#!env perl
#
# This program transpiles BNF as per http://cui.unige.ch/db-research/Enseignement/analyseinfo/AboutBNF.html to Marpa BNF
#
use strict;
use diagnostics;
use warnings FATAL => 'all';

our $LEXEME_RANGES       = 0;
our $LEXEME_CARET_RANGES = 1;
our $LEXEME_STRING       = 2;
our $LEXEME_HEX          = 3;

###########################################################################
# package Actions                                                         #
###########################################################################

package Actions;
use POSIX qw/EXIT_SUCCESS EXIT_FAILURE/;
sub new() {
  my $self = {
              rules => [],
              lexemes => {},
              lexemesExact => {},
	      symbols => {},
              start => {number => undef, rule => ''},
	      grammar => '',
             };
  return bless $self, shift;
}

sub _pushLexemes {
  my ($self, $rcp, $key) = @_;

  foreach (sort {$a cmp $b} keys %{$self->{$key}}) {
    if ($self->{$key}->{$_} eq '\'') {
      $self->{$key}->{$_} = '[\']';
    }
    my $content;
    if ($self->{$key}->{$_} =~ /^\[.+/) {
      $content = join(' ', "<$_>", '~', $self->{$key}->{$_});
    } elsif ($self->{$key}->{$_} =~ /^\\x\{/) {
      my $thisContent = $self->{$key}->{$_};
      my $lastCharacter = substr($thisContent, -1, 1);
      if ($lastCharacter eq '+' || $lastCharacter eq '*') {
        substr($thisContent, -1, 1, '');
        $content = join(' ', "<$_>", '~', '[' . $thisContent . "]$lastCharacter");
      } else {
        $content = join(' ', "<$_>", '~', '[' . $thisContent . ']');
      }
    } else {
      #
      # IF the string has a length > 1 that it is SUPPOSED TO BE A WORD, i.e.
      # HAVING WORD BOUNDARIES.
      # WE LET LATM handling this by saying that the lexeme is not really a
      # lexeme but another G1, and associate an action that will concatenate
      # all individual characters -;
      #
      if (length($self->{$key}->{$_}) > 1) {
	my @rhs = map {"'$_':i"} (split(//, $self->{$key}->{$_}));
	$content = join(' ', "<$_>", '::=', @rhs, 'action', '=>', 'fakedLexeme', '# Faked lexeme - LATM handling the ambiguities');
      } else {
	my $rhs = join(' ', '\'' . $self->{$key}->{$_} . '\'');
	$content = join(' ', "<$_>", '~', $rhs);
      }
    }
    push(@{$rcp}, $content);
    $self->{symbols}->{$_} = {terminal => 1, content => $content};
  }
}

sub _pushG1 {
    my ($self, $rcp) = @_;

    #
    # SQL grammar is highly ambiguous, and it is assumed that every rule sharing the same LHS have a rank that
    # is progressively decreasing
    #

    my %rank = ();
    my $previous = '';
    foreach (@{$self->{rules}}) {
      if (! (defined($_->{rhs}))) {
        print STDERR "[WARN] Internal error: undefined RHS list for symbol $_->{lhs}\n";
        exit(EXIT_FAILURE);
      }
      my $lhs = $_->{lhs} eq ':start' ? ':start' : "<$_->{lhs}>";
      my $content;
      if (@{$_->{rhs}}) {
	my $rhs = '<' . join('> <', @{$_->{rhs}}) . '>' . $_->{quantifier};
	if ($previous ne $lhs) {
	  $content = join(' ', $lhs, $_->{rulesep}, $rhs);
	} else {
	  $content = (' ' x length("$lhs  ")) . ' | ' . $rhs;
	}
      } else {
	$content = join(' ', $lhs, $_->{rulesep});
      }
      $rank{$lhs} //= 0;
      if ($lhs ne ':start') {
	$content .= " rank => " . $rank{$lhs}--;
      }
      push(@{$rcp}, $content);
      $self->{symbols}->{$_->{lhs}} = {terminal => 0, content => $content};
      $previous = $lhs;
    }

}

sub _rules {
  my ($self, @rules) = @_;

  my @rc = ();
  push(@rc, 'inaccessible is ok by default');
#   push(@rc, ':default ::= action => [values] bless => ::lhs');
  push(@rc, ':default ::= action => nonTerminalSemantic');
  push(@rc, 'lexeme default = action => [value] latm => 1');
  if (defined($self->{start}->{number})) {
      push(@rc, ':start ::= ' . $self->{start}->{rule});
  }
  push(@rc, '');
  $self->_pushG1(\@rc);
  $self->_pushLexemes(\@rc, 'lexemes');

  push(@rc, <<DISCARD

_WS ~ [\\s]+
:discard ~ _WS

_COMMENT_EVERYYHERE_START ~ '--'
_COMMENT_EVERYYHERE_END ~ [^\\n]*
_COMMENT ~ _COMMENT_EVERYYHERE_START _COMMENT_EVERYYHERE_END
:discard ~ _COMMENT

############################################################################
# Discard of a C comment, c.f. https://gist.github.com/jeffreykegler/5015057
############################################################################
<C style comment> ~ '/*' <comment interior> '*/'
<comment interior> ~
    <optional non stars>
    <optional star prefixed segments>
    <optional pre final stars>
<optional non stars> ~ [^*]*
<optional star prefixed segments> ~ <star prefixed segment>*
<star prefixed segment> ~ <stars> [^/*] <optional star free text>
<stars> ~ [*]+
<optional star free text> ~ [^*]*
<optional pre final stars> ~ [*]*
:discard ~ <C style comment>
DISCARD
      );
  $self->{grammar} = join("\n", @rc) . "\n";

  return $self;
}

sub _symbol {
  my ($self, $symbol) = @_;

  #
  # Remove any non-alnum character
  #
  our %UNALTERABLED_SYMBOLS = (':start' => 1, ':discard' => 1);
  $symbol =~ s/^<//;
  $symbol =~ s/>$//;
  if (! exists($UNALTERABLED_SYMBOLS{$symbol})) {
    $symbol =~ s/[^[:alnum:]]/ /g;
    #
    # Break symbol in words, ucfirst() on all
    #
    pos($symbol) = undef;
    my @words = ();
    while ($symbol =~ m/(\w+)/sxmg) {
      my $match = substr($symbol, $-[1], $+[1] - $-[1]);
      push(@words, ($match eq 'SQL' ? $match : ucfirst(lc($match))));
    }
    $symbol = join(' ', @words);
  }

  return $symbol;
}

sub _rule {
  my ($self, $symbol, $rulesep, $expressions, $quantifier, $symbolp) = @_;

  #
  # $expressions is [@concatenation]
  # Every $concatenation is [$exceptions]
  # $exceptions is [@exception]
  # Every exception is a symbol

  #
  # Ignore rulesep "~"
  #
  $rulesep = '::=';

  foreach (@{$expressions}) {
    my $concatenation = $_;
    my ($exceptions) = @{$concatenation};
    push(@{$self->{rules}}, {lhs => $symbol, rhs => $exceptions, rulesep => $rulesep, quantifier => $quantifier || ''});
  }

  return $self;
}

sub _char {
  my ($self, $char) = @_;
  #
  # A char is either and _HEX or a _CHAR_RANGE
  #
  my $rc = undef;
  if ($char =~ /^\#x(.*)/) {
    $rc = chr(hex($1));
  } else {
    $rc = $char;
  }
}

sub _chprint {
  my ($chr) = @_;
  if ($chr =~ /[\s]/ || (! ($chr =~ /[[:ascii:]]/) || ($chr =~ /[[:cntrl:]]/))) {
    $chr = sprintf('\\x{%x}', ord($chr));
  }
  return $chr;
}

sub _factorCaretRange {
  my ($self, $lbracket, $caret, $ranges, $rbracket) = @_;
  my ($printRanges, $exactRangesp) = @{$ranges};
  return $self->_factor("[^$printRanges]", $LEXEME_CARET_RANGES, $exactRangesp);
}

sub _factorRange {
  my ($self, $lbracket, $ranges, $rbracket) = @_;
  my ($printRanges, $exactRangesp) = @{$ranges};
  return $self->_factor("[$printRanges]", $LEXEME_RANGES, $exactRangesp);
}

sub _factorMetachar {
  my ($self, $metachar) = @_;
  return $self->_factor("[$metachar]", $LEXEME_RANGES, [ $metachar ]);
}

sub _ranges {
  my ($self, @ranges) = @_;
  my $printRanges = '';
  my @exactRanges = ();
  foreach (@ranges) {
    my ($range, $exactRange) = @{$_};
    my ($range1, $range2) = @{$exactRange};
    if ($range1 ne $range2) {
      $printRanges .= quotemeta($range1) . '-' . quotemeta($range2);
    } else {
      $printRanges .= quotemeta($range1);
    }
    push(@exactRanges, $exactRange);
  }
  return [$printRanges, [ @exactRanges ]];
}

sub _printable {
  my ($self, $chr, $forceHexa) = @_;
  if ($forceHexa || $chr =~ /[\s]/ || (! ($chr =~ /[[:ascii:]]/) || ($chr =~ /[[:cntrl:]]/))) {
    $chr = sprintf('\\x{%x}', ord($chr));
  }
  return $chr;
}

sub _range {
  my ($self, $char1, $char2) = @_;
  my $range;
  if (substr($char1, 0, 1) eq '\\') { substr($char1, 0, 1, ''); }
  if (defined($char2) && substr($char2, 0, 1) eq '\\') { substr($char2, 0, 1, ''); }
  my $exactRange = [$char1, defined($char2) ? $char2 : $char1];
  $char1 = $self->_printable($char1);
  if (defined($char2)) {
    $char2 = $self->_printable($char2);
    $range = "$char1-$char2";
  } else {
    $range = $char1;
  }
  return [$range, $exactRange];
}

sub _range1 {
  my ($self, $char) = @_;
  return $self->_range($self->_char($char));
}

sub _range2 {
  my ($self, $char1, $minus, $char2) = @_;
  return $self->_range($self->_char($char1), $self->_char($char2));
}

sub _factorExpressions {
  my ($self, $lparen, $expressions, $rparen) = @_;

  my $symbol = sprintf('Gen%03d', 1 + (scalar @{$self->{rules}}));
  $self->_rule($symbol, '::=', $expressions);
  return $symbol;
}

sub _factor {
  my ($self, $printableValue, $type, $valueDetail, $quantifier, $name) = @_;

  if (! $name) {
      my @name = grep {$self->{lexemes}->{$_} eq $printableValue} keys %{$self->{lexemes}};
      if (! @name) {
	  $name = sprintf('Lex%03d', 1 + (keys %{$self->{lexemes}}));
      } else {
	  $name = $name[0];
      }
  }

  if (! exists($self->{lexemesExact}->{$name})) {
    $quantifier ||= '';
      $self->{lexemesExact}->{$name} = {type => $type, value => $valueDetail, usage => 1, quantifier => $quantifier};
      $self->{lexemes}->{$name} = $printableValue;
  } else {
      $self->{lexemesExact}->{$name}->{usage}++;
  }

  return $name;
}

sub _factorStringDquote {
  my ($self, $dquote1, $stringDquote, $dquote2) = @_;
  #
  # _STRING_DQUOTE_UNIT    ~ [^"] | '\"'
  #
  return $self->_factor($stringDquote, $LEXEME_STRING, $stringDquote);
}

sub _factorString {
  my ($self, $string) = @_;
  return $self->_factor($string, $LEXEME_STRING, $string);
}

sub _factorStringSquote {
  my ($self, $squote1, $stringSquote, $squote2) = @_;
  #
  # _STRING_SQUOTE_UNIT    ~ [^'] | '\' [']
  #
  return $self->_factor($stringSquote, $LEXEME_STRING, $stringSquote);
}

sub _hex {
  my ($self, $hex) = @_;
  return $self->_factor($self->_printable($self->_char($hex), 1), $LEXEME_HEX, do {$hex =~ s/^#x//; chr(hex($hex));});
}

sub _termFactorQuantifier {
  my ($self, $factor, $quantifier, $forcedSymbol, $optimizationMode) = @_;

  my $symbol;
  if ($quantifier eq '*' || $quantifier eq '+') {
      $symbol = $forcedSymbol || sprintf('%s %s', $factor, ($quantifier eq '*') ? 'any' : 'many');
      if (! exists($self->{quantifiedSymbols}->{$symbol})) {
	  $self->{quantifiedSymbols}->{$symbol}++;
	  if (exists($self->{lexemesExact}->{$factor}) &&
	      #
	      # Lexeme optimization is limited to ranges type: [...] or [^...] or #x's
	      #
	      ($self->{lexemesExact}->{$factor}->{type} == $LEXEME_RANGES       ||
               $self->{lexemesExact}->{$factor}->{type} == $LEXEME_CARET_RANGES ||
               $self->{lexemesExact}->{$factor}->{type} == $LEXEME_HEX
              )) {
	      if (! exists($self->{lexemesExact}->{"$factor$quantifier"})) {
                  #
                  # Okay, let's take care of one thing: Marpa does not like lexemes with a zero length.
                  # Therefore, if the quantifier is '*', we create a lexeme as if it was '+' and
                  # replace current factor by a nullable symbol
                  #
                  my $thisQuantifier = $quantifier;
                  my $thisSymbol = $symbol;
		  my $thisContent = "$self->{lexemes}->{$factor}$thisQuantifier";
                  if ($quantifier eq '*') {
                    $thisQuantifier = '+';
                    $thisSymbol = sprintf('%s %s', $factor, 'many');
                  }
                  print STDERR "[INFO] Transformation to a lexeme: $thisSymbol ::= $factor$thisQuantifier\n";
                  $self->_factor($thisContent, $self->{lexemesExact}->{$factor}->{type}, $self->{lexemesExact}->{$factor}->{value}, $thisQuantifier, $thisSymbol);
		  if ($optimizationMode) {
		      #
		      # We are not in the lexer phase but in the optimization mode
		      #
		      $self->{symbols}->{$thisSymbol} = {terminal => 1, content => $thisContent};
		  }
                  if ($quantifier eq '*') {
                    my $newSymbol = $forcedSymbol || sprintf('Gen%03d', 1 + (scalar @{$self->{rules}}));
                    print STDERR "[INFO] Using a nullable symbol for: $symbol ::= $factor$quantifier, i.e. $newSymbol ::= $thisSymbol; $newSymbol ::= ;\n";
                    $self->_rule($newSymbol, '::=', [ [ [ $thisSymbol ] , {} ] ]);
                    $self->_rule($newSymbol, '::=', [ [ [] , {} ] ]);
                    #
                    # For the return
                    #
		    my $content = "$thisSymbol || ;";
                    $symbol = $newSymbol;
		    if ($optimizationMode) {
			#
			# We are not in the lexer phase but in the optimization mode
			#
			$self->{symbols}->{$symbol} = {terminal => 0, content => $content};
		    }
                  }
		  if (--$self->{lexemesExact}->{$factor}->{usage} == 0) {
		      delete($self->{lexemes}->{$factor});
		  }
	      }
	  } else {
	      $self->_rule($symbol, '::=', [ [ [ $factor ] , {} ] ], $quantifier);
	  }
      }
  } elsif ($quantifier eq '?') {
      $symbol = sprintf('%s maybe', $factor);
      if (! exists($self->{quantifiedSymbols}->{$symbol})) {
	  $self->{quantifiedSymbols}->{$symbol}++;
	  $self->_rule($symbol, '::=', [ [ [ "$factor" ] , {} ] ]);
	  $self->_rule($symbol, '::=', [ [ [] , {} ] ]);
      }
  } else {
      die "Unsupported quantifier '$quantifier'";
  }


  return $symbol;
}

###########################################################################
# package main                                                            #
###########################################################################

package main;
use Marpa::R2;
use Getopt::Long;
use File::Slurp;
use File::Spec;
use File::Basename qw/basename/;
use POSIX qw/EXIT_SUCCESS EXIT_FAILURE/;

our $DATA = do { local $/; <DATA>; };

my $output = '';
my $trace = 0;
GetOptions('output=s' => \$output,
	   'trace!' => \$trace,
	  )
  or die("Error in command line arguments\n");

if (! @ARGV) {
  print STDERR "Usage: $^X $0 [--output outputfilename.bnf] grammar.bnf\n";
  exit(EXIT_FAILURE);
}
my $bnf = shift(@ARGV);

if ($output) {
    open(STDOUT, '>', $output) || die "Cannot redirect STDOUT to $output";
}

my $grammar = Marpa::R2::Scanless::G->new( { source => \$DATA, action_object => 'Actions', bless_package => 'BNF'});
my $recce = Marpa::R2::Scanless::R->new( {grammar => $grammar, trace_terminals => $trace });

open(BNF, '<', $bnf) || die "Cannot open $bnf, $!";
my $BNF = do {local $/; <BNF>};
close(BNF) || warn "Cannot close $bnf, $!";

eval {$recce->read(\$BNF)} || do {print STDERR "$@\n" . $recce->show_progress(); exit(EXIT_FAILURE)};
my $nbvalue = 0;
my $value = undef;
my $value2 = undef;
while (defined($_ = $recce->value)) {
  ++$nbvalue;
  if ($nbvalue >= 2) {
      $value2 = ${$_};
      last;
  }
  $value = ${$_};
}
if ($nbvalue <= 0) {
  print STDERR "No value\n";
  print STDERR $recce->show_progress();
  exit(EXIT_FAILURE);
}
elsif ($nbvalue != 1) {
  my $tmp1 = "C:\\Windows\\Temp\\jdd1.txt";
  my $tmp2 = "C:\\Windows\\Temp\\jdd2.txt";
  use Data::Dumper;
  open(TMP1, '>', $tmp1); print TMP1 Dumper($value); close (TMP1);
  open(TMP2, '>', $tmp2); print TMP2 Dumper($value2); close (TMP2);
  print STDERR "==> diff $tmp1 $tmp2\n";
  die "More than one parse tree value";
}

my $generatedGrammar = $value->{grammar};
print $generatedGrammar;
{
  print STDERR "Done. Testing generated grammar.\n";
  eval {Marpa::R2::Scanless::G->new( { source => \$generatedGrammar } )} || die "$@";
}

exit(EXIT_SUCCESS);

__DATA__
:start ::= rules
:default ::= action => ::first
lexeme default = latm => 1

symbol         ::= SYMBOL                                               action => _symbol
rules          ::= rule+                                                action => _rules
rule           ::= symbol RULESEP expressions                           action => _rule
expressions    ::= concatenation+ separator => PIPE                     action => [values]
concatenation  ::= exceptions                                           action => [values]
exceptions     ::= exception+                                           action => [values]
exception      ::= term
term           ::= factor
               |   factor QUANTIFIER                                    action => _termFactorQuantifier
hex            ::= HEX                                                  action => _hex
factor         ::= hex
               |   LBRACKET       ranges RBRACKET                       action => _factorRange
               |   LBRACKET CARET ranges RBRACKET                       action => _factorCaretRange
               |   DQUOTE STRINGDQUOTE DQUOTE                           action => _factorStringDquote
               |   SQUOTE STRINGSQUOTE SQUOTE                           action => _factorStringSquote
               |   STRING                                               action => _factorString
               |   METACHAR                                             action => _factorMetachar
               |   LPAREN expressions RPAREN                            action => _factorExpressions
               |   symbol
ranges         ::= range+                                               action => _ranges
range          ::= CHAR                                                 action => _range1
               |   CHAR MINUS CHAR                                      action => _range2
RULESEP       ~ '::=' |'~'
PIPE          ~ '|'
MINUS         ~ '-'
QUANTIFIER    ~ '*' | '+' | '?'
HEX           ~ _HEX
CHAR          ~ _CHAR
LBRACKET      ~ '['
RBRACKET      ~ ']'
LPAREN        ~ '('
RPAREN        ~ ')'
CARET         ~ '^'
DQUOTE        ~ '"'
SQUOTE        ~ [']
STRINGDQUOTE  ~ _STRING_DQUOTE_UNIT*
STRINGSQUOTE  ~ _STRING_SQUOTE_UNIT*
SYMBOL        ~ _SYMBOL_START _SYMBOL_INTERIOR _SYMBOL_END
STRING        ~ [[:alnum:]_-]+

_STRING_DQUOTE_UNIT    ~ [^"] | '\"'
_STRING_SQUOTE_UNIT    ~ [^'] | '\' [']
_HEX                   ~ __HEX_START __HEX_END
_CHAR_RANGE            ~ [^\r\n\t\v\f\]\[\-\^\\\(\)\|]
                       | '\\'
                       | '\['
                       | '\]'
                       | '\('
                       | '\)'
                       | '\-'
                       | '\|'
                       | '\^'
_SYMBOL_START          ~ '<'
_SYMBOL_END            ~ '>'
_SYMBOL_INTERIOR       ~ [^>]+

__HEX_START          ~ '#x'
__HEX_END            ~ [0-9A-Fa-f]+

__METACHAR_START     ~ '\'
__METACHAR_END       ~ [\w]+
__METACHAR           ~ __METACHAR_START __METACHAR_END

_CHAR                ~ _HEX | _CHAR_RANGE

METACHAR             ~ __METACHAR

############################################################################
# Discard of a C comment, c.f. https://gist.github.com/jeffreykegler/5015057
############################################################################
<C style comment> ~ '/*' <comment interior> '*/'
<comment interior> ~
    <optional non stars>
    <optional star prefixed segments>
    <optional pre final stars>
<optional non stars> ~ [^*]*
<optional star prefixed segments> ~ <star prefixed segment>*
<star prefixed segment> ~ <stars> [^/*] <optional star free text>
<stars> ~ [*]+
<optional star free text> ~ [^*]*
<optional pre final stars> ~ [*]*
:discard ~ <C style comment>

#################
# Generic discard
#################
__SPACE_ANY ~ [\s]+
:discard ~ __SPACE_ANY
