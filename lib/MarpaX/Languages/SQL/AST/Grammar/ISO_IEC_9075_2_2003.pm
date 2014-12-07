use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::SQL::AST::Grammar::ISO_IEC_9075_2_2003;
use MarpaX::Languages::SQL::AST::Grammar::ISO_IEC_9075_2_2003::Actions;
use Carp qw/croak/;

# ABSTRACT: SQL 2003 grammar written in Marpa BNF

# VERSION

=head1 DESCRIPTION

This modules returns describes the SQL 2003 grammar written in Marpa BNF, as of L<http://savage.net.au/SQL/>.

=head1 SYNOPSIS

    use strict;
    use warnings FATAL => 'all';
    use MarpaX::Languages::SQL::AST::Grammar::ISO_IEC_9075_2_2003;

    my $grammar = MarpaX::Languages::SQL::AST::Grammar::ISO_IEC_9075_2_2003->new();

    my $grammar_content = $grammar->content();
    my $grammar_option = $grammar->grammar_option();
    my $recce_option = $grammar->recce_option();

=head1 SUBROUTINES/METHODS

=head2 new([$pausep])

Instance a new object. Takes a reference to a HASH for lexemes for which a pause after is requested.

=cut

our %DEFAULT_PAUSE = (
);

sub new {
  my ($class, $pausep) = @_;

  my $self  = {
    _grammar_option => {action_object  => sprintf('%s::%s', __PACKAGE__, 'Actions')},
    _recce_option => {ranking_method => 'high_rule_only'},
  };
  #
  # Rework the grammar to have the pauses:
  # Those in %DEFAULT_PAUSE cannot be altered.
  # The other lexemes given in argument will get a pause => after eventually
  #
  my %pause = ();
  if (defined($pausep)) {
      if (ref($pausep) ne 'HASH') {
	  croak 'pausep must be a reference to HASH';
      }
      map {$pause{$_} = 'after'} keys %{$pausep};
  }
  map {$pause{$_} = $DEFAULT_PAUSE{$_}} keys %DEFAULT_PAUSE;

  $self->{_content} = '';
  my $allb = exists($pause{__ALL__});
  while (defined($_ = <DATA>)) {
      my $line = $_;
      if ($line =~ /^\s*:lexeme\s*~\s*<(\w+)>/) {
	  my $lexeme = substr($line, $-[1], $+[1] - $-[1]);
          #
          # Doing this test first will make sure DEFAULT_PAUSE lexemes
          # will always get the correct 'pause' value (i.e. after or before)
          #
	  if (exists($pause{$lexeme})) {
            if (! ($line =~ /\bpause\b/)) {
	      substr($line, -1, 1) = " pause => $pause{$lexeme}\n";
            }
	  } elsif ($allb) {
            if (! ($line =~ /\bpause\b/)) {
              #
              # Hardcoded to 'after'
              #
	      substr($line, -1, 1) = " pause => after\n";
            }
          }
      }
      $self->{_content} .= $line;
  }

  bless($self, $class);

  return $self;
}

=head2 content()

Returns the content of the grammar. Takes no argument.

=cut

sub content {
    my ($self) = @_;
    return $self->{_content};
}

=head2 grammar_option()

Returns recommended option for Marpa::R2::Scanless::G->new(), returned as a reference to a hash.

=cut

sub grammar_option {
    my ($self) = @_;
    return $self->{_grammar_option};
}

=head2 recce_option()

Returns recommended option for Marpa::R2::Scanless::R->new(), returned as a reference to a hash.

=cut

sub recce_option {
    my ($self) = @_;
    return $self->{_recce_option};
}

1;
__DATA__
inaccessible is ok by default
:default ::= action => nonTerminalSemantic
lexeme default = action => [value] latm => 1

:start ::= <SQL Start Sequence>
<SQL Start many> ::= <SQL Start>+ rank => 0
<SQL Start Sequence> ::= <SQL Start many> rank => 0
<SQL Start> ::= <Preparable Statement> rank => 0
              | <Direct SQL Statement> rank => -1
              | <Embedded SQL Declare Section> rank => -2
              | <Embedded SQL Host Program> rank => -3
              | <Embedded SQL Statement> rank => -4
              | <SQL Client Module Definition> rank => -5
<SQL Terminal Character> ::= <SQL Language Character> rank => 0
<SQL Language Character> ::= <Simple Latin Letter> rank => 0
                           | <Digit> rank => -1
                           | <SQL Special Character> rank => -2
<Simple Latin Letter> ::= <Simple Latin Upper Case Letter> rank => 0
                        | <Simple Latin Lower Case Letter> rank => -1
<Simple Latin Upper Case Letter> ::= <Lex001> rank => 0
<Simple Latin Lower Case Letter> ::= <Lex002> rank => 0
<Digit> ::= <Lex003> rank => 0
<SQL Special Character> ::= <Space> rank => 0
                          | <Double Quote> rank => -1
                          | <Percent> rank => -2
                          | <Ampersand> rank => -3
                          | <Quote> rank => -4
                          | <Left Paren> rank => -5
                          | <Right Paren> rank => -6
                          | <Asterisk> rank => -7
                          | <Plus Sign> rank => -8
                          | <Comma> rank => -9
                          | <Minus Sign> rank => -10
                          | <Period> rank => -11
                          | <Solidus> rank => -12
                          | <Colon> rank => -13
                          | <Semicolon> rank => -14
                          | <Less Than Operator> rank => -15
                          | <Equals Operator> rank => -16
                          | <Greater Than Operator> rank => -17
                          | <Question Mark> rank => -18
                          | <Left Bracket> rank => -19
                          | <Right Bracket> rank => -20
                          | <Circumflex> rank => -21
                          | <Underscore> rank => -22
                          | <Vertical Bar> rank => -23
                          | <Left Brace> rank => -24
                          | <Right Brace> rank => -25
<Space> ::= <Lex004> rank => 0
<Double Quote> ::= <Lex005> rank => 0
<Percent> ::= <Lex006> rank => 0
<Ampersand> ::= <Lex007> rank => 0
<Quote> ::= <Lex008> rank => 0
<Left Paren> ::= <Lex009> rank => 0
<Right Paren> ::= <Lex010> rank => 0
<Asterisk> ::= <Lex011> rank => 0
<Plus Sign> ::= <Lex012> rank => 0
<Comma> ::= <Lex013> rank => 0
<Minus Sign> ::= <Lex014> rank => 0
<Period> ::= <Lex015> rank => 0
<Solidus> ::= <Lex016> rank => 0
<Colon> ::= <Lex017> rank => 0
<Semicolon> ::= <Lex018> rank => 0
<Less Than Operator> ::= <Lex019> rank => 0
<Equals Operator> ::= <Lex020> rank => 0
<Greater Than Operator> ::= <Lex021> rank => 0
<Question Mark> ::= <Lex022> rank => 0
<Left Bracket Or Trigraph> ::= <Left Bracket> rank => 0
                             | <Left Bracket Trigraph> rank => -1
<Right Bracket Or Trigraph> ::= <Right Bracket> rank => 0
                              | <Right Bracket Trigraph> rank => -1
<Left Bracket> ::= <Lex023> rank => 0
<Left Bracket Trigraph> ::= <Lex024> rank => 0
<Right Bracket> ::= <Lex025> rank => 0
<Right Bracket Trigraph> ::= <Lex026> rank => 0
<Circumflex> ::= <Lex027> rank => 0
<Underscore> ::= <Lex028> rank => 0
<Vertical Bar> ::= <Lex029> rank => 0
<Left Brace> ::= <Lex030> rank => 0
<Right Brace> ::= <Lex031> rank => 0
<Token> ::= <Nondelimiter Token> rank => 0
          | <Delimiter Token> rank => -1
<Nondelimiter Token> ::= <Regular Identifier> rank => 0
                       | <Key Word> rank => -1
                       | <Unsigned Numeric Literal> rank => -2
                       | <National Character String Literal> rank => -3
                       | <Large Object Length Token> rank => -4
                       | <Multiplier> rank => -5
<Regular Identifier> ::= <SQL Language Identifier> rank => 0
<Digit many> ::= <Digit>+ rank => 0
<Large Object Length Token> ::= <Digit many> <Multiplier> rank => 0
<Multiplier> ::= <Lex032> rank => 0
               | <Lex033> rank => -1
               | <Lex034> rank => -2
<Delimited Identifier> ::= <Double Quote> <Delimited Identifier Body> <Double Quote> rank => 0
<Delimited Identifier Part many> ::= <Delimited Identifier Part>+ rank => 0
<Delimited Identifier Body> ::= <Delimited Identifier Part many> rank => 0
<Delimited Identifier Part> ::= <Nondoublequote Character> rank => 0
                              | <Doublequote Symbol> rank => -1
<Unicode Delimited Identifier> ::= <Lex035> <Ampersand> <Double Quote> <Unicode Delimiter Body> <Double Quote> <Unicode Escape Specifier> rank => 0
<Gen097> ::= <Lex036> <Quote> <Unicode Escape Character> <Quote> rank => 0
<Gen097 maybe> ::= <Gen097> rank => 0
<Gen097 maybe> ::= rank => -1
<Unicode Escape Specifier> ::= <Gen097 maybe> rank => 0
<Unicode Identifier Part many> ::= <Unicode Identifier Part>+ rank => 0
<Unicode Delimiter Body> ::= <Unicode Identifier Part many> rank => 0
<Unicode Identifier Part> ::= <Delimited Identifier Part> rank => 0
                            | <Unicode Escape Value> rank => -1
<Unicode Escape Value> ::= <Unicode 4 Digit Escape Value> rank => 0
                         | <Unicode 6 Digit Escape Value> rank => -1
                         | <Unicode Character Escape Value> rank => -2
<Unicode 4 Digit Escape Value> ::= <Unicode Escape Character> <Hexit> <Hexit> <Hexit> <Hexit> rank => 0
<Unicode 6 Digit Escape Value> ::= <Unicode Escape Character> <Plus Sign> <Hexit> <Hexit> <Hexit> <Hexit> <Hexit> <Hexit> rank => 0
<Unicode Character Escape Value> ::= <Unicode Escape Character> <Unicode Escape Character> rank => 0
<Unicode Escape Character> ::= <Lex037> rank => 0
<Nondoublequote Character> ::= <Lex038> rank => 0
<Doublequote Symbol> ::= <Lex039> rank => 0
<Delimiter Token> ::= <Character String Literal> rank => 0
                    | <Date String> rank => -1
                    | <Time String> rank => -2
                    | <Timestamp String> rank => -3
                    | <Interval String> rank => -4
                    | <Delimited Identifier> rank => -5
                    | <Unicode Delimited Identifier> rank => -6
                    | <SQL Special Character> rank => -7
                    | <Not Equals Operator> rank => -8
                    | <Greater Than Or Equals Operator> rank => -9
                    | <Less Than Or Equals Operator> rank => -10
                    | <Concatenation Operator> rank => -11
                    | <Right Arrow> rank => -12
                    | <Left Bracket Trigraph> rank => -13
                    | <Right Bracket Trigraph> rank => -14
                    | <Double Colon> rank => -15
                    | <Double Period> rank => -16
<Not Equals Operator> ::= <Less Than Operator> <Greater Than Operator> rank => 0
<Greater Than Or Equals Operator> ::= <Greater Than Operator> <Equals Operator> rank => 0
<Less Than Or Equals Operator> ::= <Less Than Operator> <Equals Operator> rank => 0
<Concatenation Operator> ::= <Vertical Bar> <Vertical Bar> rank => 0
<Right Arrow> ::= <Minus Sign> <Greater Than Operator> rank => 0
<Double Colon> ::= <Colon> <Colon> rank => 0
<Double Period> ::= <Period> <Period> rank => 0
<Gen138> ::= <Comment> rank => 0
           | <Space> rank => -1
<Gen138 many> ::= <Gen138>+ rank => 0
<Separator> ::= <Gen138 many> rank => 0
<Comment> ::= <Simple Comment> rank => 0
            | <Bracketed Comment> rank => -1
<Comment Character any> ::= <Comment Character>* rank => 0
<Simple Comment> ::= <Simple Comment Introducer> <Comment Character any> <Newline> rank => 0
<Minus Sign any> ::= <Minus Sign>* rank => 0
<Simple Comment Introducer> ::= <Minus Sign> <Minus Sign> <Minus Sign any> rank => 0
<Bracketed Comment> ::= <Bracketed Comment Introducer> <Bracketed Comment Contents> <Bracketed Comment Terminator> rank => 0
<Bracketed Comment Introducer> ::= <Solidus> <Asterisk> rank => 0
<Bracketed Comment Terminator> ::= <Asterisk> <Solidus> rank => 0
<Gen151> ::= <Comment Character> rank => 0
           | <Separator> rank => -1
<Gen151 any> ::= <Gen151>* rank => 0
<Bracketed Comment Contents> ::= <Gen151 any> rank => 0
<Comment Character> ::= <Nonquote Character> rank => 0
                      | <Quote> rank => -1
<Newline> ::= <Lex040> rank => 0
<Key Word> ::= <Reserved Word> rank => 0
             | <Non Reserved Word> rank => -1
<Non Reserved Word> ::= <Lex041> rank => 0
                      | <Lex042> rank => -1
                      | <Lex043> rank => -2
                      | <Lex044> rank => -3
                      | <Lex045> rank => -4
                      | <Lex046> rank => -5
                      | <Lex047> rank => -6
                      | <Lex048> rank => -7
                      | <Lex049> rank => -8
                      | <Lex050> rank => -9
                      | <Lex051> rank => -10
                      | <Lex052> rank => -11
                      | <Lex053> rank => -12
                      | <Lex054> rank => -13
                      | <Lex055> rank => -14
                      | <Lex056> rank => -15
                      | <Lex057> rank => -16
                      | <Lex058> rank => -17
                      | <Lex059> rank => -18
                      | <Lex060> rank => -19
                      | <Lex061> rank => -20
                      | <Lex062> rank => -21
                      | <Lex063> rank => -22
                      | <Lex064> rank => -23
                      | <Lex065> rank => -24
                      | <Lex066> rank => -25
                      | <Lex067> rank => -26
                      | <Lex068> rank => -27
                      | <Lex069> rank => -28
                      | <Lex070> rank => -29
                      | <Lex071> rank => -30
                      | <Lex072> rank => -31
                      | <Lex073> rank => -32
                      | <Lex074> rank => -33
                      | <Lex075> rank => -34
                      | <Lex076> rank => -35
                      | <Lex077> rank => -36
                      | <Lex078> rank => -37
                      | <Lex079> rank => -38
                      | <Lex080> rank => -39
                      | <Lex081> rank => -40
                      | <Lex082> rank => -41
                      | <Lex083> rank => -42
                      | <Lex084> rank => -43
                      | <Lex085> rank => -44
                      | <Lex086> rank => -45
                      | <Lex087> rank => -46
                      | <Lex088> rank => -47
                      | <Lex089> rank => -48
                      | <Lex090> rank => -49
                      | <Lex091> rank => -50
                      | <Lex092> rank => -51
                      | <Lex093> rank => -52
                      | <Lex094> rank => -53
                      | <Lex095> rank => -54
                      | <Lex096> rank => -55
                      | <Lex097> rank => -56
                      | <Lex098> rank => -57
                      | <Lex099> rank => -58
                      | <Lex100> rank => -59
                      | <Lex101> rank => -60
                      | <Lex102> rank => -61
                      | <Lex103> rank => -62
                      | <Lex104> rank => -63
                      | <Lex105> rank => -64
                      | <Lex106> rank => -65
                      | <Lex107> rank => -66
                      | <Lex108> rank => -67
                      | <Lex109> rank => -68
                      | <Lex110> rank => -69
                      | <Lex111> rank => -70
                      | <Lex112> rank => -71
                      | <Lex113> rank => -72
                      | <Lex114> rank => -73
                      | <Lex115> rank => -74
                      | <Lex116> rank => -75
                      | <Lex117> rank => -76
                      | <Lex118> rank => -77
                      | <Lex119> rank => -78
                      | <Lex120> rank => -79
                      | <Lex121> rank => -80
                      | <Lex122> rank => -81
                      | <Lex123> rank => -82
                      | <Lex124> rank => -83
                      | <Lex125> rank => -84
                      | <Lex126> rank => -85
                      | <Lex127> rank => -86
                      | <Lex128> rank => -87
                      | <Lex129> rank => -88
                      | <Lex130> rank => -89
                      | <Lex131> rank => -90
                      | <Lex132> rank => -91
                      | <Lex133> rank => -92
                      | <Lex134> rank => -93
                      | <Lex135> rank => -94
                      | <Lex136> rank => -95
                      | <Lex034> rank => -96
                      | <Lex137> rank => -97
                      | <Lex138> rank => -98
                      | <Lex139> rank => -99
                      | <Lex140> rank => -100
                      | <Lex141> rank => -101
                      | <Lex142> rank => -102
                      | <Lex143> rank => -103
                      | <Lex144> rank => -104
                      | <Lex145> rank => -105
                      | <Lex146> rank => -106
                      | <Lex147> rank => -107
                      | <Lex148> rank => -108
                      | <Lex149> rank => -109
                      | <Lex150> rank => -110
                      | <Lex032> rank => -111
                      | <Lex151> rank => -112
                      | <Lex152> rank => -113
                      | <Lex153> rank => -114
                      | <Lex154> rank => -115
                      | <Lex155> rank => -116
                      | <Lex156> rank => -117
                      | <Lex157> rank => -118
                      | <Lex158> rank => -119
                      | <Lex159> rank => -120
                      | <Lex033> rank => -121
                      | <Lex160> rank => -122
                      | <Lex161> rank => -123
                      | <Lex162> rank => -124
                      | <Lex163> rank => -125
                      | <Lex164> rank => -126
                      | <Lex165> rank => -127
                      | <Lex166> rank => -128
                      | <Lex167> rank => -129
                      | <Lex168> rank => -130
                      | <Lex169> rank => -131
                      | <Lex170> rank => -132
                      | <Lex171> rank => -133
                      | <Lex172> rank => -134
                      | <Lex173> rank => -135
                      | <Lex174> rank => -136
                      | <Lex175> rank => -137
                      | <Lex176> rank => -138
                      | <Lex177> rank => -139
                      | <Lex178> rank => -140
                      | <Lex179> rank => -141
                      | <Lex180> rank => -142
                      | <Lex181> rank => -143
                      | <Lex182> rank => -144
                      | <Lex183> rank => -145
                      | <Lex184> rank => -146
                      | <Lex185> rank => -147
                      | <Lex186> rank => -148
                      | <Lex187> rank => -149
                      | <Lex188> rank => -150
                      | <Lex189> rank => -151
                      | <Lex190> rank => -152
                      | <Lex191> rank => -153
                      | <Lex192> rank => -154
                      | <Lex193> rank => -155
                      | <Lex194> rank => -156
                      | <Lex195> rank => -157
                      | <Lex196> rank => -158
                      | <Lex197> rank => -159
                      | <Lex198> rank => -160
                      | <Lex199> rank => -161
                      | <Lex200> rank => -162
                      | <Lex201> rank => -163
                      | <Lex202> rank => -164
                      | <Lex203> rank => -165
                      | <Lex204> rank => -166
                      | <Lex205> rank => -167
                      | <Lex206> rank => -168
                      | <Lex207> rank => -169
                      | <Lex208> rank => -170
                      | <Lex209> rank => -171
                      | <Lex210> rank => -172
                      | <Lex211> rank => -173
                      | <Lex212> rank => -174
                      | <Lex213> rank => -175
                      | <Lex214> rank => -176
                      | <Lex215> rank => -177
                      | <Lex216> rank => -178
                      | <Lex217> rank => -179
                      | <Lex218> rank => -180
                      | <Lex219> rank => -181
                      | <Lex220> rank => -182
                      | <Lex221> rank => -183
                      | <Lex222> rank => -184
                      | <Lex223> rank => -185
                      | <Lex224> rank => -186
                      | <Lex225> rank => -187
                      | <Lex226> rank => -188
                      | <Lex227> rank => -189
                      | <Lex228> rank => -190
                      | <Lex229> rank => -191
                      | <Lex230> rank => -192
                      | <Lex231> rank => -193
                      | <Lex232> rank => -194
                      | <Lex233> rank => -195
                      | <Lex234> rank => -196
                      | <Lex235> rank => -197
                      | <Lex236> rank => -198
                      | <Lex237> rank => -199
                      | <Lex238> rank => -200
                      | <Lex239> rank => -201
                      | <Lex240> rank => -202
                      | <Lex241> rank => -203
                      | <Lex242> rank => -204
                      | <Lex243> rank => -205
                      | <Lex244> rank => -206
                      | <Lex245> rank => -207
                      | <Lex246> rank => -208
                      | <Lex247> rank => -209
                      | <Lex248> rank => -210
                      | <Lex249> rank => -211
                      | <Lex250> rank => -212
                      | <Lex251> rank => -213
                      | <Lex252> rank => -214
                      | <Lex253> rank => -215
                      | <Lex254> rank => -216
                      | <Lex255> rank => -217
                      | <Lex256> rank => -218
                      | <Lex257> rank => -219
                      | <Lex258> rank => -220
                      | <Lex259> rank => -221
                      | <Lex260> rank => -222
                      | <Lex261> rank => -223
                      | <Lex262> rank => -224
                      | <Lex263> rank => -225
                      | <Lex264> rank => -226
                      | <Lex265> rank => -227
                      | <Lex266> rank => -228
                      | <Lex267> rank => -229
                      | <Lex268> rank => -230
                      | <Lex269> rank => -231
                      | <Lex270> rank => -232
                      | <Lex271> rank => -233
                      | <Lex272> rank => -234
                      | <Lex273> rank => -235
                      | <Lex274> rank => -236
                      | <Lex275> rank => -237
                      | <Lex276> rank => -238
                      | <Lex277> rank => -239
                      | <Lex278> rank => -240
                      | <Lex279> rank => -241
                      | <Lex280> rank => -242
                      | <Lex281> rank => -243
                      | <Lex282> rank => -244
                      | <Lex283> rank => -245
                      | <Lex284> rank => -246
                      | <Lex285> rank => -247
                      | <Lex286> rank => -248
                      | <Lex287> rank => -249
                      | <Lex288> rank => -250
<Reserved Word> ::= <Lex289> rank => 0
                  | <Lex290> rank => -1
                  | <Lex291> rank => -2
                  | <Lex292> rank => -3
                  | <Lex293> rank => -4
                  | <Lex294> rank => -5
                  | <Lex295> rank => -6
                  | <Lex296> rank => -7
                  | <Lex297> rank => -8
                  | <Lex298> rank => -9
                  | <Lex299> rank => -10
                  | <Lex300> rank => -11
                  | <Lex301> rank => -12
                  | <Lex302> rank => -13
                  | <Lex303> rank => -14
                  | <Lex304> rank => -15
                  | <Lex305> rank => -16
                  | <Lex306> rank => -17
                  | <Lex307> rank => -18
                  | <Lex308> rank => -19
                  | <Lex309> rank => -20
                  | <Lex310> rank => -21
                  | <Lex311> rank => -22
                  | <Lex312> rank => -23
                  | <Lex313> rank => -24
                  | <Lex314> rank => -25
                  | <Lex315> rank => -26
                  | <Lex316> rank => -27
                  | <Lex317> rank => -28
                  | <Lex318> rank => -29
                  | <Lex319> rank => -30
                  | <Lex320> rank => -31
                  | <Lex321> rank => -32
                  | <Lex322> rank => -33
                  | <Lex323> rank => -34
                  | <Lex324> rank => -35
                  | <Lex325> rank => -36
                  | <Lex326> rank => -37
                  | <Lex327> rank => -38
                  | <Lex328> rank => -39
                  | <Lex329> rank => -40
                  | <Lex330> rank => -41
                  | <Lex331> rank => -42
                  | <Lex332> rank => -43
                  | <Lex333> rank => -44
                  | <Lex334> rank => -45
                  | <Lex335> rank => -46
                  | <Lex336> rank => -47
                  | <Lex337> rank => -48
                  | <Lex338> rank => -49
                  | <Lex339> rank => -50
                  | <Lex340> rank => -51
                  | <Lex341> rank => -52
                  | <Lex342> rank => -53
                  | <Lex343> rank => -54
                  | <Lex344> rank => -55
                  | <Lex345> rank => -56
                  | <Lex346> rank => -57
                  | <Lex347> rank => -58
                  | <Lex348> rank => -59
                  | <Lex349> rank => -60
                  | <Lex350> rank => -61
                  | <Lex351> rank => -62
                  | <Lex352> rank => -63
                  | <Lex353> rank => -64
                  | <Lex354> rank => -65
                  | <Lex355> rank => -66
                  | <Lex356> rank => -67
                  | <Lex357> rank => -68
                  | <Lex358> rank => -69
                  | <Lex359> rank => -70
                  | <Lex360> rank => -71
                  | <Lex361> rank => -72
                  | <Lex362> rank => -73
                  | <Lex363> rank => -74
                  | <Lex364> rank => -75
                  | <Lex365> rank => -76
                  | <Lex366> rank => -77
                  | <Lex367> rank => -78
                  | <Lex368> rank => -79
                  | <Lex369> rank => -80
                  | <Lex370> rank => -81
                  | <Lex371> rank => -82
                  | <Lex372> rank => -83
                  | <Lex373> rank => -84
                  | <Lex374> rank => -85
                  | <Lex375> rank => -86
                  | <Lex376> rank => -87
                  | <Lex377> rank => -88
                  | <Lex378> rank => -89
                  | <Lex379> rank => -90
                  | <Lex380> rank => -91
                  | <Lex381> rank => -92
                  | <Lex382> rank => -93
                  | <Lex383> rank => -94
                  | <Lex384> rank => -95
                  | <Lex385> rank => -96
                  | <Lex386> rank => -97
                  | <Lex387> rank => -98
                  | <Lex388> rank => -99
                  | <Lex389> rank => -100
                  | <Lex390> rank => -101
                  | <Lex391> rank => -102
                  | <Lex392> rank => -103
                  | <Lex393> rank => -104
                  | <Lex394> rank => -105
                  | <Lex395> rank => -106
                  | <Lex396> rank => -107
                  | <Lex397> rank => -108
                  | <Lex398> rank => -109
                  | <Lex399> rank => -110
                  | <Lex400> rank => -111
                  | <Lex401> rank => -112
                  | <Lex150> rank => -113
                  | <Lex402> rank => -114
                  | <Lex403> rank => -115
                  | <Lex404> rank => -116
                  | <Lex405> rank => -117
                  | <Lex406> rank => -118
                  | <Lex407> rank => -119
                  | <Lex408> rank => -120
                  | <Lex409> rank => -121
                  | <Lex410> rank => -122
                  | <Lex411> rank => -123
                  | <Lex412> rank => -124
                  | <Lex413> rank => -125
                  | <Lex414> rank => -126
                  | <Lex415> rank => -127
                  | <Lex416> rank => -128
                  | <Lex417> rank => -129
                  | <Lex418> rank => -130
                  | <Lex419> rank => -131
                  | <Lex420> rank => -132
                  | <Lex421> rank => -133
                  | <Lex422> rank => -134
                  | <Lex423> rank => -135
                  | <Lex424> rank => -136
                  | <Lex425> rank => -137
                  | <Lex426> rank => -138
                  | <Lex427> rank => -139
                  | <Lex428> rank => -140
                  | <Lex429> rank => -141
                  | <Lex430> rank => -142
                  | <Lex431> rank => -143
                  | <Lex432> rank => -144
                  | <Lex433> rank => -145
                  | <Lex434> rank => -146
                  | <Lex435> rank => -147
                  | <Lex436> rank => -148
                  | <Lex437> rank => -149
                  | <Lex438> rank => -150
                  | <Lex439> rank => -151
                  | <Lex440> rank => -152
                  | <Lex441> rank => -153
                  | <Lex442> rank => -154
                  | <Lex443> rank => -155
                  | <Lex444> rank => -156
                  | <Lex445> rank => -157
                  | <Lex446> rank => -158
                  | <Lex447> rank => -159
                  | <Lex448> rank => -160
                  | <Lex449> rank => -161
                  | <Lex450> rank => -162
                  | <Lex451> rank => -163
                  | <Lex452> rank => -164
                  | <Lex453> rank => -165
                  | <Lex454> rank => -166
                  | <Lex455> rank => -167
                  | <Lex456> rank => -168
                  | <Lex457> rank => -169
                  | <Lex458> rank => -170
                  | <Lex459> rank => -171
                  | <Lex460> rank => -172
                  | <Lex461> rank => -173
                  | <Lex462> rank => -174
                  | <Lex463> rank => -175
                  | <Lex464> rank => -176
                  | <Lex465> rank => -177
                  | <Lex466> rank => -178
                  | <Lex467> rank => -179
                  | <Lex468> rank => -180
                  | <Lex469> rank => -181
                  | <Lex470> rank => -182
                  | <Lex471> rank => -183
                  | <Lex472> rank => -184
                  | <Lex473> rank => -185
                  | <Lex474> rank => -186
                  | <Lex475> rank => -187
                  | <Lex476> rank => -188
                  | <Lex477> rank => -189
                  | <Lex478> rank => -190
                  | <Lex479> rank => -191
                  | <Lex480> rank => -192
                  | <Lex481> rank => -193
                  | <Lex482> rank => -194
                  | <Lex483> rank => -195
                  | <Lex484> rank => -196
                  | <Lex485> rank => -197
                  | <Lex486> rank => -198
                  | <Lex487> rank => -199
                  | <Lex488> rank => -200
                  | <Lex489> rank => -201
                  | <Lex490> rank => -202
                  | <Lex491> rank => -203
                  | <Lex492> rank => -204
                  | <Lex493> rank => -205
                  | <Lex494> rank => -206
                  | <Lex495> rank => -207
                  | <Lex496> rank => -208
                  | <Lex497> rank => -209
                  | <Lex498> rank => -210
                  | <Lex499> rank => -211
                  | <Lex500> rank => -212
                  | <Lex501> rank => -213
                  | <Lex502> rank => -214
                  | <Lex503> rank => -215
                  | <Lex504> rank => -216
                  | <Lex505> rank => -217
                  | <Lex506> rank => -218
                  | <Lex507> rank => -219
                  | <Lex508> rank => -220
                  | <Lex509> rank => -221
                  | <Lex036> rank => -222
                  | <Lex510> rank => -223
                  | <Lex511> rank => -224
                  | <Lex512> rank => -225
                  | <Lex513> rank => -226
                  | <Lex514> rank => -227
                  | <Lex515> rank => -228
                  | <Lex516> rank => -229
                  | <Lex517> rank => -230
                  | <Lex518> rank => -231
                  | <Lex519> rank => -232
                  | <Lex520> rank => -233
                  | <Lex521> rank => -234
                  | <Lex522> rank => -235
                  | <Lex523> rank => -236
                  | <Lex524> rank => -237
                  | <Lex525> rank => -238
                  | <Lex526> rank => -239
                  | <Lex527> rank => -240
                  | <Lex528> rank => -241
                  | <Lex529> rank => -242
                  | <Lex530> rank => -243
                  | <Lex531> rank => -244
                  | <Lex532> rank => -245
<Literal> ::= <Signed Numeric Literal> rank => 0
            | <General Literal> rank => -1
<Unsigned Literal> ::= <Unsigned Numeric Literal> rank => 0
                     | <General Literal> rank => -1
<General Literal> ::= <Character String Literal> rank => 0
                    | <National Character String Literal> rank => -1
                    | <Unicode Character String Literal> rank => -2
                    | <Binary String Literal> rank => -3
                    | <Datetime Literal> rank => -4
                    | <Interval Literal> rank => -5
                    | <Boolean Literal> rank => -6
<Gen668> ::= <Introducer> <Character Set Specification> rank => 0
<Gen668 maybe> ::= <Gen668> rank => 0
<Gen668 maybe> ::= rank => -1
<Character Representation any> ::= <Character Representation>* rank => 0
<Gen672> ::= <Separator> <Quote> <Character Representation any> <Quote> rank => 0
<Gen672 any> ::= <Gen672>* rank => 0
<Character String Literal> ::= <Gen668 maybe> <Quote> <Character Representation any> <Quote> <Gen672 any> rank => 0
<Introducer> ::= <Underscore> rank => 0
<Character Representation> ::= <Nonquote Character> rank => 0
                             | <Quote Symbol> rank => -1
<Nonquote Character> ::= <Lex533> rank => 0
<Quote Symbol> ::= <Quote> <Quote> rank => 0
<Gen680> ::= <Separator> <Quote> <Character Representation any> <Quote> rank => 0
<Gen680 any> ::= <Gen680>* rank => 0
<National Character String Literal> ::= <Lex534> <Quote> <Character Representation any> <Quote> <Gen680 any> rank => 0
<Gen683> ::= <Introducer> <Character Set Specification> rank => 0
<Gen683 maybe> ::= <Gen683> rank => 0
<Gen683 maybe> ::= rank => -1
<Unicode Representation any> ::= <Unicode Representation>* rank => 0
<Gen687> ::= <Separator> <Quote> <Unicode Representation any> <Quote> rank => 0
<Gen687 any> ::= <Gen687>* rank => 0
<Gen689> ::= <Lex363> <Escape Character> rank => 0
<Gen689 maybe> ::= <Gen689> rank => 0
<Gen689 maybe> ::= rank => -1
<Unicode Character String Literal> ::= <Gen683 maybe> <Lex035> <Ampersand> <Quote> <Unicode Representation any> <Quote> <Gen687 any> <Gen689 maybe> rank => 0
<Unicode Representation> ::= <Character Representation> rank => 0
                           | <Unicode Escape Value> rank => -1
<Gen695> ::= <Hexit> <Hexit> rank => 0
<Gen695 any> ::= <Gen695>* rank => 0
<Gen697> ::= <Hexit> <Hexit> rank => 0
<Gen697 any> ::= <Gen697>* rank => 0
<Gen699> ::= <Separator> <Quote> <Gen697 any> <Quote> rank => 0
<Gen699 any> ::= <Gen699>* rank => 0
<Gen701> ::= <Lex363> <Escape Character> rank => 0
<Gen701 maybe> ::= <Gen701> rank => 0
<Gen701 maybe> ::= rank => -1
<Binary String Literal> ::= <Lex535> <Quote> <Gen695 any> <Quote> <Gen699 any> <Gen701 maybe> rank => 0
<Hexit> ::= <Digit> rank => 0
          | <Lex041> rank => -1
          | <Lex536> rank => -2
          | <Lex058> rank => -3
          | <Lex537> rank => -4
          | <Lex538> rank => -5
          | <Lex539> rank => -6
          | <Lex540> rank => -7
          | <Lex541> rank => -8
          | <Lex542> rank => -9
          | <Lex543> rank => -10
          | <Lex544> rank => -11
          | <Lex545> rank => -12
<Sign maybe> ::= <Sign> rank => 0
<Sign maybe> ::= rank => -1
<Signed Numeric Literal> ::= <Sign maybe> <Unsigned Numeric Literal> rank => 0
<Unsigned Numeric Literal> ::= <Exact Numeric Literal> rank => 0
                             | <Approximate Numeric Literal> rank => -1
<Unsigned Integer> ::= <Lex546 many> rank => 0
<Unsigned Integer maybe> ::= <Unsigned Integer> rank => 0
<Unsigned Integer maybe> ::= rank => -1
<Gen726> ::= <Period> <Unsigned Integer maybe> rank => 0
<Gen726 maybe> ::= <Gen726> rank => 0
<Gen726 maybe> ::= rank => -1
<Exact Numeric Literal> ::= <Unsigned Integer> <Gen726 maybe> rank => 0
                          | <Period> <Unsigned Integer> rank => -1
<Sign> ::= <Plus Sign> rank => 0
         | <Minus Sign> rank => -1
<Approximate Numeric Literal> ::= <Mantissa> <Lex538> <Exponent> rank => 0
<Mantissa> ::= <Exact Numeric Literal> rank => 0
<Exponent> ::= <Signed Integer> rank => 0
<Signed Integer> ::= <Sign maybe> <Unsigned Integer> rank => 0
<Datetime Literal> ::= <Date Literal> rank => 0
                     | <Time Literal> rank => -1
                     | <Timestamp Literal> rank => -2
<Date Literal> ::= <Lex342> <Date String> rank => 0
<Time Literal> ::= <Lex500> <Time String> rank => 0
<Timestamp Literal> ::= <Lex501> <Timestamp String> rank => 0
<Date String> ::= <Quote> <Unquoted Date String> <Quote> rank => 0
<Time String> ::= <Quote> <Unquoted Time String> <Quote> rank => 0
<Timestamp String> ::= <Quote> <Unquoted Timestamp String> <Quote> rank => 0
<Time Zone Interval> ::= <Sign> <Hours Value> <Colon> <Minutes Value> rank => 0
<Date Value> ::= <Years Value> <Minus Sign> <Months Value> <Minus Sign> <Days Value> rank => 0
<Time Value> ::= <Hours Value> <Colon> <Minutes Value> <Colon> <Seconds Value> rank => 0
<Interval Literal> ::= <Lex399> <Sign maybe> <Interval String> <Interval Qualifier> rank => 0
<Interval String> ::= <Quote> <Unquoted Interval String> <Quote> rank => 0
<Unquoted Date String> ::= <Date Value> rank => 0
<Time Zone Interval maybe> ::= <Time Zone Interval> rank => 0
<Time Zone Interval maybe> ::= rank => -1
<Unquoted Time String> ::= <Time Value> <Time Zone Interval maybe> rank => 0
<Unquoted Timestamp String> ::= <Unquoted Date String> <Space> <Unquoted Time String> rank => 0
<Gen756> ::= <Year Month Literal> rank => 0
           | <Day Time Literal> rank => -1
<Unquoted Interval String> ::= <Sign maybe> <Gen756> rank => 0
<Gen759> ::= <Years Value> <Minus Sign> rank => 0
<Gen759 maybe> ::= <Gen759> rank => 0
<Gen759 maybe> ::= rank => -1
<Year Month Literal> ::= <Years Value> rank => 0
                       | <Gen759 maybe> <Months Value> rank => -1
<Day Time Literal> ::= <Day Time Interval> rank => 0
                     | <Time Interval> rank => -1
<Gen766> ::= <Colon> <Seconds Value> rank => 0
<Gen766 maybe> ::= <Gen766> rank => 0
<Gen766 maybe> ::= rank => -1
<Gen769> ::= <Colon> <Minutes Value> <Gen766 maybe> rank => 0
<Gen769 maybe> ::= <Gen769> rank => 0
<Gen769 maybe> ::= rank => -1
<Gen772> ::= <Space> <Hours Value> <Gen769 maybe> rank => 0
<Gen772 maybe> ::= <Gen772> rank => 0
<Gen772 maybe> ::= rank => -1
<Day Time Interval> ::= <Days Value> <Gen772 maybe> rank => 0
<Gen776> ::= <Colon> <Seconds Value> rank => 0
<Gen776 maybe> ::= <Gen776> rank => 0
<Gen776 maybe> ::= rank => -1
<Gen779> ::= <Colon> <Minutes Value> <Gen776 maybe> rank => 0
<Gen779 maybe> ::= <Gen779> rank => 0
<Gen779 maybe> ::= rank => -1
<Gen782> ::= <Colon> <Seconds Value> rank => 0
<Gen782 maybe> ::= <Gen782> rank => 0
<Gen782 maybe> ::= rank => -1
<Time Interval> ::= <Hours Value> <Gen779 maybe> rank => 0
                  | <Minutes Value> <Gen782 maybe> rank => -1
                  | <Seconds Value> rank => -2
<Years Value> ::= <Datetime Value> rank => 0
<Months Value> ::= <Datetime Value> rank => 0
<Days Value> ::= <Datetime Value> rank => 0
<Hours Value> ::= <Datetime Value> rank => 0
<Minutes Value> ::= <Datetime Value> rank => 0
<Seconds Fraction maybe> ::= <Seconds Fraction> rank => 0
<Seconds Fraction maybe> ::= rank => -1
<Gen795> ::= <Period> <Seconds Fraction maybe> rank => 0
<Gen795 maybe> ::= <Gen795> rank => 0
<Gen795 maybe> ::= rank => -1
<Seconds Value> ::= <Seconds Integer Value> <Gen795 maybe> rank => 0
<Seconds Integer Value> ::= <Unsigned Integer> rank => 0
<Seconds Fraction> ::= <Unsigned Integer> rank => 0
<Datetime Value> ::= <Unsigned Integer> rank => 0
<Boolean Literal> ::= <Lex509> rank => 0
                    | <Lex369> rank => -1
                    | <Lex512> rank => -2
<Identifier> ::= <Actual Identifier> rank => 0
<Actual Identifier> ::= <Regular Identifier> rank => 0
                      | <Delimited Identifier> rank => -1
<Gen808> ::= <Underscore> rank => 0
           | <SQL Language Identifier Part> rank => -1
<Gen808 any> ::= <Gen808>* rank => 0
<SQL Language Identifier> ::= <SQL Language Identifier Start> <Gen808 any> rank => 0
<SQL Language Identifier Start> ::= <Simple Latin Letter> rank => 0
<SQL Language Identifier Part> ::= <Simple Latin Letter> rank => 0
                                 | <Digit> rank => -1
<Authorization Identifier> ::= <Role Name> rank => 0
                             | <User Identifier> rank => -1
<Table Name> ::= <Local Or Schema Qualified Name> rank => 0
<Domain Name> ::= <Schema Qualified Name> rank => 0
<Unqualified Schema Name> ::= <Identifier> rank => 0
<Gen820> ::= <Catalog Name> <Period> rank => 0
<Gen820 maybe> ::= <Gen820> rank => 0
<Gen820 maybe> ::= rank => -1
<Schema Name> ::= <Gen820 maybe> <Unqualified Schema Name> rank => 0
<Catalog Name> ::= <Identifier> rank => 0
<Gen825> ::= <Schema Name> <Period> rank => 0
<Gen825 maybe> ::= <Gen825> rank => 0
<Gen825 maybe> ::= rank => -1
<Schema Qualified Name> ::= <Gen825 maybe> <Qualified Identifier> rank => 0
<Gen829> ::= <Local Or Schema Qualifier> <Period> rank => 0
<Gen829 maybe> ::= <Gen829> rank => 0
<Gen829 maybe> ::= rank => -1
<Local Or Schema Qualified Name> ::= <Gen829 maybe> <Qualified Identifier> rank => 0
<Local Or Schema Qualifier> ::= <Schema Name> rank => 0
                              | <Lex418> rank => -1
<Qualified Identifier> ::= <Identifier> rank => 0
<Column Name> ::= <Identifier> rank => 0
<Correlation Name> ::= <Identifier> rank => 0
<Query Name> ::= <Identifier> rank => 0
<SQL Client Module Name> ::= <Identifier> rank => 0
<Procedure Name> ::= <Identifier> rank => 0
<Schema Qualified Routine Name> ::= <Schema Qualified Name> rank => 0
<Method Name> ::= <Identifier> rank => 0
<Specific Name> ::= <Schema Qualified Name> rank => 0
<Cursor Name> ::= <Local Qualified Name> rank => 0
<Gen845> ::= <Local Qualifier> <Period> rank => 0
<Gen845 maybe> ::= <Gen845> rank => 0
<Gen845 maybe> ::= rank => -1
<Local Qualified Name> ::= <Gen845 maybe> <Qualified Identifier> rank => 0
<Local Qualifier> ::= <Lex418> rank => 0
<Host Parameter Name> ::= <Colon> <Identifier> rank => 0
<SQL Parameter Name> ::= <Identifier> rank => 0
<Constraint Name> ::= <Schema Qualified Name> rank => 0
<External Routine Name> ::= <Identifier> rank => 0
                          | <Character String Literal> rank => -1
<Trigger Name> ::= <Schema Qualified Name> rank => 0
<Collation Name> ::= <Schema Qualified Name> rank => 0
<Gen857> ::= <Schema Name> <Period> rank => 0
<Gen857 maybe> ::= <Gen857> rank => 0
<Gen857 maybe> ::= rank => -1
<Character Set Name> ::= <Gen857 maybe> <SQL Language Identifier> rank => 0
<Transliteration Name> ::= <Schema Qualified Name> rank => 0
<Transcoding Name> ::= <Schema Qualified Name> rank => 0
<User Defined Type Name> ::= <Schema Qualified Type Name> rank => 0
<Schema Resolved User Defined Type Name> ::= <User Defined Type Name> rank => 0
<Gen865> ::= <Schema Name> <Period> rank => 0
<Gen865 maybe> ::= <Gen865> rank => 0
<Gen865 maybe> ::= rank => -1
<Schema Qualified Type Name> ::= <Gen865 maybe> <Qualified Identifier> rank => 0
<Attribute Name> ::= <Identifier> rank => 0
<Field Name> ::= <Identifier> rank => 0
<Savepoint Name> ::= <Identifier> rank => 0
<Sequence Generator Name> ::= <Schema Qualified Name> rank => 0
<Role Name> ::= <Identifier> rank => 0
<User Identifier> ::= <Identifier> rank => 0
<Connection Name> ::= <Simple Value Specification> rank => 0
<Sql Server Name> ::= <Simple Value Specification> rank => 0
<Connection User Name> ::= <Simple Value Specification> rank => 0
<SQL Statement Name> ::= <Statement Name> rank => 0
                       | <Extended Statement Name> rank => -1
<Statement Name> ::= <Identifier> rank => 0
<Scope Option maybe> ::= <Scope Option> rank => 0
<Scope Option maybe> ::= rank => -1
<Extended Statement Name> ::= <Scope Option maybe> <Simple Value Specification> rank => 0
<Dynamic Cursor Name> ::= <Cursor Name> rank => 0
                        | <Extended Cursor Name> rank => -1
<Extended Cursor Name> ::= <Scope Option maybe> <Simple Value Specification> rank => 0
<Descriptor Name> ::= <Scope Option maybe> <Simple Value Specification> rank => 0
<Scope Option> ::= <Lex380> rank => 0
                 | <Lex409> rank => -1
<Window Name> ::= <Identifier> rank => 0
<Data Type> ::= <Predefined Type> rank => 0
              | <Row Type> rank => -1
              | <Path Resolved User Defined Type Name> rank => -2
              | <Reference Type> rank => -3
              | <Collection Type> rank => -4
<Gen896> ::= <Lex317> <Lex482> <Character Set Specification> rank => 0
<Gen896 maybe> ::= <Gen896> rank => 0
<Gen896 maybe> ::= rank => -1
<Collate Clause maybe> ::= <Collate Clause> rank => 0
<Collate Clause maybe> ::= rank => -1
<Predefined Type> ::= <Character String Type> <Gen896 maybe> <Collate Clause maybe> rank => 0
                    | <National Character String Type> <Collate Clause maybe> rank => -1
                    | <Binary Large Object String Type> rank => -2
                    | <Numeric Type> rank => -3
                    | <Boolean Type> rank => -4
                    | <Datetime Type> rank => -5
                    | <Interval Type> rank => -6
<Gen908> ::= <Left Paren> <Length> <Right Paren> rank => 0
<Gen908 maybe> ::= <Gen908> rank => 0
<Gen908 maybe> ::= rank => -1
<Gen911> ::= <Left Paren> <Length> <Right Paren> rank => 0
<Gen911 maybe> ::= <Gen911> rank => 0
<Gen911 maybe> ::= rank => -1
<Gen914> ::= <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Gen914 maybe> ::= <Gen914> rank => 0
<Gen914 maybe> ::= rank => -1
<Gen917> ::= <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Gen917 maybe> ::= <Gen917> rank => 0
<Gen917 maybe> ::= rank => -1
<Gen920> ::= <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Gen920 maybe> ::= <Gen920> rank => 0
<Gen920 maybe> ::= rank => -1
<Character String Type> ::= <Lex317> <Gen908 maybe> rank => 0
                          | <Lex316> <Gen911 maybe> rank => -1
                          | <Lex317> <Lex523> <Left Paren> <Length> <Right Paren> rank => -2
                          | <Lex316> <Lex523> <Left Paren> <Length> <Right Paren> rank => -3
                          | <Lex522> <Left Paren> <Length> <Right Paren> rank => -4
                          | <Lex317> <Lex404> <Lex182> <Gen914 maybe> rank => -5
                          | <Lex316> <Lex404> <Lex182> <Gen917 maybe> rank => -6
                          | <Lex319> <Gen920 maybe> rank => -7
<Gen931> ::= <Left Paren> <Length> <Right Paren> rank => 0
<Gen931 maybe> ::= <Gen931> rank => 0
<Gen931 maybe> ::= rank => -1
<Gen934> ::= <Left Paren> <Length> <Right Paren> rank => 0
<Gen934 maybe> ::= <Gen934> rank => 0
<Gen934 maybe> ::= rank => -1
<Gen937> ::= <Left Paren> <Length> <Right Paren> rank => 0
<Gen937 maybe> ::= <Gen937> rank => 0
<Gen937 maybe> ::= rank => -1
<Gen940> ::= <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Gen940 maybe> ::= <Gen940> rank => 0
<Gen940 maybe> ::= rank => -1
<Gen943> ::= <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Gen943 maybe> ::= <Gen943> rank => 0
<Gen943 maybe> ::= rank => -1
<Gen946> ::= <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Gen946 maybe> ::= <Gen946> rank => 0
<Gen946 maybe> ::= rank => -1
<National Character String Type> ::= <Lex421> <Lex317> <Gen931 maybe> rank => 0
                                   | <Lex421> <Lex316> <Gen934 maybe> rank => -1
                                   | <Lex423> <Gen937 maybe> rank => -2
                                   | <Lex421> <Lex317> <Lex523> <Left Paren> <Length> <Right Paren> rank => -3
                                   | <Lex421> <Lex316> <Lex523> <Left Paren> <Length> <Right Paren> rank => -4
                                   | <Lex423> <Lex523> <Left Paren> <Length> <Right Paren> rank => -5
                                   | <Lex421> <Lex317> <Lex404> <Lex182> <Gen940 maybe> rank => -6
                                   | <Lex423> <Lex404> <Lex182> <Gen943 maybe> rank => -7
                                   | <Lex424> <Gen946 maybe> rank => -8
<Gen958> ::= <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Gen958 maybe> ::= <Gen958> rank => 0
<Gen958 maybe> ::= rank => -1
<Gen961> ::= <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Gen961 maybe> ::= <Gen961> rank => 0
<Gen961 maybe> ::= rank => -1
<Binary Large Object String Type> ::= <Lex306> <Lex404> <Lex182> <Gen958 maybe> rank => 0
                                    | <Lex307> <Gen961 maybe> rank => -1
<Numeric Type> ::= <Exact Numeric Type> rank => 0
                 | <Approximate Numeric Type> rank => -1
<Gen968> ::= <Comma> <Scale> rank => 0
<Gen968 maybe> ::= <Gen968> rank => 0
<Gen968 maybe> ::= rank => -1
<Gen971> ::= <Left Paren> <Precision> <Gen968 maybe> <Right Paren> rank => 0
<Gen971 maybe> ::= <Gen971> rank => 0
<Gen971 maybe> ::= rank => -1
<Gen974> ::= <Comma> <Scale> rank => 0
<Gen974 maybe> ::= <Gen974> rank => 0
<Gen974 maybe> ::= rank => -1
<Gen977> ::= <Left Paren> <Precision> <Gen974 maybe> <Right Paren> rank => 0
<Gen977 maybe> ::= <Gen977> rank => 0
<Gen977 maybe> ::= rank => -1
<Gen980> ::= <Comma> <Scale> rank => 0
<Gen980 maybe> ::= <Gen980> rank => 0
<Gen980 maybe> ::= rank => -1
<Gen983> ::= <Left Paren> <Precision> <Gen980 maybe> <Right Paren> rank => 0
<Gen983 maybe> ::= <Gen983> rank => 0
<Gen983 maybe> ::= rank => -1
<Exact Numeric Type> ::= <Lex430> <Gen971 maybe> rank => 0
                       | <Lex346> <Gen977 maybe> rank => -1
                       | <Lex345> <Gen983 maybe> rank => -2
                       | <Lex484> rank => -3
                       | <Lex397> rank => -4
                       | <Lex396> rank => -5
                       | <Lex305> rank => -6
<Gen993> ::= <Left Paren> <Precision> <Right Paren> rank => 0
<Gen993 maybe> ::= <Gen993> rank => 0
<Gen993 maybe> ::= rank => -1
<Approximate Numeric Type> ::= <Lex372> <Gen993 maybe> rank => 0
                             | <Lex451> rank => -1
                             | <Lex355> <Lex445> rank => -2
<Length> ::= <Unsigned Integer> rank => 0
<Multiplier maybe> ::= <Multiplier> rank => 0
<Multiplier maybe> ::= rank => -1
<Char Length Units maybe> ::= <Char Length Units> rank => 0
<Char Length Units maybe> ::= rank => -1
<Large Object Length> ::= <Unsigned Integer> <Multiplier maybe> <Char Length Units maybe> rank => 0
                        | <Large Object Length Token> <Char Length Units maybe> rank => -1
<Char Length Units> ::= <Lex067> rank => 0
                      | <Lex077> rank => -1
                      | <Lex183> rank => -2
<Precision> ::= <Unsigned Integer> rank => 0
<Scale> ::= <Unsigned Integer> rank => 0
<Boolean Type> ::= <Lex308> rank => 0
<Gen1012> ::= <Left Paren> <Time Precision> <Right Paren> rank => 0
<Gen1012 maybe> ::= <Gen1012> rank => 0
<Gen1012 maybe> ::= rank => -1
<Gen1015> ::= <With Or Without Time Zone> rank => 0
<Gen1015 maybe> ::= <Gen1015> rank => 0
<Gen1015 maybe> ::= rank => -1
<Gen1018> ::= <Left Paren> <Timestamp Precision> <Right Paren> rank => 0
<Gen1018 maybe> ::= <Gen1018> rank => 0
<Gen1018 maybe> ::= rank => -1
<Gen1021> ::= <With Or Without Time Zone> rank => 0
<Gen1021 maybe> ::= <Gen1021> rank => 0
<Gen1021 maybe> ::= rank => -1
<Datetime Type> ::= <Lex342> rank => 0
                  | <Lex500> <Gen1012 maybe> <Gen1015 maybe> rank => -1
                  | <Lex501> <Gen1018 maybe> <Gen1021 maybe> rank => -2
<With Or Without Time Zone> ::= <Lex529> <Lex500> <Lex288> rank => 0
                              | <Lex531> <Lex500> <Lex288> rank => -1
<Time Precision> ::= <Time Fractional Seconds Precision> rank => 0
<Timestamp Precision> ::= <Time Fractional Seconds Precision> rank => 0
<Time Fractional Seconds Precision> ::= <Unsigned Integer> rank => 0
<Interval Type> ::= <Lex399> <Interval Qualifier> rank => 0
<Row Type> ::= <Lex473> <Row Type Body> rank => 0
<Gen1034> ::= <Comma> <Field Definition> rank => 0
<Gen1034 any> ::= <Gen1034>* rank => 0
<Row Type Body> ::= <Left Paren> <Field Definition> <Gen1034 any> <Right Paren> rank => 0
<Scope Clause maybe> ::= <Scope Clause> rank => 0
<Scope Clause maybe> ::= rank => -1
<Reference Type> ::= <Lex453> <Left Paren> <Referenced Type> <Right Paren> <Scope Clause maybe> rank => 0
<Scope Clause> ::= <Lex547> <Table Name> rank => 0
<Referenced Type> ::= <Path Resolved User Defined Type Name> rank => 0
<Path Resolved User Defined Type Name> ::= <User Defined Type Name> rank => 0
<Collection Type> ::= <Array Type> rank => 0
                    | <Multiset Type> rank => -1
<Gen1045> ::= <Left Bracket Or Trigraph> <Unsigned Integer> <Right Bracket Or Trigraph> rank => 0
<Gen1045 maybe> ::= <Gen1045> rank => 0
<Gen1045 maybe> ::= rank => -1
<Array Type> ::= <Data Type> <Lex296> <Gen1045 maybe> rank => 0
<Multiset Type> ::= <Data Type> <Lex420> rank => 0
<Reference Scope Check maybe> ::= <Reference Scope Check> rank => 0
<Reference Scope Check maybe> ::= rank => -1
<Field Definition> ::= <Field Name> <Data Type> <Reference Scope Check maybe> rank => 0
<Value Expression Primary> ::= <Parenthesized Value Expression> rank => 0
                             | <Nonparenthesized Value Expression Primary> rank => -1
<Parenthesized Value Expression> ::= <Left Paren> <Value Expression> <Right Paren> rank => 0
<Nonparenthesized Value Expression Primary> ::= <Unsigned Value Specification> rank => 0
                                              | <Column Reference> rank => -1
                                              | <Set Function Specification> rank => -2
                                              | <Window Function> rank => -3
                                              | <Scalar Subquery> rank => -4
                                              | <Case Expression> rank => -5
                                              | <Cast Specification> rank => -6
                                              | <Field Reference> rank => -7
                                              | <Subtype Treatment> rank => -8
                                              | <Method Invocation> rank => -9
                                              | <Static Method Invocation> rank => -10
                                              | <New Specification> rank => -11
                                              | <Attribute Or Method Reference> rank => -12
                                              | <Reference Resolution> rank => -13
                                              | <Collection Value Constructor> rank => -14
                                              | <Array Element Reference> rank => -15
                                              | <Multiset Element Reference> rank => -16
                                              | <Routine Invocation> rank => -17
                                              | <Next Value Expression> rank => -18
<Value Specification> ::= <Literal> rank => 0
                        | <General Value Specification> rank => -1
<Unsigned Value Specification> ::= <Unsigned Literal> rank => 0
                                 | <General Value Specification> rank => -1
<General Value Specification> ::= <Host Parameter Specification> rank => 0
                                | <SQL Parameter Reference> rank => -1
                                | <Dynamic Parameter Specification> rank => -2
                                | <Embedded Variable Specification> rank => -3
                                | <Current Collation Specification> rank => -4
                                | <Lex333> rank => -5
                                | <Lex334> rank => -6
                                | <Lex335> rank => -7
                                | <Lex338> <Path Resolved User Defined Type Name> rank => -8
                                | <Lex339> rank => -9
                                | <Lex481> rank => -10
                                | <Lex497> rank => -11
                                | <Lex516> rank => -12
                                | <Lex518> rank => -13
<Simple Value Specification> ::= <Literal> rank => 0
                               | <Host Parameter Name> rank => -1
                               | <SQL Parameter Reference> rank => -2
                               | <Embedded Variable Name> rank => -3
<Target Specification> ::= <Host Parameter Specification> rank => 0
                         | <SQL Parameter Reference> rank => -1
                         | <Column Reference> rank => -2
                         | <Target Array Element Specification> rank => -3
                         | <Dynamic Parameter Specification> rank => -4
                         | <Embedded Variable Specification> rank => -5
<Simple Target Specification> ::= <Host Parameter Specification> rank => 0
                                | <SQL Parameter Reference> rank => -1
                                | <Column Reference> rank => -2
                                | <Embedded Variable Name> rank => -3
<Indicator Parameter maybe> ::= <Indicator Parameter> rank => 0
<Indicator Parameter maybe> ::= rank => -1
<Host Parameter Specification> ::= <Host Parameter Name> <Indicator Parameter maybe> rank => 0
<Dynamic Parameter Specification> ::= <Question Mark> rank => 0
<Indicator Variable maybe> ::= <Indicator Variable> rank => 0
<Indicator Variable maybe> ::= rank => -1
<Embedded Variable Specification> ::= <Embedded Variable Name> <Indicator Variable maybe> rank => 0
<Lex390 maybe> ::= <Lex390> rank => 0
<Lex390 maybe> ::= rank => -1
<Indicator Variable> ::= <Lex390 maybe> <Embedded Variable Name> rank => 0
<Indicator Parameter> ::= <Lex390 maybe> <Host Parameter Name> rank => 0
<Target Array Element Specification> ::= <Target Array Reference> <Left Bracket Or Trigraph> <Simple Value Specification> <Right Bracket Or Trigraph> rank => 0
<Target Array Reference> ::= <SQL Parameter Reference> rank => 0
                           | <Column Reference> rank => -1
<Current Collation Specification> ::= <Lex102> <Left Paren> <String Value Expression> <Right Paren> rank => 0
<Contextually Typed Value Specification> ::= <Implicitly Typed Value Specification> rank => 0
                                           | <Default Specification> rank => -1
<Implicitly Typed Value Specification> ::= <Null Specification> rank => 0
                                         | <Empty Specification> rank => -1
<Null Specification> ::= <Lex429> rank => 0
<Empty Specification> ::= <Lex296> <Left Bracket Or Trigraph> <Right Bracket Or Trigraph> rank => 0
                        | <Lex420> <Left Bracket Or Trigraph> <Right Bracket Or Trigraph> rank => -1
<Default Specification> ::= <Lex348> rank => 0
<Gen1130> ::= <Period> <Identifier> rank => 0
<Gen1130 any> ::= <Gen1130>* rank => 0
<Identifier Chain> ::= <Identifier> <Gen1130 any> rank => 0
<Basic Identifier Chain> ::= <Identifier Chain> rank => 0
<Column Reference> ::= <Basic Identifier Chain> rank => 0
                     | <Lex418> <Period> <Qualified Identifier> <Period> <Column Name> rank => -1
<SQL Parameter Reference> ::= <Basic Identifier Chain> rank => 0
<Set Function Specification> ::= <Aggregate Function> rank => 0
                               | <Grouping Operation> rank => -1
<Gen1139> ::= <Comma> <Column Reference> rank => 0
<Gen1139 any> ::= <Gen1139>* rank => 0
<Grouping Operation> ::= <Lex383> <Left Paren> <Column Reference> <Gen1139 any> <Right Paren> rank => 0
<Window Function> ::= <Window Function Type> <Lex441> <Window Name Or Specification> rank => 0
<Window Function Type> ::= <Rank Function Type> <Left Paren> <Right Paren> rank => 0
                         | <Lex229> <Left Paren> <Right Paren> rank => -1
                         | <Aggregate Function> rank => -2
<Rank Function Type> ::= <Lex214> rank => 0
                       | <Lex113> rank => -1
                       | <Lex204> rank => -2
                       | <Lex101> rank => -3
<Window Name Or Specification> ::= <Window Name> rank => 0
                                 | <In Line Window Specification> rank => -1
<In Line Window Specification> ::= <Window Specification> rank => 0
<Case Expression> ::= <Case Abbreviation> rank => 0
                    | <Case Specification> rank => -1
<Gen1155> ::= <Comma> <Value Expression> rank => 0
<Gen1155 many> ::= <Gen1155>+ rank => 0
<Case Abbreviation> ::= <Lex179> <Left Paren> <Value Expression> <Comma> <Value Expression> <Right Paren> rank => 0
                      | <Lex075> <Left Paren> <Value Expression> <Gen1155 many> <Right Paren> rank => -1
<Case Specification> ::= <Simple Case> rank => 0
                       | <Searched Case> rank => -1
<Simple When Clause many> ::= <Simple When Clause>+ rank => 0
<Else Clause maybe> ::= <Else Clause> rank => 0
<Else Clause maybe> ::= rank => -1
<Simple Case> ::= <Lex314> <Case Operand> <Simple When Clause many> <Else Clause maybe> <Lex361> rank => 0
<Searched When Clause many> ::= <Searched When Clause>+ rank => 0
<Searched Case> ::= <Lex314> <Searched When Clause many> <Else Clause maybe> <Lex361> rank => 0
<Simple When Clause> ::= <Lex524> <When Operand> <Lex499> <Result> rank => 0
<Searched When Clause> ::= <Lex524> <Search Condition> <Lex499> <Result> rank => 0
<Else Clause> ::= <Lex360> <Result> rank => 0
<Case Operand> ::= <Row Value Predicand> rank => 0
                 | <Overlaps Predicate> rank => -1
<When Operand> ::= <Row Value Predicand> rank => 0
                 | <Comparison Predicate Part 2> rank => -1
                 | <Between Predicate Part 2> rank => -2
                 | <In Predicate Part 2> rank => -3
                 | <Character Like Predicate Part 2> rank => -4
                 | <Octet Like Predicate Part 2> rank => -5
                 | <Similar Predicate Part 2> rank => -6
                 | <Null Predicate Part 2> rank => -7
                 | <Quantified Comparison Predicate Part 2> rank => -8
                 | <Match Predicate Part 2> rank => -9
                 | <Overlaps Predicate Part 2> rank => -10
                 | <Distinct Predicate Part 2> rank => -11
                 | <Member Predicate Part 2> rank => -12
                 | <Submultiset Predicate Part 2> rank => -13
                 | <Set Predicate Part 2> rank => -14
                 | <Type Predicate Part 2> rank => -15
<Result> ::= <Result Expression> rank => 0
           | <Lex429> rank => -1
<Result Expression> ::= <Value Expression> rank => 0
<Cast Specification> ::= <Lex315> <Left Paren> <Cast Operand> <Lex297> <Cast Target> <Right Paren> rank => 0
<Cast Operand> ::= <Value Expression> rank => 0
                 | <Implicitly Typed Value Specification> rank => -1
<Cast Target> ::= <Domain Name> rank => 0
                | <Data Type> rank => -1
<Next Value Expression> ::= <Lex175> <Lex518> <Lex373> <Sequence Generator Name> rank => 0
<Field Reference> ::= <Value Expression Primary> <Period> <Field Name> rank => 0
<Subtype Treatment> ::= <Lex507> <Left Paren> <Subtype Operand> <Lex297> <Target Subtype> <Right Paren> rank => 0
<Subtype Operand> ::= <Value Expression> rank => 0
<Target Subtype> ::= <Path Resolved User Defined Type Name> rank => 0
                   | <Reference Type> rank => -1
<Method Invocation> ::= <Direct Invocation> rank => 0
                      | <Generalized Invocation> rank => -1
<SQL Argument List maybe> ::= <SQL Argument List> rank => 0
<SQL Argument List maybe> ::= rank => -1
<Direct Invocation> ::= <Value Expression Primary> <Period> <Method Name> <SQL Argument List maybe> rank => 0
<Generalized Invocation> ::= <Left Paren> <Value Expression Primary> <Lex297> <Data Type> <Right Paren> <Period> <Method Name> <SQL Argument List maybe> rank => 0
<Method Selection> ::= <Routine Invocation> rank => 0
<Constructor Method Selection> ::= <Routine Invocation> rank => 0
<Static Method Invocation> ::= <Path Resolved User Defined Type Name> <Double Colon> <Method Name> <SQL Argument List maybe> rank => 0
<Static Method Selection> ::= <Routine Invocation> rank => 0
<New Specification> ::= <Lex425> <Routine Invocation> rank => 0
<New Invocation> ::= <Method Invocation> rank => 0
                   | <Routine Invocation> rank => -1
<Attribute Or Method Reference> ::= <Value Expression Primary> <Dereference Operator> <Qualified Identifier> <SQL Argument List maybe> rank => 0
<Dereference Operator> ::= <Right Arrow> rank => 0
<Dereference Operation> ::= <Reference Value Expression> <Dereference Operator> <Attribute Name> rank => 0
<Method Reference> ::= <Value Expression Primary> <Dereference Operator> <Method Name> <SQL Argument List> rank => 0
<Reference Resolution> ::= <Lex350> <Left Paren> <Reference Value Expression> <Right Paren> rank => 0
<Array Element Reference> ::= <Array Value Expression> <Left Bracket Or Trigraph> <Numeric Value Expression> <Right Bracket Or Trigraph> rank => 0
<Multiset Element Reference> ::= <Lex359> <Left Paren> <Multiset Value Expression> <Right Paren> rank => 0
<Value Expression> ::= <Common Value Expression> rank => 0
                     | <Boolean Value Expression> rank => -1
                     | <Row Value Expression> rank => -2
<Common Value Expression> ::= <Numeric Value Expression> rank => 0
                            | <String Value Expression> rank => -1
                            | <Datetime Value Expression> rank => -2
                            | <Interval Value Expression> rank => -3
                            | <User Defined Type Value Expression> rank => -4
                            | <Reference Value Expression> rank => -5
                            | <Collection Value Expression> rank => -6
<User Defined Type Value Expression> ::= <Value Expression Primary> rank => 0
<Reference Value Expression> ::= <Value Expression Primary> rank => 0
<Collection Value Expression> ::= <Array Value Expression> rank => 0
                                | <Multiset Value Expression> rank => -1
<Collection Value Constructor> ::= <Array Value Constructor> rank => 0
                                 | <Multiset Value Constructor> rank => -1
<Numeric Value Expression> ::= <Term> rank => 0
                             | <Numeric Value Expression> <Plus Sign> <Term> rank => -1
                             | <Numeric Value Expression> <Minus Sign> <Term> rank => -2
<Term> ::= <Factor> rank => 0
         | <Term> <Asterisk> <Factor> rank => -1
         | <Term> <Solidus> <Factor> rank => -2
<Factor> ::= <Sign maybe> <Numeric Primary> rank => 0
<Numeric Primary> ::= <Value Expression Primary> rank => 0
                    | <Numeric Value Function> rank => -1
<Numeric Value Function> ::= <Position Expression> rank => 0
                           | <Extract Expression> rank => -1
                           | <Length Expression> rank => -2
                           | <Cardinality Expression> rank => -3
                           | <Absolute Value Expression> rank => -4
                           | <Modulus Expression> rank => -5
                           | <Natural Logarithm> rank => -6
                           | <Exponential Function> rank => -7
                           | <Power Function> rank => -8
                           | <Square Root> rank => -9
                           | <Floor Function> rank => -10
                           | <Ceiling Function> rank => -11
                           | <Width Bucket Function> rank => -12
<Position Expression> ::= <String Position Expression> rank => 0
                        | <Blob Position Expression> rank => -1
<Gen1262> ::= <Lex517> <Char Length Units> rank => 0
<Gen1262 maybe> ::= <Gen1262> rank => 0
<Gen1262 maybe> ::= rank => -1
<String Position Expression> ::= <Lex207> <Left Paren> <String Value Expression> <Lex389> <String Value Expression> <Gen1262 maybe> <Right Paren> rank => 0
<Blob Position Expression> ::= <Lex207> <Left Paren> <Blob Value Expression> <Lex389> <Blob Value Expression> <Right Paren> rank => 0
<Length Expression> ::= <Char Length Expression> rank => 0
                      | <Octet Length Expression> rank => -1
<Gen1269> ::= <Lex072> rank => 0
            | <Lex068> rank => -1
<Gen1271> ::= <Lex517> <Char Length Units> rank => 0
<Gen1271 maybe> ::= <Gen1271> rank => 0
<Gen1271 maybe> ::= rank => -1
<Char Length Expression> ::= <Gen1269> <Left Paren> <String Value Expression> <Gen1271 maybe> <Right Paren> rank => 0
<Octet Length Expression> ::= <Lex184> <Left Paren> <String Value Expression> <Right Paren> rank => 0
<Extract Expression> ::= <Lex129> <Left Paren> <Extract Field> <Lex376> <Extract Source> <Right Paren> rank => 0
<Extract Field> ::= <Primary Datetime Field> rank => 0
                  | <Time Zone Field> rank => -1
<Time Zone Field> ::= <Lex502> rank => 0
                    | <Lex503> rank => -1
<Extract Source> ::= <Datetime Value Expression> rank => 0
                   | <Interval Value Expression> rank => -1
<Cardinality Expression> ::= <Lex059> <Left Paren> <Collection Value Expression> <Right Paren> rank => 0
<Absolute Value Expression> ::= <Lex042> <Left Paren> <Numeric Value Expression> <Right Paren> rank => 0
<Modulus Expression> ::= <Lex169> <Left Paren> <Numeric Value Expression> <Comma> <Numeric Value Expression> <Right Paren> rank => 0
<Natural Logarithm> ::= <Lex157> <Left Paren> <Numeric Value Expression> <Right Paren> rank => 0
<Exponential Function> ::= <Lex128> <Left Paren> <Numeric Value Expression> <Right Paren> rank => 0
<Power Function> ::= <Lex208> <Left Paren> <Numeric Value Expression Base> <Comma> <Numeric Value Expression Exponent> <Right Paren> rank => 0
<Numeric Value Expression Base> ::= <Numeric Value Expression> rank => 0
<Numeric Value Expression Exponent> ::= <Numeric Value Expression> rank => 0
<Square Root> ::= <Lex249> <Left Paren> <Numeric Value Expression> <Right Paren> rank => 0
<Floor Function> ::= <Lex132> <Left Paren> <Numeric Value Expression> <Right Paren> rank => 0
<Gen1293> ::= <Lex063> rank => 0
            | <Lex064> rank => -1
<Ceiling Function> ::= <Gen1293> <Left Paren> <Numeric Value Expression> <Right Paren> rank => 0
<Width Bucket Function> ::= <Lex527> <Left Paren> <Width Bucket Operand> <Comma> <Width Bucket Bound 1> <Comma> <Width Bucket Bound 2> <Comma> <Width Bucket Count> <Right Paren> rank => 0
<Width Bucket Operand> ::= <Numeric Value Expression> rank => 0
<Width Bucket Bound 1> ::= <Numeric Value Expression> rank => 0
<Width Bucket Bound 2> ::= <Numeric Value Expression> rank => 0
<Width Bucket Count> ::= <Numeric Value Expression> rank => 0
<String Value Expression> ::= <Character Value Expression> rank => 0
                            | <Blob Value Expression> rank => -1
<Character Value Expression> ::= <Concatenation> rank => 0
                               | <Character Factor> rank => -1
<Concatenation> ::= <Character Value Expression> <Concatenation Operator> <Character Factor> rank => 0
<Character Factor> ::= <Character Primary> <Collate Clause maybe> rank => 0
<Character Primary> ::= <Value Expression Primary> rank => 0
                      | <String Value Function> rank => -1
<Blob Value Expression> ::= <Blob Concatenation> rank => 0
                          | <Blob Factor> rank => -1
<Blob Factor> ::= <Blob Primary> rank => 0
<Blob Primary> ::= <Value Expression Primary> rank => 0
                 | <String Value Function> rank => -1
<Blob Concatenation> ::= <Blob Value Expression> <Concatenation Operator> <Blob Factor> rank => 0
<String Value Function> ::= <Character Value Function> rank => 0
                          | <Blob Value Function> rank => -1
<Character Value Function> ::= <Character Substring Function> rank => 0
                             | <Regular Expression Substring Function> rank => -1
                             | <Fold> rank => -2
                             | <Transcoding> rank => -3
                             | <Character Transliteration> rank => -4
                             | <Trim Function> rank => -5
                             | <Character Overlay Function> rank => -6
                             | <Normalize Function> rank => -7
                             | <Specific Type Method> rank => -8
<Gen1326> ::= <Lex373> <String Length> rank => 0
<Gen1326 maybe> ::= <Gen1326> rank => 0
<Gen1326 maybe> ::= rank => -1
<Gen1329> ::= <Lex517> <Char Length Units> rank => 0
<Gen1329 maybe> ::= <Gen1329> rank => 0
<Gen1329 maybe> ::= rank => -1
<Character Substring Function> ::= <Lex257> <Left Paren> <Character Value Expression> <Lex376> <Start Position> <Gen1326 maybe> <Gen1329 maybe> <Right Paren> rank => 0
<Regular Expression Substring Function> ::= <Lex257> <Left Paren> <Character Value Expression> <Lex483> <Character Value Expression> <Lex363> <Escape Character> <Right Paren> rank => 0
<Gen1334> ::= <Lex515> rank => 0
            | <Lex159> rank => -1
<Fold> ::= <Gen1334> <Left Paren> <Character Value Expression> <Right Paren> rank => 0
<Transcoding> ::= <Lex096> <Left Paren> <Character Value Expression> <Lex517> <Transcoding Name> <Right Paren> rank => 0
<Character Transliteration> ::= <Lex270> <Left Paren> <Character Value Expression> <Lex517> <Transliteration Name> <Right Paren> rank => 0
<Trim Function> ::= <Lex274> <Left Paren> <Trim Operands> <Right Paren> rank => 0
<Trim Specification maybe> ::= <Trim Specification> rank => 0
<Trim Specification maybe> ::= rank => -1
<Trim Character maybe> ::= <Trim Character> rank => 0
<Trim Character maybe> ::= rank => -1
<Gen1344> ::= <Trim Specification maybe> <Trim Character maybe> <Lex376> rank => 0
<Gen1344 maybe> ::= <Gen1344> rank => 0
<Gen1344 maybe> ::= rank => -1
<Trim Operands> ::= <Gen1344 maybe> <Trim Source> rank => 0
<Trim Source> ::= <Character Value Expression> rank => 0
<Trim Specification> ::= <Lex406> rank => 0
                       | <Lex505> rank => -1
                       | <Lex309> rank => -2
<Trim Character> ::= <Character Value Expression> rank => 0
<Gen1353> ::= <Lex373> <String Length> rank => 0
<Gen1353 maybe> ::= <Gen1353> rank => 0
<Gen1353 maybe> ::= rank => -1
<Gen1356> ::= <Lex517> <Char Length Units> rank => 0
<Gen1356 maybe> ::= <Gen1356> rank => 0
<Gen1356 maybe> ::= rank => -1
<Character Overlay Function> ::= <Lex190> <Left Paren> <Character Value Expression> <Lex205> <Character Value Expression> <Lex376> <Start Position> <Gen1353 maybe> <Gen1356 maybe> <Right Paren> rank => 0
<Normalize Function> ::= <Lex176> <Left Paren> <Character Value Expression> <Right Paren> rank => 0
<Specific Type Method> ::= <User Defined Type Value Expression> <Period> <Lex487> rank => 0
<Blob Value Function> ::= <Blob Substring Function> rank => 0
                        | <Blob Trim Function> rank => -1
                        | <Blob Overlay Function> rank => -2
<Gen1365> ::= <Lex373> <String Length> rank => 0
<Gen1365 maybe> ::= <Gen1365> rank => 0
<Gen1365 maybe> ::= rank => -1
<Blob Substring Function> ::= <Lex257> <Left Paren> <Blob Value Expression> <Lex376> <Start Position> <Gen1365 maybe> <Right Paren> rank => 0
<Blob Trim Function> ::= <Lex274> <Left Paren> <Blob Trim Operands> <Right Paren> rank => 0
<Trim Octet maybe> ::= <Trim Octet> rank => 0
<Trim Octet maybe> ::= rank => -1
<Gen1372> ::= <Trim Specification maybe> <Trim Octet maybe> <Lex376> rank => 0
<Gen1372 maybe> ::= <Gen1372> rank => 0
<Gen1372 maybe> ::= rank => -1
<Blob Trim Operands> ::= <Gen1372 maybe> <Blob Trim Source> rank => 0
<Blob Trim Source> ::= <Blob Value Expression> rank => 0
<Trim Octet> ::= <Blob Value Expression> rank => 0
<Gen1378> ::= <Lex373> <String Length> rank => 0
<Gen1378 maybe> ::= <Gen1378> rank => 0
<Gen1378 maybe> ::= rank => -1
<Blob Overlay Function> ::= <Lex190> <Left Paren> <Blob Value Expression> <Lex205> <Blob Value Expression> <Lex376> <Start Position> <Gen1378 maybe> <Right Paren> rank => 0
<Start Position> ::= <Numeric Value Expression> rank => 0
<String Length> ::= <Numeric Value Expression> rank => 0
<Datetime Value Expression> ::= <Datetime Term> rank => 0
                              | <Interval Value Expression> <Plus Sign> <Datetime Term> rank => -1
                              | <Datetime Value Expression> <Plus Sign> <Interval Term> rank => -2
                              | <Datetime Value Expression> <Minus Sign> <Interval Term> rank => -3
<Datetime Term> ::= <Datetime Factor> rank => 0
<Time Zone maybe> ::= <Time Zone> rank => 0
<Time Zone maybe> ::= rank => -1
<Datetime Factor> ::= <Datetime Primary> <Time Zone maybe> rank => 0
<Datetime Primary> ::= <Value Expression Primary> rank => 0
                     | <Datetime Value Function> rank => -1
<Time Zone> ::= <Lex300> <Time Zone Specifier> rank => 0
<Time Zone Specifier> ::= <Lex409> rank => 0
                        | <Lex500> <Lex288> <Interval Primary> rank => -1
<Datetime Value Function> ::= <Current Date Value Function> rank => 0
                            | <Current Time Value Function> rank => -1
                            | <Current Timestamp Value Function> rank => -2
                            | <Current Local Time Value Function> rank => -3
                            | <Current Local Timestamp Value Function> rank => -4
<Current Date Value Function> ::= <Lex332> rank => 0
<Gen1403> ::= <Left Paren> <Time Precision> <Right Paren> rank => 0
<Gen1403 maybe> ::= <Gen1403> rank => 0
<Gen1403 maybe> ::= rank => -1
<Current Time Value Function> ::= <Lex336> <Gen1403 maybe> rank => 0
<Gen1407> ::= <Left Paren> <Time Precision> <Right Paren> rank => 0
<Gen1407 maybe> ::= <Gen1407> rank => 0
<Gen1407 maybe> ::= rank => -1
<Current Local Time Value Function> ::= <Lex410> <Gen1407 maybe> rank => 0
<Gen1411> ::= <Left Paren> <Timestamp Precision> <Right Paren> rank => 0
<Gen1411 maybe> ::= <Gen1411> rank => 0
<Gen1411 maybe> ::= rank => -1
<Current Timestamp Value Function> ::= <Lex337> <Gen1411 maybe> rank => 0
<Gen1415> ::= <Left Paren> <Timestamp Precision> <Right Paren> rank => 0
<Gen1415 maybe> ::= <Gen1415> rank => 0
<Gen1415 maybe> ::= rank => -1
<Current Local Timestamp Value Function> ::= <Lex411> <Gen1415 maybe> rank => 0
<Interval Value Expression> ::= <Interval Term> rank => 0
                              | <Interval Value Expression 1> <Plus Sign> <Interval Term 1> rank => -1
                              | <Interval Value Expression 1> <Minus Sign> <Interval Term 1> rank => -2
                              | <Left Paren> <Datetime Value Expression> <Minus Sign> <Datetime Term> <Right Paren> <Interval Qualifier> rank => -3
<Interval Term> ::= <Interval Factor> rank => 0
                  | <Interval Term 2> <Asterisk> <Factor> rank => -1
                  | <Interval Term 2> <Solidus> <Factor> rank => -2
                  | <Term> <Asterisk> <Interval Factor> rank => -3
<Interval Factor> ::= <Sign maybe> <Interval Primary> rank => 0
<Interval Qualifier maybe> ::= <Interval Qualifier> rank => 0
<Interval Qualifier maybe> ::= rank => -1
<Interval Primary> ::= <Value Expression Primary> <Interval Qualifier maybe> rank => 0
                     | <Interval Value Function> rank => -1
<Interval Value Expression 1> ::= <Interval Value Expression> rank => 0
<Interval Term 1> ::= <Interval Term> rank => 0
<Interval Term 2> ::= <Interval Term> rank => 0
<Interval Value Function> ::= <Interval Absolute Value Function> rank => 0
<Interval Absolute Value Function> ::= <Lex042> <Left Paren> <Interval Value Expression> <Right Paren> rank => 0
<Boolean Value Expression> ::= <Boolean Term> rank => 0
                             | <Boolean Value Expression> <Lex436> <Boolean Term> rank => -1
<Boolean Term> ::= <Boolean Factor> rank => 0
                 | <Boolean Term> <Lex293> <Boolean Factor> rank => -1
<Lex428 maybe> ::= <Lex428> rank => 0
<Lex428 maybe> ::= rank => -1
<Boolean Factor> ::= <Lex428 maybe> <Boolean Test> rank => 0
<Gen1444> ::= <Lex401> <Lex428 maybe> <Truth Value> rank => 0
<Gen1444 maybe> ::= <Gen1444> rank => 0
<Gen1444 maybe> ::= rank => -1
<Boolean Test> ::= <Boolean Primary> <Gen1444 maybe> rank => 0
<Truth Value> ::= <Lex509> rank => 0
                | <Lex369> rank => -1
                | <Lex512> rank => -2
<Boolean Primary> ::= <Predicate> rank => 0
                    | <Boolean Predicand> rank => -1
<Boolean Predicand> ::= <Parenthesized Boolean Value Expression> rank => 0
                      | <Nonparenthesized Value Expression Primary> rank => -1
<Parenthesized Boolean Value Expression> ::= <Left Paren> <Boolean Value Expression> <Right Paren> rank => 0
<Array Value Expression> ::= <Array Concatenation> rank => 0
                           | <Array Factor> rank => -1
<Array Concatenation> ::= <Array Value Expression 1> <Concatenation Operator> <Array Factor> rank => 0
<Array Value Expression 1> ::= <Array Value Expression> rank => 0
<Array Factor> ::= <Value Expression Primary> rank => 0
<Array Value Constructor> ::= <Array Value Constructor By Enumeration> rank => 0
                            | <Array Value Constructor By Query> rank => -1
<Array Value Constructor By Enumeration> ::= <Lex296> <Left Bracket Or Trigraph> <Array Element List> <Right Bracket Or Trigraph> rank => 0
<Gen1464> ::= <Comma> <Array Element> rank => 0
<Gen1464 any> ::= <Gen1464>* rank => 0
<Array Element List> ::= <Array Element> <Gen1464 any> rank => 0
<Array Element> ::= <Value Expression> rank => 0
<Order By Clause maybe> ::= <Order By Clause> rank => 0
<Order By Clause maybe> ::= rank => -1
<Array Value Constructor By Query> ::= <Lex296> <Left Paren> <Query Expression> <Order By Clause maybe> <Right Paren> rank => 0
<Gen1471> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Gen1473> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Multiset Value Expression> ::= <Multiset Term> rank => 0
                              | <Multiset Value Expression> <Lex420> <Lex510> <Gen1471> <Multiset Term> rank => -1
                              | <Multiset Value Expression> <Lex420> <Lex364> <Gen1473> <Multiset Term> rank => -2
<Gen1478> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Multiset Term> ::= <Multiset Primary> rank => 0
                  | <Multiset Term> <Lex420> <Lex398> <Gen1478> <Multiset Primary> rank => -1
<Multiset Primary> ::= <Multiset Value Function> rank => 0
                     | <Value Expression Primary> rank => -1
<Multiset Value Function> ::= <Multiset Set Function> rank => 0
<Multiset Set Function> ::= <Lex482> <Left Paren> <Multiset Value Expression> <Right Paren> rank => 0
<Multiset Value Constructor> ::= <Multiset Value Constructor By Enumeration> rank => 0
                               | <Multiset Value Constructor By Query> rank => -1
                               | <Table Value Constructor By Query> rank => -2
<Multiset Value Constructor By Enumeration> ::= <Lex420> <Left Bracket Or Trigraph> <Multiset Element List> <Right Bracket Or Trigraph> rank => 0
<Gen1490> ::= <Comma> <Multiset Element> rank => 0
<Gen1490 any> ::= <Gen1490>* rank => 0
<Multiset Element List> ::= <Multiset Element> <Gen1490 any> rank => 0
<Multiset Element> ::= <Value Expression> rank => 0
<Multiset Value Constructor By Query> ::= <Lex420> <Left Paren> <Query Expression> <Right Paren> rank => 0
<Table Value Constructor By Query> ::= <Lex498> <Left Paren> <Query Expression> <Right Paren> rank => 0
<Row Value Constructor> ::= <Common Value Expression> rank => 0
                          | <Boolean Value Expression> rank => -1
                          | <Explicit Row Value Constructor> rank => -2
<Explicit Row Value Constructor> ::= <Left Paren> <Row Value Constructor Element> <Comma> <Row Value Constructor Element List> <Right Paren> rank => 0
                                   | <Lex473> <Left Paren> <Row Value Constructor Element List> <Right Paren> rank => -1
                                   | <Row Subquery> rank => -2
<Gen1502> ::= <Comma> <Row Value Constructor Element> rank => 0
<Gen1502 any> ::= <Gen1502>* rank => 0
<Row Value Constructor Element List> ::= <Row Value Constructor Element> <Gen1502 any> rank => 0
<Row Value Constructor Element> ::= <Value Expression> rank => 0
<Contextually Typed Row Value Constructor> ::= <Common Value Expression> rank => 0
                                             | <Boolean Value Expression> rank => -1
                                             | <Contextually Typed Value Specification> rank => -2
                                             | <Left Paren> <Contextually Typed Row Value Constructor Element> <Comma> <Contextually Typed Row Value Constructor Element List> <Right Paren> rank => -3
                                             | <Lex473> <Left Paren> <Contextually Typed Row Value Constructor Element List> <Right Paren> rank => -4
<Gen1511> ::= <Comma> <Contextually Typed Row Value Constructor Element> rank => 0
<Gen1511 any> ::= <Gen1511>* rank => 0
<Contextually Typed Row Value Constructor Element List> ::= <Contextually Typed Row Value Constructor Element> <Gen1511 any> rank => 0
<Contextually Typed Row Value Constructor Element> ::= <Value Expression> rank => 0
                                                     | <Contextually Typed Value Specification> rank => -1
<Row Value Constructor Predicand> ::= <Common Value Expression> rank => 0
                                    | <Boolean Predicand> rank => -1
                                    | <Explicit Row Value Constructor> rank => -2
<Row Value Expression> ::= <Row Value Special Case> rank => 0
                         | <Explicit Row Value Constructor> rank => -1
<Table Row Value Expression> ::= <Row Value Special Case> rank => 0
                               | <Row Value Constructor> rank => -1
<Contextually Typed Row Value Expression> ::= <Row Value Special Case> rank => 0
                                            | <Contextually Typed Row Value Constructor> rank => -1
<Row Value Predicand> ::= <Row Value Special Case> rank => 0
                        | <Row Value Constructor Predicand> rank => -1
<Row Value Special Case> ::= <Nonparenthesized Value Expression Primary> rank => 0
<Table Value Constructor> ::= <Lex519> <Row Value Expression List> rank => 0
<Gen1529> ::= <Comma> <Table Row Value Expression> rank => 0
<Gen1529 any> ::= <Gen1529>* rank => 0
<Row Value Expression List> ::= <Table Row Value Expression> <Gen1529 any> rank => 0
<Contextually Typed Table Value Constructor> ::= <Lex519> <Contextually Typed Row Value Expression List> rank => 0
<Gen1533> ::= <Comma> <Contextually Typed Row Value Expression> rank => 0
<Gen1533 any> ::= <Gen1533>* rank => 0
<Contextually Typed Row Value Expression List> ::= <Contextually Typed Row Value Expression> <Gen1533 any> rank => 0
<Where Clause maybe> ::= <Where Clause> rank => 0
<Where Clause maybe> ::= rank => -1
<Group By Clause maybe> ::= <Group By Clause> rank => 0
<Group By Clause maybe> ::= rank => -1
<Having Clause maybe> ::= <Having Clause> rank => 0
<Having Clause maybe> ::= rank => -1
<Window Clause maybe> ::= <Window Clause> rank => 0
<Window Clause maybe> ::= rank => -1
<Table Expression> ::= <From Clause> <Where Clause maybe> <Group By Clause maybe> <Having Clause maybe> <Window Clause maybe> rank => 0
<From Clause> ::= <Lex376> <Table Reference List> rank => 0
<Gen1546> ::= <Comma> <Table Reference> rank => 0
<Gen1546 any> ::= <Gen1546>* rank => 0
<Table Reference List> ::= <Table Reference> <Gen1546 any> rank => 0
<Sample Clause maybe> ::= <Sample Clause> rank => 0
<Sample Clause maybe> ::= rank => -1
<Table Reference> ::= <Table Primary Or Joined Table> <Sample Clause maybe> rank => 0
<Table Primary Or Joined Table> ::= <Table Primary> rank => 0
                                  | <Joined Table> rank => -1
<Repeatable Clause maybe> ::= <Repeatable Clause> rank => 0
<Repeatable Clause maybe> ::= rank => -1
<Sample Clause> ::= <Lex259> <Sample Method> <Left Paren> <Sample Percentage> <Right Paren> <Repeatable Clause maybe> rank => 0
<Sample Method> ::= <Lex056> rank => 0
                  | <Lex496> rank => -1
<Repeatable Clause> ::= <Lex217> <Left Paren> <Repeat Argument> <Right Paren> rank => 0
<Sample Percentage> ::= <Numeric Value Expression> rank => 0
<Repeat Argument> ::= <Numeric Value Expression> rank => 0
<Lex297 maybe> ::= <Lex297> rank => 0
<Lex297 maybe> ::= rank => -1
<Gen1564> ::= <Left Paren> <Derived Column List> <Right Paren> rank => 0
<Gen1564 maybe> ::= <Gen1564> rank => 0
<Gen1564 maybe> ::= rank => -1
<Gen1567> ::= <Lex297 maybe> <Correlation Name> <Gen1564 maybe> rank => 0
<Gen1567 maybe> ::= <Gen1567> rank => 0
<Gen1567 maybe> ::= rank => -1
<Gen1570> ::= <Left Paren> <Derived Column List> <Right Paren> rank => 0
<Gen1570 maybe> ::= <Gen1570> rank => 0
<Gen1570 maybe> ::= rank => -1
<Gen1573> ::= <Left Paren> <Derived Column List> <Right Paren> rank => 0
<Gen1573 maybe> ::= <Gen1573> rank => 0
<Gen1573 maybe> ::= rank => -1
<Gen1576> ::= <Left Paren> <Derived Column List> <Right Paren> rank => 0
<Gen1576 maybe> ::= <Gen1576> rank => 0
<Gen1576 maybe> ::= rank => -1
<Gen1579> ::= <Left Paren> <Derived Column List> <Right Paren> rank => 0
<Gen1579 maybe> ::= <Gen1579> rank => 0
<Gen1579 maybe> ::= rank => -1
<Gen1582> ::= <Left Paren> <Derived Column List> <Right Paren> rank => 0
<Gen1582 maybe> ::= <Gen1582> rank => 0
<Gen1582 maybe> ::= rank => -1
<Gen1585> ::= <Lex297 maybe> <Correlation Name> <Gen1582 maybe> rank => 0
<Gen1585 maybe> ::= <Gen1585> rank => 0
<Gen1585 maybe> ::= rank => -1
<Table Primary> ::= <Table Or Query Name> <Gen1567 maybe> rank => 0
                  | <Derived Table> <Lex297 maybe> <Correlation Name> <Gen1570 maybe> rank => -1
                  | <Lateral Derived Table> <Lex297 maybe> <Correlation Name> <Gen1573 maybe> rank => -2
                  | <Collection Derived Table> <Lex297 maybe> <Correlation Name> <Gen1576 maybe> rank => -3
                  | <Table Function Derived Table> <Lex297 maybe> <Correlation Name> <Gen1579 maybe> rank => -4
                  | <Only Spec> <Gen1585 maybe> rank => -5
                  | <Left Paren> <Joined Table> <Right Paren> rank => -6
<Only Spec> ::= <Lex434> <Left Paren> <Table Or Query Name> <Right Paren> rank => 0
<Lateral Derived Table> ::= <Lex405> <Table Subquery> rank => 0
<Gen1597> ::= <Lex529> <Lex188> rank => 0
<Gen1597 maybe> ::= <Gen1597> rank => 0
<Gen1597 maybe> ::= rank => -1
<Collection Derived Table> ::= <Lex513> <Left Paren> <Collection Value Expression> <Right Paren> <Gen1597 maybe> rank => 0
<Table Function Derived Table> ::= <Lex498> <Left Paren> <Collection Value Expression> <Right Paren> rank => 0
<Derived Table> ::= <Table Subquery> rank => 0
<Table Or Query Name> ::= <Table Name> rank => 0
                        | <Query Name> rank => -1
<Derived Column List> ::= <Column Name List> rank => 0
<Gen1606> ::= <Comma> <Column Name> rank => 0
<Gen1606 any> ::= <Gen1606>* rank => 0
<Column Name List> ::= <Column Name> <Gen1606 any> rank => 0
<Joined Table> ::= <Cross Join> rank => 0
                 | <Qualified Join> rank => -1
                 | <Natural Join> rank => -2
                 | <Union Join> rank => -3
<Cross Join> ::= <Table Reference> <Lex329> <Lex402> <Table Primary> rank => 0
<Join Type maybe> ::= <Join Type> rank => 0
<Join Type maybe> ::= rank => -1
<Qualified Join> ::= <Table Reference> <Join Type maybe> <Lex402> <Table Reference> <Join Specification> rank => 0
<Natural Join> ::= <Table Reference> <Lex422> <Join Type maybe> <Lex402> <Table Primary> rank => 0
<Union Join> ::= <Table Reference> <Lex510> <Lex402> <Table Primary> rank => 0
<Join Specification> ::= <Join Condition> rank => 0
                       | <Named Columns Join> rank => -1
<Join Condition> ::= <Lex433> <Search Condition> rank => 0
<Named Columns Join> ::= <Lex517> <Left Paren> <Join Column List> <Right Paren> rank => 0
<Lex439 maybe> ::= <Lex439> rank => 0
<Lex439 maybe> ::= rank => -1
<Join Type> ::= <Lex391> rank => 0
              | <Outer Join Type> <Lex439 maybe> rank => -1
<Outer Join Type> ::= <Lex407> rank => 0
                    | <Lex470> rank => -1
                    | <Lex377> rank => -2
<Join Column List> ::= <Column Name List> rank => 0
<Where Clause> ::= <Lex526> <Search Condition> rank => 0
<Set Quantifier maybe> ::= <Set Quantifier> rank => 0
<Set Quantifier maybe> ::= rank => -1
<Group By Clause> ::= <Lex382> <Lex310> <Set Quantifier maybe> <Grouping Element List> rank => 0
<Gen1635> ::= <Comma> <Grouping Element> rank => 0
<Gen1635 any> ::= <Gen1635>* rank => 0
<Grouping Element List> ::= <Grouping Element> <Gen1635 any> rank => 0
<Grouping Element> ::= <Ordinary Grouping Set> rank => 0
                     | <Rollup List> rank => -1
                     | <Cube List> rank => -2
                     | <Grouping Sets Specification> rank => -3
                     | <Empty Grouping Set> rank => -4
<Ordinary Grouping Set> ::= <Grouping Column Reference> rank => 0
                          | <Left Paren> <Grouping Column Reference List> <Right Paren> rank => -1
<Grouping Column Reference> ::= <Column Reference> <Collate Clause maybe> rank => 0
<Gen1646> ::= <Comma> <Grouping Column Reference> rank => 0
<Gen1646 any> ::= <Gen1646>* rank => 0
<Grouping Column Reference List> ::= <Grouping Column Reference> <Gen1646 any> rank => 0
<Rollup List> ::= <Lex472> <Left Paren> <Ordinary Grouping Set List> <Right Paren> rank => 0
<Gen1650> ::= <Comma> <Ordinary Grouping Set> rank => 0
<Gen1650 any> ::= <Gen1650>* rank => 0
<Ordinary Grouping Set List> ::= <Ordinary Grouping Set> <Gen1650 any> rank => 0
<Cube List> ::= <Lex330> <Left Paren> <Ordinary Grouping Set List> <Right Paren> rank => 0
<Grouping Sets Specification> ::= <Lex383> <Lex243> <Left Paren> <Grouping Set List> <Right Paren> rank => 0
<Gen1655> ::= <Comma> <Grouping Set> rank => 0
<Gen1655 any> ::= <Gen1655>* rank => 0
<Grouping Set List> ::= <Grouping Set> <Gen1655 any> rank => 0
<Grouping Set> ::= <Ordinary Grouping Set> rank => 0
                 | <Rollup List> rank => -1
                 | <Cube List> rank => -2
                 | <Grouping Sets Specification> rank => -3
                 | <Empty Grouping Set> rank => -4
<Empty Grouping Set> ::= <Left Paren> <Right Paren> rank => 0
<Having Clause> ::= <Lex384> <Search Condition> rank => 0
<Window Clause> ::= <Lex528> <Window Definition List> rank => 0
<Gen1666> ::= <Comma> <Window Definition> rank => 0
<Gen1666 any> ::= <Gen1666>* rank => 0
<Window Definition List> ::= <Window Definition> <Gen1666 any> rank => 0
<Window Definition> ::= <New Window Name> <Lex297> <Window Specification> rank => 0
<New Window Name> ::= <Window Name> rank => 0
<Window Specification> ::= <Left Paren> <Window Specification Details> <Right Paren> rank => 0
<Existing Window Name maybe> ::= <Existing Window Name> rank => 0
<Existing Window Name maybe> ::= rank => -1
<Window Partition Clause maybe> ::= <Window Partition Clause> rank => 0
<Window Partition Clause maybe> ::= rank => -1
<Window Order Clause maybe> ::= <Window Order Clause> rank => 0
<Window Order Clause maybe> ::= rank => -1
<Window Frame Clause maybe> ::= <Window Frame Clause> rank => 0
<Window Frame Clause maybe> ::= rank => -1
<Window Specification Details> ::= <Existing Window Name maybe> <Window Partition Clause maybe> <Window Order Clause maybe> <Window Frame Clause maybe> rank => 0
<Existing Window Name> ::= <Window Name> rank => 0
<Window Partition Clause> ::= <Lex444> <Lex310> <Window Partition Column Reference List> rank => 0
<Gen1683> ::= <Comma> <Window Partition Column Reference> rank => 0
<Gen1683 any> ::= <Gen1683>* rank => 0
<Window Partition Column Reference List> ::= <Window Partition Column Reference> <Gen1683 any> rank => 0
<Window Partition Column Reference> ::= <Column Reference> <Collate Clause maybe> rank => 0
<Window Order Clause> ::= <Lex437> <Lex310> <Sort Specification List> rank => 0
<Window Frame Exclusion maybe> ::= <Window Frame Exclusion> rank => 0
<Window Frame Exclusion maybe> ::= rank => -1
<Window Frame Clause> ::= <Window Frame Units> <Window Frame Extent> <Window Frame Exclusion maybe> rank => 0
<Window Frame Units> ::= <Lex474> rank => 0
                       | <Lex449> rank => -1
<Window Frame Extent> ::= <Window Frame Start> rank => 0
                        | <Window Frame Between> rank => -1
<Window Frame Start> ::= <Lex276> <Lex209> rank => 0
                       | <Window Frame Preceding> rank => -1
                       | <Lex331> <Lex473> rank => -2
<Window Frame Preceding> ::= <Unsigned Value Specification> <Lex209> rank => 0
<Window Frame Between> ::= <Lex304> <Window Frame Bound 1> <Lex293> <Window Frame Bound 2> rank => 0
<Window Frame Bound 1> ::= <Window Frame Bound> rank => 0
<Window Frame Bound 2> ::= <Window Frame Bound> rank => 0
<Window Frame Bound> ::= <Window Frame Start> rank => 0
                       | <Lex276> <Lex133> rank => -1
                       | <Window Frame Following> rank => -2
<Window Frame Following> ::= <Unsigned Value Specification> <Lex133> rank => 0
<Window Frame Exclusion> ::= <Lex126> <Lex331> <Lex473> rank => 0
                           | <Lex126> <Lex382> rank => -1
                           | <Lex126> <Lex262> rank => -2
                           | <Lex126> <Lex426> <Lex189> rank => -3
<Query Specification> ::= <Lex479> <Set Quantifier maybe> <Select List> <Table Expression> rank => 0
<Gen1711> ::= <Comma> <Select Sublist> rank => 0
<Gen1711 any> ::= <Gen1711>* rank => 0
<Select List> ::= <Asterisk> rank => 0
                | <Select Sublist> <Gen1711 any> rank => -1
<Select Sublist> ::= <Derived Column> rank => 0
                   | <Qualified Asterisk> rank => -1
<Qualified Asterisk> ::= <Asterisked Identifier Chain> <Period> <Asterisk> rank => 0
                       | <All Fields Reference> rank => -1
<Gen1719> ::= <Period> <Asterisked Identifier> rank => 0
<Gen1719 any> ::= <Gen1719>* rank => 0
<Asterisked Identifier Chain> ::= <Asterisked Identifier> <Gen1719 any> rank => 0
<Asterisked Identifier> ::= <Identifier> rank => 0
<As Clause maybe> ::= <As Clause> rank => 0
<As Clause maybe> ::= rank => -1
<Derived Column> ::= <Value Expression> <As Clause maybe> rank => 0
<As Clause> ::= <Lex297 maybe> <Column Name> rank => 0
<Gen1727> ::= <Lex297> <Left Paren> <All Fields Column Name List> <Right Paren> rank => 0
<Gen1727 maybe> ::= <Gen1727> rank => 0
<Gen1727 maybe> ::= rank => -1
<All Fields Reference> ::= <Value Expression Primary> <Period> <Asterisk> <Gen1727 maybe> rank => 0
<All Fields Column Name List> ::= <Column Name List> rank => 0
<With Clause maybe> ::= <With Clause> rank => 0
<With Clause maybe> ::= rank => -1
<Query Expression> ::= <With Clause maybe> <Query Expression Body> rank => 0
<Lex452 maybe> ::= <Lex452> rank => 0
<Lex452 maybe> ::= rank => -1
<With Clause> ::= <Lex529> <Lex452 maybe> <With List> rank => 0
<Gen1738> ::= <Comma> <With List Element> rank => 0
<Gen1738 any> ::= <Gen1738>* rank => 0
<With List> ::= <With List Element> <Gen1738 any> rank => 0
<Gen1741> ::= <Left Paren> <With Column List> <Right Paren> rank => 0
<Gen1741 maybe> ::= <Gen1741> rank => 0
<Gen1741 maybe> ::= rank => -1
<Search Or Cycle Clause maybe> ::= <Search Or Cycle Clause> rank => 0
<Search Or Cycle Clause maybe> ::= rank => -1
<With List Element> ::= <Query Name> <Gen1741 maybe> <Lex297> <Left Paren> <Query Expression> <Right Paren> <Search Or Cycle Clause maybe> rank => 0
<With Column List> ::= <Column Name List> rank => 0
<Query Expression Body> ::= <Non Join Query Expression> rank => 0
                          | <Joined Table> rank => -1
<Gen1750> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Gen1750 maybe> ::= <Gen1750> rank => 0
<Gen1750 maybe> ::= rank => -1
<Corresponding Spec maybe> ::= <Corresponding Spec> rank => 0
<Corresponding Spec maybe> ::= rank => -1
<Gen1756> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Gen1756 maybe> ::= <Gen1756> rank => 0
<Gen1756 maybe> ::= rank => -1
<Non Join Query Expression> ::= <Non Join Query Term> rank => 0
                              | <Query Expression Body> <Lex510> <Gen1750 maybe> <Corresponding Spec maybe> <Query Term> rank => -1
                              | <Query Expression Body> <Lex364> <Gen1756 maybe> <Corresponding Spec maybe> <Query Term> rank => -2
<Query Term> ::= <Non Join Query Term> rank => 0
               | <Joined Table> rank => -1
<Gen1765> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Gen1765 maybe> ::= <Gen1765> rank => 0
<Gen1765 maybe> ::= rank => -1
<Non Join Query Term> ::= <Non Join Query Primary> rank => 0
                        | <Query Term> <Lex398> <Gen1765 maybe> <Corresponding Spec maybe> <Query Primary> rank => -1
<Query Primary> ::= <Non Join Query Primary> rank => 0
                  | <Joined Table> rank => -1
<Non Join Query Primary> ::= <Simple Table> rank => 0
                           | <Left Paren> <Non Join Query Expression> <Right Paren> rank => -1
<Simple Table> ::= <Query Specification> rank => 0
                 | <Table Value Constructor> rank => -1
                 | <Explicit Table> rank => -2
<Explicit Table> ::= <Lex498> <Table Or Query Name> rank => 0
<Gen1779> ::= <Lex310> <Left Paren> <Corresponding Column List> <Right Paren> rank => 0
<Gen1779 maybe> ::= <Gen1779> rank => 0
<Gen1779 maybe> ::= rank => -1
<Corresponding Spec> ::= <Lex327> <Gen1779 maybe> rank => 0
<Corresponding Column List> ::= <Column Name List> rank => 0
<Search Or Cycle Clause> ::= <Search Clause> rank => 0
                           | <Cycle Clause> rank => -1
                           | <Search Clause> <Cycle Clause> rank => -2
<Search Clause> ::= <Lex477> <Recursive Search Order> <Lex482> <Sequence Column> rank => 0
<Recursive Search Order> ::= <Lex114> <Lex131> <Lex310> <Sort Specification List> rank => 0
                           | <Lex057> <Lex131> <Lex310> <Sort Specification List> rank => -1
<Sequence Column> ::= <Column Name> rank => 0
<Cycle Clause> ::= <Lex341> <Cycle Column List> <Lex482> <Cycle Mark Column> <Lex504> <Cycle Mark Value> <Lex348> <Non Cycle Mark Value> <Lex517> <Path Column> rank => 0
<Gen1792> ::= <Comma> <Cycle Column> rank => 0
<Gen1792 any> ::= <Gen1792>* rank => 0
<Cycle Column List> ::= <Cycle Column> <Gen1792 any> rank => 0
<Cycle Column> ::= <Column Name> rank => 0
<Cycle Mark Column> ::= <Column Name> rank => 0
<Path Column> ::= <Column Name> rank => 0
<Cycle Mark Value> ::= <Value Expression> rank => 0
<Non Cycle Mark Value> ::= <Value Expression> rank => 0
<Scalar Subquery> ::= <Subquery> rank => 0
<Row Subquery> ::= <Subquery> rank => 0
<Table Subquery> ::= <Subquery> rank => 0
<Subquery> ::= <Left Paren> <Query Expression> <Right Paren> rank => 0
<Predicate> ::= <Comparison Predicate> rank => 0
              | <Between Predicate> rank => -1
              | <In Predicate> rank => -2
              | <Like Predicate> rank => -3
              | <Similar Predicate> rank => -4
              | <Null Predicate> rank => -5
              | <Quantified Comparison Predicate> rank => -6
              | <Exists Predicate> rank => -7
              | <Unique Predicate> rank => -8
              | <Normalized Predicate> rank => -9
              | <Match Predicate> rank => -10
              | <Overlaps Predicate> rank => -11
              | <Distinct Predicate> rank => -12
              | <Member Predicate> rank => -13
              | <Submultiset Predicate> rank => -14
              | <Set Predicate> rank => -15
              | <Type Predicate> rank => -16
<Comparison Predicate> ::= <Row Value Predicand> <Comparison Predicate Part 2> rank => 0
<Comparison Predicate Part 2> ::= <Comp Op> <Row Value Predicand> rank => 0
<Comp Op> ::= <Equals Operator> rank => 0
            | <Not Equals Operator> rank => -1
            | <Less Than Operator> rank => -2
            | <Greater Than Operator> rank => -3
            | <Less Than Or Equals Operator> rank => -4
            | <Greater Than Or Equals Operator> rank => -5
<Between Predicate> ::= <Row Value Predicand> <Between Predicate Part 2> rank => 0
<Gen1830> ::= <Lex299> rank => 0
            | <Lex495> rank => -1
<Gen1830 maybe> ::= <Gen1830> rank => 0
<Gen1830 maybe> ::= rank => -1
<Between Predicate Part 2> ::= <Lex428 maybe> <Lex304> <Gen1830 maybe> <Row Value Predicand> <Lex293> <Row Value Predicand> rank => 0
<In Predicate> ::= <Row Value Predicand> <In Predicate Part 2> rank => 0
<In Predicate Part 2> ::= <Lex428 maybe> <Lex389> <In Predicate Value> rank => 0
<In Predicate Value> ::= <Table Subquery> rank => 0
                       | <Left Paren> <In Value List> <Right Paren> rank => -1
<Gen1839> ::= <Comma> <Row Value Expression> rank => 0
<Gen1839 any> ::= <Gen1839>* rank => 0
<In Value List> ::= <Row Value Expression> <Gen1839 any> rank => 0
<Like Predicate> ::= <Character Like Predicate> rank => 0
                   | <Octet Like Predicate> rank => -1
<Character Like Predicate> ::= <Row Value Predicand> <Character Like Predicate Part 2> rank => 0
<Gen1845> ::= <Lex363> <Escape Character> rank => 0
<Gen1845 maybe> ::= <Gen1845> rank => 0
<Gen1845 maybe> ::= rank => -1
<Character Like Predicate Part 2> ::= <Lex428 maybe> <Lex408> <Character Pattern> <Gen1845 maybe> rank => 0
<Character Pattern> ::= <Character Value Expression> rank => 0
<Escape Character> ::= <Character Value Expression> rank => 0
<Octet Like Predicate> ::= <Row Value Predicand> <Octet Like Predicate Part 2> rank => 0
<Gen1852> ::= <Lex363> <Escape Octet> rank => 0
<Gen1852 maybe> ::= <Gen1852> rank => 0
<Gen1852 maybe> ::= rank => -1
<Octet Like Predicate Part 2> ::= <Lex428 maybe> <Lex408> <Octet Pattern> <Gen1852 maybe> rank => 0
<Octet Pattern> ::= <Blob Value Expression> rank => 0
<Escape Octet> ::= <Blob Value Expression> rank => 0
<Similar Predicate> ::= <Row Value Predicand> <Similar Predicate Part 2> rank => 0
<Gen1859> ::= <Lex363> <Escape Character> rank => 0
<Gen1859 maybe> ::= <Gen1859> rank => 0
<Gen1859 maybe> ::= rank => -1
<Similar Predicate Part 2> ::= <Lex428 maybe> <Lex483> <Lex504> <Similar Pattern> <Gen1859 maybe> rank => 0
<Similar Pattern> ::= <Character Value Expression> rank => 0
<Regular Expression> ::= <Regular Term> rank => 0
                       | <Regular Expression> <Vertical Bar> <Regular Term> rank => -1
<Regular Term> ::= <Regular Factor> rank => 0
                 | <Regular Term> <Regular Factor> rank => -1
<Regular Factor> ::= <Regular Primary> rank => 0
                   | <Regular Primary> <Asterisk> rank => -1
                   | <Regular Primary> <Plus Sign> rank => -2
                   | <Regular Primary> <Question Mark> rank => -3
                   | <Regular Primary> <Repeat Factor> rank => -4
<Upper Limit maybe> ::= <Upper Limit> rank => 0
<Upper Limit maybe> ::= rank => -1
<Repeat Factor> ::= <Left Brace> <Low Value> <Upper Limit maybe> <Right Brace> rank => 0
<High Value maybe> ::= <High Value> rank => 0
<High Value maybe> ::= rank => -1
<Upper Limit> ::= <Comma> <High Value maybe> rank => 0
<Low Value> ::= <Unsigned Integer> rank => 0
<High Value> ::= <Unsigned Integer> rank => 0
<Regular Primary> ::= <Character Specifier> rank => 0
                    | <Percent> rank => -1
                    | <Regular Character Set> rank => -2
                    | <Left Paren> <Regular Expression> <Right Paren> rank => -3
<Character Specifier> ::= <Non Escaped Character> rank => 0
                        | <Escaped Character> rank => -1
<Non Escaped Character> ::= <Lex548> rank => 0
<Escaped Character> ::= <Lex549> <Lex550> rank => 0
<Character Enumeration many> ::= <Character Enumeration>+ rank => 0
<Character Enumeration Include many> ::= <Character Enumeration Include>+ rank => 0
<Character Enumeration Exclude many> ::= <Character Enumeration Exclude>+ rank => 0
<Regular Character Set> ::= <Underscore> rank => 0
                          | <Left Bracket> <Character Enumeration many> <Right Bracket> rank => -1
                          | <Left Bracket> <Circumflex> <Character Enumeration many> <Right Bracket> rank => -2
                          | <Left Bracket> <Character Enumeration Include many> <Circumflex> <Character Enumeration Exclude many> <Right Bracket> rank => -3
<Character Enumeration Include> ::= <Character Enumeration> rank => 0
<Character Enumeration Exclude> ::= <Character Enumeration> rank => 0
<Character Enumeration> ::= <Character Specifier> rank => 0
                          | <Character Specifier> <Minus Sign> <Character Specifier> rank => -1
                          | <Left Bracket> <Colon> <Regular Character Set Identifier> <Colon> <Right Bracket> rank => -2
<Regular Character Set Identifier> ::= <Identifier> rank => 0
<Null Predicate> ::= <Row Value Predicand> <Null Predicate Part 2> rank => 0
<Null Predicate Part 2> ::= <Lex401> <Lex428 maybe> <Lex429> rank => 0
<Quantified Comparison Predicate> ::= <Row Value Predicand> <Quantified Comparison Predicate Part 2> rank => 0
<Quantified Comparison Predicate Part 2> ::= <Comp Op> <Quantifier> <Table Subquery> rank => 0
<Quantifier> ::= <All> rank => 0
               | <Some> rank => -1
<All> ::= <Lex290> rank => 0
<Some> ::= <Lex485> rank => 0
         | <Lex294> rank => -1
<Exists Predicate> ::= <Lex367> <Table Subquery> rank => 0
<Unique Predicate> ::= <Lex511> <Table Subquery> rank => 0
<Normalized Predicate> ::= <String Value Expression> <Lex401> <Lex428 maybe> <Lex177> rank => 0
<Match Predicate> ::= <Row Value Predicand> <Match Predicate Part 2> rank => 0
<Lex511 maybe> ::= <Lex511> rank => 0
<Lex511 maybe> ::= rank => -1
<Gen1917> ::= <Lex244> rank => 0
            | <Lex199> rank => -1
            | <Lex377> rank => -2
<Gen1917 maybe> ::= <Gen1917> rank => 0
<Gen1917 maybe> ::= rank => -1
<Match Predicate Part 2> ::= <Lex412> <Lex511 maybe> <Gen1917 maybe> <Table Subquery> rank => 0
<Overlaps Predicate> ::= <Overlaps Predicate Part 1> <Overlaps Predicate Part 2> rank => 0
<Overlaps Predicate Part 1> ::= <Row Value Predicand 1> rank => 0
<Overlaps Predicate Part 2> ::= <Lex442> <Row Value Predicand 2> rank => 0
<Row Value Predicand 1> ::= <Row Value Predicand> rank => 0
<Row Value Predicand 2> ::= <Row Value Predicand> rank => 0
<Distinct Predicate> ::= <Row Value Predicand 3> <Distinct Predicate Part 2> rank => 0
<Distinct Predicate Part 2> ::= <Lex401> <Lex354> <Lex376> <Row Value Predicand 4> rank => 0
<Row Value Predicand 3> ::= <Row Value Predicand> rank => 0
<Row Value Predicand 4> ::= <Row Value Predicand> rank => 0
<Member Predicate> ::= <Row Value Predicand> <Member Predicate Part 2> rank => 0
<Lex431 maybe> ::= <Lex431> rank => 0
<Lex431 maybe> ::= rank => -1
<Member Predicate Part 2> ::= <Lex428 maybe> <Lex413> <Lex431 maybe> <Multiset Value Expression> rank => 0
<Submultiset Predicate> ::= <Row Value Predicand> <Submultiset Predicate Part 2> rank => 0
<Submultiset Predicate Part 2> ::= <Lex428 maybe> <Lex494> <Lex431 maybe> <Multiset Value Expression> rank => 0
<Set Predicate> ::= <Row Value Predicand> <Set Predicate Part 2> rank => 0
<Set Predicate Part 2> ::= <Lex401> <Lex428 maybe> <Lex041> <Lex482> rank => 0
<Type Predicate> ::= <Row Value Predicand> <Type Predicate Part 2> rank => 0
<Type Predicate Part 2> ::= <Lex401> <Lex428 maybe> <Lex431> <Left Paren> <Type List> <Right Paren> rank => 0
<Gen1942> ::= <Comma> <User Defined Type Specification> rank => 0
<Gen1942 any> ::= <Gen1942>* rank => 0
<Type List> ::= <User Defined Type Specification> <Gen1942 any> rank => 0
<User Defined Type Specification> ::= <Inclusive User Defined Type Specification> rank => 0
                                    | <Exclusive User Defined Type Specification> rank => -1
<Inclusive User Defined Type Specification> ::= <Path Resolved User Defined Type Name> rank => 0
<Exclusive User Defined Type Specification> ::= <Lex434> <Path Resolved User Defined Type Name> rank => 0
<Search Condition> ::= <Boolean Value Expression> rank => 0
<Interval Qualifier> ::= <Start Field> <Lex504> <End Field> rank => 0
                       | <Single Datetime Field> rank => -1
<Gen1952> ::= <Left Paren> <Interval Leading Field Precision> <Right Paren> rank => 0
<Gen1952 maybe> ::= <Gen1952> rank => 0
<Gen1952 maybe> ::= rank => -1
<Start Field> ::= <Non Second Primary Datetime Field> <Gen1952 maybe> rank => 0
<Gen1956> ::= <Left Paren> <Interval Fractional Seconds Precision> <Right Paren> rank => 0
<Gen1956 maybe> ::= <Gen1956> rank => 0
<Gen1956 maybe> ::= rank => -1
<End Field> ::= <Non Second Primary Datetime Field> rank => 0
              | <Lex478> <Gen1956 maybe> rank => -1
<Gen1961> ::= <Left Paren> <Interval Leading Field Precision> <Right Paren> rank => 0
<Gen1961 maybe> ::= <Gen1961> rank => 0
<Gen1961 maybe> ::= rank => -1
<Gen1964> ::= <Comma> <Interval Fractional Seconds Precision> rank => 0
<Gen1964 maybe> ::= <Gen1964> rank => 0
<Gen1964 maybe> ::= rank => -1
<Gen1967> ::= <Left Paren> <Interval Leading Field Precision> <Gen1964 maybe> <Right Paren> rank => 0
<Gen1967 maybe> ::= <Gen1967> rank => 0
<Gen1967 maybe> ::= rank => -1
<Single Datetime Field> ::= <Non Second Primary Datetime Field> <Gen1961 maybe> rank => 0
                          | <Lex478> <Gen1967 maybe> rank => -1
<Primary Datetime Field> ::= <Non Second Primary Datetime Field> rank => 0
                           | <Lex478> rank => -1
<Non Second Primary Datetime Field> ::= <Lex532> rank => 0
                                      | <Lex419> rank => -1
                                      | <Lex343> rank => -2
                                      | <Lex386> rank => -3
                                      | <Lex416> rank => -4
<Interval Fractional Seconds Precision> ::= <Unsigned Integer> rank => 0
<Interval Leading Field Precision> ::= <Unsigned Integer> rank => 0
<Language Clause> ::= <Lex403> <Language Name> rank => 0
<Language Name> ::= <Lex045> rank => 0
                  | <Lex058> rank => -1
                  | <Lex076> rank => -2
                  | <Lex134> rank => -3
                  | <Lex171> rank => -4
                  | <Lex200> rank => -5
                  | <Lex206> rank => -6
                  | <Lex488> rank => -7
<Path Specification> ::= <Lex201> <Schema Name List> rank => 0
<Gen1991> ::= <Comma> <Schema Name> rank => 0
<Gen1991 any> ::= <Gen1991>* rank => 0
<Schema Name List> ::= <Schema Name> <Gen1991 any> rank => 0
<Routine Invocation> ::= <Routine Name> <SQL Argument List> rank => 0
<Gen1995> ::= <Schema Name> <Period> rank => 0
<Gen1995 maybe> ::= <Gen1995> rank => 0
<Gen1995 maybe> ::= rank => -1
<Routine Name> ::= <Gen1995 maybe> <Qualified Identifier> rank => 0
<Gen1999> ::= <Comma> <SQL Argument> rank => 0
<Gen1999 any> ::= <Gen1999>* rank => 0
<Gen2001> ::= <SQL Argument> <Gen1999 any> rank => 0
<Gen2001 maybe> ::= <Gen2001> rank => 0
<Gen2001 maybe> ::= rank => -1
<SQL Argument List> ::= <Left Paren> <Gen2001 maybe> <Right Paren> rank => 0
<SQL Argument> ::= <Value Expression> rank => 0
                 | <Generalized Expression> rank => -1
                 | <Target Specification> rank => -2
<Generalized Expression> ::= <Value Expression> <Lex297> <Path Resolved User Defined Type Name> rank => 0
<Character Set Specification> ::= <Standard Character Set Name> rank => 0
                                | <Implementation Defined Character Set Name> rank => -1
                                | <User Defined Character Set Name> rank => -2
<Standard Character Set Name> ::= <Character Set Name> rank => 0
<Implementation Defined Character Set Name> ::= <Character Set Name> rank => 0
<User Defined Character Set Name> ::= <Character Set Name> rank => 0
<Gen2015> ::= <Lex373> <Schema Resolved User Defined Type Name> rank => 0
<Gen2015 maybe> ::= <Gen2015> rank => 0
<Gen2015 maybe> ::= rank => -1
<Specific Routine Designator> ::= <Lex486> <Routine Type> <Specific Name> rank => 0
                                | <Routine Type> <Member Name> <Gen2015 maybe> rank => -1
<Gen2020> ::= <Lex146> rank => 0
            | <Lex493> rank => -1
            | <Lex551> rank => -2
<Gen2020 maybe> ::= <Gen2020> rank => 0
<Gen2020 maybe> ::= rank => -1
<Routine Type> ::= <Lex224> rank => 0
                 | <Lex378> rank => -1
                 | <Lex448> rank => -2
                 | <Gen2020 maybe> <Lex415> rank => -3
<Data Type List maybe> ::= <Data Type List> rank => 0
<Data Type List maybe> ::= rank => -1
<Member Name> ::= <Member Name Alternatives> <Data Type List maybe> rank => 0
<Member Name Alternatives> ::= <Schema Qualified Routine Name> rank => 0
                             | <Method Name> rank => -1
<Gen2034> ::= <Comma> <Data Type> rank => 0
<Gen2034 any> ::= <Gen2034>* rank => 0
<Gen2036> ::= <Data Type> <Gen2034 any> rank => 0
<Gen2036 maybe> ::= <Gen2036> rank => 0
<Gen2036 maybe> ::= rank => -1
<Data Type List> ::= <Left Paren> <Gen2036 maybe> <Right Paren> rank => 0
<Collate Clause> ::= <Lex321> <Collation Name> rank => 0
<Constraint Name Definition> ::= <Lex325> <Constraint Name> rank => 0
<Gen2042> ::= <Lex428 maybe> <Lex108> rank => 0
<Gen2042 maybe> ::= <Gen2042> rank => 0
<Gen2042 maybe> ::= rank => -1
<Constraint Check Time maybe> ::= <Constraint Check Time> rank => 0
<Constraint Check Time maybe> ::= rank => -1
<Constraint Characteristics> ::= <Constraint Check Time> <Gen2042 maybe> rank => 0
                               | <Lex428 maybe> <Lex108> <Constraint Check Time maybe> rank => -1
<Constraint Check Time> ::= <Lex145> <Lex109> rank => 0
                          | <Lex145> <Lex388> rank => -1
<Filter Clause maybe> ::= <Filter Clause> rank => 0
<Filter Clause maybe> ::= rank => -1
<Aggregate Function> ::= <Lex098> <Left Paren> <Asterisk> <Right Paren> <Filter Clause maybe> rank => 0
                       | <General Set Function> <Filter Clause maybe> rank => -1
                       | <Binary Set Function> <Filter Clause maybe> rank => -2
                       | <Ordered Set Function> <Filter Clause maybe> rank => -3
<General Set Function> ::= <Set Function Type> <Left Paren> <Set Quantifier maybe> <Value Expression> <Right Paren> rank => 0
<Set Function Type> ::= <Computational Operation> rank => 0
<Computational Operation> ::= <Lex054> rank => 0
                            | <Lex162> rank => -1
                            | <Lex167> rank => -2
                            | <Lex258> rank => -3
                            | <Lex124> rank => -4
                            | <Lex294> rank => -5
                            | <Lex485> rank => -6
                            | <Lex098> rank => -7
                            | <Lex252> rank => -8
                            | <Lex253> rank => -9
                            | <Lex521> rank => -10
                            | <Lex520> rank => -11
                            | <Lex082> rank => -12
                            | <Lex136> rank => -13
                            | <Lex148> rank => -14
<Set Quantifier> ::= <Lex354> rank => 0
                   | <Lex290> rank => -1
<Filter Clause> ::= <Lex371> <Left Paren> <Lex526> <Search Condition> <Right Paren> rank => 0
<Binary Set Function> ::= <Binary Set Function Type> <Left Paren> <Dependent Variable Expression> <Comma> <Independent Variable Expression> <Right Paren> rank => 0
<Binary Set Function Type> ::= <Lex099> rank => 0
                             | <Lex100> rank => -1
                             | <Lex097> rank => -2
                             | <Lex461> rank => -3
                             | <Lex459> rank => -4
                             | <Lex458> rank => -5
                             | <Lex460> rank => -6
                             | <Lex456> rank => -7
                             | <Lex457> rank => -8
                             | <Lex462> rank => -9
                             | <Lex464> rank => -10
                             | <Lex463> rank => -11
<Dependent Variable Expression> ::= <Numeric Value Expression> rank => 0
<Independent Variable Expression> ::= <Numeric Value Expression> rank => 0
<Ordered Set Function> ::= <Hypothetical Set Function> rank => 0
                         | <Inverse Distribution Function> rank => -1
<Hypothetical Set Function> ::= <Rank Function Type> <Left Paren> <Hypothetical Set Function Value Expression List> <Right Paren> <Within Group Specification> rank => 0
<Within Group Specification> ::= <Lex530> <Lex382> <Left Paren> <Lex437> <Lex310> <Sort Specification List> <Right Paren> rank => 0
<Gen2096> ::= <Comma> <Value Expression> rank => 0
<Gen2096 any> ::= <Gen2096>* rank => 0
<Hypothetical Set Function Value Expression List> ::= <Value Expression> <Gen2096 any> rank => 0
<Inverse Distribution Function> ::= <Inverse Distribution Function Type> <Left Paren> <Inverse Distribution Function Argument> <Right Paren> <Within Group Specification> rank => 0
<Inverse Distribution Function Argument> ::= <Numeric Value Expression> rank => 0
<Inverse Distribution Function Type> ::= <Lex202> rank => 0
                                       | <Lex203> rank => -1
<Gen2103> ::= <Comma> <Sort Specification> rank => 0
<Gen2103 any> ::= <Gen2103>* rank => 0
<Sort Specification List> ::= <Sort Specification> <Gen2103 any> rank => 0
<Ordering Specification maybe> ::= <Ordering Specification> rank => 0
<Ordering Specification maybe> ::= rank => -1
<Null Ordering maybe> ::= <Null Ordering> rank => 0
<Null Ordering maybe> ::= rank => -1
<Sort Specification> ::= <Sort Key> <Ordering Specification maybe> <Null Ordering maybe> rank => 0
<Sort Key> ::= <Value Expression> rank => 0
<Ordering Specification> ::= <Lex049> rank => 0
                           | <Lex116> rank => -1
<Null Ordering> ::= <Lex180> <Lex131> rank => 0
                  | <Lex180> <Lex154> rank => -1
<Schema Character Set Or Path maybe> ::= <Schema Character Set Or Path> rank => 0
<Schema Character Set Or Path maybe> ::= rank => -1
<Schema Element any> ::= <Schema Element>* rank => 0
<Schema Definition> ::= <Lex328> <Lex231> <Schema Name Clause> <Schema Character Set Or Path maybe> <Schema Element any> rank => 0
<Schema Character Set Or Path> ::= <Schema Character Set Specification> rank => 0
                                 | <Schema Path Specification> rank => -1
                                 | <Schema Character Set Specification> <Schema Path Specification> rank => -2
                                 | <Schema Path Specification> <Schema Character Set Specification> rank => -3
<Schema Name Clause> ::= <Schema Name> rank => 0
                       | <Lex302> <Schema Authorization Identifier> rank => -1
                       | <Schema Name> <Lex302> <Schema Authorization Identifier> rank => -2
<Schema Authorization Identifier> ::= <Authorization Identifier> rank => 0
<Schema Character Set Specification> ::= <Lex348> <Lex317> <Lex482> <Character Set Specification> rank => 0
<Schema Path Specification> ::= <Path Specification> rank => 0
<Schema Element> ::= <Table Definition> rank => 0
                   | <View Definition> rank => -1
                   | <Domain Definition> rank => -2
                   | <Character Set Definition> rank => -3
                   | <Collation Definition> rank => -4
                   | <Transliteration Definition> rank => -5
                   | <Assertion Definition> rank => -6
                   | <Trigger Definition> rank => -7
                   | <User Defined Type Definition> rank => -8
                   | <User Defined Cast Definition> rank => -9
                   | <User Defined Ordering Definition> rank => -10
                   | <Transform Definition> rank => -11
                   | <Schema Routine> rank => -12
                   | <Sequence Generator Definition> rank => -13
                   | <Grant Statement> rank => -14
                   | <Role Definition> rank => -15
<Drop Schema Statement> ::= <Lex356> <Lex231> <Schema Name> <Drop Behavior> rank => 0
<Drop Behavior> ::= <Lex060> rank => 0
                  | <Lex552> rank => -1
<Table Scope maybe> ::= <Table Scope> rank => 0
<Table Scope maybe> ::= rank => -1
<Gen2151> ::= <Lex433> <Lex323> <Table Commit Action> <Lex474> rank => 0
<Gen2151 maybe> ::= <Gen2151> rank => 0
<Gen2151 maybe> ::= rank => -1
<Table Definition> ::= <Lex328> <Table Scope maybe> <Lex498> <Table Name> <Table Contents Source> <Gen2151 maybe> rank => 0
<Subtable Clause maybe> ::= <Subtable Clause> rank => 0
<Subtable Clause maybe> ::= rank => -1
<Table Element List maybe> ::= <Table Element List> rank => 0
<Table Element List maybe> ::= rank => -1
<Table Contents Source> ::= <Table Element List> rank => 0
                          | <Lex431> <Path Resolved User Defined Type Name> <Subtable Clause maybe> <Table Element List maybe> rank => -1
                          | <As Subquery Clause> rank => -2
<Table Scope> ::= <Global Or Local> <Lex261> rank => 0
<Global Or Local> ::= <Lex380> rank => 0
                    | <Lex409> rank => -1
<Table Commit Action> ::= <Lex210> rank => 0
                        | <Lex349> rank => -1
<Gen2167> ::= <Comma> <Table Element> rank => 0
<Gen2167 any> ::= <Gen2167>* rank => 0
<Table Element List> ::= <Left Paren> <Table Element> <Gen2167 any> <Right Paren> rank => 0
<Table Element> ::= <Column Definition> rank => 0
                  | <Table Constraint Definition> rank => -1
                  | <Like Clause> rank => -2
                  | <Self Referencing Column Specification> rank => -3
                  | <Column Options> rank => -4
<Self Referencing Column Specification> ::= <Lex453> <Lex401> <Self Referencing Column Name> <Reference Generation> rank => 0
<Reference Generation> ::= <Lex496> <Lex553> rank => 0
                         | <Lex516> <Lex553> rank => -1
                         | <Lex115> rank => -2
<Self Referencing Column Name> ::= <Column Name> rank => 0
<Column Options> ::= <Column Name> <Lex529> <Lex186> <Column Option List> rank => 0
<Default Clause maybe> ::= <Default Clause> rank => 0
<Default Clause maybe> ::= rank => -1
<Column Constraint Definition any> ::= <Column Constraint Definition>* rank => 0
<Column Option List> ::= <Scope Clause maybe> <Default Clause maybe> <Column Constraint Definition any> rank => 0
<Subtable Clause> ::= <Lex278> <Supertable Clause> rank => 0
<Supertable Clause> ::= <Supertable Name> rank => 0
<Supertable Name> ::= <Table Name> rank => 0
<Like Options maybe> ::= <Like Options> rank => 0
<Like Options maybe> ::= rank => -1
<Like Clause> ::= <Lex408> <Table Name> <Like Options maybe> rank => 0
<Like Options> ::= <Identity Option> rank => 0
                 | <Column Default Option> rank => -1
<Identity Option> ::= <Lex143> <Lex387> rank => 0
                    | <Lex127> <Lex387> rank => -1
<Column Default Option> ::= <Lex143> <Lex107> rank => 0
                          | <Lex127> <Lex107> rank => -1
<Gen2197> ::= <Left Paren> <Column Name List> <Right Paren> rank => 0
<Gen2197 maybe> ::= <Gen2197> rank => 0
<Gen2197 maybe> ::= rank => -1
<As Subquery Clause> ::= <Gen2197 maybe> <Lex297> <Subquery> <With Or Without Data> rank => 0
<With Or Without Data> ::= <Lex529> <Lex426> <Lex104> rank => 0
                         | <Lex529> <Lex104> rank => -1
<Gen2203> ::= <Data Type> rank => 0
            | <Domain Name> rank => -1
<Gen2203 maybe> ::= <Gen2203> rank => 0
<Gen2203 maybe> ::= rank => -1
<Gen2207> ::= <Default Clause> rank => 0
            | <Identity Column Specification> rank => -1
            | <Generation Clause> rank => -2
<Gen2207 maybe> ::= <Gen2207> rank => 0
<Gen2207 maybe> ::= rank => -1
<Column Definition> ::= <Column Name> <Gen2203 maybe> <Reference Scope Check maybe> <Gen2207 maybe> <Column Constraint Definition any> <Collate Clause maybe> rank => 0
<Constraint Name Definition maybe> ::= <Constraint Name Definition> rank => 0
<Constraint Name Definition maybe> ::= rank => -1
<Constraint Characteristics maybe> ::= <Constraint Characteristics> rank => 0
<Constraint Characteristics maybe> ::= rank => -1
<Column Constraint Definition> ::= <Constraint Name Definition maybe> <Column Constraint> <Constraint Characteristics maybe> rank => 0
<Column Constraint> ::= <Lex428> <Lex429> rank => 0
                      | <Unique Specification> rank => -1
                      | <References Specification> rank => -2
                      | <Check Constraint Definition> rank => -3
<Gen2222> ::= <Lex433> <Lex349> <Reference Scope Check Action> rank => 0
<Gen2222 maybe> ::= <Gen2222> rank => 0
<Gen2222 maybe> ::= rank => -1
<Reference Scope Check> ::= <Lex454> <Lex295> <Lex428 maybe> <Lex073> <Gen2222 maybe> rank => 0
<Reference Scope Check Action> ::= <Referential Action> rank => 0
<Gen2227> ::= <Lex048> rank => 0
            | <Lex310> <Lex348> rank => -1
<Gen2229> ::= <Left Paren> <Common Sequence Generator Options> <Right Paren> rank => 0
<Gen2229 maybe> ::= <Gen2229> rank => 0
<Gen2229 maybe> ::= rank => -1
<Identity Column Specification> ::= <Lex553> <Gen2227> <Lex297> <Lex387> <Gen2229 maybe> rank => 0
<Generation Clause> ::= <Generation Rule> <Lex297> <Generation Expression> rank => 0
<Generation Rule> ::= <Lex553> <Lex048> rank => 0
<Generation Expression> ::= <Left Paren> <Value Expression> <Right Paren> rank => 0
<Default Clause> ::= <Lex348> <Default Option> rank => 0
<Default Option> ::= <Literal> rank => 0
                   | <Datetime Value Function> rank => -1
                   | <Lex516> rank => -2
                   | <Lex339> rank => -3
                   | <Lex335> rank => -4
                   | <Lex481> rank => -5
                   | <Lex497> rank => -6
                   | <Lex334> rank => -7
                   | <Implicitly Typed Value Specification> rank => -8
<Table Constraint Definition> ::= <Constraint Name Definition maybe> <Table Constraint> <Constraint Characteristics maybe> rank => 0
<Table Constraint> ::= <Unique Constraint Definition> rank => 0
                     | <Referential Constraint Definition> rank => -1
                     | <Check Constraint Definition> rank => -2
<Gen2250> ::= <Lex518> rank => 0
<Unique Constraint Definition> ::= <Unique Specification> <Left Paren> <Unique Column List> <Right Paren> rank => 0
                                 | <Lex511> <Gen2250> rank => -1
<Unique Specification> ::= <Lex511> rank => 0
                         | <Lex447> <Lex151> rank => -1
<Unique Column List> ::= <Column Name List> rank => 0
<Referential Constraint Definition> ::= <Lex374> <Lex151> <Left Paren> <Referencing Columns> <Right Paren> <References Specification> rank => 0
<Gen2257> ::= <Lex412> <Match Type> rank => 0
<Gen2257 maybe> ::= <Gen2257> rank => 0
<Gen2257 maybe> ::= rank => -1
<Referential Triggered Action maybe> ::= <Referential Triggered Action> rank => 0
<Referential Triggered Action maybe> ::= rank => -1
<References Specification> ::= <Lex454> <Referenced Table And Columns> <Gen2257 maybe> <Referential Triggered Action maybe> rank => 0
<Match Type> ::= <Lex377> rank => 0
               | <Lex199> rank => -1
               | <Lex244> rank => -2
<Referencing Columns> ::= <Reference Column List> rank => 0
<Gen2267> ::= <Left Paren> <Reference Column List> <Right Paren> rank => 0
<Gen2267 maybe> ::= <Gen2267> rank => 0
<Gen2267 maybe> ::= rank => -1
<Referenced Table And Columns> ::= <Table Name> <Gen2267 maybe> rank => 0
<Reference Column List> ::= <Column Name List> rank => 0
<Delete Rule maybe> ::= <Delete Rule> rank => 0
<Delete Rule maybe> ::= rank => -1
<Update Rule maybe> ::= <Update Rule> rank => 0
<Update Rule maybe> ::= rank => -1
<Referential Triggered Action> ::= <Update Rule> <Delete Rule maybe> rank => 0
                                 | <Delete Rule> <Update Rule maybe> rank => -1
<Update Rule> ::= <Lex433> <Lex514> <Referential Action> rank => 0
<Delete Rule> ::= <Lex433> <Lex349> <Referential Action> rank => 0
<Referential Action> ::= <Lex060> rank => 0
                       | <Lex482> <Lex429> rank => -1
                       | <Lex482> <Lex348> rank => -2
                       | <Lex552> rank => -3
                       | <Lex426> <Lex044> rank => -4
<Check Constraint Definition> ::= <Lex318> <Left Paren> <Search Condition> <Right Paren> rank => 0
<Alter Table Statement> ::= <Lex292> <Lex498> <Table Name> <Alter Table Action> rank => 0
<Alter Table Action> ::= <Add Column Definition> rank => 0
                       | <Alter Column Definition> rank => -1
                       | <Drop Column Definition> rank => -2
                       | <Add Table Constraint Definition> rank => -3
                       | <Drop Table Constraint Definition> rank => -4
<Lex322 maybe> ::= <Lex322> rank => 0
<Lex322 maybe> ::= rank => -1
<Add Column Definition> ::= <Lex289> <Lex322 maybe> <Column Definition> rank => 0
<Alter Column Definition> ::= <Lex292> <Lex322 maybe> <Column Name> <Alter Column Action> rank => 0
<Alter Column Action> ::= <Set Column Default Clause> rank => 0
                        | <Drop Column Default Clause> rank => -1
                        | <Add Column Scope Clause> rank => -2
                        | <Drop Column Scope Clause> rank => -3
                        | <Alter Identity Column Specification> rank => -4
<Set Column Default Clause> ::= <Lex482> <Default Clause> rank => 0
<Drop Column Default Clause> ::= <Lex356> <Lex348> rank => 0
<Add Column Scope Clause> ::= <Lex289> <Scope Clause> rank => 0
<Drop Column Scope Clause> ::= <Lex356> <Lex547> <Drop Behavior> rank => 0
<Alter Identity Column Option many> ::= <Alter Identity Column Option>+ rank => 0
<Alter Identity Column Specification> ::= <Alter Identity Column Option many> rank => 0
<Alter Identity Column Option> ::= <Alter Sequence Generator Restart Option> rank => 0
                                 | <Lex482> <Basic Sequence Generator Option> rank => -1
<Drop Column Definition> ::= <Lex356> <Lex322 maybe> <Column Name> <Drop Behavior> rank => 0
<Add Table Constraint Definition> ::= <Lex289> <Table Constraint Definition> rank => 0
<Drop Table Constraint Definition> ::= <Lex356> <Lex325> <Constraint Name> <Drop Behavior> rank => 0
<Drop Table Statement> ::= <Lex356> <Lex498> <Table Name> <Drop Behavior> rank => 0
<Levels Clause maybe> ::= <Levels Clause> rank => 0
<Levels Clause maybe> ::= rank => -1
<Gen2315> ::= <Lex529> <Levels Clause maybe> <Lex318> <Lex185> rank => 0
<Gen2315 maybe> ::= <Gen2315> rank => 0
<Gen2315 maybe> ::= rank => -1
<View Definition> ::= <Lex328> <Lex452 maybe> <Lex285> <Table Name> <View Specification> <Lex297> <Query Expression> <Gen2315 maybe> rank => 0
<View Specification> ::= <Regular View Specification> rank => 0
                       | <Referenceable View Specification> rank => -1
<Gen2321> ::= <Left Paren> <View Column List> <Right Paren> rank => 0
<Gen2321 maybe> ::= <Gen2321> rank => 0
<Gen2321 maybe> ::= rank => -1
<Regular View Specification> ::= <Gen2321 maybe> rank => 0
<Subview Clause maybe> ::= <Subview Clause> rank => 0
<Subview Clause maybe> ::= rank => -1
<View Element List maybe> ::= <View Element List> rank => 0
<View Element List maybe> ::= rank => -1
<Referenceable View Specification> ::= <Lex431> <Path Resolved User Defined Type Name> <Subview Clause maybe> <View Element List maybe> rank => 0
<Subview Clause> ::= <Lex278> <Table Name> rank => 0
<Gen2331> ::= <Comma> <View Element> rank => 0
<Gen2331 any> ::= <Gen2331>* rank => 0
<View Element List> ::= <Left Paren> <View Element> <Gen2331 any> <Right Paren> rank => 0
<View Element> ::= <Self Referencing Column Specification> rank => 0
                 | <View Column Option> rank => -1
<View Column Option> ::= <Column Name> <Lex529> <Lex186> <Scope Clause> rank => 0
<Levels Clause> ::= <Lex313> rank => 0
                  | <Lex409> rank => -1
<View Column List> ::= <Column Name List> rank => 0
<Drop View Statement> ::= <Lex356> <Lex285> <Table Name> <Drop Behavior> rank => 0
<Domain Constraint any> ::= <Domain Constraint>* rank => 0
<Domain Definition> ::= <Lex328> <Lex120> <Domain Name> <Lex297 maybe> <Data Type> <Default Clause maybe> <Domain Constraint any> <Collate Clause maybe> rank => 0
<Domain Constraint> ::= <Constraint Name Definition maybe> <Check Constraint Definition> <Constraint Characteristics maybe> rank => 0
<Alter Domain Statement> ::= <Lex292> <Lex120> <Domain Name> <Alter Domain Action> rank => 0
<Alter Domain Action> ::= <Set Domain Default Clause> rank => 0
                        | <Drop Domain Default Clause> rank => -1
                        | <Add Domain Constraint Definition> rank => -2
                        | <Drop Domain Constraint Definition> rank => -3
<Set Domain Default Clause> ::= <Lex482> <Default Clause> rank => 0
<Drop Domain Default Clause> ::= <Lex356> <Lex348> rank => 0
<Add Domain Constraint Definition> ::= <Lex289> <Domain Constraint> rank => 0
<Drop Domain Constraint Definition> ::= <Lex356> <Lex325> <Constraint Name> rank => 0
<Drop Domain Statement> ::= <Lex356> <Lex120> <Domain Name> <Drop Behavior> rank => 0
<Character Set Definition> ::= <Lex328> <Lex317> <Lex482> <Character Set Name> <Lex297 maybe> <Character Set Source> <Collate Clause maybe> rank => 0
<Character Set Source> ::= <Lex379> <Character Set Specification> rank => 0
<Drop Character Set Statement> ::= <Lex356> <Lex317> <Lex482> <Character Set Name> rank => 0
<Pad Characteristic maybe> ::= <Pad Characteristic> rank => 0
<Pad Characteristic maybe> ::= rank => -1
<Collation Definition> ::= <Lex328> <Lex078> <Collation Name> <Lex373> <Character Set Specification> <Lex376> <Existing Collation Name> <Pad Characteristic maybe> rank => 0
<Existing Collation Name> ::= <Collation Name> rank => 0
<Pad Characteristic> ::= <Lex426> <Lex192> rank => 0
                       | <Lex192> <Lex247> rank => -1
<Drop Collation Statement> ::= <Lex356> <Lex078> <Collation Name> <Drop Behavior> rank => 0
<Transliteration Definition> ::= <Lex328> <Lex506> <Transliteration Name> <Lex373> <Source Character Set Specification> <Lex504> <Target Character Set Specification> <Lex376> <Transliteration Source> rank => 0
<Source Character Set Specification> ::= <Character Set Specification> rank => 0
<Target Character Set Specification> ::= <Character Set Specification> rank => 0
<Transliteration Source> ::= <Existing Transliteration Name> rank => 0
                           | <Transliteration Routine> rank => -1
<Existing Transliteration Name> ::= <Transliteration Name> rank => 0
<Transliteration Routine> ::= <Specific Routine Designator> rank => 0
<Drop Transliteration Statement> ::= <Lex356> <Lex506> <Transliteration Name> rank => 0
<Assertion Definition> ::= <Lex328> <Lex050> <Constraint Name> <Lex318> <Left Paren> <Search Condition> <Right Paren> <Constraint Characteristics maybe> rank => 0
<Drop Assertion Statement> ::= <Lex356> <Lex050> <Constraint Name> rank => 0
<Gen2374> ::= <Lex455> <Old Or New Values Alias List> rank => 0
<Gen2374 maybe> ::= <Gen2374> rank => 0
<Gen2374 maybe> ::= rank => -1
<Trigger Definition> ::= <Lex328> <Lex508> <Trigger Name> <Trigger Action Time> <Trigger Event> <Lex433> <Table Name> <Gen2374 maybe> <Triggered Action> rank => 0
<Trigger Action Time> ::= <Lex055> rank => 0
                        | <Lex047> rank => -1
<Gen2380> ::= <Lex431> <Trigger Column List> rank => 0
<Gen2380 maybe> ::= <Gen2380> rank => 0
<Gen2380 maybe> ::= rank => -1
<Trigger Event> ::= <Lex395> rank => 0
                  | <Lex349> rank => -1
                  | <Lex514> <Gen2380 maybe> rank => -2
<Trigger Column List> ::= <Column Name List> rank => 0
<Gen2387> ::= <Lex473> rank => 0
            | <Lex251> rank => -1
<Gen2389> ::= <Lex373> <Lex358> <Gen2387> rank => 0
<Gen2389 maybe> ::= <Gen2389> rank => 0
<Gen2389 maybe> ::= rank => -1
<Gen2392> ::= <Lex524> <Left Paren> <Search Condition> <Right Paren> rank => 0
<Gen2392 maybe> ::= <Gen2392> rank => 0
<Gen2392 maybe> ::= rank => -1
<Triggered Action> ::= <Gen2389 maybe> <Gen2392 maybe> <Triggered SQL Statement> rank => 0
<Gen2396> ::= <SQL Procedure Statement> <Semicolon> rank => 0
<Gen2396 many> ::= <Gen2396>+ rank => 0
<Triggered SQL Statement> ::= <SQL Procedure Statement> rank => 0
                            | <Lex303> <Lex301> <Gen2396 many> <Lex361> rank => -1
<Old Or New Values Alias many> ::= <Old Or New Values Alias>+ rank => 0
<Old Or New Values Alias List> ::= <Old Or New Values Alias many> rank => 0
<Lex473 maybe> ::= <Lex473> rank => 0
<Lex473 maybe> ::= rank => -1
<Old Or New Values Alias> ::= <Lex432> <Lex473 maybe> <Lex297 maybe> <Old Values Correlation Name> rank => 0
                            | <Lex425> <Lex473 maybe> <Lex297 maybe> <New Values Correlation Name> rank => -1
                            | <Lex432> <Lex498> <Lex297 maybe> <Old Values Table Alias> rank => -2
                            | <Lex425> <Lex498> <Lex297 maybe> <New Values Table Alias> rank => -3
<Old Values Table Alias> ::= <Identifier> rank => 0
<New Values Table Alias> ::= <Identifier> rank => 0
<Old Values Correlation Name> ::= <Correlation Name> rank => 0
<New Values Correlation Name> ::= <Correlation Name> rank => 0
<Drop Trigger Statement> ::= <Lex356> <Lex508> <Trigger Name> rank => 0
<User Defined Type Definition> ::= <Lex328> <Lex275> <User Defined Type Body> rank => 0
<Subtype Clause maybe> ::= <Subtype Clause> rank => 0
<Subtype Clause maybe> ::= rank => -1
<Gen2416> ::= <Lex297> <Representation> rank => 0
<Gen2416 maybe> ::= <Gen2416> rank => 0
<Gen2416 maybe> ::= rank => -1
<User Defined Type Option List maybe> ::= <User Defined Type Option List> rank => 0
<User Defined Type Option List maybe> ::= rank => -1
<Method Specification List maybe> ::= <Method Specification List> rank => 0
<Method Specification List maybe> ::= rank => -1
<User Defined Type Body> ::= <Schema Resolved User Defined Type Name> <Subtype Clause maybe> <Gen2416 maybe> <User Defined Type Option List maybe> <Method Specification List maybe> rank => 0
<User Defined Type Option any> ::= <User Defined Type Option>* rank => 0
<User Defined Type Option List> ::= <User Defined Type Option> <User Defined Type Option any> rank => 0
<User Defined Type Option> ::= <Instantiable Clause> rank => 0
                             | <Finality> rank => -1
                             | <Reference Type Specification> rank => -2
                             | <Ref Cast Option> rank => -3
                             | <Cast Option> rank => -4
<Subtype Clause> ::= <Lex278> <Supertype Name> rank => 0
<Supertype Name> ::= <Path Resolved User Defined Type Name> rank => 0
<Representation> ::= <Predefined Type> rank => 0
                   | <Member List> rank => -1
<Gen2435> ::= <Comma> <Member> rank => 0
<Gen2435 any> ::= <Gen2435>* rank => 0
<Member List> ::= <Left Paren> <Member> <Gen2435 any> <Right Paren> rank => 0
<Member> ::= <Attribute Definition> rank => 0
<Instantiable Clause> ::= <Lex147> rank => 0
                        | <Lex428> <Lex147> rank => -1
<Finality> ::= <Lex130> rank => 0
             | <Lex428> <Lex130> rank => -1
<Reference Type Specification> ::= <User Defined Representation> rank => 0
                                 | <Derived Representation> rank => -1
                                 | <System Generated Representation> rank => -2
<User Defined Representation> ::= <Lex453> <Lex517> <Predefined Type> rank => 0
<Derived Representation> ::= <Lex453> <Lex376> <List Of Attributes> rank => 0
<System Generated Representation> ::= <Lex453> <Lex401> <Lex496> <Lex553> rank => 0
<Cast To Type maybe> ::= <Cast To Type> rank => 0
<Cast To Type maybe> ::= rank => -1
<Ref Cast Option> ::= <Cast To Ref> <Cast To Type maybe> rank => 0
                    | <Cast To Type> rank => -1
<Cast To Ref> ::= <Lex315> <Left Paren> <Lex246> <Lex297> <Lex453> <Right Paren> <Lex529> <Cast To Ref Identifier> rank => 0
<Cast To Ref Identifier> ::= <Identifier> rank => 0
<Cast To Type> ::= <Lex315> <Left Paren> <Lex453> <Lex297> <Lex246> <Right Paren> <Lex529> <Cast To Type Identifier> rank => 0
<Cast To Type Identifier> ::= <Identifier> rank => 0
<Gen2457> ::= <Comma> <Attribute Name> rank => 0
<Gen2457 any> ::= <Gen2457>* rank => 0
<List Of Attributes> ::= <Left Paren> <Attribute Name> <Gen2457 any> <Right Paren> rank => 0
<Cast To Distinct maybe> ::= <Cast To Distinct> rank => 0
<Cast To Distinct maybe> ::= rank => -1
<Cast Option> ::= <Cast To Distinct maybe> <Cast To Source> rank => 0
                | <Cast To Source> rank => -1
<Cast To Distinct> ::= <Lex315> <Left Paren> <Lex246> <Lex297> <Lex354> <Right Paren> <Lex529> <Cast To Distinct Identifier> rank => 0
<Cast To Distinct Identifier> ::= <Identifier> rank => 0
<Cast To Source> ::= <Lex315> <Left Paren> <Lex354> <Lex297> <Lex246> <Right Paren> <Lex529> <Cast To Source Identifier> rank => 0
<Cast To Source Identifier> ::= <Identifier> rank => 0
<Gen2468> ::= <Comma> <Method Specification> rank => 0
<Gen2468 any> ::= <Gen2468>* rank => 0
<Method Specification List> ::= <Method Specification> <Gen2468 any> rank => 0
<Method Specification> ::= <Original Method Specification> rank => 0
                         | <Overriding Method Specification> rank => -1
<Gen2473> ::= <Lex238> <Lex297> <Lex466> rank => 0
<Gen2473 maybe> ::= <Gen2473> rank => 0
<Gen2473 maybe> ::= rank => -1
<Gen2476> ::= <Lex238> <Lex297> <Lex158> rank => 0
<Gen2476 maybe> ::= <Gen2476> rank => 0
<Gen2476 maybe> ::= rank => -1
<Method Characteristics maybe> ::= <Method Characteristics> rank => 0
<Method Characteristics maybe> ::= rank => -1
<Original Method Specification> ::= <Partial Method Specification> <Gen2473 maybe> <Gen2476 maybe> <Method Characteristics maybe> rank => 0
<Overriding Method Specification> ::= <Lex191> <Partial Method Specification> rank => 0
<Gen2483> ::= <Lex146> rank => 0
            | <Lex493> rank => -1
            | <Lex551> rank => -2
<Gen2483 maybe> ::= <Gen2483> rank => 0
<Gen2483 maybe> ::= rank => -1
<Gen2488> ::= <Lex486> <Specific Method Name> rank => 0
<Gen2488 maybe> ::= <Gen2488> rank => 0
<Gen2488 maybe> ::= rank => -1
<Partial Method Specification> ::= <Gen2483 maybe> <Lex415> <Method Name> <SQL Parameter Declaration List> <Returns Clause> <Gen2488 maybe> rank => 0
<Gen2492> ::= <Schema Name> <Period> rank => 0
<Gen2492 maybe> ::= <Gen2492> rank => 0
<Gen2492 maybe> ::= rank => -1
<Specific Method Name> ::= <Gen2492 maybe> <Qualified Identifier> rank => 0
<Method Characteristic many> ::= <Method Characteristic>+ rank => 0
<Method Characteristics> ::= <Method Characteristic many> rank => 0
<Method Characteristic> ::= <Language Clause> rank => 0
                          | <Parameter Style Clause> rank => -1
                          | <Deterministic Characteristic> rank => -2
                          | <SQL Data Access Indication> rank => -3
                          | <Null Call Clause> rank => -4
<Attribute Default maybe> ::= <Attribute Default> rank => 0
<Attribute Default maybe> ::= rank => -1
<Attribute Definition> ::= <Attribute Name> <Data Type> <Reference Scope Check maybe> <Attribute Default maybe> <Collate Clause maybe> rank => 0
<Attribute Default> ::= <Default Clause> rank => 0
<Alter Type Statement> ::= <Lex292> <Lex275> <Schema Resolved User Defined Type Name> <Alter Type Action> rank => 0
<Alter Type Action> ::= <Add Attribute Definition> rank => 0
                      | <Drop Attribute Definition> rank => -1
                      | <Add Original Method Specification> rank => -2
                      | <Add Overriding Method Specification> rank => -3
                      | <Drop Method Specification> rank => -4
<Add Attribute Definition> ::= <Lex289> <Lex052> <Attribute Definition> rank => 0
<Drop Attribute Definition> ::= <Lex356> <Lex052> <Attribute Name> <Lex552> rank => 0
<Add Original Method Specification> ::= <Lex289> <Original Method Specification> rank => 0
<Add Overriding Method Specification> ::= <Lex289> <Overriding Method Specification> rank => 0
<Drop Method Specification> ::= <Lex356> <Specific Method Specification Designator> <Lex552> rank => 0
<Gen2518> ::= <Lex146> rank => 0
            | <Lex493> rank => -1
            | <Lex551> rank => -2
<Gen2518 maybe> ::= <Gen2518> rank => 0
<Gen2518 maybe> ::= rank => -1
<Specific Method Specification Designator> ::= <Gen2518 maybe> <Lex415> <Method Name> <Data Type List> rank => 0
<Drop Data Type Statement> ::= <Lex356> <Lex275> <Schema Resolved User Defined Type Name> <Drop Behavior> rank => 0
<SQL Invoked Routine> ::= <Schema Routine> rank => 0
<Schema Routine> ::= <Schema Procedure> rank => 0
                   | <Schema Function> rank => -1
<Schema Procedure> ::= <Lex328> <SQL Invoked Procedure> rank => 0
<Schema Function> ::= <Lex328> <SQL Invoked Function> rank => 0
<SQL Invoked Procedure> ::= <Lex448> <Schema Qualified Routine Name> <SQL Parameter Declaration List> <Routine Characteristics> <Routine Body> rank => 0
<Gen2531> ::= <Function Specification> rank => 0
            | <Method Specification Designator> rank => -1
<SQL Invoked Function> ::= <Gen2531> <Routine Body> rank => 0
<Gen2534> ::= <Comma> <SQL Parameter Declaration> rank => 0
<Gen2534 any> ::= <Gen2534>* rank => 0
<Gen2536> ::= <SQL Parameter Declaration> <Gen2534 any> rank => 0
<Gen2536 maybe> ::= <Gen2536> rank => 0
<Gen2536 maybe> ::= rank => -1
<SQL Parameter Declaration List> ::= <Left Paren> <Gen2536 maybe> <Right Paren> rank => 0
<Parameter Mode maybe> ::= <Parameter Mode> rank => 0
<Parameter Mode maybe> ::= rank => -1
<SQL Parameter Name maybe> ::= <SQL Parameter Name> rank => 0
<SQL Parameter Name maybe> ::= rank => -1
<Lex466 maybe> ::= <Lex466> rank => 0
<Lex466 maybe> ::= rank => -1
<SQL Parameter Declaration> ::= <Parameter Mode maybe> <SQL Parameter Name maybe> <Parameter Type> <Lex466 maybe> rank => 0
<Parameter Mode> ::= <Lex389> rank => 0
                   | <Lex438> rank => -1
                   | <Lex392> rank => -2
<Locator Indication maybe> ::= <Locator Indication> rank => 0
<Locator Indication maybe> ::= rank => -1
<Parameter Type> ::= <Data Type> <Locator Indication maybe> rank => 0
<Locator Indication> ::= <Lex297> <Lex158> rank => 0
<Dispatch Clause maybe> ::= <Dispatch Clause> rank => 0
<Dispatch Clause maybe> ::= rank => -1
<Function Specification> ::= <Lex378> <Schema Qualified Routine Name> <SQL Parameter Declaration List> <Returns Clause> <Routine Characteristics> <Dispatch Clause maybe> rank => 0
<Gen2557> ::= <Lex146> rank => 0
            | <Lex493> rank => -1
            | <Lex551> rank => -2
<Gen2557 maybe> ::= <Gen2557> rank => 0
<Gen2557 maybe> ::= rank => -1
<Returns Clause maybe> ::= <Returns Clause> rank => 0
<Returns Clause maybe> ::= rank => -1
<Method Specification Designator> ::= <Lex486> <Lex415> <Specific Method Name> rank => 0
                                    | <Gen2557 maybe> <Lex415> <Method Name> <SQL Parameter Declaration List> <Returns Clause maybe> <Lex373> <Schema Resolved User Defined Type Name> rank => -1
<Routine Characteristic any> ::= <Routine Characteristic>* rank => 0
<Routine Characteristics> ::= <Routine Characteristic any> rank => 0
<Routine Characteristic> ::= <Language Clause> rank => 0
                           | <Parameter Style Clause> rank => -1
                           | <Lex486> <Specific Name> rank => -2
                           | <Deterministic Characteristic> rank => -3
                           | <SQL Data Access Indication> rank => -4
                           | <Null Call Clause> rank => -5
                           | <Dynamic Result Sets Characteristic> rank => -6
                           | <Savepoint Level Indication> rank => -7
<Savepoint Level Indication> ::= <Lex425> <Lex475> <Lex156> rank => 0
                               | <Lex432> <Lex475> <Lex156> rank => -1
<Dynamic Result Sets Characteristic> ::= <Lex357> <Lex466> <Lex243> <Maximum Dynamic Result Sets> rank => 0
<Parameter Style Clause> ::= <Lex443> <Lex255> <Parameter Style> rank => 0
<Dispatch Clause> ::= <Lex493> <Lex119> rank => 0
<Returns Clause> ::= <Lex468> <Returns Type> rank => 0
<Result Cast maybe> ::= <Result Cast> rank => 0
<Result Cast maybe> ::= rank => -1
<Returns Type> ::= <Returns Data Type> <Result Cast maybe> rank => 0
                 | <Returns Table Type> rank => -1
<Returns Table Type> ::= <Lex498> <Table Function Column List> rank => 0
<Gen2587> ::= <Comma> <Table Function Column List Element> rank => 0
<Gen2587 any> ::= <Gen2587>* rank => 0
<Table Function Column List> ::= <Left Paren> <Table Function Column List Element> <Gen2587 any> <Right Paren> rank => 0
<Table Function Column List Element> ::= <Column Name> <Data Type> rank => 0
<Result Cast> ::= <Lex315> <Lex376> <Result Cast From Type> rank => 0
<Result Cast From Type> ::= <Data Type> <Locator Indication maybe> rank => 0
<Returns Data Type> ::= <Data Type> <Locator Indication maybe> rank => 0
<Routine Body> ::= <SQL Routine Spec> rank => 0
                 | <External Body Reference> rank => -1
<Rights Clause maybe> ::= <Rights Clause> rank => 0
<Rights Clause maybe> ::= rank => -1
<SQL Routine Spec> ::= <Rights Clause maybe> <SQL Routine Body> rank => 0
<Rights Clause> ::= <Lex488> <Lex237> <Lex149> rank => 0
                  | <Lex488> <Lex237> <Lex111> rank => -1
<SQL Routine Body> ::= <SQL Procedure Statement> rank => 0
<Gen2602> ::= <Lex172> <External Routine Name> rank => 0
<Gen2602 maybe> ::= <Gen2602> rank => 0
<Gen2602 maybe> ::= rank => -1
<Parameter Style Clause maybe> ::= <Parameter Style Clause> rank => 0
<Parameter Style Clause maybe> ::= rank => -1
<Transform Group Specification maybe> ::= <Transform Group Specification> rank => 0
<Transform Group Specification maybe> ::= rank => -1
<External Security Clause maybe> ::= <External Security Clause> rank => 0
<External Security Clause maybe> ::= rank => -1
<External Body Reference> ::= <Lex368> <Gen2602 maybe> <Parameter Style Clause maybe> <Transform Group Specification maybe> <External Security Clause maybe> rank => 0
<External Security Clause> ::= <Lex368> <Lex237> <Lex111> rank => 0
                             | <Lex368> <Lex237> <Lex149> rank => -1
                             | <Lex368> <Lex237> <Lex142> <Lex110> rank => -2
<Parameter Style> ::= <Lex488> rank => 0
                    | <Lex137> rank => -1
<Deterministic Characteristic> ::= <Lex352> rank => 0
                                 | <Lex428> <Lex352> rank => -1
<SQL Data Access Indication> ::= <Lex426> <Lex488> rank => 0
                               | <Lex095> <Lex488> rank => -1
                               | <Lex450> <Lex488> <Lex104> rank => -2
                               | <Lex417> <Lex488> <Lex104> rank => -3
<Null Call Clause> ::= <Lex468> <Lex429> <Lex433> <Lex429> <Lex393> rank => 0
                     | <Lex312> <Lex433> <Lex429> <Lex393> rank => -1
<Maximum Dynamic Result Sets> ::= <Unsigned Integer> rank => 0
<Gen2626> ::= <Single Group Specification> rank => 0
            | <Multiple Group Specification> rank => -1
<Transform Group Specification> ::= <Lex268> <Lex382> <Gen2626> rank => 0
<Single Group Specification> ::= <Group Name> rank => 0
<Gen2630> ::= <Comma> <Group Specification> rank => 0
<Gen2630 any> ::= <Gen2630>* rank => 0
<Multiple Group Specification> ::= <Group Specification> <Gen2630 any> rank => 0
<Group Specification> ::= <Group Name> <Lex373> <Lex275> <Path Resolved User Defined Type Name> rank => 0
<Alter Routine Statement> ::= <Lex292> <Specific Routine Designator> <Alter Routine Characteristics> <Alter Routine Behavior> rank => 0
<Alter Routine Characteristic many> ::= <Alter Routine Characteristic>+ rank => 0
<Alter Routine Characteristics> ::= <Alter Routine Characteristic many> rank => 0
<Alter Routine Characteristic> ::= <Language Clause> rank => 0
                                 | <Parameter Style Clause> rank => -1
                                 | <SQL Data Access Indication> rank => -2
                                 | <Null Call Clause> rank => -3
                                 | <Dynamic Result Sets Characteristic> rank => -4
                                 | <Lex172> <External Routine Name> rank => -5
<Alter Routine Behavior> ::= <Lex552> rank => 0
<Drop Routine Statement> ::= <Lex356> <Specific Routine Designator> <Drop Behavior> rank => 0
<Gen2645> ::= <Lex297> <Lex051> rank => 0
<Gen2645 maybe> ::= <Gen2645> rank => 0
<Gen2645 maybe> ::= rank => -1
<User Defined Cast Definition> ::= <Lex328> <Lex315> <Left Paren> <Source Data Type> <Lex297> <Target Data Type> <Right Paren> <Lex529> <Cast Function> <Gen2645 maybe> rank => 0
<Cast Function> ::= <Specific Routine Designator> rank => 0
<Source Data Type> ::= <Data Type> rank => 0
<Target Data Type> ::= <Data Type> rank => 0
<Drop User Defined Cast Statement> ::= <Lex356> <Lex315> <Left Paren> <Source Data Type> <Lex297> <Target Data Type> <Right Paren> <Drop Behavior> rank => 0
<User Defined Ordering Definition> ::= <Lex328> <Lex187> <Lex373> <Schema Resolved User Defined Type Name> <Ordering Form> rank => 0
<Ordering Form> ::= <Equals Ordering Form> rank => 0
                  | <Full Ordering Form> rank => -1
<Equals Ordering Form> ::= <Lex123> <Lex434> <Lex310> <Ordering Category> rank => 0
<Full Ordering Form> ::= <Lex437> <Lex377> <Lex310> <Ordering Category> rank => 0
<Ordering Category> ::= <Relative Category> rank => 0
                      | <Map Category> rank => -1
                      | <State Category> rank => -2
<Relative Category> ::= <Lex216> <Lex529> <Relative Function Specification> rank => 0
<Map Category> ::= <Lex160> <Lex529> <Map Function Specification> rank => 0
<Specific Name maybe> ::= <Specific Name> rank => 0
<Specific Name maybe> ::= rank => -1
<State Category> ::= <Lex250> <Specific Name maybe> rank => 0
<Relative Function Specification> ::= <Specific Routine Designator> rank => 0
<Map Function Specification> ::= <Specific Routine Designator> rank => 0
<Drop User Defined Ordering Statement> ::= <Lex356> <Lex187> <Lex373> <Schema Resolved User Defined Type Name> <Drop Behavior> rank => 0
<Gen2669> ::= <Lex268> rank => 0
            | <Lex269> rank => -1
<Transform Group many> ::= <Transform Group>+ rank => 0
<Transform Definition> ::= <Lex328> <Gen2669> <Lex373> <Schema Resolved User Defined Type Name> <Transform Group many> rank => 0
<Transform Group> ::= <Group Name> <Left Paren> <Transform Element List> <Right Paren> rank => 0
<Group Name> ::= <Identifier> rank => 0
<Gen2675> ::= <Comma> <Transform Element> rank => 0
<Gen2675 maybe> ::= <Gen2675> rank => 0
<Gen2675 maybe> ::= rank => -1
<Transform Element List> ::= <Transform Element> <Gen2675 maybe> rank => 0
<Transform Element> ::= <To Sql> rank => 0
                      | <From Sql> rank => -1
<To Sql> ::= <Lex504> <Lex488> <Lex529> <To Sql Function> rank => 0
<From Sql> ::= <Lex376> <Lex488> <Lex529> <From Sql Function> rank => 0
<To Sql Function> ::= <Specific Routine Designator> rank => 0
<From Sql Function> ::= <Specific Routine Designator> rank => 0
<Gen2685> ::= <Lex268> rank => 0
            | <Lex269> rank => -1
<Alter Group many> ::= <Alter Group>+ rank => 0
<Alter Transform Statement> ::= <Lex292> <Gen2685> <Lex373> <Schema Resolved User Defined Type Name> <Alter Group many> rank => 0
<Alter Group> ::= <Group Name> <Left Paren> <Alter Transform Action List> <Right Paren> rank => 0
<Gen2690> ::= <Comma> <Alter Transform Action> rank => 0
<Gen2690 any> ::= <Gen2690>* rank => 0
<Alter Transform Action List> ::= <Alter Transform Action> <Gen2690 any> rank => 0
<Alter Transform Action> ::= <Add Transform Element List> rank => 0
                           | <Drop Transform Element List> rank => -1
<Add Transform Element List> ::= <Lex289> <Left Paren> <Transform Element List> <Right Paren> rank => 0
<Gen2696> ::= <Comma> <Transform Kind> rank => 0
<Gen2696 maybe> ::= <Gen2696> rank => 0
<Gen2696 maybe> ::= rank => -1
<Drop Transform Element List> ::= <Lex356> <Left Paren> <Transform Kind> <Gen2696 maybe> <Drop Behavior> <Right Paren> rank => 0
<Transform Kind> ::= <Lex504> <Lex488> rank => 0
                   | <Lex376> <Lex488> rank => -1
<Gen2702> ::= <Lex268> rank => 0
            | <Lex269> rank => -1
<Drop Transform Statement> ::= <Lex356> <Gen2702> <Transforms To Be Dropped> <Lex373> <Schema Resolved User Defined Type Name> <Drop Behavior> rank => 0
<Transforms To Be Dropped> ::= <Lex290> rank => 0
                             | <Transform Group Element> rank => -1
<Transform Group Element> ::= <Group Name> rank => 0
<Sequence Generator Options maybe> ::= <Sequence Generator Options> rank => 0
<Sequence Generator Options maybe> ::= rank => -1
<Sequence Generator Definition> ::= <Lex328> <Lex239> <Sequence Generator Name> <Sequence Generator Options maybe> rank => 0
<Sequence Generator Option many> ::= <Sequence Generator Option>+ rank => 0
<Sequence Generator Options> ::= <Sequence Generator Option many> rank => 0
<Sequence Generator Option> ::= <Sequence Generator Data Type Option> rank => 0
                              | <Common Sequence Generator Options> rank => -1
<Common Sequence Generator Option many> ::= <Common Sequence Generator Option>+ rank => 0
<Common Sequence Generator Options> ::= <Common Sequence Generator Option many> rank => 0
<Common Sequence Generator Option> ::= <Sequence Generator Start With Option> rank => 0
                                     | <Basic Sequence Generator Option> rank => -1
<Basic Sequence Generator Option> ::= <Sequence Generator Increment By Option> rank => 0
                                    | <Sequence Generator Maxvalue Option> rank => -1
                                    | <Sequence Generator Minvalue Option> rank => -2
                                    | <Sequence Generator Cycle Option> rank => -3
<Sequence Generator Data Type Option> ::= <Lex297> <Data Type> rank => 0
<Sequence Generator Start With Option> ::= <Lex492> <Lex529> <Sequence Generator Start Value> rank => 0
<Sequence Generator Start Value> ::= <Signed Numeric Literal> rank => 0
<Sequence Generator Increment By Option> ::= <Lex144> <Lex310> <Sequence Generator Increment> rank => 0
<Sequence Generator Increment> ::= <Signed Numeric Literal> rank => 0
<Sequence Generator Maxvalue Option> ::= <Lex163> <Sequence Generator Max Value> rank => 0
                                       | <Lex426> <Lex163> rank => -1
<Sequence Generator Max Value> ::= <Signed Numeric Literal> rank => 0
<Sequence Generator Minvalue Option> ::= <Lex168> <Sequence Generator Min Value> rank => 0
                                       | <Lex426> <Lex168> rank => -1
<Sequence Generator Min Value> ::= <Signed Numeric Literal> rank => 0
<Sequence Generator Cycle Option> ::= <Lex341> rank => 0
                                    | <Lex426> <Lex341> rank => -1
<Alter Sequence Generator Statement> ::= <Lex292> <Lex239> <Sequence Generator Name> <Alter Sequence Generator Options> rank => 0
<Alter Sequence Generator Option many> ::= <Alter Sequence Generator Option>+ rank => 0
<Alter Sequence Generator Options> ::= <Alter Sequence Generator Option many> rank => 0
<Alter Sequence Generator Option> ::= <Alter Sequence Generator Restart Option> rank => 0
                                    | <Basic Sequence Generator Option> rank => -1
<Alter Sequence Generator Restart Option> ::= <Lex218> <Lex529> <Sequence Generator Restart Value> rank => 0
<Sequence Generator Restart Value> ::= <Signed Numeric Literal> rank => 0
<Drop Sequence Generator Statement> ::= <Lex356> <Lex239> <Sequence Generator Name> <Drop Behavior> rank => 0
<Grant Statement> ::= <Grant Privilege Statement> rank => 0
                    | <Grant Role Statement> rank => -1
<Gen2746> ::= <Comma> <Grantee> rank => 0
<Gen2746 any> ::= <Gen2746>* rank => 0
<Gen2748> ::= <Lex529> <Lex141> <Lex185> rank => 0
<Gen2748 maybe> ::= <Gen2748> rank => 0
<Gen2748 maybe> ::= rank => -1
<Gen2751> ::= <Lex529> <Lex381> <Lex185> rank => 0
<Gen2751 maybe> ::= <Gen2751> rank => 0
<Gen2751 maybe> ::= rank => -1
<Gen2754> ::= <Lex140> <Lex310> <Grantor> rank => 0
<Gen2754 maybe> ::= <Gen2754> rank => 0
<Gen2754 maybe> ::= rank => -1
<Grant Privilege Statement> ::= <Lex381> <Privileges> <Lex504> <Grantee> <Gen2746 any> <Gen2748 maybe> <Gen2751 maybe> <Gen2754 maybe> rank => 0
<Privileges> ::= <Object Privileges> <Lex433> <Object Name> rank => 0
<Lex498 maybe> ::= <Lex498> rank => 0
<Lex498 maybe> ::= rank => -1
<Object Name> ::= <Lex498 maybe> <Table Name> rank => 0
                | <Lex120> <Domain Name> rank => -1
                | <Lex078> <Collation Name> rank => -2
                | <Lex317> <Lex482> <Character Set Name> rank => -3
                | <Lex506> <Transliteration Name> rank => -4
                | <Lex275> <Schema Resolved User Defined Type Name> rank => -5
                | <Lex239> <Sequence Generator Name> rank => -6
                | <Specific Routine Designator> rank => -7
<Gen2769> ::= <Comma> <Action> rank => 0
<Gen2769 any> ::= <Gen2769>* rank => 0
<Object Privileges> ::= <Lex290> <Lex212> rank => 0
                      | <Action> <Gen2769 any> rank => -1
<Gen2773> ::= <Left Paren> <Privilege Column List> <Right Paren> rank => 0
<Gen2773 maybe> ::= <Gen2773> rank => 0
<Gen2773 maybe> ::= rank => -1
<Gen2776> ::= <Left Paren> <Privilege Column List> <Right Paren> rank => 0
<Gen2776 maybe> ::= <Gen2776> rank => 0
<Gen2776 maybe> ::= rank => -1
<Gen2779> ::= <Left Paren> <Privilege Column List> <Right Paren> rank => 0
<Gen2779 maybe> ::= <Gen2779> rank => 0
<Gen2779 maybe> ::= rank => -1
<Action> ::= <Lex479> rank => 0
           | <Lex479> <Left Paren> <Privilege Column List> <Right Paren> rank => -1
           | <Lex479> <Left Paren> <Privilege Method List> <Right Paren> rank => -2
           | <Lex349> rank => -3
           | <Lex395> <Gen2773 maybe> rank => -4
           | <Lex514> <Gen2776 maybe> rank => -5
           | <Lex454> <Gen2779 maybe> rank => -6
           | <Lex280> rank => -7
           | <Lex508> rank => -8
           | <Lex278> rank => -9
           | <Lex366> rank => -10
<Gen2793> ::= <Comma> <Specific Routine Designator> rank => 0
<Gen2793 any> ::= <Gen2793>* rank => 0
<Privilege Method List> ::= <Specific Routine Designator> <Gen2793 any> rank => 0
<Privilege Column List> ::= <Column Name List> rank => 0
<Grantee> ::= <Lex213> rank => 0
            | <Authorization Identifier> rank => -1
<Grantor> ::= <Lex339> rank => 0
            | <Lex335> rank => -1
<Gen2801> ::= <Lex529> <Lex046> <Grantor> rank => 0
<Gen2801 maybe> ::= <Gen2801> rank => 0
<Gen2801 maybe> ::= rank => -1
<Role Definition> ::= <Lex328> <Lex223> <Role Name> <Gen2801 maybe> rank => 0
<Gen2805> ::= <Comma> <Role Granted> rank => 0
<Gen2805 any> ::= <Gen2805>* rank => 0
<Gen2807> ::= <Comma> <Grantee> rank => 0
<Gen2807 any> ::= <Gen2807>* rank => 0
<Gen2809> ::= <Lex529> <Lex046> <Lex185> rank => 0
<Gen2809 maybe> ::= <Gen2809> rank => 0
<Gen2809 maybe> ::= rank => -1
<Gen2812> ::= <Lex140> <Lex310> <Grantor> rank => 0
<Gen2812 maybe> ::= <Gen2812> rank => 0
<Gen2812 maybe> ::= rank => -1
<Grant Role Statement> ::= <Lex381> <Role Granted> <Gen2805 any> <Lex504> <Grantee> <Gen2807 any> <Gen2809 maybe> <Gen2812 maybe> rank => 0
<Role Granted> ::= <Role Name> rank => 0
<Drop Role Statement> ::= <Lex356> <Lex223> <Role Name> rank => 0
<Revoke Statement> ::= <Revoke Privilege Statement> rank => 0
                     | <Revoke Role Statement> rank => -1
<Revoke Option Extension maybe> ::= <Revoke Option Extension> rank => 0
<Revoke Option Extension maybe> ::= rank => -1
<Gen2822> ::= <Comma> <Grantee> rank => 0
<Gen2822 any> ::= <Gen2822>* rank => 0
<Gen2824> ::= <Lex140> <Lex310> <Grantor> rank => 0
<Gen2824 maybe> ::= <Gen2824> rank => 0
<Gen2824 maybe> ::= rank => -1
<Revoke Privilege Statement> ::= <Lex469> <Revoke Option Extension maybe> <Privileges> <Lex376> <Grantee> <Gen2822 any> <Gen2824 maybe> <Drop Behavior> rank => 0
<Revoke Option Extension> ::= <Lex381> <Lex185> <Lex373> rank => 0
                            | <Lex141> <Lex185> <Lex373> rank => -1
<Gen2830> ::= <Lex046> <Lex185> <Lex373> rank => 0
<Gen2830 maybe> ::= <Gen2830> rank => 0
<Gen2830 maybe> ::= rank => -1
<Gen2833> ::= <Comma> <Role Revoked> rank => 0
<Gen2833 any> ::= <Gen2833>* rank => 0
<Gen2835> ::= <Comma> <Grantee> rank => 0
<Gen2835 any> ::= <Gen2835>* rank => 0
<Gen2837> ::= <Lex140> <Lex310> <Grantor> rank => 0
<Gen2837 maybe> ::= <Gen2837> rank => 0
<Gen2837 maybe> ::= rank => -1
<Revoke Role Statement> ::= <Lex469> <Gen2830 maybe> <Role Revoked> <Gen2833 any> <Lex376> <Grantee> <Gen2835 any> <Gen2837 maybe> <Drop Behavior> rank => 0
<Role Revoked> ::= <Role Name> rank => 0
<Module Path Specification maybe> ::= <Module Path Specification> rank => 0
<Module Path Specification maybe> ::= rank => -1
<Module Transform Group Specification maybe> ::= <Module Transform Group Specification> rank => 0
<Module Transform Group Specification maybe> ::= rank => -1
<Module Collations maybe> ::= <Module Collations> rank => 0
<Module Collations maybe> ::= rank => -1
<Temporary Table Declaration any> ::= <Temporary Table Declaration>* rank => 0
<Module Contents many> ::= <Module Contents>+ rank => 0
<SQL Client Module Definition> ::= <Module Name Clause> <Language Clause> <Module Authorization Clause> <Module Path Specification maybe> <Module Transform Group Specification maybe> <Module Collations maybe> <Temporary Table Declaration any> <Module Contents many> rank => 0
<Gen2851> ::= <Lex434> rank => 0
            | <Lex293> <Lex357> rank => -1
<Gen2853> ::= <Lex373> <Lex493> <Gen2851> rank => 0
<Gen2853 maybe> ::= <Gen2853> rank => 0
<Gen2853 maybe> ::= rank => -1
<Gen2856> ::= <Lex434> rank => 0
            | <Lex293> <Lex357> rank => -1
<Gen2858> ::= <Lex373> <Lex493> <Gen2856> rank => 0
<Gen2858 maybe> ::= <Gen2858> rank => 0
<Gen2858 maybe> ::= rank => -1
<Module Authorization Clause> ::= <Lex231> <Schema Name> rank => 0
                                | <Lex302> <Module Authorization Identifier> <Gen2853 maybe> rank => -1
                                | <Lex231> <Schema Name> <Lex302> <Module Authorization Identifier> <Gen2858 maybe> rank => -2
<Module Authorization Identifier> ::= <Authorization Identifier> rank => 0
<Module Path Specification> ::= <Path Specification> rank => 0
<Module Transform Group Specification> ::= <Transform Group Specification> rank => 0
<Module Collation Specification many> ::= <Module Collation Specification>+ rank => 0
<Module Collations> ::= <Module Collation Specification many> rank => 0
<Gen2869> ::= <Lex373> <Character Set Specification List> rank => 0
<Gen2869 maybe> ::= <Gen2869> rank => 0
<Gen2869 maybe> ::= rank => -1
<Module Collation Specification> ::= <Lex078> <Collation Name> <Gen2869 maybe> rank => 0
<Gen2873> ::= <Comma> <Character Set Specification> rank => 0
<Gen2873 any> ::= <Gen2873>* rank => 0
<Character Set Specification List> ::= <Character Set Specification> <Gen2873 any> rank => 0
<Module Contents> ::= <Declare Cursor> rank => 0
                    | <Dynamic Declare Cursor> rank => -1
                    | <Externally Invoked Procedure> rank => -2
<SQL Client Module Name maybe> ::= <SQL Client Module Name> rank => 0
<SQL Client Module Name maybe> ::= rank => -1
<Module Character Set Specification maybe> ::= <Module Character Set Specification> rank => 0
<Module Character Set Specification maybe> ::= rank => -1
<Module Name Clause> ::= <Lex418> <SQL Client Module Name maybe> <Module Character Set Specification maybe> rank => 0
<Module Character Set Specification> ::= <Lex173> <Lex295> <Character Set Specification> rank => 0
<Externally Invoked Procedure> ::= <Lex448> <Procedure Name> <Host Parameter Declaration List> <Semicolon> <SQL Procedure Statement> <Semicolon> rank => 0
<Gen2886> ::= <Comma> <Host Parameter Declaration> rank => 0
<Gen2886 any> ::= <Gen2886>* rank => 0
<Host Parameter Declaration List> ::= <Left Paren> <Host Parameter Declaration> <Gen2886 any> <Right Paren> rank => 0
<Host Parameter Declaration> ::= <Host Parameter Name> <Host Parameter Data Type> rank => 0
                               | <Status Parameter> rank => -1
<Host Parameter Data Type> ::= <Data Type> <Locator Indication maybe> rank => 0
<Status Parameter> ::= <Lex490> rank => 0
<SQL Procedure Statement> ::= <SQL Executable Statement> rank => 0
<SQL Executable Statement> ::= <SQL Schema Statement> rank => 0
                             | <SQL Data Statement> rank => -1
                             | <SQL Control Statement> rank => -2
                             | <SQL Transaction Statement> rank => -3
                             | <SQL Connection Statement> rank => -4
                             | <SQL Session Statement> rank => -5
                             | <SQL Diagnostics Statement> rank => -6
                             | <SQL Dynamic Statement> rank => -7
<SQL Schema Statement> ::= <SQL Schema Definition Statement> rank => 0
                         | <SQL Schema Manipulation Statement> rank => -1
<SQL Schema Definition Statement> ::= <Schema Definition> rank => 0
                                    | <Table Definition> rank => -1
                                    | <View Definition> rank => -2
                                    | <SQL Invoked Routine> rank => -3
                                    | <Grant Statement> rank => -4
                                    | <Role Definition> rank => -5
                                    | <Domain Definition> rank => -6
                                    | <Character Set Definition> rank => -7
                                    | <Collation Definition> rank => -8
                                    | <Transliteration Definition> rank => -9
                                    | <Assertion Definition> rank => -10
                                    | <Trigger Definition> rank => -11
                                    | <User Defined Type Definition> rank => -12
                                    | <User Defined Cast Definition> rank => -13
                                    | <User Defined Ordering Definition> rank => -14
                                    | <Transform Definition> rank => -15
                                    | <Sequence Generator Definition> rank => -16
<SQL Schema Manipulation Statement> ::= <Drop Schema Statement> rank => 0
                                      | <Alter Table Statement> rank => -1
                                      | <Drop Table Statement> rank => -2
                                      | <Drop View Statement> rank => -3
                                      | <Alter Routine Statement> rank => -4
                                      | <Drop Routine Statement> rank => -5
                                      | <Drop User Defined Cast Statement> rank => -6
                                      | <Revoke Statement> rank => -7
                                      | <Drop Role Statement> rank => -8
                                      | <Alter Domain Statement> rank => -9
                                      | <Drop Domain Statement> rank => -10
                                      | <Drop Character Set Statement> rank => -11
                                      | <Drop Collation Statement> rank => -12
                                      | <Drop Transliteration Statement> rank => -13
                                      | <Drop Assertion Statement> rank => -14
                                      | <Drop Trigger Statement> rank => -15
                                      | <Alter Type Statement> rank => -16
                                      | <Drop Data Type Statement> rank => -17
                                      | <Drop User Defined Ordering Statement> rank => -18
                                      | <Alter Transform Statement> rank => -19
                                      | <Drop Transform Statement> rank => -20
                                      | <Alter Sequence Generator Statement> rank => -21
                                      | <Drop Sequence Generator Statement> rank => -22
<SQL Data Statement> ::= <Open Statement> rank => 0
                       | <Fetch Statement> rank => -1
                       | <Close Statement> rank => -2
                       | <Select Statement Single Row> rank => -3
                       | <Free Locator Statement> rank => -4
                       | <Hold Locator Statement> rank => -5
                       | <SQL Data Change Statement> rank => -6
<SQL Data Change Statement> ::= <Delete Statement Positioned> rank => 0
                              | <Delete Statement Searched> rank => -1
                              | <Insert Statement> rank => -2
                              | <Update Statement Positioned> rank => -3
                              | <Update Statement Searched> rank => -4
                              | <Merge Statement> rank => -5
<SQL Control Statement> ::= <Call Statement> rank => 0
                          | <Return Statement> rank => -1
<SQL Transaction Statement> ::= <Start Transaction Statement> rank => 0
                              | <Set Transaction Statement> rank => -1
                              | <Set Constraints Mode Statement> rank => -2
                              | <Savepoint Statement> rank => -3
                              | <Release Savepoint Statement> rank => -4
                              | <Commit Statement> rank => -5
                              | <Rollback Statement> rank => -6
<SQL Connection Statement> ::= <Connect Statement> rank => 0
                             | <Set Connection Statement> rank => -1
                             | <Disconnect Statement> rank => -2
<SQL Session Statement> ::= <Set Session User Identifier Statement> rank => 0
                          | <Set Role Statement> rank => -1
                          | <Set Local Time Zone Statement> rank => -2
                          | <Set Session Characteristics Statement> rank => -3
                          | <Set Catalog Statement> rank => -4
                          | <Set Schema Statement> rank => -5
                          | <Set Names Statement> rank => -6
                          | <Set Path Statement> rank => -7
                          | <Set Transform Group Statement> rank => -8
                          | <Set Session Collation Statement> rank => -9
<SQL Diagnostics Statement> ::= <Get Diagnostics Statement> rank => 0
<SQL Dynamic Statement> ::= <System Descriptor Statement> rank => 0
                          | <Prepare Statement> rank => -1
                          | <Deallocate Prepared Statement> rank => -2
                          | <Describe Statement> rank => -3
                          | <Execute Statement> rank => -4
                          | <Execute Immediate Statement> rank => -5
                          | <SQL Dynamic Data Statement> rank => -6
<SQL Dynamic Data Statement> ::= <Allocate Cursor Statement> rank => 0
                               | <Dynamic Open Statement> rank => -1
                               | <Dynamic Fetch Statement> rank => -2
                               | <Dynamic Close Statement> rank => -3
                               | <Dynamic Delete Statement Positioned> rank => -4
                               | <Dynamic Update Statement Positioned> rank => -5
<System Descriptor Statement> ::= <Allocate Descriptor Statement> rank => 0
                                | <Deallocate Descriptor Statement> rank => -1
                                | <Set Descriptor Statement> rank => -2
                                | <Get Descriptor Statement> rank => -3
<Cursor Sensitivity maybe> ::= <Cursor Sensitivity> rank => 0
<Cursor Sensitivity maybe> ::= rank => -1
<Cursor Scrollability maybe> ::= <Cursor Scrollability> rank => 0
<Cursor Scrollability maybe> ::= rank => -1
<Cursor Holdability maybe> ::= <Cursor Holdability> rank => 0
<Cursor Holdability maybe> ::= rank => -1
<Cursor Returnability maybe> ::= <Cursor Returnability> rank => 0
<Cursor Returnability maybe> ::= rank => -1
<Declare Cursor> ::= <Lex347> <Cursor Name> <Cursor Sensitivity maybe> <Cursor Scrollability maybe> <Lex340> <Cursor Holdability maybe> <Cursor Returnability maybe> <Lex373> <Cursor Specification> rank => 0
<Cursor Sensitivity> ::= <Lex480> rank => 0
                       | <Lex394> rank => -1
                       | <Lex298> rank => -2
<Cursor Scrollability> ::= <Lex476> rank => 0
                         | <Lex426> <Lex476> rank => -1
<Cursor Holdability> ::= <Lex529> <Lex385> rank => 0
                       | <Lex531> <Lex385> rank => -1
<Cursor Returnability> ::= <Lex529> <Lex467> rank => 0
                         | <Lex531> <Lex467> rank => -1
<Updatability Clause maybe> ::= <Updatability Clause> rank => 0
<Updatability Clause maybe> ::= rank => -1
<Cursor Specification> ::= <Query Expression> <Order By Clause maybe> <Updatability Clause maybe> rank => 0
<Gen3018> ::= <Lex431> <Column Name List> rank => 0
<Gen3018 maybe> ::= <Gen3018> rank => 0
<Gen3018 maybe> ::= rank => -1
<Gen3021> ::= <Lex215> <Lex434> rank => 0
            | <Lex514> <Gen3018 maybe> rank => -1
<Updatability Clause> ::= <Lex373> <Gen3021> rank => 0
<Order By Clause> ::= <Lex437> <Lex310> <Sort Specification List> rank => 0
<Open Statement> ::= <Lex435> <Cursor Name> rank => 0
<Fetch Orientation maybe> ::= <Fetch Orientation> rank => 0
<Fetch Orientation maybe> ::= rank => -1
<Gen3028> ::= <Fetch Orientation maybe> <Lex376> rank => 0
<Gen3028 maybe> ::= <Gen3028> rank => 0
<Gen3028 maybe> ::= rank => -1
<Fetch Statement> ::= <Lex370> <Gen3028 maybe> <Cursor Name> <Lex400> <Fetch Target List> rank => 0
<Gen3032> ::= <Lex043> rank => 0
            | <Lex216> rank => -1
<Fetch Orientation> ::= <Lex175> rank => 0
                      | <Lex211> rank => -1
                      | <Lex131> rank => -2
                      | <Lex154> rank => -3
                      | <Gen3032> <Simple Value Specification> rank => -4
<Gen3039> ::= <Comma> <Target Specification> rank => 0
<Gen3039 any> ::= <Gen3039>* rank => 0
<Fetch Target List> ::= <Target Specification> <Gen3039 any> rank => 0
<Close Statement> ::= <Lex320> <Cursor Name> rank => 0
<Select Statement Single Row> ::= <Lex479> <Set Quantifier maybe> <Select List> <Lex400> <Select Target List> <Table Expression> rank => 0
<Gen3044> ::= <Comma> <Target Specification> rank => 0
<Gen3044 any> ::= <Gen3044>* rank => 0
<Select Target List> ::= <Target Specification> <Gen3044 any> rank => 0
<Delete Statement Positioned> ::= <Lex349> <Lex376> <Target Table> <Lex526> <Lex331> <Lex431> <Cursor Name> rank => 0
<Target Table> ::= <Table Name> rank => 0
                 | <Lex434> <Left Paren> <Table Name> <Right Paren> rank => -1
<Gen3050> ::= <Lex526> <Search Condition> rank => 0
<Gen3050 maybe> ::= <Gen3050> rank => 0
<Gen3050 maybe> ::= rank => -1
<Delete Statement Searched> ::= <Lex349> <Lex376> <Target Table> <Gen3050 maybe> rank => 0
<Insert Statement> ::= <Lex395> <Lex400> <Insertion Target> <Insert Columns And Source> rank => 0
<Insertion Target> ::= <Table Name> rank => 0
<Insert Columns And Source> ::= <From Subquery> rank => 0
                              | <From Constructor> rank => -1
                              | <From Default> rank => -2
<Gen3059> ::= <Left Paren> <Insert Column List> <Right Paren> rank => 0
<Gen3059 maybe> ::= <Gen3059> rank => 0
<Gen3059 maybe> ::= rank => -1
<Override Clause maybe> ::= <Override Clause> rank => 0
<Override Clause maybe> ::= rank => -1
<From Subquery> ::= <Gen3059 maybe> <Override Clause maybe> <Query Expression> rank => 0
<Gen3065> ::= <Left Paren> <Insert Column List> <Right Paren> rank => 0
<Gen3065 maybe> ::= <Gen3065> rank => 0
<Gen3065 maybe> ::= rank => -1
<From Constructor> ::= <Gen3065 maybe> <Override Clause maybe> <Contextually Typed Table Value Constructor> rank => 0
<Override Clause> ::= <Lex191> <Lex516> <Lex518> rank => 0
                    | <Lex191> <Lex496> <Lex518> rank => -1
<From Default> ::= <Lex348> <Lex519> rank => 0
<Insert Column List> ::= <Column Name List> rank => 0
<Gen3073> ::= <Lex297 maybe> <Merge Correlation Name> rank => 0
<Gen3073 maybe> ::= <Gen3073> rank => 0
<Gen3073 maybe> ::= rank => -1
<Merge Statement> ::= <Lex414> <Lex400> <Target Table> <Gen3073 maybe> <Lex517> <Table Reference> <Lex433> <Search Condition> <Merge Operation Specification> rank => 0
<Merge Correlation Name> ::= <Correlation Name> rank => 0
<Merge When Clause many> ::= <Merge When Clause>+ rank => 0
<Merge Operation Specification> ::= <Merge When Clause many> rank => 0
<Merge When Clause> ::= <Merge When Matched Clause> rank => 0
                      | <Merge When Not Matched Clause> rank => -1
<Merge When Matched Clause> ::= <Lex524> <Lex161> <Lex499> <Merge Update Specification> rank => 0
<Merge When Not Matched Clause> ::= <Lex524> <Lex428> <Lex161> <Lex499> <Merge Insert Specification> rank => 0
<Merge Update Specification> ::= <Lex514> <Lex482> <Set Clause List> rank => 0
<Gen3085> ::= <Left Paren> <Insert Column List> <Right Paren> rank => 0
<Gen3085 maybe> ::= <Gen3085> rank => 0
<Gen3085 maybe> ::= rank => -1
<Merge Insert Specification> ::= <Lex395> <Gen3085 maybe> <Override Clause maybe> <Lex519> <Merge Insert Value List> rank => 0
<Gen3089> ::= <Comma> <Merge Insert Value Element> rank => 0
<Gen3089 any> ::= <Gen3089>* rank => 0
<Merge Insert Value List> ::= <Left Paren> <Merge Insert Value Element> <Gen3089 any> <Right Paren> rank => 0
<Merge Insert Value Element> ::= <Value Expression> rank => 0
                               | <Contextually Typed Value Specification> rank => -1
<Update Statement Positioned> ::= <Lex514> <Target Table> <Lex482> <Set Clause List> <Lex526> <Lex331> <Lex431> <Cursor Name> rank => 0
<Gen3095> ::= <Lex526> <Search Condition> rank => 0
<Gen3095 maybe> ::= <Gen3095> rank => 0
<Gen3095 maybe> ::= rank => -1
<Update Statement Searched> ::= <Lex514> <Target Table> <Lex482> <Set Clause List> <Gen3095 maybe> rank => 0
<Gen3099> ::= <Comma> <Set Clause> rank => 0
<Gen3099 any> ::= <Gen3099>* rank => 0
<Set Clause List> ::= <Set Clause> <Gen3099 any> rank => 0
<Set Clause> ::= <Multiple Column Assignment> rank => 0
               | <Set Target> <Equals Operator> <Update Source> rank => -1
<Set Target> ::= <Update Target> rank => 0
               | <Mutated Set Clause> rank => -1
<Multiple Column Assignment> ::= <Set Target List> <Equals Operator> <Assigned Row> rank => 0
<Gen3107> ::= <Comma> <Set Target> rank => 0
<Gen3107 any> ::= <Gen3107>* rank => 0
<Set Target List> ::= <Left Paren> <Set Target> <Gen3107 any> <Right Paren> rank => 0
<Assigned Row> ::= <Contextually Typed Row Value Expression> rank => 0
<Update Target> ::= <Object Column> rank => 0
                  | <Object Column> <Left Bracket Or Trigraph> <Simple Value Specification> <Right Bracket Or Trigraph> rank => -1
<Object Column> ::= <Column Name> rank => 0
<Mutated Set Clause> ::= <Mutated Target> <Period> <Method Name> rank => 0
<Mutated Target> ::= <Object Column> rank => 0
                   | <Mutated Set Clause> rank => -1
<Update Source> ::= <Value Expression> rank => 0
                  | <Contextually Typed Value Specification> rank => -1
<Gen3119> ::= <Lex433> <Lex323> <Table Commit Action> <Lex474> rank => 0
<Gen3119 maybe> ::= <Gen3119> rank => 0
<Gen3119 maybe> ::= rank => -1
<Temporary Table Declaration> ::= <Lex347> <Lex409> <Lex261> <Lex498> <Table Name> <Table Element List> <Gen3119 maybe> rank => 0
<Gen3123> ::= <Comma> <Locator Reference> rank => 0
<Gen3123 any> ::= <Gen3123>* rank => 0
<Free Locator Statement> ::= <Lex375> <Lex158> <Locator Reference> <Gen3123 any> rank => 0
<Locator Reference> ::= <Host Parameter Name> rank => 0
                      | <Embedded Variable Name> rank => -1
<Gen3128> ::= <Comma> <Locator Reference> rank => 0
<Gen3128 any> ::= <Gen3128>* rank => 0
<Hold Locator Statement> ::= <Lex385> <Lex158> <Locator Reference> <Gen3128 any> rank => 0
<Call Statement> ::= <Lex311> <Routine Invocation> rank => 0
<Return Statement> ::= <Lex467> <Return Value> rank => 0
<Return Value> ::= <Value Expression> rank => 0
                 | <Lex429> rank => -1
<Gen3135> ::= <Comma> <Transaction Mode> rank => 0
<Gen3135 any> ::= <Gen3135>* rank => 0
<Gen3137> ::= <Transaction Mode> <Gen3135 any> rank => 0
<Gen3137 maybe> ::= <Gen3137> rank => 0
<Gen3137 maybe> ::= rank => -1
<Start Transaction Statement> ::= <Lex492> <Lex264> <Gen3137 maybe> rank => 0
<Transaction Mode> ::= <Isolation Level> rank => 0
                     | <Transaction Access Mode> rank => -1
                     | <Diagnostics Size> rank => -2
<Transaction Access Mode> ::= <Lex215> <Lex434> rank => 0
                            | <Lex215> <Lex287> rank => -1
<Isolation Level> ::= <Lex150> <Lex156> <Level Of Isolation> rank => 0
<Level Of Isolation> ::= <Lex215> <Lex277> rank => 0
                       | <Lex215> <Lex086> rank => -1
                       | <Lex217> <Lex215> rank => -2
                       | <Lex240> rank => -3
<Diagnostics Size> ::= <Lex118> <Lex245> <Number Of Conditions> rank => 0
<Number Of Conditions> ::= <Simple Value Specification> rank => 0
<Lex409 maybe> ::= <Lex409> rank => 0
<Lex409 maybe> ::= rank => -1
<Set Transaction Statement> ::= <Lex482> <Lex409 maybe> <Transaction Characteristics> rank => 0
<Gen3156> ::= <Comma> <Transaction Mode> rank => 0
<Gen3156 any> ::= <Gen3156>* rank => 0
<Transaction Characteristics> ::= <Lex264> <Transaction Mode> <Gen3156 any> rank => 0
<Gen3159> ::= <Lex109> rank => 0
            | <Lex388> rank => -1
<Set Constraints Mode Statement> ::= <Lex482> <Lex090> <Constraint Name List> <Gen3159> rank => 0
<Gen3162> ::= <Comma> <Constraint Name> rank => 0
<Gen3162 any> ::= <Gen3162>* rank => 0
<Constraint Name List> ::= <Lex290> rank => 0
                         | <Constraint Name> <Gen3162 any> rank => -1
<Savepoint Statement> ::= <Lex475> <Savepoint Specifier> rank => 0
<Savepoint Specifier> ::= <Savepoint Name> rank => 0
<Release Savepoint Statement> ::= <Lex465> <Lex475> <Savepoint Specifier> rank => 0
<Lex286 maybe> ::= <Lex286> rank => 0
<Lex286 maybe> ::= rank => -1
<Lex426 maybe> ::= <Lex426> rank => 0
<Lex426 maybe> ::= rank => -1
<Gen3173> ::= <Lex293> <Lex426 maybe> <Lex065> rank => 0
<Gen3173 maybe> ::= <Gen3173> rank => 0
<Gen3173 maybe> ::= rank => -1
<Commit Statement> ::= <Lex323> <Lex286 maybe> <Gen3173 maybe> rank => 0
<Gen3177> ::= <Lex293> <Lex426 maybe> <Lex065> rank => 0
<Gen3177 maybe> ::= <Gen3177> rank => 0
<Gen3177 maybe> ::= rank => -1
<Savepoint Clause maybe> ::= <Savepoint Clause> rank => 0
<Savepoint Clause maybe> ::= rank => -1
<Rollback Statement> ::= <Lex471> <Lex286 maybe> <Gen3177 maybe> <Savepoint Clause maybe> rank => 0
<Savepoint Clause> ::= <Lex504> <Lex475> <Savepoint Specifier> rank => 0
<Connect Statement> ::= <Lex324> <Lex504> <Connection Target> rank => 0
<Gen3185> ::= <Lex297> <Connection Name> rank => 0
<Gen3185 maybe> ::= <Gen3185> rank => 0
<Gen3185 maybe> ::= rank => -1
<Gen3188> ::= <Lex516> <Connection User Name> rank => 0
<Gen3188 maybe> ::= <Gen3188> rank => 0
<Gen3188 maybe> ::= rank => -1
<Connection Target> ::= <Sql Server Name> <Gen3185 maybe> <Gen3188 maybe> rank => 0
                      | <Lex348> rank => -1
<Set Connection Statement> ::= <Lex482> <Lex554> <Connection Object> rank => 0
<Connection Object> ::= <Lex348> rank => 0
                      | <Connection Name> rank => -1
<Disconnect Statement> ::= <Lex353> <Disconnect Object> rank => 0
<Disconnect Object> ::= <Connection Object> rank => 0
                      | <Lex290> rank => -1
                      | <Lex331> rank => -2
<Set Session Characteristics Statement> ::= <Lex482> <Lex242> <Lex066> <Lex297> <Session Characteristic List> rank => 0
<Gen3201> ::= <Comma> <Session Characteristic> rank => 0
<Gen3201 any> ::= <Gen3201>* rank => 0
<Session Characteristic List> ::= <Session Characteristic> <Gen3201 any> rank => 0
<Session Characteristic> ::= <Transaction Characteristics> rank => 0
<Set Session User Identifier Statement> ::= <Lex482> <Lex242> <Lex302> <Value Specification> rank => 0
<Set Role Statement> ::= <Lex482> <Lex223> <Role Specification> rank => 0
<Role Specification> ::= <Value Specification> rank => 0
                       | <Lex427> rank => -1
<Set Local Time Zone Statement> ::= <Lex482> <Lex500> <Lex288> <Set Time Zone Value> rank => 0
<Set Time Zone Value> ::= <Interval Value Expression> rank => 0
                        | <Lex409> rank => -1
<Set Catalog Statement> ::= <Lex482> <Catalog Name Characteristic> rank => 0
<Catalog Name Characteristic> ::= <Lex061> <Value Specification> rank => 0
<Set Schema Statement> ::= <Lex482> <Schema Name Characteristic> rank => 0
<Schema Name Characteristic> ::= <Lex231> <Value Specification> rank => 0
<Set Names Statement> ::= <Lex482> <Character Set Name Characteristic> rank => 0
<Character Set Name Characteristic> ::= <Lex173> <Value Specification> rank => 0
<Set Path Statement> ::= <Lex482> <SQL Path Characteristic> rank => 0
<SQL Path Characteristic> ::= <Lex201> <Value Specification> rank => 0
<Set Transform Group Statement> ::= <Lex482> <Transform Group Characteristic> rank => 0
<Transform Group Characteristic> ::= <Lex348> <Lex268> <Lex382> <Value Specification> rank => 0
                                   | <Lex268> <Lex382> <Lex373> <Lex275> <Path Resolved User Defined Type Name> <Value Specification> rank => -1
<Gen3223> ::= <Lex373> <Character Set Specification List> rank => 0
<Gen3223 maybe> ::= <Gen3223> rank => 0
<Gen3223 maybe> ::= rank => -1
<Gen3226> ::= <Lex373> <Character Set Specification List> rank => 0
<Gen3226 maybe> ::= <Gen3226> rank => 0
<Gen3226 maybe> ::= rank => -1
<Set Session Collation Statement> ::= <Lex482> <Lex078> <Collation Specification> <Gen3223 maybe> rank => 0
                                    | <Lex482> <Lex426> <Lex078> <Gen3226 maybe> rank => -1
<Gen3231> ::= <Lex013> <Character Set Specification> rank => 0
<Gen3231 any> ::= <Gen3231>* rank => 0
<Character Set Specification List> ::= <Character Set Specification> <Gen3231 any> rank => -1
<Collation Specification> ::= <Value Specification> rank => 0
<Lex488 maybe> ::= <Lex488> rank => 0
<Lex488 maybe> ::= rank => -1
<Gen3237> ::= <Lex529> <Lex162> <Occurrences> rank => 0
<Gen3237 maybe> ::= <Gen3237> rank => 0
<Gen3237 maybe> ::= rank => -1
<Allocate Descriptor Statement> ::= <Lex291> <Lex488 maybe> <Lex117> <Descriptor Name> <Gen3237 maybe> rank => 0
<Occurrences> ::= <Simple Value Specification> rank => 0
<Deallocate Descriptor Statement> ::= <Lex344> <Lex488 maybe> <Lex117> <Descriptor Name> rank => 0
<Get Descriptor Statement> ::= <Lex379> <Lex488 maybe> <Lex117> <Descriptor Name> <Get Descriptor Information> rank => 0
<Gen3244> ::= <Comma> <Get Header Information> rank => 0
<Gen3244 any> ::= <Gen3244>* rank => 0
<Gen3246> ::= <Comma> <Get Item Information> rank => 0
<Gen3246 any> ::= <Gen3246>* rank => 0
<Get Descriptor Information> ::= <Get Header Information> <Gen3244 any> rank => 0
                               | <Lex518> <Item Number> <Get Item Information> <Gen3246 any> rank => -1
<Get Header Information> ::= <Simple Target Specification 1> <Equals Operator> <Header Item Name> rank => 0
<Header Item Name> ::= <Lex098> rank => 0
                     | <Lex153> rank => -1
                     | <Lex121> rank => -2
                     | <Lex122> rank => -3
                     | <Lex263> rank => -4
<Get Item Information> ::= <Simple Target Specification 2> <Equals Operator> <Descriptor Item Name> rank => 0
<Item Number> ::= <Simple Value Specification> rank => 0
<Simple Target Specification 1> ::= <Simple Target Specification> rank => 0
<Simple Target Specification 2> ::= <Simple Target Specification> rank => 0
<Descriptor Item Name> ::= <Lex059> rank => 0
                         | <Lex069> rank => -1
                         | <Lex070> rank => -2
                         | <Lex071> rank => -3
                         | <Lex079> rank => -4
                         | <Lex080> rank => -5
                         | <Lex081> rank => -6
                         | <Lex104> rank => -7
                         | <Lex105> rank => -8
                         | <Lex106> rank => -9
                         | <Lex112> rank => -10
                         | <Lex390> rank => -11
                         | <Lex152> rank => -12
                         | <Lex155> rank => -13
                         | <Lex156> rank => -14
                         | <Lex172> rank => -15
                         | <Lex178> rank => -16
                         | <Lex184> rank => -17
                         | <Lex193> rank => -18
                         | <Lex195> rank => -19
                         | <Lex196> rank => -20
                         | <Lex197> rank => -21
                         | <Lex198> rank => -22
                         | <Lex445> rank => -23
                         | <Lex219> rank => -24
                         | <Lex220> rank => -25
                         | <Lex221> rank => -26
                         | <Lex230> rank => -27
                         | <Lex233> rank => -28
                         | <Lex234> rank => -29
                         | <Lex235> rank => -30
                         | <Lex275> rank => -31
                         | <Lex279> rank => -32
                         | <Lex281> rank => -33
                         | <Lex283> rank => -34
                         | <Lex284> rank => -35
                         | <Lex282> rank => -36
<Set Descriptor Statement> ::= <Lex482> <Lex488 maybe> <Lex117> <Descriptor Name> <Set Descriptor Information> rank => 0
<Gen3298> ::= <Comma> <Set Header Information> rank => 0
<Gen3298 any> ::= <Gen3298>* rank => 0
<Gen3300> ::= <Comma> <Set Item Information> rank => 0
<Gen3300 any> ::= <Gen3300>* rank => 0
<Set Descriptor Information> ::= <Set Header Information> <Gen3298 any> rank => 0
                               | <Lex518> <Item Number> <Set Item Information> <Gen3300 any> rank => -1
<Set Header Information> ::= <Header Item Name> <Equals Operator> <Simple Value Specification 1> rank => 0
<Set Item Information> ::= <Descriptor Item Name> <Equals Operator> <Simple Value Specification 2> rank => 0
<Simple Value Specification 1> ::= <Simple Value Specification> rank => 0
<Simple Value Specification 2> ::= <Simple Value Specification> rank => 0
<Attributes Specification maybe> ::= <Attributes Specification> rank => 0
<Attributes Specification maybe> ::= rank => -1
<Prepare Statement> ::= <Lex446> <SQL Statement Name> <Attributes Specification maybe> <Lex376> <SQL Statement Variable> rank => 0
<Attributes Specification> ::= <Lex053> <Attributes Variable> rank => 0
<Attributes Variable> ::= <Simple Value Specification> rank => 0
<SQL Statement Variable> ::= <Simple Value Specification> rank => 0
<Preparable Statement> ::= <Preparable SQL Data Statement> rank => 0
                         | <Preparable SQL Schema Statement> rank => -1
                         | <Preparable SQL Transaction Statement> rank => -2
                         | <Preparable SQL Control Statement> rank => -3
                         | <Preparable SQL Session Statement> rank => -4
<Preparable SQL Data Statement> ::= <Delete Statement Searched> rank => 0
                                  | <Dynamic Single Row Select Statement> rank => -1
                                  | <Insert Statement> rank => -2
                                  | <Dynamic Select Statement> rank => -3
                                  | <Update Statement Searched> rank => -4
                                  | <Merge Statement> rank => -5
                                  | <Preparable Dynamic Delete Statement Positioned> rank => -6
                                  | <Preparable Dynamic Update Statement Positioned> rank => -7
<Preparable SQL Schema Statement> ::= <SQL Schema Statement> rank => 0
<Preparable SQL Transaction Statement> ::= <SQL Transaction Statement> rank => 0
<Preparable SQL Control Statement> ::= <SQL Control Statement> rank => 0
<Preparable SQL Session Statement> ::= <SQL Session Statement> rank => 0
<Dynamic Select Statement> ::= <Cursor Specification> rank => 0
<Cursor Attribute many> ::= <Cursor Attribute>+ rank => 0
<Cursor Attributes> ::= <Cursor Attribute many> rank => 0
<Cursor Attribute> ::= <Cursor Sensitivity> rank => 0
                     | <Cursor Scrollability> rank => -1
                     | <Cursor Holdability> rank => -2
                     | <Cursor Returnability> rank => -3
<Deallocate Prepared Statement> ::= <Lex344> <Lex446> <SQL Statement Name> rank => 0
<Describe Statement> ::= <Describe Input Statement> rank => 0
                       | <Describe Output Statement> rank => -1
<Nesting Option maybe> ::= <Nesting Option> rank => 0
<Nesting Option maybe> ::= rank => -1
<Describe Input Statement> ::= <Lex351> <Lex393> <SQL Statement Name> <Using Descriptor> <Nesting Option maybe> rank => 0
<Lex440 maybe> ::= <Lex440> rank => 0
<Lex440 maybe> ::= rank => -1
<Describe Output Statement> ::= <Lex351> <Lex440 maybe> <Described Object> <Using Descriptor> <Nesting Option maybe> rank => 0
<Nesting Option> ::= <Lex529> <Lex174> rank => 0
                   | <Lex531> <Lex174> rank => -1
<Using Descriptor> ::= <Lex517> <Lex488 maybe> <Lex117> <Descriptor Name> rank => 0
<Described Object> ::= <SQL Statement Name> rank => 0
                     | <Lex340> <Extended Cursor Name> <Lex254> rank => -1
<Input Using Clause> ::= <Using Arguments> rank => 0
                       | <Using Input Descriptor> rank => -1
<Gen3354> ::= <Comma> <Using Argument> rank => 0
<Gen3354 any> ::= <Gen3354>* rank => 0
<Using Arguments> ::= <Lex517> <Using Argument> <Gen3354 any> rank => 0
<Using Argument> ::= <General Value Specification> rank => 0
<Using Input Descriptor> ::= <Using Descriptor> rank => 0
<Output Using Clause> ::= <Into Arguments> rank => 0
                        | <Into Descriptor> rank => -1
<Gen3361> ::= <Comma> <Into Argument> rank => 0
<Gen3361 any> ::= <Gen3361>* rank => 0
<Into Arguments> ::= <Lex400> <Into Argument> <Gen3361 any> rank => 0
<Into Argument> ::= <Target Specification> rank => 0
<Into Descriptor> ::= <Lex400> <Lex488 maybe> <Lex117> <Descriptor Name> rank => 0
<Result Using Clause maybe> ::= <Result Using Clause> rank => 0
<Result Using Clause maybe> ::= rank => -1
<Parameter Using Clause maybe> ::= <Parameter Using Clause> rank => 0
<Parameter Using Clause maybe> ::= rank => -1
<Execute Statement> ::= <Lex366> <SQL Statement Name> <Result Using Clause maybe> <Parameter Using Clause maybe> rank => 0
<Result Using Clause> ::= <Output Using Clause> rank => 0
<Parameter Using Clause> ::= <Input Using Clause> rank => 0
<Execute Immediate Statement> ::= <Lex366> <Lex388> <SQL Statement Variable> rank => 0
<Dynamic Declare Cursor> ::= <Lex347> <Cursor Name> <Cursor Sensitivity maybe> <Cursor Scrollability maybe> <Lex340> <Cursor Holdability maybe> <Cursor Returnability maybe> <Lex373> <Statement Name> rank => 0
<Allocate Cursor Statement> ::= <Lex291> <Extended Cursor Name> <Cursor Intent> rank => 0
<Cursor Intent> ::= <Statement Cursor> rank => 0
                  | <Result Set Cursor> rank => -1
<Statement Cursor> ::= <Cursor Sensitivity maybe> <Cursor Scrollability maybe> <Lex340> <Cursor Holdability maybe> <Cursor Returnability maybe> <Lex373> <Extended Statement Name> rank => 0
<Result Set Cursor> ::= <Lex373> <Lex448> <Specific Routine Designator> rank => 0
<Input Using Clause maybe> ::= <Input Using Clause> rank => 0
<Input Using Clause maybe> ::= rank => -1
<Dynamic Open Statement> ::= <Lex435> <Dynamic Cursor Name> <Input Using Clause maybe> rank => 0
<Gen3383> ::= <Fetch Orientation maybe> <Lex376> rank => 0
<Gen3383 maybe> ::= <Gen3383> rank => 0
<Gen3383 maybe> ::= rank => -1
<Dynamic Fetch Statement> ::= <Lex370> <Gen3383 maybe> <Dynamic Cursor Name> <Output Using Clause> rank => 0
<Dynamic Single Row Select Statement> ::= <Query Specification> rank => 0
<Dynamic Close Statement> ::= <Lex320> <Dynamic Cursor Name> rank => 0
<Dynamic Delete Statement Positioned> ::= <Lex349> <Lex376> <Target Table> <Lex526> <Lex331> <Lex431> <Dynamic Cursor Name> rank => 0
<Dynamic Update Statement Positioned> ::= <Lex514> <Target Table> <Lex482> <Set Clause List> <Lex526> <Lex331> <Lex431> <Dynamic Cursor Name> rank => 0
<Gen3391> ::= <Lex376> <Target Table> rank => 0
<Gen3391 maybe> ::= <Gen3391> rank => 0
<Gen3391 maybe> ::= rank => -1
<Preparable Dynamic Delete Statement Positioned> ::= <Lex349> <Gen3391 maybe> <Lex526> <Lex331> <Lex431> <Scope Option maybe> <Cursor Name> rank => 0
<Target Table maybe> ::= <Target Table> rank => 0
<Target Table maybe> ::= rank => -1
<Preparable Dynamic Update Statement Positioned> ::= <Lex514> <Target Table maybe> <Lex482> <Set Clause List> <Lex526> <Lex331> <Lex431> <Scope Option maybe> <Cursor Name> rank => 0
<Embedded SQL Host Program> ::= <Embedded SQL Ada Program> rank => 0
                              | <Embedded SQL C Program> rank => -1
                              | <Embedded SQL Cobol Program> rank => -2
                              | <Embedded SQL Fortran Program> rank => -3
                              | <Embedded SQL Mumps Program> rank => -4
                              | <Embedded SQL Pascal Program> rank => -5
                              | <Embedded SQL Pl I Program> rank => -6
<SQL Terminator maybe> ::= <SQL Terminator> rank => 0
<SQL Terminator maybe> ::= rank => -1
<Embedded SQL Statement> ::= <SQL Prefix> <Statement Or Declaration> <SQL Terminator maybe> rank => 0
<Statement Or Declaration> ::= <Declare Cursor> rank => 0
                             | <Dynamic Declare Cursor> rank => -1
                             | <Temporary Table Declaration> rank => -2
                             | <Embedded Authorization Declaration> rank => -3
                             | <Embedded Path Specification> rank => -4
                             | <Embedded Transform Group Specification> rank => -5
                             | <Embedded Collation Specification> rank => -6
                             | <Embedded Exception Declaration> rank => -7
                             | <SQL Procedure Statement> rank => -8
<SQL Prefix> ::= <Lex365> <Lex488> rank => 0
               | <Ampersand> <Lex488> <Left Paren> rank => -1
<SQL Terminator> ::= <Lex362> rank => 0
                   | <Semicolon> rank => -1
                   | <Right Paren> rank => -2
<Embedded Authorization Declaration> ::= <Lex347> <Embedded Authorization Clause> rank => 0
<Gen3423> ::= <Lex434> rank => 0
            | <Lex293> <Lex357> rank => -1
<Gen3425> ::= <Lex373> <Lex493> <Gen3423> rank => 0
<Gen3425 maybe> ::= <Gen3425> rank => 0
<Gen3425 maybe> ::= rank => -1
<Gen3428> ::= <Lex434> rank => 0
            | <Lex293> <Lex357> rank => -1
<Gen3430> ::= <Lex373> <Lex493> <Gen3428> rank => 0
<Gen3430 maybe> ::= <Gen3430> rank => 0
<Gen3430 maybe> ::= rank => -1
<Embedded Authorization Clause> ::= <Lex231> <Schema Name> rank => 0
                                  | <Lex302> <Embedded Authorization Identifier> <Gen3425 maybe> rank => -1
                                  | <Lex231> <Schema Name> <Lex302> <Embedded Authorization Identifier> <Gen3430 maybe> rank => -2
<Embedded Authorization Identifier> ::= <Module Authorization Identifier> rank => 0
<Embedded Path Specification> ::= <Path Specification> rank => 0
<Embedded Transform Group Specification> ::= <Transform Group Specification> rank => 0
<Embedded Collation Specification> ::= <Module Collations> rank => 0
<Embedded Character Set Declaration maybe> ::= <Embedded Character Set Declaration> rank => 0
<Embedded Character Set Declaration maybe> ::= rank => -1
<Host Variable Definition any> ::= <Host Variable Definition>* rank => 0
<Embedded SQL Declare Section> ::= <Embedded SQL Begin Declare> <Embedded Character Set Declaration maybe> <Host Variable Definition any> <Embedded SQL End Declare> rank => 0
                                 | <Embedded SQL Mumps Declare> rank => -1
<Embedded Character Set Declaration> ::= <Lex488> <Lex173> <Lex295> <Character Set Specification> rank => 0
<Embedded SQL Begin Declare> ::= <SQL Prefix> <Lex303> <Lex347> <Lex236> <SQL Terminator maybe> rank => 0
<Embedded SQL End Declare> ::= <SQL Prefix> <Lex361> <Lex347> <Lex236> <SQL Terminator maybe> rank => 0
<Embedded SQL Mumps Declare> ::= <SQL Prefix> <Lex303> <Lex347> <Lex236> <Embedded Character Set Declaration maybe> <Host Variable Definition any> <Lex361> <Lex347> <Lex236> <SQL Terminator> rank => 0
<Host Variable Definition> ::= <Ada Variable Definition> rank => 0
                             | <C Variable Definition> rank => -1
                             | <Cobol Variable Definition> rank => -2
                             | <Fortran Variable Definition> rank => -3
                             | <Mumps Variable Definition> rank => -4
                             | <Pascal Variable Definition> rank => -5
                             | <Pl I Variable Definition> rank => -6
<Embedded Variable Name> ::= <Colon> <Host Identifier> rank => 0
<Host Identifier> ::= <Ada Host Identifier> rank => 0
                    | <C Host Identifier> rank => -1
                    | <Cobol Host Identifier> rank => -2
                    | <Fortran Host Identifier> rank => -3
                    | <Mumps Host Identifier> rank => -4
                    | <Pascal Host Identifier> rank => -5
                    | <Pl I Host Identifier> rank => -6
<Embedded Exception Declaration> ::= <Lex525> <Condition> <Condition Action> rank => 0
<Condition> ::= <SQL Condition> rank => 0
<Gen3466> ::= <Lex013> <Sqlstate Subclass Value> rank => 0
<Gen3466 maybe> ::= <Gen3466> rank => 0
<Gen3466 maybe> ::= rank => -1
<Gen3469> ::= <Sqlstate Class Value> <Gen3466 maybe> rank => 0
<SQL Condition> ::= <Major Category> rank => 0
                  | <Lex490> <Gen3469> rank => -1
                  | <Lex325> <Constraint Name> rank => -2
<Major Category> ::= <Lex489> rank => 0
                   | <Lex491> rank => -1
                   | <Lex428> <Lex135> rank => -2
<Sqlstate Class Value> ::= <Sqlstate Char> <Sqlstate Char> rank => 0
<Sqlstate Subclass Value> ::= <Sqlstate Char> <Sqlstate Char> <Sqlstate Char> rank => 0
<Sqlstate Char> ::= <Simple Latin Upper Case Letter> rank => 0
                  | <Digit> rank => -1
<Condition Action> ::= <Lex326> rank => 0
                     | <Go To> rank => -1
<Gen3482> ::= <Lex139> rank => 0
            | <Lex138> <Lex504> rank => -1
<Go To> ::= <Gen3482> <Goto Target> rank => 0
<Goto Target> ::= <Unsigned Integer> rank => 0
<Embedded SQL Ada Program> ::= <Lex365> <Lex488> rank => 0
<Gen3487> ::= <Comma> <Ada Host Identifier> rank => 0
<Gen3487 any> ::= <Gen3487>* rank => 0
<Ada Initial Value maybe> ::= <Ada Initial Value> rank => 0
<Ada Initial Value maybe> ::= rank => -1
<Ada Variable Definition> ::= <Ada Host Identifier> <Gen3487 any> <Colon> <Ada Type Specification> <Ada Initial Value maybe> rank => 0
<Character Representation many> ::= <Character Representation>+ rank => 0
<Ada Initial Value> ::= <Ada Assignment Operator> <Character Representation many> rank => 0
<Ada Assignment Operator> ::= <Colon> <Equals Operator> rank => 0
<Underscore maybe> ::= <Underscore> rank => 0
<Underscore maybe> ::= rank => -1
<Gen3497> ::= <Ada Host Identifier Letter> rank => 0
            | <Digit> rank => -1
<Gen3499> ::= <Underscore maybe> <Gen3497> rank => 0
<Gen3499 any> ::= <Gen3499>* rank => 0
<Ada Host Identifier> ::= <Ada Host Identifier Letter> <Gen3499 any> rank => 0
<Ada Host Identifier Letter> ::= <Simple Latin Letter> rank => 0
<Ada Type Specification> ::= <Ada Qualified Type Specification> rank => 0
                           | <Ada Unqualified Type Specification> rank => -1
                           | <Ada Derived Type Specification> rank => -2
<Lex401 maybe> ::= <Lex401> rank => 0
<Lex401 maybe> ::= rank => -1
<Gen3508> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3508 maybe> ::= <Gen3508> rank => 0
<Gen3508 maybe> ::= rank => -1
<Ada Qualified Type Specification> ::= <Lex555> <Period> <Lex316> <Gen3508 maybe> <Left Paren> <Lex556> <Double Period> <Length> <Right Paren> rank => 0
                                     | <Lex555> <Period> <Lex484> rank => -1
                                     | <Lex555> <Period> <Lex396> rank => -2
                                     | <Lex555> <Period> <Lex305> rank => -3
                                     | <Lex555> <Period> <Lex451> rank => -4
                                     | <Lex555> <Period> <Lex557> rank => -5
                                     | <Lex555> <Period> <Lex308> rank => -6
                                     | <Lex555> <Period> <Lex558> rank => -7
                                     | <Lex555> <Period> <Lex559> rank => -8
<Ada Unqualified Type Specification> ::= <Lex316> <Left Paren> <Lex556> <Double Period> <Length> <Right Paren> rank => 0
                                       | <Lex484> rank => -1
                                       | <Lex396> rank => -2
                                       | <Lex305> rank => -3
                                       | <Lex451> rank => -4
                                       | <Lex557> rank => -5
                                       | <Lex308> rank => -6
                                       | <Lex558> rank => -7
                                       | <Lex559> rank => -8
<Ada Derived Type Specification> ::= <Ada Clob Variable> rank => 0
                                   | <Ada Clob Locator Variable> rank => -1
                                   | <Ada Blob Variable> rank => -2
                                   | <Ada Blob Locator Variable> rank => -3
                                   | <Ada User Defined Type Variable> rank => -4
                                   | <Ada User Defined Type Locator Variable> rank => -5
                                   | <Ada Ref Variable> rank => -6
                                   | <Ada Array Locator Variable> rank => -7
                                   | <Ada Multiset Locator Variable> rank => -8
<Gen3538> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3538 maybe> ::= <Gen3538> rank => 0
<Gen3538 maybe> ::= rank => -1
<Ada Clob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left Paren> <Large Object Length> <Right Paren> <Gen3538 maybe> rank => 0
<Ada Clob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Ada Blob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Ada Blob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Ada User Defined Type Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Predefined Type> rank => 0
<Ada User Defined Type Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Lex158> rank => 0
<Ada Ref Variable> ::= <Lex488> <Lex275> <Lex401> <Reference Type> rank => 0
<Ada Array Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Array Type> <Lex297> <Lex158> rank => 0
<Ada Multiset Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset Type> <Lex297> <Lex158> rank => 0
<Embedded SQL C Program> ::= <Lex365> <Lex488> rank => 0
<C Storage Class maybe> ::= <C Storage Class> rank => 0
<C Storage Class maybe> ::= rank => -1
<C Class Modifier maybe> ::= <C Class Modifier> rank => 0
<C Class Modifier maybe> ::= rank => -1
<C Variable Definition> ::= <C Storage Class maybe> <C Class Modifier maybe> <C Variable Specification> <Semicolon> rank => 0
<C Variable Specification> ::= <C Numeric Variable> rank => 0
                             | <C Character Variable> rank => -1
                             | <C Derived Variable> rank => -2
<C Storage Class> ::= <Lex560> rank => 0
                    | <Lex561> rank => -1
                    | <Lex562> rank => -2
<C Class Modifier> ::= <Lex563> rank => 0
                     | <Lex564> rank => -1
<Gen3564> ::= <Lex565> <Lex565> rank => 0
            | <Lex565> rank => -1
            | <Lex566> rank => -2
            | <Lex567> rank => -3
            | <Lex568> rank => -4
<C Initial Value maybe> ::= <C Initial Value> rank => 0
<C Initial Value maybe> ::= rank => -1
<Gen3571> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3571 any> ::= <Gen3571>* rank => 0
<C Numeric Variable> ::= <Gen3564> <C Host Identifier> <C Initial Value maybe> <Gen3571 any> rank => 0
<Gen3574> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3574 maybe> ::= <Gen3574> rank => 0
<Gen3574 maybe> ::= rank => -1
<Gen3577> ::= <Comma> <C Host Identifier> <C Array Specification> <C Initial Value maybe> rank => 0
<Gen3577 any> ::= <Gen3577>* rank => 0
<C Character Variable> ::= <C Character Type> <Gen3574 maybe> <C Host Identifier> <C Array Specification> <C Initial Value maybe> <Gen3577 any> rank => 0
<C Character Type> ::= <Lex569> rank => 0
                     | <Lex570> <Lex569> rank => -1
                     | <Lex570> <Lex566> rank => -2
<C Array Specification> ::= <Left Bracket> <Length> <Right Bracket> rank => 0
<C Host Identifier> ::= <Regular Identifier> rank => 0
<C Derived Variable> ::= <C Varchar Variable> rank => 0
                       | <C Nchar Variable> rank => -1
                       | <C Nchar Varying Variable> rank => -2
                       | <C Clob Variable> rank => -3
                       | <C Nclob Variable> rank => -4
                       | <C Blob Variable> rank => -5
                       | <C User Defined Type Variable> rank => -6
                       | <C Clob Locator Variable> rank => -7
                       | <C Blob Locator Variable> rank => -8
                       | <C Array Locator Variable> rank => -9
                       | <C Multiset Locator Variable> rank => -10
                       | <C User Defined Type Locator Variable> rank => -11
                       | <C Ref Variable> rank => -12
<Gen3598> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3598 maybe> ::= <Gen3598> rank => 0
<Gen3598 maybe> ::= rank => -1
<Gen3601> ::= <Comma> <C Host Identifier> <C Array Specification> <C Initial Value maybe> rank => 0
<Gen3601 any> ::= <Gen3601>* rank => 0
<C Varchar Variable> ::= <Lex522> <Gen3598 maybe> <C Host Identifier> <C Array Specification> <C Initial Value maybe> <Gen3601 any> rank => 0
<Gen3604> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3604 maybe> ::= <Gen3604> rank => 0
<Gen3604 maybe> ::= rank => -1
<Gen3607> ::= <Comma> <C Host Identifier> <C Array Specification> <C Initial Value maybe> rank => 0
<Gen3607 any> ::= <Gen3607>* rank => 0
<C Nchar Variable> ::= <Lex423> <Gen3604 maybe> <C Host Identifier> <C Array Specification> <C Initial Value maybe> <Gen3607 any> rank => 0
<Gen3610> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3610 maybe> ::= <Gen3610> rank => 0
<Gen3610 maybe> ::= rank => -1
<Gen3613> ::= <Comma> <C Host Identifier> <C Array Specification> <C Initial Value maybe> rank => 0
<Gen3613 any> ::= <Gen3613>* rank => 0
<C Nchar Varying Variable> ::= <Lex423> <Lex523> <Gen3610 maybe> <C Host Identifier> <C Array Specification> <C Initial Value maybe> <Gen3613 any> rank => 0
<Gen3616> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3616 maybe> ::= <Gen3616> rank => 0
<Gen3616 maybe> ::= rank => -1
<Gen3619> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3619 any> ::= <Gen3619>* rank => 0
<C Clob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left Paren> <Large Object Length> <Right Paren> <Gen3616 maybe> <C Host Identifier> <C Initial Value maybe> <Gen3619 any> rank => 0
<Gen3622> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3622 maybe> ::= <Gen3622> rank => 0
<Gen3622 maybe> ::= rank => -1
<Gen3625> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3625 any> ::= <Gen3625>* rank => 0
<C Nclob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex424> <Left Paren> <Large Object Length> <Right Paren> <Gen3622 maybe> <C Host Identifier> <C Initial Value maybe> <Gen3625 any> rank => 0
<Gen3628> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3628 any> ::= <Gen3628>* rank => 0
<C User Defined Type Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Predefined Type> <C Host Identifier> <C Initial Value maybe> <Gen3628 any> rank => 0
<Gen3631> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3631 any> ::= <Gen3631>* rank => 0
<C Blob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left Paren> <Large Object Length> <Right Paren> <C Host Identifier> <C Initial Value maybe> <Gen3631 any> rank => 0
<Gen3634> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3634 any> ::= <Gen3634>* rank => 0
<C Clob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> <C Host Identifier> <C Initial Value maybe> <Gen3634 any> rank => 0
<Gen3637> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3637 any> ::= <Gen3637>* rank => 0
<C Blob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> <C Host Identifier> <C Initial Value maybe> <Gen3637 any> rank => 0
<Gen3640> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3640 any> ::= <Gen3640>* rank => 0
<C Array Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Array Type> <Lex297> <Lex158> <C Host Identifier> <C Initial Value maybe> <Gen3640 any> rank => 0
<Gen3643> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3643 any> ::= <Gen3643>* rank => 0
<C Multiset Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset Type> <Lex297> <Lex158> <C Host Identifier> <C Initial Value maybe> <Gen3643 any> rank => 0
<Gen3646> ::= <Comma> <C Host Identifier> <C Initial Value maybe> rank => 0
<Gen3646 any> ::= <Gen3646>* rank => 0
<C User Defined Type Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Lex158> <C Host Identifier> <C Initial Value maybe> <Gen3646 any> rank => 0
<C Ref Variable> ::= <Lex488> <Lex275> <Lex401> <Reference Type> rank => 0
<C Initial Value> ::= <Equals Operator> <Character Representation many> rank => 0
<Embedded SQL Cobol Program> ::= <Lex365> <Lex488> rank => 0
<Gen3652> ::= <Lex571> rank => 0
            | <Lex572> rank => -1
<Cobol Variable Definition> ::= <Gen3652> <Cobol Host Identifier> <Cobol Type Specification> <Character Representation any> <Period> rank => 0
<Gen3655> ::= <Lex009> <Cobol Subscript> <Lex010> rank => 0
<Gen3655 any> ::= <Gen3655>* rank => 0
<Cobol Length maybe> ::= <Cobol Length> rank => 0
<Cobol Length maybe> ::= rank => -1
<Gen3659> ::= <Lex009> <Cobol Leftmost Character Position> <Lex017> <Cobol Length maybe> <Lex010> rank => 0
<Gen3659 maybe> ::= <Gen3659> rank => 0
<Gen3659 maybe> ::= rank => -1
<Cobol Host Identifier> ::= <Cobol Qualified Data Name> <Gen3655 any> <Gen3659 maybe> rank => 0
<Gen3663> ::= <Lex389> rank => 0
            | <Lex431> rank => -1
<Gen3665> ::= <Gen3663> <Cobol Data Name> rank => 0
<Gen3665 any> ::= <Gen3665>* rank => 0
<Gen3667> ::= <Lex389> rank => 0
            | <Lex431> rank => -1
<Gen3669> ::= <Gen3667> <Cobol File Name> rank => 0
<Gen3669 maybe> ::= <Gen3669> rank => 0
<Gen3669 maybe> ::= rank => -1
<Cobol Qualified Data Name> ::= <Cobol Data Name> <Gen3665 any> <Gen3669 maybe> rank => 0
<Cobol Data Name> ::= <Cobol Alphabetic User Defined Word> rank => 0
<Gen3674> ::= <Lex573 many> rank => 0
<Gen3674> ::= rank => -1
<Gen3676> ::= <Digit many> <Gen3674> rank => 0
<Gen3676 any> ::= <Gen3676>* rank => 0
<Digit any> ::= <Digit>* rank => 0
<Gen3679> ::= <Lex575 many> rank => 0
<Gen3679> ::= rank => -1
<Gen3681> ::= <Lex576 many> <Lex577 many> rank => 0
<Gen3681 any> ::= <Gen3681>* rank => 0
<Cobol Alphabetic User Defined Word> ::= <Gen3676 any> <Digit any> <Lex574> <Gen3679> <Gen3681 any> rank => 0
<Cobol File Name> ::= <Cobol Alphabetic User Defined Word> rank => 0
<Gen3685> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3687> ::= <Gen3685> <Cobol Integer> rank => 0
<Gen3687 maybe> ::= <Gen3687> rank => 0
<Gen3687 maybe> ::= rank => -1
<Gen3690> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3692> ::= <Gen3690> <Cobol Integer> rank => 0
<Gen3692 maybe> ::= <Gen3692> rank => 0
<Gen3692 maybe> ::= rank => -1
<Gen3695> ::= <Cobol Integer> rank => 0
            | <Cobol Qualified Data Name> <Gen3687 maybe> rank => -1
            | <Cobol Index Name> <Gen3692 maybe> rank => -2
<Gen3695 many> ::= <Gen3695>+ rank => 0
<Cobol Subscript> ::= <Gen3695 many> rank => 0
<Gen3700> ::= <Lex578 many> rank => 0
<Gen3700> ::= rank => -1
<Cobol Integer> ::= <Gen3700> <Lex579> <Digit any> rank => 0
<Cobol Index Name> ::= <Cobol Alphabetic User Defined Word> rank => 0
<Gen3704> ::= <Lex389> rank => 0
            | <Lex431> rank => -1
<Gen3706> ::= <Gen3704> <Cobol File Name> rank => 0
<Gen3706 maybe> ::= <Gen3706> rank => 0
<Gen3706 maybe> ::= rank => -1
<Cobol Host Identifier> ::= <Lex580> <Gen3706 maybe> rank => -1
<Cobol Leftmost Character Position> ::= <Cobol Arithmetic Expression> rank => 0
<Cobol Length> ::= <Cobol Arithmetic Expression> rank => 0
<Gen3712> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3714> ::= <Gen3712> <Cobol Times Div> rank => 0
<Gen3714 any> ::= <Gen3714>* rank => 0
<Cobol Arithmetic Expression> ::= <Cobol Times Div> <Gen3714 any> rank => 0
<Gen3717> ::= <Lex011> rank => 0
            | <Lex016> rank => -1
<Gen3719> ::= <Gen3717> <Cobol Power> rank => 0
<Gen3719 any> ::= <Gen3719>* rank => 0
<Cobol Times Div> ::= <Cobol Power> <Gen3719 any> rank => 0
<Gen3722> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3724> ::= <Gen3722> rank => 0
<Gen3724 maybe> ::= <Gen3724> rank => 0
<Gen3724 maybe> ::= rank => -1
<Gen3727> ::= <Lex581> <Cobol Basis> rank => 0
<Gen3727 any> ::= <Gen3727>* rank => 0
<Cobol Power> ::= <Gen3724 maybe> <Cobol Basis> <Gen3727 any> rank => 0
<Cobol Basis> ::= <Cobol Host Identifier> rank => 0
                | <Cobol Literal> rank => -1
                | <Lex009> <Cobol Arithmetic Expression> <Lex010> rank => -2
<Cobol Literal> ::= <Cobol Nonnumeric> rank => 0
                  | <Cobol Numeric> rank => -1
                  | <Cobol Figurative Constant> rank => -2
<Gen3736> ::= <Lex038> rank => 0
            | <Lex005> <Lex005> rank => -1
<Gen3736 any> ::= <Gen3736>* rank => 0
<Gen3739> ::= <Lex533> rank => 0
            | <Lex008> <Lex008> rank => -1
<Gen3739 any> ::= <Gen3739>* rank => 0
<Cobol Nonnumeric> ::= <Lex005> <Gen3736 any> <Lex005> rank => 0
                     | <Lex008> <Gen3739 any> <Lex008> rank => -1
                     | <Lex535> <Lex005> <Cobol Hexdigits> <Lex005> rank => -2
                     | <Lex535> <Lex008> <Cobol Hexdigits> <Lex008> rank => -3
<Cobol Hexdigits> ::= <Lex582 many> rank => 0
<Gen3747> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3747 maybe> ::= <Gen3747> rank => 0
<Gen3747 maybe> ::= rank => -1
<Gen3751> ::= <Digit any> <Lex015> <Digit many> rank => 0
            | <Digit many> rank => -1
<Cobol Numeric> ::= <Gen3747 maybe> <Gen3751> rank => 0
<Cobol Figurative Constant> ::= <Lex583> rank => 0
                              | <Lex584> rank => -1
                              | <Lex585> rank => -2
                              | <Lex247> rank => -3
                              | <Lex586> rank => -4
                              | <Lex587> rank => -5
                              | <Lex588> rank => -6
                              | <Lex589> rank => -7
                              | <Lex590> rank => -8
                              | <Lex591> rank => -9
                              | <Lex592> rank => -10
                              | <Lex290> <Cobol Literal> rank => -11
                              | <Lex429> rank => -12
                              | <Lex180> rank => -13
<Cobol Type Specification> ::= <Cobol Character Type> rank => 0
                             | <Cobol National Character Type> rank => -1
                             | <Cobol Numeric Type> rank => -2
                             | <Cobol Integer Type> rank => -3
                             | <Cobol Derived Type Specification> rank => -4
<Cobol Derived Type Specification> ::= <Cobol Clob Variable> rank => 0
                                     | <Cobol Nclob Variable> rank => -1
                                     | <Cobol Blob Variable> rank => -2
                                     | <Cobol User Defined Type Variable> rank => -3
                                     | <Cobol Clob Locator Variable> rank => -4
                                     | <Cobol Blob Locator Variable> rank => -5
                                     | <Cobol Array Locator Variable> rank => -6
                                     | <Cobol Multiset Locator Variable> rank => -7
                                     | <Cobol User Defined Type Locator Variable> rank => -8
                                     | <Cobol Ref Variable> rank => -9
<Gen3783> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3783 maybe> ::= <Gen3783> rank => 0
<Gen3783 maybe> ::= rank => -1
<Gen3786> ::= <Lex593> rank => 0
            | <Lex594> rank => -1
<Gen3788> ::= <Left Paren> <Length> <Right Paren> rank => 0
<Gen3788 maybe> ::= <Gen3788> rank => 0
<Gen3788 maybe> ::= rank => -1
<Gen3791> ::= <Lex535> <Gen3788 maybe> rank => 0
<Gen3791 many> ::= <Gen3791>+ rank => 0
<Cobol Character Type> ::= <Gen3783 maybe> <Gen3786> <Lex401 maybe> <Gen3791 many> rank => 0
<Gen3794> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3794 maybe> ::= <Gen3794> rank => 0
<Gen3794 maybe> ::= rank => -1
<Gen3797> ::= <Lex593> rank => 0
            | <Lex594> rank => -1
<Gen3799> ::= <Left Paren> <Length> <Right Paren> rank => 0
<Gen3799 maybe> ::= <Gen3799> rank => 0
<Gen3799 maybe> ::= rank => -1
<Gen3802> ::= <Lex534> <Gen3799 maybe> rank => 0
<Gen3802 many> ::= <Gen3802>+ rank => 0
<Cobol National Character Type> ::= <Gen3794 maybe> <Gen3797> <Lex401 maybe> <Gen3802 many> rank => 0
<Gen3805> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3805 maybe> ::= <Gen3805> rank => 0
<Gen3805 maybe> ::= rank => -1
<Gen3808> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3808 maybe> ::= <Gen3808> rank => 0
<Gen3808 maybe> ::= rank => -1
<Cobol Clob Variable> ::= <Gen3805 maybe> <Lex488> <Lex275> <Lex401> <Lex319> <Left Paren> <Large Object Length> <Right Paren> <Gen3808 maybe> rank => 0
<Gen3812> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3812 maybe> ::= <Gen3812> rank => 0
<Gen3812 maybe> ::= rank => -1
<Gen3815> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3815 maybe> ::= <Gen3815> rank => 0
<Gen3815 maybe> ::= rank => -1
<Cobol Nclob Variable> ::= <Gen3812 maybe> <Lex488> <Lex275> <Lex401> <Lex424> <Left Paren> <Large Object Length> <Right Paren> <Gen3815 maybe> rank => 0
<Gen3819> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3819 maybe> ::= <Gen3819> rank => 0
<Gen3819 maybe> ::= rank => -1
<Cobol Blob Variable> ::= <Gen3819 maybe> <Lex488> <Lex275> <Lex401> <Lex307> <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Gen3823> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3823 maybe> ::= <Gen3823> rank => 0
<Gen3823 maybe> ::= rank => -1
<Cobol User Defined Type Variable> ::= <Gen3823 maybe> <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Predefined Type> rank => 0
<Gen3827> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3827 maybe> ::= <Gen3827> rank => 0
<Gen3827 maybe> ::= rank => -1
<Cobol Clob Locator Variable> ::= <Gen3827 maybe> <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Gen3831> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3831 maybe> ::= <Gen3831> rank => 0
<Gen3831 maybe> ::= rank => -1
<Cobol Blob Locator Variable> ::= <Gen3831 maybe> <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Gen3835> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3835 maybe> ::= <Gen3835> rank => 0
<Gen3835 maybe> ::= rank => -1
<Cobol Array Locator Variable> ::= <Gen3835 maybe> <Lex488> <Lex275> <Lex401> <Array Type> <Lex297> <Lex158> rank => 0
<Gen3839> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3839 maybe> ::= <Gen3839> rank => 0
<Gen3839 maybe> ::= rank => -1
<Cobol Multiset Locator Variable> ::= <Gen3839 maybe> <Lex488> <Lex275> <Lex401> <Multiset Type> <Lex297> <Lex158> rank => 0
<Gen3843> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3843 maybe> ::= <Gen3843> rank => 0
<Gen3843 maybe> ::= rank => -1
<Cobol User Defined Type Locator Variable> ::= <Gen3843 maybe> <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Lex158> rank => 0
<Gen3847> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3847 maybe> ::= <Gen3847> rank => 0
<Gen3847 maybe> ::= rank => -1
<Cobol Ref Variable> ::= <Gen3847 maybe> <Lex488> <Lex275> <Lex401> <Reference Type> rank => 0
<Gen3851> ::= <Lex593> rank => 0
            | <Lex594> rank => -1
<Gen3853> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3853 maybe> ::= <Gen3853> rank => 0
<Gen3853 maybe> ::= rank => -1
<Cobol Numeric Type> ::= <Gen3851> <Lex401 maybe> <Lex595> <Cobol Nines Specification> <Gen3853 maybe> <Lex596> <Lex597> <Lex406> <Lex598> rank => 0
<Cobol Nines maybe> ::= <Cobol Nines> rank => 0
<Cobol Nines maybe> ::= rank => -1
<Gen3859> ::= <Lex599> <Cobol Nines maybe> rank => 0
<Gen3859 maybe> ::= <Gen3859> rank => 0
<Gen3859 maybe> ::= rank => -1
<Cobol Nines Specification> ::= <Cobol Nines> <Gen3859 maybe> rank => 0
                              | <Lex599> <Cobol Nines> rank => -1
<Cobol Integer Type> ::= <Cobol Binary Integer> rank => 0
<Gen3865> ::= <Lex593> rank => 0
            | <Lex594> rank => -1
<Gen3867> ::= <Lex280> <Lex401 maybe> rank => 0
<Gen3867 maybe> ::= <Gen3867> rank => 0
<Gen3867 maybe> ::= rank => -1
<Cobol Binary Integer> ::= <Gen3865> <Lex401 maybe> <Lex595> <Cobol Nines> <Gen3867 maybe> <Lex306> rank => 0
<Gen3871> ::= <Left Paren> <Length> <Right Paren> rank => 0
<Gen3871 maybe> ::= <Gen3871> rank => 0
<Gen3871 maybe> ::= rank => -1
<Gen3874> ::= <Lex600> <Gen3871 maybe> rank => 0
<Gen3874 many> ::= <Gen3874>+ rank => 0
<Cobol Nines> ::= <Gen3874 many> rank => 0
<Embedded SQL Fortran Program> ::= <Lex365> <Lex488> rank => 0
<Gen3878> ::= <Comma> <Fortran Host Identifier> rank => 0
<Gen3878 any> ::= <Gen3878>* rank => 0
<Fortran Variable Definition> ::= <Fortran Type Specification> <Fortran Host Identifier> <Gen3878 any> rank => 0
<Fortran Host Identifier> ::= <Regular Identifier> rank => 0
<Gen3882> ::= <Asterisk> <Length> rank => 0
<Gen3882 maybe> ::= <Gen3882> rank => 0
<Gen3882 maybe> ::= rank => -1
<Gen3885> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3885 maybe> ::= <Gen3885> rank => 0
<Gen3885 maybe> ::= rank => -1
<Gen3888> ::= <Lex003 many> rank => 0
<Gen3888> ::= rank => -1
<Gen3890> ::= <Asterisk> <Length> rank => 0
<Gen3890 maybe> ::= <Gen3890> rank => 0
<Gen3890 maybe> ::= rank => -1
<Gen3893> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3893 maybe> ::= <Gen3893> rank => 0
<Gen3893 maybe> ::= rank => -1
<Fortran Type Specification> ::= <Lex317> <Gen3882 maybe> <Gen3885 maybe> rank => 0
                               | <Lex317> <Lex601> <Lex020> <Lex003> <Gen3888> <Gen3890 maybe> <Gen3893 maybe> rank => -1
                               | <Lex397> rank => -2
                               | <Lex451> rank => -3
                               | <Lex355> <Lex445> rank => -4
                               | <Lex603> rank => -5
                               | <Fortran Derived Type Specification> rank => -6
<Fortran Derived Type Specification> ::= <Fortran Clob Variable> rank => 0
                                       | <Fortran Blob Variable> rank => -1
                                       | <Fortran User Defined Type Variable> rank => -2
                                       | <Fortran Clob Locator Variable> rank => -3
                                       | <Fortran Blob Locator Variable> rank => -4
                                       | <Fortran User Defined Type Locator Variable> rank => -5
                                       | <Fortran Array Locator Variable> rank => -6
                                       | <Fortran Multiset Locator Variable> rank => -7
                                       | <Fortran Ref Variable> rank => -8
<Gen3912> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3912 maybe> ::= <Gen3912> rank => 0
<Gen3912 maybe> ::= rank => -1
<Fortran Clob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left Paren> <Large Object Length> <Right Paren> <Gen3912 maybe> rank => 0
<Fortran Blob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Fortran User Defined Type Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Predefined Type> rank => 0
<Fortran Clob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Fortran Blob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Fortran User Defined Type Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Lex158> rank => 0
<Fortran Array Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Array Type> <Lex297> <Lex158> rank => 0
<Fortran Multiset Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset Type> <Lex297> <Lex158> rank => 0
<Fortran Ref Variable> ::= <Lex488> <Lex275> <Lex401> <Reference Type> rank => 0
<Embedded SQL Mumps Program> ::= <Lex365> <Lex488> rank => 0
<Mumps Variable Definition> ::= <Mumps Numeric Variable> <Semicolon> rank => 0
                              | <Mumps Character Variable> <Semicolon> rank => -1
                              | <Mumps Derived Type Specification> <Semicolon> rank => -2
<Gen3928> ::= <Comma> <Mumps Host Identifier> <Mumps Length Specification> rank => 0
<Gen3928 any> ::= <Gen3928>* rank => 0
<Mumps Character Variable> ::= <Lex522> <Mumps Host Identifier> <Mumps Length Specification> <Gen3928 any> rank => 0
<Mumps Host Identifier> ::= <Regular Identifier> rank => 0
<Mumps Length Specification> ::= <Left Paren> <Length> <Right Paren> rank => 0
<Gen3933> ::= <Comma> <Mumps Host Identifier> rank => 0
<Gen3933 any> ::= <Gen3933>* rank => 0
<Mumps Numeric Variable> ::= <Mumps Type Specification> <Mumps Host Identifier> <Gen3933 any> rank => 0
<Gen3936> ::= <Comma> <Scale> rank => 0
<Gen3936 maybe> ::= <Gen3936> rank => 0
<Gen3936 maybe> ::= rank => -1
<Gen3939> ::= <Left Paren> <Precision> <Gen3936 maybe> <Right Paren> rank => 0
<Gen3939 maybe> ::= <Gen3939> rank => 0
<Gen3939 maybe> ::= rank => -1
<Mumps Type Specification> ::= <Lex396> rank => 0
                             | <Lex345> <Gen3939 maybe> rank => -1
                             | <Lex451> rank => -2
<Mumps Derived Type Specification> ::= <Mumps Clob Variable> rank => 0
                                     | <Mumps Blob Variable> rank => -1
                                     | <Mumps User Defined Type Variable> rank => -2
                                     | <Mumps Clob Locator Variable> rank => -3
                                     | <Mumps Blob Locator Variable> rank => -4
                                     | <Mumps User Defined Type Locator Variable> rank => -5
                                     | <Mumps Array Locator Variable> rank => -6
                                     | <Mumps Multiset Locator Variable> rank => -7
                                     | <Mumps Ref Variable> rank => -8
<Gen3954> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3954 maybe> ::= <Gen3954> rank => 0
<Gen3954 maybe> ::= rank => -1
<Mumps Clob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left Paren> <Large Object Length> <Right Paren> <Gen3954 maybe> rank => 0
<Mumps Blob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Mumps User Defined Type Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Predefined Type> rank => 0
<Mumps Clob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Mumps Blob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Mumps User Defined Type Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Lex158> rank => 0
<Mumps Array Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Array Type> <Lex297> <Lex158> rank => 0
<Mumps Multiset Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset Type> <Lex297> <Lex158> rank => 0
<Mumps Ref Variable> ::= <Lex488> <Lex275> <Lex401> <Reference Type> rank => 0
<Embedded SQL Pascal Program> ::= <Lex365> <Lex488> rank => 0
<Gen3967> ::= <Comma> <Pascal Host Identifier> rank => 0
<Gen3967 any> ::= <Gen3967>* rank => 0
<Pascal Variable Definition> ::= <Pascal Host Identifier> <Gen3967 any> <Colon> <Pascal Type Specification> <Semicolon> rank => 0
<Pascal Host Identifier> ::= <Regular Identifier> rank => 0
<Gen3971> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3971 maybe> ::= <Gen3971> rank => 0
<Gen3971 maybe> ::= rank => -1
<Gen3974> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3974 maybe> ::= <Gen3974> rank => 0
<Gen3974 maybe> ::= rank => -1
<Pascal Type Specification> ::= <Lex604> <Lex296> <Left Bracket> <Lex556> <Double Period> <Length> <Right Bracket> <Lex431> <Lex316> <Gen3971 maybe> rank => 0
                              | <Lex397> rank => -1
                              | <Lex451> rank => -2
                              | <Lex316> <Gen3974 maybe> rank => -3
                              | <Lex308> rank => -4
                              | <Pascal Derived Type Specification> rank => -5
<Pascal Derived Type Specification> ::= <Pascal Clob Variable> rank => 0
                                      | <Pascal Blob Variable> rank => -1
                                      | <Pascal User Defined Type Variable> rank => -2
                                      | <Pascal Clob Locator Variable> rank => -3
                                      | <Pascal Blob Locator Variable> rank => -4
                                      | <Pascal User Defined Type Locator Variable> rank => -5
                                      | <Pascal Array Locator Variable> rank => -6
                                      | <Pascal Multiset Locator Variable> rank => -7
                                      | <Pascal Ref Variable> rank => -8
<Gen3992> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen3992 maybe> ::= <Gen3992> rank => 0
<Gen3992 maybe> ::= rank => -1
<Pascal Clob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left Paren> <Large Object Length> <Right Paren> <Gen3992 maybe> rank => 0
<Pascal Blob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Pascal Clob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Pascal User Defined Type Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Predefined Type> rank => 0
<Pascal Blob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Pascal User Defined Type Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Lex158> rank => 0
<Pascal Array Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Array Type> <Lex297> <Lex158> rank => 0
<Pascal Multiset Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset Type> <Lex297> <Lex158> rank => 0
<Pascal Ref Variable> ::= <Lex488> <Lex275> <Lex401> <Reference Type> rank => 0
<Embedded SQL Pl I Program> ::= <Lex365> <Lex488> rank => 0
<Gen4005> ::= <Lex605> rank => 0
            | <Lex347> rank => -1
<Gen4007> ::= <Comma> <Pl I Host Identifier> rank => 0
<Gen4007 any> ::= <Gen4007>* rank => 0
<Pl I Variable Definition> ::= <Gen4005> <Pl I Host Identifier> <Left Paren> <Pl I Host Identifier> <Gen4007 any> <Right Paren> <Pl I Type Specification> <Character Representation any> <Semicolon> rank => 0
<Pl I Host Identifier> ::= <Regular Identifier> rank => 0
<Gen4011> ::= <Lex316> rank => 0
            | <Lex317> rank => -1
<Lex523 maybe> ::= <Lex523> rank => 0
<Lex523 maybe> ::= rank => -1
<Gen4015> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen4015 maybe> ::= <Gen4015> rank => 0
<Gen4015 maybe> ::= rank => -1
<Gen4018> ::= <Comma> <Scale> rank => 0
<Gen4018 maybe> ::= <Gen4018> rank => 0
<Gen4018 maybe> ::= rank => -1
<Gen4021> ::= <Left Paren> <Precision> <Right Paren> rank => 0
<Gen4021 maybe> ::= <Gen4021> rank => 0
<Gen4021 maybe> ::= rank => -1
<Pl I Type Specification> ::= <Gen4011> <Lex523 maybe> <Left Paren> <Length> <Right Paren> <Gen4015 maybe> rank => 0
                            | <Pl I Type Fixed Decimal> <Left Paren> <Precision> <Gen4018 maybe> <Right Paren> rank => -1
                            | <Pl I Type Fixed Binary> <Gen4021 maybe> rank => -2
                            | <Pl I Type Float Binary> <Left Paren> <Precision> <Right Paren> rank => -3
                            | <Pl I Derived Type Specification> rank => -4
<Pl I Derived Type Specification> ::= <Pl I Clob Variable> rank => 0
                                    | <Pl I Blob Variable> rank => -1
                                    | <Pl I User Defined Type Variable> rank => -2
                                    | <Pl I Clob Locator Variable> rank => -3
                                    | <Pl I Blob Locator Variable> rank => -4
                                    | <Pl I User Defined Type Locator Variable> rank => -5
                                    | <Pl I Array Locator Variable> rank => -6
                                    | <Pl I Multiset Locator Variable> rank => -7
                                    | <Pl I Ref Variable> rank => -8
<Gen4038> ::= <Lex317> <Lex482> <Lex401 maybe> <Character Set Specification> rank => 0
<Gen4038 maybe> ::= <Gen4038> rank => 0
<Gen4038 maybe> ::= rank => -1
<Pl I Clob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left Paren> <Large Object Length> <Right Paren> <Gen4038 maybe> rank => 0
<Pl I Blob Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left Paren> <Large Object Length> <Right Paren> rank => 0
<Pl I User Defined Type Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Predefined Type> rank => 0
<Pl I Clob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Pl I Blob Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Pl I User Defined Type Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Path Resolved User Defined Type Name> <Lex297> <Lex158> rank => 0
<Pl I Array Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Array Type> <Lex297> <Lex158> rank => 0
<Pl I Multiset Locator Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset Type> <Lex297> <Lex158> rank => 0
<Pl I Ref Variable> ::= <Lex488> <Lex275> <Lex401> <Reference Type> rank => 0
<Gen4050> ::= <Lex345> rank => 0
            | <Lex346> rank => -1
<Gen4052> ::= <Lex345> rank => 0
            | <Lex346> rank => -1
<Pl I Type Fixed Decimal> ::= <Gen4050> <Lex606> rank => 0
                            | <Lex606> <Gen4052> rank => -1
<Gen4056> ::= <Lex607> rank => 0
            | <Lex306> rank => -1
<Gen4058> ::= <Lex607> rank => 0
            | <Lex306> rank => -1
<Pl I Type Fixed Binary> ::= <Gen4056> <Lex606> rank => 0
                           | <Lex606> <Gen4058> rank => -1
<Gen4062> ::= <Lex607> rank => 0
            | <Lex306> rank => -1
<Gen4064> ::= <Lex607> rank => 0
            | <Lex306> rank => -1
<Pl I Type Float Binary> ::= <Gen4062> <Lex372> rank => 0
                           | <Lex372> <Gen4064> rank => -1
<Direct SQL Statement> ::= <Directly Executable Statement> <Semicolon> rank => 0
<Directly Executable Statement> ::= <Direct SQL Data Statement> rank => 0
                                  | <SQL Schema Statement> rank => -1
                                  | <SQL Transaction Statement> rank => -2
                                  | <SQL Connection Statement> rank => -3
                                  | <SQL Session Statement> rank => -4
<Direct SQL Data Statement> ::= <Delete Statement Searched> rank => 0
                              | <Direct Select Statement Multiple Rows> rank => -1
                              | <Insert Statement> rank => -2
                              | <Update Statement Searched> rank => -3
                              | <Merge Statement> rank => -4
                              | <Temporary Table Declaration> rank => -5
<Direct Select Statement Multiple Rows> ::= <Cursor Specification> rank => 0
<Get Diagnostics Statement> ::= <Lex379> <Lex118> <SQL Diagnostics Information> rank => 0
<SQL Diagnostics Information> ::= <Statement Information> rank => 0
                                | <Condition Information> rank => -1
<Gen4084> ::= <Comma> <Statement Information Item> rank => 0
<Gen4084 any> ::= <Gen4084>* rank => 0
<Statement Information> ::= <Statement Information Item> <Gen4084 any> rank => 0
<Statement Information Item> ::= <Simple Target Specification> <Equals Operator> <Statement Information Item Name> rank => 0
<Statement Information Item Name> ::= <Lex181> rank => 0
                                    | <Lex170> rank => -1
                                    | <Lex084> rank => -2
                                    | <Lex085> rank => -3
                                    | <Lex121> rank => -4
                                    | <Lex122> rank => -5
                                    | <Lex228> rank => -6
                                    | <Lex265> rank => -7
                                    | <Lex266> rank => -8
                                    | <Lex267> rank => -9
<Gen4098> ::= <Lex125> rank => 0
            | <Lex087> rank => -1
<Gen4100> ::= <Comma> <Condition Information Item> rank => 0
<Gen4100 any> ::= <Gen4100>* rank => 0
<Condition Information> ::= <Gen4098> <Condition Number> <Condition Information Item> <Gen4100 any> rank => 0
<Condition Information Item> ::= <Simple Target Specification> <Equals Operator> <Condition Information Item Name> rank => 0
<Condition Information Item Name> ::= <Lex062> rank => 0
                                    | <Lex074> rank => -1
                                    | <Lex083> rank => -2
                                    | <Lex088> rank => -3
                                    | <Lex089> rank => -4
                                    | <Lex091> rank => -5
                                    | <Lex092> rank => -6
                                    | <Lex093> rank => -7
                                    | <Lex103> rank => -8
                                    | <Lex164> rank => -9
                                    | <Lex165> rank => -10
                                    | <Lex166> rank => -11
                                    | <Lex193> rank => -12
                                    | <Lex194> rank => -13
                                    | <Lex195> rank => -14
                                    | <Lex222> rank => -15
                                    | <Lex225> rank => -16
                                    | <Lex226> rank => -17
                                    | <Lex227> rank => -18
                                    | <Lex232> rank => -19
                                    | <Lex241> rank => -20
                                    | <Lex248> rank => -21
                                    | <Lex256> rank => -22
                                    | <Lex260> rank => -23
                                    | <Lex271> rank => -24
                                    | <Lex272> rank => -25
                                    | <Lex273> rank => -26
<Condition Number> ::= <Simple Value Specification> rank => 0
<Lex001> ~ [A-Z]
<Lex002> ~ [a-z]
<Lex003> ~ [0-9]
<Lex003 many> ~ [0-9]*
<Lex004> ~ [\s]
<Lex005> ~ '"'
<Lex006> ~ '%'
<Lex007> ~ '&'
<Lex008> ~ [']
<Lex009> ~ '('
<Lex010> ~ ')'
<Lex011> ~ '*'
<Lex012> ~ '+'
<Lex013> ~ ','
<Lex014> ~ '-'
<Lex015> ~ '.'
<Lex016> ~ '/'
<Lex017> ~ ':'
<Lex018> ~ ';'
<Lex019> ~ '<'
<Lex020> ~ '='
<Lex021> ~ '>'
<Lex022> ~ '?'
<Lex023> ~ '['
<Lex024> ::= '?':i '?':i '(':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex025> ~ ']'
<Lex026> ::= '?':i '?':i ')':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex027> ~ '^'
<Lex028> ~ '_'
<Lex029> ~ '|'
<Lex030> ~ '{'
<Lex031> ~ '}'
<Lex032> ~ 'K'
<Lex033> ~ 'M'
<Lex034> ~ 'G'
<Lex035> ~ 'U'
<Lex036> ::= 'U':i 'E':i 'S':i 'C':i 'A':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex037> ~ [\x{1b}]
<Lex038> ~ [^\"]
<Lex039> ::= '"':i '"':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex040> ~ [\n]
<Lex041> ~ 'A'
<Lex042> ::= 'A':i 'B':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex043> ::= 'A':i 'B':i 'S':i 'O':i 'L':i 'U':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex044> ::= 'A':i 'C':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex045> ::= 'A':i 'D':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex046> ::= 'A':i 'D':i 'M':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex047> ::= 'A':i 'F':i 'T':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex048> ::= 'A':i 'L':i 'W':i 'A':i 'Y':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex049> ::= 'A':i 'S':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex050> ::= 'A':i 'S':i 'S':i 'E':i 'R':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex051> ::= 'A':i 'S':i 'S':i 'I':i 'G':i 'N':i 'M':i 'E':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex052> ::= 'A':i 'T':i 'T':i 'R':i 'I':i 'B':i 'U':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex053> ::= 'A':i 'T':i 'T':i 'R':i 'I':i 'B':i 'U':i 'T':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex054> ::= 'A':i 'V':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex055> ::= 'B':i 'E':i 'F':i 'O':i 'R':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex056> ::= 'B':i 'E':i 'R':i 'N':i 'O':i 'U':i 'L':i 'L':i 'I':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex057> ::= 'B':i 'R':i 'E':i 'A':i 'D':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex058> ~ 'C'
<Lex059> ::= 'C':i 'A':i 'R':i 'D':i 'I':i 'N':i 'A':i 'L':i 'I':i 'T':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex060> ::= 'C':i 'A':i 'S':i 'C':i 'A':i 'D':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex061> ::= 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex062> ::= 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex063> ::= 'C':i 'E':i 'I':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex064> ::= 'C':i 'E':i 'I':i 'L':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex065> ::= 'C':i 'H':i 'A':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex066> ::= 'C':i 'H':i 'A':i 'R':i 'A':i 'C':i 'T':i 'E':i 'R':i 'I':i 'S':i 'T':i 'I':i 'C':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex067> ::= 'C':i 'H':i 'A':i 'R':i 'A':i 'C':i 'T':i 'E':i 'R':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex068> ::= 'C':i 'H':i 'A':i 'R':i 'A':i 'C':i 'T':i 'E':i 'R':i '_':i 'L':i 'E':i 'N':i 'G':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex069> ::= 'C':i 'H':i 'A':i 'R':i 'A':i 'C':i 'T':i 'E':i 'R':i '_':i 'S':i 'E':i 'T':i '_':i 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex070> ::= 'C':i 'H':i 'A':i 'R':i 'A':i 'C':i 'T':i 'E':i 'R':i '_':i 'S':i 'E':i 'T':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex071> ::= 'C':i 'H':i 'A':i 'R':i 'A':i 'C':i 'T':i 'E':i 'R':i '_':i 'S':i 'E':i 'T':i '_':i 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex072> ::= 'C':i 'H':i 'A':i 'R':i '_':i 'L':i 'E':i 'N':i 'G':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex073> ::= 'C':i 'H':i 'E':i 'C':i 'K':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex074> ::= 'C':i 'L':i 'A':i 'S':i 'S':i '_':i 'O':i 'R':i 'I':i 'G':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex075> ::= 'C':i 'O':i 'A':i 'L':i 'E':i 'S':i 'C':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex076> ::= 'C':i 'O':i 'B':i 'O':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex077> ::= 'C':i 'O':i 'D':i 'E':i '_':i 'U':i 'N':i 'I':i 'T':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex078> ::= 'C':i 'O':i 'L':i 'L':i 'A':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex079> ::= 'C':i 'O':i 'L':i 'L':i 'A':i 'T':i 'I':i 'O':i 'N':i '_':i 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex080> ::= 'C':i 'O':i 'L':i 'L':i 'A':i 'T':i 'I':i 'O':i 'N':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex081> ::= 'C':i 'O':i 'L':i 'L':i 'A':i 'T':i 'I':i 'O':i 'N':i '_':i 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex082> ::= 'C':i 'O':i 'L':i 'L':i 'E':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex083> ::= 'C':i 'O':i 'L':i 'U':i 'M':i 'N':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex084> ::= 'C':i 'O':i 'M':i 'M':i 'A':i 'N':i 'D':i '_':i 'F':i 'U':i 'N':i 'C':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex085> ::= 'C':i 'O':i 'M':i 'M':i 'A':i 'N':i 'D':i '_':i 'F':i 'U':i 'N':i 'C':i 'T':i 'I':i 'O':i 'N':i '_':i 'C':i 'O':i 'D':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex086> ::= 'C':i 'O':i 'M':i 'M':i 'I':i 'T':i 'T':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex087> ::= 'C':i 'O':i 'N':i 'D':i 'I':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex088> ::= 'C':i 'O':i 'N':i 'D':i 'I':i 'T':i 'I':i 'O':i 'N':i '_':i 'N':i 'U':i 'M':i 'B':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex089> ::= 'C':i 'O':i 'N':i 'N':i 'E':i 'C':i 'T':i 'I':i 'O':i 'N':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex090> ::= 'C':i 'O':i 'N':i 'S':i 'T':i 'R':i 'A':i 'I':i 'N':i 'T':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex091> ::= 'C':i 'O':i 'N':i 'S':i 'T':i 'R':i 'A':i 'I':i 'N':i 'T':i '_':i 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex092> ::= 'C':i 'O':i 'N':i 'S':i 'T':i 'R':i 'A':i 'I':i 'N':i 'T':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex093> ::= 'C':i 'O':i 'N':i 'S':i 'T':i 'R':i 'A':i 'I':i 'N':i 'T':i '_':i 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex094> ::= 'C':i 'O':i 'N':i 'S':i 'T':i 'R':i 'U':i 'C':i 'T':i 'O':i 'R':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex095> ::= 'C':i 'O':i 'N':i 'T':i 'A':i 'I':i 'N':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex096> ::= 'C':i 'O':i 'N':i 'V':i 'E':i 'R':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex097> ::= 'C':i 'O':i 'R':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex098> ::= 'C':i 'O':i 'U':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex099> ::= 'C':i 'O':i 'V':i 'A':i 'R':i '_':i 'P':i 'O':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex100> ::= 'C':i 'O':i 'V':i 'A':i 'R':i '_':i 'S':i 'A':i 'M':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex101> ::= 'C':i 'U':i 'M':i 'E':i '_':i 'D':i 'I':i 'S':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex102> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i '_':i 'C':i 'O':i 'L':i 'L':i 'A':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex103> ::= 'C':i 'U':i 'R':i 'S':i 'O':i 'R':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex104> ::= 'D':i 'A':i 'T':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex105> ::= 'D':i 'A':i 'T':i 'E':i 'T':i 'I':i 'M':i 'E':i '_':i 'I':i 'N':i 'T':i 'E':i 'R':i 'V':i 'A':i 'L':i '_':i 'C':i 'O':i 'D':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex106> ::= 'D':i 'A':i 'T':i 'E':i 'T':i 'I':i 'M':i 'E':i '_':i 'I':i 'N':i 'T':i 'E':i 'R':i 'V':i 'A':i 'L':i '_':i 'P':i 'R':i 'E':i 'C':i 'I':i 'S':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex107> ::= 'D':i 'E':i 'F':i 'A':i 'U':i 'L':i 'T':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex108> ::= 'D':i 'E':i 'F':i 'E':i 'R':i 'R':i 'A':i 'B':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex109> ::= 'D':i 'E':i 'F':i 'E':i 'R':i 'R':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex110> ::= 'D':i 'E':i 'F':i 'I':i 'N':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex111> ::= 'D':i 'E':i 'F':i 'I':i 'N':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex112> ::= 'D':i 'E':i 'G':i 'R':i 'E':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex113> ::= 'D':i 'E':i 'N':i 'S':i 'E':i '_':i 'R':i 'A':i 'N':i 'K':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex114> ::= 'D':i 'E':i 'P':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex115> ::= 'D':i 'E':i 'R':i 'I':i 'V':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex116> ::= 'D':i 'E':i 'S':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex117> ::= 'D':i 'E':i 'S':i 'C':i 'R':i 'I':i 'P':i 'T':i 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex118> ::= 'D':i 'I':i 'A':i 'G':i 'N':i 'O':i 'S':i 'T':i 'I':i 'C':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex119> ::= 'D':i 'I':i 'S':i 'P':i 'A':i 'T':i 'C':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex120> ::= 'D':i 'O':i 'M':i 'A':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex121> ::= 'D':i 'Y':i 'N':i 'A':i 'M':i 'I':i 'C':i '_':i 'F':i 'U':i 'N':i 'C':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex122> ::= 'D':i 'Y':i 'N':i 'A':i 'M':i 'I':i 'C':i '_':i 'F':i 'U':i 'N':i 'C':i 'T':i 'I':i 'O':i 'N':i '_':i 'C':i 'O':i 'D':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex123> ::= 'E':i 'Q':i 'U':i 'A':i 'L':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex124> ::= 'E':i 'V':i 'E':i 'R':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex125> ::= 'E':i 'X':i 'C':i 'E':i 'P':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex126> ::= 'E':i 'X':i 'C':i 'L':i 'U':i 'D':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex127> ::= 'E':i 'X':i 'C':i 'L':i 'U':i 'D':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex128> ::= 'E':i 'X':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex129> ::= 'E':i 'X':i 'T':i 'R':i 'A':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex130> ::= 'F':i 'I':i 'N':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex131> ::= 'F':i 'I':i 'R':i 'S':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex132> ::= 'F':i 'L':i 'O':i 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex133> ::= 'F':i 'O':i 'L':i 'L':i 'O':i 'W':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex134> ::= 'F':i 'O':i 'R':i 'T':i 'R':i 'A':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex135> ::= 'F':i 'O':i 'U':i 'N':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex136> ::= 'F':i 'U':i 'S':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex137> ::= 'G':i 'E':i 'N':i 'E':i 'R':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex138> ::= 'G':i 'O':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex139> ::= 'G':i 'O':i 'T':i 'O':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex140> ::= 'G':i 'R':i 'A':i 'N':i 'T':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex141> ::= 'H':i 'I':i 'E':i 'R':i 'A':i 'R':i 'C':i 'H':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex142> ::= 'I':i 'M':i 'P':i 'L':i 'E':i 'M':i 'E':i 'N':i 'T':i 'A':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex143> ::= 'I':i 'N':i 'C':i 'L':i 'U':i 'D':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex144> ::= 'I':i 'N':i 'C':i 'R':i 'E':i 'M':i 'E':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex145> ::= 'I':i 'N':i 'I':i 'T':i 'I':i 'A':i 'L':i 'L':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex146> ::= 'I':i 'N':i 'S':i 'T':i 'A':i 'N':i 'C':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex147> ::= 'I':i 'N':i 'S':i 'T':i 'A':i 'N':i 'T':i 'I':i 'A':i 'B':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex148> ::= 'I':i 'N':i 'T':i 'E':i 'R':i 'S':i 'E':i 'C':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex149> ::= 'I':i 'N':i 'V':i 'O':i 'K':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex150> ::= 'I':i 'S':i 'O':i 'L':i 'A':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex151> ::= 'K':i 'E':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex152> ::= 'K':i 'E':i 'Y':i '_':i 'M':i 'E':i 'M':i 'B':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex153> ::= 'K':i 'E':i 'Y':i '_':i 'T':i 'Y':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex154> ::= 'L':i 'A':i 'S':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex155> ::= 'L':i 'E':i 'N':i 'G':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex156> ::= 'L':i 'E':i 'V':i 'E':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex157> ::= 'L':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex158> ::= 'L':i 'O':i 'C':i 'A':i 'T':i 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex159> ::= 'L':i 'O':i 'W':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex160> ::= 'M':i 'A':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex161> ::= 'M':i 'A':i 'T':i 'C':i 'H':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex162> ::= 'M':i 'A':i 'X':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex163> ::= 'M':i 'A':i 'X':i 'V':i 'A':i 'L':i 'U':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex164> ::= 'M':i 'E':i 'S':i 'S':i 'A':i 'G':i 'E':i '_':i 'L':i 'E':i 'N':i 'G':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex165> ::= 'M':i 'E':i 'S':i 'S':i 'A':i 'G':i 'E':i '_':i 'O':i 'C':i 'T':i 'E':i 'T':i '_':i 'L':i 'E':i 'N':i 'G':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex166> ::= 'M':i 'E':i 'S':i 'S':i 'A':i 'G':i 'E':i '_':i 'T':i 'E':i 'X':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex167> ::= 'M':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex168> ::= 'M':i 'I':i 'N':i 'V':i 'A':i 'L':i 'U':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex169> ::= 'M':i 'O':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex170> ::= 'M':i 'O':i 'R':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex171> ::= 'M':i 'U':i 'M':i 'P':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex172> ::= 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex173> ::= 'N':i 'A':i 'M':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex174> ::= 'N':i 'E':i 'S':i 'T':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex175> ::= 'N':i 'E':i 'X':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex176> ::= 'N':i 'O':i 'R':i 'M':i 'A':i 'L':i 'I':i 'Z':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex177> ::= 'N':i 'O':i 'R':i 'M':i 'A':i 'L':i 'I':i 'Z':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex178> ::= 'N':i 'U':i 'L':i 'L':i 'A':i 'B':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex179> ::= 'N':i 'U':i 'L':i 'L':i 'I':i 'F':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex180> ::= 'N':i 'U':i 'L':i 'L':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex181> ::= 'N':i 'U':i 'M':i 'B':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex182> ::= 'O':i 'B':i 'J':i 'E':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex183> ::= 'O':i 'C':i 'T':i 'E':i 'T':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex184> ::= 'O':i 'C':i 'T':i 'E':i 'T':i '_':i 'L':i 'E':i 'N':i 'G':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex185> ::= 'O':i 'P':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex186> ::= 'O':i 'P':i 'T':i 'I':i 'O':i 'N':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex187> ::= 'O':i 'R':i 'D':i 'E':i 'R':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex188> ::= 'O':i 'R':i 'D':i 'I':i 'N':i 'A':i 'L':i 'I':i 'T':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex189> ::= 'O':i 'T':i 'H':i 'E':i 'R':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex190> ::= 'O':i 'V':i 'E':i 'R':i 'L':i 'A':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex191> ::= 'O':i 'V':i 'E':i 'R':i 'R':i 'I':i 'D':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex192> ::= 'P':i 'A':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex193> ::= 'P':i 'A':i 'R':i 'A':i 'M':i 'E':i 'T':i 'E':i 'R':i '_':i 'M':i 'O':i 'D':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex194> ::= 'P':i 'A':i 'R':i 'A':i 'M':i 'E':i 'T':i 'E':i 'R':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex195> ::= 'P':i 'A':i 'R':i 'A':i 'M':i 'E':i 'T':i 'E':i 'R':i '_':i 'O':i 'R':i 'D':i 'I':i 'N':i 'A':i 'L':i '_':i 'P':i 'O':i 'S':i 'I':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex196> ::= 'P':i 'A':i 'R':i 'A':i 'M':i 'E':i 'T':i 'E':i 'R':i '_':i 'S':i 'P':i 'E':i 'C':i 'I':i 'F':i 'I':i 'C':i '_':i 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex197> ::= 'P':i 'A':i 'R':i 'A':i 'M':i 'E':i 'T':i 'E':i 'R':i '_':i 'S':i 'P':i 'E':i 'C':i 'I':i 'F':i 'I':i 'C':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex198> ::= 'P':i 'A':i 'R':i 'A':i 'M':i 'E':i 'T':i 'E':i 'R':i '_':i 'S':i 'P':i 'E':i 'C':i 'I':i 'F':i 'I':i 'C':i '_':i 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex199> ::= 'P':i 'A':i 'R':i 'T':i 'I':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex200> ::= 'P':i 'A':i 'S':i 'C':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex201> ::= 'P':i 'A':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex202> ::= 'P':i 'E':i 'R':i 'C':i 'E':i 'N':i 'T':i 'I':i 'L':i 'E':i '_':i 'C':i 'O':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex203> ::= 'P':i 'E':i 'R':i 'C':i 'E':i 'N':i 'T':i 'I':i 'L':i 'E':i '_':i 'D':i 'I':i 'S':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex204> ::= 'P':i 'E':i 'R':i 'C':i 'E':i 'N':i 'T':i '_':i 'R':i 'A':i 'N':i 'K':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex205> ::= 'P':i 'L':i 'A':i 'C':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex206> ::= 'P':i 'L':i 'I':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex207> ::= 'P':i 'O':i 'S':i 'I':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex208> ::= 'P':i 'O':i 'W':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex209> ::= 'P':i 'R':i 'E':i 'C':i 'E':i 'D':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex210> ::= 'P':i 'R':i 'E':i 'S':i 'E':i 'R':i 'V':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex211> ::= 'P':i 'R':i 'I':i 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex212> ::= 'P':i 'R':i 'I':i 'V':i 'I':i 'L':i 'E':i 'G':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex213> ::= 'P':i 'U':i 'B':i 'L':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex214> ::= 'R':i 'A':i 'N':i 'K':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex215> ::= 'R':i 'E':i 'A':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex216> ::= 'R':i 'E':i 'L':i 'A':i 'T':i 'I':i 'V':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex217> ::= 'R':i 'E':i 'P':i 'E':i 'A':i 'T':i 'A':i 'B':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex218> ::= 'R':i 'E':i 'S':i 'T':i 'A':i 'R':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex219> ::= 'R':i 'E':i 'T':i 'U':i 'R':i 'N':i 'E':i 'D':i '_':i 'C':i 'A':i 'R':i 'D':i 'I':i 'N':i 'A':i 'L':i 'I':i 'T':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex220> ::= 'R':i 'E':i 'T':i 'U':i 'R':i 'N':i 'E':i 'D':i '_':i 'L':i 'E':i 'N':i 'G':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex221> ::= 'R':i 'E':i 'T':i 'U':i 'R':i 'N':i 'E':i 'D':i '_':i 'O':i 'C':i 'T':i 'E':i 'T':i '_':i 'L':i 'E':i 'N':i 'G':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex222> ::= 'R':i 'E':i 'T':i 'U':i 'R':i 'N':i 'E':i 'D':i '_':i 'S':i 'Q':i 'L':i 'S':i 'T':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex223> ::= 'R':i 'O':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex224> ::= 'R':i 'O':i 'U':i 'T':i 'I':i 'N':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex225> ::= 'R':i 'O':i 'U':i 'T':i 'I':i 'N':i 'E':i '_':i 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex226> ::= 'R':i 'O':i 'U':i 'T':i 'I':i 'N':i 'E':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex227> ::= 'R':i 'O':i 'U':i 'T':i 'I':i 'N':i 'E':i '_':i 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex228> ::= 'R':i 'O':i 'W':i '_':i 'C':i 'O':i 'U':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex229> ::= 'R':i 'O':i 'W':i '_':i 'N':i 'U':i 'M':i 'B':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex230> ::= 'S':i 'C':i 'A':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex231> ::= 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex232> ::= 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex233> ::= 'S':i 'C':i 'O':i 'P':i 'E':i '_':i 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex234> ::= 'S':i 'C':i 'O':i 'P':i 'E':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex235> ::= 'S':i 'C':i 'O':i 'P':i 'E':i '_':i 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex236> ::= 'S':i 'E':i 'C':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex237> ::= 'S':i 'E':i 'C':i 'U':i 'R':i 'I':i 'T':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex238> ::= 'S':i 'E':i 'L':i 'F':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex239> ::= 'S':i 'E':i 'Q':i 'U':i 'E':i 'N':i 'C':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex240> ::= 'S':i 'E':i 'R':i 'I':i 'A':i 'L':i 'I':i 'Z':i 'A':i 'B':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex241> ::= 'S':i 'E':i 'R':i 'V':i 'E':i 'R':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex242> ::= 'S':i 'E':i 'S':i 'S':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex243> ::= 'S':i 'E':i 'T':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex244> ::= 'S':i 'I':i 'M':i 'P':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex245> ::= 'S':i 'I':i 'Z':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex246> ::= 'S':i 'O':i 'U':i 'R':i 'C':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex247> ::= 'S':i 'P':i 'A':i 'C':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex248> ::= 'S':i 'P':i 'E':i 'C':i 'I':i 'F':i 'I':i 'C':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex249> ::= 'S':i 'Q':i 'R':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex250> ::= 'S':i 'T':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex251> ::= 'S':i 'T':i 'A':i 'T':i 'E':i 'M':i 'E':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex252> ::= 'S':i 'T':i 'D':i 'D':i 'E':i 'V':i '_':i 'P':i 'O':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex253> ::= 'S':i 'T':i 'D':i 'D':i 'E':i 'V':i '_':i 'S':i 'A':i 'M':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex254> ::= 'S':i 'T':i 'R':i 'U':i 'C':i 'T':i 'U':i 'R':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex255> ::= 'S':i 'T':i 'Y':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex256> ::= 'S':i 'U':i 'B':i 'C':i 'L':i 'A':i 'S':i 'S':i '_':i 'O':i 'R':i 'I':i 'G':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex257> ::= 'S':i 'U':i 'B':i 'S':i 'T':i 'R':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex258> ::= 'S':i 'U':i 'M':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex259> ::= 'T':i 'A':i 'B':i 'L':i 'E':i 'S':i 'A':i 'M':i 'P':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex260> ::= 'T':i 'A':i 'B':i 'L':i 'E':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex261> ::= 'T':i 'E':i 'M':i 'P':i 'O':i 'R':i 'A':i 'R':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex262> ::= 'T':i 'I':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex263> ::= 'T':i 'O':i 'P':i '_':i 'L':i 'E':i 'V':i 'E':i 'L':i '_':i 'C':i 'O':i 'U':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex264> ::= 'T':i 'R':i 'A':i 'N':i 'S':i 'A':i 'C':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex265> ::= 'T':i 'R':i 'A':i 'N':i 'S':i 'A':i 'C':i 'T':i 'I':i 'O':i 'N':i 'S':i '_':i 'C':i 'O':i 'M':i 'M':i 'I':i 'T':i 'T':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex266> ::= 'T':i 'R':i 'A':i 'N':i 'S':i 'A':i 'C':i 'T':i 'I':i 'O':i 'N':i 'S':i '_':i 'R':i 'O':i 'L':i 'L':i 'E':i 'D':i '_':i 'B':i 'A':i 'C':i 'K':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex267> ::= 'T':i 'R':i 'A':i 'N':i 'S':i 'A':i 'C':i 'T':i 'I':i 'O':i 'N':i '_':i 'A':i 'C':i 'T':i 'I':i 'V':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex268> ::= 'T':i 'R':i 'A':i 'N':i 'S':i 'F':i 'O':i 'R':i 'M':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex269> ::= 'T':i 'R':i 'A':i 'N':i 'S':i 'F':i 'O':i 'R':i 'M':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex270> ::= 'T':i 'R':i 'A':i 'N':i 'S':i 'L':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex271> ::= 'T':i 'R':i 'I':i 'G':i 'G':i 'E':i 'R':i '_':i 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex272> ::= 'T':i 'R':i 'I':i 'G':i 'G':i 'E':i 'R':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex273> ::= 'T':i 'R':i 'I':i 'G':i 'G':i 'E':i 'R':i '_':i 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex274> ::= 'T':i 'R':i 'I':i 'M':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex275> ::= 'T':i 'Y':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex276> ::= 'U':i 'N':i 'B':i 'O':i 'U':i 'N':i 'D':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex277> ::= 'U':i 'N':i 'C':i 'O':i 'M':i 'M':i 'I':i 'T':i 'T':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex278> ::= 'U':i 'N':i 'D':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex279> ::= 'U':i 'N':i 'N':i 'A':i 'M':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex280> ::= 'U':i 'S':i 'A':i 'G':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex281> ::= 'U':i 'S':i 'E':i 'R':i '_':i 'D':i 'E':i 'F':i 'I':i 'N':i 'E':i 'D':i '_':i 'T':i 'Y':i 'P':i 'E':i '_':i 'C':i 'A':i 'T':i 'A':i 'L':i 'O':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex282> ::= 'U':i 'S':i 'E':i 'R':i '_':i 'D':i 'E':i 'F':i 'I':i 'N':i 'E':i 'D':i '_':i 'T':i 'Y':i 'P':i 'E':i '_':i 'C':i 'O':i 'D':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex283> ::= 'U':i 'S':i 'E':i 'R':i '_':i 'D':i 'E':i 'F':i 'I':i 'N':i 'E':i 'D':i '_':i 'T':i 'Y':i 'P':i 'E':i '_':i 'N':i 'A':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex284> ::= 'U':i 'S':i 'E':i 'R':i '_':i 'D':i 'E':i 'F':i 'I':i 'N':i 'E':i 'D':i '_':i 'T':i 'Y':i 'P':i 'E':i '_':i 'S':i 'C':i 'H':i 'E':i 'M':i 'A':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex285> ::= 'V':i 'I':i 'E':i 'W':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex286> ::= 'W':i 'O':i 'R':i 'K':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex287> ::= 'W':i 'R':i 'I':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex288> ::= 'Z':i 'O':i 'N':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex289> ::= 'A':i 'D':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex290> ::= 'A':i 'L':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex291> ::= 'A':i 'L':i 'L':i 'O':i 'C':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex292> ::= 'A':i 'L':i 'T':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex293> ::= 'A':i 'N':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex294> ::= 'A':i 'N':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex295> ::= 'A':i 'R':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex296> ::= 'A':i 'R':i 'R':i 'A':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex297> ::= 'A':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex298> ::= 'A':i 'S':i 'E':i 'N':i 'S':i 'I':i 'T':i 'I':i 'V':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex299> ::= 'A':i 'S':i 'Y':i 'M':i 'M':i 'E':i 'T':i 'R':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex300> ::= 'A':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex301> ::= 'A':i 'T':i 'O':i 'M':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex302> ::= 'A':i 'U':i 'T':i 'H':i 'O':i 'R':i 'I':i 'Z':i 'A':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex303> ::= 'B':i 'E':i 'G':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex304> ::= 'B':i 'E':i 'T':i 'W':i 'E':i 'E':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex305> ::= 'B':i 'I':i 'G':i 'I':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex306> ::= 'B':i 'I':i 'N':i 'A':i 'R':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex307> ::= 'B':i 'L':i 'O':i 'B':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex308> ::= 'B':i 'O':i 'O':i 'L':i 'E':i 'A':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex309> ::= 'B':i 'O':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex310> ::= 'B':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex311> ::= 'C':i 'A':i 'L':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex312> ::= 'C':i 'A':i 'L':i 'L':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex313> ::= 'C':i 'A':i 'S':i 'C':i 'A':i 'D':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex314> ::= 'C':i 'A':i 'S':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex315> ::= 'C':i 'A':i 'S':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex316> ::= 'C':i 'H':i 'A':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex317> ::= 'C':i 'H':i 'A':i 'R':i 'A':i 'C':i 'T':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex318> ::= 'C':i 'H':i 'E':i 'C':i 'K':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex319> ::= 'C':i 'L':i 'O':i 'B':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex320> ::= 'C':i 'L':i 'O':i 'S':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex321> ::= 'C':i 'O':i 'L':i 'L':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex322> ::= 'C':i 'O':i 'L':i 'U':i 'M':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex323> ::= 'C':i 'O':i 'M':i 'M':i 'I':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex324> ::= 'C':i 'O':i 'N':i 'N':i 'E':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex325> ::= 'C':i 'O':i 'N':i 'S':i 'T':i 'R':i 'A':i 'I':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex326> ::= 'C':i 'O':i 'N':i 'T':i 'I':i 'N':i 'U':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex327> ::= 'C':i 'O':i 'R':i 'R':i 'E':i 'S':i 'P':i 'O':i 'N':i 'D':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex328> ::= 'C':i 'R':i 'E':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex329> ::= 'C':i 'R':i 'O':i 'S':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex330> ::= 'C':i 'U':i 'B':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex331> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex332> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i '_':i 'D':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex333> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i '_':i 'D':i 'E':i 'F':i 'A':i 'U':i 'L':i 'T':i '_':i 'T':i 'R':i 'A':i 'N':i 'S':i 'F':i 'O':i 'R':i 'M':i '_':i 'G':i 'R':i 'O':i 'U':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex334> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i '_':i 'P':i 'A':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex335> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i '_':i 'R':i 'O':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex336> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i '_':i 'T':i 'I':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex337> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i '_':i 'T':i 'I':i 'M':i 'E':i 'S':i 'T':i 'A':i 'M':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex338> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i '_':i 'T':i 'R':i 'A':i 'N':i 'S':i 'F':i 'O':i 'R':i 'M':i '_':i 'G':i 'R':i 'O':i 'U':i 'P':i '_':i 'F':i 'O':i 'R':i '_':i 'T':i 'Y':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex339> ::= 'C':i 'U':i 'R':i 'R':i 'E':i 'N':i 'T':i '_':i 'U':i 'S':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex340> ::= 'C':i 'U':i 'R':i 'S':i 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex341> ::= 'C':i 'Y':i 'C':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex342> ::= 'D':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex343> ::= 'D':i 'A':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex344> ::= 'D':i 'E':i 'A':i 'L':i 'L':i 'O':i 'C':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex345> ::= 'D':i 'E':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex346> ::= 'D':i 'E':i 'C':i 'I':i 'M':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex347> ::= 'D':i 'E':i 'C':i 'L':i 'A':i 'R':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex348> ::= 'D':i 'E':i 'F':i 'A':i 'U':i 'L':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex349> ::= 'D':i 'E':i 'L':i 'E':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex350> ::= 'D':i 'E':i 'R':i 'E':i 'F':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex351> ::= 'D':i 'E':i 'S':i 'C':i 'R':i 'I':i 'B':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex352> ::= 'D':i 'E':i 'T':i 'E':i 'R':i 'M':i 'I':i 'N':i 'I':i 'S':i 'T':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex353> ::= 'D':i 'I':i 'S':i 'C':i 'O':i 'N':i 'N':i 'E':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex354> ::= 'D':i 'I':i 'S':i 'T':i 'I':i 'N':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex355> ::= 'D':i 'O':i 'U':i 'B':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex356> ::= 'D':i 'R':i 'O':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex357> ::= 'D':i 'Y':i 'N':i 'A':i 'M':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex358> ::= 'E':i 'A':i 'C':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex359> ::= 'E':i 'L':i 'E':i 'M':i 'E':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex360> ::= 'E':i 'L':i 'S':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex361> ::= 'E':i 'N':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex362> ::= 'E':i 'N':i 'D':i '-':i 'E':i 'X':i 'E':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex363> ::= 'E':i 'S':i 'C':i 'A':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex364> ::= 'E':i 'X':i 'C':i 'E':i 'P':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex365> ::= 'E':i 'X':i 'E':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex366> ::= 'E':i 'X':i 'E':i 'C':i 'U':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex367> ::= 'E':i 'X':i 'I':i 'S':i 'T':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex368> ::= 'E':i 'X':i 'T':i 'E':i 'R':i 'N':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex369> ::= 'F':i 'A':i 'L':i 'S':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex370> ::= 'F':i 'E':i 'T':i 'C':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex371> ::= 'F':i 'I':i 'L':i 'T':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex372> ::= 'F':i 'L':i 'O':i 'A':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex373> ::= 'F':i 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex374> ::= 'F':i 'O':i 'R':i 'E':i 'I':i 'G':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex375> ::= 'F':i 'R':i 'E':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex376> ::= 'F':i 'R':i 'O':i 'M':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex377> ::= 'F':i 'U':i 'L':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex378> ::= 'F':i 'U':i 'N':i 'C':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex379> ::= 'G':i 'E':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex380> ::= 'G':i 'L':i 'O':i 'B':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex381> ::= 'G':i 'R':i 'A':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex382> ::= 'G':i 'R':i 'O':i 'U':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex383> ::= 'G':i 'R':i 'O':i 'U':i 'P':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex384> ::= 'H':i 'A':i 'V':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex385> ::= 'H':i 'O':i 'L':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex386> ::= 'H':i 'O':i 'U':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex387> ::= 'I':i 'D':i 'E':i 'N':i 'T':i 'I':i 'T':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex388> ::= 'I':i 'M':i 'M':i 'E':i 'D':i 'I':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex389> ::= 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex390> ::= 'I':i 'N':i 'D':i 'I':i 'C':i 'A':i 'T':i 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex391> ::= 'I':i 'N':i 'N':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex392> ::= 'I':i 'N':i 'O':i 'U':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex393> ::= 'I':i 'N':i 'P':i 'U':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex394> ::= 'I':i 'N':i 'S':i 'E':i 'N':i 'S':i 'I':i 'T':i 'I':i 'V':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex395> ::= 'I':i 'N':i 'S':i 'E':i 'R':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex396> ::= 'I':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex397> ::= 'I':i 'N':i 'T':i 'E':i 'G':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex398> ::= 'I':i 'N':i 'T':i 'E':i 'R':i 'S':i 'E':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex399> ::= 'I':i 'N':i 'T':i 'E':i 'R':i 'V':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex400> ::= 'I':i 'N':i 'T':i 'O':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex401> ::= 'I':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex402> ::= 'J':i 'O':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex403> ::= 'L':i 'A':i 'N':i 'G':i 'U':i 'A':i 'G':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex404> ::= 'L':i 'A':i 'R':i 'G':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex405> ::= 'L':i 'A':i 'T':i 'E':i 'R':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex406> ::= 'L':i 'E':i 'A':i 'D':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex407> ::= 'L':i 'E':i 'F':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex408> ::= 'L':i 'I':i 'K':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex409> ::= 'L':i 'O':i 'C':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex410> ::= 'L':i 'O':i 'C':i 'A':i 'L':i 'T':i 'I':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex411> ::= 'L':i 'O':i 'C':i 'A':i 'L':i 'T':i 'I':i 'M':i 'E':i 'S':i 'T':i 'A':i 'M':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex412> ::= 'M':i 'A':i 'T':i 'C':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex413> ::= 'M':i 'E':i 'M':i 'B':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex414> ::= 'M':i 'E':i 'R':i 'G':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex415> ::= 'M':i 'E':i 'T':i 'H':i 'O':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex416> ::= 'M':i 'I':i 'N':i 'U':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex417> ::= 'M':i 'O':i 'D':i 'I':i 'F':i 'I':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex418> ::= 'M':i 'O':i 'D':i 'U':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex419> ::= 'M':i 'O':i 'N':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex420> ::= 'M':i 'U':i 'L':i 'T':i 'I':i 'S':i 'E':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex421> ::= 'N':i 'A':i 'T':i 'I':i 'O':i 'N':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex422> ::= 'N':i 'A':i 'T':i 'U':i 'R':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex423> ::= 'N':i 'C':i 'H':i 'A':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex424> ::= 'N':i 'C':i 'L':i 'O':i 'B':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex425> ::= 'N':i 'E':i 'W':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex426> ::= 'N':i 'O':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex427> ::= 'N':i 'O':i 'N':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex428> ::= 'N':i 'O':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex429> ::= 'N':i 'U':i 'L':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex430> ::= 'N':i 'U':i 'M':i 'E':i 'R':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex431> ::= 'O':i 'F':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex432> ::= 'O':i 'L':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex433> ::= 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex434> ::= 'O':i 'N':i 'L':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex435> ::= 'O':i 'P':i 'E':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex436> ::= 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex437> ::= 'O':i 'R':i 'D':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex438> ::= 'O':i 'U':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex439> ::= 'O':i 'U':i 'T':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex440> ::= 'O':i 'U':i 'T':i 'P':i 'U':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex441> ::= 'O':i 'V':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex442> ::= 'O':i 'V':i 'E':i 'R':i 'L':i 'A':i 'P':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex443> ::= 'P':i 'A':i 'R':i 'A':i 'M':i 'E':i 'T':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex444> ::= 'P':i 'A':i 'R':i 'T':i 'I':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex445> ::= 'P':i 'R':i 'E':i 'C':i 'I':i 'S':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex446> ::= 'P':i 'R':i 'E':i 'P':i 'A':i 'R':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex447> ::= 'P':i 'R':i 'I':i 'M':i 'A':i 'R':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex448> ::= 'P':i 'R':i 'O':i 'C':i 'E':i 'D':i 'U':i 'R':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex449> ::= 'R':i 'A':i 'N':i 'G':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex450> ::= 'R':i 'E':i 'A':i 'D':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex451> ::= 'R':i 'E':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex452> ::= 'R':i 'E':i 'C':i 'U':i 'R':i 'S':i 'I':i 'V':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex453> ::= 'R':i 'E':i 'F':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex454> ::= 'R':i 'E':i 'F':i 'E':i 'R':i 'E':i 'N':i 'C':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex455> ::= 'R':i 'E':i 'F':i 'E':i 'R':i 'E':i 'N':i 'C':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex456> ::= 'R':i 'E':i 'G':i 'R':i '_':i 'A':i 'V':i 'G':i 'X':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex457> ::= 'R':i 'E':i 'G':i 'R':i '_':i 'A':i 'V':i 'G':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex458> ::= 'R':i 'E':i 'G':i 'R':i '_':i 'C':i 'O':i 'U':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex459> ::= 'R':i 'E':i 'G':i 'R':i '_':i 'I':i 'N':i 'T':i 'E':i 'R':i 'C':i 'E':i 'P':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex460> ::= 'R':i 'E':i 'G':i 'R':i '_':i 'R':i '2':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex461> ::= 'R':i 'E':i 'G':i 'R':i '_':i 'S':i 'L':i 'O':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex462> ::= 'R':i 'E':i 'G':i 'R':i '_':i 'S':i 'X':i 'X':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex463> ::= 'R':i 'E':i 'G':i 'R':i '_':i 'S':i 'X':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex464> ::= 'R':i 'E':i 'G':i 'R':i '_':i 'S':i 'Y':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex465> ::= 'R':i 'E':i 'L':i 'E':i 'A':i 'S':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex466> ::= 'R':i 'E':i 'S':i 'U':i 'L':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex467> ::= 'R':i 'E':i 'T':i 'U':i 'R':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex468> ::= 'R':i 'E':i 'T':i 'U':i 'R':i 'N':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex469> ::= 'R':i 'E':i 'V':i 'O':i 'K':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex470> ::= 'R':i 'I':i 'G':i 'H':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex471> ::= 'R':i 'O':i 'L':i 'L':i 'B':i 'A':i 'C':i 'K':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex472> ::= 'R':i 'O':i 'L':i 'L':i 'U':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex473> ::= 'R':i 'O':i 'W':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex474> ::= 'R':i 'O':i 'W':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex475> ::= 'S':i 'A':i 'V':i 'E':i 'P':i 'O':i 'I':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex476> ::= 'S':i 'C':i 'R':i 'O':i 'L':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex477> ::= 'S':i 'E':i 'A':i 'R':i 'C':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex478> ::= 'S':i 'E':i 'C':i 'O':i 'N':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex479> ::= 'S':i 'E':i 'L':i 'E':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex480> ::= 'S':i 'E':i 'N':i 'S':i 'I':i 'T':i 'I':i 'V':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex481> ::= 'S':i 'E':i 'S':i 'S':i 'I':i 'O':i 'N':i '_':i 'U':i 'S':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex482> ::= 'S':i 'E':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex483> ::= 'S':i 'I':i 'M':i 'I':i 'L':i 'A':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex484> ::= 'S':i 'M':i 'A':i 'L':i 'L':i 'I':i 'N':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex485> ::= 'S':i 'O':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex486> ::= 'S':i 'P':i 'E':i 'C':i 'I':i 'F':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex487> ::= 'S':i 'P':i 'E':i 'C':i 'I':i 'F':i 'I':i 'C':i 'T':i 'Y':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex488> ::= 'S':i 'Q':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex489> ::= 'S':i 'Q':i 'L':i 'E':i 'X':i 'C':i 'E':i 'P':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex490> ::= 'S':i 'Q':i 'L':i 'S':i 'T':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex491> ::= 'S':i 'Q':i 'L':i 'W':i 'A':i 'R':i 'N':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex492> ::= 'S':i 'T':i 'A':i 'R':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex493> ::= 'S':i 'T':i 'A':i 'T':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex494> ::= 'S':i 'U':i 'B':i 'M':i 'U':i 'L':i 'T':i 'I':i 'S':i 'E':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex495> ::= 'S':i 'Y':i 'M':i 'M':i 'E':i 'T':i 'R':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex496> ::= 'S':i 'Y':i 'S':i 'T':i 'E':i 'M':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex497> ::= 'S':i 'Y':i 'S':i 'T':i 'E':i 'M':i '_':i 'U':i 'S':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex498> ::= 'T':i 'A':i 'B':i 'L':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex499> ::= 'T':i 'H':i 'E':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex500> ::= 'T':i 'I':i 'M':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex501> ::= 'T':i 'I':i 'M':i 'E':i 'S':i 'T':i 'A':i 'M':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex502> ::= 'T':i 'I':i 'M':i 'E':i 'Z':i 'O':i 'N':i 'E':i '_':i 'H':i 'O':i 'U':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex503> ::= 'T':i 'I':i 'M':i 'E':i 'Z':i 'O':i 'N':i 'E':i '_':i 'M':i 'I':i 'N':i 'U':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex504> ::= 'T':i 'O':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex505> ::= 'T':i 'R':i 'A':i 'I':i 'L':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex506> ::= 'T':i 'R':i 'A':i 'N':i 'S':i 'L':i 'A':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex507> ::= 'T':i 'R':i 'E':i 'A':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex508> ::= 'T':i 'R':i 'I':i 'G':i 'G':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex509> ::= 'T':i 'R':i 'U':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex510> ::= 'U':i 'N':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex511> ::= 'U':i 'N':i 'I':i 'Q':i 'U':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex512> ::= 'U':i 'N':i 'K':i 'N':i 'O':i 'W':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex513> ::= 'U':i 'N':i 'N':i 'E':i 'S':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex514> ::= 'U':i 'P':i 'D':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex515> ::= 'U':i 'P':i 'P':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex516> ::= 'U':i 'S':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex517> ::= 'U':i 'S':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex518> ::= 'V':i 'A':i 'L':i 'U':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex519> ::= 'V':i 'A':i 'L':i 'U':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex520> ::= 'V':i 'A':i 'R':i '_':i 'P':i 'O':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex521> ::= 'V':i 'A':i 'R':i '_':i 'S':i 'A':i 'M':i 'P':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex522> ::= 'V':i 'A':i 'R':i 'C':i 'H':i 'A':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex523> ::= 'V':i 'A':i 'R':i 'Y':i 'I':i 'N':i 'G':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex524> ::= 'W':i 'H':i 'E':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex525> ::= 'W':i 'H':i 'E':i 'N':i 'E':i 'V':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex526> ::= 'W':i 'H':i 'E':i 'R':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex527> ::= 'W':i 'I':i 'D':i 'T':i 'H':i '_':i 'B':i 'U':i 'C':i 'K':i 'E':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex528> ::= 'W':i 'I':i 'N':i 'D':i 'O':i 'W':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex529> ::= 'W':i 'I':i 'T':i 'H':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex530> ::= 'W':i 'I':i 'T':i 'H':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex531> ::= 'W':i 'I':i 'T':i 'H':i 'O':i 'U':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex532> ::= 'Y':i 'E':i 'A':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex533> ~ [^\']
<Lex534> ~ 'N'
<Lex535> ~ 'X'
<Lex536> ~ 'B'
<Lex537> ~ 'D'
<Lex538> ~ 'E'
<Lex539> ~ 'F'
<Lex540> ~ 'a'
<Lex541> ~ 'b'
<Lex542> ~ 'c'
<Lex543> ~ 'd'
<Lex544> ~ 'e'
<Lex545> ~ 'f'
<Lex546 many> ~ [\d]+
<Lex547> ::= 'S':i 'C':i 'O':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex548> ~ [^\[\]\(\)\|\^\-\+\*_\%\?\{\\]
<Lex549> ~ [\x{5c}]
<Lex550> ~ [\[\]\(\)\|\^\-\+\*_\%\?\{\\]
<Lex551> ::= 'C':i 'O':i 'N':i 'S':i 'T':i 'R':i 'U':i 'C':i 'T':i 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex552> ::= 'R':i 'E':i 'S':i 'T':i 'R':i 'I':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex553> ::= 'G':i 'E':i 'N':i 'E':i 'R':i 'A':i 'T':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex554> ::= 'C':i 'O':i 'N':i 'N':i 'E':i 'C':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex555> ::= 'I':i 'n':i 't':i 'e':i 'r':i 'f':i 'a':i 'c':i 'e':i 's':i '.':i 'S':i 'Q':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex556> ~ '1'
<Lex557> ::= 'D':i 'O':i 'U':i 'B':i 'L':i 'E':i '_':i 'P':i 'R':i 'E':i 'C':i 'I':i 'S':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex558> ::= 'S':i 'Q':i 'L':i 'S':i 'T':i 'A':i 'T':i 'E':i '_':i 'T':i 'Y':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex559> ::= 'I':i 'N':i 'D':i 'I':i 'C':i 'A':i 'T':i 'O':i 'R':i '_':i 'T':i 'Y':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex560> ::= 'a':i 'u':i 't':i 'o':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex561> ::= 'e':i 'x':i 't':i 'e':i 'r':i 'n':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex562> ::= 's':i 't':i 'a':i 't':i 'i':i 'c':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex563> ::= 'c':i 'o':i 'n':i 's':i 't':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex564> ::= 'v':i 'o':i 'l':i 'a':i 't':i 'i':i 'l':i 'e':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex565> ::= 'l':i 'o':i 'n':i 'g':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex566> ::= 's':i 'h':i 'o':i 'r':i 't':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex567> ::= 'f':i 'l':i 'o':i 'a':i 't':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex568> ::= 'd':i 'o':i 'u':i 'b':i 'l':i 'e':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex569> ::= 'c':i 'h':i 'a':i 'r':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex570> ::= 'u':i 'n':i 's':i 'i':i 'g':i 'n':i 'e':i 'd':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex571> ::= '0':i '1':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex572> ::= '7':i '7':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex573 many> ~ [\-]*
<Lex574> ~ [A-Za-z]
<Lex575 many> ~ [A-Za-z0-9]*
<Lex576 many> ~ [\-]+
<Lex577 many> ~ [A-Za-z0-9]+
<Lex578 many> ~ [0]*
<Lex579> ~ [1-9]
<Lex580> ::= 'L':i 'I':i 'N':i 'A':i 'G':i 'E':i '-':i 'C':i 'O':i 'U':i 'N':i 'T':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex581> ::= '*':i '*':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex582 many> ~ [0-9A-Fa-f]+
<Lex583> ::= 'Z':i 'E':i 'R':i 'O':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex584> ::= 'Z':i 'E':i 'R':i 'O':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex585> ::= 'Z':i 'E':i 'R':i 'O':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex586> ::= 'S':i 'P':i 'A':i 'C':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex587> ::= 'H':i 'I':i 'G':i 'H':i '-':i 'V':i 'A':i 'L':i 'U':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex588> ::= 'H':i 'I':i 'G':i 'H':i '-':i 'V':i 'A':i 'L':i 'U':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex589> ::= 'L':i 'O':i 'W':i '-':i 'V':i 'A':i 'L':i 'U':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex590> ::= 'L':i 'O':i 'W':i '-':i 'V':i 'A':i 'L':i 'U':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex591> ::= 'Q':i 'U':i 'O':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex592> ::= 'Q':i 'U':i 'O':i 'T':i 'E':i 'S':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex593> ::= 'P':i 'I':i 'C':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex594> ::= 'P':i 'I':i 'C':i 'T':i 'U':i 'R':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex595> ~ 'S'
<Lex596> ::= 'D':i 'I':i 'S':i 'P':i 'L':i 'A':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex597> ::= 'S':i 'I':i 'G':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex598> ::= 'S':i 'E':i 'P':i 'A':i 'R':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex599> ~ 'V'
<Lex600> ~ '9'
<Lex601> ::= 'K':i 'I':i 'N':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex603> ::= 'L':i 'O':i 'G':i 'I':i 'C':i 'A':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex604> ::= 'P':i 'A':i 'C':i 'K':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex605> ::= 'D':i 'C':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex606> ::= 'F':i 'I':i 'X':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex607> ::= 'B':i 'I':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities

_WS ~ [\s]+
:discard ~ _WS

_COMMENT_EVERYYHERE_START ~ '--'
_COMMENT_EVERYYHERE_END ~ [^\n]*
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

