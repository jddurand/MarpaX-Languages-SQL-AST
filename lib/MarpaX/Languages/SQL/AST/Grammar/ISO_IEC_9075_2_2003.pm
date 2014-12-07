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

:start ::= <SQL_Start_Sequence>
<SQL_Start_many> ::= <SQL_Start>+ rank => 0
<SQL_Start_Sequence> ::= <SQL_Start_many> rank => 0
<SQL_Start> ::= <Preparable_Statement> rank => 0
              | <Direct_SQL_Statement> rank => -1
              | <Embedded_SQL_Declare_Section> rank => -2
              | <Embedded_SQL_Host_Program> rank => -3
              | <Embedded_SQL_Statement> rank => -4
              | <SQL_Client_Module_Definition> rank => -5
<SQL_Terminal_Character> ::= <SQL_Language_Character> rank => 0
<SQL_Language_Character> ::= <Simple_Latin_Letter> rank => 0
                           | <Digit> rank => -1
                           | <SQL_Special_Character> rank => -2
<Simple_Latin_Letter> ::= <Simple_Latin_Upper_Case_Letter> rank => 0
                        | <Simple_Latin_Lower_Case_Letter> rank => -1
<Simple_Latin_Upper_Case_Letter> ::= <Lex001> rank => 0
<Simple_Latin_Lower_Case_Letter> ::= <Lex002> rank => 0
<Digit> ::= <Lex003> rank => 0
<SQL_Special_Character> ::= <Space> rank => 0
                          | <Double_Quote> rank => -1
                          | <Percent> rank => -2
                          | <Ampersand> rank => -3
                          | <Quote> rank => -4
                          | <Left_Paren> rank => -5
                          | <Right_Paren> rank => -6
                          | <Asterisk> rank => -7
                          | <Plus_Sign> rank => -8
                          | <Comma> rank => -9
                          | <Minus_Sign> rank => -10
                          | <Period> rank => -11
                          | <Solidus> rank => -12
                          | <Colon> rank => -13
                          | <Semicolon> rank => -14
                          | <Less_Than_Operator> rank => -15
                          | <Equals_Operator> rank => -16
                          | <Greater_Than_Operator> rank => -17
                          | <Question_Mark> rank => -18
                          | <Left_Bracket> rank => -19
                          | <Right_Bracket> rank => -20
                          | <Circumflex> rank => -21
                          | <Underscore> rank => -22
                          | <Vertical_Bar> rank => -23
                          | <Left_Brace> rank => -24
                          | <Right_Brace> rank => -25
<Space> ::= <Lex004> rank => 0
<Double_Quote> ::= <Lex005> rank => 0
<Percent> ::= <Lex006> rank => 0
<Ampersand> ::= <Lex007> rank => 0
<Quote> ::= <Lex008> rank => 0
<Left_Paren> ::= <Lex009> rank => 0
<Right_Paren> ::= <Lex010> rank => 0
<Asterisk> ::= <Lex011> rank => 0
<Plus_Sign> ::= <Lex012> rank => 0
<Comma> ::= <Lex013> rank => 0
<Minus_Sign> ::= <Lex014> rank => 0
<Period> ::= <Lex015> rank => 0
<Solidus> ::= <Lex016> rank => 0
<Colon> ::= <Lex017> rank => 0
<Semicolon> ::= <Lex018> rank => 0
<Less_Than_Operator> ::= <Lex019> rank => 0
<Equals_Operator> ::= <Lex020> rank => 0
<Greater_Than_Operator> ::= <Lex021> rank => 0
<Question_Mark> ::= <Lex022> rank => 0
<Left_Bracket_Or_Trigraph> ::= <Left_Bracket> rank => 0
                             | <Left_Bracket_Trigraph> rank => -1
<Right_Bracket_Or_Trigraph> ::= <Right_Bracket> rank => 0
                              | <Right_Bracket_Trigraph> rank => -1
<Left_Bracket> ::= <Lex023> rank => 0
<Left_Bracket_Trigraph> ::= <Lex024> rank => 0
<Right_Bracket> ::= <Lex025> rank => 0
<Right_Bracket_Trigraph> ::= <Lex026> rank => 0
<Circumflex> ::= <Lex027> rank => 0
<Underscore> ::= <Lex028> rank => 0
<Vertical_Bar> ::= <Lex029> rank => 0
<Left_Brace> ::= <Lex030> rank => 0
<Right_Brace> ::= <Lex031> rank => 0
<Token> ::= <Nondelimiter_Token> rank => 0
          | <Delimiter_Token> rank => -1
<Nondelimiter_Token> ::= <Regular_Identifier> rank => 0
                       | <Key_Word> rank => -1
                       | <Unsigned_Numeric_Literal> rank => -2
                       | <National_Character_String_Literal> rank => -3
                       | <Large_Object_Length_Token> rank => -4
                       | <Multiplier> rank => -5
<Regular_Identifier> ::= <SQL_Language_Identifier> rank => 0
<Digit_many> ::= <Digit>+ rank => 0
<Large_Object_Length_Token> ::= <Digit_many> <Multiplier> rank => 0
<Multiplier> ::= <Lex032> rank => 0
               | <Lex033> rank => -1
               | <Lex034> rank => -2
<Delimited_Identifier> ::= <Double_Quote> <Delimited_Identifier_Body> <Double_Quote> rank => 0
<Delimited_Identifier_Part_many> ::= <Delimited_Identifier_Part>+ rank => 0
<Delimited_Identifier_Body> ::= <Delimited_Identifier_Part_many> rank => 0
<Delimited_Identifier_Part> ::= <Nondoublequote_Character> rank => 0
                              | <Doublequote_Symbol> rank => -1
<Unicode_Delimited_Identifier> ::= <Lex035> <Ampersand> <Double_Quote> <Unicode_Delimiter_Body> <Double_Quote> <Unicode_Escape_Specifier> rank => 0
<Gen097> ::= <Lex036> <Quote> <Unicode_Escape_Character> <Quote> rank => 0
<Gen097_maybe> ::= <Gen097> rank => 0
<Gen097_maybe> ::= rank => -1
<Unicode_Escape_Specifier> ::= <Gen097_maybe> rank => 0
<Unicode_Identifier_Part_many> ::= <Unicode_Identifier_Part>+ rank => 0
<Unicode_Delimiter_Body> ::= <Unicode_Identifier_Part_many> rank => 0
<Unicode_Identifier_Part> ::= <Delimited_Identifier_Part> rank => 0
                            | <Unicode_Escape_Value> rank => -1
<Unicode_Escape_Value> ::= <Unicode_4_Digit_Escape_Value> rank => 0
                         | <Unicode_6_Digit_Escape_Value> rank => -1
                         | <Unicode_Character_Escape_Value> rank => -2
<Unicode_4_Digit_Escape_Value> ::= <Unicode_Escape_Character> <Hexit> <Hexit> <Hexit> <Hexit> rank => 0
<Unicode_6_Digit_Escape_Value> ::= <Unicode_Escape_Character> <Plus_Sign> <Hexit> <Hexit> <Hexit> <Hexit> <Hexit> <Hexit> rank => 0
<Unicode_Character_Escape_Value> ::= <Unicode_Escape_Character> <Unicode_Escape_Character> rank => 0
<Unicode_Escape_Character> ::= <Lex037> rank => 0
<Nondoublequote_Character> ::= <Lex038> rank => 0
<Doublequote_Symbol> ::= <Lex039> rank => 0
<Delimiter_Token> ::= <Character_String_Literal> rank => 0
                    | <Date_String> rank => -1
                    | <Time_String> rank => -2
                    | <Timestamp_String> rank => -3
                    | <Interval_String> rank => -4
                    | <Delimited_Identifier> rank => -5
                    | <Unicode_Delimited_Identifier> rank => -6
                    | <SQL_Special_Character> rank => -7
                    | <Not_Equals_Operator> rank => -8
                    | <Greater_Than_Or_Equals_Operator> rank => -9
                    | <Less_Than_Or_Equals_Operator> rank => -10
                    | <Concatenation_Operator> rank => -11
                    | <Right_Arrow> rank => -12
                    | <Left_Bracket_Trigraph> rank => -13
                    | <Right_Bracket_Trigraph> rank => -14
                    | <Double_Colon> rank => -15
                    | <Double_Period> rank => -16
<Not_Equals_Operator> ::= <Less_Than_Operator> <Greater_Than_Operator> rank => 0
<Greater_Than_Or_Equals_Operator> ::= <Greater_Than_Operator> <Equals_Operator> rank => 0
<Less_Than_Or_Equals_Operator> ::= <Less_Than_Operator> <Equals_Operator> rank => 0
<Concatenation_Operator> ::= <Vertical_Bar> <Vertical_Bar> rank => 0
<Right_Arrow> ::= <Minus_Sign> <Greater_Than_Operator> rank => 0
<Double_Colon> ::= <Colon> <Colon> rank => 0
<Double_Period> ::= <Period> <Period> rank => 0
<Gen138> ::= <Comment> rank => 0
           | <Space> rank => -1
<Gen138_many> ::= <Gen138>+ rank => 0
<Separator> ::= <Gen138_many> rank => 0
<Comment> ::= <Simple_Comment> rank => 0
            | <Bracketed_Comment> rank => -1
<Comment_Character_any> ::= <Comment_Character>* rank => 0
<Simple_Comment> ::= <Simple_Comment_Introducer> <Comment_Character_any> <Newline> rank => 0
<Minus_Sign_any> ::= <Minus_Sign>* rank => 0
<Simple_Comment_Introducer> ::= <Minus_Sign> <Minus_Sign> <Minus_Sign_any> rank => 0
<Bracketed_Comment> ::= <Bracketed_Comment_Introducer> <Bracketed_Comment_Contents> <Bracketed_Comment_Terminator> rank => 0
<Bracketed_Comment_Introducer> ::= <Solidus> <Asterisk> rank => 0
<Bracketed_Comment_Terminator> ::= <Asterisk> <Solidus> rank => 0
<Gen151> ::= <Comment_Character> rank => 0
           | <Separator> rank => -1
<Gen151_any> ::= <Gen151>* rank => 0
<Bracketed_Comment_Contents> ::= <Gen151_any> rank => 0
<Comment_Character> ::= <Nonquote_Character> rank => 0
                      | <Quote> rank => -1
<Newline> ::= <Lex040> rank => 0
<Key_Word> ::= <Reserved_Word> rank => 0
             | <Non_Reserved_Word> rank => -1
<Non_Reserved_Word> ::= <Lex041> rank => 0
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
<Reserved_Word> ::= <Lex289> rank => 0
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
<Literal> ::= <Signed_Numeric_Literal> rank => 0
            | <General_Literal> rank => -1
<Unsigned_Literal> ::= <Unsigned_Numeric_Literal> rank => 0
                     | <General_Literal> rank => -1
<General_Literal> ::= <Character_String_Literal> rank => 0
                    | <National_Character_String_Literal> rank => -1
                    | <Unicode_Character_String_Literal> rank => -2
                    | <Binary_String_Literal> rank => -3
                    | <Datetime_Literal> rank => -4
                    | <Interval_Literal> rank => -5
                    | <Boolean_Literal> rank => -6
<Gen668> ::= <Introducer> <Character_Set_Specification> rank => 0
<Gen668_maybe> ::= <Gen668> rank => 0
<Gen668_maybe> ::= rank => -1
<Character_Representation_any> ::= <Character_Representation>* rank => 0
<Gen672> ::= <Separator> <Quote> <Character_Representation_any> <Quote> rank => 0
<Gen672_any> ::= <Gen672>* rank => 0
<Character_String_Literal> ::= <Gen668_maybe> <Quote> <Character_Representation_any> <Quote> <Gen672_any> rank => 0
<Introducer> ::= <Underscore> rank => 0
<Character_Representation> ::= <Nonquote_Character> rank => 0
                             | <Quote_Symbol> rank => -1
<Nonquote_Character> ::= <Lex533> rank => 0
<Quote_Symbol> ::= <Quote> <Quote> rank => 0
<Gen680> ::= <Separator> <Quote> <Character_Representation_any> <Quote> rank => 0
<Gen680_any> ::= <Gen680>* rank => 0
<National_Character_String_Literal> ::= <Lex534> <Quote> <Character_Representation_any> <Quote> <Gen680_any> rank => 0
<Gen683> ::= <Introducer> <Character_Set_Specification> rank => 0
<Gen683_maybe> ::= <Gen683> rank => 0
<Gen683_maybe> ::= rank => -1
<Unicode_Representation_any> ::= <Unicode_Representation>* rank => 0
<Gen687> ::= <Separator> <Quote> <Unicode_Representation_any> <Quote> rank => 0
<Gen687_any> ::= <Gen687>* rank => 0
<Gen689> ::= <Lex363> <Escape_Character> rank => 0
<Gen689_maybe> ::= <Gen689> rank => 0
<Gen689_maybe> ::= rank => -1
<Unicode_Character_String_Literal> ::= <Gen683_maybe> <Lex035> <Ampersand> <Quote> <Unicode_Representation_any> <Quote> <Gen687_any> <Gen689_maybe> rank => 0
<Unicode_Representation> ::= <Character_Representation> rank => 0
                           | <Unicode_Escape_Value> rank => -1
<Gen695> ::= <Hexit> <Hexit> rank => 0
<Gen695_any> ::= <Gen695>* rank => 0
<Gen697> ::= <Hexit> <Hexit> rank => 0
<Gen697_any> ::= <Gen697>* rank => 0
<Gen699> ::= <Separator> <Quote> <Gen697_any> <Quote> rank => 0
<Gen699_any> ::= <Gen699>* rank => 0
<Gen701> ::= <Lex363> <Escape_Character> rank => 0
<Gen701_maybe> ::= <Gen701> rank => 0
<Gen701_maybe> ::= rank => -1
<Binary_String_Literal> ::= <Lex535> <Quote> <Gen695_any> <Quote> <Gen699_any> <Gen701_maybe> rank => 0
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
<Sign_maybe> ::= <Sign> rank => 0
<Sign_maybe> ::= rank => -1
<Signed_Numeric_Literal> ::= <Sign_maybe> <Unsigned_Numeric_Literal> rank => 0
<Unsigned_Numeric_Literal> ::= <Exact_Numeric_Literal> rank => 0
                             | <Approximate_Numeric_Literal> rank => -1
<Unsigned_Integer> ::= <Lex546_many> rank => 0
<Unsigned_Integer_maybe> ::= <Unsigned_Integer> rank => 0
<Unsigned_Integer_maybe> ::= rank => -1
<Gen726> ::= <Period> <Unsigned_Integer_maybe> rank => 0
<Gen726_maybe> ::= <Gen726> rank => 0
<Gen726_maybe> ::= rank => -1
<Exact_Numeric_Literal> ::= <Unsigned_Integer> <Gen726_maybe> rank => 0
                          | <Period> <Unsigned_Integer> rank => -1
<Sign> ::= <Plus_Sign> rank => 0
         | <Minus_Sign> rank => -1
<Approximate_Numeric_Literal> ::= <Mantissa> <Lex538> <Exponent> rank => 0
<Mantissa> ::= <Exact_Numeric_Literal> rank => 0
<Exponent> ::= <Signed_Integer> rank => 0
<Signed_Integer> ::= <Sign_maybe> <Unsigned_Integer> rank => 0
<Datetime_Literal> ::= <Date_Literal> rank => 0
                     | <Time_Literal> rank => -1
                     | <Timestamp_Literal> rank => -2
<Date_Literal> ::= <Lex342> <Date_String> rank => 0
<Time_Literal> ::= <Lex500> <Time_String> rank => 0
<Timestamp_Literal> ::= <Lex501> <Timestamp_String> rank => 0
<Date_String> ::= <Quote> <Unquoted_Date_String> <Quote> rank => 0
<Time_String> ::= <Quote> <Unquoted_Time_String> <Quote> rank => 0
<Timestamp_String> ::= <Quote> <Unquoted_Timestamp_String> <Quote> rank => 0
<Time_Zone_Interval> ::= <Sign> <Hours_Value> <Colon> <Minutes_Value> rank => 0
<Date_Value> ::= <Years_Value> <Minus_Sign> <Months_Value> <Minus_Sign> <Days_Value> rank => 0
<Time_Value> ::= <Hours_Value> <Colon> <Minutes_Value> <Colon> <Seconds_Value> rank => 0
<Interval_Literal> ::= <Lex399> <Sign_maybe> <Interval_String> <Interval_Qualifier> rank => 0
<Interval_String> ::= <Quote> <Unquoted_Interval_String> <Quote> rank => 0
<Unquoted_Date_String> ::= <Date_Value> rank => 0
<Time_Zone_Interval_maybe> ::= <Time_Zone_Interval> rank => 0
<Time_Zone_Interval_maybe> ::= rank => -1
<Unquoted_Time_String> ::= <Time_Value> <Time_Zone_Interval_maybe> rank => 0
<Unquoted_Timestamp_String> ::= <Unquoted_Date_String> <Space> <Unquoted_Time_String> rank => 0
<Gen756> ::= <Year_Month_Literal> rank => 0
           | <Day_Time_Literal> rank => -1
<Unquoted_Interval_String> ::= <Sign_maybe> <Gen756> rank => 0
<Gen759> ::= <Years_Value> <Minus_Sign> rank => 0
<Gen759_maybe> ::= <Gen759> rank => 0
<Gen759_maybe> ::= rank => -1
<Year_Month_Literal> ::= <Years_Value> rank => 0
                       | <Gen759_maybe> <Months_Value> rank => -1
<Day_Time_Literal> ::= <Day_Time_Interval> rank => 0
                     | <Time_Interval> rank => -1
<Gen766> ::= <Colon> <Seconds_Value> rank => 0
<Gen766_maybe> ::= <Gen766> rank => 0
<Gen766_maybe> ::= rank => -1
<Gen769> ::= <Colon> <Minutes_Value> <Gen766_maybe> rank => 0
<Gen769_maybe> ::= <Gen769> rank => 0
<Gen769_maybe> ::= rank => -1
<Gen772> ::= <Space> <Hours_Value> <Gen769_maybe> rank => 0
<Gen772_maybe> ::= <Gen772> rank => 0
<Gen772_maybe> ::= rank => -1
<Day_Time_Interval> ::= <Days_Value> <Gen772_maybe> rank => 0
<Gen776> ::= <Colon> <Seconds_Value> rank => 0
<Gen776_maybe> ::= <Gen776> rank => 0
<Gen776_maybe> ::= rank => -1
<Gen779> ::= <Colon> <Minutes_Value> <Gen776_maybe> rank => 0
<Gen779_maybe> ::= <Gen779> rank => 0
<Gen779_maybe> ::= rank => -1
<Gen782> ::= <Colon> <Seconds_Value> rank => 0
<Gen782_maybe> ::= <Gen782> rank => 0
<Gen782_maybe> ::= rank => -1
<Time_Interval> ::= <Hours_Value> <Gen779_maybe> rank => 0
                  | <Minutes_Value> <Gen782_maybe> rank => -1
                  | <Seconds_Value> rank => -2
<Years_Value> ::= <Datetime_Value> rank => 0
<Months_Value> ::= <Datetime_Value> rank => 0
<Days_Value> ::= <Datetime_Value> rank => 0
<Hours_Value> ::= <Datetime_Value> rank => 0
<Minutes_Value> ::= <Datetime_Value> rank => 0
<Seconds_Fraction_maybe> ::= <Seconds_Fraction> rank => 0
<Seconds_Fraction_maybe> ::= rank => -1
<Gen795> ::= <Period> <Seconds_Fraction_maybe> rank => 0
<Gen795_maybe> ::= <Gen795> rank => 0
<Gen795_maybe> ::= rank => -1
<Seconds_Value> ::= <Seconds_Integer_Value> <Gen795_maybe> rank => 0
<Seconds_Integer_Value> ::= <Unsigned_Integer> rank => 0
<Seconds_Fraction> ::= <Unsigned_Integer> rank => 0
<Datetime_Value> ::= <Unsigned_Integer> rank => 0
<Boolean_Literal> ::= <Lex509> rank => 0
                    | <Lex369> rank => -1
                    | <Lex512> rank => -2
<Identifier> ::= <Actual_Identifier> rank => 0
<Actual_Identifier> ::= <Regular_Identifier> rank => 0
                      | <Delimited_Identifier> rank => -1
<Gen808> ::= <Underscore> rank => 0
           | <SQL_Language_Identifier_Part> rank => -1
<Gen808_any> ::= <Gen808>* rank => 0
<SQL_Language_Identifier> ::= <SQL_Language_Identifier_Start> <Gen808_any> rank => 0
<SQL_Language_Identifier_Start> ::= <Simple_Latin_Letter> rank => 0
<SQL_Language_Identifier_Part> ::= <Simple_Latin_Letter> rank => 0
                                 | <Digit> rank => -1
<Authorization_Identifier> ::= <Role_Name> rank => 0
                             | <User_Identifier> rank => -1
<Table_Name> ::= <Local_Or_Schema_Qualified_Name> rank => 0
<Domain_Name> ::= <Schema_Qualified_Name> rank => 0
<Unqualified_Schema_Name> ::= <Identifier> rank => 0
<Gen820> ::= <Catalog_Name> <Period> rank => 0
<Gen820_maybe> ::= <Gen820> rank => 0
<Gen820_maybe> ::= rank => -1
<Schema_Name> ::= <Gen820_maybe> <Unqualified_Schema_Name> rank => 0
<Catalog_Name> ::= <Identifier> rank => 0
<Gen825> ::= <Schema_Name> <Period> rank => 0
<Gen825_maybe> ::= <Gen825> rank => 0
<Gen825_maybe> ::= rank => -1
<Schema_Qualified_Name> ::= <Gen825_maybe> <Qualified_Identifier> rank => 0
<Gen829> ::= <Local_Or_Schema_Qualifier> <Period> rank => 0
<Gen829_maybe> ::= <Gen829> rank => 0
<Gen829_maybe> ::= rank => -1
<Local_Or_Schema_Qualified_Name> ::= <Gen829_maybe> <Qualified_Identifier> rank => 0
<Local_Or_Schema_Qualifier> ::= <Schema_Name> rank => 0
                              | <Lex418> rank => -1
<Qualified_Identifier> ::= <Identifier> rank => 0
<Column_Name> ::= <Identifier> rank => 0
<Correlation_Name> ::= <Identifier> rank => 0
<Query_Name> ::= <Identifier> rank => 0
<SQL_Client_Module_Name> ::= <Identifier> rank => 0
<Procedure_Name> ::= <Identifier> rank => 0
<Schema_Qualified_Routine_Name> ::= <Schema_Qualified_Name> rank => 0
<Method_Name> ::= <Identifier> rank => 0
<Specific_Name> ::= <Schema_Qualified_Name> rank => 0
<Cursor_Name> ::= <Local_Qualified_Name> rank => 0
<Gen845> ::= <Local_Qualifier> <Period> rank => 0
<Gen845_maybe> ::= <Gen845> rank => 0
<Gen845_maybe> ::= rank => -1
<Local_Qualified_Name> ::= <Gen845_maybe> <Qualified_Identifier> rank => 0
<Local_Qualifier> ::= <Lex418> rank => 0
<Host_Parameter_Name> ::= <Colon> <Identifier> rank => 0
<SQL_Parameter_Name> ::= <Identifier> rank => 0
<Constraint_Name> ::= <Schema_Qualified_Name> rank => 0
<External_Routine_Name> ::= <Identifier> rank => 0
                          | <Character_String_Literal> rank => -1
<Trigger_Name> ::= <Schema_Qualified_Name> rank => 0
<Collation_Name> ::= <Schema_Qualified_Name> rank => 0
<Gen857> ::= <Schema_Name> <Period> rank => 0
<Gen857_maybe> ::= <Gen857> rank => 0
<Gen857_maybe> ::= rank => -1
<Character_Set_Name> ::= <Gen857_maybe> <SQL_Language_Identifier> rank => 0
<Transliteration_Name> ::= <Schema_Qualified_Name> rank => 0
<Transcoding_Name> ::= <Schema_Qualified_Name> rank => 0
<User_Defined_Type_Name> ::= <Schema_Qualified_Type_Name> rank => 0
<Schema_Resolved_User_Defined_Type_Name> ::= <User_Defined_Type_Name> rank => 0
<Gen865> ::= <Schema_Name> <Period> rank => 0
<Gen865_maybe> ::= <Gen865> rank => 0
<Gen865_maybe> ::= rank => -1
<Schema_Qualified_Type_Name> ::= <Gen865_maybe> <Qualified_Identifier> rank => 0
<Attribute_Name> ::= <Identifier> rank => 0
<Field_Name> ::= <Identifier> rank => 0
<Savepoint_Name> ::= <Identifier> rank => 0
<Sequence_Generator_Name> ::= <Schema_Qualified_Name> rank => 0
<Role_Name> ::= <Identifier> rank => 0
<User_Identifier> ::= <Identifier> rank => 0
<Connection_Name> ::= <Simple_Value_Specification> rank => 0
<Sql_Server_Name> ::= <Simple_Value_Specification> rank => 0
<Connection_User_Name> ::= <Simple_Value_Specification> rank => 0
<SQL_Statement_Name> ::= <Statement_Name> rank => 0
                       | <Extended_Statement_Name> rank => -1
<Statement_Name> ::= <Identifier> rank => 0
<Scope_Option_maybe> ::= <Scope_Option> rank => 0
<Scope_Option_maybe> ::= rank => -1
<Extended_Statement_Name> ::= <Scope_Option_maybe> <Simple_Value_Specification> rank => 0
<Dynamic_Cursor_Name> ::= <Cursor_Name> rank => 0
                        | <Extended_Cursor_Name> rank => -1
<Extended_Cursor_Name> ::= <Scope_Option_maybe> <Simple_Value_Specification> rank => 0
<Descriptor_Name> ::= <Scope_Option_maybe> <Simple_Value_Specification> rank => 0
<Scope_Option> ::= <Lex380> rank => 0
                 | <Lex409> rank => -1
<Window_Name> ::= <Identifier> rank => 0
<Data_Type> ::= <Predefined_Type> rank => 0
              | <Row_Type> rank => -1
              | <Path_Resolved_User_Defined_Type_Name> rank => -2
              | <Reference_Type> rank => -3
              | <Collection_Type> rank => -4
<Gen896> ::= <Lex317> <Lex482> <Character_Set_Specification> rank => 0
<Gen896_maybe> ::= <Gen896> rank => 0
<Gen896_maybe> ::= rank => -1
<Collate_Clause_maybe> ::= <Collate_Clause> rank => 0
<Collate_Clause_maybe> ::= rank => -1
<Predefined_Type> ::= <Character_String_Type> <Gen896_maybe> <Collate_Clause_maybe> rank => 0
                    | <National_Character_String_Type> <Collate_Clause_maybe> rank => -1
                    | <Binary_Large_Object_String_Type> rank => -2
                    | <Numeric_Type> rank => -3
                    | <Boolean_Type> rank => -4
                    | <Datetime_Type> rank => -5
                    | <Interval_Type> rank => -6
<Gen908> ::= <Left_Paren> <Length> <Right_Paren> rank => 0
<Gen908_maybe> ::= <Gen908> rank => 0
<Gen908_maybe> ::= rank => -1
<Gen911> ::= <Left_Paren> <Length> <Right_Paren> rank => 0
<Gen911_maybe> ::= <Gen911> rank => 0
<Gen911_maybe> ::= rank => -1
<Gen914> ::= <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Gen914_maybe> ::= <Gen914> rank => 0
<Gen914_maybe> ::= rank => -1
<Gen917> ::= <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Gen917_maybe> ::= <Gen917> rank => 0
<Gen917_maybe> ::= rank => -1
<Gen920> ::= <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Gen920_maybe> ::= <Gen920> rank => 0
<Gen920_maybe> ::= rank => -1
<Character_String_Type> ::= <Lex317> <Gen908_maybe> rank => 0
                          | <Lex316> <Gen911_maybe> rank => -1
                          | <Lex317> <Lex523> <Left_Paren> <Length> <Right_Paren> rank => -2
                          | <Lex316> <Lex523> <Left_Paren> <Length> <Right_Paren> rank => -3
                          | <Lex522> <Left_Paren> <Length> <Right_Paren> rank => -4
                          | <Lex317> <Lex404> <Lex182> <Gen914_maybe> rank => -5
                          | <Lex316> <Lex404> <Lex182> <Gen917_maybe> rank => -6
                          | <Lex319> <Gen920_maybe> rank => -7
<Gen931> ::= <Left_Paren> <Length> <Right_Paren> rank => 0
<Gen931_maybe> ::= <Gen931> rank => 0
<Gen931_maybe> ::= rank => -1
<Gen934> ::= <Left_Paren> <Length> <Right_Paren> rank => 0
<Gen934_maybe> ::= <Gen934> rank => 0
<Gen934_maybe> ::= rank => -1
<Gen937> ::= <Left_Paren> <Length> <Right_Paren> rank => 0
<Gen937_maybe> ::= <Gen937> rank => 0
<Gen937_maybe> ::= rank => -1
<Gen940> ::= <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Gen940_maybe> ::= <Gen940> rank => 0
<Gen940_maybe> ::= rank => -1
<Gen943> ::= <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Gen943_maybe> ::= <Gen943> rank => 0
<Gen943_maybe> ::= rank => -1
<Gen946> ::= <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Gen946_maybe> ::= <Gen946> rank => 0
<Gen946_maybe> ::= rank => -1
<National_Character_String_Type> ::= <Lex421> <Lex317> <Gen931_maybe> rank => 0
                                   | <Lex421> <Lex316> <Gen934_maybe> rank => -1
                                   | <Lex423> <Gen937_maybe> rank => -2
                                   | <Lex421> <Lex317> <Lex523> <Left_Paren> <Length> <Right_Paren> rank => -3
                                   | <Lex421> <Lex316> <Lex523> <Left_Paren> <Length> <Right_Paren> rank => -4
                                   | <Lex423> <Lex523> <Left_Paren> <Length> <Right_Paren> rank => -5
                                   | <Lex421> <Lex317> <Lex404> <Lex182> <Gen940_maybe> rank => -6
                                   | <Lex423> <Lex404> <Lex182> <Gen943_maybe> rank => -7
                                   | <Lex424> <Gen946_maybe> rank => -8
<Gen958> ::= <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Gen958_maybe> ::= <Gen958> rank => 0
<Gen958_maybe> ::= rank => -1
<Gen961> ::= <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Gen961_maybe> ::= <Gen961> rank => 0
<Gen961_maybe> ::= rank => -1
<Binary_Large_Object_String_Type> ::= <Lex306> <Lex404> <Lex182> <Gen958_maybe> rank => 0
                                    | <Lex307> <Gen961_maybe> rank => -1
<Numeric_Type> ::= <Exact_Numeric_Type> rank => 0
                 | <Approximate_Numeric_Type> rank => -1
<Gen968> ::= <Comma> <Scale> rank => 0
<Gen968_maybe> ::= <Gen968> rank => 0
<Gen968_maybe> ::= rank => -1
<Gen971> ::= <Left_Paren> <Precision> <Gen968_maybe> <Right_Paren> rank => 0
<Gen971_maybe> ::= <Gen971> rank => 0
<Gen971_maybe> ::= rank => -1
<Gen974> ::= <Comma> <Scale> rank => 0
<Gen974_maybe> ::= <Gen974> rank => 0
<Gen974_maybe> ::= rank => -1
<Gen977> ::= <Left_Paren> <Precision> <Gen974_maybe> <Right_Paren> rank => 0
<Gen977_maybe> ::= <Gen977> rank => 0
<Gen977_maybe> ::= rank => -1
<Gen980> ::= <Comma> <Scale> rank => 0
<Gen980_maybe> ::= <Gen980> rank => 0
<Gen980_maybe> ::= rank => -1
<Gen983> ::= <Left_Paren> <Precision> <Gen980_maybe> <Right_Paren> rank => 0
<Gen983_maybe> ::= <Gen983> rank => 0
<Gen983_maybe> ::= rank => -1
<Exact_Numeric_Type> ::= <Lex430> <Gen971_maybe> rank => 0
                       | <Lex346> <Gen977_maybe> rank => -1
                       | <Lex345> <Gen983_maybe> rank => -2
                       | <Lex484> rank => -3
                       | <Lex397> rank => -4
                       | <Lex396> rank => -5
                       | <Lex305> rank => -6
<Gen993> ::= <Left_Paren> <Precision> <Right_Paren> rank => 0
<Gen993_maybe> ::= <Gen993> rank => 0
<Gen993_maybe> ::= rank => -1
<Approximate_Numeric_Type> ::= <Lex372> <Gen993_maybe> rank => 0
                             | <Lex451> rank => -1
                             | <Lex355> <Lex445> rank => -2
<Length> ::= <Unsigned_Integer> rank => 0
<Multiplier_maybe> ::= <Multiplier> rank => 0
<Multiplier_maybe> ::= rank => -1
<Char_Length_Units_maybe> ::= <Char_Length_Units> rank => 0
<Char_Length_Units_maybe> ::= rank => -1
<Large_Object_Length> ::= <Unsigned_Integer> <Multiplier_maybe> <Char_Length_Units_maybe> rank => 0
                        | <Large_Object_Length_Token> <Char_Length_Units_maybe> rank => -1
<Char_Length_Units> ::= <Lex067> rank => 0
                      | <Lex077> rank => -1
                      | <Lex183> rank => -2
