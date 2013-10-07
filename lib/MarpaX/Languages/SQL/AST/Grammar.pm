use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::SQL::AST::Grammar;

# ABSTRACT: SQL grammar written in Marpa BNF

use MarpaX::Languages::SQL::AST::Grammar::ISO_IEC_9075_2_2003;
use Carp qw/croak/;

# VERSION

=head1 DESCRIPTION

This modules returns SQL grammar(s) written in Marpa BNF.
Current grammars are:
=over
=item *
ISO-IEC-9075-2-2003. The ISO grammar of SQL 2003, as of L<http://savage.net.au/SQL/>.
=back

=head1 SYNOPSIS

    use MarpaX::Languages::SQL::AST::Grammar;

    my $grammar = MarpaX::Languages::SQL::AST::Grammar->new('ISO-IEC-9075-2-2003');
    my $grammar_content = $grammar->content();
    my $grammar_option = $grammar->grammar_option();
    my $recce_option = $grammar->recce_option();

=head1 SUBROUTINES/METHODS

=head2 new($class, $grammarName)

Instance a new object. Takes the name of the grammar as argument. Remaining arguments are passed to the sub grammar method. Supported grammars are:

=over

=item ISO-IEC-9075-2-2003

SQL 2003

=back

=cut

sub new {
  my $class = shift;
  my $grammarName = shift;

  my $self = {};
  if (! defined($grammarName)) {
    croak 'Usage: new($grammar_Name)';
  } elsif ($grammarName eq 'ISO-IEC-9075-2-2003') {
    $self->{_grammar} = MarpaX::Languages::SQL::AST::Grammar::ISO_IEC_9075_2_2003->new(@_);
  } else {
    croak "Unsupported grammar name $grammarName";
  }
  bless($self, $class);

  return $self;
}

=head2 content($self)

Returns the content of the grammar.

=cut

sub content {
    my ($self) = @_;
    return $self->{_grammar}->content(@_);
}

=head2 grammar_option($self)

Returns recommended option for Marpa::R2::Scanless::G->new(), returned as a reference to a hash.

=cut

sub grammar_option {
    my ($self) = @_;
    return $self->{_grammar}->grammar_option(@_);
}

=head2 recce_option($self)

Returns recommended option for Marpa::R2::Scanless::R->new(), returned as a reference to a hash.

=cut

sub recce_option {
    my ($self) = @_;
    return $self->{_grammar}->recce_option(@_);
}

=head1 SEE ALSO

L<Marpa::R2>, L<MarpaX::Languages::SQL::AST::Grammar::ISO_IEC_9075_2_2003>

=cut

1;
