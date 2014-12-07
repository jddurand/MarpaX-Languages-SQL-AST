use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::SQL::AST;

# ABSTRACT: Translate a SQL source to an AST

use Log::Any qw/$log/;
use Carp qw/croak/;
use MarpaX::Languages::SQL::AST::Util qw/:all/;
use MarpaX::Languages::SQL::AST::Grammar qw//;
use MarpaX::Languages::SQL::AST::Impl qw//;

# VERSION

=head1 DESCRIPTION

This module translates SQL source into an XML::LibXML AST. Be aware that this module is a Log::Any thingy.

=head1 SYNOPSIS

    use strict;
    use warnings FATAL => 'all';
    use MarpaX::Languages::SQL::AST;
    use Log::Log4perl qw/:easy/;
    use Log::Any::Adapter;
    use Log::Any qw/$log/;
    use Data::Dumper;
    #
    # Init log
    #
    our $defaultLog4perlConf = '
    log4perl.rootLogger              = WARN, Screen
    log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.stderr  = 0
    log4perl.appender.Screen.layout  = PatternLayout
    log4perl.appender.Screen.layout.ConversionPattern = %d %-5p %6P %m{chomp}%n
    ';
    Log::Log4perl::init(\$defaultLog4perlConf);
    Log::Any::Adapter->set('Log4perl');
    #
    # Parse SQL
    #
    my $sqlSourceCode = 'select * from myTable;';
    my $sqlAstObject = MarpaX::Languages::SQL::AST->new();
    log->infof('%s', $sqlAstObject->parse(\$sqlSourceCode)->value()->toString(1));

=head1 SUBROUTINES/METHODS

=head2 new($class, %options)

Instantiate a new object. Takes as parameter an optional hash of options that can be:

=over

=item grammarName

Name of a grammar. Default is 'ISO-IEC-9075-2-2003'.

=back

=cut

# ----------------------------------------------------------------------------------------
sub new {
  my ($class, %opts) = @_;

  my $grammarName = $opts{grammarName} || 'ISO-IEC-9075-2-2003';

  my $grammar = MarpaX::Languages::SQL::AST::Grammar->new($grammarName);
  my $grammar_option = $grammar->grammar_option();
  $grammar_option->{bless_package} = 'SQL::AST';
  $grammar_option->{source} = \$grammar->content();
  my $recce_option = $grammar->recce_option();

  my $self  = {
               _grammar            => $grammar,
               _impl               => MarpaX::Languages::SQL::AST::Impl->new($grammar_option, $recce_option),
               _sourcep            => undef,
              };

  bless($self, $class);

  return $self;
}

# ----------------------------------------------------------------------------------------

sub _context {
    my $self = shift;

    my $context = $log->is_debug() ?
	sprintf("\n\nContext:\n\n%s", $self->{_impl}->show_progress()) :
	'';

    return $context;
}
# ----------------------------------------------------------------------------------------

=head2 parse($self, $sourcep)

Do the parsing. Takes as parameter the reference to a SQL source code. Returns $self, so that chaining with value method will be natural, i.e. parse()->value().

=cut

sub parse {
  my ($self, $sourcep) = @_;

  $self->{_sourcep} = $sourcep;

  my $max = length(${$sourcep});
  my $pos = $[;
  eval {$pos = $self->{_impl}->read($sourcep, $pos)};
  if ($@) {
      my $line_columnp = lineAndCol($self->{_impl});
      logCroak("%s\nLast position:\n\n%s%s\nTerminals expected:\n%s", "$@", showLineAndCol(@{$line_columnp}, $self->{_sourcep}), $self->_context(),  join(', ', @{$self->{_impl}->terminals_expected()}));
  }
  do {
    my %lexeme = ();
    $self->_getLexeme(\%lexeme);
    $self->_doEvents();
    $pos += $self->_doPauseBeforeLexeme(\%lexeme);
    eval {$pos = $self->{_impl}->resume()};
    if ($@) {
	my $line_columnp = lineAndCol($self->{_impl});
	logCroak("%s\nLast position:\n\n%s%s", "$@", showLineAndCol(@{$line_columnp}, $self->{_sourcep}), , $self->_context());
    }
  } while ($pos < $max);

  return $self;
}

# ----------------------------------------------------------------------------------------
sub _show_last_expression {
  my ($self) = @_;

  my ($start, $end) = $self->{_impl}->last_completed_range('SQL Start');
  return 'No expression was successfully parsed' if (! defined($start));
  my $lastExpression = $self->{_impl}->range_to_string($start, $end);
  return "Last expression successfully parsed was: $lastExpression";
}
# ----------------------------------------------------------------------------------------

=head2 value($self, $optionalArrayOfValuesb)

Return the blessed value. Takes as optional parameter a flag saying if the return value should be an array of all values or not. If this flag is false, the module will croak if there more than one parse tree value. If this flag is true, a reference to an array of values will be returned, even if there is a single parse tree value.

=cut

sub value {
  my ($self, $arrayOfValuesb) = @_;

  $arrayOfValuesb ||= 0;

  my @rc = ();
  my $nvalue = 0;
  my $valuep = $self->{_impl}->value() || logCroak('%s', $self->_show_last_expression());
  if (defined($valuep)) {
    push(@rc, $valuep);
  }
  my $value2p = undef;
  do {
    $value2p = $self->{_impl}->value();
    if (defined($value2p)) {
      if (! $arrayOfValuesb) {
	$value2p = undef;
      } else {
	push(@rc, $value2p);
      }
    }
  } while (defined($value2p));
  if ($#rc != 0 && ! $arrayOfValuesb) {
    logCroak('Number of parse tree values should be 1 instead of %d.', scalar(@rc));
  }
  if ($arrayOfValuesb) {
    return [ @rc ];
  } else {
    return $rc[0];
  }
}
# ----------------------------------------------------------------------------------------
sub _doEvents {
  my $self = shift;

  my %events = ();
  my $iEvent = 0;
  while (defined($_ = $self->{_impl}->event($iEvent++))) {
    ++$events{$_->[0]};
  }

  if (%events) {
    my @events = keys %events;
    if ($log->is_debug) {
	$log->debugf('[%s] Events: %s', whoami(__PACKAGE__), \@events);
    }
  }
}
# ----------------------------------------------------------------------------------------
sub _getLexeme {
  my ($self, $lexemeHashp) = @_;

  #
  # Get paused lexeme
  # Trustable if pause after
  # See _doPauseBeforeLexeme for the others
  #
  my $lexeme = $self->{_impl}->pause_lexeme();
  if (defined($lexeme)) {
    $lexemeHashp->{name} = $lexeme;
    ($lexemeHashp->{start}, $lexemeHashp->{length}) = $self->{_impl}->pause_span();
    ($lexemeHashp->{line}, $lexemeHashp->{column}) = $self->{_impl}->line_column($lexemeHashp->{start});
    $lexemeHashp->{value} = $self->{_impl}->literal($lexemeHashp->{start}, $lexemeHashp->{length});
  }
}
# ----------------------------------------------------------------------------------------
sub _doPauseBeforeLexeme {
  my ($self, $lexemeHashp) = @_;

  my $delta = 0;

  return $delta;
}

=head1 SEE ALSO

L<Log::Any>, L<Marpa::R2>, L<XML::LibXML>

=cut

1;