<Precision> ::= <Unsigned_Integer> rank => 0
<Scale> ::= <Unsigned_Integer> rank => 0
<Boolean_Type> ::= <Lex308> rank => 0
<Gen1012> ::= <Left_Paren> <Time_Precision> <Right_Paren> rank => 0
<Gen1012_maybe> ::= <Gen1012> rank => 0
<Gen1012_maybe> ::= rank => -1
<Gen1015> ::= <With_Or_Without_Time_Zone> rank => 0
<Gen1015_maybe> ::= <Gen1015> rank => 0
<Gen1015_maybe> ::= rank => -1
<Gen1018> ::= <Left_Paren> <Timestamp_Precision> <Right_Paren> rank => 0
<Gen1018_maybe> ::= <Gen1018> rank => 0
<Gen1018_maybe> ::= rank => -1
<Gen1021> ::= <With_Or_Without_Time_Zone> rank => 0
<Gen1021_maybe> ::= <Gen1021> rank => 0
<Gen1021_maybe> ::= rank => -1
<Datetime_Type> ::= <Lex342> rank => 0
                  | <Lex500> <Gen1012_maybe> <Gen1015_maybe> rank => -1
                  | <Lex501> <Gen1018_maybe> <Gen1021_maybe> rank => -2
<With_Or_Without_Time_Zone> ::= <Lex529> <Lex500> <Lex288> rank => 0
                              | <Lex531> <Lex500> <Lex288> rank => -1
<Time_Precision> ::= <Time_Fractional_Seconds_Precision> rank => 0
<Timestamp_Precision> ::= <Time_Fractional_Seconds_Precision> rank => 0
<Time_Fractional_Seconds_Precision> ::= <Unsigned_Integer> rank => 0
<Interval_Type> ::= <Lex399> <Interval_Qualifier> rank => 0
<Row_Type> ::= <Lex473> <Row_Type_Body> rank => 0
<Gen1034> ::= <Comma> <Field_Definition> rank => 0
<Gen1034_any> ::= <Gen1034>* rank => 0
<Row_Type_Body> ::= <Left_Paren> <Field_Definition> <Gen1034_any> <Right_Paren> rank => 0
<Scope_Clause_maybe> ::= <Scope_Clause> rank => 0
<Scope_Clause_maybe> ::= rank => -1
<Reference_Type> ::= <Lex453> <Left_Paren> <Referenced_Type> <Right_Paren> <Scope_Clause_maybe> rank => 0
<Scope_Clause> ::= <Lex547> <Table_Name> rank => 0
<Referenced_Type> ::= <Path_Resolved_User_Defined_Type_Name> rank => 0
<Path_Resolved_User_Defined_Type_Name> ::= <User_Defined_Type_Name> rank => 0
<Collection_Type> ::= <Array_Type> rank => 0
                    | <Multiset_Type> rank => -1
<Gen1045> ::= <Left_Bracket_Or_Trigraph> <Unsigned_Integer> <Right_Bracket_Or_Trigraph> rank => 0
<Gen1045_maybe> ::= <Gen1045> rank => 0
<Gen1045_maybe> ::= rank => -1
<Array_Type> ::= <Data_Type> <Lex296> <Gen1045_maybe> rank => 0
<Multiset_Type> ::= <Data_Type> <Lex420> rank => 0
<Reference_Scope_Check_maybe> ::= <Reference_Scope_Check> rank => 0
<Reference_Scope_Check_maybe> ::= rank => -1
<Field_Definition> ::= <Field_Name> <Data_Type> <Reference_Scope_Check_maybe> rank => 0
<Value_Expression_Primary> ::= <Parenthesized_Value_Expression> rank => 0
                             | <Nonparenthesized_Value_Expression_Primary> rank => -1
<Parenthesized_Value_Expression> ::= <Left_Paren> <Value_Expression> <Right_Paren> rank => 0
<Nonparenthesized_Value_Expression_Primary> ::= <Unsigned_Value_Specification> rank => 0
                                              | <Column_Reference> rank => -1
                                              | <Set_Function_Specification> rank => -2
                                              | <Window_Function> rank => -3
                                              | <Scalar_Subquery> rank => -4
                                              | <Case_Expression> rank => -5
                                              | <Cast_Specification> rank => -6
                                              | <Field_Reference> rank => -7
                                              | <Subtype_Treatment> rank => -8
                                              | <Method_Invocation> rank => -9
                                              | <Static_Method_Invocation> rank => -10
                                              | <New_Specification> rank => -11
                                              | <Attribute_Or_Method_Reference> rank => -12
                                              | <Reference_Resolution> rank => -13
                                              | <Collection_Value_Constructor> rank => -14
                                              | <Array_Element_Reference> rank => -15
                                              | <Multiset_Element_Reference> rank => -16
                                              | <Routine_Invocation> rank => -17
                                              | <Next_Value_Expression> rank => -18
<Value_Specification> ::= <Literal> rank => 0
                        | <General_Value_Specification> rank => -1
<Unsigned_Value_Specification> ::= <Unsigned_Literal> rank => 0
                                 | <General_Value_Specification> rank => -1
<General_Value_Specification> ::= <Host_Parameter_Specification> rank => 0
                                | <SQL_Parameter_Reference> rank => -1
                                | <Dynamic_Parameter_Specification> rank => -2
                                | <Embedded_Variable_Specification> rank => -3
                                | <Current_Collation_Specification> rank => -4
                                | <Lex333> rank => -5
                                | <Lex334> rank => -6
                                | <Lex335> rank => -7
                                | <Lex338> <Path_Resolved_User_Defined_Type_Name> rank => -8
                                | <Lex339> rank => -9
                                | <Lex481> rank => -10
                                | <Lex497> rank => -11
                                | <Lex516> rank => -12
                                | <Lex518> rank => -13
<Simple_Value_Specification> ::= <Literal> rank => 0
                               | <Host_Parameter_Name> rank => -1
                               | <SQL_Parameter_Reference> rank => -2
                               | <Embedded_Variable_Name> rank => -3
<Target_Specification> ::= <Host_Parameter_Specification> rank => 0
                         | <SQL_Parameter_Reference> rank => -1
                         | <Column_Reference> rank => -2
                         | <Target_Array_Element_Specification> rank => -3
                         | <Dynamic_Parameter_Specification> rank => -4
                         | <Embedded_Variable_Specification> rank => -5
<Simple_Target_Specification> ::= <Host_Parameter_Specification> rank => 0
                                | <SQL_Parameter_Reference> rank => -1
                                | <Column_Reference> rank => -2
                                | <Embedded_Variable_Name> rank => -3
<Indicator_Parameter_maybe> ::= <Indicator_Parameter> rank => 0
<Indicator_Parameter_maybe> ::= rank => -1
<Host_Parameter_Specification> ::= <Host_Parameter_Name> <Indicator_Parameter_maybe> rank => 0
<Dynamic_Parameter_Specification> ::= <Question_Mark> rank => 0
<Indicator_Variable_maybe> ::= <Indicator_Variable> rank => 0
<Indicator_Variable_maybe> ::= rank => -1
<Embedded_Variable_Specification> ::= <Embedded_Variable_Name> <Indicator_Variable_maybe> rank => 0
<Lex390_maybe> ::= <Lex390> rank => 0
<Lex390_maybe> ::= rank => -1
<Indicator_Variable> ::= <Lex390_maybe> <Embedded_Variable_Name> rank => 0
<Indicator_Parameter> ::= <Lex390_maybe> <Host_Parameter_Name> rank => 0
<Target_Array_Element_Specification> ::= <Target_Array_Reference> <Left_Bracket_Or_Trigraph> <Simple_Value_Specification> <Right_Bracket_Or_Trigraph> rank => 0
<Target_Array_Reference> ::= <SQL_Parameter_Reference> rank => 0
                           | <Column_Reference> rank => -1
<Current_Collation_Specification> ::= <Lex102> <Left_Paren> <String_Value_Expression> <Right_Paren> rank => 0
<Contextually_Typed_Value_Specification> ::= <Implicitly_Typed_Value_Specification> rank => 0
                                           | <Default_Specification> rank => -1
<Implicitly_Typed_Value_Specification> ::= <Null_Specification> rank => 0
                                         | <Empty_Specification> rank => -1
<Null_Specification> ::= <Lex429> rank => 0
<Empty_Specification> ::= <Lex296> <Left_Bracket_Or_Trigraph> <Right_Bracket_Or_Trigraph> rank => 0
                        | <Lex420> <Left_Bracket_Or_Trigraph> <Right_Bracket_Or_Trigraph> rank => -1
<Default_Specification> ::= <Lex348> rank => 0
<Gen1130> ::= <Period> <Identifier> rank => 0
<Gen1130_any> ::= <Gen1130>* rank => 0
<Identifier_Chain> ::= <Identifier> <Gen1130_any> rank => 0
<Basic_Identifier_Chain> ::= <Identifier_Chain> rank => 0
<Column_Reference> ::= <Basic_Identifier_Chain> rank => 0
                     | <Lex418> <Period> <Qualified_Identifier> <Period> <Column_Name> rank => -1
<SQL_Parameter_Reference> ::= <Basic_Identifier_Chain> rank => 0
<Set_Function_Specification> ::= <Aggregate_Function> rank => 0
                               | <Grouping_Operation> rank => -1
<Gen1139> ::= <Comma> <Column_Reference> rank => 0
<Gen1139_any> ::= <Gen1139>* rank => 0
<Grouping_Operation> ::= <Lex383> <Left_Paren> <Column_Reference> <Gen1139_any> <Right_Paren> rank => 0
<Window_Function> ::= <Window_Function_Type> <Lex441> <Window_Name_Or_Specification> rank => 0
<Window_Function_Type> ::= <Rank_Function_Type> <Left_Paren> <Right_Paren> rank => 0
                         | <Lex229> <Left_Paren> <Right_Paren> rank => -1
                         | <Aggregate_Function> rank => -2
<Rank_Function_Type> ::= <Lex214> rank => 0
                       | <Lex113> rank => -1
                       | <Lex204> rank => -2
                       | <Lex101> rank => -3
<Window_Name_Or_Specification> ::= <Window_Name> rank => 0
                                 | <In_Line_Window_Specification> rank => -1
<In_Line_Window_Specification> ::= <Window_Specification> rank => 0
<Case_Expression> ::= <Case_Abbreviation> rank => 0
                    | <Case_Specification> rank => -1
<Gen1155> ::= <Comma> <Value_Expression> rank => 0
<Gen1155_many> ::= <Gen1155>+ rank => 0
<Case_Abbreviation> ::= <Lex179> <Left_Paren> <Value_Expression> <Comma> <Value_Expression> <Right_Paren> rank => 0
                      | <Lex075> <Left_Paren> <Value_Expression> <Gen1155_many> <Right_Paren> rank => -1
<Case_Specification> ::= <Simple_Case> rank => 0
                       | <Searched_Case> rank => -1
<Simple_When_Clause_many> ::= <Simple_When_Clause>+ rank => 0
<Else_Clause_maybe> ::= <Else_Clause> rank => 0
<Else_Clause_maybe> ::= rank => -1
<Simple_Case> ::= <Lex314> <Case_Operand> <Simple_When_Clause_many> <Else_Clause_maybe> <Lex361> rank => 0
<Searched_When_Clause_many> ::= <Searched_When_Clause>+ rank => 0
<Searched_Case> ::= <Lex314> <Searched_When_Clause_many> <Else_Clause_maybe> <Lex361> rank => 0
<Simple_When_Clause> ::= <Lex524> <When_Operand> <Lex499> <Result> rank => 0
<Searched_When_Clause> ::= <Lex524> <Search_Condition> <Lex499> <Result> rank => 0
<Else_Clause> ::= <Lex360> <Result> rank => 0
<Case_Operand> ::= <Row_Value_Predicand> rank => 0
                 | <Overlaps_Predicate> rank => -1
<When_Operand> ::= <Row_Value_Predicand> rank => 0
                 | <Comparison_Predicate_Part_2> rank => -1
                 | <Between_Predicate_Part_2> rank => -2
                 | <In_Predicate_Part_2> rank => -3
                 | <Character_Like_Predicate_Part_2> rank => -4
                 | <Octet_Like_Predicate_Part_2> rank => -5
                 | <Similar_Predicate_Part_2> rank => -6
                 | <Null_Predicate_Part_2> rank => -7
                 | <Quantified_Comparison_Predicate_Part_2> rank => -8
                 | <Match_Predicate_Part_2> rank => -9
                 | <Overlaps_Predicate_Part_2> rank => -10
                 | <Distinct_Predicate_Part_2> rank => -11
                 | <Member_Predicate_Part_2> rank => -12
                 | <Submultiset_Predicate_Part_2> rank => -13
                 | <Set_Predicate_Part_2> rank => -14
                 | <Type_Predicate_Part_2> rank => -15
<Result> ::= <Result_Expression> rank => 0
           | <Lex429> rank => -1
<Result_Expression> ::= <Value_Expression> rank => 0
<Cast_Specification> ::= <Lex315> <Left_Paren> <Cast_Operand> <Lex297> <Cast_Target> <Right_Paren> rank => 0
<Cast_Operand> ::= <Value_Expression> rank => 0
                 | <Implicitly_Typed_Value_Specification> rank => -1
<Cast_Target> ::= <Domain_Name> rank => 0
                | <Data_Type> rank => -1
<Next_Value_Expression> ::= <Lex175> <Lex518> <Lex373> <Sequence_Generator_Name> rank => 0
<Field_Reference> ::= <Value_Expression_Primary> <Period> <Field_Name> rank => 0
<Subtype_Treatment> ::= <Lex507> <Left_Paren> <Subtype_Operand> <Lex297> <Target_Subtype> <Right_Paren> rank => 0
<Subtype_Operand> ::= <Value_Expression> rank => 0
<Target_Subtype> ::= <Path_Resolved_User_Defined_Type_Name> rank => 0
                   | <Reference_Type> rank => -1
<Method_Invocation> ::= <Direct_Invocation> rank => 0
                      | <Generalized_Invocation> rank => -1
<SQL_Argument_List_maybe> ::= <SQL_Argument_List> rank => 0
<SQL_Argument_List_maybe> ::= rank => -1
<Direct_Invocation> ::= <Value_Expression_Primary> <Period> <Method_Name> <SQL_Argument_List_maybe> rank => 0
<Generalized_Invocation> ::= <Left_Paren> <Value_Expression_Primary> <Lex297> <Data_Type> <Right_Paren> <Period> <Method_Name> <SQL_Argument_List_maybe> rank => 0
<Method_Selection> ::= <Routine_Invocation> rank => 0
<Constructor_Method_Selection> ::= <Routine_Invocation> rank => 0
<Static_Method_Invocation> ::= <Path_Resolved_User_Defined_Type_Name> <Double_Colon> <Method_Name> <SQL_Argument_List_maybe> rank => 0
<Static_Method_Selection> ::= <Routine_Invocation> rank => 0
<New_Specification> ::= <Lex425> <Routine_Invocation> rank => 0
<New_Invocation> ::= <Method_Invocation> rank => 0
                   | <Routine_Invocation> rank => -1
<Attribute_Or_Method_Reference> ::= <Value_Expression_Primary> <Dereference_Operator> <Qualified_Identifier> <SQL_Argument_List_maybe> rank => 0
<Dereference_Operator> ::= <Right_Arrow> rank => 0
<Dereference_Operation> ::= <Reference_Value_Expression> <Dereference_Operator> <Attribute_Name> rank => 0
<Method_Reference> ::= <Value_Expression_Primary> <Dereference_Operator> <Method_Name> <SQL_Argument_List> rank => 0
<Reference_Resolution> ::= <Lex350> <Left_Paren> <Reference_Value_Expression> <Right_Paren> rank => 0
<Array_Element_Reference> ::= <Array_Value_Expression> <Left_Bracket_Or_Trigraph> <Numeric_Value_Expression> <Right_Bracket_Or_Trigraph> rank => 0
<Multiset_Element_Reference> ::= <Lex359> <Left_Paren> <Multiset_Value_Expression> <Right_Paren> rank => 0
<Value_Expression> ::= <Common_Value_Expression> rank => 0
                     | <Boolean_Value_Expression> rank => -1
                     | <Row_Value_Expression> rank => -2
<Common_Value_Expression> ::= <Numeric_Value_Expression> rank => 0
                            | <String_Value_Expression> rank => -1
                            | <Datetime_Value_Expression> rank => -2
                            | <Interval_Value_Expression> rank => -3
                            | <User_Defined_Type_Value_Expression> rank => -4
                            | <Reference_Value_Expression> rank => -5
                            | <Collection_Value_Expression> rank => -6
<User_Defined_Type_Value_Expression> ::= <Value_Expression_Primary> rank => 0
<Reference_Value_Expression> ::= <Value_Expression_Primary> rank => 0
<Collection_Value_Expression> ::= <Array_Value_Expression> rank => 0
                                | <Multiset_Value_Expression> rank => -1
<Collection_Value_Constructor> ::= <Array_Value_Constructor> rank => 0
                                 | <Multiset_Value_Constructor> rank => -1
<Numeric_Value_Expression> ::= <Term> rank => 0
                             | <Numeric_Value_Expression> <Plus_Sign> <Term> rank => -1
                             | <Numeric_Value_Expression> <Minus_Sign> <Term> rank => -2
<Term> ::= <Factor> rank => 0
         | <Term> <Asterisk> <Factor> rank => -1
         | <Term> <Solidus> <Factor> rank => -2
<Factor> ::= <Sign_maybe> <Numeric_Primary> rank => 0
<Numeric_Primary> ::= <Value_Expression_Primary> rank => 0
                    | <Numeric_Value_Function> rank => -1
<Numeric_Value_Function> ::= <Position_Expression> rank => 0
                           | <Extract_Expression> rank => -1
                           | <Length_Expression> rank => -2
                           | <Cardinality_Expression> rank => -3
                           | <Absolute_Value_Expression> rank => -4
                           | <Modulus_Expression> rank => -5
                           | <Natural_Logarithm> rank => -6
                           | <Exponential_Function> rank => -7
                           | <Power_Function> rank => -8
                           | <Square_Root> rank => -9
                           | <Floor_Function> rank => -10
                           | <Ceiling_Function> rank => -11
                           | <Width_Bucket_Function> rank => -12
<Position_Expression> ::= <String_Position_Expression> rank => 0
                        | <Blob_Position_Expression> rank => -1
<Gen1262> ::= <Lex517> <Char_Length_Units> rank => 0
<Gen1262_maybe> ::= <Gen1262> rank => 0
<Gen1262_maybe> ::= rank => -1
<String_Position_Expression> ::= <Lex207> <Left_Paren> <String_Value_Expression> <Lex389> <String_Value_Expression> <Gen1262_maybe> <Right_Paren> rank => 0
<Blob_Position_Expression> ::= <Lex207> <Left_Paren> <Blob_Value_Expression> <Lex389> <Blob_Value_Expression> <Right_Paren> rank => 0
<Length_Expression> ::= <Char_Length_Expression> rank => 0
                      | <Octet_Length_Expression> rank => -1
<Gen1269> ::= <Lex072> rank => 0
            | <Lex068> rank => -1
<Gen1271> ::= <Lex517> <Char_Length_Units> rank => 0
<Gen1271_maybe> ::= <Gen1271> rank => 0
<Gen1271_maybe> ::= rank => -1
<Char_Length_Expression> ::= <Gen1269> <Left_Paren> <String_Value_Expression> <Gen1271_maybe> <Right_Paren> rank => 0
<Octet_Length_Expression> ::= <Lex184> <Left_Paren> <String_Value_Expression> <Right_Paren> rank => 0
<Extract_Expression> ::= <Lex129> <Left_Paren> <Extract_Field> <Lex376> <Extract_Source> <Right_Paren> rank => 0
<Extract_Field> ::= <Primary_Datetime_Field> rank => 0
                  | <Time_Zone_Field> rank => -1
<Time_Zone_Field> ::= <Lex502> rank => 0
                    | <Lex503> rank => -1
<Extract_Source> ::= <Datetime_Value_Expression> rank => 0
                   | <Interval_Value_Expression> rank => -1
<Cardinality_Expression> ::= <Lex059> <Left_Paren> <Collection_Value_Expression> <Right_Paren> rank => 0
<Absolute_Value_Expression> ::= <Lex042> <Left_Paren> <Numeric_Value_Expression> <Right_Paren> rank => 0
<Modulus_Expression> ::= <Lex169> <Left_Paren> <Numeric_Value_Expression> <Comma> <Numeric_Value_Expression> <Right_Paren> rank => 0
<Natural_Logarithm> ::= <Lex157> <Left_Paren> <Numeric_Value_Expression> <Right_Paren> rank => 0
<Exponential_Function> ::= <Lex128> <Left_Paren> <Numeric_Value_Expression> <Right_Paren> rank => 0
<Power_Function> ::= <Lex208> <Left_Paren> <Numeric_Value_Expression_Base> <Comma> <Numeric_Value_Expression_Exponent> <Right_Paren> rank => 0
<Numeric_Value_Expression_Base> ::= <Numeric_Value_Expression> rank => 0
<Numeric_Value_Expression_Exponent> ::= <Numeric_Value_Expression> rank => 0
<Square_Root> ::= <Lex249> <Left_Paren> <Numeric_Value_Expression> <Right_Paren> rank => 0
<Floor_Function> ::= <Lex132> <Left_Paren> <Numeric_Value_Expression> <Right_Paren> rank => 0
<Gen1293> ::= <Lex063> rank => 0
            | <Lex064> rank => -1
<Ceiling_Function> ::= <Gen1293> <Left_Paren> <Numeric_Value_Expression> <Right_Paren> rank => 0
<Width_Bucket_Function> ::= <Lex527> <Left_Paren> <Width_Bucket_Operand> <Comma> <Width_Bucket_Bound_1> <Comma> <Width_Bucket_Bound_2> <Comma> <Width_Bucket_Count> <Right_Paren> rank => 0
<Width_Bucket_Operand> ::= <Numeric_Value_Expression> rank => 0
<Width_Bucket_Bound_1> ::= <Numeric_Value_Expression> rank => 0
<Width_Bucket_Bound_2> ::= <Numeric_Value_Expression> rank => 0
<Width_Bucket_Count> ::= <Numeric_Value_Expression> rank => 0
<String_Value_Expression> ::= <Character_Value_Expression> rank => 0
                            | <Blob_Value_Expression> rank => -1
<Character_Value_Expression> ::= <Concatenation> rank => 0
                               | <Character_Factor> rank => -1
<Concatenation> ::= <Character_Value_Expression> <Concatenation_Operator> <Character_Factor> rank => 0
<Character_Factor> ::= <Character_Primary> <Collate_Clause_maybe> rank => 0
<Character_Primary> ::= <Value_Expression_Primary> rank => 0
                      | <String_Value_Function> rank => -1
<Blob_Value_Expression> ::= <Blob_Concatenation> rank => 0
                          | <Blob_Factor> rank => -1
<Blob_Factor> ::= <Blob_Primary> rank => 0
<Blob_Primary> ::= <Value_Expression_Primary> rank => 0
                 | <String_Value_Function> rank => -1
<Blob_Concatenation> ::= <Blob_Value_Expression> <Concatenation_Operator> <Blob_Factor> rank => 0
<String_Value_Function> ::= <Character_Value_Function> rank => 0
                          | <Blob_Value_Function> rank => -1
<Character_Value_Function> ::= <Character_Substring_Function> rank => 0
                             | <Regular_Expression_Substring_Function> rank => -1
                             | <Fold> rank => -2
                             | <Transcoding> rank => -3
                             | <Character_Transliteration> rank => -4
                             | <Trim_Function> rank => -5
                             | <Character_Overlay_Function> rank => -6
                             | <Normalize_Function> rank => -7
                             | <Specific_Type_Method> rank => -8
<Gen1326> ::= <Lex373> <String_Length> rank => 0
<Gen1326_maybe> ::= <Gen1326> rank => 0
<Gen1326_maybe> ::= rank => -1
<Gen1329> ::= <Lex517> <Char_Length_Units> rank => 0
<Gen1329_maybe> ::= <Gen1329> rank => 0
<Gen1329_maybe> ::= rank => -1
<Character_Substring_Function> ::= <Lex257> <Left_Paren> <Character_Value_Expression> <Lex376> <Start_Position> <Gen1326_maybe> <Gen1329_maybe> <Right_Paren> rank => 0
<Regular_Expression_Substring_Function> ::= <Lex257> <Left_Paren> <Character_Value_Expression> <Lex483> <Character_Value_Expression> <Lex363> <Escape_Character> <Right_Paren> rank => 0
<Gen1334> ::= <Lex515> rank => 0
            | <Lex159> rank => -1
<Fold> ::= <Gen1334> <Left_Paren> <Character_Value_Expression> <Right_Paren> rank => 0
<Transcoding> ::= <Lex096> <Left_Paren> <Character_Value_Expression> <Lex517> <Transcoding_Name> <Right_Paren> rank => 0
<Character_Transliteration> ::= <Lex270> <Left_Paren> <Character_Value_Expression> <Lex517> <Transliteration_Name> <Right_Paren> rank => 0
<Trim_Function> ::= <Lex274> <Left_Paren> <Trim_Operands> <Right_Paren> rank => 0
<Trim_Specification_maybe> ::= <Trim_Specification> rank => 0
<Trim_Specification_maybe> ::= rank => -1
<Trim_Character_maybe> ::= <Trim_Character> rank => 0
<Trim_Character_maybe> ::= rank => -1
<Gen1344> ::= <Trim_Specification_maybe> <Trim_Character_maybe> <Lex376> rank => 0
<Gen1344_maybe> ::= <Gen1344> rank => 0
<Gen1344_maybe> ::= rank => -1
<Trim_Operands> ::= <Gen1344_maybe> <Trim_Source> rank => 0
<Trim_Source> ::= <Character_Value_Expression> rank => 0
<Trim_Specification> ::= <Lex406> rank => 0
                       | <Lex505> rank => -1
                       | <Lex309> rank => -2
<Trim_Character> ::= <Character_Value_Expression> rank => 0
<Gen1353> ::= <Lex373> <String_Length> rank => 0
<Gen1353_maybe> ::= <Gen1353> rank => 0
<Gen1353_maybe> ::= rank => -1
<Gen1356> ::= <Lex517> <Char_Length_Units> rank => 0
<Gen1356_maybe> ::= <Gen1356> rank => 0
<Gen1356_maybe> ::= rank => -1
<Character_Overlay_Function> ::= <Lex190> <Left_Paren> <Character_Value_Expression> <Lex205> <Character_Value_Expression> <Lex376> <Start_Position> <Gen1353_maybe> <Gen1356_maybe> <Right_Paren> rank => 0
<Normalize_Function> ::= <Lex176> <Left_Paren> <Character_Value_Expression> <Right_Paren> rank => 0
<Specific_Type_Method> ::= <User_Defined_Type_Value_Expression> <Period> <Lex487> rank => 0
<Blob_Value_Function> ::= <Blob_Substring_Function> rank => 0
                        | <Blob_Trim_Function> rank => -1
                        | <Blob_Overlay_Function> rank => -2
<Gen1365> ::= <Lex373> <String_Length> rank => 0
<Gen1365_maybe> ::= <Gen1365> rank => 0
<Gen1365_maybe> ::= rank => -1
<Blob_Substring_Function> ::= <Lex257> <Left_Paren> <Blob_Value_Expression> <Lex376> <Start_Position> <Gen1365_maybe> <Right_Paren> rank => 0
<Blob_Trim_Function> ::= <Lex274> <Left_Paren> <Blob_Trim_Operands> <Right_Paren> rank => 0
<Trim_Octet_maybe> ::= <Trim_Octet> rank => 0
<Trim_Octet_maybe> ::= rank => -1
<Gen1372> ::= <Trim_Specification_maybe> <Trim_Octet_maybe> <Lex376> rank => 0
<Gen1372_maybe> ::= <Gen1372> rank => 0
<Gen1372_maybe> ::= rank => -1
<Blob_Trim_Operands> ::= <Gen1372_maybe> <Blob_Trim_Source> rank => 0
<Blob_Trim_Source> ::= <Blob_Value_Expression> rank => 0
<Trim_Octet> ::= <Blob_Value_Expression> rank => 0
<Gen1378> ::= <Lex373> <String_Length> rank => 0
<Gen1378_maybe> ::= <Gen1378> rank => 0
<Gen1378_maybe> ::= rank => -1
<Blob_Overlay_Function> ::= <Lex190> <Left_Paren> <Blob_Value_Expression> <Lex205> <Blob_Value_Expression> <Lex376> <Start_Position> <Gen1378_maybe> <Right_Paren> rank => 0
<Start_Position> ::= <Numeric_Value_Expression> rank => 0
<String_Length> ::= <Numeric_Value_Expression> rank => 0
<Datetime_Value_Expression> ::= <Datetime_Term> rank => 0
                              | <Interval_Value_Expression> <Plus_Sign> <Datetime_Term> rank => -1
                              | <Datetime_Value_Expression> <Plus_Sign> <Interval_Term> rank => -2
                              | <Datetime_Value_Expression> <Minus_Sign> <Interval_Term> rank => -3
<Datetime_Term> ::= <Datetime_Factor> rank => 0
<Time_Zone_maybe> ::= <Time_Zone> rank => 0
<Time_Zone_maybe> ::= rank => -1
<Datetime_Factor> ::= <Datetime_Primary> <Time_Zone_maybe> rank => 0
<Datetime_Primary> ::= <Value_Expression_Primary> rank => 0
                     | <Datetime_Value_Function> rank => -1
<Time_Zone> ::= <Lex300> <Time_Zone_Specifier> rank => 0
<Time_Zone_Specifier> ::= <Lex409> rank => 0
                        | <Lex500> <Lex288> <Interval_Primary> rank => -1
<Datetime_Value_Function> ::= <Current_Date_Value_Function> rank => 0
                            | <Current_Time_Value_Function> rank => -1
                            | <Current_Timestamp_Value_Function> rank => -2
                            | <Current_Local_Time_Value_Function> rank => -3
                            | <Current_Local_Timestamp_Value_Function> rank => -4
<Current_Date_Value_Function> ::= <Lex332> rank => 0
<Gen1403> ::= <Left_Paren> <Time_Precision> <Right_Paren> rank => 0
<Gen1403_maybe> ::= <Gen1403> rank => 0
<Gen1403_maybe> ::= rank => -1
<Current_Time_Value_Function> ::= <Lex336> <Gen1403_maybe> rank => 0
<Gen1407> ::= <Left_Paren> <Time_Precision> <Right_Paren> rank => 0
<Gen1407_maybe> ::= <Gen1407> rank => 0
<Gen1407_maybe> ::= rank => -1
<Current_Local_Time_Value_Function> ::= <Lex410> <Gen1407_maybe> rank => 0
<Gen1411> ::= <Left_Paren> <Timestamp_Precision> <Right_Paren> rank => 0
<Gen1411_maybe> ::= <Gen1411> rank => 0
<Gen1411_maybe> ::= rank => -1
<Current_Timestamp_Value_Function> ::= <Lex337> <Gen1411_maybe> rank => 0
<Gen1415> ::= <Left_Paren> <Timestamp_Precision> <Right_Paren> rank => 0
<Gen1415_maybe> ::= <Gen1415> rank => 0
<Gen1415_maybe> ::= rank => -1
<Current_Local_Timestamp_Value_Function> ::= <Lex411> <Gen1415_maybe> rank => 0
<Interval_Value_Expression> ::= <Interval_Term> rank => 0
                              | <Interval_Value_Expression_1> <Plus_Sign> <Interval_Term_1> rank => -1
                              | <Interval_Value_Expression_1> <Minus_Sign> <Interval_Term_1> rank => -2
                              | <Left_Paren> <Datetime_Value_Expression> <Minus_Sign> <Datetime_Term> <Right_Paren> <Interval_Qualifier> rank => -3
<Interval_Term> ::= <Interval_Factor> rank => 0
                  | <Interval_Term_2> <Asterisk> <Factor> rank => -1
                  | <Interval_Term_2> <Solidus> <Factor> rank => -2
                  | <Term> <Asterisk> <Interval_Factor> rank => -3
<Interval_Factor> ::= <Sign_maybe> <Interval_Primary> rank => 0
<Interval_Qualifier_maybe> ::= <Interval_Qualifier> rank => 0
<Interval_Qualifier_maybe> ::= rank => -1
<Interval_Primary> ::= <Value_Expression_Primary> <Interval_Qualifier_maybe> rank => 0
                     | <Interval_Value_Function> rank => -1
<Interval_Value_Expression_1> ::= <Interval_Value_Expression> rank => 0
<Interval_Term_1> ::= <Interval_Term> rank => 0
<Interval_Term_2> ::= <Interval_Term> rank => 0
<Interval_Value_Function> ::= <Interval_Absolute_Value_Function> rank => 0
<Interval_Absolute_Value_Function> ::= <Lex042> <Left_Paren> <Interval_Value_Expression> <Right_Paren> rank => 0
<Boolean_Value_Expression> ::= <Boolean_Term> rank => 0
                             | <Boolean_Value_Expression> <Lex436> <Boolean_Term> rank => -1
<Boolean_Term> ::= <Boolean_Factor> rank => 0
                 | <Boolean_Term> <Lex293> <Boolean_Factor> rank => -1
<Lex428_maybe> ::= <Lex428> rank => 0
<Lex428_maybe> ::= rank => -1
<Boolean_Factor> ::= <Lex428_maybe> <Boolean_Test> rank => 0
<Gen1444> ::= <Lex401> <Lex428_maybe> <Truth_Value> rank => 0
<Gen1444_maybe> ::= <Gen1444> rank => 0
<Gen1444_maybe> ::= rank => -1
<Boolean_Test> ::= <Boolean_Primary> <Gen1444_maybe> rank => 0
<Truth_Value> ::= <Lex509> rank => 0
                | <Lex369> rank => -1
                | <Lex512> rank => -2
<Boolean_Primary> ::= <Predicate> rank => 0
                    | <Boolean_Predicand> rank => -1
<Boolean_Predicand> ::= <Parenthesized_Boolean_Value_Expression> rank => 0
                      | <Nonparenthesized_Value_Expression_Primary> rank => -1
<Parenthesized_Boolean_Value_Expression> ::= <Left_Paren> <Boolean_Value_Expression> <Right_Paren> rank => 0
<Array_Value_Expression> ::= <Array_Concatenation> rank => 0
                           | <Array_Factor> rank => -1
<Array_Concatenation> ::= <Array_Value_Expression_1> <Concatenation_Operator> <Array_Factor> rank => 0
<Array_Value_Expression_1> ::= <Array_Value_Expression> rank => 0
<Array_Factor> ::= <Value_Expression_Primary> rank => 0
<Array_Value_Constructor> ::= <Array_Value_Constructor_By_Enumeration> rank => 0
                            | <Array_Value_Constructor_By_Query> rank => -1
<Array_Value_Constructor_By_Enumeration> ::= <Lex296> <Left_Bracket_Or_Trigraph> <Array_Element_List> <Right_Bracket_Or_Trigraph> rank => 0
<Gen1464> ::= <Comma> <Array_Element> rank => 0
<Gen1464_any> ::= <Gen1464>* rank => 0
<Array_Element_List> ::= <Array_Element> <Gen1464_any> rank => 0
<Array_Element> ::= <Value_Expression> rank => 0
<Order_By_Clause_maybe> ::= <Order_By_Clause> rank => 0
<Order_By_Clause_maybe> ::= rank => -1
<Array_Value_Constructor_By_Query> ::= <Lex296> <Left_Paren> <Query_Expression> <Order_By_Clause_maybe> <Right_Paren> rank => 0
<Gen1471> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Gen1473> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Multiset_Value_Expression> ::= <Multiset_Term> rank => 0
                              | <Multiset_Value_Expression> <Lex420> <Lex510> <Gen1471> <Multiset_Term> rank => -1
                              | <Multiset_Value_Expression> <Lex420> <Lex364> <Gen1473> <Multiset_Term> rank => -2
<Gen1478> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Multiset_Term> ::= <Multiset_Primary> rank => 0
                  | <Multiset_Term> <Lex420> <Lex398> <Gen1478> <Multiset_Primary> rank => -1
<Multiset_Primary> ::= <Multiset_Value_Function> rank => 0
                     | <Value_Expression_Primary> rank => -1
<Multiset_Value_Function> ::= <Multiset_Set_Function> rank => 0
<Multiset_Set_Function> ::= <Lex482> <Left_Paren> <Multiset_Value_Expression> <Right_Paren> rank => 0
<Multiset_Value_Constructor> ::= <Multiset_Value_Constructor_By_Enumeration> rank => 0
                               | <Multiset_Value_Constructor_By_Query> rank => -1
                               | <Table_Value_Constructor_By_Query> rank => -2
<Multiset_Value_Constructor_By_Enumeration> ::= <Lex420> <Left_Bracket_Or_Trigraph> <Multiset_Element_List> <Right_Bracket_Or_Trigraph> rank => 0
<Gen1490> ::= <Comma> <Multiset_Element> rank => 0
<Gen1490_any> ::= <Gen1490>* rank => 0
<Multiset_Element_List> ::= <Multiset_Element> <Gen1490_any> rank => 0
<Multiset_Element> ::= <Value_Expression> rank => 0
<Multiset_Value_Constructor_By_Query> ::= <Lex420> <Left_Paren> <Query_Expression> <Right_Paren> rank => 0
<Table_Value_Constructor_By_Query> ::= <Lex498> <Left_Paren> <Query_Expression> <Right_Paren> rank => 0
<Row_Value_Constructor> ::= <Common_Value_Expression> rank => 0
                          | <Boolean_Value_Expression> rank => -1
                          | <Explicit_Row_Value_Constructor> rank => -2
<Explicit_Row_Value_Constructor> ::= <Left_Paren> <Row_Value_Constructor_Element> <Comma> <Row_Value_Constructor_Element_List> <Right_Paren> rank => 0
                                   | <Lex473> <Left_Paren> <Row_Value_Constructor_Element_List> <Right_Paren> rank => -1
                                   | <Row_Subquery> rank => -2
<Gen1502> ::= <Comma> <Row_Value_Constructor_Element> rank => 0
<Gen1502_any> ::= <Gen1502>* rank => 0
<Row_Value_Constructor_Element_List> ::= <Row_Value_Constructor_Element> <Gen1502_any> rank => 0
<Row_Value_Constructor_Element> ::= <Value_Expression> rank => 0
<Contextually_Typed_Row_Value_Constructor> ::= <Common_Value_Expression> rank => 0
                                             | <Boolean_Value_Expression> rank => -1
                                             | <Contextually_Typed_Value_Specification> rank => -2
                                             | <Left_Paren> <Contextually_Typed_Row_Value_Constructor_Element> <Comma> <Contextually_Typed_Row_Value_Constructor_Element_List> <Right_Paren> rank => -3
                                             | <Lex473> <Left_Paren> <Contextually_Typed_Row_Value_Constructor_Element_List> <Right_Paren> rank => -4
<Gen1511> ::= <Comma> <Contextually_Typed_Row_Value_Constructor_Element> rank => 0
<Gen1511_any> ::= <Gen1511>* rank => 0
<Contextually_Typed_Row_Value_Constructor_Element_List> ::= <Contextually_Typed_Row_Value_Constructor_Element> <Gen1511_any> rank => 0
<Contextually_Typed_Row_Value_Constructor_Element> ::= <Value_Expression> rank => 0
                                                     | <Contextually_Typed_Value_Specification> rank => -1
<Row_Value_Constructor_Predicand> ::= <Common_Value_Expression> rank => 0
                                    | <Boolean_Predicand> rank => -1
                                    | <Explicit_Row_Value_Constructor> rank => -2
<Row_Value_Expression> ::= <Row_Value_Special_Case> rank => 0
                         | <Explicit_Row_Value_Constructor> rank => -1
<Table_Row_Value_Expression> ::= <Row_Value_Special_Case> rank => 0
                               | <Row_Value_Constructor> rank => -1
<Contextually_Typed_Row_Value_Expression> ::= <Row_Value_Special_Case> rank => 0
                                            | <Contextually_Typed_Row_Value_Constructor> rank => -1
<Row_Value_Predicand> ::= <Row_Value_Special_Case> rank => 0
                        | <Row_Value_Constructor_Predicand> rank => -1
<Row_Value_Special_Case> ::= <Nonparenthesized_Value_Expression_Primary> rank => 0
<Table_Value_Constructor> ::= <Lex519> <Row_Value_Expression_List> rank => 0
<Gen1529> ::= <Comma> <Table_Row_Value_Expression> rank => 0
<Gen1529_any> ::= <Gen1529>* rank => 0
<Row_Value_Expression_List> ::= <Table_Row_Value_Expression> <Gen1529_any> rank => 0
<Contextually_Typed_Table_Value_Constructor> ::= <Lex519> <Contextually_Typed_Row_Value_Expression_List> rank => 0
<Gen1533> ::= <Comma> <Contextually_Typed_Row_Value_Expression> rank => 0
<Gen1533_any> ::= <Gen1533>* rank => 0
<Contextually_Typed_Row_Value_Expression_List> ::= <Contextually_Typed_Row_Value_Expression> <Gen1533_any> rank => 0
<Where_Clause_maybe> ::= <Where_Clause> rank => 0
<Where_Clause_maybe> ::= rank => -1
<Group_By_Clause_maybe> ::= <Group_By_Clause> rank => 0
<Group_By_Clause_maybe> ::= rank => -1
<Having_Clause_maybe> ::= <Having_Clause> rank => 0
<Having_Clause_maybe> ::= rank => -1
<Window_Clause_maybe> ::= <Window_Clause> rank => 0
<Window_Clause_maybe> ::= rank => -1
<Table_Expression> ::= <From_Clause> <Where_Clause_maybe> <Group_By_Clause_maybe> <Having_Clause_maybe> <Window_Clause_maybe> rank => 0
<From_Clause> ::= <Lex376> <Table_Reference_List> rank => 0
<Gen1546> ::= <Comma> <Table_Reference> rank => 0
<Gen1546_any> ::= <Gen1546>* rank => 0
<Table_Reference_List> ::= <Table_Reference> <Gen1546_any> rank => 0
<Sample_Clause_maybe> ::= <Sample_Clause> rank => 0
<Sample_Clause_maybe> ::= rank => -1
<Table_Reference> ::= <Table_Primary_Or_Joined_Table> <Sample_Clause_maybe> rank => 0
<Table_Primary_Or_Joined_Table> ::= <Table_Primary> rank => 0
                                  | <Joined_Table> rank => -1
<Repeatable_Clause_maybe> ::= <Repeatable_Clause> rank => 0
<Repeatable_Clause_maybe> ::= rank => -1
<Sample_Clause> ::= <Lex259> <Sample_Method> <Left_Paren> <Sample_Percentage> <Right_Paren> <Repeatable_Clause_maybe> rank => 0
<Sample_Method> ::= <Lex056> rank => 0
                  | <Lex496> rank => -1
<Repeatable_Clause> ::= <Lex217> <Left_Paren> <Repeat_Argument> <Right_Paren> rank => 0
<Sample_Percentage> ::= <Numeric_Value_Expression> rank => 0
<Repeat_Argument> ::= <Numeric_Value_Expression> rank => 0
<Lex297_maybe> ::= <Lex297> rank => 0
<Lex297_maybe> ::= rank => -1
<Gen1564> ::= <Left_Paren> <Derived_Column_List> <Right_Paren> rank => 0
<Gen1564_maybe> ::= <Gen1564> rank => 0
<Gen1564_maybe> ::= rank => -1
<Gen1567> ::= <Lex297_maybe> <Correlation_Name> <Gen1564_maybe> rank => 0
<Gen1567_maybe> ::= <Gen1567> rank => 0
<Gen1567_maybe> ::= rank => -1
<Gen1570> ::= <Left_Paren> <Derived_Column_List> <Right_Paren> rank => 0
<Gen1570_maybe> ::= <Gen1570> rank => 0
<Gen1570_maybe> ::= rank => -1
<Gen1573> ::= <Left_Paren> <Derived_Column_List> <Right_Paren> rank => 0
<Gen1573_maybe> ::= <Gen1573> rank => 0
<Gen1573_maybe> ::= rank => -1
<Gen1576> ::= <Left_Paren> <Derived_Column_List> <Right_Paren> rank => 0
<Gen1576_maybe> ::= <Gen1576> rank => 0
<Gen1576_maybe> ::= rank => -1
<Gen1579> ::= <Left_Paren> <Derived_Column_List> <Right_Paren> rank => 0
<Gen1579_maybe> ::= <Gen1579> rank => 0
<Gen1579_maybe> ::= rank => -1
<Gen1582> ::= <Left_Paren> <Derived_Column_List> <Right_Paren> rank => 0
<Gen1582_maybe> ::= <Gen1582> rank => 0
<Gen1582_maybe> ::= rank => -1
<Gen1585> ::= <Lex297_maybe> <Correlation_Name> <Gen1582_maybe> rank => 0
<Gen1585_maybe> ::= <Gen1585> rank => 0
<Gen1585_maybe> ::= rank => -1
<Table_Primary> ::= <Table_Or_Query_Name> <Gen1567_maybe> rank => 0
                  | <Derived_Table> <Lex297_maybe> <Correlation_Name> <Gen1570_maybe> rank => -1
                  | <Lateral_Derived_Table> <Lex297_maybe> <Correlation_Name> <Gen1573_maybe> rank => -2
                  | <Collection_Derived_Table> <Lex297_maybe> <Correlation_Name> <Gen1576_maybe> rank => -3
                  | <Table_Function_Derived_Table> <Lex297_maybe> <Correlation_Name> <Gen1579_maybe> rank => -4
                  | <Only_Spec> <Gen1585_maybe> rank => -5
                  | <Left_Paren> <Joined_Table> <Right_Paren> rank => -6
<Only_Spec> ::= <Lex434> <Left_Paren> <Table_Or_Query_Name> <Right_Paren> rank => 0
<Lateral_Derived_Table> ::= <Lex405> <Table_Subquery> rank => 0
<Gen1597> ::= <Lex529> <Lex188> rank => 0
<Gen1597_maybe> ::= <Gen1597> rank => 0
<Gen1597_maybe> ::= rank => -1
<Collection_Derived_Table> ::= <Lex513> <Left_Paren> <Collection_Value_Expression> <Right_Paren> <Gen1597_maybe> rank => 0
<Table_Function_Derived_Table> ::= <Lex498> <Left_Paren> <Collection_Value_Expression> <Right_Paren> rank => 0
<Derived_Table> ::= <Table_Subquery> rank => 0
<Table_Or_Query_Name> ::= <Table_Name> rank => 0
                        | <Query_Name> rank => -1
<Derived_Column_List> ::= <Column_Name_List> rank => 0
<Gen1606> ::= <Comma> <Column_Name> rank => 0
<Gen1606_any> ::= <Gen1606>* rank => 0
<Column_Name_List> ::= <Column_Name> <Gen1606_any> rank => 0
<Joined_Table> ::= <Cross_Join> rank => 0
                 | <Qualified_Join> rank => -1
                 | <Natural_Join> rank => -2
                 | <Union_Join> rank => -3
<Cross_Join> ::= <Table_Reference> <Lex329> <Lex402> <Table_Primary> rank => 0
<Join_Type_maybe> ::= <Join_Type> rank => 0
<Join_Type_maybe> ::= rank => -1
<Qualified_Join> ::= <Table_Reference> <Join_Type_maybe> <Lex402> <Table_Reference> <Join_Specification> rank => 0
<Natural_Join> ::= <Table_Reference> <Lex422> <Join_Type_maybe> <Lex402> <Table_Primary> rank => 0
<Union_Join> ::= <Table_Reference> <Lex510> <Lex402> <Table_Primary> rank => 0
<Join_Specification> ::= <Join_Condition> rank => 0
                       | <Named_Columns_Join> rank => -1
<Join_Condition> ::= <Lex433> <Search_Condition> rank => 0
<Named_Columns_Join> ::= <Lex517> <Left_Paren> <Join_Column_List> <Right_Paren> rank => 0
<Lex439_maybe> ::= <Lex439> rank => 0
<Lex439_maybe> ::= rank => -1
<Join_Type> ::= <Lex391> rank => 0
              | <Outer_Join_Type> <Lex439_maybe> rank => -1
<Outer_Join_Type> ::= <Lex407> rank => 0
                    | <Lex470> rank => -1
                    | <Lex377> rank => -2
<Join_Column_List> ::= <Column_Name_List> rank => 0
<Where_Clause> ::= <Lex526> <Search_Condition> rank => 0
<Set_Quantifier_maybe> ::= <Set_Quantifier> rank => 0
<Set_Quantifier_maybe> ::= rank => -1
<Group_By_Clause> ::= <Lex382> <Lex310> <Set_Quantifier_maybe> <Grouping_Element_List> rank => 0
<Gen1635> ::= <Comma> <Grouping_Element> rank => 0
<Gen1635_any> ::= <Gen1635>* rank => 0
<Grouping_Element_List> ::= <Grouping_Element> <Gen1635_any> rank => 0
<Grouping_Element> ::= <Ordinary_Grouping_Set> rank => 0
                     | <Rollup_List> rank => -1
                     | <Cube_List> rank => -2
                     | <Grouping_Sets_Specification> rank => -3
                     | <Empty_Grouping_Set> rank => -4
<Ordinary_Grouping_Set> ::= <Grouping_Column_Reference> rank => 0
                          | <Left_Paren> <Grouping_Column_Reference_List> <Right_Paren> rank => -1
<Grouping_Column_Reference> ::= <Column_Reference> <Collate_Clause_maybe> rank => 0
<Gen1646> ::= <Comma> <Grouping_Column_Reference> rank => 0
<Gen1646_any> ::= <Gen1646>* rank => 0
<Grouping_Column_Reference_List> ::= <Grouping_Column_Reference> <Gen1646_any> rank => 0
<Rollup_List> ::= <Lex472> <Left_Paren> <Ordinary_Grouping_Set_List> <Right_Paren> rank => 0
<Gen1650> ::= <Comma> <Ordinary_Grouping_Set> rank => 0
<Gen1650_any> ::= <Gen1650>* rank => 0
<Ordinary_Grouping_Set_List> ::= <Ordinary_Grouping_Set> <Gen1650_any> rank => 0
<Cube_List> ::= <Lex330> <Left_Paren> <Ordinary_Grouping_Set_List> <Right_Paren> rank => 0
<Grouping_Sets_Specification> ::= <Lex383> <Lex243> <Left_Paren> <Grouping_Set_List> <Right_Paren> rank => 0
<Gen1655> ::= <Comma> <Grouping_Set> rank => 0
<Gen1655_any> ::= <Gen1655>* rank => 0
<Grouping_Set_List> ::= <Grouping_Set> <Gen1655_any> rank => 0
<Grouping_Set> ::= <Ordinary_Grouping_Set> rank => 0
                 | <Rollup_List> rank => -1
                 | <Cube_List> rank => -2
                 | <Grouping_Sets_Specification> rank => -3
                 | <Empty_Grouping_Set> rank => -4
<Empty_Grouping_Set> ::= <Left_Paren> <Right_Paren> rank => 0
<Having_Clause> ::= <Lex384> <Search_Condition> rank => 0
<Window_Clause> ::= <Lex528> <Window_Definition_List> rank => 0
<Gen1666> ::= <Comma> <Window_Definition> rank => 0
<Gen1666_any> ::= <Gen1666>* rank => 0
<Window_Definition_List> ::= <Window_Definition> <Gen1666_any> rank => 0
<Window_Definition> ::= <New_Window_Name> <Lex297> <Window_Specification> rank => 0
<New_Window_Name> ::= <Window_Name> rank => 0
<Window_Specification> ::= <Left_Paren> <Window_Specification_Details> <Right_Paren> rank => 0
<Existing_Window_Name_maybe> ::= <Existing_Window_Name> rank => 0
<Existing_Window_Name_maybe> ::= rank => -1
<Window_Partition_Clause_maybe> ::= <Window_Partition_Clause> rank => 0
<Window_Partition_Clause_maybe> ::= rank => -1
<Window_Order_Clause_maybe> ::= <Window_Order_Clause> rank => 0
<Window_Order_Clause_maybe> ::= rank => -1
<Window_Frame_Clause_maybe> ::= <Window_Frame_Clause> rank => 0
<Window_Frame_Clause_maybe> ::= rank => -1
<Window_Specification_Details> ::= <Existing_Window_Name_maybe> <Window_Partition_Clause_maybe> <Window_Order_Clause_maybe> <Window_Frame_Clause_maybe> rank => 0
<Existing_Window_Name> ::= <Window_Name> rank => 0
<Window_Partition_Clause> ::= <Lex444> <Lex310> <Window_Partition_Column_Reference_List> rank => 0
<Gen1683> ::= <Comma> <Window_Partition_Column_Reference> rank => 0
<Gen1683_any> ::= <Gen1683>* rank => 0
<Window_Partition_Column_Reference_List> ::= <Window_Partition_Column_Reference> <Gen1683_any> rank => 0
<Window_Partition_Column_Reference> ::= <Column_Reference> <Collate_Clause_maybe> rank => 0
<Window_Order_Clause> ::= <Lex437> <Lex310> <Sort_Specification_List> rank => 0
<Window_Frame_Exclusion_maybe> ::= <Window_Frame_Exclusion> rank => 0
<Window_Frame_Exclusion_maybe> ::= rank => -1
<Window_Frame_Clause> ::= <Window_Frame_Units> <Window_Frame_Extent> <Window_Frame_Exclusion_maybe> rank => 0
<Window_Frame_Units> ::= <Lex474> rank => 0
                       | <Lex449> rank => -1
<Window_Frame_Extent> ::= <Window_Frame_Start> rank => 0
                        | <Window_Frame_Between> rank => -1
<Window_Frame_Start> ::= <Lex276> <Lex209> rank => 0
                       | <Window_Frame_Preceding> rank => -1
                       | <Lex331> <Lex473> rank => -2
<Window_Frame_Preceding> ::= <Unsigned_Value_Specification> <Lex209> rank => 0
<Window_Frame_Between> ::= <Lex304> <Window_Frame_Bound_1> <Lex293> <Window_Frame_Bound_2> rank => 0
<Window_Frame_Bound_1> ::= <Window_Frame_Bound> rank => 0
<Window_Frame_Bound_2> ::= <Window_Frame_Bound> rank => 0
<Window_Frame_Bound> ::= <Window_Frame_Start> rank => 0
                       | <Lex276> <Lex133> rank => -1
                       | <Window_Frame_Following> rank => -2
<Window_Frame_Following> ::= <Unsigned_Value_Specification> <Lex133> rank => 0
<Window_Frame_Exclusion> ::= <Lex126> <Lex331> <Lex473> rank => 0
                           | <Lex126> <Lex382> rank => -1
                           | <Lex126> <Lex262> rank => -2
                           | <Lex126> <Lex426> <Lex189> rank => -3
<Query_Specification> ::= <Lex479> <Set_Quantifier_maybe> <Select_List> <Table_Expression> rank => 0
<Gen1711> ::= <Comma> <Select_Sublist> rank => 0
<Gen1711_any> ::= <Gen1711>* rank => 0
<Select_List> ::= <Asterisk> rank => 0
                | <Select_Sublist> <Gen1711_any> rank => -1
<Select_Sublist> ::= <Derived_Column> rank => 0
                   | <Qualified_Asterisk> rank => -1
<Qualified_Asterisk> ::= <Asterisked_Identifier_Chain> <Period> <Asterisk> rank => 0
                       | <All_Fields_Reference> rank => -1
<Gen1719> ::= <Period> <Asterisked_Identifier> rank => 0
<Gen1719_any> ::= <Gen1719>* rank => 0
<Asterisked_Identifier_Chain> ::= <Asterisked_Identifier> <Gen1719_any> rank => 0
<Asterisked_Identifier> ::= <Identifier> rank => 0
<As_Clause_maybe> ::= <As_Clause> rank => 0
<As_Clause_maybe> ::= rank => -1
<Derived_Column> ::= <Value_Expression> <As_Clause_maybe> rank => 0
<As_Clause> ::= <Lex297_maybe> <Column_Name> rank => 0
<Gen1727> ::= <Lex297> <Left_Paren> <All_Fields_Column_Name_List> <Right_Paren> rank => 0
<Gen1727_maybe> ::= <Gen1727> rank => 0
<Gen1727_maybe> ::= rank => -1
<All_Fields_Reference> ::= <Value_Expression_Primary> <Period> <Asterisk> <Gen1727_maybe> rank => 0
<All_Fields_Column_Name_List> ::= <Column_Name_List> rank => 0
<With_Clause_maybe> ::= <With_Clause> rank => 0
<With_Clause_maybe> ::= rank => -1
<Query_Expression> ::= <With_Clause_maybe> <Query_Expression_Body> rank => 0
<Lex452_maybe> ::= <Lex452> rank => 0
<Lex452_maybe> ::= rank => -1
<With_Clause> ::= <Lex529> <Lex452_maybe> <With_List> rank => 0
<Gen1738> ::= <Comma> <With_List_Element> rank => 0
<Gen1738_any> ::= <Gen1738>* rank => 0
<With_List> ::= <With_List_Element> <Gen1738_any> rank => 0
<Gen1741> ::= <Left_Paren> <With_Column_List> <Right_Paren> rank => 0
<Gen1741_maybe> ::= <Gen1741> rank => 0
<Gen1741_maybe> ::= rank => -1
<Search_Or_Cycle_Clause_maybe> ::= <Search_Or_Cycle_Clause> rank => 0
<Search_Or_Cycle_Clause_maybe> ::= rank => -1
<With_List_Element> ::= <Query_Name> <Gen1741_maybe> <Lex297> <Left_Paren> <Query_Expression> <Right_Paren> <Search_Or_Cycle_Clause_maybe> rank => 0
<With_Column_List> ::= <Column_Name_List> rank => 0
<Query_Expression_Body> ::= <Non_Join_Query_Expression> rank => 0
                          | <Joined_Table> rank => -1
<Gen1750> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Gen1750_maybe> ::= <Gen1750> rank => 0
<Gen1750_maybe> ::= rank => -1
<Corresponding_Spec_maybe> ::= <Corresponding_Spec> rank => 0
<Corresponding_Spec_maybe> ::= rank => -1
<Gen1756> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Gen1756_maybe> ::= <Gen1756> rank => 0
<Gen1756_maybe> ::= rank => -1
<Non_Join_Query_Expression> ::= <Non_Join_Query_Term> rank => 0
                              | <Query_Expression_Body> <Lex510> <Gen1750_maybe> <Corresponding_Spec_maybe> <Query_Term> rank => -1
                              | <Query_Expression_Body> <Lex364> <Gen1756_maybe> <Corresponding_Spec_maybe> <Query_Term> rank => -2
<Query_Term> ::= <Non_Join_Query_Term> rank => 0
               | <Joined_Table> rank => -1
<Gen1765> ::= <Lex290> rank => 0
            | <Lex354> rank => -1
<Gen1765_maybe> ::= <Gen1765> rank => 0
<Gen1765_maybe> ::= rank => -1
<Non_Join_Query_Term> ::= <Non_Join_Query_Primary> rank => 0
                        | <Query_Term> <Lex398> <Gen1765_maybe> <Corresponding_Spec_maybe> <Query_Primary> rank => -1
<Query_Primary> ::= <Non_Join_Query_Primary> rank => 0
                  | <Joined_Table> rank => -1
<Non_Join_Query_Primary> ::= <Simple_Table> rank => 0
                           | <Left_Paren> <Non_Join_Query_Expression> <Right_Paren> rank => -1
<Simple_Table> ::= <Query_Specification> rank => 0
                 | <Table_Value_Constructor> rank => -1
                 | <Explicit_Table> rank => -2
<Explicit_Table> ::= <Lex498> <Table_Or_Query_Name> rank => 0
<Gen1779> ::= <Lex310> <Left_Paren> <Corresponding_Column_List> <Right_Paren> rank => 0
<Gen1779_maybe> ::= <Gen1779> rank => 0
<Gen1779_maybe> ::= rank => -1
<Corresponding_Spec> ::= <Lex327> <Gen1779_maybe> rank => 0
<Corresponding_Column_List> ::= <Column_Name_List> rank => 0
<Search_Or_Cycle_Clause> ::= <Search_Clause> rank => 0
                           | <Cycle_Clause> rank => -1
                           | <Search_Clause> <Cycle_Clause> rank => -2
<Search_Clause> ::= <Lex477> <Recursive_Search_Order> <Lex482> <Sequence_Column> rank => 0
<Recursive_Search_Order> ::= <Lex114> <Lex131> <Lex310> <Sort_Specification_List> rank => 0
                           | <Lex057> <Lex131> <Lex310> <Sort_Specification_List> rank => -1
<Sequence_Column> ::= <Column_Name> rank => 0
<Cycle_Clause> ::= <Lex341> <Cycle_Column_List> <Lex482> <Cycle_Mark_Column> <Lex504> <Cycle_Mark_Value> <Lex348> <Non_Cycle_Mark_Value> <Lex517> <Path_Column> rank => 0
<Gen1792> ::= <Comma> <Cycle_Column> rank => 0
<Gen1792_any> ::= <Gen1792>* rank => 0
<Cycle_Column_List> ::= <Cycle_Column> <Gen1792_any> rank => 0
<Cycle_Column> ::= <Column_Name> rank => 0
<Cycle_Mark_Column> ::= <Column_Name> rank => 0
<Path_Column> ::= <Column_Name> rank => 0
<Cycle_Mark_Value> ::= <Value_Expression> rank => 0
<Non_Cycle_Mark_Value> ::= <Value_Expression> rank => 0
<Scalar_Subquery> ::= <Subquery> rank => 0
<Row_Subquery> ::= <Subquery> rank => 0
<Table_Subquery> ::= <Subquery> rank => 0
<Subquery> ::= <Left_Paren> <Query_Expression> <Right_Paren> rank => 0
<Predicate> ::= <Comparison_Predicate> rank => 0
              | <Between_Predicate> rank => -1
              | <In_Predicate> rank => -2
              | <Like_Predicate> rank => -3
              | <Similar_Predicate> rank => -4
              | <Null_Predicate> rank => -5
              | <Quantified_Comparison_Predicate> rank => -6
              | <Exists_Predicate> rank => -7
              | <Unique_Predicate> rank => -8
              | <Normalized_Predicate> rank => -9
              | <Match_Predicate> rank => -10
              | <Overlaps_Predicate> rank => -11
              | <Distinct_Predicate> rank => -12
              | <Member_Predicate> rank => -13
              | <Submultiset_Predicate> rank => -14
              | <Set_Predicate> rank => -15
              | <Type_Predicate> rank => -16
<Comparison_Predicate> ::= <Row_Value_Predicand> <Comparison_Predicate_Part_2> rank => 0
<Comparison_Predicate_Part_2> ::= <Comp_Op> <Row_Value_Predicand> rank => 0
<Comp_Op> ::= <Equals_Operator> rank => 0
            | <Not_Equals_Operator> rank => -1
            | <Less_Than_Operator> rank => -2
            | <Greater_Than_Operator> rank => -3
            | <Less_Than_Or_Equals_Operator> rank => -4
            | <Greater_Than_Or_Equals_Operator> rank => -5
<Between_Predicate> ::= <Row_Value_Predicand> <Between_Predicate_Part_2> rank => 0
<Gen1830> ::= <Lex299> rank => 0
            | <Lex495> rank => -1
<Gen1830_maybe> ::= <Gen1830> rank => 0
<Gen1830_maybe> ::= rank => -1
<Between_Predicate_Part_2> ::= <Lex428_maybe> <Lex304> <Gen1830_maybe> <Row_Value_Predicand> <Lex293> <Row_Value_Predicand> rank => 0
<In_Predicate> ::= <Row_Value_Predicand> <In_Predicate_Part_2> rank => 0
<In_Predicate_Part_2> ::= <Lex428_maybe> <Lex389> <In_Predicate_Value> rank => 0
<In_Predicate_Value> ::= <Table_Subquery> rank => 0
                       | <Left_Paren> <In_Value_List> <Right_Paren> rank => -1
<Gen1839> ::= <Comma> <Row_Value_Expression> rank => 0
<Gen1839_any> ::= <Gen1839>* rank => 0
<In_Value_List> ::= <Row_Value_Expression> <Gen1839_any> rank => 0
<Like_Predicate> ::= <Character_Like_Predicate> rank => 0
                   | <Octet_Like_Predicate> rank => -1
<Character_Like_Predicate> ::= <Row_Value_Predicand> <Character_Like_Predicate_Part_2> rank => 0
<Gen1845> ::= <Lex363> <Escape_Character> rank => 0
<Gen1845_maybe> ::= <Gen1845> rank => 0
<Gen1845_maybe> ::= rank => -1
<Character_Like_Predicate_Part_2> ::= <Lex428_maybe> <Lex408> <Character_Pattern> <Gen1845_maybe> rank => 0
<Character_Pattern> ::= <Character_Value_Expression> rank => 0
<Escape_Character> ::= <Character_Value_Expression> rank => 0
<Octet_Like_Predicate> ::= <Row_Value_Predicand> <Octet_Like_Predicate_Part_2> rank => 0
<Gen1852> ::= <Lex363> <Escape_Octet> rank => 0
<Gen1852_maybe> ::= <Gen1852> rank => 0
<Gen1852_maybe> ::= rank => -1
<Octet_Like_Predicate_Part_2> ::= <Lex428_maybe> <Lex408> <Octet_Pattern> <Gen1852_maybe> rank => 0
<Octet_Pattern> ::= <Blob_Value_Expression> rank => 0
<Escape_Octet> ::= <Blob_Value_Expression> rank => 0
<Similar_Predicate> ::= <Row_Value_Predicand> <Similar_Predicate_Part_2> rank => 0
<Gen1859> ::= <Lex363> <Escape_Character> rank => 0
<Gen1859_maybe> ::= <Gen1859> rank => 0
<Gen1859_maybe> ::= rank => -1
<Similar_Predicate_Part_2> ::= <Lex428_maybe> <Lex483> <Lex504> <Similar_Pattern> <Gen1859_maybe> rank => 0
<Similar_Pattern> ::= <Character_Value_Expression> rank => 0
<Regular_Expression> ::= <Regular_Term> rank => 0
                       | <Regular_Expression> <Vertical_Bar> <Regular_Term> rank => -1
<Regular_Term> ::= <Regular_Factor> rank => 0
                 | <Regular_Term> <Regular_Factor> rank => -1
<Regular_Factor> ::= <Regular_Primary> rank => 0
                   | <Regular_Primary> <Asterisk> rank => -1
                   | <Regular_Primary> <Plus_Sign> rank => -2
                   | <Regular_Primary> <Question_Mark> rank => -3
                   | <Regular_Primary> <Repeat_Factor> rank => -4
<Upper_Limit_maybe> ::= <Upper_Limit> rank => 0
<Upper_Limit_maybe> ::= rank => -1
<Repeat_Factor> ::= <Left_Brace> <Low_Value> <Upper_Limit_maybe> <Right_Brace> rank => 0
<High_Value_maybe> ::= <High_Value> rank => 0
<High_Value_maybe> ::= rank => -1
<Upper_Limit> ::= <Comma> <High_Value_maybe> rank => 0
<Low_Value> ::= <Unsigned_Integer> rank => 0
<High_Value> ::= <Unsigned_Integer> rank => 0
<Regular_Primary> ::= <Character_Specifier> rank => 0
                    | <Percent> rank => -1
                    | <Regular_Character_Set> rank => -2
                    | <Left_Paren> <Regular_Expression> <Right_Paren> rank => -3
<Character_Specifier> ::= <Non_Escaped_Character> rank => 0
                        | <Escaped_Character> rank => -1
<Non_Escaped_Character> ::= <Lex548> rank => 0
<Escaped_Character> ::= <Lex549> <Lex550> rank => 0
<Character_Enumeration_many> ::= <Character_Enumeration>+ rank => 0
<Character_Enumeration_Include_many> ::= <Character_Enumeration_Include>+ rank => 0
<Character_Enumeration_Exclude_many> ::= <Character_Enumeration_Exclude>+ rank => 0
<Regular_Character_Set> ::= <Underscore> rank => 0
                          | <Left_Bracket> <Character_Enumeration_many> <Right_Bracket> rank => -1
                          | <Left_Bracket> <Circumflex> <Character_Enumeration_many> <Right_Bracket> rank => -2
                          | <Left_Bracket> <Character_Enumeration_Include_many> <Circumflex> <Character_Enumeration_Exclude_many> <Right_Bracket> rank => -3
<Character_Enumeration_Include> ::= <Character_Enumeration> rank => 0
<Character_Enumeration_Exclude> ::= <Character_Enumeration> rank => 0
<Character_Enumeration> ::= <Character_Specifier> rank => 0
                          | <Character_Specifier> <Minus_Sign> <Character_Specifier> rank => -1
                          | <Left_Bracket> <Colon> <Regular_Character_Set_Identifier> <Colon> <Right_Bracket> rank => -2
<Regular_Character_Set_Identifier> ::= <Identifier> rank => 0
<Null_Predicate> ::= <Row_Value_Predicand> <Null_Predicate_Part_2> rank => 0
<Null_Predicate_Part_2> ::= <Lex401> <Lex428_maybe> <Lex429> rank => 0
<Quantified_Comparison_Predicate> ::= <Row_Value_Predicand> <Quantified_Comparison_Predicate_Part_2> rank => 0
<Quantified_Comparison_Predicate_Part_2> ::= <Comp_Op> <Quantifier> <Table_Subquery> rank => 0
<Quantifier> ::= <All> rank => 0
               | <Some> rank => -1
<All> ::= <Lex290> rank => 0
<Some> ::= <Lex485> rank => 0
         | <Lex294> rank => -1
<Exists_Predicate> ::= <Lex367> <Table_Subquery> rank => 0
<Unique_Predicate> ::= <Lex511> <Table_Subquery> rank => 0
<Normalized_Predicate> ::= <String_Value_Expression> <Lex401> <Lex428_maybe> <Lex177> rank => 0
<Match_Predicate> ::= <Row_Value_Predicand> <Match_Predicate_Part_2> rank => 0
<Lex511_maybe> ::= <Lex511> rank => 0
<Lex511_maybe> ::= rank => -1
<Gen1917> ::= <Lex244> rank => 0
            | <Lex199> rank => -1
            | <Lex377> rank => -2
<Gen1917_maybe> ::= <Gen1917> rank => 0
<Gen1917_maybe> ::= rank => -1
<Match_Predicate_Part_2> ::= <Lex412> <Lex511_maybe> <Gen1917_maybe> <Table_Subquery> rank => 0
<Overlaps_Predicate> ::= <Overlaps_Predicate_Part_1> <Overlaps_Predicate_Part_2> rank => 0
<Overlaps_Predicate_Part_1> ::= <Row_Value_Predicand_1> rank => 0
<Overlaps_Predicate_Part_2> ::= <Lex442> <Row_Value_Predicand_2> rank => 0
<Row_Value_Predicand_1> ::= <Row_Value_Predicand> rank => 0
<Row_Value_Predicand_2> ::= <Row_Value_Predicand> rank => 0
<Distinct_Predicate> ::= <Row_Value_Predicand_3> <Distinct_Predicate_Part_2> rank => 0
<Distinct_Predicate_Part_2> ::= <Lex401> <Lex354> <Lex376> <Row_Value_Predicand_4> rank => 0
<Row_Value_Predicand_3> ::= <Row_Value_Predicand> rank => 0
<Row_Value_Predicand_4> ::= <Row_Value_Predicand> rank => 0
<Member_Predicate> ::= <Row_Value_Predicand> <Member_Predicate_Part_2> rank => 0
<Lex431_maybe> ::= <Lex431> rank => 0
<Lex431_maybe> ::= rank => -1
<Member_Predicate_Part_2> ::= <Lex428_maybe> <Lex413> <Lex431_maybe> <Multiset_Value_Expression> rank => 0
<Submultiset_Predicate> ::= <Row_Value_Predicand> <Submultiset_Predicate_Part_2> rank => 0
<Submultiset_Predicate_Part_2> ::= <Lex428_maybe> <Lex494> <Lex431_maybe> <Multiset_Value_Expression> rank => 0
<Set_Predicate> ::= <Row_Value_Predicand> <Set_Predicate_Part_2> rank => 0
<Set_Predicate_Part_2> ::= <Lex401> <Lex428_maybe> <Lex041> <Lex482> rank => 0
<Type_Predicate> ::= <Row_Value_Predicand> <Type_Predicate_Part_2> rank => 0
<Type_Predicate_Part_2> ::= <Lex401> <Lex428_maybe> <Lex431> <Left_Paren> <Type_List> <Right_Paren> rank => 0
<Gen1942> ::= <Comma> <User_Defined_Type_Specification> rank => 0
<Gen1942_any> ::= <Gen1942>* rank => 0
<Type_List> ::= <User_Defined_Type_Specification> <Gen1942_any> rank => 0
<User_Defined_Type_Specification> ::= <Inclusive_User_Defined_Type_Specification> rank => 0
                                    | <Exclusive_User_Defined_Type_Specification> rank => -1
<Inclusive_User_Defined_Type_Specification> ::= <Path_Resolved_User_Defined_Type_Name> rank => 0
<Exclusive_User_Defined_Type_Specification> ::= <Lex434> <Path_Resolved_User_Defined_Type_Name> rank => 0
<Search_Condition> ::= <Boolean_Value_Expression> rank => 0
<Interval_Qualifier> ::= <Start_Field> <Lex504> <End_Field> rank => 0
                       | <Single_Datetime_Field> rank => -1
<Gen1952> ::= <Left_Paren> <Interval_Leading_Field_Precision> <Right_Paren> rank => 0
<Gen1952_maybe> ::= <Gen1952> rank => 0
<Gen1952_maybe> ::= rank => -1
<Start_Field> ::= <Non_Second_Primary_Datetime_Field> <Gen1952_maybe> rank => 0
<Gen1956> ::= <Left_Paren> <Interval_Fractional_Seconds_Precision> <Right_Paren> rank => 0
<Gen1956_maybe> ::= <Gen1956> rank => 0
<Gen1956_maybe> ::= rank => -1
<End_Field> ::= <Non_Second_Primary_Datetime_Field> rank => 0
              | <Lex478> <Gen1956_maybe> rank => -1
<Gen1961> ::= <Left_Paren> <Interval_Leading_Field_Precision> <Right_Paren> rank => 0
<Gen1961_maybe> ::= <Gen1961> rank => 0
<Gen1961_maybe> ::= rank => -1
<Gen1964> ::= <Comma> <Interval_Fractional_Seconds_Precision> rank => 0
<Gen1964_maybe> ::= <Gen1964> rank => 0
<Gen1964_maybe> ::= rank => -1
<Gen1967> ::= <Left_Paren> <Interval_Leading_Field_Precision> <Gen1964_maybe> <Right_Paren> rank => 0
<Gen1967_maybe> ::= <Gen1967> rank => 0
<Gen1967_maybe> ::= rank => -1
<Single_Datetime_Field> ::= <Non_Second_Primary_Datetime_Field> <Gen1961_maybe> rank => 0
                          | <Lex478> <Gen1967_maybe> rank => -1
<Primary_Datetime_Field> ::= <Non_Second_Primary_Datetime_Field> rank => 0
                           | <Lex478> rank => -1
<Non_Second_Primary_Datetime_Field> ::= <Lex532> rank => 0
                                      | <Lex419> rank => -1
                                      | <Lex343> rank => -2
                                      | <Lex386> rank => -3
                                      | <Lex416> rank => -4
<Interval_Fractional_Seconds_Precision> ::= <Unsigned_Integer> rank => 0
<Interval_Leading_Field_Precision> ::= <Unsigned_Integer> rank => 0
<Language_Clause> ::= <Lex403> <Language_Name> rank => 0
<Language_Name> ::= <Lex045> rank => 0
                  | <Lex058> rank => -1
                  | <Lex076> rank => -2
                  | <Lex134> rank => -3
                  | <Lex171> rank => -4
                  | <Lex200> rank => -5
                  | <Lex206> rank => -6
                  | <Lex488> rank => -7
<Path_Specification> ::= <Lex201> <Schema_Name_List> rank => 0
<Gen1991> ::= <Comma> <Schema_Name> rank => 0
<Gen1991_any> ::= <Gen1991>* rank => 0
<Schema_Name_List> ::= <Schema_Name> <Gen1991_any> rank => 0
<Routine_Invocation> ::= <Routine_Name> <SQL_Argument_List> rank => 0
<Gen1995> ::= <Schema_Name> <Period> rank => 0
<Gen1995_maybe> ::= <Gen1995> rank => 0
<Gen1995_maybe> ::= rank => -1
<Routine_Name> ::= <Gen1995_maybe> <Qualified_Identifier> rank => 0
<Gen1999> ::= <Comma> <SQL_Argument> rank => 0
<Gen1999_any> ::= <Gen1999>* rank => 0
<Gen2001> ::= <SQL_Argument> <Gen1999_any> rank => 0
<Gen2001_maybe> ::= <Gen2001> rank => 0
<Gen2001_maybe> ::= rank => -1
<SQL_Argument_List> ::= <Left_Paren> <Gen2001_maybe> <Right_Paren> rank => 0
<SQL_Argument> ::= <Value_Expression> rank => 0
                 | <Generalized_Expression> rank => -1
                 | <Target_Specification> rank => -2
<Generalized_Expression> ::= <Value_Expression> <Lex297> <Path_Resolved_User_Defined_Type_Name> rank => 0
<Character_Set_Specification> ::= <Standard_Character_Set_Name> rank => 0
                                | <Implementation_Defined_Character_Set_Name> rank => -1
                                | <User_Defined_Character_Set_Name> rank => -2
<Standard_Character_Set_Name> ::= <Character_Set_Name> rank => 0
<Implementation_Defined_Character_Set_Name> ::= <Character_Set_Name> rank => 0
<User_Defined_Character_Set_Name> ::= <Character_Set_Name> rank => 0
<Gen2015> ::= <Lex373> <Schema_Resolved_User_Defined_Type_Name> rank => 0
<Gen2015_maybe> ::= <Gen2015> rank => 0
<Gen2015_maybe> ::= rank => -1
<Specific_Routine_Designator> ::= <Lex486> <Routine_Type> <Specific_Name> rank => 0
                                | <Routine_Type> <Member_Name> <Gen2015_maybe> rank => -1
<Gen2020> ::= <Lex146> rank => 0
            | <Lex493> rank => -1
            | <Lex551> rank => -2
<Gen2020_maybe> ::= <Gen2020> rank => 0
<Gen2020_maybe> ::= rank => -1
<Routine_Type> ::= <Lex224> rank => 0
                 | <Lex378> rank => -1
                 | <Lex448> rank => -2
                 | <Gen2020_maybe> <Lex415> rank => -3
<Data_Type_List_maybe> ::= <Data_Type_List> rank => 0
<Data_Type_List_maybe> ::= rank => -1
<Member_Name> ::= <Member_Name_Alternatives> <Data_Type_List_maybe> rank => 0
<Member_Name_Alternatives> ::= <Schema_Qualified_Routine_Name> rank => 0
                             | <Method_Name> rank => -1
<Gen2034> ::= <Comma> <Data_Type> rank => 0
<Gen2034_any> ::= <Gen2034>* rank => 0
<Gen2036> ::= <Data_Type> <Gen2034_any> rank => 0
<Gen2036_maybe> ::= <Gen2036> rank => 0
<Gen2036_maybe> ::= rank => -1
<Data_Type_List> ::= <Left_Paren> <Gen2036_maybe> <Right_Paren> rank => 0
<Collate_Clause> ::= <Lex321> <Collation_Name> rank => 0
<Constraint_Name_Definition> ::= <Lex325> <Constraint_Name> rank => 0
<Gen2042> ::= <Lex428_maybe> <Lex108> rank => 0
<Gen2042_maybe> ::= <Gen2042> rank => 0
<Gen2042_maybe> ::= rank => -1
<Constraint_Check_Time_maybe> ::= <Constraint_Check_Time> rank => 0
<Constraint_Check_Time_maybe> ::= rank => -1
<Constraint_Characteristics> ::= <Constraint_Check_Time> <Gen2042_maybe> rank => 0
                               | <Lex428_maybe> <Lex108> <Constraint_Check_Time_maybe> rank => -1
<Constraint_Check_Time> ::= <Lex145> <Lex109> rank => 0
                          | <Lex145> <Lex388> rank => -1
<Filter_Clause_maybe> ::= <Filter_Clause> rank => 0
<Filter_Clause_maybe> ::= rank => -1
<Aggregate_Function> ::= <Lex098> <Left_Paren> <Asterisk> <Right_Paren> <Filter_Clause_maybe> rank => 0
                       | <General_Set_Function> <Filter_Clause_maybe> rank => -1
                       | <Binary_Set_Function> <Filter_Clause_maybe> rank => -2
                       | <Ordered_Set_Function> <Filter_Clause_maybe> rank => -3
<General_Set_Function> ::= <Set_Function_Type> <Left_Paren> <Set_Quantifier_maybe> <Value_Expression> <Right_Paren> rank => 0
<Set_Function_Type> ::= <Computational_Operation> rank => 0
<Computational_Operation> ::= <Lex054> rank => 0
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
<Set_Quantifier> ::= <Lex354> rank => 0
                   | <Lex290> rank => -1
<Filter_Clause> ::= <Lex371> <Left_Paren> <Lex526> <Search_Condition> <Right_Paren> rank => 0
<Binary_Set_Function> ::= <Binary_Set_Function_Type> <Left_Paren> <Dependent_Variable_Expression> <Comma> <Independent_Variable_Expression> <Right_Paren> rank => 0
<Binary_Set_Function_Type> ::= <Lex099> rank => 0
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
<Dependent_Variable_Expression> ::= <Numeric_Value_Expression> rank => 0
<Independent_Variable_Expression> ::= <Numeric_Value_Expression> rank => 0
<Ordered_Set_Function> ::= <Hypothetical_Set_Function> rank => 0
                         | <Inverse_Distribution_Function> rank => -1
<Hypothetical_Set_Function> ::= <Rank_Function_Type> <Left_Paren> <Hypothetical_Set_Function_Value_Expression_List> <Right_Paren> <Within_Group_Specification> rank => 0
<Within_Group_Specification> ::= <Lex530> <Lex382> <Left_Paren> <Lex437> <Lex310> <Sort_Specification_List> <Right_Paren> rank => 0
<Gen2096> ::= <Comma> <Value_Expression> rank => 0
<Gen2096_any> ::= <Gen2096>* rank => 0
<Hypothetical_Set_Function_Value_Expression_List> ::= <Value_Expression> <Gen2096_any> rank => 0
<Inverse_Distribution_Function> ::= <Inverse_Distribution_Function_Type> <Left_Paren> <Inverse_Distribution_Function_Argument> <Right_Paren> <Within_Group_Specification> rank => 0
<Inverse_Distribution_Function_Argument> ::= <Numeric_Value_Expression> rank => 0
<Inverse_Distribution_Function_Type> ::= <Lex202> rank => 0
                                       | <Lex203> rank => -1
<Gen2103> ::= <Comma> <Sort_Specification> rank => 0
<Gen2103_any> ::= <Gen2103>* rank => 0
<Sort_Specification_List> ::= <Sort_Specification> <Gen2103_any> rank => 0
<Ordering_Specification_maybe> ::= <Ordering_Specification> rank => 0
<Ordering_Specification_maybe> ::= rank => -1
<Null_Ordering_maybe> ::= <Null_Ordering> rank => 0
<Null_Ordering_maybe> ::= rank => -1
<Sort_Specification> ::= <Sort_Key> <Ordering_Specification_maybe> <Null_Ordering_maybe> rank => 0
<Sort_Key> ::= <Value_Expression> rank => 0
<Ordering_Specification> ::= <Lex049> rank => 0
                           | <Lex116> rank => -1
<Null_Ordering> ::= <Lex180> <Lex131> rank => 0
                  | <Lex180> <Lex154> rank => -1
<Schema_Character_Set_Or_Path_maybe> ::= <Schema_Character_Set_Or_Path> rank => 0
<Schema_Character_Set_Or_Path_maybe> ::= rank => -1
<Schema_Element_any> ::= <Schema_Element>* rank => 0
<Schema_Definition> ::= <Lex328> <Lex231> <Schema_Name_Clause> <Schema_Character_Set_Or_Path_maybe> <Schema_Element_any> rank => 0
<Schema_Character_Set_Or_Path> ::= <Schema_Character_Set_Specification> rank => 0
                                 | <Schema_Path_Specification> rank => -1
                                 | <Schema_Character_Set_Specification> <Schema_Path_Specification> rank => -2
                                 | <Schema_Path_Specification> <Schema_Character_Set_Specification> rank => -3
<Schema_Name_Clause> ::= <Schema_Name> rank => 0
                       | <Lex302> <Schema_Authorization_Identifier> rank => -1
                       | <Schema_Name> <Lex302> <Schema_Authorization_Identifier> rank => -2
<Schema_Authorization_Identifier> ::= <Authorization_Identifier> rank => 0
<Schema_Character_Set_Specification> ::= <Lex348> <Lex317> <Lex482> <Character_Set_Specification> rank => 0
<Schema_Path_Specification> ::= <Path_Specification> rank => 0
<Schema_Element> ::= <Table_Definition> rank => 0
                   | <View_Definition> rank => -1
                   | <Domain_Definition> rank => -2
                   | <Character_Set_Definition> rank => -3
                   | <Collation_Definition> rank => -4
                   | <Transliteration_Definition> rank => -5
                   | <Assertion_Definition> rank => -6
                   | <Trigger_Definition> rank => -7
                   | <User_Defined_Type_Definition> rank => -8
                   | <User_Defined_Cast_Definition> rank => -9
                   | <User_Defined_Ordering_Definition> rank => -10
                   | <Transform_Definition> rank => -11
                   | <Schema_Routine> rank => -12
                   | <Sequence_Generator_Definition> rank => -13
                   | <Grant_Statement> rank => -14
                   | <Role_Definition> rank => -15
<Drop_Schema_Statement> ::= <Lex356> <Lex231> <Schema_Name> <Drop_Behavior> rank => 0
<Drop_Behavior> ::= <Lex060> rank => 0
                  | <Lex552> rank => -1
<Table_Scope_maybe> ::= <Table_Scope> rank => 0
<Table_Scope_maybe> ::= rank => -1
<Gen2151> ::= <Lex433> <Lex323> <Table_Commit_Action> <Lex474> rank => 0
<Gen2151_maybe> ::= <Gen2151> rank => 0
<Gen2151_maybe> ::= rank => -1
<Table_Definition> ::= <Lex328> <Table_Scope_maybe> <Lex498> <Table_Name> <Table_Contents_Source> <Gen2151_maybe> rank => 0
<Subtable_Clause_maybe> ::= <Subtable_Clause> rank => 0
<Subtable_Clause_maybe> ::= rank => -1
<Table_Element_List_maybe> ::= <Table_Element_List> rank => 0
<Table_Element_List_maybe> ::= rank => -1
<Table_Contents_Source> ::= <Table_Element_List> rank => 0
                          | <Lex431> <Path_Resolved_User_Defined_Type_Name> <Subtable_Clause_maybe> <Table_Element_List_maybe> rank => -1
                          | <As_Subquery_Clause> rank => -2
<Table_Scope> ::= <Global_Or_Local> <Lex261> rank => 0
<Global_Or_Local> ::= <Lex380> rank => 0
                    | <Lex409> rank => -1
<Table_Commit_Action> ::= <Lex210> rank => 0
                        | <Lex349> rank => -1
<Gen2167> ::= <Comma> <Table_Element> rank => 0
<Gen2167_any> ::= <Gen2167>* rank => 0
<Table_Element_List> ::= <Left_Paren> <Table_Element> <Gen2167_any> <Right_Paren> rank => 0
<Table_Element> ::= <Column_Definition> rank => 0
                  | <Table_Constraint_Definition> rank => -1
                  | <Like_Clause> rank => -2
                  | <Self_Referencing_Column_Specification> rank => -3
                  | <Column_Options> rank => -4
<Self_Referencing_Column_Specification> ::= <Lex453> <Lex401> <Self_Referencing_Column_Name> <Reference_Generation> rank => 0
<Reference_Generation> ::= <Lex496> <Lex553> rank => 0
                         | <Lex516> <Lex553> rank => -1
                         | <Lex115> rank => -2
<Self_Referencing_Column_Name> ::= <Column_Name> rank => 0
<Column_Options> ::= <Column_Name> <Lex529> <Lex186> <Column_Option_List> rank => 0
<Default_Clause_maybe> ::= <Default_Clause> rank => 0
<Default_Clause_maybe> ::= rank => -1
<Column_Constraint_Definition_any> ::= <Column_Constraint_Definition>* rank => 0
<Column_Option_List> ::= <Scope_Clause_maybe> <Default_Clause_maybe> <Column_Constraint_Definition_any> rank => 0
<Subtable_Clause> ::= <Lex278> <Supertable_Clause> rank => 0
<Supertable_Clause> ::= <Supertable_Name> rank => 0
<Supertable_Name> ::= <Table_Name> rank => 0
<Like_Options_maybe> ::= <Like_Options> rank => 0
<Like_Options_maybe> ::= rank => -1
<Like_Clause> ::= <Lex408> <Table_Name> <Like_Options_maybe> rank => 0
<Like_Options> ::= <Identity_Option> rank => 0
                 | <Column_Default_Option> rank => -1
<Identity_Option> ::= <Lex143> <Lex387> rank => 0
                    | <Lex127> <Lex387> rank => -1
<Column_Default_Option> ::= <Lex143> <Lex107> rank => 0
                          | <Lex127> <Lex107> rank => -1
<Gen2197> ::= <Left_Paren> <Column_Name_List> <Right_Paren> rank => 0
<Gen2197_maybe> ::= <Gen2197> rank => 0
<Gen2197_maybe> ::= rank => -1
<As_Subquery_Clause> ::= <Gen2197_maybe> <Lex297> <Subquery> <With_Or_Without_Data> rank => 0
<With_Or_Without_Data> ::= <Lex529> <Lex426> <Lex104> rank => 0
                         | <Lex529> <Lex104> rank => -1
<Gen2203> ::= <Data_Type> rank => 0
            | <Domain_Name> rank => -1
<Gen2203_maybe> ::= <Gen2203> rank => 0
<Gen2203_maybe> ::= rank => -1
<Gen2207> ::= <Default_Clause> rank => 0
            | <Identity_Column_Specification> rank => -1
            | <Generation_Clause> rank => -2
<Gen2207_maybe> ::= <Gen2207> rank => 0
<Gen2207_maybe> ::= rank => -1
<Column_Definition> ::= <Column_Name> <Gen2203_maybe> <Reference_Scope_Check_maybe> <Gen2207_maybe> <Column_Constraint_Definition_any> <Collate_Clause_maybe> rank => 0
<Constraint_Name_Definition_maybe> ::= <Constraint_Name_Definition> rank => 0
<Constraint_Name_Definition_maybe> ::= rank => -1
<Constraint_Characteristics_maybe> ::= <Constraint_Characteristics> rank => 0
<Constraint_Characteristics_maybe> ::= rank => -1
<Column_Constraint_Definition> ::= <Constraint_Name_Definition_maybe> <Column_Constraint> <Constraint_Characteristics_maybe> rank => 0
<Column_Constraint> ::= <Lex428> <Lex429> rank => 0
                      | <Unique_Specification> rank => -1
                      | <References_Specification> rank => -2
                      | <Check_Constraint_Definition> rank => -3
<Gen2222> ::= <Lex433> <Lex349> <Reference_Scope_Check_Action> rank => 0
<Gen2222_maybe> ::= <Gen2222> rank => 0
<Gen2222_maybe> ::= rank => -1
<Reference_Scope_Check> ::= <Lex454> <Lex295> <Lex428_maybe> <Lex073> <Gen2222_maybe> rank => 0
<Reference_Scope_Check_Action> ::= <Referential_Action> rank => 0
<Gen2227> ::= <Lex048> rank => 0
            | <Lex310> <Lex348> rank => -1
<Gen2229> ::= <Left_Paren> <Common_Sequence_Generator_Options> <Right_Paren> rank => 0
<Gen2229_maybe> ::= <Gen2229> rank => 0
<Gen2229_maybe> ::= rank => -1
<Identity_Column_Specification> ::= <Lex553> <Gen2227> <Lex297> <Lex387> <Gen2229_maybe> rank => 0
<Generation_Clause> ::= <Generation_Rule> <Lex297> <Generation_Expression> rank => 0
<Generation_Rule> ::= <Lex553> <Lex048> rank => 0
<Generation_Expression> ::= <Left_Paren> <Value_Expression> <Right_Paren> rank => 0
<Default_Clause> ::= <Lex348> <Default_Option> rank => 0
<Default_Option> ::= <Literal> rank => 0
                   | <Datetime_Value_Function> rank => -1
                   | <Lex516> rank => -2
                   | <Lex339> rank => -3
                   | <Lex335> rank => -4
                   | <Lex481> rank => -5
                   | <Lex497> rank => -6
                   | <Lex334> rank => -7
                   | <Implicitly_Typed_Value_Specification> rank => -8
<Table_Constraint_Definition> ::= <Constraint_Name_Definition_maybe> <Table_Constraint> <Constraint_Characteristics_maybe> rank => 0
<Table_Constraint> ::= <Unique_Constraint_Definition> rank => 0
                     | <Referential_Constraint_Definition> rank => -1
                     | <Check_Constraint_Definition> rank => -2
<Gen2250> ::= <Lex518> rank => 0
<Unique_Constraint_Definition> ::= <Unique_Specification> <Left_Paren> <Unique_Column_List> <Right_Paren> rank => 0
                                 | <Lex511> <Gen2250> rank => -1
<Unique_Specification> ::= <Lex511> rank => 0
                         | <Lex447> <Lex151> rank => -1
<Unique_Column_List> ::= <Column_Name_List> rank => 0
<Referential_Constraint_Definition> ::= <Lex374> <Lex151> <Left_Paren> <Referencing_Columns> <Right_Paren> <References_Specification> rank => 0
<Gen2257> ::= <Lex412> <Match_Type> rank => 0
<Gen2257_maybe> ::= <Gen2257> rank => 0
<Gen2257_maybe> ::= rank => -1
<Referential_Triggered_Action_maybe> ::= <Referential_Triggered_Action> rank => 0
<Referential_Triggered_Action_maybe> ::= rank => -1
<References_Specification> ::= <Lex454> <Referenced_Table_And_Columns> <Gen2257_maybe> <Referential_Triggered_Action_maybe> rank => 0
<Match_Type> ::= <Lex377> rank => 0
               | <Lex199> rank => -1
               | <Lex244> rank => -2
<Referencing_Columns> ::= <Reference_Column_List> rank => 0
<Gen2267> ::= <Left_Paren> <Reference_Column_List> <Right_Paren> rank => 0
<Gen2267_maybe> ::= <Gen2267> rank => 0
<Gen2267_maybe> ::= rank => -1
<Referenced_Table_And_Columns> ::= <Table_Name> <Gen2267_maybe> rank => 0
<Reference_Column_List> ::= <Column_Name_List> rank => 0
<Delete_Rule_maybe> ::= <Delete_Rule> rank => 0
<Delete_Rule_maybe> ::= rank => -1
<Update_Rule_maybe> ::= <Update_Rule> rank => 0
<Update_Rule_maybe> ::= rank => -1
<Referential_Triggered_Action> ::= <Update_Rule> <Delete_Rule_maybe> rank => 0
                                 | <Delete_Rule> <Update_Rule_maybe> rank => -1
<Update_Rule> ::= <Lex433> <Lex514> <Referential_Action> rank => 0
<Delete_Rule> ::= <Lex433> <Lex349> <Referential_Action> rank => 0
<Referential_Action> ::= <Lex060> rank => 0
                       | <Lex482> <Lex429> rank => -1
                       | <Lex482> <Lex348> rank => -2
                       | <Lex552> rank => -3
                       | <Lex426> <Lex044> rank => -4
<Check_Constraint_Definition> ::= <Lex318> <Left_Paren> <Search_Condition> <Right_Paren> rank => 0
<Alter_Table_Statement> ::= <Lex292> <Lex498> <Table_Name> <Alter_Table_Action> rank => 0
<Alter_Table_Action> ::= <Add_Column_Definition> rank => 0
                       | <Alter_Column_Definition> rank => -1
                       | <Drop_Column_Definition> rank => -2
                       | <Add_Table_Constraint_Definition> rank => -3
                       | <Drop_Table_Constraint_Definition> rank => -4
<Lex322_maybe> ::= <Lex322> rank => 0
<Lex322_maybe> ::= rank => -1
<Add_Column_Definition> ::= <Lex289> <Lex322_maybe> <Column_Definition> rank => 0
<Alter_Column_Definition> ::= <Lex292> <Lex322_maybe> <Column_Name> <Alter_Column_Action> rank => 0
<Alter_Column_Action> ::= <Set_Column_Default_Clause> rank => 0
                        | <Drop_Column_Default_Clause> rank => -1
                        | <Add_Column_Scope_Clause> rank => -2
                        | <Drop_Column_Scope_Clause> rank => -3
                        | <Alter_Identity_Column_Specification> rank => -4
<Set_Column_Default_Clause> ::= <Lex482> <Default_Clause> rank => 0
<Drop_Column_Default_Clause> ::= <Lex356> <Lex348> rank => 0
<Add_Column_Scope_Clause> ::= <Lex289> <Scope_Clause> rank => 0
<Drop_Column_Scope_Clause> ::= <Lex356> <Lex547> <Drop_Behavior> rank => 0
<Alter_Identity_Column_Option_many> ::= <Alter_Identity_Column_Option>+ rank => 0
<Alter_Identity_Column_Specification> ::= <Alter_Identity_Column_Option_many> rank => 0
<Alter_Identity_Column_Option> ::= <Alter_Sequence_Generator_Restart_Option> rank => 0
                                 | <Lex482> <Basic_Sequence_Generator_Option> rank => -1
<Drop_Column_Definition> ::= <Lex356> <Lex322_maybe> <Column_Name> <Drop_Behavior> rank => 0
<Add_Table_Constraint_Definition> ::= <Lex289> <Table_Constraint_Definition> rank => 0
<Drop_Table_Constraint_Definition> ::= <Lex356> <Lex325> <Constraint_Name> <Drop_Behavior> rank => 0
<Drop_Table_Statement> ::= <Lex356> <Lex498> <Table_Name> <Drop_Behavior> rank => 0
<Levels_Clause_maybe> ::= <Levels_Clause> rank => 0
<Levels_Clause_maybe> ::= rank => -1
<Gen2315> ::= <Lex529> <Levels_Clause_maybe> <Lex318> <Lex185> rank => 0
<Gen2315_maybe> ::= <Gen2315> rank => 0
<Gen2315_maybe> ::= rank => -1
<View_Definition> ::= <Lex328> <Lex452_maybe> <Lex285> <Table_Name> <View_Specification> <Lex297> <Query_Expression> <Gen2315_maybe> rank => 0
<View_Specification> ::= <Regular_View_Specification> rank => 0
                       | <Referenceable_View_Specification> rank => -1
<Gen2321> ::= <Left_Paren> <View_Column_List> <Right_Paren> rank => 0
<Gen2321_maybe> ::= <Gen2321> rank => 0
<Gen2321_maybe> ::= rank => -1
<Regular_View_Specification> ::= <Gen2321_maybe> rank => 0
<Subview_Clause_maybe> ::= <Subview_Clause> rank => 0
<Subview_Clause_maybe> ::= rank => -1
<View_Element_List_maybe> ::= <View_Element_List> rank => 0
<View_Element_List_maybe> ::= rank => -1
<Referenceable_View_Specification> ::= <Lex431> <Path_Resolved_User_Defined_Type_Name> <Subview_Clause_maybe> <View_Element_List_maybe> rank => 0
<Subview_Clause> ::= <Lex278> <Table_Name> rank => 0
<Gen2331> ::= <Comma> <View_Element> rank => 0
<Gen2331_any> ::= <Gen2331>* rank => 0
<View_Element_List> ::= <Left_Paren> <View_Element> <Gen2331_any> <Right_Paren> rank => 0
<View_Element> ::= <Self_Referencing_Column_Specification> rank => 0
                 | <View_Column_Option> rank => -1
<View_Column_Option> ::= <Column_Name> <Lex529> <Lex186> <Scope_Clause> rank => 0
<Levels_Clause> ::= <Lex313> rank => 0
                  | <Lex409> rank => -1
<View_Column_List> ::= <Column_Name_List> rank => 0
<Drop_View_Statement> ::= <Lex356> <Lex285> <Table_Name> <Drop_Behavior> rank => 0
<Domain_Constraint_any> ::= <Domain_Constraint>* rank => 0
<Domain_Definition> ::= <Lex328> <Lex120> <Domain_Name> <Lex297_maybe> <Data_Type> <Default_Clause_maybe> <Domain_Constraint_any> <Collate_Clause_maybe> rank => 0
<Domain_Constraint> ::= <Constraint_Name_Definition_maybe> <Check_Constraint_Definition> <Constraint_Characteristics_maybe> rank => 0
<Alter_Domain_Statement> ::= <Lex292> <Lex120> <Domain_Name> <Alter_Domain_Action> rank => 0
<Alter_Domain_Action> ::= <Set_Domain_Default_Clause> rank => 0
                        | <Drop_Domain_Default_Clause> rank => -1
                        | <Add_Domain_Constraint_Definition> rank => -2
                        | <Drop_Domain_Constraint_Definition> rank => -3
<Set_Domain_Default_Clause> ::= <Lex482> <Default_Clause> rank => 0
<Drop_Domain_Default_Clause> ::= <Lex356> <Lex348> rank => 0
<Add_Domain_Constraint_Definition> ::= <Lex289> <Domain_Constraint> rank => 0
<Drop_Domain_Constraint_Definition> ::= <Lex356> <Lex325> <Constraint_Name> rank => 0
<Drop_Domain_Statement> ::= <Lex356> <Lex120> <Domain_Name> <Drop_Behavior> rank => 0
<Character_Set_Definition> ::= <Lex328> <Lex317> <Lex482> <Character_Set_Name> <Lex297_maybe> <Character_Set_Source> <Collate_Clause_maybe> rank => 0
<Character_Set_Source> ::= <Lex379> <Character_Set_Specification> rank => 0
<Drop_Character_Set_Statement> ::= <Lex356> <Lex317> <Lex482> <Character_Set_Name> rank => 0
<Pad_Characteristic_maybe> ::= <Pad_Characteristic> rank => 0
<Pad_Characteristic_maybe> ::= rank => -1
<Collation_Definition> ::= <Lex328> <Lex078> <Collation_Name> <Lex373> <Character_Set_Specification> <Lex376> <Existing_Collation_Name> <Pad_Characteristic_maybe> rank => 0
<Existing_Collation_Name> ::= <Collation_Name> rank => 0
<Pad_Characteristic> ::= <Lex426> <Lex192> rank => 0
                       | <Lex192> <Lex247> rank => -1
<Drop_Collation_Statement> ::= <Lex356> <Lex078> <Collation_Name> <Drop_Behavior> rank => 0
<Transliteration_Definition> ::= <Lex328> <Lex506> <Transliteration_Name> <Lex373> <Source_Character_Set_Specification> <Lex504> <Target_Character_Set_Specification> <Lex376> <Transliteration_Source> rank => 0
<Source_Character_Set_Specification> ::= <Character_Set_Specification> rank => 0
<Target_Character_Set_Specification> ::= <Character_Set_Specification> rank => 0
<Transliteration_Source> ::= <Existing_Transliteration_Name> rank => 0
                           | <Transliteration_Routine> rank => -1
<Existing_Transliteration_Name> ::= <Transliteration_Name> rank => 0
<Transliteration_Routine> ::= <Specific_Routine_Designator> rank => 0
<Drop_Transliteration_Statement> ::= <Lex356> <Lex506> <Transliteration_Name> rank => 0
<Assertion_Definition> ::= <Lex328> <Lex050> <Constraint_Name> <Lex318> <Left_Paren> <Search_Condition> <Right_Paren> <Constraint_Characteristics_maybe> rank => 0
<Drop_Assertion_Statement> ::= <Lex356> <Lex050> <Constraint_Name> rank => 0
<Gen2374> ::= <Lex455> <Old_Or_New_Values_Alias_List> rank => 0
<Gen2374_maybe> ::= <Gen2374> rank => 0
<Gen2374_maybe> ::= rank => -1
<Trigger_Definition> ::= <Lex328> <Lex508> <Trigger_Name> <Trigger_Action_Time> <Trigger_Event> <Lex433> <Table_Name> <Gen2374_maybe> <Triggered_Action> rank => 0
<Trigger_Action_Time> ::= <Lex055> rank => 0
                        | <Lex047> rank => -1
<Gen2380> ::= <Lex431> <Trigger_Column_List> rank => 0
<Gen2380_maybe> ::= <Gen2380> rank => 0
<Gen2380_maybe> ::= rank => -1
<Trigger_Event> ::= <Lex395> rank => 0
                  | <Lex349> rank => -1
                  | <Lex514> <Gen2380_maybe> rank => -2
<Trigger_Column_List> ::= <Column_Name_List> rank => 0
<Gen2387> ::= <Lex473> rank => 0
            | <Lex251> rank => -1
<Gen2389> ::= <Lex373> <Lex358> <Gen2387> rank => 0
<Gen2389_maybe> ::= <Gen2389> rank => 0
<Gen2389_maybe> ::= rank => -1
<Gen2392> ::= <Lex524> <Left_Paren> <Search_Condition> <Right_Paren> rank => 0
<Gen2392_maybe> ::= <Gen2392> rank => 0
<Gen2392_maybe> ::= rank => -1
<Triggered_Action> ::= <Gen2389_maybe> <Gen2392_maybe> <Triggered_SQL_Statement> rank => 0
<Gen2396> ::= <SQL_Procedure_Statement> <Semicolon> rank => 0
<Gen2396_many> ::= <Gen2396>+ rank => 0
<Triggered_SQL_Statement> ::= <SQL_Procedure_Statement> rank => 0
                            | <Lex303> <Lex301> <Gen2396_many> <Lex361> rank => -1
<Old_Or_New_Values_Alias_many> ::= <Old_Or_New_Values_Alias>+ rank => 0
<Old_Or_New_Values_Alias_List> ::= <Old_Or_New_Values_Alias_many> rank => 0
<Lex473_maybe> ::= <Lex473> rank => 0
<Lex473_maybe> ::= rank => -1
<Old_Or_New_Values_Alias> ::= <Lex432> <Lex473_maybe> <Lex297_maybe> <Old_Values_Correlation_Name> rank => 0
                            | <Lex425> <Lex473_maybe> <Lex297_maybe> <New_Values_Correlation_Name> rank => -1
                            | <Lex432> <Lex498> <Lex297_maybe> <Old_Values_Table_Alias> rank => -2
                            | <Lex425> <Lex498> <Lex297_maybe> <New_Values_Table_Alias> rank => -3
<Old_Values_Table_Alias> ::= <Identifier> rank => 0
<New_Values_Table_Alias> ::= <Identifier> rank => 0
<Old_Values_Correlation_Name> ::= <Correlation_Name> rank => 0
<New_Values_Correlation_Name> ::= <Correlation_Name> rank => 0
<Drop_Trigger_Statement> ::= <Lex356> <Lex508> <Trigger_Name> rank => 0
<User_Defined_Type_Definition> ::= <Lex328> <Lex275> <User_Defined_Type_Body> rank => 0
<Subtype_Clause_maybe> ::= <Subtype_Clause> rank => 0
<Subtype_Clause_maybe> ::= rank => -1
<Gen2416> ::= <Lex297> <Representation> rank => 0
<Gen2416_maybe> ::= <Gen2416> rank => 0
<Gen2416_maybe> ::= rank => -1
<User_Defined_Type_Option_List_maybe> ::= <User_Defined_Type_Option_List> rank => 0
<User_Defined_Type_Option_List_maybe> ::= rank => -1
<Method_Specification_List_maybe> ::= <Method_Specification_List> rank => 0
<Method_Specification_List_maybe> ::= rank => -1
<User_Defined_Type_Body> ::= <Schema_Resolved_User_Defined_Type_Name> <Subtype_Clause_maybe> <Gen2416_maybe> <User_Defined_Type_Option_List_maybe> <Method_Specification_List_maybe> rank => 0
<User_Defined_Type_Option_any> ::= <User_Defined_Type_Option>* rank => 0
<User_Defined_Type_Option_List> ::= <User_Defined_Type_Option> <User_Defined_Type_Option_any> rank => 0
<User_Defined_Type_Option> ::= <Instantiable_Clause> rank => 0
                             | <Finality> rank => -1
                             | <Reference_Type_Specification> rank => -2
                             | <Ref_Cast_Option> rank => -3
                             | <Cast_Option> rank => -4
<Subtype_Clause> ::= <Lex278> <Supertype_Name> rank => 0
<Supertype_Name> ::= <Path_Resolved_User_Defined_Type_Name> rank => 0
<Representation> ::= <Predefined_Type> rank => 0
                   | <Member_List> rank => -1
<Gen2435> ::= <Comma> <Member> rank => 0
<Gen2435_any> ::= <Gen2435>* rank => 0
<Member_List> ::= <Left_Paren> <Member> <Gen2435_any> <Right_Paren> rank => 0
<Member> ::= <Attribute_Definition> rank => 0
<Instantiable_Clause> ::= <Lex147> rank => 0
                        | <Lex428> <Lex147> rank => -1
<Finality> ::= <Lex130> rank => 0
             | <Lex428> <Lex130> rank => -1
<Reference_Type_Specification> ::= <User_Defined_Representation> rank => 0
                                 | <Derived_Representation> rank => -1
                                 | <System_Generated_Representation> rank => -2
<User_Defined_Representation> ::= <Lex453> <Lex517> <Predefined_Type> rank => 0
<Derived_Representation> ::= <Lex453> <Lex376> <List_Of_Attributes> rank => 0
<System_Generated_Representation> ::= <Lex453> <Lex401> <Lex496> <Lex553> rank => 0
<Cast_To_Type_maybe> ::= <Cast_To_Type> rank => 0
<Cast_To_Type_maybe> ::= rank => -1
<Ref_Cast_Option> ::= <Cast_To_Ref> <Cast_To_Type_maybe> rank => 0
                    | <Cast_To_Type> rank => -1
<Cast_To_Ref> ::= <Lex315> <Left_Paren> <Lex246> <Lex297> <Lex453> <Right_Paren> <Lex529> <Cast_To_Ref_Identifier> rank => 0
<Cast_To_Ref_Identifier> ::= <Identifier> rank => 0
<Cast_To_Type> ::= <Lex315> <Left_Paren> <Lex453> <Lex297> <Lex246> <Right_Paren> <Lex529> <Cast_To_Type_Identifier> rank => 0
<Cast_To_Type_Identifier> ::= <Identifier> rank => 0
<Gen2457> ::= <Comma> <Attribute_Name> rank => 0
<Gen2457_any> ::= <Gen2457>* rank => 0
<List_Of_Attributes> ::= <Left_Paren> <Attribute_Name> <Gen2457_any> <Right_Paren> rank => 0
<Cast_To_Distinct_maybe> ::= <Cast_To_Distinct> rank => 0
<Cast_To_Distinct_maybe> ::= rank => -1
<Cast_Option> ::= <Cast_To_Distinct_maybe> <Cast_To_Source> rank => 0
                | <Cast_To_Source> rank => -1
<Cast_To_Distinct> ::= <Lex315> <Left_Paren> <Lex246> <Lex297> <Lex354> <Right_Paren> <Lex529> <Cast_To_Distinct_Identifier> rank => 0
<Cast_To_Distinct_Identifier> ::= <Identifier> rank => 0
<Cast_To_Source> ::= <Lex315> <Left_Paren> <Lex354> <Lex297> <Lex246> <Right_Paren> <Lex529> <Cast_To_Source_Identifier> rank => 0
<Cast_To_Source_Identifier> ::= <Identifier> rank => 0
<Gen2468> ::= <Comma> <Method_Specification> rank => 0
<Gen2468_any> ::= <Gen2468>* rank => 0
<Method_Specification_List> ::= <Method_Specification> <Gen2468_any> rank => 0
<Method_Specification> ::= <Original_Method_Specification> rank => 0
                         | <Overriding_Method_Specification> rank => -1
<Gen2473> ::= <Lex238> <Lex297> <Lex466> rank => 0
<Gen2473_maybe> ::= <Gen2473> rank => 0
<Gen2473_maybe> ::= rank => -1
<Gen2476> ::= <Lex238> <Lex297> <Lex158> rank => 0
<Gen2476_maybe> ::= <Gen2476> rank => 0
<Gen2476_maybe> ::= rank => -1
<Method_Characteristics_maybe> ::= <Method_Characteristics> rank => 0
<Method_Characteristics_maybe> ::= rank => -1
<Original_Method_Specification> ::= <Partial_Method_Specification> <Gen2473_maybe> <Gen2476_maybe> <Method_Characteristics_maybe> rank => 0
<Overriding_Method_Specification> ::= <Lex191> <Partial_Method_Specification> rank => 0
<Gen2483> ::= <Lex146> rank => 0
            | <Lex493> rank => -1
            | <Lex551> rank => -2
<Gen2483_maybe> ::= <Gen2483> rank => 0
<Gen2483_maybe> ::= rank => -1
<Gen2488> ::= <Lex486> <Specific_Method_Name> rank => 0
<Gen2488_maybe> ::= <Gen2488> rank => 0
<Gen2488_maybe> ::= rank => -1
<Partial_Method_Specification> ::= <Gen2483_maybe> <Lex415> <Method_Name> <SQL_Parameter_Declaration_List> <Returns_Clause> <Gen2488_maybe> rank => 0
<Gen2492> ::= <Schema_Name> <Period> rank => 0
<Gen2492_maybe> ::= <Gen2492> rank => 0
<Gen2492_maybe> ::= rank => -1
<Specific_Method_Name> ::= <Gen2492_maybe> <Qualified_Identifier> rank => 0
<Method_Characteristic_many> ::= <Method_Characteristic>+ rank => 0
<Method_Characteristics> ::= <Method_Characteristic_many> rank => 0
<Method_Characteristic> ::= <Language_Clause> rank => 0
                          | <Parameter_Style_Clause> rank => -1
                          | <Deterministic_Characteristic> rank => -2
                          | <SQL_Data_Access_Indication> rank => -3
                          | <Null_Call_Clause> rank => -4
<Attribute_Default_maybe> ::= <Attribute_Default> rank => 0
<Attribute_Default_maybe> ::= rank => -1
<Attribute_Definition> ::= <Attribute_Name> <Data_Type> <Reference_Scope_Check_maybe> <Attribute_Default_maybe> <Collate_Clause_maybe> rank => 0
<Attribute_Default> ::= <Default_Clause> rank => 0
<Alter_Type_Statement> ::= <Lex292> <Lex275> <Schema_Resolved_User_Defined_Type_Name> <Alter_Type_Action> rank => 0
<Alter_Type_Action> ::= <Add_Attribute_Definition> rank => 0
                      | <Drop_Attribute_Definition> rank => -1
                      | <Add_Original_Method_Specification> rank => -2
                      | <Add_Overriding_Method_Specification> rank => -3
                      | <Drop_Method_Specification> rank => -4
<Add_Attribute_Definition> ::= <Lex289> <Lex052> <Attribute_Definition> rank => 0
<Drop_Attribute_Definition> ::= <Lex356> <Lex052> <Attribute_Name> <Lex552> rank => 0
<Add_Original_Method_Specification> ::= <Lex289> <Original_Method_Specification> rank => 0
<Add_Overriding_Method_Specification> ::= <Lex289> <Overriding_Method_Specification> rank => 0
<Drop_Method_Specification> ::= <Lex356> <Specific_Method_Specification_Designator> <Lex552> rank => 0
<Gen2518> ::= <Lex146> rank => 0
            | <Lex493> rank => -1
            | <Lex551> rank => -2
<Gen2518_maybe> ::= <Gen2518> rank => 0
<Gen2518_maybe> ::= rank => -1
<Specific_Method_Specification_Designator> ::= <Gen2518_maybe> <Lex415> <Method_Name> <Data_Type_List> rank => 0
<Drop_Data_Type_Statement> ::= <Lex356> <Lex275> <Schema_Resolved_User_Defined_Type_Name> <Drop_Behavior> rank => 0
<SQL_Invoked_Routine> ::= <Schema_Routine> rank => 0
<Schema_Routine> ::= <Schema_Procedure> rank => 0
                   | <Schema_Function> rank => -1
<Schema_Procedure> ::= <Lex328> <SQL_Invoked_Procedure> rank => 0
<Schema_Function> ::= <Lex328> <SQL_Invoked_Function> rank => 0
<SQL_Invoked_Procedure> ::= <Lex448> <Schema_Qualified_Routine_Name> <SQL_Parameter_Declaration_List> <Routine_Characteristics> <Routine_Body> rank => 0
<Gen2531> ::= <Function_Specification> rank => 0
            | <Method_Specification_Designator> rank => -1
<SQL_Invoked_Function> ::= <Gen2531> <Routine_Body> rank => 0
<Gen2534> ::= <Comma> <SQL_Parameter_Declaration> rank => 0
<Gen2534_any> ::= <Gen2534>* rank => 0
<Gen2536> ::= <SQL_Parameter_Declaration> <Gen2534_any> rank => 0
<Gen2536_maybe> ::= <Gen2536> rank => 0
<Gen2536_maybe> ::= rank => -1
<SQL_Parameter_Declaration_List> ::= <Left_Paren> <Gen2536_maybe> <Right_Paren> rank => 0
<Parameter_Mode_maybe> ::= <Parameter_Mode> rank => 0
<Parameter_Mode_maybe> ::= rank => -1
<SQL_Parameter_Name_maybe> ::= <SQL_Parameter_Name> rank => 0
<SQL_Parameter_Name_maybe> ::= rank => -1
<Lex466_maybe> ::= <Lex466> rank => 0
<Lex466_maybe> ::= rank => -1
<SQL_Parameter_Declaration> ::= <Parameter_Mode_maybe> <SQL_Parameter_Name_maybe> <Parameter_Type> <Lex466_maybe> rank => 0
<Parameter_Mode> ::= <Lex389> rank => 0
                   | <Lex438> rank => -1
                   | <Lex392> rank => -2
<Locator_Indication_maybe> ::= <Locator_Indication> rank => 0
<Locator_Indication_maybe> ::= rank => -1
<Parameter_Type> ::= <Data_Type> <Locator_Indication_maybe> rank => 0
<Locator_Indication> ::= <Lex297> <Lex158> rank => 0
<Dispatch_Clause_maybe> ::= <Dispatch_Clause> rank => 0
<Dispatch_Clause_maybe> ::= rank => -1
<Function_Specification> ::= <Lex378> <Schema_Qualified_Routine_Name> <SQL_Parameter_Declaration_List> <Returns_Clause> <Routine_Characteristics> <Dispatch_Clause_maybe> rank => 0
<Gen2557> ::= <Lex146> rank => 0
            | <Lex493> rank => -1
            | <Lex551> rank => -2
<Gen2557_maybe> ::= <Gen2557> rank => 0
<Gen2557_maybe> ::= rank => -1
<Returns_Clause_maybe> ::= <Returns_Clause> rank => 0
<Returns_Clause_maybe> ::= rank => -1
<Method_Specification_Designator> ::= <Lex486> <Lex415> <Specific_Method_Name> rank => 0
                                    | <Gen2557_maybe> <Lex415> <Method_Name> <SQL_Parameter_Declaration_List> <Returns_Clause_maybe> <Lex373> <Schema_Resolved_User_Defined_Type_Name> rank => -1
<Routine_Characteristic_any> ::= <Routine_Characteristic>* rank => 0
<Routine_Characteristics> ::= <Routine_Characteristic_any> rank => 0
<Routine_Characteristic> ::= <Language_Clause> rank => 0
                           | <Parameter_Style_Clause> rank => -1
                           | <Lex486> <Specific_Name> rank => -2
                           | <Deterministic_Characteristic> rank => -3
                           | <SQL_Data_Access_Indication> rank => -4
                           | <Null_Call_Clause> rank => -5
                           | <Dynamic_Result_Sets_Characteristic> rank => -6
                           | <Savepoint_Level_Indication> rank => -7
<Savepoint_Level_Indication> ::= <Lex425> <Lex475> <Lex156> rank => 0
                               | <Lex432> <Lex475> <Lex156> rank => -1
<Dynamic_Result_Sets_Characteristic> ::= <Lex357> <Lex466> <Lex243> <Maximum_Dynamic_Result_Sets> rank => 0
<Parameter_Style_Clause> ::= <Lex443> <Lex255> <Parameter_Style> rank => 0
<Dispatch_Clause> ::= <Lex493> <Lex119> rank => 0
<Returns_Clause> ::= <Lex468> <Returns_Type> rank => 0
<Result_Cast_maybe> ::= <Result_Cast> rank => 0
<Result_Cast_maybe> ::= rank => -1
<Returns_Type> ::= <Returns_Data_Type> <Result_Cast_maybe> rank => 0
                 | <Returns_Table_Type> rank => -1
<Returns_Table_Type> ::= <Lex498> <Table_Function_Column_List> rank => 0
<Gen2587> ::= <Comma> <Table_Function_Column_List_Element> rank => 0
<Gen2587_any> ::= <Gen2587>* rank => 0
<Table_Function_Column_List> ::= <Left_Paren> <Table_Function_Column_List_Element> <Gen2587_any> <Right_Paren> rank => 0
<Table_Function_Column_List_Element> ::= <Column_Name> <Data_Type> rank => 0
<Result_Cast> ::= <Lex315> <Lex376> <Result_Cast_From_Type> rank => 0
<Result_Cast_From_Type> ::= <Data_Type> <Locator_Indication_maybe> rank => 0
<Returns_Data_Type> ::= <Data_Type> <Locator_Indication_maybe> rank => 0
<Routine_Body> ::= <SQL_Routine_Spec> rank => 0
                 | <External_Body_Reference> rank => -1
<Rights_Clause_maybe> ::= <Rights_Clause> rank => 0
<Rights_Clause_maybe> ::= rank => -1
<SQL_Routine_Spec> ::= <Rights_Clause_maybe> <SQL_Routine_Body> rank => 0
<Rights_Clause> ::= <Lex488> <Lex237> <Lex149> rank => 0
                  | <Lex488> <Lex237> <Lex111> rank => -1
<SQL_Routine_Body> ::= <SQL_Procedure_Statement> rank => 0
<Gen2602> ::= <Lex172> <External_Routine_Name> rank => 0
<Gen2602_maybe> ::= <Gen2602> rank => 0
<Gen2602_maybe> ::= rank => -1
<Parameter_Style_Clause_maybe> ::= <Parameter_Style_Clause> rank => 0
<Parameter_Style_Clause_maybe> ::= rank => -1
<Transform_Group_Specification_maybe> ::= <Transform_Group_Specification> rank => 0
<Transform_Group_Specification_maybe> ::= rank => -1
<External_Security_Clause_maybe> ::= <External_Security_Clause> rank => 0
<External_Security_Clause_maybe> ::= rank => -1
<External_Body_Reference> ::= <Lex368> <Gen2602_maybe> <Parameter_Style_Clause_maybe> <Transform_Group_Specification_maybe> <External_Security_Clause_maybe> rank => 0
<External_Security_Clause> ::= <Lex368> <Lex237> <Lex111> rank => 0
                             | <Lex368> <Lex237> <Lex149> rank => -1
                             | <Lex368> <Lex237> <Lex142> <Lex110> rank => -2
<Parameter_Style> ::= <Lex488> rank => 0
                    | <Lex137> rank => -1
<Deterministic_Characteristic> ::= <Lex352> rank => 0
                                 | <Lex428> <Lex352> rank => -1
<SQL_Data_Access_Indication> ::= <Lex426> <Lex488> rank => 0
                               | <Lex095> <Lex488> rank => -1
                               | <Lex450> <Lex488> <Lex104> rank => -2
                               | <Lex417> <Lex488> <Lex104> rank => -3
<Null_Call_Clause> ::= <Lex468> <Lex429> <Lex433> <Lex429> <Lex393> rank => 0
                     | <Lex312> <Lex433> <Lex429> <Lex393> rank => -1
<Maximum_Dynamic_Result_Sets> ::= <Unsigned_Integer> rank => 0
<Gen2626> ::= <Single_Group_Specification> rank => 0
            | <Multiple_Group_Specification> rank => -1
<Transform_Group_Specification> ::= <Lex268> <Lex382> <Gen2626> rank => 0
<Single_Group_Specification> ::= <Group_Name> rank => 0
<Gen2630> ::= <Comma> <Group_Specification> rank => 0
<Gen2630_any> ::= <Gen2630>* rank => 0
<Multiple_Group_Specification> ::= <Group_Specification> <Gen2630_any> rank => 0
<Group_Specification> ::= <Group_Name> <Lex373> <Lex275> <Path_Resolved_User_Defined_Type_Name> rank => 0
<Alter_Routine_Statement> ::= <Lex292> <Specific_Routine_Designator> <Alter_Routine_Characteristics> <Alter_Routine_Behavior> rank => 0
<Alter_Routine_Characteristic_many> ::= <Alter_Routine_Characteristic>+ rank => 0
<Alter_Routine_Characteristics> ::= <Alter_Routine_Characteristic_many> rank => 0
<Alter_Routine_Characteristic> ::= <Language_Clause> rank => 0
                                 | <Parameter_Style_Clause> rank => -1
                                 | <SQL_Data_Access_Indication> rank => -2
                                 | <Null_Call_Clause> rank => -3
                                 | <Dynamic_Result_Sets_Characteristic> rank => -4
                                 | <Lex172> <External_Routine_Name> rank => -5
<Alter_Routine_Behavior> ::= <Lex552> rank => 0
<Drop_Routine_Statement> ::= <Lex356> <Specific_Routine_Designator> <Drop_Behavior> rank => 0
<Gen2645> ::= <Lex297> <Lex051> rank => 0
<Gen2645_maybe> ::= <Gen2645> rank => 0
<Gen2645_maybe> ::= rank => -1
<User_Defined_Cast_Definition> ::= <Lex328> <Lex315> <Left_Paren> <Source_Data_Type> <Lex297> <Target_Data_Type> <Right_Paren> <Lex529> <Cast_Function> <Gen2645_maybe> rank => 0
<Cast_Function> ::= <Specific_Routine_Designator> rank => 0
<Source_Data_Type> ::= <Data_Type> rank => 0
<Target_Data_Type> ::= <Data_Type> rank => 0
<Drop_User_Defined_Cast_Statement> ::= <Lex356> <Lex315> <Left_Paren> <Source_Data_Type> <Lex297> <Target_Data_Type> <Right_Paren> <Drop_Behavior> rank => 0
<User_Defined_Ordering_Definition> ::= <Lex328> <Lex187> <Lex373> <Schema_Resolved_User_Defined_Type_Name> <Ordering_Form> rank => 0
<Ordering_Form> ::= <Equals_Ordering_Form> rank => 0
                  | <Full_Ordering_Form> rank => -1
<Equals_Ordering_Form> ::= <Lex123> <Lex434> <Lex310> <Ordering_Category> rank => 0
<Full_Ordering_Form> ::= <Lex437> <Lex377> <Lex310> <Ordering_Category> rank => 0
<Ordering_Category> ::= <Relative_Category> rank => 0
                      | <Map_Category> rank => -1
                      | <State_Category> rank => -2
<Relative_Category> ::= <Lex216> <Lex529> <Relative_Function_Specification> rank => 0
<Map_Category> ::= <Lex160> <Lex529> <Map_Function_Specification> rank => 0
<Specific_Name_maybe> ::= <Specific_Name> rank => 0
<Specific_Name_maybe> ::= rank => -1
<State_Category> ::= <Lex250> <Specific_Name_maybe> rank => 0
<Relative_Function_Specification> ::= <Specific_Routine_Designator> rank => 0
<Map_Function_Specification> ::= <Specific_Routine_Designator> rank => 0
<Drop_User_Defined_Ordering_Statement> ::= <Lex356> <Lex187> <Lex373> <Schema_Resolved_User_Defined_Type_Name> <Drop_Behavior> rank => 0
<Gen2669> ::= <Lex268> rank => 0
            | <Lex269> rank => -1
<Transform_Group_many> ::= <Transform_Group>+ rank => 0
<Transform_Definition> ::= <Lex328> <Gen2669> <Lex373> <Schema_Resolved_User_Defined_Type_Name> <Transform_Group_many> rank => 0
<Transform_Group> ::= <Group_Name> <Left_Paren> <Transform_Element_List> <Right_Paren> rank => 0
<Group_Name> ::= <Identifier> rank => 0
<Gen2675> ::= <Comma> <Transform_Element> rank => 0
<Gen2675_maybe> ::= <Gen2675> rank => 0
<Gen2675_maybe> ::= rank => -1
<Transform_Element_List> ::= <Transform_Element> <Gen2675_maybe> rank => 0
<Transform_Element> ::= <To_Sql> rank => 0
                      | <From_Sql> rank => -1
<To_Sql> ::= <Lex504> <Lex488> <Lex529> <To_Sql_Function> rank => 0
<From_Sql> ::= <Lex376> <Lex488> <Lex529> <From_Sql_Function> rank => 0
<To_Sql_Function> ::= <Specific_Routine_Designator> rank => 0
<From_Sql_Function> ::= <Specific_Routine_Designator> rank => 0
<Gen2685> ::= <Lex268> rank => 0
            | <Lex269> rank => -1
<Alter_Group_many> ::= <Alter_Group>+ rank => 0
<Alter_Transform_Statement> ::= <Lex292> <Gen2685> <Lex373> <Schema_Resolved_User_Defined_Type_Name> <Alter_Group_many> rank => 0
<Alter_Group> ::= <Group_Name> <Left_Paren> <Alter_Transform_Action_List> <Right_Paren> rank => 0
<Gen2690> ::= <Comma> <Alter_Transform_Action> rank => 0
<Gen2690_any> ::= <Gen2690>* rank => 0
<Alter_Transform_Action_List> ::= <Alter_Transform_Action> <Gen2690_any> rank => 0
<Alter_Transform_Action> ::= <Add_Transform_Element_List> rank => 0
                           | <Drop_Transform_Element_List> rank => -1
<Add_Transform_Element_List> ::= <Lex289> <Left_Paren> <Transform_Element_List> <Right_Paren> rank => 0
<Gen2696> ::= <Comma> <Transform_Kind> rank => 0
<Gen2696_maybe> ::= <Gen2696> rank => 0
<Gen2696_maybe> ::= rank => -1
<Drop_Transform_Element_List> ::= <Lex356> <Left_Paren> <Transform_Kind> <Gen2696_maybe> <Drop_Behavior> <Right_Paren> rank => 0
<Transform_Kind> ::= <Lex504> <Lex488> rank => 0
                   | <Lex376> <Lex488> rank => -1
<Gen2702> ::= <Lex268> rank => 0
            | <Lex269> rank => -1
<Drop_Transform_Statement> ::= <Lex356> <Gen2702> <Transforms_To_Be_Dropped> <Lex373> <Schema_Resolved_User_Defined_Type_Name> <Drop_Behavior> rank => 0
<Transforms_To_Be_Dropped> ::= <Lex290> rank => 0
                             | <Transform_Group_Element> rank => -1
<Transform_Group_Element> ::= <Group_Name> rank => 0
<Sequence_Generator_Options_maybe> ::= <Sequence_Generator_Options> rank => 0
<Sequence_Generator_Options_maybe> ::= rank => -1
<Sequence_Generator_Definition> ::= <Lex328> <Lex239> <Sequence_Generator_Name> <Sequence_Generator_Options_maybe> rank => 0
<Sequence_Generator_Option_many> ::= <Sequence_Generator_Option>+ rank => 0
<Sequence_Generator_Options> ::= <Sequence_Generator_Option_many> rank => 0
<Sequence_Generator_Option> ::= <Sequence_Generator_Data_Type_Option> rank => 0
                              | <Common_Sequence_Generator_Options> rank => -1
<Common_Sequence_Generator_Option_many> ::= <Common_Sequence_Generator_Option>+ rank => 0
<Common_Sequence_Generator_Options> ::= <Common_Sequence_Generator_Option_many> rank => 0
<Common_Sequence_Generator_Option> ::= <Sequence_Generator_Start_With_Option> rank => 0
                                     | <Basic_Sequence_Generator_Option> rank => -1
<Basic_Sequence_Generator_Option> ::= <Sequence_Generator_Increment_By_Option> rank => 0
                                    | <Sequence_Generator_Maxvalue_Option> rank => -1
                                    | <Sequence_Generator_Minvalue_Option> rank => -2
                                    | <Sequence_Generator_Cycle_Option> rank => -3
<Sequence_Generator_Data_Type_Option> ::= <Lex297> <Data_Type> rank => 0
<Sequence_Generator_Start_With_Option> ::= <Lex492> <Lex529> <Sequence_Generator_Start_Value> rank => 0
<Sequence_Generator_Start_Value> ::= <Signed_Numeric_Literal> rank => 0
<Sequence_Generator_Increment_By_Option> ::= <Lex144> <Lex310> <Sequence_Generator_Increment> rank => 0
<Sequence_Generator_Increment> ::= <Signed_Numeric_Literal> rank => 0
<Sequence_Generator_Maxvalue_Option> ::= <Lex163> <Sequence_Generator_Max_Value> rank => 0
                                       | <Lex426> <Lex163> rank => -1
<Sequence_Generator_Max_Value> ::= <Signed_Numeric_Literal> rank => 0
<Sequence_Generator_Minvalue_Option> ::= <Lex168> <Sequence_Generator_Min_Value> rank => 0
                                       | <Lex426> <Lex168> rank => -1
<Sequence_Generator_Min_Value> ::= <Signed_Numeric_Literal> rank => 0
<Sequence_Generator_Cycle_Option> ::= <Lex341> rank => 0
                                    | <Lex426> <Lex341> rank => -1
<Alter_Sequence_Generator_Statement> ::= <Lex292> <Lex239> <Sequence_Generator_Name> <Alter_Sequence_Generator_Options> rank => 0
<Alter_Sequence_Generator_Option_many> ::= <Alter_Sequence_Generator_Option>+ rank => 0
<Alter_Sequence_Generator_Options> ::= <Alter_Sequence_Generator_Option_many> rank => 0
<Alter_Sequence_Generator_Option> ::= <Alter_Sequence_Generator_Restart_Option> rank => 0
                                    | <Basic_Sequence_Generator_Option> rank => -1
<Alter_Sequence_Generator_Restart_Option> ::= <Lex218> <Lex529> <Sequence_Generator_Restart_Value> rank => 0
<Sequence_Generator_Restart_Value> ::= <Signed_Numeric_Literal> rank => 0
<Drop_Sequence_Generator_Statement> ::= <Lex356> <Lex239> <Sequence_Generator_Name> <Drop_Behavior> rank => 0
<Grant_Statement> ::= <Grant_Privilege_Statement> rank => 0
                    | <Grant_Role_Statement> rank => -1
<Gen2746> ::= <Comma> <Grantee> rank => 0
<Gen2746_any> ::= <Gen2746>* rank => 0
<Gen2748> ::= <Lex529> <Lex141> <Lex185> rank => 0
<Gen2748_maybe> ::= <Gen2748> rank => 0
<Gen2748_maybe> ::= rank => -1
<Gen2751> ::= <Lex529> <Lex381> <Lex185> rank => 0
<Gen2751_maybe> ::= <Gen2751> rank => 0
<Gen2751_maybe> ::= rank => -1
<Gen2754> ::= <Lex140> <Lex310> <Grantor> rank => 0
<Gen2754_maybe> ::= <Gen2754> rank => 0
<Gen2754_maybe> ::= rank => -1
<Grant_Privilege_Statement> ::= <Lex381> <Privileges> <Lex504> <Grantee> <Gen2746_any> <Gen2748_maybe> <Gen2751_maybe> <Gen2754_maybe> rank => 0
<Privileges> ::= <Object_Privileges> <Lex433> <Object_Name> rank => 0
<Lex498_maybe> ::= <Lex498> rank => 0
<Lex498_maybe> ::= rank => -1
<Object_Name> ::= <Lex498_maybe> <Table_Name> rank => 0
                | <Lex120> <Domain_Name> rank => -1
                | <Lex078> <Collation_Name> rank => -2
                | <Lex317> <Lex482> <Character_Set_Name> rank => -3
                | <Lex506> <Transliteration_Name> rank => -4
                | <Lex275> <Schema_Resolved_User_Defined_Type_Name> rank => -5
                | <Lex239> <Sequence_Generator_Name> rank => -6
                | <Specific_Routine_Designator> rank => -7
<Gen2769> ::= <Comma> <Action> rank => 0
<Gen2769_any> ::= <Gen2769>* rank => 0
<Object_Privileges> ::= <Lex290> <Lex212> rank => 0
                      | <Action> <Gen2769_any> rank => -1
<Gen2773> ::= <Left_Paren> <Privilege_Column_List> <Right_Paren> rank => 0
<Gen2773_maybe> ::= <Gen2773> rank => 0
<Gen2773_maybe> ::= rank => -1
<Gen2776> ::= <Left_Paren> <Privilege_Column_List> <Right_Paren> rank => 0
<Gen2776_maybe> ::= <Gen2776> rank => 0
<Gen2776_maybe> ::= rank => -1
<Gen2779> ::= <Left_Paren> <Privilege_Column_List> <Right_Paren> rank => 0
<Gen2779_maybe> ::= <Gen2779> rank => 0
<Gen2779_maybe> ::= rank => -1
<Action> ::= <Lex479> rank => 0
           | <Lex479> <Left_Paren> <Privilege_Column_List> <Right_Paren> rank => -1
           | <Lex479> <Left_Paren> <Privilege_Method_List> <Right_Paren> rank => -2
           | <Lex349> rank => -3
           | <Lex395> <Gen2773_maybe> rank => -4
           | <Lex514> <Gen2776_maybe> rank => -5
           | <Lex454> <Gen2779_maybe> rank => -6
           | <Lex280> rank => -7
           | <Lex508> rank => -8
           | <Lex278> rank => -9
           | <Lex366> rank => -10
<Gen2793> ::= <Comma> <Specific_Routine_Designator> rank => 0
<Gen2793_any> ::= <Gen2793>* rank => 0
<Privilege_Method_List> ::= <Specific_Routine_Designator> <Gen2793_any> rank => 0
<Privilege_Column_List> ::= <Column_Name_List> rank => 0
<Grantee> ::= <Lex213> rank => 0
            | <Authorization_Identifier> rank => -1
<Grantor> ::= <Lex339> rank => 0
            | <Lex335> rank => -1
<Gen2801> ::= <Lex529> <Lex046> <Grantor> rank => 0
<Gen2801_maybe> ::= <Gen2801> rank => 0
<Gen2801_maybe> ::= rank => -1
<Role_Definition> ::= <Lex328> <Lex223> <Role_Name> <Gen2801_maybe> rank => 0
<Gen2805> ::= <Comma> <Role_Granted> rank => 0
<Gen2805_any> ::= <Gen2805>* rank => 0
<Gen2807> ::= <Comma> <Grantee> rank => 0
<Gen2807_any> ::= <Gen2807>* rank => 0
<Gen2809> ::= <Lex529> <Lex046> <Lex185> rank => 0
<Gen2809_maybe> ::= <Gen2809> rank => 0
<Gen2809_maybe> ::= rank => -1
<Gen2812> ::= <Lex140> <Lex310> <Grantor> rank => 0
<Gen2812_maybe> ::= <Gen2812> rank => 0
<Gen2812_maybe> ::= rank => -1
<Grant_Role_Statement> ::= <Lex381> <Role_Granted> <Gen2805_any> <Lex504> <Grantee> <Gen2807_any> <Gen2809_maybe> <Gen2812_maybe> rank => 0
<Role_Granted> ::= <Role_Name> rank => 0
<Drop_Role_Statement> ::= <Lex356> <Lex223> <Role_Name> rank => 0
<Revoke_Statement> ::= <Revoke_Privilege_Statement> rank => 0
                     | <Revoke_Role_Statement> rank => -1
<Revoke_Option_Extension_maybe> ::= <Revoke_Option_Extension> rank => 0
<Revoke_Option_Extension_maybe> ::= rank => -1
<Gen2822> ::= <Comma> <Grantee> rank => 0
<Gen2822_any> ::= <Gen2822>* rank => 0
<Gen2824> ::= <Lex140> <Lex310> <Grantor> rank => 0
<Gen2824_maybe> ::= <Gen2824> rank => 0
<Gen2824_maybe> ::= rank => -1
<Revoke_Privilege_Statement> ::= <Lex469> <Revoke_Option_Extension_maybe> <Privileges> <Lex376> <Grantee> <Gen2822_any> <Gen2824_maybe> <Drop_Behavior> rank => 0
<Revoke_Option_Extension> ::= <Lex381> <Lex185> <Lex373> rank => 0
                            | <Lex141> <Lex185> <Lex373> rank => -1
<Gen2830> ::= <Lex046> <Lex185> <Lex373> rank => 0
<Gen2830_maybe> ::= <Gen2830> rank => 0
<Gen2830_maybe> ::= rank => -1
<Gen2833> ::= <Comma> <Role_Revoked> rank => 0
<Gen2833_any> ::= <Gen2833>* rank => 0
<Gen2835> ::= <Comma> <Grantee> rank => 0
<Gen2835_any> ::= <Gen2835>* rank => 0
<Gen2837> ::= <Lex140> <Lex310> <Grantor> rank => 0
<Gen2837_maybe> ::= <Gen2837> rank => 0
<Gen2837_maybe> ::= rank => -1
<Revoke_Role_Statement> ::= <Lex469> <Gen2830_maybe> <Role_Revoked> <Gen2833_any> <Lex376> <Grantee> <Gen2835_any> <Gen2837_maybe> <Drop_Behavior> rank => 0
<Role_Revoked> ::= <Role_Name> rank => 0
<Module_Path_Specification_maybe> ::= <Module_Path_Specification> rank => 0
<Module_Path_Specification_maybe> ::= rank => -1
<Module_Transform_Group_Specification_maybe> ::= <Module_Transform_Group_Specification> rank => 0
<Module_Transform_Group_Specification_maybe> ::= rank => -1
<Module_Collations_maybe> ::= <Module_Collations> rank => 0
<Module_Collations_maybe> ::= rank => -1
<Temporary_Table_Declaration_any> ::= <Temporary_Table_Declaration>* rank => 0
<Module_Contents_many> ::= <Module_Contents>+ rank => 0
<SQL_Client_Module_Definition> ::= <Module_Name_Clause> <Language_Clause> <Module_Authorization_Clause> <Module_Path_Specification_maybe> <Module_Transform_Group_Specification_maybe> <Module_Collations_maybe> <Temporary_Table_Declaration_any> <Module_Contents_many> rank => 0
<Gen2851> ::= <Lex434> rank => 0
            | <Lex293> <Lex357> rank => -1
<Gen2853> ::= <Lex373> <Lex493> <Gen2851> rank => 0
<Gen2853_maybe> ::= <Gen2853> rank => 0
<Gen2853_maybe> ::= rank => -1
<Gen2856> ::= <Lex434> rank => 0
            | <Lex293> <Lex357> rank => -1
<Gen2858> ::= <Lex373> <Lex493> <Gen2856> rank => 0
<Gen2858_maybe> ::= <Gen2858> rank => 0
<Gen2858_maybe> ::= rank => -1
<Module_Authorization_Clause> ::= <Lex231> <Schema_Name> rank => 0
                                | <Lex302> <Module_Authorization_Identifier> <Gen2853_maybe> rank => -1
                                | <Lex231> <Schema_Name> <Lex302> <Module_Authorization_Identifier> <Gen2858_maybe> rank => -2
<Module_Authorization_Identifier> ::= <Authorization_Identifier> rank => 0
<Module_Path_Specification> ::= <Path_Specification> rank => 0
<Module_Transform_Group_Specification> ::= <Transform_Group_Specification> rank => 0
<Module_Collation_Specification_many> ::= <Module_Collation_Specification>+ rank => 0
<Module_Collations> ::= <Module_Collation_Specification_many> rank => 0
<Gen2869> ::= <Lex373> <Character_Set_Specification_List> rank => 0
<Gen2869_maybe> ::= <Gen2869> rank => 0
<Gen2869_maybe> ::= rank => -1
<Module_Collation_Specification> ::= <Lex078> <Collation_Name> <Gen2869_maybe> rank => 0
<Gen2873> ::= <Comma> <Character_Set_Specification> rank => 0
<Gen2873_any> ::= <Gen2873>* rank => 0
<Character_Set_Specification_List> ::= <Character_Set_Specification> <Gen2873_any> rank => 0
<Module_Contents> ::= <Declare_Cursor> rank => 0
                    | <Dynamic_Declare_Cursor> rank => -1
                    | <Externally_Invoked_Procedure> rank => -2
<SQL_Client_Module_Name_maybe> ::= <SQL_Client_Module_Name> rank => 0
<SQL_Client_Module_Name_maybe> ::= rank => -1
<Module_Character_Set_Specification_maybe> ::= <Module_Character_Set_Specification> rank => 0
<Module_Character_Set_Specification_maybe> ::= rank => -1
<Module_Name_Clause> ::= <Lex418> <SQL_Client_Module_Name_maybe> <Module_Character_Set_Specification_maybe> rank => 0
<Module_Character_Set_Specification> ::= <Lex173> <Lex295> <Character_Set_Specification> rank => 0
<Externally_Invoked_Procedure> ::= <Lex448> <Procedure_Name> <Host_Parameter_Declaration_List> <Semicolon> <SQL_Procedure_Statement> <Semicolon> rank => 0
<Gen2886> ::= <Comma> <Host_Parameter_Declaration> rank => 0
<Gen2886_any> ::= <Gen2886>* rank => 0
<Host_Parameter_Declaration_List> ::= <Left_Paren> <Host_Parameter_Declaration> <Gen2886_any> <Right_Paren> rank => 0
<Host_Parameter_Declaration> ::= <Host_Parameter_Name> <Host_Parameter_Data_Type> rank => 0
                               | <Status_Parameter> rank => -1
<Host_Parameter_Data_Type> ::= <Data_Type> <Locator_Indication_maybe> rank => 0
<Status_Parameter> ::= <Lex490> rank => 0
<SQL_Procedure_Statement> ::= <SQL_Executable_Statement> rank => 0
<SQL_Executable_Statement> ::= <SQL_Schema_Statement> rank => 0
                             | <SQL_Data_Statement> rank => -1
                             | <SQL_Control_Statement> rank => -2
                             | <SQL_Transaction_Statement> rank => -3
                             | <SQL_Connection_Statement> rank => -4
                             | <SQL_Session_Statement> rank => -5
                             | <SQL_Diagnostics_Statement> rank => -6
                             | <SQL_Dynamic_Statement> rank => -7
<SQL_Schema_Statement> ::= <SQL_Schema_Definition_Statement> rank => 0
                         | <SQL_Schema_Manipulation_Statement> rank => -1
<SQL_Schema_Definition_Statement> ::= <Schema_Definition> rank => 0
                                    | <Table_Definition> rank => -1
                                    | <View_Definition> rank => -2
                                    | <SQL_Invoked_Routine> rank => -3
                                    | <Grant_Statement> rank => -4
                                    | <Role_Definition> rank => -5
                                    | <Domain_Definition> rank => -6
                                    | <Character_Set_Definition> rank => -7
                                    | <Collation_Definition> rank => -8
                                    | <Transliteration_Definition> rank => -9
                                    | <Assertion_Definition> rank => -10
                                    | <Trigger_Definition> rank => -11
                                    | <User_Defined_Type_Definition> rank => -12
                                    | <User_Defined_Cast_Definition> rank => -13
                                    | <User_Defined_Ordering_Definition> rank => -14
                                    | <Transform_Definition> rank => -15
                                    | <Sequence_Generator_Definition> rank => -16
<SQL_Schema_Manipulation_Statement> ::= <Drop_Schema_Statement> rank => 0
                                      | <Alter_Table_Statement> rank => -1
                                      | <Drop_Table_Statement> rank => -2
                                      | <Drop_View_Statement> rank => -3
                                      | <Alter_Routine_Statement> rank => -4
                                      | <Drop_Routine_Statement> rank => -5
                                      | <Drop_User_Defined_Cast_Statement> rank => -6
                                      | <Revoke_Statement> rank => -7
                                      | <Drop_Role_Statement> rank => -8
                                      | <Alter_Domain_Statement> rank => -9
                                      | <Drop_Domain_Statement> rank => -10
                                      | <Drop_Character_Set_Statement> rank => -11
                                      | <Drop_Collation_Statement> rank => -12
                                      | <Drop_Transliteration_Statement> rank => -13
                                      | <Drop_Assertion_Statement> rank => -14
                                      | <Drop_Trigger_Statement> rank => -15
                                      | <Alter_Type_Statement> rank => -16
                                      | <Drop_Data_Type_Statement> rank => -17
                                      | <Drop_User_Defined_Ordering_Statement> rank => -18
                                      | <Alter_Transform_Statement> rank => -19
                                      | <Drop_Transform_Statement> rank => -20
                                      | <Alter_Sequence_Generator_Statement> rank => -21
                                      | <Drop_Sequence_Generator_Statement> rank => -22
<SQL_Data_Statement> ::= <Open_Statement> rank => 0
                       | <Fetch_Statement> rank => -1
                       | <Close_Statement> rank => -2
                       | <Select_Statement_Single_Row> rank => -3
                       | <Free_Locator_Statement> rank => -4
                       | <Hold_Locator_Statement> rank => -5
                       | <SQL_Data_Change_Statement> rank => -6
<SQL_Data_Change_Statement> ::= <Delete_Statement_Positioned> rank => 0
                              | <Delete_Statement_Searched> rank => -1
                              | <Insert_Statement> rank => -2
                              | <Update_Statement_Positioned> rank => -3
                              | <Update_Statement_Searched> rank => -4
                              | <Merge_Statement> rank => -5
<SQL_Control_Statement> ::= <Call_Statement> rank => 0
                          | <Return_Statement> rank => -1
<SQL_Transaction_Statement> ::= <Start_Transaction_Statement> rank => 0
                              | <Set_Transaction_Statement> rank => -1
                              | <Set_Constraints_Mode_Statement> rank => -2
                              | <Savepoint_Statement> rank => -3
                              | <Release_Savepoint_Statement> rank => -4
                              | <Commit_Statement> rank => -5
                              | <Rollback_Statement> rank => -6
<SQL_Connection_Statement> ::= <Connect_Statement> rank => 0
                             | <Set_Connection_Statement> rank => -1
                             | <Disconnect_Statement> rank => -2
<SQL_Session_Statement> ::= <Set_Session_User_Identifier_Statement> rank => 0
                          | <Set_Role_Statement> rank => -1
                          | <Set_Local_Time_Zone_Statement> rank => -2
                          | <Set_Session_Characteristics_Statement> rank => -3
                          | <Set_Catalog_Statement> rank => -4
                          | <Set_Schema_Statement> rank => -5
                          | <Set_Names_Statement> rank => -6
                          | <Set_Path_Statement> rank => -7
                          | <Set_Transform_Group_Statement> rank => -8
                          | <Set_Session_Collation_Statement> rank => -9
<SQL_Diagnostics_Statement> ::= <Get_Diagnostics_Statement> rank => 0
<SQL_Dynamic_Statement> ::= <System_Descriptor_Statement> rank => 0
                          | <Prepare_Statement> rank => -1
                          | <Deallocate_Prepared_Statement> rank => -2
                          | <Describe_Statement> rank => -3
                          | <Execute_Statement> rank => -4
                          | <Execute_Immediate_Statement> rank => -5
                          | <SQL_Dynamic_Data_Statement> rank => -6
<SQL_Dynamic_Data_Statement> ::= <Allocate_Cursor_Statement> rank => 0
                               | <Dynamic_Open_Statement> rank => -1
                               | <Dynamic_Fetch_Statement> rank => -2
                               | <Dynamic_Close_Statement> rank => -3
                               | <Dynamic_Delete_Statement_Positioned> rank => -4
                               | <Dynamic_Update_Statement_Positioned> rank => -5
<System_Descriptor_Statement> ::= <Allocate_Descriptor_Statement> rank => 0
                                | <Deallocate_Descriptor_Statement> rank => -1
                                | <Set_Descriptor_Statement> rank => -2
                                | <Get_Descriptor_Statement> rank => -3
<Cursor_Sensitivity_maybe> ::= <Cursor_Sensitivity> rank => 0
<Cursor_Sensitivity_maybe> ::= rank => -1
<Cursor_Scrollability_maybe> ::= <Cursor_Scrollability> rank => 0
<Cursor_Scrollability_maybe> ::= rank => -1
<Cursor_Holdability_maybe> ::= <Cursor_Holdability> rank => 0
<Cursor_Holdability_maybe> ::= rank => -1
<Cursor_Returnability_maybe> ::= <Cursor_Returnability> rank => 0
<Cursor_Returnability_maybe> ::= rank => -1
<Declare_Cursor> ::= <Lex347> <Cursor_Name> <Cursor_Sensitivity_maybe> <Cursor_Scrollability_maybe> <Lex340> <Cursor_Holdability_maybe> <Cursor_Returnability_maybe> <Lex373> <Cursor_Specification> rank => 0
<Cursor_Sensitivity> ::= <Lex480> rank => 0
                       | <Lex394> rank => -1
                       | <Lex298> rank => -2
<Cursor_Scrollability> ::= <Lex476> rank => 0
                         | <Lex426> <Lex476> rank => -1
<Cursor_Holdability> ::= <Lex529> <Lex385> rank => 0
                       | <Lex531> <Lex385> rank => -1
<Cursor_Returnability> ::= <Lex529> <Lex467> rank => 0
                         | <Lex531> <Lex467> rank => -1
<Updatability_Clause_maybe> ::= <Updatability_Clause> rank => 0
<Updatability_Clause_maybe> ::= rank => -1
<Cursor_Specification> ::= <Query_Expression> <Order_By_Clause_maybe> <Updatability_Clause_maybe> rank => 0
<Gen3018> ::= <Lex431> <Column_Name_List> rank => 0
<Gen3018_maybe> ::= <Gen3018> rank => 0
<Gen3018_maybe> ::= rank => -1
<Gen3021> ::= <Lex215> <Lex434> rank => 0
            | <Lex514> <Gen3018_maybe> rank => -1
<Updatability_Clause> ::= <Lex373> <Gen3021> rank => 0
<Order_By_Clause> ::= <Lex437> <Lex310> <Sort_Specification_List> rank => 0
<Open_Statement> ::= <Lex435> <Cursor_Name> rank => 0
<Fetch_Orientation_maybe> ::= <Fetch_Orientation> rank => 0
<Fetch_Orientation_maybe> ::= rank => -1
<Gen3028> ::= <Fetch_Orientation_maybe> <Lex376> rank => 0
<Gen3028_maybe> ::= <Gen3028> rank => 0
<Gen3028_maybe> ::= rank => -1
<Fetch_Statement> ::= <Lex370> <Gen3028_maybe> <Cursor_Name> <Lex400> <Fetch_Target_List> rank => 0
<Gen3032> ::= <Lex043> rank => 0
            | <Lex216> rank => -1
<Fetch_Orientation> ::= <Lex175> rank => 0
                      | <Lex211> rank => -1
                      | <Lex131> rank => -2
                      | <Lex154> rank => -3
                      | <Gen3032> <Simple_Value_Specification> rank => -4
<Gen3039> ::= <Comma> <Target_Specification> rank => 0
<Gen3039_any> ::= <Gen3039>* rank => 0
<Fetch_Target_List> ::= <Target_Specification> <Gen3039_any> rank => 0
<Close_Statement> ::= <Lex320> <Cursor_Name> rank => 0
<Select_Statement_Single_Row> ::= <Lex479> <Set_Quantifier_maybe> <Select_List> <Lex400> <Select_Target_List> <Table_Expression> rank => 0
<Gen3044> ::= <Comma> <Target_Specification> rank => 0
<Gen3044_any> ::= <Gen3044>* rank => 0
<Select_Target_List> ::= <Target_Specification> <Gen3044_any> rank => 0
<Delete_Statement_Positioned> ::= <Lex349> <Lex376> <Target_Table> <Lex526> <Lex331> <Lex431> <Cursor_Name> rank => 0
<Target_Table> ::= <Table_Name> rank => 0
                 | <Lex434> <Left_Paren> <Table_Name> <Right_Paren> rank => -1
<Gen3050> ::= <Lex526> <Search_Condition> rank => 0
<Gen3050_maybe> ::= <Gen3050> rank => 0
<Gen3050_maybe> ::= rank => -1
<Delete_Statement_Searched> ::= <Lex349> <Lex376> <Target_Table> <Gen3050_maybe> rank => 0
<Insert_Statement> ::= <Lex395> <Lex400> <Insertion_Target> <Insert_Columns_And_Source> rank => 0
<Insertion_Target> ::= <Table_Name> rank => 0
<Insert_Columns_And_Source> ::= <From_Subquery> rank => 0
                              | <From_Constructor> rank => -1
                              | <From_Default> rank => -2
<Gen3059> ::= <Left_Paren> <Insert_Column_List> <Right_Paren> rank => 0
<Gen3059_maybe> ::= <Gen3059> rank => 0
<Gen3059_maybe> ::= rank => -1
<Override_Clause_maybe> ::= <Override_Clause> rank => 0
<Override_Clause_maybe> ::= rank => -1
<From_Subquery> ::= <Gen3059_maybe> <Override_Clause_maybe> <Query_Expression> rank => 0
<Gen3065> ::= <Left_Paren> <Insert_Column_List> <Right_Paren> rank => 0
<Gen3065_maybe> ::= <Gen3065> rank => 0
<Gen3065_maybe> ::= rank => -1
<From_Constructor> ::= <Gen3065_maybe> <Override_Clause_maybe> <Contextually_Typed_Table_Value_Constructor> rank => 0
<Override_Clause> ::= <Lex191> <Lex516> <Lex518> rank => 0
                    | <Lex191> <Lex496> <Lex518> rank => -1
<From_Default> ::= <Lex348> <Lex519> rank => 0
<Insert_Column_List> ::= <Column_Name_List> rank => 0
<Gen3073> ::= <Lex297_maybe> <Merge_Correlation_Name> rank => 0
<Gen3073_maybe> ::= <Gen3073> rank => 0
<Gen3073_maybe> ::= rank => -1
<Merge_Statement> ::= <Lex414> <Lex400> <Target_Table> <Gen3073_maybe> <Lex517> <Table_Reference> <Lex433> <Search_Condition> <Merge_Operation_Specification> rank => 0
<Merge_Correlation_Name> ::= <Correlation_Name> rank => 0
<Merge_When_Clause_many> ::= <Merge_When_Clause>+ rank => 0
<Merge_Operation_Specification> ::= <Merge_When_Clause_many> rank => 0
<Merge_When_Clause> ::= <Merge_When_Matched_Clause> rank => 0
                      | <Merge_When_Not_Matched_Clause> rank => -1
<Merge_When_Matched_Clause> ::= <Lex524> <Lex161> <Lex499> <Merge_Update_Specification> rank => 0
<Merge_When_Not_Matched_Clause> ::= <Lex524> <Lex428> <Lex161> <Lex499> <Merge_Insert_Specification> rank => 0
<Merge_Update_Specification> ::= <Lex514> <Lex482> <Set_Clause_List> rank => 0
<Gen3085> ::= <Left_Paren> <Insert_Column_List> <Right_Paren> rank => 0
<Gen3085_maybe> ::= <Gen3085> rank => 0
<Gen3085_maybe> ::= rank => -1
<Merge_Insert_Specification> ::= <Lex395> <Gen3085_maybe> <Override_Clause_maybe> <Lex519> <Merge_Insert_Value_List> rank => 0
<Gen3089> ::= <Comma> <Merge_Insert_Value_Element> rank => 0
<Gen3089_any> ::= <Gen3089>* rank => 0
<Merge_Insert_Value_List> ::= <Left_Paren> <Merge_Insert_Value_Element> <Gen3089_any> <Right_Paren> rank => 0
<Merge_Insert_Value_Element> ::= <Value_Expression> rank => 0
                               | <Contextually_Typed_Value_Specification> rank => -1
<Update_Statement_Positioned> ::= <Lex514> <Target_Table> <Lex482> <Set_Clause_List> <Lex526> <Lex331> <Lex431> <Cursor_Name> rank => 0
<Gen3095> ::= <Lex526> <Search_Condition> rank => 0
<Gen3095_maybe> ::= <Gen3095> rank => 0
<Gen3095_maybe> ::= rank => -1
<Update_Statement_Searched> ::= <Lex514> <Target_Table> <Lex482> <Set_Clause_List> <Gen3095_maybe> rank => 0
<Gen3099> ::= <Comma> <Set_Clause> rank => 0
<Gen3099_any> ::= <Gen3099>* rank => 0
<Set_Clause_List> ::= <Set_Clause> <Gen3099_any> rank => 0
<Set_Clause> ::= <Multiple_Column_Assignment> rank => 0
               | <Set_Target> <Equals_Operator> <Update_Source> rank => -1
<Set_Target> ::= <Update_Target> rank => 0
               | <Mutated_Set_Clause> rank => -1
<Multiple_Column_Assignment> ::= <Set_Target_List> <Equals_Operator> <Assigned_Row> rank => 0
<Gen3107> ::= <Comma> <Set_Target> rank => 0
<Gen3107_any> ::= <Gen3107>* rank => 0
<Set_Target_List> ::= <Left_Paren> <Set_Target> <Gen3107_any> <Right_Paren> rank => 0
<Assigned_Row> ::= <Contextually_Typed_Row_Value_Expression> rank => 0
<Update_Target> ::= <Object_Column> rank => 0
                  | <Object_Column> <Left_Bracket_Or_Trigraph> <Simple_Value_Specification> <Right_Bracket_Or_Trigraph> rank => -1
<Object_Column> ::= <Column_Name> rank => 0
<Mutated_Set_Clause> ::= <Mutated_Target> <Period> <Method_Name> rank => 0
<Mutated_Target> ::= <Object_Column> rank => 0
                   | <Mutated_Set_Clause> rank => -1
<Update_Source> ::= <Value_Expression> rank => 0
                  | <Contextually_Typed_Value_Specification> rank => -1
<Gen3119> ::= <Lex433> <Lex323> <Table_Commit_Action> <Lex474> rank => 0
<Gen3119_maybe> ::= <Gen3119> rank => 0
<Gen3119_maybe> ::= rank => -1
<Temporary_Table_Declaration> ::= <Lex347> <Lex409> <Lex261> <Lex498> <Table_Name> <Table_Element_List> <Gen3119_maybe> rank => 0
<Gen3123> ::= <Comma> <Locator_Reference> rank => 0
<Gen3123_any> ::= <Gen3123>* rank => 0
<Free_Locator_Statement> ::= <Lex375> <Lex158> <Locator_Reference> <Gen3123_any> rank => 0
<Locator_Reference> ::= <Host_Parameter_Name> rank => 0
                      | <Embedded_Variable_Name> rank => -1
<Gen3128> ::= <Comma> <Locator_Reference> rank => 0
<Gen3128_any> ::= <Gen3128>* rank => 0
<Hold_Locator_Statement> ::= <Lex385> <Lex158> <Locator_Reference> <Gen3128_any> rank => 0
<Call_Statement> ::= <Lex311> <Routine_Invocation> rank => 0
<Return_Statement> ::= <Lex467> <Return_Value> rank => 0
<Return_Value> ::= <Value_Expression> rank => 0
                 | <Lex429> rank => -1
<Gen3135> ::= <Comma> <Transaction_Mode> rank => 0
<Gen3135_any> ::= <Gen3135>* rank => 0
<Gen3137> ::= <Transaction_Mode> <Gen3135_any> rank => 0
<Gen3137_maybe> ::= <Gen3137> rank => 0
<Gen3137_maybe> ::= rank => -1
<Start_Transaction_Statement> ::= <Lex492> <Lex264> <Gen3137_maybe> rank => 0
<Transaction_Mode> ::= <Isolation_Level> rank => 0
                     | <Transaction_Access_Mode> rank => -1
                     | <Diagnostics_Size> rank => -2
<Transaction_Access_Mode> ::= <Lex215> <Lex434> rank => 0
                            | <Lex215> <Lex287> rank => -1
<Isolation_Level> ::= <Lex150> <Lex156> <Level_Of_Isolation> rank => 0
<Level_Of_Isolation> ::= <Lex215> <Lex277> rank => 0
                       | <Lex215> <Lex086> rank => -1
                       | <Lex217> <Lex215> rank => -2
                       | <Lex240> rank => -3
<Diagnostics_Size> ::= <Lex118> <Lex245> <Number_Of_Conditions> rank => 0
<Number_Of_Conditions> ::= <Simple_Value_Specification> rank => 0
<Lex409_maybe> ::= <Lex409> rank => 0
<Lex409_maybe> ::= rank => -1
<Set_Transaction_Statement> ::= <Lex482> <Lex409_maybe> <Transaction_Characteristics> rank => 0
<Gen3156> ::= <Comma> <Transaction_Mode> rank => 0
<Gen3156_any> ::= <Gen3156>* rank => 0
<Transaction_Characteristics> ::= <Lex264> <Transaction_Mode> <Gen3156_any> rank => 0
<Gen3159> ::= <Lex109> rank => 0
            | <Lex388> rank => -1
<Set_Constraints_Mode_Statement> ::= <Lex482> <Lex090> <Constraint_Name_List> <Gen3159> rank => 0
<Gen3162> ::= <Comma> <Constraint_Name> rank => 0
<Gen3162_any> ::= <Gen3162>* rank => 0
<Constraint_Name_List> ::= <Lex290> rank => 0
                         | <Constraint_Name> <Gen3162_any> rank => -1
<Savepoint_Statement> ::= <Lex475> <Savepoint_Specifier> rank => 0
<Savepoint_Specifier> ::= <Savepoint_Name> rank => 0
<Release_Savepoint_Statement> ::= <Lex465> <Lex475> <Savepoint_Specifier> rank => 0
<Lex286_maybe> ::= <Lex286> rank => 0
<Lex286_maybe> ::= rank => -1
<Lex426_maybe> ::= <Lex426> rank => 0
<Lex426_maybe> ::= rank => -1
<Gen3173> ::= <Lex293> <Lex426_maybe> <Lex065> rank => 0
<Gen3173_maybe> ::= <Gen3173> rank => 0
<Gen3173_maybe> ::= rank => -1
<Commit_Statement> ::= <Lex323> <Lex286_maybe> <Gen3173_maybe> rank => 0
<Gen3177> ::= <Lex293> <Lex426_maybe> <Lex065> rank => 0
<Gen3177_maybe> ::= <Gen3177> rank => 0
<Gen3177_maybe> ::= rank => -1
<Savepoint_Clause_maybe> ::= <Savepoint_Clause> rank => 0
<Savepoint_Clause_maybe> ::= rank => -1
<Rollback_Statement> ::= <Lex471> <Lex286_maybe> <Gen3177_maybe> <Savepoint_Clause_maybe> rank => 0
<Savepoint_Clause> ::= <Lex504> <Lex475> <Savepoint_Specifier> rank => 0
<Connect_Statement> ::= <Lex324> <Lex504> <Connection_Target> rank => 0
<Gen3185> ::= <Lex297> <Connection_Name> rank => 0
<Gen3185_maybe> ::= <Gen3185> rank => 0
<Gen3185_maybe> ::= rank => -1
<Gen3188> ::= <Lex516> <Connection_User_Name> rank => 0
<Gen3188_maybe> ::= <Gen3188> rank => 0
<Gen3188_maybe> ::= rank => -1
<Connection_Target> ::= <Sql_Server_Name> <Gen3185_maybe> <Gen3188_maybe> rank => 0
                      | <Lex348> rank => -1
<Set_Connection_Statement> ::= <Lex482> <Lex554> <Connection_Object> rank => 0
<Connection_Object> ::= <Lex348> rank => 0
                      | <Connection_Name> rank => -1
<Disconnect_Statement> ::= <Lex353> <Disconnect_Object> rank => 0
<Disconnect_Object> ::= <Connection_Object> rank => 0
                      | <Lex290> rank => -1
                      | <Lex331> rank => -2
<Set_Session_Characteristics_Statement> ::= <Lex482> <Lex242> <Lex066> <Lex297> <Session_Characteristic_List> rank => 0
<Gen3201> ::= <Comma> <Session_Characteristic> rank => 0
<Gen3201_any> ::= <Gen3201>* rank => 0
<Session_Characteristic_List> ::= <Session_Characteristic> <Gen3201_any> rank => 0
<Session_Characteristic> ::= <Transaction_Characteristics> rank => 0
<Set_Session_User_Identifier_Statement> ::= <Lex482> <Lex242> <Lex302> <Value_Specification> rank => 0
<Set_Role_Statement> ::= <Lex482> <Lex223> <Role_Specification> rank => 0
<Role_Specification> ::= <Value_Specification> rank => 0
                       | <Lex427> rank => -1
<Set_Local_Time_Zone_Statement> ::= <Lex482> <Lex500> <Lex288> <Set_Time_Zone_Value> rank => 0
<Set_Time_Zone_Value> ::= <Interval_Value_Expression> rank => 0
                        | <Lex409> rank => -1
<Set_Catalog_Statement> ::= <Lex482> <Catalog_Name_Characteristic> rank => 0
<Catalog_Name_Characteristic> ::= <Lex061> <Value_Specification> rank => 0
<Set_Schema_Statement> ::= <Lex482> <Schema_Name_Characteristic> rank => 0
<Schema_Name_Characteristic> ::= <Lex231> <Value_Specification> rank => 0
<Set_Names_Statement> ::= <Lex482> <Character_Set_Name_Characteristic> rank => 0
<Character_Set_Name_Characteristic> ::= <Lex173> <Value_Specification> rank => 0
<Set_Path_Statement> ::= <Lex482> <SQL_Path_Characteristic> rank => 0
<SQL_Path_Characteristic> ::= <Lex201> <Value_Specification> rank => 0
<Set_Transform_Group_Statement> ::= <Lex482> <Transform_Group_Characteristic> rank => 0
<Transform_Group_Characteristic> ::= <Lex348> <Lex268> <Lex382> <Value_Specification> rank => 0
                                   | <Lex268> <Lex382> <Lex373> <Lex275> <Path_Resolved_User_Defined_Type_Name> <Value_Specification> rank => -1
<Gen3223> ::= <Lex373> <Character_Set_Specification_List> rank => 0
<Gen3223_maybe> ::= <Gen3223> rank => 0
<Gen3223_maybe> ::= rank => -1
<Gen3226> ::= <Lex373> <Character_Set_Specification_List> rank => 0
<Gen3226_maybe> ::= <Gen3226> rank => 0
<Gen3226_maybe> ::= rank => -1
<Set_Session_Collation_Statement> ::= <Lex482> <Lex078> <Collation_Specification> <Gen3223_maybe> rank => 0
                                    | <Lex482> <Lex426> <Lex078> <Gen3226_maybe> rank => -1
<Gen3231> ::= <Lex013> <Character_Set_Specification> rank => 0
<Gen3231_any> ::= <Gen3231>* rank => 0
<Character_Set_Specification_List> ::= <Character_Set_Specification> <Gen3231_any> rank => -1
<Collation_Specification> ::= <Value_Specification> rank => 0
<Lex488_maybe> ::= <Lex488> rank => 0
<Lex488_maybe> ::= rank => -1
<Gen3237> ::= <Lex529> <Lex162> <Occurrences> rank => 0
<Gen3237_maybe> ::= <Gen3237> rank => 0
<Gen3237_maybe> ::= rank => -1
<Allocate_Descriptor_Statement> ::= <Lex291> <Lex488_maybe> <Lex117> <Descriptor_Name> <Gen3237_maybe> rank => 0
<Occurrences> ::= <Simple_Value_Specification> rank => 0
<Deallocate_Descriptor_Statement> ::= <Lex344> <Lex488_maybe> <Lex117> <Descriptor_Name> rank => 0
<Get_Descriptor_Statement> ::= <Lex379> <Lex488_maybe> <Lex117> <Descriptor_Name> <Get_Descriptor_Information> rank => 0
<Gen3244> ::= <Comma> <Get_Header_Information> rank => 0
<Gen3244_any> ::= <Gen3244>* rank => 0
<Gen3246> ::= <Comma> <Get_Item_Information> rank => 0
<Gen3246_any> ::= <Gen3246>* rank => 0
<Get_Descriptor_Information> ::= <Get_Header_Information> <Gen3244_any> rank => 0
                               | <Lex518> <Item_Number> <Get_Item_Information> <Gen3246_any> rank => -1
<Get_Header_Information> ::= <Simple_Target_Specification_1> <Equals_Operator> <Header_Item_Name> rank => 0
<Header_Item_Name> ::= <Lex098> rank => 0
                     | <Lex153> rank => -1
                     | <Lex121> rank => -2
                     | <Lex122> rank => -3
                     | <Lex263> rank => -4
<Get_Item_Information> ::= <Simple_Target_Specification_2> <Equals_Operator> <Descriptor_Item_Name> rank => 0
<Item_Number> ::= <Simple_Value_Specification> rank => 0
<Simple_Target_Specification_1> ::= <Simple_Target_Specification> rank => 0
<Simple_Target_Specification_2> ::= <Simple_Target_Specification> rank => 0
<Descriptor_Item_Name> ::= <Lex059> rank => 0
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
<Set_Descriptor_Statement> ::= <Lex482> <Lex488_maybe> <Lex117> <Descriptor_Name> <Set_Descriptor_Information> rank => 0
<Gen3298> ::= <Comma> <Set_Header_Information> rank => 0
<Gen3298_any> ::= <Gen3298>* rank => 0
<Gen3300> ::= <Comma> <Set_Item_Information> rank => 0
<Gen3300_any> ::= <Gen3300>* rank => 0
<Set_Descriptor_Information> ::= <Set_Header_Information> <Gen3298_any> rank => 0
                               | <Lex518> <Item_Number> <Set_Item_Information> <Gen3300_any> rank => -1
<Set_Header_Information> ::= <Header_Item_Name> <Equals_Operator> <Simple_Value_Specification_1> rank => 0
<Set_Item_Information> ::= <Descriptor_Item_Name> <Equals_Operator> <Simple_Value_Specification_2> rank => 0
<Simple_Value_Specification_1> ::= <Simple_Value_Specification> rank => 0
<Simple_Value_Specification_2> ::= <Simple_Value_Specification> rank => 0
<Attributes_Specification_maybe> ::= <Attributes_Specification> rank => 0
<Attributes_Specification_maybe> ::= rank => -1
<Prepare_Statement> ::= <Lex446> <SQL_Statement_Name> <Attributes_Specification_maybe> <Lex376> <SQL_Statement_Variable> rank => 0
<Attributes_Specification> ::= <Lex053> <Attributes_Variable> rank => 0
<Attributes_Variable> ::= <Simple_Value_Specification> rank => 0
<SQL_Statement_Variable> ::= <Simple_Value_Specification> rank => 0
<Preparable_Statement> ::= <Preparable_SQL_Data_Statement> rank => 0
                         | <Preparable_SQL_Schema_Statement> rank => -1
                         | <Preparable_SQL_Transaction_Statement> rank => -2
                         | <Preparable_SQL_Control_Statement> rank => -3
                         | <Preparable_SQL_Session_Statement> rank => -4
<Preparable_SQL_Data_Statement> ::= <Delete_Statement_Searched> rank => 0
                                  | <Dynamic_Single_Row_Select_Statement> rank => -1
                                  | <Insert_Statement> rank => -2
                                  | <Dynamic_Select_Statement> rank => -3
                                  | <Update_Statement_Searched> rank => -4
                                  | <Merge_Statement> rank => -5
                                  | <Preparable_Dynamic_Delete_Statement_Positioned> rank => -6
                                  | <Preparable_Dynamic_Update_Statement_Positioned> rank => -7
<Preparable_SQL_Schema_Statement> ::= <SQL_Schema_Statement> rank => 0
<Preparable_SQL_Transaction_Statement> ::= <SQL_Transaction_Statement> rank => 0
<Preparable_SQL_Control_Statement> ::= <SQL_Control_Statement> rank => 0
<Preparable_SQL_Session_Statement> ::= <SQL_Session_Statement> rank => 0
<Dynamic_Select_Statement> ::= <Cursor_Specification> rank => 0
<Cursor_Attribute_many> ::= <Cursor_Attribute>+ rank => 0
<Cursor_Attributes> ::= <Cursor_Attribute_many> rank => 0
<Cursor_Attribute> ::= <Cursor_Sensitivity> rank => 0
                     | <Cursor_Scrollability> rank => -1
                     | <Cursor_Holdability> rank => -2
                     | <Cursor_Returnability> rank => -3
<Deallocate_Prepared_Statement> ::= <Lex344> <Lex446> <SQL_Statement_Name> rank => 0
<Describe_Statement> ::= <Describe_Input_Statement> rank => 0
                       | <Describe_Output_Statement> rank => -1
<Nesting_Option_maybe> ::= <Nesting_Option> rank => 0
<Nesting_Option_maybe> ::= rank => -1
<Describe_Input_Statement> ::= <Lex351> <Lex393> <SQL_Statement_Name> <Using_Descriptor> <Nesting_Option_maybe> rank => 0
<Lex440_maybe> ::= <Lex440> rank => 0
<Lex440_maybe> ::= rank => -1
<Describe_Output_Statement> ::= <Lex351> <Lex440_maybe> <Described_Object> <Using_Descriptor> <Nesting_Option_maybe> rank => 0
<Nesting_Option> ::= <Lex529> <Lex174> rank => 0
                   | <Lex531> <Lex174> rank => -1
<Using_Descriptor> ::= <Lex517> <Lex488_maybe> <Lex117> <Descriptor_Name> rank => 0
<Described_Object> ::= <SQL_Statement_Name> rank => 0
                     | <Lex340> <Extended_Cursor_Name> <Lex254> rank => -1
<Input_Using_Clause> ::= <Using_Arguments> rank => 0
                       | <Using_Input_Descriptor> rank => -1
<Gen3354> ::= <Comma> <Using_Argument> rank => 0
<Gen3354_any> ::= <Gen3354>* rank => 0
<Using_Arguments> ::= <Lex517> <Using_Argument> <Gen3354_any> rank => 0
<Using_Argument> ::= <General_Value_Specification> rank => 0
<Using_Input_Descriptor> ::= <Using_Descriptor> rank => 0
<Output_Using_Clause> ::= <Into_Arguments> rank => 0
                        | <Into_Descriptor> rank => -1
<Gen3361> ::= <Comma> <Into_Argument> rank => 0
<Gen3361_any> ::= <Gen3361>* rank => 0
<Into_Arguments> ::= <Lex400> <Into_Argument> <Gen3361_any> rank => 0
<Into_Argument> ::= <Target_Specification> rank => 0
<Into_Descriptor> ::= <Lex400> <Lex488_maybe> <Lex117> <Descriptor_Name> rank => 0
<Result_Using_Clause_maybe> ::= <Result_Using_Clause> rank => 0
<Result_Using_Clause_maybe> ::= rank => -1
<Parameter_Using_Clause_maybe> ::= <Parameter_Using_Clause> rank => 0
<Parameter_Using_Clause_maybe> ::= rank => -1
<Execute_Statement> ::= <Lex366> <SQL_Statement_Name> <Result_Using_Clause_maybe> <Parameter_Using_Clause_maybe> rank => 0
<Result_Using_Clause> ::= <Output_Using_Clause> rank => 0
<Parameter_Using_Clause> ::= <Input_Using_Clause> rank => 0
<Execute_Immediate_Statement> ::= <Lex366> <Lex388> <SQL_Statement_Variable> rank => 0
<Dynamic_Declare_Cursor> ::= <Lex347> <Cursor_Name> <Cursor_Sensitivity_maybe> <Cursor_Scrollability_maybe> <Lex340> <Cursor_Holdability_maybe> <Cursor_Returnability_maybe> <Lex373> <Statement_Name> rank => 0
<Allocate_Cursor_Statement> ::= <Lex291> <Extended_Cursor_Name> <Cursor_Intent> rank => 0
<Cursor_Intent> ::= <Statement_Cursor> rank => 0
                  | <Result_Set_Cursor> rank => -1
<Statement_Cursor> ::= <Cursor_Sensitivity_maybe> <Cursor_Scrollability_maybe> <Lex340> <Cursor_Holdability_maybe> <Cursor_Returnability_maybe> <Lex373> <Extended_Statement_Name> rank => 0
<Result_Set_Cursor> ::= <Lex373> <Lex448> <Specific_Routine_Designator> rank => 0
<Input_Using_Clause_maybe> ::= <Input_Using_Clause> rank => 0
<Input_Using_Clause_maybe> ::= rank => -1
<Dynamic_Open_Statement> ::= <Lex435> <Dynamic_Cursor_Name> <Input_Using_Clause_maybe> rank => 0
<Gen3383> ::= <Fetch_Orientation_maybe> <Lex376> rank => 0
<Gen3383_maybe> ::= <Gen3383> rank => 0
<Gen3383_maybe> ::= rank => -1
<Dynamic_Fetch_Statement> ::= <Lex370> <Gen3383_maybe> <Dynamic_Cursor_Name> <Output_Using_Clause> rank => 0
<Dynamic_Single_Row_Select_Statement> ::= <Query_Specification> rank => 0
<Dynamic_Close_Statement> ::= <Lex320> <Dynamic_Cursor_Name> rank => 0
<Dynamic_Delete_Statement_Positioned> ::= <Lex349> <Lex376> <Target_Table> <Lex526> <Lex331> <Lex431> <Dynamic_Cursor_Name> rank => 0
<Dynamic_Update_Statement_Positioned> ::= <Lex514> <Target_Table> <Lex482> <Set_Clause_List> <Lex526> <Lex331> <Lex431> <Dynamic_Cursor_Name> rank => 0
<Gen3391> ::= <Lex376> <Target_Table> rank => 0
<Gen3391_maybe> ::= <Gen3391> rank => 0
<Gen3391_maybe> ::= rank => -1
<Preparable_Dynamic_Delete_Statement_Positioned> ::= <Lex349> <Gen3391_maybe> <Lex526> <Lex331> <Lex431> <Scope_Option_maybe> <Cursor_Name> rank => 0
<Target_Table_maybe> ::= <Target_Table> rank => 0
<Target_Table_maybe> ::= rank => -1
<Preparable_Dynamic_Update_Statement_Positioned> ::= <Lex514> <Target_Table_maybe> <Lex482> <Set_Clause_List> <Lex526> <Lex331> <Lex431> <Scope_Option_maybe> <Cursor_Name> rank => 0
<Embedded_SQL_Host_Program> ::= <Embedded_SQL_Ada_Program> rank => 0
                              | <Embedded_SQL_C_Program> rank => -1
                              | <Embedded_SQL_Cobol_Program> rank => -2
                              | <Embedded_SQL_Fortran_Program> rank => -3
                              | <Embedded_SQL_Mumps_Program> rank => -4
                              | <Embedded_SQL_Pascal_Program> rank => -5
                              | <Embedded_SQL_Pl_I_Program> rank => -6
<SQL_Terminator_maybe> ::= <SQL_Terminator> rank => 0
<SQL_Terminator_maybe> ::= rank => -1
<Embedded_SQL_Statement> ::= <SQL_Prefix> <Statement_Or_Declaration> <SQL_Terminator_maybe> rank => 0
<Statement_Or_Declaration> ::= <Declare_Cursor> rank => 0
                             | <Dynamic_Declare_Cursor> rank => -1
                             | <Temporary_Table_Declaration> rank => -2
                             | <Embedded_Authorization_Declaration> rank => -3
                             | <Embedded_Path_Specification> rank => -4
                             | <Embedded_Transform_Group_Specification> rank => -5
                             | <Embedded_Collation_Specification> rank => -6
                             | <Embedded_Exception_Declaration> rank => -7
                             | <SQL_Procedure_Statement> rank => -8
<SQL_Prefix> ::= <Lex365> <Lex488> rank => 0
               | <Ampersand> <Lex488> <Left_Paren> rank => -1
<SQL_Terminator> ::= <Lex362> rank => 0
                   | <Semicolon> rank => -1
                   | <Right_Paren> rank => -2
<Embedded_Authorization_Declaration> ::= <Lex347> <Embedded_Authorization_Clause> rank => 0
<Gen3423> ::= <Lex434> rank => 0
            | <Lex293> <Lex357> rank => -1
<Gen3425> ::= <Lex373> <Lex493> <Gen3423> rank => 0
<Gen3425_maybe> ::= <Gen3425> rank => 0
<Gen3425_maybe> ::= rank => -1
<Gen3428> ::= <Lex434> rank => 0
            | <Lex293> <Lex357> rank => -1
<Gen3430> ::= <Lex373> <Lex493> <Gen3428> rank => 0
<Gen3430_maybe> ::= <Gen3430> rank => 0
<Gen3430_maybe> ::= rank => -1
<Embedded_Authorization_Clause> ::= <Lex231> <Schema_Name> rank => 0
                                  | <Lex302> <Embedded_Authorization_Identifier> <Gen3425_maybe> rank => -1
                                  | <Lex231> <Schema_Name> <Lex302> <Embedded_Authorization_Identifier> <Gen3430_maybe> rank => -2
<Embedded_Authorization_Identifier> ::= <Module_Authorization_Identifier> rank => 0
<Embedded_Path_Specification> ::= <Path_Specification> rank => 0
<Embedded_Transform_Group_Specification> ::= <Transform_Group_Specification> rank => 0
<Embedded_Collation_Specification> ::= <Module_Collations> rank => 0
<Embedded_Character_Set_Declaration_maybe> ::= <Embedded_Character_Set_Declaration> rank => 0
<Embedded_Character_Set_Declaration_maybe> ::= rank => -1
<Host_Variable_Definition_any> ::= <Host_Variable_Definition>* rank => 0
<Embedded_SQL_Declare_Section> ::= <Embedded_SQL_Begin_Declare> <Embedded_Character_Set_Declaration_maybe> <Host_Variable_Definition_any> <Embedded_SQL_End_Declare> rank => 0
                                 | <Embedded_SQL_Mumps_Declare> rank => -1
<Embedded_Character_Set_Declaration> ::= <Lex488> <Lex173> <Lex295> <Character_Set_Specification> rank => 0
<Embedded_SQL_Begin_Declare> ::= <SQL_Prefix> <Lex303> <Lex347> <Lex236> <SQL_Terminator_maybe> rank => 0
<Embedded_SQL_End_Declare> ::= <SQL_Prefix> <Lex361> <Lex347> <Lex236> <SQL_Terminator_maybe> rank => 0
<Embedded_SQL_Mumps_Declare> ::= <SQL_Prefix> <Lex303> <Lex347> <Lex236> <Embedded_Character_Set_Declaration_maybe> <Host_Variable_Definition_any> <Lex361> <Lex347> <Lex236> <SQL_Terminator> rank => 0
<Host_Variable_Definition> ::= <Ada_Variable_Definition> rank => 0
                             | <C_Variable_Definition> rank => -1
                             | <Cobol_Variable_Definition> rank => -2
                             | <Fortran_Variable_Definition> rank => -3
                             | <Mumps_Variable_Definition> rank => -4
                             | <Pascal_Variable_Definition> rank => -5
                             | <Pl_I_Variable_Definition> rank => -6
<Embedded_Variable_Name> ::= <Colon> <Host_Identifier> rank => 0
<Host_Identifier> ::= <Ada_Host_Identifier> rank => 0
                    | <C_Host_Identifier> rank => -1
                    | <Cobol_Host_Identifier> rank => -2
                    | <Fortran_Host_Identifier> rank => -3
                    | <Mumps_Host_Identifier> rank => -4
                    | <Pascal_Host_Identifier> rank => -5
                    | <Pl_I_Host_Identifier> rank => -6
<Embedded_Exception_Declaration> ::= <Lex525> <Condition> <Condition_Action> rank => 0
<Condition> ::= <SQL_Condition> rank => 0
<Gen3466> ::= <Lex013> <Sqlstate_Subclass_Value> rank => 0
<Gen3466_maybe> ::= <Gen3466> rank => 0
<Gen3466_maybe> ::= rank => -1
<Gen3469> ::= <Sqlstate_Class_Value> <Gen3466_maybe> rank => 0
<SQL_Condition> ::= <Major_Category> rank => 0
                  | <Lex490> <Gen3469> rank => -1
                  | <Lex325> <Constraint_Name> rank => -2
<Major_Category> ::= <Lex489> rank => 0
                   | <Lex491> rank => -1
                   | <Lex428> <Lex135> rank => -2
<Sqlstate_Class_Value> ::= <Sqlstate_Char> <Sqlstate_Char> rank => 0
<Sqlstate_Subclass_Value> ::= <Sqlstate_Char> <Sqlstate_Char> <Sqlstate_Char> rank => 0
<Sqlstate_Char> ::= <Simple_Latin_Upper_Case_Letter> rank => 0
                  | <Digit> rank => -1
<Condition_Action> ::= <Lex326> rank => 0
                     | <Go_To> rank => -1
<Gen3482> ::= <Lex139> rank => 0
            | <Lex138> <Lex504> rank => -1
<Go_To> ::= <Gen3482> <Goto_Target> rank => 0
<Goto_Target> ::= <Unsigned_Integer> rank => 0
<Embedded_SQL_Ada_Program> ::= <Lex365> <Lex488> rank => 0
<Gen3487> ::= <Comma> <Ada_Host_Identifier> rank => 0
<Gen3487_any> ::= <Gen3487>* rank => 0
<Ada_Initial_Value_maybe> ::= <Ada_Initial_Value> rank => 0
<Ada_Initial_Value_maybe> ::= rank => -1
<Ada_Variable_Definition> ::= <Ada_Host_Identifier> <Gen3487_any> <Colon> <Ada_Type_Specification> <Ada_Initial_Value_maybe> rank => 0
<Character_Representation_many> ::= <Character_Representation>+ rank => 0
<Ada_Initial_Value> ::= <Ada_Assignment_Operator> <Character_Representation_many> rank => 0
<Ada_Assignment_Operator> ::= <Colon> <Equals_Operator> rank => 0
<Underscore_maybe> ::= <Underscore> rank => 0
<Underscore_maybe> ::= rank => -1
<Gen3497> ::= <Ada_Host_Identifier_Letter> rank => 0
            | <Digit> rank => -1
<Gen3499> ::= <Underscore_maybe> <Gen3497> rank => 0
<Gen3499_any> ::= <Gen3499>* rank => 0
<Ada_Host_Identifier> ::= <Ada_Host_Identifier_Letter> <Gen3499_any> rank => 0
<Ada_Host_Identifier_Letter> ::= <Simple_Latin_Letter> rank => 0
<Ada_Type_Specification> ::= <Ada_Qualified_Type_Specification> rank => 0
                           | <Ada_Unqualified_Type_Specification> rank => -1
                           | <Ada_Derived_Type_Specification> rank => -2
<Lex401_maybe> ::= <Lex401> rank => 0
<Lex401_maybe> ::= rank => -1
<Gen3508> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3508_maybe> ::= <Gen3508> rank => 0
<Gen3508_maybe> ::= rank => -1
<Ada_Qualified_Type_Specification> ::= <Lex555> <Period> <Lex316> <Gen3508_maybe> <Left_Paren> <Lex556> <Double_Period> <Length> <Right_Paren> rank => 0
                                     | <Lex555> <Period> <Lex484> rank => -1
                                     | <Lex555> <Period> <Lex396> rank => -2
                                     | <Lex555> <Period> <Lex305> rank => -3
                                     | <Lex555> <Period> <Lex451> rank => -4
                                     | <Lex555> <Period> <Lex557> rank => -5
                                     | <Lex555> <Period> <Lex308> rank => -6
                                     | <Lex555> <Period> <Lex558> rank => -7
                                     | <Lex555> <Period> <Lex559> rank => -8
<Ada_Unqualified_Type_Specification> ::= <Lex316> <Left_Paren> <Lex556> <Double_Period> <Length> <Right_Paren> rank => 0
                                       | <Lex484> rank => -1
                                       | <Lex396> rank => -2
                                       | <Lex305> rank => -3
                                       | <Lex451> rank => -4
                                       | <Lex557> rank => -5
                                       | <Lex308> rank => -6
                                       | <Lex558> rank => -7
                                       | <Lex559> rank => -8
<Ada_Derived_Type_Specification> ::= <Ada_Clob_Variable> rank => 0
                                   | <Ada_Clob_Locator_Variable> rank => -1
                                   | <Ada_Blob_Variable> rank => -2
                                   | <Ada_Blob_Locator_Variable> rank => -3
                                   | <Ada_User_Defined_Type_Variable> rank => -4
                                   | <Ada_User_Defined_Type_Locator_Variable> rank => -5
                                   | <Ada_Ref_Variable> rank => -6
                                   | <Ada_Array_Locator_Variable> rank => -7
                                   | <Ada_Multiset_Locator_Variable> rank => -8
<Gen3538> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3538_maybe> ::= <Gen3538> rank => 0
<Gen3538_maybe> ::= rank => -1
<Ada_Clob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3538_maybe> rank => 0
<Ada_Clob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Ada_Blob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Ada_Blob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Ada_User_Defined_Type_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Predefined_Type> rank => 0
<Ada_User_Defined_Type_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Lex158> rank => 0
<Ada_Ref_Variable> ::= <Lex488> <Lex275> <Lex401> <Reference_Type> rank => 0
<Ada_Array_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Array_Type> <Lex297> <Lex158> rank => 0
<Ada_Multiset_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset_Type> <Lex297> <Lex158> rank => 0
<Embedded_SQL_C_Program> ::= <Lex365> <Lex488> rank => 0
<C_Storage_Class_maybe> ::= <C_Storage_Class> rank => 0
<C_Storage_Class_maybe> ::= rank => -1
<C_Class_Modifier_maybe> ::= <C_Class_Modifier> rank => 0
<C_Class_Modifier_maybe> ::= rank => -1
<C_Variable_Definition> ::= <C_Storage_Class_maybe> <C_Class_Modifier_maybe> <C_Variable_Specification> <Semicolon> rank => 0
<C_Variable_Specification> ::= <C_Numeric_Variable> rank => 0
                             | <C_Character_Variable> rank => -1
                             | <C_Derived_Variable> rank => -2
<C_Storage_Class> ::= <Lex560> rank => 0
                    | <Lex561> rank => -1
                    | <Lex562> rank => -2
<C_Class_Modifier> ::= <Lex563> rank => 0
                     | <Lex564> rank => -1
<Gen3564> ::= <Lex565> <Lex565> rank => 0
            | <Lex565> rank => -1
            | <Lex566> rank => -2
            | <Lex567> rank => -3
            | <Lex568> rank => -4
<C_Initial_Value_maybe> ::= <C_Initial_Value> rank => 0
<C_Initial_Value_maybe> ::= rank => -1
<Gen3571> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3571_any> ::= <Gen3571>* rank => 0
<C_Numeric_Variable> ::= <Gen3564> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3571_any> rank => 0
<Gen3574> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3574_maybe> ::= <Gen3574> rank => 0
<Gen3574_maybe> ::= rank => -1
<Gen3577> ::= <Comma> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> rank => 0
<Gen3577_any> ::= <Gen3577>* rank => 0
<C_Character_Variable> ::= <C_Character_Type> <Gen3574_maybe> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> <Gen3577_any> rank => 0
<C_Character_Type> ::= <Lex569> rank => 0
                     | <Lex570> <Lex569> rank => -1
                     | <Lex570> <Lex566> rank => -2
<C_Array_Specification> ::= <Left_Bracket> <Length> <Right_Bracket> rank => 0
<C_Host_Identifier> ::= <Regular_Identifier> rank => 0
<C_Derived_Variable> ::= <C_Varchar_Variable> rank => 0
                       | <C_Nchar_Variable> rank => -1
                       | <C_Nchar_Varying_Variable> rank => -2
                       | <C_Clob_Variable> rank => -3
                       | <C_Nclob_Variable> rank => -4
                       | <C_Blob_Variable> rank => -5
                       | <C_User_Defined_Type_Variable> rank => -6
                       | <C_Clob_Locator_Variable> rank => -7
                       | <C_Blob_Locator_Variable> rank => -8
                       | <C_Array_Locator_Variable> rank => -9
                       | <C_Multiset_Locator_Variable> rank => -10
                       | <C_User_Defined_Type_Locator_Variable> rank => -11
                       | <C_Ref_Variable> rank => -12
<Gen3598> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3598_maybe> ::= <Gen3598> rank => 0
<Gen3598_maybe> ::= rank => -1
<Gen3601> ::= <Comma> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> rank => 0
<Gen3601_any> ::= <Gen3601>* rank => 0
<C_Varchar_Variable> ::= <Lex522> <Gen3598_maybe> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> <Gen3601_any> rank => 0
<Gen3604> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3604_maybe> ::= <Gen3604> rank => 0
<Gen3604_maybe> ::= rank => -1
<Gen3607> ::= <Comma> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> rank => 0
<Gen3607_any> ::= <Gen3607>* rank => 0
<C_Nchar_Variable> ::= <Lex423> <Gen3604_maybe> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> <Gen3607_any> rank => 0
<Gen3610> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3610_maybe> ::= <Gen3610> rank => 0
<Gen3610_maybe> ::= rank => -1
<Gen3613> ::= <Comma> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> rank => 0
<Gen3613_any> ::= <Gen3613>* rank => 0
<C_Nchar_Varying_Variable> ::= <Lex423> <Lex523> <Gen3610_maybe> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> <Gen3613_any> rank => 0
<Gen3616> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3616_maybe> ::= <Gen3616> rank => 0
<Gen3616_maybe> ::= rank => -1
<Gen3619> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3619_any> ::= <Gen3619>* rank => 0
<C_Clob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3616_maybe> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3619_any> rank => 0
<Gen3622> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3622_maybe> ::= <Gen3622> rank => 0
<Gen3622_maybe> ::= rank => -1
<Gen3625> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3625_any> ::= <Gen3625>* rank => 0
<C_Nclob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex424> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3622_maybe> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3625_any> rank => 0
<Gen3628> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3628_any> ::= <Gen3628>* rank => 0
<C_User_Defined_Type_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Predefined_Type> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3628_any> rank => 0
<Gen3631> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3631_any> ::= <Gen3631>* rank => 0
<C_Blob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left_Paren> <Large_Object_Length> <Right_Paren> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3631_any> rank => 0
<Gen3634> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3634_any> ::= <Gen3634>* rank => 0
<C_Clob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3634_any> rank => 0
<Gen3637> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3637_any> ::= <Gen3637>* rank => 0
<C_Blob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3637_any> rank => 0
<Gen3640> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3640_any> ::= <Gen3640>* rank => 0
<C_Array_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Array_Type> <Lex297> <Lex158> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3640_any> rank => 0
<Gen3643> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3643_any> ::= <Gen3643>* rank => 0
<C_Multiset_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset_Type> <Lex297> <Lex158> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3643_any> rank => 0
<Gen3646> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe> rank => 0
<Gen3646_any> ::= <Gen3646>* rank => 0
<C_User_Defined_Type_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Lex158> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3646_any> rank => 0
<C_Ref_Variable> ::= <Lex488> <Lex275> <Lex401> <Reference_Type> rank => 0
<C_Initial_Value> ::= <Equals_Operator> <Character_Representation_many> rank => 0
<Embedded_SQL_Cobol_Program> ::= <Lex365> <Lex488> rank => 0
<Gen3652> ::= <Lex571> rank => 0
            | <Lex572> rank => -1
<Cobol_Variable_Definition> ::= <Gen3652> <Cobol_Host_Identifier> <Cobol_Type_Specification> <Character_Representation_any> <Period> rank => 0
<Gen3655> ::= <Lex009> <Cobol_Subscript> <Lex010> rank => 0
<Gen3655_any> ::= <Gen3655>* rank => 0
<Cobol_Length_maybe> ::= <Cobol_Length> rank => 0
<Cobol_Length_maybe> ::= rank => -1
<Gen3659> ::= <Lex009> <Cobol_Leftmost_Character_Position> <Lex017> <Cobol_Length_maybe> <Lex010> rank => 0
<Gen3659_maybe> ::= <Gen3659> rank => 0
<Gen3659_maybe> ::= rank => -1
<Cobol_Host_Identifier> ::= <Cobol_Qualified_Data_Name> <Gen3655_any> <Gen3659_maybe> rank => 0
<Gen3663> ::= <Lex389> rank => 0
            | <Lex431> rank => -1
<Gen3665> ::= <Gen3663> <Cobol_Data_Name> rank => 0
<Gen3665_any> ::= <Gen3665>* rank => 0
<Gen3667> ::= <Lex389> rank => 0
            | <Lex431> rank => -1
<Gen3669> ::= <Gen3667> <Cobol_File_Name> rank => 0
<Gen3669_maybe> ::= <Gen3669> rank => 0
<Gen3669_maybe> ::= rank => -1
<Cobol_Qualified_Data_Name> ::= <Cobol_Data_Name> <Gen3665_any> <Gen3669_maybe> rank => 0
<Cobol_Data_Name> ::= <Cobol_Alphabetic_User_Defined_Word> rank => 0
<Gen3674> ::= <Lex573_many> rank => 0
<Gen3674> ::= rank => -1
<Gen3676> ::= <Digit_many> <Gen3674> rank => 0
<Gen3676_any> ::= <Gen3676>* rank => 0
<Digit_any> ::= <Digit>* rank => 0
<Gen3679> ::= <Lex575_many> rank => 0
<Gen3679> ::= rank => -1
<Gen3681> ::= <Lex576_many> <Lex577_many> rank => 0
<Gen3681_any> ::= <Gen3681>* rank => 0
<Cobol_Alphabetic_User_Defined_Word> ::= <Gen3676_any> <Digit_any> <Lex574> <Gen3679> <Gen3681_any> rank => 0
<Cobol_File_Name> ::= <Cobol_Alphabetic_User_Defined_Word> rank => 0
<Gen3685> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3687> ::= <Gen3685> <Cobol_Integer> rank => 0
<Gen3687_maybe> ::= <Gen3687> rank => 0
<Gen3687_maybe> ::= rank => -1
<Gen3690> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3692> ::= <Gen3690> <Cobol_Integer> rank => 0
<Gen3692_maybe> ::= <Gen3692> rank => 0
<Gen3692_maybe> ::= rank => -1
<Gen3695> ::= <Cobol_Integer> rank => 0
            | <Cobol_Qualified_Data_Name> <Gen3687_maybe> rank => -1
            | <Cobol_Index_Name> <Gen3692_maybe> rank => -2
<Gen3695_many> ::= <Gen3695>+ rank => 0
<Cobol_Subscript> ::= <Gen3695_many> rank => 0
<Gen3700> ::= <Lex578_many> rank => 0
<Gen3700> ::= rank => -1
<Cobol_Integer> ::= <Gen3700> <Lex579> <Digit_any> rank => 0
<Cobol_Index_Name> ::= <Cobol_Alphabetic_User_Defined_Word> rank => 0
<Gen3704> ::= <Lex389> rank => 0
            | <Lex431> rank => -1
<Gen3706> ::= <Gen3704> <Cobol_File_Name> rank => 0
<Gen3706_maybe> ::= <Gen3706> rank => 0
<Gen3706_maybe> ::= rank => -1
<Cobol_Host_Identifier> ::= <Lex580> <Gen3706_maybe> rank => -1
<Cobol_Leftmost_Character_Position> ::= <Cobol_Arithmetic_Expression> rank => 0
<Cobol_Length> ::= <Cobol_Arithmetic_Expression> rank => 0
<Gen3712> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3714> ::= <Gen3712> <Cobol_Times_Div> rank => 0
<Gen3714_any> ::= <Gen3714>* rank => 0
<Cobol_Arithmetic_Expression> ::= <Cobol_Times_Div> <Gen3714_any> rank => 0
<Gen3717> ::= <Lex011> rank => 0
            | <Lex016> rank => -1
<Gen3719> ::= <Gen3717> <Cobol_Power> rank => 0
<Gen3719_any> ::= <Gen3719>* rank => 0
<Cobol_Times_Div> ::= <Cobol_Power> <Gen3719_any> rank => 0
<Gen3722> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3724> ::= <Gen3722> rank => 0
<Gen3724_maybe> ::= <Gen3724> rank => 0
<Gen3724_maybe> ::= rank => -1
<Gen3727> ::= <Lex581> <Cobol_Basis> rank => 0
<Gen3727_any> ::= <Gen3727>* rank => 0
<Cobol_Power> ::= <Gen3724_maybe> <Cobol_Basis> <Gen3727_any> rank => 0
<Cobol_Basis> ::= <Cobol_Host_Identifier> rank => 0
                | <Cobol_Literal> rank => -1
                | <Lex009> <Cobol_Arithmetic_Expression> <Lex010> rank => -2
<Cobol_Literal> ::= <Cobol_Nonnumeric> rank => 0
                  | <Cobol_Numeric> rank => -1
                  | <Cobol_Figurative_Constant> rank => -2
<Gen3736> ::= <Lex038> rank => 0
            | <Lex005> <Lex005> rank => -1
<Gen3736_any> ::= <Gen3736>* rank => 0
<Gen3739> ::= <Lex533> rank => 0
            | <Lex008> <Lex008> rank => -1
<Gen3739_any> ::= <Gen3739>* rank => 0
<Cobol_Nonnumeric> ::= <Lex005> <Gen3736_any> <Lex005> rank => 0
                     | <Lex008> <Gen3739_any> <Lex008> rank => -1
                     | <Lex535> <Lex005> <Cobol_Hexdigits> <Lex005> rank => -2
                     | <Lex535> <Lex008> <Cobol_Hexdigits> <Lex008> rank => -3
<Cobol_Hexdigits> ::= <Lex582_many> rank => 0
<Gen3747> ::= <Lex012> rank => 0
            | <Lex014> rank => -1
<Gen3747_maybe> ::= <Gen3747> rank => 0
<Gen3747_maybe> ::= rank => -1
<Gen3751> ::= <Digit_any> <Lex015> <Digit_many> rank => 0
            | <Digit_many> rank => -1
<Cobol_Numeric> ::= <Gen3747_maybe> <Gen3751> rank => 0
<Cobol_Figurative_Constant> ::= <Lex583> rank => 0
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
                              | <Lex290> <Cobol_Literal> rank => -11
                              | <Lex429> rank => -12
                              | <Lex180> rank => -13
<Cobol_Type_Specification> ::= <Cobol_Character_Type> rank => 0
                             | <Cobol_National_Character_Type> rank => -1
                             | <Cobol_Numeric_Type> rank => -2
                             | <Cobol_Integer_Type> rank => -3
                             | <Cobol_Derived_Type_Specification> rank => -4
<Cobol_Derived_Type_Specification> ::= <Cobol_Clob_Variable> rank => 0
                                     | <Cobol_Nclob_Variable> rank => -1
                                     | <Cobol_Blob_Variable> rank => -2
                                     | <Cobol_User_Defined_Type_Variable> rank => -3
                                     | <Cobol_Clob_Locator_Variable> rank => -4
                                     | <Cobol_Blob_Locator_Variable> rank => -5
                                     | <Cobol_Array_Locator_Variable> rank => -6
                                     | <Cobol_Multiset_Locator_Variable> rank => -7
                                     | <Cobol_User_Defined_Type_Locator_Variable> rank => -8
                                     | <Cobol_Ref_Variable> rank => -9
<Gen3783> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3783_maybe> ::= <Gen3783> rank => 0
<Gen3783_maybe> ::= rank => -1
<Gen3786> ::= <Lex593> rank => 0
            | <Lex594> rank => -1
<Gen3788> ::= <Left_Paren> <Length> <Right_Paren> rank => 0
<Gen3788_maybe> ::= <Gen3788> rank => 0
<Gen3788_maybe> ::= rank => -1
<Gen3791> ::= <Lex535> <Gen3788_maybe> rank => 0
<Gen3791_many> ::= <Gen3791>+ rank => 0
<Cobol_Character_Type> ::= <Gen3783_maybe> <Gen3786> <Lex401_maybe> <Gen3791_many> rank => 0
<Gen3794> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3794_maybe> ::= <Gen3794> rank => 0
<Gen3794_maybe> ::= rank => -1
<Gen3797> ::= <Lex593> rank => 0
            | <Lex594> rank => -1
<Gen3799> ::= <Left_Paren> <Length> <Right_Paren> rank => 0
<Gen3799_maybe> ::= <Gen3799> rank => 0
<Gen3799_maybe> ::= rank => -1
<Gen3802> ::= <Lex534> <Gen3799_maybe> rank => 0
<Gen3802_many> ::= <Gen3802>+ rank => 0
<Cobol_National_Character_Type> ::= <Gen3794_maybe> <Gen3797> <Lex401_maybe> <Gen3802_many> rank => 0
<Gen3805> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3805_maybe> ::= <Gen3805> rank => 0
<Gen3805_maybe> ::= rank => -1
<Gen3808> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3808_maybe> ::= <Gen3808> rank => 0
<Gen3808_maybe> ::= rank => -1
<Cobol_Clob_Variable> ::= <Gen3805_maybe> <Lex488> <Lex275> <Lex401> <Lex319> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3808_maybe> rank => 0
<Gen3812> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3812_maybe> ::= <Gen3812> rank => 0
<Gen3812_maybe> ::= rank => -1
<Gen3815> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3815_maybe> ::= <Gen3815> rank => 0
<Gen3815_maybe> ::= rank => -1
<Cobol_Nclob_Variable> ::= <Gen3812_maybe> <Lex488> <Lex275> <Lex401> <Lex424> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3815_maybe> rank => 0
<Gen3819> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3819_maybe> ::= <Gen3819> rank => 0
<Gen3819_maybe> ::= rank => -1
<Cobol_Blob_Variable> ::= <Gen3819_maybe> <Lex488> <Lex275> <Lex401> <Lex307> <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Gen3823> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3823_maybe> ::= <Gen3823> rank => 0
<Gen3823_maybe> ::= rank => -1
<Cobol_User_Defined_Type_Variable> ::= <Gen3823_maybe> <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Predefined_Type> rank => 0
<Gen3827> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3827_maybe> ::= <Gen3827> rank => 0
<Gen3827_maybe> ::= rank => -1
<Cobol_Clob_Locator_Variable> ::= <Gen3827_maybe> <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Gen3831> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3831_maybe> ::= <Gen3831> rank => 0
<Gen3831_maybe> ::= rank => -1
<Cobol_Blob_Locator_Variable> ::= <Gen3831_maybe> <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Gen3835> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3835_maybe> ::= <Gen3835> rank => 0
<Gen3835_maybe> ::= rank => -1
<Cobol_Array_Locator_Variable> ::= <Gen3835_maybe> <Lex488> <Lex275> <Lex401> <Array_Type> <Lex297> <Lex158> rank => 0
<Gen3839> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3839_maybe> ::= <Gen3839> rank => 0
<Gen3839_maybe> ::= rank => -1
<Cobol_Multiset_Locator_Variable> ::= <Gen3839_maybe> <Lex488> <Lex275> <Lex401> <Multiset_Type> <Lex297> <Lex158> rank => 0
<Gen3843> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3843_maybe> ::= <Gen3843> rank => 0
<Gen3843_maybe> ::= rank => -1
<Cobol_User_Defined_Type_Locator_Variable> ::= <Gen3843_maybe> <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Lex158> rank => 0
<Gen3847> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3847_maybe> ::= <Gen3847> rank => 0
<Gen3847_maybe> ::= rank => -1
<Cobol_Ref_Variable> ::= <Gen3847_maybe> <Lex488> <Lex275> <Lex401> <Reference_Type> rank => 0
<Gen3851> ::= <Lex593> rank => 0
            | <Lex594> rank => -1
<Gen3853> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3853_maybe> ::= <Gen3853> rank => 0
<Gen3853_maybe> ::= rank => -1
<Cobol_Numeric_Type> ::= <Gen3851> <Lex401_maybe> <Lex595> <Cobol_Nines_Specification> <Gen3853_maybe> <Lex596> <Lex597> <Lex406> <Lex598> rank => 0
<Cobol_Nines_maybe> ::= <Cobol_Nines> rank => 0
<Cobol_Nines_maybe> ::= rank => -1
<Gen3859> ::= <Lex599> <Cobol_Nines_maybe> rank => 0
<Gen3859_maybe> ::= <Gen3859> rank => 0
<Gen3859_maybe> ::= rank => -1
<Cobol_Nines_Specification> ::= <Cobol_Nines> <Gen3859_maybe> rank => 0
                              | <Lex599> <Cobol_Nines> rank => -1
<Cobol_Integer_Type> ::= <Cobol_Binary_Integer> rank => 0
<Gen3865> ::= <Lex593> rank => 0
            | <Lex594> rank => -1
<Gen3867> ::= <Lex280> <Lex401_maybe> rank => 0
<Gen3867_maybe> ::= <Gen3867> rank => 0
<Gen3867_maybe> ::= rank => -1
<Cobol_Binary_Integer> ::= <Gen3865> <Lex401_maybe> <Lex595> <Cobol_Nines> <Gen3867_maybe> <Lex306> rank => 0
<Gen3871> ::= <Left_Paren> <Length> <Right_Paren> rank => 0
<Gen3871_maybe> ::= <Gen3871> rank => 0
<Gen3871_maybe> ::= rank => -1
<Gen3874> ::= <Lex600> <Gen3871_maybe> rank => 0
<Gen3874_many> ::= <Gen3874>+ rank => 0
<Cobol_Nines> ::= <Gen3874_many> rank => 0
<Embedded_SQL_Fortran_Program> ::= <Lex365> <Lex488> rank => 0
<Gen3878> ::= <Comma> <Fortran_Host_Identifier> rank => 0
<Gen3878_any> ::= <Gen3878>* rank => 0
<Fortran_Variable_Definition> ::= <Fortran_Type_Specification> <Fortran_Host_Identifier> <Gen3878_any> rank => 0
<Gen3881> ::= <Simple_Latin_Letter> rank => 0
            | <Digit> rank => -1
            | <Underscore> rank => -2
<Gen3881_any> ::= <Gen3881>* rank => 0
<Fortran_Host_Identifier> ::= <Simple_Latin_Letter> <Gen3881_any> rank => 0
<Gen3886> ::= <Asterisk> <Length> rank => 0
<Gen3886_maybe> ::= <Gen3886> rank => 0
<Gen3886_maybe> ::= rank => -1
<Gen3889> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3889_maybe> ::= <Gen3889> rank => 0
<Gen3889_maybe> ::= rank => -1
<Gen3892> ::= <Lex003_many> rank => 0
<Gen3892> ::= rank => -1
<Gen3894> ::= <Asterisk> <Length> rank => 0
<Gen3894_maybe> ::= <Gen3894> rank => 0
<Gen3894_maybe> ::= rank => -1
<Gen3897> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3897_maybe> ::= <Gen3897> rank => 0
<Gen3897_maybe> ::= rank => -1
<Fortran_Type_Specification> ::= <Lex317> <Gen3886_maybe> <Gen3889_maybe> rank => 0
                               | <Lex317> <Lex601> <Lex020> <Lex003> <Gen3892> <Gen3894_maybe> <Gen3897_maybe> rank => -1
                               | <Lex397> rank => -2
                               | <Lex451> rank => -3
                               | <Lex355> <Lex445> rank => -4
                               | <Lex603> rank => -5
                               | <Fortran_Derived_Type_Specification> rank => -6
<Fortran_Derived_Type_Specification> ::= <Fortran_Clob_Variable> rank => 0
                                       | <Fortran_Blob_Variable> rank => -1
                                       | <Fortran_User_Defined_Type_Variable> rank => -2
                                       | <Fortran_Clob_Locator_Variable> rank => -3
                                       | <Fortran_Blob_Locator_Variable> rank => -4
                                       | <Fortran_User_Defined_Type_Locator_Variable> rank => -5
                                       | <Fortran_Array_Locator_Variable> rank => -6
                                       | <Fortran_Multiset_Locator_Variable> rank => -7
                                       | <Fortran_Ref_Variable> rank => -8
<Gen3916> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3916_maybe> ::= <Gen3916> rank => 0
<Gen3916_maybe> ::= rank => -1
<Fortran_Clob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3916_maybe> rank => 0
<Fortran_Blob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Fortran_User_Defined_Type_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Predefined_Type> rank => 0
<Fortran_Clob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Fortran_Blob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Fortran_User_Defined_Type_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Lex158> rank => 0
<Fortran_Array_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Array_Type> <Lex297> <Lex158> rank => 0
<Fortran_Multiset_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset_Type> <Lex297> <Lex158> rank => 0
<Fortran_Ref_Variable> ::= <Lex488> <Lex275> <Lex401> <Reference_Type> rank => 0
<Embedded_SQL_Mumps_Program> ::= <Lex365> <Lex488> rank => 0
<Mumps_Variable_Definition> ::= <Mumps_Numeric_Variable> <Semicolon> rank => 0
                              | <Mumps_Character_Variable> <Semicolon> rank => -1
                              | <Mumps_Derived_Type_Specification> <Semicolon> rank => -2
<Gen3932> ::= <Comma> <Mumps_Host_Identifier> <Mumps_Length_Specification> rank => 0
<Gen3932_any> ::= <Gen3932>* rank => 0
<Mumps_Character_Variable> ::= <Lex522> <Mumps_Host_Identifier> <Mumps_Length_Specification> <Gen3932_any> rank => 0
<Gen3935> ::= <Lex006> rank => 0
            | <Simple_Latin_Letter> rank => -1
<Gen3937> ::= <Simple_Latin_Letter> rank => 0
            | <Digit> rank => -1
<Gen3937_any> ::= <Gen3937>* rank => 0
<Mumps_Host_Identifier> ::= <Gen3935> <Gen3937_any> rank => 0
<Mumps_Length_Specification> ::= <Left_Paren> <Length> <Right_Paren> rank => 0
<Gen3942> ::= <Comma> <Mumps_Host_Identifier> rank => 0
<Gen3942_any> ::= <Gen3942>* rank => 0
<Mumps_Numeric_Variable> ::= <Mumps_Type_Specification> <Mumps_Host_Identifier> <Gen3942_any> rank => 0
<Gen3945> ::= <Comma> <Scale> rank => 0
<Gen3945_maybe> ::= <Gen3945> rank => 0
<Gen3945_maybe> ::= rank => -1
<Gen3948> ::= <Left_Paren> <Precision> <Gen3945_maybe> <Right_Paren> rank => 0
<Gen3948_maybe> ::= <Gen3948> rank => 0
<Gen3948_maybe> ::= rank => -1
<Mumps_Type_Specification> ::= <Lex396> rank => 0
                             | <Lex345> <Gen3948_maybe> rank => -1
                             | <Lex451> rank => -2
<Mumps_Derived_Type_Specification> ::= <Mumps_Clob_Variable> rank => 0
                                     | <Mumps_Blob_Variable> rank => -1
                                     | <Mumps_User_Defined_Type_Variable> rank => -2
                                     | <Mumps_Clob_Locator_Variable> rank => -3
                                     | <Mumps_Blob_Locator_Variable> rank => -4
                                     | <Mumps_User_Defined_Type_Locator_Variable> rank => -5
                                     | <Mumps_Array_Locator_Variable> rank => -6
                                     | <Mumps_Multiset_Locator_Variable> rank => -7
                                     | <Mumps_Ref_Variable> rank => -8
<Gen3963> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3963_maybe> ::= <Gen3963> rank => 0
<Gen3963_maybe> ::= rank => -1
<Mumps_Clob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3963_maybe> rank => 0
<Mumps_Blob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Mumps_User_Defined_Type_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Predefined_Type> rank => 0
<Mumps_Clob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Mumps_Blob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Mumps_User_Defined_Type_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Lex158> rank => 0
<Mumps_Array_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Array_Type> <Lex297> <Lex158> rank => 0
<Mumps_Multiset_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset_Type> <Lex297> <Lex158> rank => 0
<Mumps_Ref_Variable> ::= <Lex488> <Lex275> <Lex401> <Reference_Type> rank => 0
<Embedded_SQL_Pascal_Program> ::= <Lex365> <Lex488> rank => 0
<Gen3976> ::= <Comma> <Pascal_Host_Identifier> rank => 0
<Gen3976_any> ::= <Gen3976>* rank => 0
<Pascal_Variable_Definition> ::= <Pascal_Host_Identifier> <Gen3976_any> <Colon> <Pascal_Type_Specification> <Semicolon> rank => 0
<Pascal_Host_Identifier> ::= <Regular_Identifier> rank => 0
<Gen3980> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3980_maybe> ::= <Gen3980> rank => 0
<Gen3980_maybe> ::= rank => -1
<Gen3983> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen3983_maybe> ::= <Gen3983> rank => 0
<Gen3983_maybe> ::= rank => -1
<Pascal_Type_Specification> ::= <Lex604> <Lex296> <Left_Bracket> <Lex556> <Double_Period> <Length> <Right_Bracket> <Lex431> <Lex316> <Gen3980_maybe> rank => 0
                              | <Lex397> rank => -1
                              | <Lex451> rank => -2
                              | <Lex316> <Gen3983_maybe> rank => -3
                              | <Lex308> rank => -4
                              | <Pascal_Derived_Type_Specification> rank => -5
<Pascal_Derived_Type_Specification> ::= <Pascal_Clob_Variable> rank => 0
                                      | <Pascal_Blob_Variable> rank => -1
                                      | <Pascal_User_Defined_Type_Variable> rank => -2
                                      | <Pascal_Clob_Locator_Variable> rank => -3
                                      | <Pascal_Blob_Locator_Variable> rank => -4
                                      | <Pascal_User_Defined_Type_Locator_Variable> rank => -5
                                      | <Pascal_Array_Locator_Variable> rank => -6
                                      | <Pascal_Multiset_Locator_Variable> rank => -7
                                      | <Pascal_Ref_Variable> rank => -8
<Gen4001> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen4001_maybe> ::= <Gen4001> rank => 0
<Gen4001_maybe> ::= rank => -1
<Pascal_Clob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen4001_maybe> rank => 0
<Pascal_Blob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Pascal_Clob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Pascal_User_Defined_Type_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Predefined_Type> rank => 0
<Pascal_Blob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Pascal_User_Defined_Type_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Lex158> rank => 0
<Pascal_Array_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Array_Type> <Lex297> <Lex158> rank => 0
<Pascal_Multiset_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset_Type> <Lex297> <Lex158> rank => 0
<Pascal_Ref_Variable> ::= <Lex488> <Lex275> <Lex401> <Reference_Type> rank => 0
<Embedded_SQL_Pl_I_Program> ::= <Lex365> <Lex488> rank => 0
<Gen4014> ::= <Lex605> rank => 0
            | <Lex347> rank => -1
<Gen4016> ::= <Comma> <Pl_I_Host_Identifier> rank => 0
<Gen4016_any> ::= <Gen4016>* rank => 0
<Pl_I_Variable_Definition> ::= <Gen4014> <Pl_I_Host_Identifier> <Left_Paren> <Pl_I_Host_Identifier> <Gen4016_any> <Right_Paren> <Pl_I_Type_Specification> <Character_Representation_any> <Semicolon> rank => 0
<Pl_I_Host_Identifier> ::= <Regular_Identifier> rank => 0
<Gen4020> ::= <Lex316> rank => 0
            | <Lex317> rank => -1
<Lex523_maybe> ::= <Lex523> rank => 0
<Lex523_maybe> ::= rank => -1
<Gen4024> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen4024_maybe> ::= <Gen4024> rank => 0
<Gen4024_maybe> ::= rank => -1
<Gen4027> ::= <Comma> <Scale> rank => 0
<Gen4027_maybe> ::= <Gen4027> rank => 0
<Gen4027_maybe> ::= rank => -1
<Gen4030> ::= <Left_Paren> <Precision> <Right_Paren> rank => 0
<Gen4030_maybe> ::= <Gen4030> rank => 0
<Gen4030_maybe> ::= rank => -1
<Pl_I_Type_Specification> ::= <Gen4020> <Lex523_maybe> <Left_Paren> <Length> <Right_Paren> <Gen4024_maybe> rank => 0
                            | <Pl_I_Type_Fixed_Decimal> <Left_Paren> <Precision> <Gen4027_maybe> <Right_Paren> rank => -1
                            | <Pl_I_Type_Fixed_Binary> <Gen4030_maybe> rank => -2
                            | <Pl_I_Type_Float_Binary> <Left_Paren> <Precision> <Right_Paren> rank => -3
                            | <Pl_I_Derived_Type_Specification> rank => -4
<Pl_I_Derived_Type_Specification> ::= <Pl_I_Clob_Variable> rank => 0
                                    | <Pl_I_Blob_Variable> rank => -1
                                    | <Pl_I_User_Defined_Type_Variable> rank => -2
                                    | <Pl_I_Clob_Locator_Variable> rank => -3
                                    | <Pl_I_Blob_Locator_Variable> rank => -4
                                    | <Pl_I_User_Defined_Type_Locator_Variable> rank => -5
                                    | <Pl_I_Array_Locator_Variable> rank => -6
                                    | <Pl_I_Multiset_Locator_Variable> rank => -7
                                    | <Pl_I_Ref_Variable> rank => -8
<Gen4047> ::= <Lex317> <Lex482> <Lex401_maybe> <Character_Set_Specification> rank => 0
<Gen4047_maybe> ::= <Gen4047> rank => 0
<Gen4047_maybe> ::= rank => -1
<Pl_I_Clob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen4047_maybe> rank => 0
<Pl_I_Blob_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Left_Paren> <Large_Object_Length> <Right_Paren> rank => 0
<Pl_I_User_Defined_Type_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Predefined_Type> rank => 0
<Pl_I_Clob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex319> <Lex297> <Lex158> rank => 0
<Pl_I_Blob_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Lex307> <Lex297> <Lex158> rank => 0
<Pl_I_User_Defined_Type_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Path_Resolved_User_Defined_Type_Name> <Lex297> <Lex158> rank => 0
<Pl_I_Array_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Array_Type> <Lex297> <Lex158> rank => 0
<Pl_I_Multiset_Locator_Variable> ::= <Lex488> <Lex275> <Lex401> <Multiset_Type> <Lex297> <Lex158> rank => 0
<Pl_I_Ref_Variable> ::= <Lex488> <Lex275> <Lex401> <Reference_Type> rank => 0
<Gen4059> ::= <Lex345> rank => 0
            | <Lex346> rank => -1
<Gen4061> ::= <Lex345> rank => 0
            | <Lex346> rank => -1
<Pl_I_Type_Fixed_Decimal> ::= <Gen4059> <Lex606> rank => 0
                            | <Lex606> <Gen4061> rank => -1
<Gen4065> ::= <Lex607> rank => 0
            | <Lex306> rank => -1
<Gen4067> ::= <Lex607> rank => 0
            | <Lex306> rank => -1
<Pl_I_Type_Fixed_Binary> ::= <Gen4065> <Lex606> rank => 0
                           | <Lex606> <Gen4067> rank => -1
<Gen4071> ::= <Lex607> rank => 0
            | <Lex306> rank => -1
<Gen4073> ::= <Lex607> rank => 0
            | <Lex306> rank => -1
<Pl_I_Type_Float_Binary> ::= <Gen4071> <Lex372> rank => 0
                           | <Lex372> <Gen4073> rank => -1
<Direct_SQL_Statement> ::= <Directly_Executable_Statement> <Semicolon> rank => 0
<Directly_Executable_Statement> ::= <Direct_SQL_Data_Statement> rank => 0
                                  | <SQL_Schema_Statement> rank => -1
                                  | <SQL_Transaction_Statement> rank => -2
                                  | <SQL_Connection_Statement> rank => -3
                                  | <SQL_Session_Statement> rank => -4
<Direct_SQL_Data_Statement> ::= <Delete_Statement_Searched> rank => 0
                              | <Direct_Select_Statement_Multiple_Rows> rank => -1
                              | <Insert_Statement> rank => -2
                              | <Update_Statement_Searched> rank => -3
                              | <Merge_Statement> rank => -4
                              | <Temporary_Table_Declaration> rank => -5
<Direct_Select_Statement_Multiple_Rows> ::= <Cursor_Specification> rank => 0
<Get_Diagnostics_Statement> ::= <Lex379> <Lex118> <SQL_Diagnostics_Information> rank => 0
<SQL_Diagnostics_Information> ::= <Statement_Information> rank => 0
                                | <Condition_Information> rank => -1
<Gen4093> ::= <Comma> <Statement_Information_Item> rank => 0
<Gen4093_any> ::= <Gen4093>* rank => 0
<Statement_Information> ::= <Statement_Information_Item> <Gen4093_any> rank => 0
<Statement_Information_Item> ::= <Simple_Target_Specification> <Equals_Operator> <Statement_Information_Item_Name> rank => 0
<Statement_Information_Item_Name> ::= <Lex181> rank => 0
                                    | <Lex170> rank => -1
                                    | <Lex084> rank => -2
                                    | <Lex085> rank => -3
                                    | <Lex121> rank => -4
                                    | <Lex122> rank => -5
                                    | <Lex228> rank => -6
                                    | <Lex265> rank => -7
                                    | <Lex266> rank => -8
                                    | <Lex267> rank => -9
<Gen4107> ::= <Lex125> rank => 0
            | <Lex087> rank => -1
<Gen4109> ::= <Comma> <Condition_Information_Item> rank => 0
<Gen4109_any> ::= <Gen4109>* rank => 0
<Condition_Information> ::= <Gen4107> <Condition_Number> <Condition_Information_Item> <Gen4109_any> rank => 0
<Condition_Information_Item> ::= <Simple_Target_Specification> <Equals_Operator> <Condition_Information_Item_Name> rank => 0
<Condition_Information_Item_Name> ::= <Lex062> rank => 0
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
<Condition_Number> ::= <Simple_Value_Specification> rank => 0
<Lex001> ~ [A-Z]
<Lex002> ~ [a-z]
<Lex003> ~ [0-9]
<Lex003_many> ~ [0-9]*
<Lex004> ~ [\s]
<Lex005> ~ '"':i
<Lex006> ~ '%':i
<Lex007> ~ '&':i
<Lex008> ~ [']
<Lex009> ~ '(':i
<Lex010> ~ ')':i
<Lex011> ~ '*':i
<Lex012> ~ '+':i
<Lex013> ~ ',':i
<Lex014> ~ '-':i
<Lex015> ~ '.':i
<Lex016> ~ '/':i
<Lex017> ~ ':':i
<Lex018> ~ ';':i
<Lex019> ~ '<':i
<Lex020> ~ '=':i
<Lex021> ~ '>':i
<Lex022> ~ '?':i
<Lex023> ~ '[':i
<Lex024> ::= '?':i '?':i '(':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex025> ~ ']':i
<Lex026> ::= '?':i '?':i ')':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex027> ~ '^':i
<Lex028> ~ '_':i
<Lex029> ~ '|':i
<Lex030> ~ '{':i
<Lex031> ~ '}':i
<Lex032> ~ 'K':i
<Lex033> ~ 'M':i
<Lex034> ~ 'G':i
<Lex035> ~ 'U':i
<Lex036> ::= 'U':i 'E':i 'S':i 'C':i 'A':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex037> ~ [\x{1b}]
<Lex038> ~ [^\"]
<Lex039> ::= '"':i '"':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex040> ~ [\n]
<Lex041> ~ 'A':i
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
<Lex058> ~ 'C':i
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
<Lex534> ~ 'N':i
<Lex535> ~ 'X':i
<Lex536> ~ 'B':i
<Lex537> ~ 'D':i
<Lex538> ~ 'E':i
<Lex539> ~ 'F':i
<Lex540> ~ 'a':i
<Lex541> ~ 'b':i
<Lex542> ~ 'c':i
<Lex543> ~ 'd':i
<Lex544> ~ 'e':i
<Lex545> ~ 'f':i
<Lex546_many> ~ [\d]+
<Lex547> ::= 'S':i 'C':i 'O':i 'P':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex548> ~ [^\[\]\(\)\|\^\-\+\*_\%\?\{\\]
<Lex549> ~ [\x{5c}]
<Lex550> ~ [\[\]\(\)\|\^\-\+\*_\%\?\{\\]
<Lex551> ::= 'C':i 'O':i 'N':i 'S':i 'T':i 'R':i 'U':i 'C':i 'T':i 'O':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex552> ::= 'R':i 'E':i 'S':i 'T':i 'R':i 'I':i 'C':i 'T':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex553> ::= 'G':i 'E':i 'N':i 'E':i 'R':i 'A':i 'T':i 'E':i 'D':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex554> ::= 'C':i 'O':i 'N':i 'N':i 'E':i 'C':i 'T':i 'I':i 'O':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex555> ::= 'I':i 'n':i 't':i 'e':i 'r':i 'f':i 'a':i 'c':i 'e':i 's':i '.':i 'S':i 'Q':i 'L':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex556> ~ '1':i
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
<Lex573_many> ~ [\-]*
<Lex574> ~ [A-Za-z]
<Lex575_many> ~ [A-Za-z0-9]*
<Lex576_many> ~ [\-]+
<Lex577_many> ~ [A-Za-z0-9]+
<Lex578_many> ~ [0]*
<Lex579> ~ [1-9]
<Lex580> ::= 'L':i 'I':i 'N':i 'A':i 'G':i 'E':i '-':i 'C':i 'O':i 'U':i 'N':i 'T':i 'E':i 'R':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex581> ::= '*':i '*':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex582_many> ~ [0-9A-Fa-f]+
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
<Lex595> ~ 'S':i
<Lex596> ::= 'D':i 'I':i 'S':i 'P':i 'L':i 'A':i 'Y':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex597> ::= 'S':i 'I':i 'G':i 'N':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex598> ::= 'S':i 'E':i 'P':i 'A':i 'R':i 'A':i 'T':i 'E':i action => fakedLexeme # Faked lexeme - LATM handling the ambiguities
<Lex599> ~ 'V':i
<Lex600> ~ '9':i
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

