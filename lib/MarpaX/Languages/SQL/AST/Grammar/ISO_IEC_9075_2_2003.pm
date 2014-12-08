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
    _recce_option => {ranking_method => 'high_rule_only',
                      # trace_terminals => 1,
                     },
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
lexeme default = action => [start,length,value] latm => 1

:start ::= <SQL_Start_Sequence>
<SQL_Start_many> ::= <SQL_Start>+
<SQL_Start_Sequence> ::= <SQL_Start_many>
<SQL_Start> ::= <Preparable_Statement>
              | <Direct_SQL_Statement>
              | <Embedded_SQL_Declare_Section>
              | <Embedded_SQL_Host_Program>
              | <Embedded_SQL_Statement>
              | <SQL_Client_Module_Definition>
<SQL_Terminal_Character> ::= <SQL_Language_Character>
<SQL_Language_Character> ::= <Simple_Latin_Letter>
                           | <Digit>
                           | <SQL_Special_Character>
<Simple_Latin_Letter> ::= <Simple_Latin_Upper_Case_Letter>
                        | <Simple_Latin_Lower_Case_Letter>
<Simple_Latin_Upper_Case_Letter> ::= <Lex001>
<Simple_Latin_Lower_Case_Letter> ::= <Lex002>
<Digit> ::= <Lex003>
<SQL_Special_Character> ::= <Space>
                          | <Double_Quote>
                          | <Percent>
                          | <Ampersand>
                          | <Quote>
                          | <Left_Paren>
                          | <Right_Paren>
                          | <Asterisk>
                          | <Plus_Sign>
                          | <Comma>
                          | <Minus_Sign>
                          | <Period>
                          | <Solidus>
                          | <Colon>
                          | <Semicolon>
                          | <Less_Than_Operator>
                          | <Equals_Operator>
                          | <Greater_Than_Operator>
                          | <Question_Mark>
                          | <Left_Bracket>
                          | <Right_Bracket>
                          | <Circumflex>
                          | <Underscore>
                          | <Vertical_Bar>
                          | <Left_Brace>
                          | <Right_Brace>
<Space> ::= <Lex004>
<Double_Quote> ::= <Lex005>
<Percent> ::= <Lex006>
<Ampersand> ::= <Lex007>
<Quote> ::= <Lex008>
<Left_Paren> ::= <Lex009>
<Right_Paren> ::= <Lex010>
<Asterisk> ::= <Lex011>
<Plus_Sign> ::= <Lex012>
<Comma> ::= <Lex013>
<Minus_Sign> ::= <Lex014>
<Period> ::= <Lex015>
<Solidus> ::= <Lex016>
<Colon> ::= <Lex017>
<Semicolon> ::= <Lex018>
<Less_Than_Operator> ::= <Lex019>
<Equals_Operator> ::= <Lex020>
<Greater_Than_Operator> ::= <Lex021>
<Question_Mark> ::= <Lex022>
<Left_Bracket_Or_Trigraph> ::= <Left_Bracket>
                             | <Left_Bracket_Trigraph>
<Right_Bracket_Or_Trigraph> ::= <Right_Bracket>
                              | <Right_Bracket_Trigraph>
<Left_Bracket> ::= <Lex023>
<Left_Bracket_Trigraph> ::= <Lex024>
<Right_Bracket> ::= <Lex025>
<Right_Bracket_Trigraph> ::= <Lex026>
<Circumflex> ::= <Lex027>
<Underscore> ::= <Lex028>
<Vertical_Bar> ::= <Lex029>
<Left_Brace> ::= <Lex030>
<Right_Brace> ::= <Lex031>
<Token> ::= <Nondelimiter_Token>
          | <Delimiter_Token>
<Nondelimiter_Token> ::= <Regular_Identifier>
                       | <Key_Word>
                       | <Unsigned_Numeric_Literal>
                       | <National_Character_String_Literal>
                       | <Large_Object_Length_Token>
                       | <Multiplier>
<Regular_Identifier> ::= <SQL_Language_Identifier>
<Digit_many> ::= <Digit>+
<Large_Object_Length_Token> ::= <Digit_many> <Multiplier>
<Multiplier> ::= <K>
               | <M>
               | <G>
<Delimited_Identifier> ~ <Lex035> <Delimited_Identifier_Body> <Lex036>
<GenLex092> ~ <Delimited_Identifier_Part>
<GenLex092_many> ~ <GenLex092>+
<Delimited_Identifier_Body> ~ <GenLex092_many>
<Delimited_Identifier_Part> ~ <Nondoublequote_Character>
                              | <Doublequote_Symbol>
<Unicode_Delimited_Identifier> ~ <Lex037> <Lex038> <Lex039> <Unicode_Delimiter_Body> <Lex040> <Unicode_Escape_Specifier>
<GenLex098> ~ <Lex041> <Lex042> <Unicode_Escape_Character> <Lex043>
<GenLex098_maybe> ~ <GenLex098>
<GenLex098_maybe> ~
<Unicode_Escape_Specifier> ~ <GenLex098_maybe>
<GenLex102> ~ <Unicode_Identifier_Part>
<GenLex102_many> ~ <GenLex102>+
<Unicode_Delimiter_Body> ~ <GenLex102_many>
<Unicode_Identifier_Part> ~ <Unicode_Delimited_Identifier_Part>
                            | <Unicode_Escape_Value_Internal>
<Unicode_Delimited_Identifier_Part> ~ <Nondoublequote_Character>
                                      | <Doublequote_Symbol>
<Unicode_Escape_Value_Internal> ~ <Unicode_4_Digit_Escape_Value>
                                  | <Unicode_6_Digit_Escape_Value>
                                  | <Unicode_Character_Escape_Value>
<Unicode_Escape_Value> ~ <Unicode_Escape_Value_Internal>
<Unicode_Hexit> ~ <Lex044>
<Unicode_4_Digit_Escape_Value> ~ <Unicode_Escape_Character> <Unicode_Hexit> <Unicode_Hexit> <Unicode_Hexit> <Unicode_Hexit>
<Unicode_6_Digit_Escape_Value> ~ <Unicode_Escape_Character> <Lex045> <Unicode_Hexit> <Unicode_Hexit> <Unicode_Hexit> <Unicode_Hexit> <Unicode_Hexit> <Unicode_Hexit>
<Unicode_Character_Escape_Value> ~ <Unicode_Escape_Character> <Unicode_Escape_Character>
<Unicode_Escape_Character> ~ <Lex046>
<Nondoublequote_Character> ~ <Lex047>
<Doublequote_Symbol> ~ <Lex048>
<Delimiter_Token> ::= <Character_String_Literal>
                    | <Date_String>
                    | <Time_String>
                    | <Timestamp_String>
                    | <Interval_String>
                    | <Delimited_Identifier>
                    | <Unicode_Delimited_Identifier>
                    | <SQL_Special_Character>
                    | <Not_Equals_Operator>
                    | <Greater_Than_Or_Equals_Operator>
                    | <Less_Than_Or_Equals_Operator>
                    | <Concatenation_Operator>
                    | <Right_Arrow>
                    | <Left_Bracket_Trigraph>
                    | <Right_Bracket_Trigraph>
                    | <Double_Colon>
                    | <Double_Period>
<Not_Equals_Operator> ::= <Less_Than_Operator> <Greater_Than_Operator>
<Greater_Than_Or_Equals_Operator> ::= <Greater_Than_Operator> <Equals_Operator>
<Less_Than_Or_Equals_Operator> ::= <Less_Than_Operator> <Equals_Operator>
<Concatenation_Operator> ::= <Vertical_Bar> <Vertical_Bar>
<Right_Arrow> ::= <Minus_Sign> <Greater_Than_Operator>
<Double_Colon> ::= <Colon> <Colon>
<Double_Period> ::= <Period> <Period>
<Gen144> ::= <Comment>
           | <Space>
<Gen144_many> ::= <Gen144>+
<Separator> ::= <Gen144_many>
<Comment> ::= <Simple_Comment>
            | <Bracketed_Comment>
<Comment_Character_any> ::= <Comment_Character>*
<Simple_Comment> ::= <Simple_Comment_Introducer> <Comment_Character_any> <Newline>
<Minus_Sign_any> ::= <Minus_Sign>*
<Simple_Comment_Introducer> ::= <Minus_Sign> <Minus_Sign> <Minus_Sign_any>
<Bracketed_Comment> ::= <Bracketed_Comment_Introducer> <Bracketed_Comment_Contents> <Bracketed_Comment_Terminator>
<Bracketed_Comment_Introducer> ::= <Solidus> <Asterisk>
<Bracketed_Comment_Terminator> ::= <Asterisk> <Solidus>
<Gen157> ::= <Comment_Character>
           | <Separator>
<Gen157_any> ::= <Gen157>*
<Bracketed_Comment_Contents> ::= <Gen157_any>
<Comment_Character> ::= <Nonquote_Character>
                      | <Quote>
<Newline> ::= <Lex049>
<Key_Word> ::= <Reserved_Word>
             | <Non_Reserved_Word>
<Non_Reserved_Word> ::= <A>
                      | <ABS>
                      | <ABSOLUTE>
                      | <ACTION>
                      | <ADA>
                      | <ADMIN>
                      | <AFTER>
                      | <ALWAYS>
                      | <ASC>
                      | <ASSERTION>
                      | <ASSIGNMENT>
                      | <ATTRIBUTE>
                      | <ATTRIBUTES>
                      | <AVG>
                      | <BEFORE>
                      | <BERNOULLI>
                      | <BREADTH>
                      | <C>
                      | <CARDINALITY>
                      | <CASCADE>
                      | <CATALOG>
                      | <Lex071>
                      | <CEIL>
                      | <CEILING>
                      | <CHAIN>
                      | <CHARACTERISTICS>
                      | <CHARACTERS>
                      | <Lex077>
                      | <Lex078>
                      | <Lex079>
                      | <Lex080>
                      | <Lex081>
                      | <CHECKED>
                      | <Lex083>
                      | <COALESCE>
                      | <COBOL>
                      | <Lex086>
                      | <COLLATION>
                      | <Lex088>
                      | <Lex089>
                      | <Lex090>
                      | <COLLECT>
                      | <Lex092>
                      | <Lex093>
                      | <Lex094>
                      | <COMMITTED>
                      | <CONDITION>
                      | <Lex097>
                      | <Lex098>
                      | <CONSTRAINTS>
                      | <Lex100>
                      | <Lex101>
                      | <Lex102>
                      | <CONSTRUCTORS>
                      | <CONTAINS>
                      | <CONVERT>
                      | <CORR>
                      | <COUNT>
                      | <Lex108>
                      | <Lex109>
                      | <Lex110>
                      | <Lex111>
                      | <Lex112>
                      | <DATA>
                      | <Lex114>
                      | <Lex115>
                      | <DEFAULTS>
                      | <DEFERRABLE>
                      | <DEFERRED>
                      | <DEFINED>
                      | <DEFINER>
                      | <DEGREE>
                      | <Lex122>
                      | <DEPTH>
                      | <DERIVED>
                      | <DESC>
                      | <DESCRIPTOR>
                      | <DIAGNOSTICS>
                      | <DISPATCH>
                      | <DOMAIN>
                      | <Lex130>
                      | <Lex131>
                      | <EQUALS>
                      | <EVERY>
                      | <EXCEPTION>
                      | <EXCLUDE>
                      | <EXCLUDING>
                      | <EXP>
                      | <EXTRACT>
                      | <FINAL>
                      | <FIRST>
                      | <FLOOR>
                      | <FOLLOWING>
                      | <FORTRAN>
                      | <FOUND>
                      | <FUSION>
                      | <G>
                      | <GENERAL>
                      | <GO>
                      | <GOTO>
                      | <GRANTED>
                      | <HIERARCHY>
                      | <IMPLEMENTATION>
                      | <INCLUDING>
                      | <INCREMENT>
                      | <INITIALLY>
                      | <INSTANCE>
                      | <INSTANTIABLE>
                      | <INTERSECTION>
                      | <INVOKER>
                      | <ISOLATION>
                      | <K>
                      | <KEY>
                      | <Lex161>
                      | <Lex162>
                      | <LAST>
                      | <LENGTH>
                      | <LEVEL>
                      | <LN>
                      | <LOCATOR>
                      | <LOWER>
                      | <M>
                      | <MAP>
                      | <MATCHED>
                      | <MAX>
                      | <MAXVALUE>
                      | <Lex173>
                      | <Lex174>
                      | <Lex175>
                      | <MIN>
                      | <MINVALUE>
                      | <MOD>
                      | <MORE>
                      | <MUMPS>
                      | <NAME>
                      | <NAMES>
                      | <NESTING>
                      | <NEXT>
                      | <NORMALIZE>
                      | <NORMALIZED>
                      | <NULLABLE>
                      | <NULLIF>
                      | <NULLS>
                      | <NUMBER>
                      | <OBJECT>
                      | <OCTETS>
                      | <Lex193>
                      | <OPTION>
                      | <OPTIONS>
                      | <ORDERING>
                      | <ORDINALITY>
                      | <OTHERS>
                      | <OVERLAY>
                      | <OVERRIDING>
                      | <PAD>
                      | <Lex202>
                      | <Lex203>
                      | <Lex204>
                      | <Lex205>
                      | <Lex206>
                      | <Lex207>
                      | <PARTIAL>
                      | <PASCAL>
                      | <PATH>
                      | <Lex211>
                      | <Lex212>
                      | <Lex213>
                      | <PLACING>
                      | <PLI>
                      | <POSITION>
                      | <POWER>
                      | <PRECEDING>
                      | <PRESERVE>
                      | <PRIOR>
                      | <PRIVILEGES>
                      | <PUBLIC>
                      | <RANK>
                      | <READ>
                      | <RELATIVE>
                      | <REPEATABLE>
                      | <RESTART>
                      | <Lex228>
                      | <Lex229>
                      | <Lex230>
                      | <Lex231>
                      | <ROLE>
                      | <ROUTINE>
                      | <Lex234>
                      | <Lex235>
                      | <Lex236>
                      | <Lex237>
                      | <Lex238>
                      | <SCALE>
                      | <SCHEMA>
                      | <Lex241>
                      | <Lex242>
                      | <Lex243>
                      | <Lex244>
                      | <SECTION>
                      | <SECURITY>
                      | <SELF>
                      | <SEQUENCE>
                      | <SERIALIZABLE>
                      | <Lex250>
                      | <SESSION>
                      | <SETS>
                      | <SIMPLE>
                      | <SIZE>
                      | <SOURCE>
                      | <SPACE>
                      | <Lex257>
                      | <SQRT>
                      | <STATE>
                      | <STATEMENT>
                      | <Lex261>
                      | <Lex262>
                      | <STRUCTURE>
                      | <STYLE>
                      | <Lex265>
                      | <SUBSTRING>
                      | <SUM>
                      | <TABLESAMPLE>
                      | <Lex269>
                      | <TEMPORARY>
                      | <TIES>
                      | <Lex272>
                      | <TRANSACTION>
                      | <Lex274>
                      | <Lex275>
                      | <Lex276>
                      | <TRANSFORM>
                      | <TRANSFORMS>
                      | <TRANSLATE>
                      | <Lex280>
                      | <Lex281>
                      | <Lex282>
                      | <TRIM>
                      | <TYPE>
                      | <UNBOUNDED>
                      | <UNCOMMITTED>
                      | <UNDER>
                      | <UNNAMED>
                      | <USAGE>
                      | <Lex290>
                      | <Lex291>
                      | <Lex292>
                      | <Lex293>
                      | <VIEW>
                      | <WORK>
                      | <WRITE>
                      | <ZONE>
<Reserved_Word> ::= <ADD>
                  | <ALL>
                  | <ALLOCATE>
                  | <ALTER>
                  | <AND>
                  | <ANY>
                  | <ARE>
                  | <ARRAY>
                  | <AS>
                  | <ASENSITIVE>
                  | <ASYMMETRIC>
                  | <AT>
                  | <ATOMIC>
                  | <AUTHORIZATION>
                  | <BEGIN>
                  | <BETWEEN>
                  | <BIGINT>
                  | <BINARY>
                  | <BLOB>
                  | <BOOLEAN>
                  | <BOTH>
                  | <BY>
                  | <CALL>
                  | <CALLED>
                  | <CASCADED>
                  | <CASE>
                  | <CAST>
                  | <CHAR>
                  | <CHARACTER>
                  | <CHECK>
                  | <CLOB>
                  | <CLOSE>
                  | <COLLATE>
                  | <COLUMN>
                  | <COMMIT>
                  | <CONNECT>
                  | <CONSTRAINT>
                  | <CONTINUE>
                  | <CORRESPONDING>
                  | <CREATE>
                  | <CROSS>
                  | <CUBE>
                  | <CURRENT>
                  | <Lex341>
                  | <Lex342>
                  | <Lex343>
                  | <Lex344>
                  | <Lex345>
                  | <Lex346>
                  | <Lex347>
                  | <Lex348>
                  | <CURSOR>
                  | <CYCLE>
                  | <DATE>
                  | <DAY>
                  | <DEALLOCATE>
                  | <DEC>
                  | <DECIMAL>
                  | <DECLARE>
                  | <DEFAULT>
                  | <DELETE>
                  | <DEREF>
                  | <DESCRIBE>
                  | <DETERMINISTIC>
                  | <DISCONNECT>
                  | <DISTINCT>
                  | <DOUBLE>
                  | <DROP>
                  | <DYNAMIC>
                  | <EACH>
                  | <ELEMENT>
                  | <ELSE>
                  | <END>
                  | <Lex371>
                  | <ESCAPE>
                  | <EXCEPT>
                  | <EXEC>
                  | <EXECUTE>
                  | <EXISTS>
                  | <EXTERNAL>
                  | <FALSE>
                  | <FETCH>
                  | <FILTER>
                  | <FLOAT>
                  | <FOR>
                  | <FOREIGN>
                  | <FREE>
                  | <FROM>
                  | <FULL>
                  | <FUNCTION>
                  | <GET>
                  | <GLOBAL>
                  | <GRANT>
                  | <GROUP>
                  | <GROUPING>
                  | <HAVING>
                  | <HOLD>
                  | <HOUR>
                  | <IDENTITY>
                  | <IMMEDIATE>
                  | <IN>
                  | <INDICATOR>
                  | <INNER>
                  | <INOUT>
                  | <INPUT>
                  | <INSENSITIVE>
                  | <INSERT>
                  | <INT>
                  | <INTEGER>
                  | <INTERSECT>
                  | <INTERVAL>
                  | <INTO>
                  | <IS>
                  | <ISOLATION>
                  | <JOIN>
                  | <LANGUAGE>
                  | <LARGE>
                  | <LATERAL>
                  | <LEADING>
                  | <LEFT>
                  | <LIKE>
                  | <LOCAL>
                  | <LOCALTIME>
                  | <LOCALTIMESTAMP>
                  | <MATCH>
                  | <MEMBER>
                  | <MERGE>
                  | <METHOD>
                  | <MINUTE>
                  | <MODIFIES>
                  | <MODULE>
                  | <MONTH>
                  | <MULTISET>
                  | <NATIONAL>
                  | <NATURAL>
                  | <NCHAR>
                  | <NCLOB>
                  | <NEW>
                  | <NO>
                  | <NONE>
                  | <NOT>
                  | <NULL>
                  | <NUMERIC>
                  | <OF>
                  | <OLD>
                  | <ON>
                  | <ONLY>
                  | <OPEN>
                  | <OR>
                  | <ORDER>
                  | <OUT>
                  | <OUTER>
                  | <OUTPUT>
                  | <OVER>
                  | <OVERLAPS>
                  | <PARAMETER>
                  | <PARTITION>
                  | <PRECISION>
                  | <PREPARE>
                  | <PRIMARY>
                  | <PROCEDURE>
                  | <RANGE>
                  | <READS>
                  | <REAL>
                  | <RECURSIVE>
                  | <REF>
                  | <REFERENCES>
                  | <REFERENCING>
                  | <Lex465>
                  | <Lex466>
                  | <Lex467>
                  | <Lex468>
                  | <Lex469>
                  | <Lex470>
                  | <Lex471>
                  | <Lex472>
                  | <Lex473>
                  | <RELEASE>
                  | <RESULT>
                  | <RETURN>
                  | <RETURNS>
                  | <REVOKE>
                  | <RIGHT>
                  | <ROLLBACK>
                  | <ROLLUP>
                  | <ROW>
                  | <ROWS>
                  | <SAVEPOINT>
                  | <SCROLL>
                  | <SEARCH>
                  | <SECOND>
                  | <SELECT>
                  | <SENSITIVE>
                  | <Lex490>
                  | <SET>
                  | <SIMILAR>
                  | <SMALLINT>
                  | <SOME>
                  | <SPECIFIC>
                  | <SPECIFICTYPE>
                  | <SQL>
                  | <SQLEXCEPTION>
                  | <SQLSTATE>
                  | <SQLWARNING>
                  | <START>
                  | <STATIC>
                  | <SUBMULTISET>
                  | <SYMMETRIC>
                  | <SYSTEM>
                  | <Lex506>
                  | <TABLE>
                  | <THEN>
                  | <TIME>
                  | <TIMESTAMP>
                  | <Lex511>
                  | <Lex512>
                  | <TO>
                  | <TRAILING>
                  | <TRANSLATION>
                  | <TREAT>
                  | <TRIGGER>
                  | <TRUE>
                  | <UESCAPE>
                  | <UNION>
                  | <UNIQUE>
                  | <UNKNOWN>
                  | <UNNEST>
                  | <UPDATE>
                  | <UPPER>
                  | <USER>
                  | <USING>
                  | <VALUE>
                  | <VALUES>
                  | <Lex530>
                  | <Lex531>
                  | <VARCHAR>
                  | <VARYING>
                  | <WHEN>
                  | <WHENEVER>
                  | <WHERE>
                  | <Lex537>
                  | <WINDOW>
                  | <WITH>
                  | <WITHIN>
                  | <WITHOUT>
                  | <YEAR>
<Literal> ::= <Signed_Numeric_Literal>
            | <General_Literal>
<Unsigned_Literal> ::= <Unsigned_Numeric_Literal>
                     | <General_Literal>
<General_Literal> ::= <Character_String_Literal>
                    | <National_Character_String_Literal>
                    | <Unicode_Character_String_Literal>
                    | <Binary_String_Literal>
                    | <Datetime_Literal>
                    | <Interval_Literal>
                    | <Boolean_Literal>
<Gen674> ::= <Introducer> <Character_Set_Specification>
<Gen674_maybe> ::= <Gen674>
<Gen674_maybe> ::=
<Character_Representation_any> ::= <Character_Representation>*
<Gen678> ::= <Separator> <Quote> <Character_Representation_any> <Quote>
<Gen678_any> ::= <Gen678>*
<Character_String_Literal> ::= <Gen674_maybe> <Quote> <Character_Representation_any> <Quote> <Gen678_any>
<Introducer> ::= <Underscore>
<Character_Representation> ::= <Nonquote_Character>
                             | <Quote_Symbol>
<Nonquote_Character> ::= <Lex543>
<Quote_Symbol> ::= <Quote> <Quote>
<Gen686> ::= <Separator> <Quote> <Character_Representation_any> <Quote>
<Gen686_any> ::= <Gen686>*
<National_Character_String_Literal> ::= <N> <Quote> <Character_Representation_any> <Quote> <Gen686_any>
<Gen689> ::= <Introducer> <Character_Set_Specification>
<Gen689_maybe> ::= <Gen689>
<Gen689_maybe> ::=
<Unicode_Representation_any> ::= <Unicode_Representation>*
<Gen693> ::= <Separator> <Quote> <Unicode_Representation_any> <Quote>
<Gen693_any> ::= <Gen693>*
<Gen695> ::= <ESCAPE> <Escape_Character>
<Gen695_maybe> ::= <Gen695>
<Gen695_maybe> ::=
<Unicode_Character_String_Literal> ::= <Gen689_maybe> <U> <Ampersand> <Quote> <Unicode_Representation_any> <Quote> <Gen693_any> <Gen695_maybe>
<Unicode_Representation> ::= <Character_Representation>
                           | <Unicode_Escape_Value>
<Gen701> ::= <Hexit> <Hexit>
<Gen701_any> ::= <Gen701>*
<Gen703> ::= <Hexit> <Hexit>
<Gen703_any> ::= <Gen703>*
<Gen705> ::= <Separator> <Quote> <Gen703_any> <Quote>
<Gen705_any> ::= <Gen705>*
<Gen707> ::= <ESCAPE> <Escape_Character>
<Gen707_maybe> ::= <Gen707>
<Gen707_maybe> ::=
<Binary_String_Literal> ::= <X> <Quote> <Gen701_any> <Quote> <Gen705_any> <Gen707_maybe>
<Hexit> ::= <Digit>
          | <A>
          | <B>
          | <C>
          | <D>
          | <E>
          | <F>
          | <a>
          | <b>
          | <c>
          | <d>
          | <e>
          | <f>
<Sign_maybe> ::= <Sign>
<Sign_maybe> ::=
<Signed_Numeric_Literal> ::= <Sign_maybe> <Unsigned_Numeric_Literal>
<Unsigned_Numeric_Literal> ::= <Exact_Numeric_Literal>
                             | <Approximate_Numeric_Literal>
<Unsigned_Integer> ::= <Lex557_many>
<Unsigned_Integer_maybe> ::= <Unsigned_Integer>
<Unsigned_Integer_maybe> ::=
<Gen732> ::= <Period> <Unsigned_Integer_maybe>
<Gen732_maybe> ::= <Gen732>
<Gen732_maybe> ::=
<Exact_Numeric_Literal> ::= <Unsigned_Integer> <Gen732_maybe>
                          | <Period> <Unsigned_Integer>
<Sign> ::= <Plus_Sign>
         | <Minus_Sign>
<Approximate_Numeric_Literal> ::= <Mantissa> <E> <Exponent>
<Mantissa> ::= <Exact_Numeric_Literal>
<Exponent> ::= <Signed_Integer>
<Signed_Integer> ::= <Sign_maybe> <Unsigned_Integer>
<Datetime_Literal> ::= <Date_Literal>
                     | <Time_Literal>
                     | <Timestamp_Literal>
<Date_Literal> ::= <DATE> <Date_String>
<Time_Literal> ::= <TIME> <Time_String>
<Timestamp_Literal> ::= <TIMESTAMP> <Timestamp_String>
<Date_String> ::= <Quote> <Unquoted_Date_String> <Quote>
<Time_String> ::= <Quote> <Unquoted_Time_String> <Quote>
<Timestamp_String> ::= <Quote> <Unquoted_Timestamp_String> <Quote>
<Time_Zone_Interval> ::= <Sign> <Hours_Value> <Colon> <Minutes_Value>
<Date_Value> ::= <Years_Value> <Minus_Sign> <Months_Value> <Minus_Sign> <Days_Value>
<Time_Value> ::= <Hours_Value> <Colon> <Minutes_Value> <Colon> <Seconds_Value>
<Interval_Literal> ::= <INTERVAL> <Sign_maybe> <Interval_String> <Interval_Qualifier>
<Interval_String> ::= <Quote> <Unquoted_Interval_String> <Quote>
<Unquoted_Date_String> ::= <Date_Value>
<Time_Zone_Interval_maybe> ::= <Time_Zone_Interval>
<Time_Zone_Interval_maybe> ::=
<Unquoted_Time_String> ::= <Time_Value> <Time_Zone_Interval_maybe>
<Unquoted_Timestamp_String> ::= <Unquoted_Date_String> <Space> <Unquoted_Time_String>
<Gen762> ::= <Year_Month_Literal>
           | <Day_Time_Literal>
<Unquoted_Interval_String> ::= <Sign_maybe> <Gen762>
<Gen765> ::= <Years_Value> <Minus_Sign>
<Gen765_maybe> ::= <Gen765>
<Gen765_maybe> ::=
<Year_Month_Literal> ::= <Years_Value>
                       | <Gen765_maybe> <Months_Value>
<Day_Time_Literal> ::= <Day_Time_Interval>
                     | <Time_Interval>
<Gen772> ::= <Colon> <Seconds_Value>
<Gen772_maybe> ::= <Gen772>
<Gen772_maybe> ::=
<Gen775> ::= <Colon> <Minutes_Value> <Gen772_maybe>
<Gen775_maybe> ::= <Gen775>
<Gen775_maybe> ::=
<Gen778> ::= <Space> <Hours_Value> <Gen775_maybe>
<Gen778_maybe> ::= <Gen778>
<Gen778_maybe> ::=
<Day_Time_Interval> ::= <Days_Value> <Gen778_maybe>
<Gen782> ::= <Colon> <Seconds_Value>
<Gen782_maybe> ::= <Gen782>
<Gen782_maybe> ::=
<Gen785> ::= <Colon> <Minutes_Value> <Gen782_maybe>
<Gen785_maybe> ::= <Gen785>
<Gen785_maybe> ::=
<Gen788> ::= <Colon> <Seconds_Value>
<Gen788_maybe> ::= <Gen788>
<Gen788_maybe> ::=
<Time_Interval> ::= <Hours_Value> <Gen785_maybe>
                  | <Minutes_Value> <Gen788_maybe>
                  | <Seconds_Value>
<Years_Value> ::= <Datetime_Value>
<Months_Value> ::= <Datetime_Value>
<Days_Value> ::= <Datetime_Value>
<Hours_Value> ::= <Datetime_Value>
<Minutes_Value> ::= <Datetime_Value>
<Seconds_Fraction_maybe> ::= <Seconds_Fraction>
<Seconds_Fraction_maybe> ::=
<Gen801> ::= <Period> <Seconds_Fraction_maybe>
<Gen801_maybe> ::= <Gen801>
<Gen801_maybe> ::=
<Seconds_Value> ::= <Seconds_Integer_Value> <Gen801_maybe>
<Seconds_Integer_Value> ::= <Unsigned_Integer>
<Seconds_Fraction> ::= <Unsigned_Integer>
<Datetime_Value> ::= <Unsigned_Integer>
<Boolean_Literal> ::= <TRUE>
                    | <FALSE>
                    | <UNKNOWN>
<Identifier> ::= <Actual_Identifier>
<Actual_Identifier> ::= <Regular_Identifier>
                      | <Delimited_Identifier>
<GenLex814> ~ <Lex559>
<GenLex814_any> ~ <GenLex814>*
<SQL_Language_Identifier> ~ <Lex558> <GenLex814_any>
<Authorization_Identifier> ::= <Role_Name>
                             | <User_Identifier>
<Table_Name> ::= <Local_Or_Schema_Qualified_Name>
<Domain_Name> ::= <Schema_Qualified_Name>
<Unqualified_Schema_Name> ::= <Identifier>
<Gen822> ::= <Catalog_Name> <Period>
<Gen822_maybe> ::= <Gen822>
<Gen822_maybe> ::=
<Schema_Name> ::= <Gen822_maybe> <Unqualified_Schema_Name>
<Catalog_Name> ::= <Identifier>
<Gen827> ::= <Schema_Name> <Period>
<Gen827_maybe> ::= <Gen827>
<Gen827_maybe> ::=
<Schema_Qualified_Name> ::= <Gen827_maybe> <Qualified_Identifier>
<Gen831> ::= <Local_Or_Schema_Qualifier> <Period>
<Gen831_maybe> ::= <Gen831>
<Gen831_maybe> ::=
<Local_Or_Schema_Qualified_Name> ::= <Gen831_maybe> <Qualified_Identifier>
<Local_Or_Schema_Qualifier> ::= <Schema_Name>
                              | <MODULE>
<Qualified_Identifier> ::= <Identifier>
<Column_Name> ::= <Identifier>
<Correlation_Name> ::= <Identifier>
<Query_Name> ::= <Identifier>
<SQL_Client_Module_Name> ::= <Identifier>
<Procedure_Name> ::= <Identifier>
<Schema_Qualified_Routine_Name> ::= <Schema_Qualified_Name>
<Method_Name> ::= <Identifier>
<Specific_Name> ::= <Schema_Qualified_Name>
<Cursor_Name> ::= <Local_Qualified_Name>
<Gen847> ::= <Local_Qualifier> <Period>
<Gen847_maybe> ::= <Gen847>
<Gen847_maybe> ::=
<Local_Qualified_Name> ::= <Gen847_maybe> <Qualified_Identifier>
<Local_Qualifier> ::= <MODULE>
<Host_Parameter_Name> ::= <Colon> <Identifier>
<SQL_Parameter_Name> ::= <Identifier>
<Constraint_Name> ::= <Schema_Qualified_Name>
<External_Routine_Name> ::= <Identifier>
                          | <Character_String_Literal>
<Trigger_Name> ::= <Schema_Qualified_Name>
<Collation_Name> ::= <Schema_Qualified_Name>
<Gen859> ::= <Schema_Name> <Period>
<Gen859_maybe> ::= <Gen859>
<Gen859_maybe> ::=
<Character_Set_Name> ::= <Gen859_maybe> <SQL_Language_Identifier>
<Transliteration_Name> ::= <Schema_Qualified_Name>
<Transcoding_Name> ::= <Schema_Qualified_Name>
<User_Defined_Type_Name> ::= <Schema_Qualified_Type_Name>
<Schema_Resolved_User_Defined_Type_Name> ::= <User_Defined_Type_Name>
<Gen867> ::= <Schema_Name> <Period>
<Gen867_maybe> ::= <Gen867>
<Gen867_maybe> ::=
<Schema_Qualified_Type_Name> ::= <Gen867_maybe> <Qualified_Identifier>
<Attribute_Name> ::= <Identifier>
<Field_Name> ::= <Identifier>
<Savepoint_Name> ::= <Identifier>
<Sequence_Generator_Name> ::= <Schema_Qualified_Name>
<Role_Name> ::= <Identifier>
<User_Identifier> ::= <Identifier>
<Connection_Name> ::= <Simple_Value_Specification>
<Sql_Server_Name> ::= <Simple_Value_Specification>
<Connection_User_Name> ::= <Simple_Value_Specification>
<SQL_Statement_Name> ::= <Statement_Name>
                       | <Extended_Statement_Name>
<Statement_Name> ::= <Identifier>
<Scope_Option_maybe> ::= <Scope_Option>
<Scope_Option_maybe> ::=
<Extended_Statement_Name> ::= <Scope_Option_maybe> <Simple_Value_Specification>
<Dynamic_Cursor_Name> ::= <Cursor_Name>
                        | <Extended_Cursor_Name>
<Extended_Cursor_Name> ::= <Scope_Option_maybe> <Simple_Value_Specification>
<Descriptor_Name> ::= <Scope_Option_maybe> <Simple_Value_Specification>
<Scope_Option> ::= <GLOBAL>
                 | <LOCAL>
<Window_Name> ::= <Identifier>
<Data_Type> ::= <Predefined_Type>
              | <Row_Type>
              | <Path_Resolved_User_Defined_Type_Name>
              | <Reference_Type>
              | <Collection_Type>
<Gen898> ::= <CHARACTER> <SET> <Character_Set_Specification>
<Gen898_maybe> ::= <Gen898>
<Gen898_maybe> ::=
<Collate_Clause_maybe> ::= <Collate_Clause>
<Collate_Clause_maybe> ::=
<Predefined_Type> ::= <Character_String_Type> <Gen898_maybe> <Collate_Clause_maybe>
                    | <National_Character_String_Type> <Collate_Clause_maybe>
                    | <Binary_Large_Object_String_Type>
                    | <Numeric_Type>
                    | <Boolean_Type>
                    | <Datetime_Type>
                    | <Interval_Type>
<Gen910> ::= <Left_Paren> <Length> <Right_Paren>
<Gen910_maybe> ::= <Gen910>
<Gen910_maybe> ::=
<Gen913> ::= <Left_Paren> <Length> <Right_Paren>
<Gen913_maybe> ::= <Gen913>
<Gen913_maybe> ::=
<Gen916> ::= <Left_Paren> <Large_Object_Length> <Right_Paren>
<Gen916_maybe> ::= <Gen916>
<Gen916_maybe> ::=
<Gen919> ::= <Left_Paren> <Large_Object_Length> <Right_Paren>
<Gen919_maybe> ::= <Gen919>
<Gen919_maybe> ::=
<Gen922> ::= <Left_Paren> <Large_Object_Length> <Right_Paren>
<Gen922_maybe> ::= <Gen922>
<Gen922_maybe> ::=
<Character_String_Type> ::= <CHARACTER> <Gen910_maybe>
                          | <CHAR> <Gen913_maybe>
                          | <CHARACTER> <VARYING> <Left_Paren> <Length> <Right_Paren>
                          | <CHAR> <VARYING> <Left_Paren> <Length> <Right_Paren>
                          | <VARCHAR> <Left_Paren> <Length> <Right_Paren>
                          | <CHARACTER> <LARGE> <OBJECT> <Gen916_maybe>
                          | <CHAR> <LARGE> <OBJECT> <Gen919_maybe>
                          | <CLOB> <Gen922_maybe>
<Gen933> ::= <Left_Paren> <Length> <Right_Paren>
<Gen933_maybe> ::= <Gen933>
<Gen933_maybe> ::=
<Gen936> ::= <Left_Paren> <Length> <Right_Paren>
<Gen936_maybe> ::= <Gen936>
<Gen936_maybe> ::=
<Gen939> ::= <Left_Paren> <Length> <Right_Paren>
<Gen939_maybe> ::= <Gen939>
<Gen939_maybe> ::=
<Gen942> ::= <Left_Paren> <Large_Object_Length> <Right_Paren>
<Gen942_maybe> ::= <Gen942>
<Gen942_maybe> ::=
<Gen945> ::= <Left_Paren> <Large_Object_Length> <Right_Paren>
<Gen945_maybe> ::= <Gen945>
<Gen945_maybe> ::=
<Gen948> ::= <Left_Paren> <Large_Object_Length> <Right_Paren>
<Gen948_maybe> ::= <Gen948>
<Gen948_maybe> ::=
<National_Character_String_Type> ::= <NATIONAL> <CHARACTER> <Gen933_maybe>
                                   | <NATIONAL> <CHAR> <Gen936_maybe>
                                   | <NCHAR> <Gen939_maybe>
                                   | <NATIONAL> <CHARACTER> <VARYING> <Left_Paren> <Length> <Right_Paren>
                                   | <NATIONAL> <CHAR> <VARYING> <Left_Paren> <Length> <Right_Paren>
                                   | <NCHAR> <VARYING> <Left_Paren> <Length> <Right_Paren>
                                   | <NATIONAL> <CHARACTER> <LARGE> <OBJECT> <Gen942_maybe>
                                   | <NCHAR> <LARGE> <OBJECT> <Gen945_maybe>
                                   | <NCLOB> <Gen948_maybe>
<Gen960> ::= <Left_Paren> <Large_Object_Length> <Right_Paren>
<Gen960_maybe> ::= <Gen960>
<Gen960_maybe> ::=
<Gen963> ::= <Left_Paren> <Large_Object_Length> <Right_Paren>
<Gen963_maybe> ::= <Gen963>
<Gen963_maybe> ::=
<Binary_Large_Object_String_Type> ::= <BINARY> <LARGE> <OBJECT> <Gen960_maybe>
                                    | <BLOB> <Gen963_maybe>
<Numeric_Type> ::= <Exact_Numeric_Type>
                 | <Approximate_Numeric_Type>
<Gen970> ::= <Comma> <Scale>
<Gen970_maybe> ::= <Gen970>
<Gen970_maybe> ::=
<Gen973> ::= <Left_Paren> <Precision> <Gen970_maybe> <Right_Paren>
<Gen973_maybe> ::= <Gen973>
<Gen973_maybe> ::=
<Gen976> ::= <Comma> <Scale>
<Gen976_maybe> ::= <Gen976>
<Gen976_maybe> ::=
<Gen979> ::= <Left_Paren> <Precision> <Gen976_maybe> <Right_Paren>
<Gen979_maybe> ::= <Gen979>
<Gen979_maybe> ::=
<Gen982> ::= <Comma> <Scale>
<Gen982_maybe> ::= <Gen982>
<Gen982_maybe> ::=
<Gen985> ::= <Left_Paren> <Precision> <Gen982_maybe> <Right_Paren>
<Gen985_maybe> ::= <Gen985>
<Gen985_maybe> ::=
<Exact_Numeric_Type> ::= <NUMERIC> <Gen973_maybe>
                       | <DECIMAL> <Gen979_maybe>
                       | <DEC> <Gen985_maybe>
                       | <SMALLINT>
                       | <INTEGER>
                       | <INT>
                       | <BIGINT>
<Gen995> ::= <Left_Paren> <Precision> <Right_Paren>
<Gen995_maybe> ::= <Gen995>
<Gen995_maybe> ::=
<Approximate_Numeric_Type> ::= <FLOAT> <Gen995_maybe>
                             | <REAL>
                             | <DOUBLE> <PRECISION>
<Length> ::= <Unsigned_Integer>
<Multiplier_maybe> ::= <Multiplier>
<Multiplier_maybe> ::=
<Char_Length_Units_maybe> ::= <Char_Length_Units>
<Char_Length_Units_maybe> ::=
<Large_Object_Length> ::= <Unsigned_Integer> <Multiplier_maybe> <Char_Length_Units_maybe>
                        | <Large_Object_Length_Token> <Char_Length_Units_maybe>
<Char_Length_Units> ::= <CHARACTERS>
                      | <Lex086>
                      | <OCTETS>
<Precision> ::= <Unsigned_Integer>
<Scale> ::= <Unsigned_Integer>
<Boolean_Type> ::= <BOOLEAN>
<Gen1014> ::= <Left_Paren> <Time_Precision> <Right_Paren>
<Gen1014_maybe> ::= <Gen1014>
<Gen1014_maybe> ::=
<Gen1017> ::= <With_Or_Without_Time_Zone>
<Gen1017_maybe> ::= <Gen1017>
<Gen1017_maybe> ::=
<Gen1020> ::= <Left_Paren> <Timestamp_Precision> <Right_Paren>
<Gen1020_maybe> ::= <Gen1020>
<Gen1020_maybe> ::=
<Gen1023> ::= <With_Or_Without_Time_Zone>
<Gen1023_maybe> ::= <Gen1023>
<Gen1023_maybe> ::=
<Datetime_Type> ::= <DATE>
                  | <TIME> <Gen1014_maybe> <Gen1017_maybe>
                  | <TIMESTAMP> <Gen1020_maybe> <Gen1023_maybe>
<With_Or_Without_Time_Zone> ::= <WITH> <TIME> <ZONE>
                              | <WITHOUT> <TIME> <ZONE>
<Time_Precision> ::= <Time_Fractional_Seconds_Precision>
<Timestamp_Precision> ::= <Time_Fractional_Seconds_Precision>
<Time_Fractional_Seconds_Precision> ::= <Unsigned_Integer>
<Interval_Type> ::= <INTERVAL> <Interval_Qualifier>
<Row_Type> ::= <ROW> <Row_Type_Body>
<Gen1036> ::= <Comma> <Field_Definition>
<Gen1036_any> ::= <Gen1036>*
<Row_Type_Body> ::= <Left_Paren> <Field_Definition> <Gen1036_any> <Right_Paren>
<Scope_Clause_maybe> ::= <Scope_Clause>
<Scope_Clause_maybe> ::=
<Reference_Type> ::= <REF> <Left_Paren> <Referenced_Type> <Right_Paren> <Scope_Clause_maybe>
<Scope_Clause> ::= <SCOPE> <Table_Name>
<Referenced_Type> ::= <Path_Resolved_User_Defined_Type_Name>
<Path_Resolved_User_Defined_Type_Name> ::= <User_Defined_Type_Name>
<Collection_Type> ::= <Array_Type>
                    | <Multiset_Type>
<Gen1047> ::= <Left_Bracket_Or_Trigraph> <Unsigned_Integer> <Right_Bracket_Or_Trigraph>
<Gen1047_maybe> ::= <Gen1047>
<Gen1047_maybe> ::=
<Array_Type> ::= <Data_Type> <ARRAY> <Gen1047_maybe>
<Multiset_Type> ::= <Data_Type> <MULTISET>
<Reference_Scope_Check_maybe> ::= <Reference_Scope_Check>
<Reference_Scope_Check_maybe> ::=
<Field_Definition> ::= <Field_Name> <Data_Type> <Reference_Scope_Check_maybe>
<Value_Expression_Primary> ::= <Parenthesized_Value_Expression>
                             | <Nonparenthesized_Value_Expression_Primary>
<Parenthesized_Value_Expression> ::= <Left_Paren> <Value_Expression> <Right_Paren>
<Nonparenthesized_Value_Expression_Primary> ::= <Unsigned_Value_Specification>
                                              | <Column_Reference>
                                              | <Set_Function_Specification>
                                              | <Window_Function>
                                              | <Scalar_Subquery>
                                              | <Case_Expression>
                                              | <Cast_Specification>
                                              | <Field_Reference>
                                              | <Subtype_Treatment>
                                              | <Method_Invocation>
                                              | <Static_Method_Invocation>
                                              | <New_Specification>
                                              | <Attribute_Or_Method_Reference>
                                              | <Reference_Resolution>
                                              | <Collection_Value_Constructor>
                                              | <Array_Element_Reference>
                                              | <Multiset_Element_Reference>
                                              | <Routine_Invocation>
                                              | <Next_Value_Expression>
<Value_Specification> ::= <Literal>
                        | <General_Value_Specification>
<Unsigned_Value_Specification> ::= <Unsigned_Literal>
                                 | <General_Value_Specification>
<General_Value_Specification> ::= <Host_Parameter_Specification>
                                | <SQL_Parameter_Reference>
                                | <Dynamic_Parameter_Specification>
                                | <Embedded_Variable_Specification>
                                | <Current_Collation_Specification>
                                | <Lex342>
                                | <Lex343>
                                | <Lex344>
                                | <Lex347> <Path_Resolved_User_Defined_Type_Name>
                                | <Lex348>
                                | <Lex490>
                                | <Lex506>
                                | <USER>
                                | <VALUE>
<Simple_Value_Specification> ::= <Literal>
                               | <Host_Parameter_Name>
                               | <SQL_Parameter_Reference>
                               | <Embedded_Variable_Name>
<Target_Specification> ::= <Host_Parameter_Specification>
                         | <SQL_Parameter_Reference>
                         | <Column_Reference>
                         | <Target_Array_Element_Specification>
                         | <Dynamic_Parameter_Specification>
                         | <Embedded_Variable_Specification>
<Simple_Target_Specification> ::= <Host_Parameter_Specification>
                                | <SQL_Parameter_Reference>
                                | <Column_Reference>
                                | <Embedded_Variable_Name>
<Indicator_Parameter_maybe> ::= <Indicator_Parameter>
<Indicator_Parameter_maybe> ::=
<Host_Parameter_Specification> ::= <Host_Parameter_Name> <Indicator_Parameter_maybe>
<Dynamic_Parameter_Specification> ::= <Question_Mark>
<Indicator_Variable_maybe> ::= <Indicator_Variable>
<Indicator_Variable_maybe> ::=
<Embedded_Variable_Specification> ::= <Embedded_Variable_Name> <Indicator_Variable_maybe>
<INDICATOR_maybe> ::= <INDICATOR>
<INDICATOR_maybe> ::=
<Indicator_Variable> ::= <INDICATOR_maybe> <Embedded_Variable_Name>
<Indicator_Parameter> ::= <INDICATOR_maybe> <Host_Parameter_Name>
<Target_Array_Element_Specification> ::= <Target_Array_Reference> <Left_Bracket_Or_Trigraph> <Simple_Value_Specification> <Right_Bracket_Or_Trigraph>
<Target_Array_Reference> ::= <SQL_Parameter_Reference>
                           | <Column_Reference>
<Current_Collation_Specification> ::= <Lex111> <Left_Paren> <String_Value_Expression> <Right_Paren>
<Contextually_Typed_Value_Specification> ::= <Implicitly_Typed_Value_Specification>
                                           | <Default_Specification>
<Implicitly_Typed_Value_Specification> ::= <Null_Specification>
                                         | <Empty_Specification>
<Null_Specification> ::= <NULL>
<Empty_Specification> ::= <ARRAY> <Left_Bracket_Or_Trigraph> <Right_Bracket_Or_Trigraph>
                        | <MULTISET> <Left_Bracket_Or_Trigraph> <Right_Bracket_Or_Trigraph>
<Default_Specification> ::= <DEFAULT>
<Gen1132> ::= <Period> <Identifier>
<Gen1132_any> ::= <Gen1132>*
<Identifier_Chain> ::= <Identifier> <Gen1132_any>
<Basic_Identifier_Chain> ::= <Identifier_Chain>
<Column_Reference> ::= <Basic_Identifier_Chain>
                     | <MODULE> <Period> <Qualified_Identifier> <Period> <Column_Name>
<SQL_Parameter_Reference> ::= <Basic_Identifier_Chain>
<Set_Function_Specification> ::= <Aggregate_Function>
                               | <Grouping_Operation>
<Gen1141> ::= <Comma> <Column_Reference>
<Gen1141_any> ::= <Gen1141>*
<Grouping_Operation> ::= <GROUPING> <Left_Paren> <Column_Reference> <Gen1141_any> <Right_Paren>
<Window_Function> ::= <Window_Function_Type> <OVER> <Window_Name_Or_Specification>
<Window_Function_Type> ::= <Rank_Function_Type> <Left_Paren> <Right_Paren>
                         | <Lex238> <Left_Paren> <Right_Paren>
                         | <Aggregate_Function>
<Rank_Function_Type> ::= <RANK>
                       | <Lex122>
                       | <Lex213>
                       | <Lex110>
<Window_Name_Or_Specification> ::= <Window_Name>
                                 | <In_Line_Window_Specification>
<In_Line_Window_Specification> ::= <Window_Specification>
<Case_Expression> ::= <Case_Abbreviation>
                    | <Case_Specification>
<Gen1157> ::= <Comma> <Value_Expression>
<Gen1157_many> ::= <Gen1157>+
<Case_Abbreviation> ::= <NULLIF> <Left_Paren> <Value_Expression> <Comma> <Value_Expression> <Right_Paren>
                      | <COALESCE> <Left_Paren> <Value_Expression> <Gen1157_many> <Right_Paren>
<Case_Specification> ::= <Simple_Case>
                       | <Searched_Case>
<Simple_When_Clause_many> ::= <Simple_When_Clause>+
<Else_Clause_maybe> ::= <Else_Clause>
<Else_Clause_maybe> ::=
<Simple_Case> ::= <CASE> <Case_Operand> <Simple_When_Clause_many> <Else_Clause_maybe> <END>
<Searched_When_Clause_many> ::= <Searched_When_Clause>+
<Searched_Case> ::= <CASE> <Searched_When_Clause_many> <Else_Clause_maybe> <END>
<Simple_When_Clause> ::= <WHEN> <When_Operand> <THEN> <Result>
<Searched_When_Clause> ::= <WHEN> <Search_Condition> <THEN> <Result>
<Else_Clause> ::= <ELSE> <Result>
<Case_Operand> ::= <Row_Value_Predicand>
                 | <Overlaps_Predicate>
<When_Operand> ::= <Row_Value_Predicand>
                 | <Comparison_Predicate_Part_2>
                 | <Between_Predicate_Part_2>
                 | <In_Predicate_Part_2>
                 | <Character_Like_Predicate_Part_2>
                 | <Octet_Like_Predicate_Part_2>
                 | <Similar_Predicate_Part_2>
                 | <Null_Predicate_Part_2>
                 | <Quantified_Comparison_Predicate_Part_2>
                 | <Match_Predicate_Part_2>
                 | <Overlaps_Predicate_Part_2>
                 | <Distinct_Predicate_Part_2>
                 | <Member_Predicate_Part_2>
                 | <Submultiset_Predicate_Part_2>
                 | <Set_Predicate_Part_2>
                 | <Type_Predicate_Part_2>
<Result> ::= <Result_Expression>
           | <NULL>
<Result_Expression> ::= <Value_Expression>
<Cast_Specification> ::= <CAST> <Left_Paren> <Cast_Operand> <AS> <Cast_Target> <Right_Paren>
<Cast_Operand> ::= <Value_Expression>
                 | <Implicitly_Typed_Value_Specification>
<Cast_Target> ::= <Domain_Name>
                | <Data_Type>
<Next_Value_Expression> ::= <NEXT> <VALUE> <FOR> <Sequence_Generator_Name>
<Field_Reference> ::= <Value_Expression_Primary> <Period> <Field_Name>
<Subtype_Treatment> ::= <TREAT> <Left_Paren> <Subtype_Operand> <AS> <Target_Subtype> <Right_Paren>
<Subtype_Operand> ::= <Value_Expression>
<Target_Subtype> ::= <Path_Resolved_User_Defined_Type_Name>
                   | <Reference_Type>
<Method_Invocation> ::= <Direct_Invocation>
                      | <Generalized_Invocation>
<SQL_Argument_List_maybe> ::= <SQL_Argument_List>
<SQL_Argument_List_maybe> ::=
<Direct_Invocation> ::= <Value_Expression_Primary> <Period> <Method_Name> <SQL_Argument_List_maybe>
<Generalized_Invocation> ::= <Left_Paren> <Value_Expression_Primary> <AS> <Data_Type> <Right_Paren> <Period> <Method_Name> <SQL_Argument_List_maybe>
<Method_Selection> ::= <Routine_Invocation>
<Constructor_Method_Selection> ::= <Routine_Invocation>
<Static_Method_Invocation> ::= <Path_Resolved_User_Defined_Type_Name> <Double_Colon> <Method_Name> <SQL_Argument_List_maybe>
<Static_Method_Selection> ::= <Routine_Invocation>
<New_Specification> ::= <NEW> <Routine_Invocation>
<New_Invocation> ::= <Method_Invocation>
                   | <Routine_Invocation>
<Attribute_Or_Method_Reference> ::= <Value_Expression_Primary> <Dereference_Operator> <Qualified_Identifier> <SQL_Argument_List_maybe>
<Dereference_Operator> ::= <Right_Arrow>
<Dereference_Operation> ::= <Reference_Value_Expression> <Dereference_Operator> <Attribute_Name>
<Method_Reference> ::= <Value_Expression_Primary> <Dereference_Operator> <Method_Name> <SQL_Argument_List>
<Reference_Resolution> ::= <DEREF> <Left_Paren> <Reference_Value_Expression> <Right_Paren>
<Array_Element_Reference> ::= <Array_Value_Expression> <Left_Bracket_Or_Trigraph> <Numeric_Value_Expression> <Right_Bracket_Or_Trigraph>
<Multiset_Element_Reference> ::= <ELEMENT> <Left_Paren> <Multiset_Value_Expression> <Right_Paren>
<Value_Expression> ::= <Common_Value_Expression>
                     | <Boolean_Value_Expression>
                     | <Row_Value_Expression>
<Common_Value_Expression> ::= <Numeric_Value_Expression>
                            | <String_Value_Expression>
                            | <Datetime_Value_Expression>
                            | <Interval_Value_Expression>
                            | <User_Defined_Type_Value_Expression>
                            | <Reference_Value_Expression>
                            | <Collection_Value_Expression>
<User_Defined_Type_Value_Expression> ::= <Value_Expression_Primary>
<Reference_Value_Expression> ::= <Value_Expression_Primary>
<Collection_Value_Expression> ::= <Array_Value_Expression>
                                | <Multiset_Value_Expression>
<Collection_Value_Constructor> ::= <Array_Value_Constructor>
                                 | <Multiset_Value_Constructor>
<Numeric_Value_Expression> ::= <Term>
                             | <Numeric_Value_Expression> <Plus_Sign> <Term>
                             | <Numeric_Value_Expression> <Minus_Sign> <Term>
<Term> ::= <Factor>
         | <Term> <Asterisk> <Factor>
         | <Term> <Solidus> <Factor>
<Factor> ::= <Sign_maybe> <Numeric_Primary>
<Numeric_Primary> ::= <Value_Expression_Primary>
                    | <Numeric_Value_Function>
<Numeric_Value_Function> ::= <Position_Expression>
                           | <Extract_Expression>
                           | <Length_Expression>
                           | <Cardinality_Expression>
                           | <Absolute_Value_Expression>
                           | <Modulus_Expression>
                           | <Natural_Logarithm>
                           | <Exponential_Function>
                           | <Power_Function>
                           | <Square_Root>
                           | <Floor_Function>
                           | <Ceiling_Function>
                           | <Width_Bucket_Function>
<Position_Expression> ::= <String_Position_Expression>
                        | <Blob_Position_Expression>
<Gen1264> ::= <USING> <Char_Length_Units>
<Gen1264_maybe> ::= <Gen1264>
<Gen1264_maybe> ::=
<String_Position_Expression> ::= <POSITION> <Left_Paren> <String_Value_Expression> <IN> <String_Value_Expression> <Gen1264_maybe> <Right_Paren>
<Blob_Position_Expression> ::= <POSITION> <Left_Paren> <Blob_Value_Expression> <IN> <Blob_Value_Expression> <Right_Paren>
<Length_Expression> ::= <Char_Length_Expression>
                      | <Octet_Length_Expression>
<Gen1271> ::= <Lex081>
            | <Lex077>
<Gen1273> ::= <USING> <Char_Length_Units>
<Gen1273_maybe> ::= <Gen1273>
<Gen1273_maybe> ::=
<Char_Length_Expression> ::= <Gen1271> <Left_Paren> <String_Value_Expression> <Gen1273_maybe> <Right_Paren>
<Octet_Length_Expression> ::= <Lex193> <Left_Paren> <String_Value_Expression> <Right_Paren>
<Extract_Expression> ::= <EXTRACT> <Left_Paren> <Extract_Field> <FROM> <Extract_Source> <Right_Paren>
<Extract_Field> ::= <Primary_Datetime_Field>
                  | <Time_Zone_Field>
<Time_Zone_Field> ::= <Lex511>
                    | <Lex512>
<Extract_Source> ::= <Datetime_Value_Expression>
                   | <Interval_Value_Expression>
<Cardinality_Expression> ::= <CARDINALITY> <Left_Paren> <Collection_Value_Expression> <Right_Paren>
<Absolute_Value_Expression> ::= <ABS> <Left_Paren> <Numeric_Value_Expression> <Right_Paren>
<Modulus_Expression> ::= <MOD> <Left_Paren> <Numeric_Value_Expression> <Comma> <Numeric_Value_Expression> <Right_Paren>
<Natural_Logarithm> ::= <LN> <Left_Paren> <Numeric_Value_Expression> <Right_Paren>
<Exponential_Function> ::= <EXP> <Left_Paren> <Numeric_Value_Expression> <Right_Paren>
<Power_Function> ::= <POWER> <Left_Paren> <Numeric_Value_Expression_Base> <Comma> <Numeric_Value_Expression_Exponent> <Right_Paren>
<Numeric_Value_Expression_Base> ::= <Numeric_Value_Expression>
<Numeric_Value_Expression_Exponent> ::= <Numeric_Value_Expression>
<Square_Root> ::= <SQRT> <Left_Paren> <Numeric_Value_Expression> <Right_Paren>
<Floor_Function> ::= <FLOOR> <Left_Paren> <Numeric_Value_Expression> <Right_Paren>
<Gen1295> ::= <CEIL>
            | <CEILING>
<Ceiling_Function> ::= <Gen1295> <Left_Paren> <Numeric_Value_Expression> <Right_Paren>
<Width_Bucket_Function> ::= <Lex537> <Left_Paren> <Width_Bucket_Operand> <Comma> <Width_Bucket_Bound_1> <Comma> <Width_Bucket_Bound_2> <Comma> <Width_Bucket_Count> <Right_Paren>
<Width_Bucket_Operand> ::= <Numeric_Value_Expression>
<Width_Bucket_Bound_1> ::= <Numeric_Value_Expression>
<Width_Bucket_Bound_2> ::= <Numeric_Value_Expression>
<Width_Bucket_Count> ::= <Numeric_Value_Expression>
<String_Value_Expression> ::= <Character_Value_Expression>
                            | <Blob_Value_Expression>
<Character_Value_Expression> ::= <Concatenation>
                               | <Character_Factor>
<Concatenation> ::= <Character_Value_Expression> <Concatenation_Operator> <Character_Factor>
<Character_Factor> ::= <Character_Primary> <Collate_Clause_maybe>
<Character_Primary> ::= <Value_Expression_Primary>
                      | <String_Value_Function>
<Blob_Value_Expression> ::= <Blob_Concatenation>
                          | <Blob_Factor>
<Blob_Factor> ::= <Blob_Primary>
<Blob_Primary> ::= <Value_Expression_Primary>
                 | <String_Value_Function>
<Blob_Concatenation> ::= <Blob_Value_Expression> <Concatenation_Operator> <Blob_Factor>
<String_Value_Function> ::= <Character_Value_Function>
                          | <Blob_Value_Function>
<Character_Value_Function> ::= <Character_Substring_Function>
                             | <Regular_Expression_Substring_Function>
                             | <Fold>
                             | <Transcoding>
                             | <Character_Transliteration>
                             | <Trim_Function>
                             | <Character_Overlay_Function>
                             | <Normalize_Function>
                             | <Specific_Type_Method>
<Gen1328> ::= <FOR> <String_Length>
<Gen1328_maybe> ::= <Gen1328>
<Gen1328_maybe> ::=
<Gen1331> ::= <USING> <Char_Length_Units>
<Gen1331_maybe> ::= <Gen1331>
<Gen1331_maybe> ::=
<Character_Substring_Function> ::= <SUBSTRING> <Left_Paren> <Character_Value_Expression> <FROM> <Start_Position> <Gen1328_maybe> <Gen1331_maybe> <Right_Paren>
<Regular_Expression_Substring_Function> ::= <SUBSTRING> <Left_Paren> <Character_Value_Expression> <SIMILAR> <Character_Value_Expression> <ESCAPE> <Escape_Character> <Right_Paren>
<Gen1336> ::= <UPPER>
            | <LOWER>
<Fold> ::= <Gen1336> <Left_Paren> <Character_Value_Expression> <Right_Paren>
<Transcoding> ::= <CONVERT> <Left_Paren> <Character_Value_Expression> <USING> <Transcoding_Name> <Right_Paren>
<Character_Transliteration> ::= <TRANSLATE> <Left_Paren> <Character_Value_Expression> <USING> <Transliteration_Name> <Right_Paren>
<Trim_Function> ::= <TRIM> <Left_Paren> <Trim_Operands> <Right_Paren>
<Trim_Specification_maybe> ::= <Trim_Specification>
<Trim_Specification_maybe> ::=
<Trim_Character_maybe> ::= <Trim_Character>
<Trim_Character_maybe> ::=
<Gen1346> ::= <Trim_Specification_maybe> <Trim_Character_maybe> <FROM>
<Gen1346_maybe> ::= <Gen1346>
<Gen1346_maybe> ::=
<Trim_Operands> ::= <Gen1346_maybe> <Trim_Source>
<Trim_Source> ::= <Character_Value_Expression>
<Trim_Specification> ::= <LEADING>
                       | <TRAILING>
                       | <BOTH>
<Trim_Character> ::= <Character_Value_Expression>
<Gen1355> ::= <FOR> <String_Length>
<Gen1355_maybe> ::= <Gen1355>
<Gen1355_maybe> ::=
<Gen1358> ::= <USING> <Char_Length_Units>
<Gen1358_maybe> ::= <Gen1358>
<Gen1358_maybe> ::=
<Character_Overlay_Function> ::= <OVERLAY> <Left_Paren> <Character_Value_Expression> <PLACING> <Character_Value_Expression> <FROM> <Start_Position> <Gen1355_maybe> <Gen1358_maybe> <Right_Paren>
<Normalize_Function> ::= <NORMALIZE> <Left_Paren> <Character_Value_Expression> <Right_Paren>
<Specific_Type_Method> ::= <User_Defined_Type_Value_Expression> <Period> <SPECIFICTYPE>
<Blob_Value_Function> ::= <Blob_Substring_Function>
                        | <Blob_Trim_Function>
                        | <Blob_Overlay_Function>
<Gen1367> ::= <FOR> <String_Length>
<Gen1367_maybe> ::= <Gen1367>
<Gen1367_maybe> ::=
<Blob_Substring_Function> ::= <SUBSTRING> <Left_Paren> <Blob_Value_Expression> <FROM> <Start_Position> <Gen1367_maybe> <Right_Paren>
<Blob_Trim_Function> ::= <TRIM> <Left_Paren> <Blob_Trim_Operands> <Right_Paren>
<Trim_Octet_maybe> ::= <Trim_Octet>
<Trim_Octet_maybe> ::=
<Gen1374> ::= <Trim_Specification_maybe> <Trim_Octet_maybe> <FROM>
<Gen1374_maybe> ::= <Gen1374>
<Gen1374_maybe> ::=
<Blob_Trim_Operands> ::= <Gen1374_maybe> <Blob_Trim_Source>
<Blob_Trim_Source> ::= <Blob_Value_Expression>
<Trim_Octet> ::= <Blob_Value_Expression>
<Gen1380> ::= <FOR> <String_Length>
<Gen1380_maybe> ::= <Gen1380>
<Gen1380_maybe> ::=
<Blob_Overlay_Function> ::= <OVERLAY> <Left_Paren> <Blob_Value_Expression> <PLACING> <Blob_Value_Expression> <FROM> <Start_Position> <Gen1380_maybe> <Right_Paren>
<Start_Position> ::= <Numeric_Value_Expression>
<String_Length> ::= <Numeric_Value_Expression>
<Datetime_Value_Expression> ::= <Datetime_Term>
                              | <Interval_Value_Expression> <Plus_Sign> <Datetime_Term>
                              | <Datetime_Value_Expression> <Plus_Sign> <Interval_Term>
                              | <Datetime_Value_Expression> <Minus_Sign> <Interval_Term>
<Datetime_Term> ::= <Datetime_Factor>
<Time_Zone_maybe> ::= <Time_Zone>
<Time_Zone_maybe> ::=
<Datetime_Factor> ::= <Datetime_Primary> <Time_Zone_maybe>
<Datetime_Primary> ::= <Value_Expression_Primary>
                     | <Datetime_Value_Function>
<Time_Zone> ::= <AT> <Time_Zone_Specifier>
<Time_Zone_Specifier> ::= <LOCAL>
                        | <TIME> <ZONE> <Interval_Primary>
<Datetime_Value_Function> ::= <Current_Date_Value_Function>
                            | <Current_Time_Value_Function>
                            | <Current_Timestamp_Value_Function>
                            | <Current_Local_Time_Value_Function>
                            | <Current_Local_Timestamp_Value_Function>
<Current_Date_Value_Function> ::= <Lex341>
<Gen1405> ::= <Left_Paren> <Time_Precision> <Right_Paren>
<Gen1405_maybe> ::= <Gen1405>
<Gen1405_maybe> ::=
<Current_Time_Value_Function> ::= <Lex345> <Gen1405_maybe>
<Gen1409> ::= <Left_Paren> <Time_Precision> <Right_Paren>
<Gen1409_maybe> ::= <Gen1409>
<Gen1409_maybe> ::=
<Current_Local_Time_Value_Function> ::= <LOCALTIME> <Gen1409_maybe>
<Gen1413> ::= <Left_Paren> <Timestamp_Precision> <Right_Paren>
<Gen1413_maybe> ::= <Gen1413>
<Gen1413_maybe> ::=
<Current_Timestamp_Value_Function> ::= <Lex346> <Gen1413_maybe>
<Gen1417> ::= <Left_Paren> <Timestamp_Precision> <Right_Paren>
<Gen1417_maybe> ::= <Gen1417>
<Gen1417_maybe> ::=
<Current_Local_Timestamp_Value_Function> ::= <LOCALTIMESTAMP> <Gen1417_maybe>
<Interval_Value_Expression> ::= <Interval_Term>
                              | <Interval_Value_Expression_1> <Plus_Sign> <Interval_Term_1>
                              | <Interval_Value_Expression_1> <Minus_Sign> <Interval_Term_1>
                              | <Left_Paren> <Datetime_Value_Expression> <Minus_Sign> <Datetime_Term> <Right_Paren> <Interval_Qualifier>
<Interval_Term> ::= <Interval_Factor>
                  | <Interval_Term_2> <Asterisk> <Factor>
                  | <Interval_Term_2> <Solidus> <Factor>
                  | <Term> <Asterisk> <Interval_Factor>
<Interval_Factor> ::= <Sign_maybe> <Interval_Primary>
<Interval_Qualifier_maybe> ::= <Interval_Qualifier>
<Interval_Qualifier_maybe> ::=
<Interval_Primary> ::= <Value_Expression_Primary> <Interval_Qualifier_maybe>
                     | <Interval_Value_Function>
<Interval_Value_Expression_1> ::= <Interval_Value_Expression>
<Interval_Term_1> ::= <Interval_Term>
<Interval_Term_2> ::= <Interval_Term>
<Interval_Value_Function> ::= <Interval_Absolute_Value_Function>
<Interval_Absolute_Value_Function> ::= <ABS> <Left_Paren> <Interval_Value_Expression> <Right_Paren>
<Boolean_Value_Expression> ::= <Boolean_Term>
                             | <Boolean_Value_Expression> <OR> <Boolean_Term>
<Boolean_Term> ::= <Boolean_Factor>
                 | <Boolean_Term> <AND> <Boolean_Factor>
<NOT_maybe> ::= <NOT>
<NOT_maybe> ::=
<Boolean_Factor> ::= <NOT_maybe> <Boolean_Test>
<Gen1446> ::= <IS> <NOT_maybe> <Truth_Value>
<Gen1446_maybe> ::= <Gen1446>
<Gen1446_maybe> ::=
<Boolean_Test> ::= <Boolean_Primary> <Gen1446_maybe>
<Truth_Value> ::= <TRUE>
                | <FALSE>
                | <UNKNOWN>
<Boolean_Primary> ::= <Predicate>
                    | <Boolean_Predicand>
<Boolean_Predicand> ::= <Parenthesized_Boolean_Value_Expression>
                      | <Nonparenthesized_Value_Expression_Primary>
<Parenthesized_Boolean_Value_Expression> ::= <Left_Paren> <Boolean_Value_Expression> <Right_Paren>
<Array_Value_Expression> ::= <Array_Concatenation>
                           | <Array_Factor>
<Array_Concatenation> ::= <Array_Value_Expression_1> <Concatenation_Operator> <Array_Factor>
<Array_Value_Expression_1> ::= <Array_Value_Expression>
<Array_Factor> ::= <Value_Expression_Primary>
<Array_Value_Constructor> ::= <Array_Value_Constructor_By_Enumeration>
                            | <Array_Value_Constructor_By_Query>
<Array_Value_Constructor_By_Enumeration> ::= <ARRAY> <Left_Bracket_Or_Trigraph> <Array_Element_List> <Right_Bracket_Or_Trigraph>
<Gen1466> ::= <Comma> <Array_Element>
<Gen1466_any> ::= <Gen1466>*
<Array_Element_List> ::= <Array_Element> <Gen1466_any>
<Array_Element> ::= <Value_Expression>
<Order_By_Clause_maybe> ::= <Order_By_Clause>
<Order_By_Clause_maybe> ::=
<Array_Value_Constructor_By_Query> ::= <ARRAY> <Left_Paren> <Query_Expression> <Order_By_Clause_maybe> <Right_Paren>
<Gen1473> ::= <ALL>
            | <DISTINCT>
<Gen1475> ::= <ALL>
            | <DISTINCT>
<Multiset_Value_Expression> ::= <Multiset_Term>
                              | <Multiset_Value_Expression> <MULTISET> <UNION> <Gen1473> <Multiset_Term>
                              | <Multiset_Value_Expression> <MULTISET> <EXCEPT> <Gen1475> <Multiset_Term>
<Gen1480> ::= <ALL>
            | <DISTINCT>
<Multiset_Term> ::= <Multiset_Primary>
                  | <Multiset_Term> <MULTISET> <INTERSECT> <Gen1480> <Multiset_Primary>
<Multiset_Primary> ::= <Multiset_Value_Function>
                     | <Value_Expression_Primary>
<Multiset_Value_Function> ::= <Multiset_Set_Function>
<Multiset_Set_Function> ::= <SET> <Left_Paren> <Multiset_Value_Expression> <Right_Paren>
<Multiset_Value_Constructor> ::= <Multiset_Value_Constructor_By_Enumeration>
                               | <Multiset_Value_Constructor_By_Query>
                               | <Table_Value_Constructor_By_Query>
<Multiset_Value_Constructor_By_Enumeration> ::= <MULTISET> <Left_Bracket_Or_Trigraph> <Multiset_Element_List> <Right_Bracket_Or_Trigraph>
<Gen1492> ::= <Comma> <Multiset_Element>
<Gen1492_any> ::= <Gen1492>*
<Multiset_Element_List> ::= <Multiset_Element> <Gen1492_any>
<Multiset_Element> ::= <Value_Expression>
<Multiset_Value_Constructor_By_Query> ::= <MULTISET> <Left_Paren> <Query_Expression> <Right_Paren>
<Table_Value_Constructor_By_Query> ::= <TABLE> <Left_Paren> <Query_Expression> <Right_Paren>
<Row_Value_Constructor> ::= <Common_Value_Expression>
                          | <Boolean_Value_Expression>
                          | <Explicit_Row_Value_Constructor>
<Explicit_Row_Value_Constructor> ::= <Left_Paren> <Row_Value_Constructor_Element> <Comma> <Row_Value_Constructor_Element_List> <Right_Paren>
                                   | <ROW> <Left_Paren> <Row_Value_Constructor_Element_List> <Right_Paren>
                                   | <Row_Subquery>
<Gen1504> ::= <Comma> <Row_Value_Constructor_Element>
<Gen1504_any> ::= <Gen1504>*
<Row_Value_Constructor_Element_List> ::= <Row_Value_Constructor_Element> <Gen1504_any>
<Row_Value_Constructor_Element> ::= <Value_Expression>
<Contextually_Typed_Row_Value_Constructor> ::= <Common_Value_Expression>
                                             | <Boolean_Value_Expression>
                                             | <Contextually_Typed_Value_Specification>
                                             | <Left_Paren> <Contextually_Typed_Row_Value_Constructor_Element> <Comma> <Contextually_Typed_Row_Value_Constructor_Element_List> <Right_Paren>
                                             | <ROW> <Left_Paren> <Contextually_Typed_Row_Value_Constructor_Element_List> <Right_Paren>
<Gen1513> ::= <Comma> <Contextually_Typed_Row_Value_Constructor_Element>
<Gen1513_any> ::= <Gen1513>*
<Contextually_Typed_Row_Value_Constructor_Element_List> ::= <Contextually_Typed_Row_Value_Constructor_Element> <Gen1513_any>
<Contextually_Typed_Row_Value_Constructor_Element> ::= <Value_Expression>
                                                     | <Contextually_Typed_Value_Specification>
<Row_Value_Constructor_Predicand> ::= <Common_Value_Expression>
                                    | <Boolean_Predicand>
                                    | <Explicit_Row_Value_Constructor>
<Row_Value_Expression> ::= <Row_Value_Special_Case>
                         | <Explicit_Row_Value_Constructor>
<Table_Row_Value_Expression> ::= <Row_Value_Special_Case>
                               | <Row_Value_Constructor>
<Contextually_Typed_Row_Value_Expression> ::= <Row_Value_Special_Case>
                                            | <Contextually_Typed_Row_Value_Constructor>
<Row_Value_Predicand> ::= <Row_Value_Special_Case>
                        | <Row_Value_Constructor_Predicand>
<Row_Value_Special_Case> ::= <Nonparenthesized_Value_Expression_Primary>
<Table_Value_Constructor> ::= <VALUES> <Row_Value_Expression_List>
<Gen1531> ::= <Comma> <Table_Row_Value_Expression>
<Gen1531_any> ::= <Gen1531>*
<Row_Value_Expression_List> ::= <Table_Row_Value_Expression> <Gen1531_any>
<Contextually_Typed_Table_Value_Constructor> ::= <VALUES> <Contextually_Typed_Row_Value_Expression_List>
<Gen1535> ::= <Comma> <Contextually_Typed_Row_Value_Expression>
<Gen1535_any> ::= <Gen1535>*
<Contextually_Typed_Row_Value_Expression_List> ::= <Contextually_Typed_Row_Value_Expression> <Gen1535_any>
<Where_Clause_maybe> ::= <Where_Clause>
<Where_Clause_maybe> ::=
<Group_By_Clause_maybe> ::= <Group_By_Clause>
<Group_By_Clause_maybe> ::=
<Having_Clause_maybe> ::= <Having_Clause>
<Having_Clause_maybe> ::=
<Window_Clause_maybe> ::= <Window_Clause>
<Window_Clause_maybe> ::=
<Table_Expression> ::= <From_Clause> <Where_Clause_maybe> <Group_By_Clause_maybe> <Having_Clause_maybe> <Window_Clause_maybe>
<From_Clause> ::= <FROM> <Table_Reference_List>
<Gen1548> ::= <Comma> <Table_Reference>
<Gen1548_any> ::= <Gen1548>*
<Table_Reference_List> ::= <Table_Reference> <Gen1548_any>
<Sample_Clause_maybe> ::= <Sample_Clause>
<Sample_Clause_maybe> ::=
<Table_Reference> ::= <Table_Primary_Or_Joined_Table> <Sample_Clause_maybe>
<Table_Primary_Or_Joined_Table> ::= <Table_Primary>
                                  | <Joined_Table>
<Repeatable_Clause_maybe> ::= <Repeatable_Clause>
<Repeatable_Clause_maybe> ::=
<Sample_Clause> ::= <TABLESAMPLE> <Sample_Method> <Left_Paren> <Sample_Percentage> <Right_Paren> <Repeatable_Clause_maybe>
<Sample_Method> ::= <BERNOULLI>
                  | <SYSTEM>
<Repeatable_Clause> ::= <REPEATABLE> <Left_Paren> <Repeat_Argument> <Right_Paren>
<Sample_Percentage> ::= <Numeric_Value_Expression>
<Repeat_Argument> ::= <Numeric_Value_Expression>
<AS_maybe> ::= <AS>
<AS_maybe> ::=
<Gen1566> ::= <Left_Paren> <Derived_Column_List> <Right_Paren>
<Gen1566_maybe> ::= <Gen1566>
<Gen1566_maybe> ::=
<Gen1569> ::= <AS_maybe> <Correlation_Name> <Gen1566_maybe>
<Gen1569_maybe> ::= <Gen1569>
<Gen1569_maybe> ::=
<Gen1572> ::= <Left_Paren> <Derived_Column_List> <Right_Paren>
<Gen1572_maybe> ::= <Gen1572>
<Gen1572_maybe> ::=
<Gen1575> ::= <Left_Paren> <Derived_Column_List> <Right_Paren>
<Gen1575_maybe> ::= <Gen1575>
<Gen1575_maybe> ::=
<Gen1578> ::= <Left_Paren> <Derived_Column_List> <Right_Paren>
<Gen1578_maybe> ::= <Gen1578>
<Gen1578_maybe> ::=
<Gen1581> ::= <Left_Paren> <Derived_Column_List> <Right_Paren>
<Gen1581_maybe> ::= <Gen1581>
<Gen1581_maybe> ::=
<Gen1584> ::= <Left_Paren> <Derived_Column_List> <Right_Paren>
<Gen1584_maybe> ::= <Gen1584>
<Gen1584_maybe> ::=
<Gen1587> ::= <AS_maybe> <Correlation_Name> <Gen1584_maybe>
<Gen1587_maybe> ::= <Gen1587>
<Gen1587_maybe> ::=
<Table_Primary> ::= <Table_Or_Query_Name> <Gen1569_maybe>
                  | <Derived_Table> <AS_maybe> <Correlation_Name> <Gen1572_maybe>
                  | <Lateral_Derived_Table> <AS_maybe> <Correlation_Name> <Gen1575_maybe>
                  | <Collection_Derived_Table> <AS_maybe> <Correlation_Name> <Gen1578_maybe>
                  | <Table_Function_Derived_Table> <AS_maybe> <Correlation_Name> <Gen1581_maybe>
                  | <Only_Spec> <Gen1587_maybe>
                  | <Left_Paren> <Joined_Table> <Right_Paren>
<Only_Spec> ::= <ONLY> <Left_Paren> <Table_Or_Query_Name> <Right_Paren>
<Lateral_Derived_Table> ::= <LATERAL> <Table_Subquery>
<Gen1599> ::= <WITH> <ORDINALITY>
<Gen1599_maybe> ::= <Gen1599>
<Gen1599_maybe> ::=
<Collection_Derived_Table> ::= <UNNEST> <Left_Paren> <Collection_Value_Expression> <Right_Paren> <Gen1599_maybe>
<Table_Function_Derived_Table> ::= <TABLE> <Left_Paren> <Collection_Value_Expression> <Right_Paren>
<Derived_Table> ::= <Table_Subquery>
<Table_Or_Query_Name> ::= <Table_Name>
                        | <Query_Name>
<Derived_Column_List> ::= <Column_Name_List>
<Gen1608> ::= <Comma> <Column_Name>
<Gen1608_any> ::= <Gen1608>*
<Column_Name_List> ::= <Column_Name> <Gen1608_any>
<Joined_Table> ::= <Cross_Join>
                 | <Qualified_Join>
                 | <Natural_Join>
                 | <Union_Join>
<Cross_Join> ::= <Table_Reference> <CROSS> <JOIN> <Table_Primary>
<Join_Type_maybe> ::= <Join_Type>
<Join_Type_maybe> ::=
<Qualified_Join> ::= <Table_Reference> <Join_Type_maybe> <JOIN> <Table_Reference> <Join_Specification>
<Natural_Join> ::= <Table_Reference> <NATURAL> <Join_Type_maybe> <JOIN> <Table_Primary>
<Union_Join> ::= <Table_Reference> <UNION> <JOIN> <Table_Primary>
<Join_Specification> ::= <Join_Condition>
                       | <Named_Columns_Join>
<Join_Condition> ::= <ON> <Search_Condition>
<Named_Columns_Join> ::= <USING> <Left_Paren> <Join_Column_List> <Right_Paren>
<OUTER_maybe> ::= <OUTER>
<OUTER_maybe> ::=
<Join_Type> ::= <INNER>
              | <Outer_Join_Type> <OUTER_maybe>
<Outer_Join_Type> ::= <LEFT>
                    | <RIGHT>
                    | <FULL>
<Join_Column_List> ::= <Column_Name_List>
<Where_Clause> ::= <WHERE> <Search_Condition>
<Set_Quantifier_maybe> ::= <Set_Quantifier>
<Set_Quantifier_maybe> ::=
<Group_By_Clause> ::= <GROUP> <BY> <Set_Quantifier_maybe> <Grouping_Element_List>
<Gen1637> ::= <Comma> <Grouping_Element>
<Gen1637_any> ::= <Gen1637>*
<Grouping_Element_List> ::= <Grouping_Element> <Gen1637_any>
<Grouping_Element> ::= <Ordinary_Grouping_Set>
                     | <Rollup_List>
                     | <Cube_List>
                     | <Grouping_Sets_Specification>
                     | <Empty_Grouping_Set>
<Ordinary_Grouping_Set> ::= <Grouping_Column_Reference>
                          | <Left_Paren> <Grouping_Column_Reference_List> <Right_Paren>
<Grouping_Column_Reference> ::= <Column_Reference> <Collate_Clause_maybe>
<Gen1648> ::= <Comma> <Grouping_Column_Reference>
<Gen1648_any> ::= <Gen1648>*
<Grouping_Column_Reference_List> ::= <Grouping_Column_Reference> <Gen1648_any>
<Rollup_List> ::= <ROLLUP> <Left_Paren> <Ordinary_Grouping_Set_List> <Right_Paren>
<Gen1652> ::= <Comma> <Ordinary_Grouping_Set>
<Gen1652_any> ::= <Gen1652>*
<Ordinary_Grouping_Set_List> ::= <Ordinary_Grouping_Set> <Gen1652_any>
<Cube_List> ::= <CUBE> <Left_Paren> <Ordinary_Grouping_Set_List> <Right_Paren>
<Grouping_Sets_Specification> ::= <GROUPING> <SETS> <Left_Paren> <Grouping_Set_List> <Right_Paren>
<Gen1657> ::= <Comma> <Grouping_Set>
<Gen1657_any> ::= <Gen1657>*
<Grouping_Set_List> ::= <Grouping_Set> <Gen1657_any>
<Grouping_Set> ::= <Ordinary_Grouping_Set>
                 | <Rollup_List>
                 | <Cube_List>
                 | <Grouping_Sets_Specification>
                 | <Empty_Grouping_Set>
<Empty_Grouping_Set> ::= <Left_Paren> <Right_Paren>
<Having_Clause> ::= <HAVING> <Search_Condition>
<Window_Clause> ::= <WINDOW> <Window_Definition_List>
<Gen1668> ::= <Comma> <Window_Definition>
<Gen1668_any> ::= <Gen1668>*
<Window_Definition_List> ::= <Window_Definition> <Gen1668_any>
<Window_Definition> ::= <New_Window_Name> <AS> <Window_Specification>
<New_Window_Name> ::= <Window_Name>
<Window_Specification> ::= <Left_Paren> <Window_Specification_Details> <Right_Paren>
<Existing_Window_Name_maybe> ::= <Existing_Window_Name>
<Existing_Window_Name_maybe> ::=
<Window_Partition_Clause_maybe> ::= <Window_Partition_Clause>
<Window_Partition_Clause_maybe> ::=
<Window_Order_Clause_maybe> ::= <Window_Order_Clause>
<Window_Order_Clause_maybe> ::=
<Window_Frame_Clause_maybe> ::= <Window_Frame_Clause>
<Window_Frame_Clause_maybe> ::=
<Window_Specification_Details> ::= <Existing_Window_Name_maybe> <Window_Partition_Clause_maybe> <Window_Order_Clause_maybe> <Window_Frame_Clause_maybe>
<Existing_Window_Name> ::= <Window_Name>
<Window_Partition_Clause> ::= <PARTITION> <BY> <Window_Partition_Column_Reference_List>
<Gen1685> ::= <Comma> <Window_Partition_Column_Reference>
<Gen1685_any> ::= <Gen1685>*
<Window_Partition_Column_Reference_List> ::= <Window_Partition_Column_Reference> <Gen1685_any>
<Window_Partition_Column_Reference> ::= <Column_Reference> <Collate_Clause_maybe>
<Window_Order_Clause> ::= <ORDER> <BY> <Sort_Specification_List>
<Window_Frame_Exclusion_maybe> ::= <Window_Frame_Exclusion>
<Window_Frame_Exclusion_maybe> ::=
<Window_Frame_Clause> ::= <Window_Frame_Units> <Window_Frame_Extent> <Window_Frame_Exclusion_maybe>
<Window_Frame_Units> ::= <ROWS>
                       | <RANGE>
<Window_Frame_Extent> ::= <Window_Frame_Start>
                        | <Window_Frame_Between>
<Window_Frame_Start> ::= <UNBOUNDED> <PRECEDING>
                       | <Window_Frame_Preceding>
                       | <CURRENT> <ROW>
<Window_Frame_Preceding> ::= <Unsigned_Value_Specification> <PRECEDING>
<Window_Frame_Between> ::= <BETWEEN> <Window_Frame_Bound_1> <AND> <Window_Frame_Bound_2>
<Window_Frame_Bound_1> ::= <Window_Frame_Bound>
<Window_Frame_Bound_2> ::= <Window_Frame_Bound>
<Window_Frame_Bound> ::= <Window_Frame_Start>
                       | <UNBOUNDED> <FOLLOWING>
                       | <Window_Frame_Following>
<Window_Frame_Following> ::= <Unsigned_Value_Specification> <FOLLOWING>
<Window_Frame_Exclusion> ::= <EXCLUDE> <CURRENT> <ROW>
                           | <EXCLUDE> <GROUP>
                           | <EXCLUDE> <TIES>
                           | <EXCLUDE> <NO> <OTHERS>
<Query_Specification> ::= <SELECT> <Set_Quantifier_maybe> <Select_List> <Table_Expression>
<Gen1713> ::= <Comma> <Select_Sublist>
<Gen1713_any> ::= <Gen1713>*
<Select_List> ::= <Asterisk>
                | <Select_Sublist> <Gen1713_any>
<Select_Sublist> ::= <Derived_Column>
                   | <Qualified_Asterisk>
<Qualified_Asterisk> ::= <Asterisked_Identifier_Chain> <Period> <Asterisk>
                       | <All_Fields_Reference>
<Gen1721> ::= <Period> <Asterisked_Identifier>
<Gen1721_any> ::= <Gen1721>*
<Asterisked_Identifier_Chain> ::= <Asterisked_Identifier> <Gen1721_any>
<Asterisked_Identifier> ::= <Identifier>
<As_Clause_maybe> ::= <As_Clause>
<As_Clause_maybe> ::=
<Derived_Column> ::= <Value_Expression> <As_Clause_maybe>
<As_Clause> ::= <AS_maybe> <Column_Name>
<Gen1729> ::= <AS> <Left_Paren> <All_Fields_Column_Name_List> <Right_Paren>
<Gen1729_maybe> ::= <Gen1729>
<Gen1729_maybe> ::=
<All_Fields_Reference> ::= <Value_Expression_Primary> <Period> <Asterisk> <Gen1729_maybe>
<All_Fields_Column_Name_List> ::= <Column_Name_List>
<With_Clause_maybe> ::= <With_Clause>
<With_Clause_maybe> ::=
<Query_Expression> ::= <With_Clause_maybe> <Query_Expression_Body>
<RECURSIVE_maybe> ::= <RECURSIVE>
<RECURSIVE_maybe> ::=
<With_Clause> ::= <WITH> <RECURSIVE_maybe> <With_List>
<Gen1740> ::= <Comma> <With_List_Element>
<Gen1740_any> ::= <Gen1740>*
<With_List> ::= <With_List_Element> <Gen1740_any>
<Gen1743> ::= <Left_Paren> <With_Column_List> <Right_Paren>
<Gen1743_maybe> ::= <Gen1743>
<Gen1743_maybe> ::=
<Search_Or_Cycle_Clause_maybe> ::= <Search_Or_Cycle_Clause>
<Search_Or_Cycle_Clause_maybe> ::=
<With_List_Element> ::= <Query_Name> <Gen1743_maybe> <AS> <Left_Paren> <Query_Expression> <Right_Paren> <Search_Or_Cycle_Clause_maybe>
<With_Column_List> ::= <Column_Name_List>
<Query_Expression_Body> ::= <Non_Join_Query_Expression>
                          | <Joined_Table>
<Gen1752> ::= <ALL>
            | <DISTINCT>
<Gen1752_maybe> ::= <Gen1752>
<Gen1752_maybe> ::=
<Corresponding_Spec_maybe> ::= <Corresponding_Spec>
<Corresponding_Spec_maybe> ::=
<Gen1758> ::= <ALL>
            | <DISTINCT>
<Gen1758_maybe> ::= <Gen1758>
<Gen1758_maybe> ::=
<Non_Join_Query_Expression> ::= <Non_Join_Query_Term>
                              | <Query_Expression_Body> <UNION> <Gen1752_maybe> <Corresponding_Spec_maybe> <Query_Term>
                              | <Query_Expression_Body> <EXCEPT> <Gen1758_maybe> <Corresponding_Spec_maybe> <Query_Term>
<Query_Term> ::= <Non_Join_Query_Term>
               | <Joined_Table>
<Gen1767> ::= <ALL>
            | <DISTINCT>
<Gen1767_maybe> ::= <Gen1767>
<Gen1767_maybe> ::=
<Non_Join_Query_Term> ::= <Non_Join_Query_Primary>
                        | <Query_Term> <INTERSECT> <Gen1767_maybe> <Corresponding_Spec_maybe> <Query_Primary>
<Query_Primary> ::= <Non_Join_Query_Primary>
                  | <Joined_Table>
<Non_Join_Query_Primary> ::= <Simple_Table>
                           | <Left_Paren> <Non_Join_Query_Expression> <Right_Paren>
<Simple_Table> ::= <Query_Specification>
                 | <Table_Value_Constructor>
                 | <Explicit_Table>
<Explicit_Table> ::= <TABLE> <Table_Or_Query_Name>
<Gen1781> ::= <BY> <Left_Paren> <Corresponding_Column_List> <Right_Paren>
<Gen1781_maybe> ::= <Gen1781>
<Gen1781_maybe> ::=
<Corresponding_Spec> ::= <CORRESPONDING> <Gen1781_maybe>
<Corresponding_Column_List> ::= <Column_Name_List>
<Search_Or_Cycle_Clause> ::= <Search_Clause>
                           | <Cycle_Clause>
                           | <Search_Clause> <Cycle_Clause>
<Search_Clause> ::= <SEARCH> <Recursive_Search_Order> <SET> <Sequence_Column>
<Recursive_Search_Order> ::= <DEPTH> <FIRST> <BY> <Sort_Specification_List>
                           | <BREADTH> <FIRST> <BY> <Sort_Specification_List>
<Sequence_Column> ::= <Column_Name>
<Cycle_Clause> ::= <CYCLE> <Cycle_Column_List> <SET> <Cycle_Mark_Column> <TO> <Cycle_Mark_Value> <DEFAULT> <Non_Cycle_Mark_Value> <USING> <Path_Column>
<Gen1794> ::= <Comma> <Cycle_Column>
<Gen1794_any> ::= <Gen1794>*
<Cycle_Column_List> ::= <Cycle_Column> <Gen1794_any>
<Cycle_Column> ::= <Column_Name>
<Cycle_Mark_Column> ::= <Column_Name>
<Path_Column> ::= <Column_Name>
<Cycle_Mark_Value> ::= <Value_Expression>
<Non_Cycle_Mark_Value> ::= <Value_Expression>
<Scalar_Subquery> ::= <Subquery>
<Row_Subquery> ::= <Subquery>
<Table_Subquery> ::= <Subquery>
<Subquery> ::= <Left_Paren> <Query_Expression> <Right_Paren>
<Predicate> ::= <Comparison_Predicate>
              | <Between_Predicate>
              | <In_Predicate>
              | <Like_Predicate>
              | <Similar_Predicate>
              | <Null_Predicate>
              | <Quantified_Comparison_Predicate>
              | <Exists_Predicate>
              | <Unique_Predicate>
              | <Normalized_Predicate>
              | <Match_Predicate>
              | <Overlaps_Predicate>
              | <Distinct_Predicate>
              | <Member_Predicate>
              | <Submultiset_Predicate>
              | <Set_Predicate>
              | <Type_Predicate>
<Comparison_Predicate> ::= <Row_Value_Predicand> <Comparison_Predicate_Part_2>
<Comparison_Predicate_Part_2> ::= <Comp_Op> <Row_Value_Predicand>
<Comp_Op> ::= <Equals_Operator>
            | <Not_Equals_Operator>
            | <Less_Than_Operator>
            | <Greater_Than_Operator>
            | <Less_Than_Or_Equals_Operator>
            | <Greater_Than_Or_Equals_Operator>
<Between_Predicate> ::= <Row_Value_Predicand> <Between_Predicate_Part_2>
<Gen1832> ::= <ASYMMETRIC>
            | <SYMMETRIC>
<Gen1832_maybe> ::= <Gen1832>
<Gen1832_maybe> ::=
<Between_Predicate_Part_2> ::= <NOT_maybe> <BETWEEN> <Gen1832_maybe> <Row_Value_Predicand> <AND> <Row_Value_Predicand>
<In_Predicate> ::= <Row_Value_Predicand> <In_Predicate_Part_2>
<In_Predicate_Part_2> ::= <NOT_maybe> <IN> <In_Predicate_Value>
<In_Predicate_Value> ::= <Table_Subquery>
                       | <Left_Paren> <In_Value_List> <Right_Paren>
<Gen1841> ::= <Comma> <Row_Value_Expression>
<Gen1841_any> ::= <Gen1841>*
<In_Value_List> ::= <Row_Value_Expression> <Gen1841_any>
<Like_Predicate> ::= <Character_Like_Predicate>
                   | <Octet_Like_Predicate>
<Character_Like_Predicate> ::= <Row_Value_Predicand> <Character_Like_Predicate_Part_2>
<Gen1847> ::= <ESCAPE> <Escape_Character>
<Gen1847_maybe> ::= <Gen1847>
<Gen1847_maybe> ::=
<Character_Like_Predicate_Part_2> ::= <NOT_maybe> <LIKE> <Character_Pattern> <Gen1847_maybe>
<Character_Pattern> ::= <Character_Value_Expression>
<Escape_Character> ::= <Character_Value_Expression>
<Octet_Like_Predicate> ::= <Row_Value_Predicand> <Octet_Like_Predicate_Part_2>
<Gen1854> ::= <ESCAPE> <Escape_Octet>
<Gen1854_maybe> ::= <Gen1854>
<Gen1854_maybe> ::=
<Octet_Like_Predicate_Part_2> ::= <NOT_maybe> <LIKE> <Octet_Pattern> <Gen1854_maybe>
<Octet_Pattern> ::= <Blob_Value_Expression>
<Escape_Octet> ::= <Blob_Value_Expression>
<Similar_Predicate> ::= <Row_Value_Predicand> <Similar_Predicate_Part_2>
<Gen1861> ::= <ESCAPE> <Escape_Character>
<Gen1861_maybe> ::= <Gen1861>
<Gen1861_maybe> ::=
<Similar_Predicate_Part_2> ::= <NOT_maybe> <SIMILAR> <TO> <Similar_Pattern> <Gen1861_maybe>
<Similar_Pattern> ::= <Character_Value_Expression>
<Regular_Expression> ::= <Regular_Term>
                       | <Regular_Expression> <Vertical_Bar> <Regular_Term>
<Regular_Term> ::= <Regular_Factor>
                 | <Regular_Term> <Regular_Factor>
<Regular_Factor> ::= <Regular_Primary>
                   | <Regular_Primary> <Asterisk>
                   | <Regular_Primary> <Plus_Sign>
                   | <Regular_Primary> <Question_Mark>
                   | <Regular_Primary> <Repeat_Factor>
<Upper_Limit_maybe> ::= <Upper_Limit>
<Upper_Limit_maybe> ::=
<Repeat_Factor> ::= <Left_Brace> <Low_Value> <Upper_Limit_maybe> <Right_Brace>
<High_Value_maybe> ::= <High_Value>
<High_Value_maybe> ::=
<Upper_Limit> ::= <Comma> <High_Value_maybe>
<Low_Value> ::= <Unsigned_Integer>
<High_Value> ::= <Unsigned_Integer>
<Regular_Primary> ::= <Character_Specifier>
                    | <Percent>
                    | <Regular_Character_Set>
                    | <Left_Paren> <Regular_Expression> <Right_Paren>
<Character_Specifier> ::= <Non_Escaped_Character>
                        | <Escaped_Character>
<Non_Escaped_Character> ::= <Lex561>
<Escaped_Character> ::= <Lex562> <Lex563>
<Character_Enumeration_many> ::= <Character_Enumeration>+
<Character_Enumeration_Include_many> ::= <Character_Enumeration_Include>+
<Character_Enumeration_Exclude_many> ::= <Character_Enumeration_Exclude>+
<Regular_Character_Set> ::= <Underscore>
                          | <Left_Bracket> <Character_Enumeration_many> <Right_Bracket>
                          | <Left_Bracket> <Circumflex> <Character_Enumeration_many> <Right_Bracket>
                          | <Left_Bracket> <Character_Enumeration_Include_many> <Circumflex> <Character_Enumeration_Exclude_many> <Right_Bracket>
<Character_Enumeration_Include> ::= <Character_Enumeration>
<Character_Enumeration_Exclude> ::= <Character_Enumeration>
<Character_Enumeration> ::= <Character_Specifier>
                          | <Character_Specifier> <Minus_Sign> <Character_Specifier>
                          | <Left_Bracket> <Colon> <Regular_Character_Set_Identifier> <Colon> <Right_Bracket>
<Regular_Character_Set_Identifier> ::= <Identifier>
<Null_Predicate> ::= <Row_Value_Predicand> <Null_Predicate_Part_2>
<Null_Predicate_Part_2> ::= <IS> <NOT_maybe> <NULL>
<Quantified_Comparison_Predicate> ::= <Row_Value_Predicand> <Quantified_Comparison_Predicate_Part_2>
<Quantified_Comparison_Predicate_Part_2> ::= <Comp_Op> <Quantifier> <Table_Subquery>
<Quantifier> ::= <All>
               | <Some>
<All> ::= <ALL>
<Some> ::= <SOME>
         | <ANY>
<Exists_Predicate> ::= <EXISTS> <Table_Subquery>
<Unique_Predicate> ::= <UNIQUE> <Table_Subquery>
<Normalized_Predicate> ::= <String_Value_Expression> <IS> <NOT_maybe> <NORMALIZED>
<Match_Predicate> ::= <Row_Value_Predicand> <Match_Predicate_Part_2>
<UNIQUE_maybe> ::= <UNIQUE>
<UNIQUE_maybe> ::=
<Gen1919> ::= <SIMPLE>
            | <PARTIAL>
            | <FULL>
<Gen1919_maybe> ::= <Gen1919>
<Gen1919_maybe> ::=
<Match_Predicate_Part_2> ::= <MATCH> <UNIQUE_maybe> <Gen1919_maybe> <Table_Subquery>
<Overlaps_Predicate> ::= <Overlaps_Predicate_Part_1> <Overlaps_Predicate_Part_2>
<Overlaps_Predicate_Part_1> ::= <Row_Value_Predicand_1>
<Overlaps_Predicate_Part_2> ::= <OVERLAPS> <Row_Value_Predicand_2>
<Row_Value_Predicand_1> ::= <Row_Value_Predicand>
<Row_Value_Predicand_2> ::= <Row_Value_Predicand>
<Distinct_Predicate> ::= <Row_Value_Predicand_3> <Distinct_Predicate_Part_2>
<Distinct_Predicate_Part_2> ::= <IS> <DISTINCT> <FROM> <Row_Value_Predicand_4>
<Row_Value_Predicand_3> ::= <Row_Value_Predicand>
<Row_Value_Predicand_4> ::= <Row_Value_Predicand>
<Member_Predicate> ::= <Row_Value_Predicand> <Member_Predicate_Part_2>
<OF_maybe> ::= <OF>
<OF_maybe> ::=
<Member_Predicate_Part_2> ::= <NOT_maybe> <MEMBER> <OF_maybe> <Multiset_Value_Expression>
<Submultiset_Predicate> ::= <Row_Value_Predicand> <Submultiset_Predicate_Part_2>
<Submultiset_Predicate_Part_2> ::= <NOT_maybe> <SUBMULTISET> <OF_maybe> <Multiset_Value_Expression>
<Set_Predicate> ::= <Row_Value_Predicand> <Set_Predicate_Part_2>
<Set_Predicate_Part_2> ::= <IS> <NOT_maybe> <A> <SET>
<Type_Predicate> ::= <Row_Value_Predicand> <Type_Predicate_Part_2>
<Type_Predicate_Part_2> ::= <IS> <NOT_maybe> <OF> <Left_Paren> <Type_List> <Right_Paren>
<Gen1944> ::= <Comma> <User_Defined_Type_Specification>
<Gen1944_any> ::= <Gen1944>*
<Type_List> ::= <User_Defined_Type_Specification> <Gen1944_any>
<User_Defined_Type_Specification> ::= <Inclusive_User_Defined_Type_Specification>
                                    | <Exclusive_User_Defined_Type_Specification>
<Inclusive_User_Defined_Type_Specification> ::= <Path_Resolved_User_Defined_Type_Name>
<Exclusive_User_Defined_Type_Specification> ::= <ONLY> <Path_Resolved_User_Defined_Type_Name>
<Search_Condition> ::= <Boolean_Value_Expression>
<Interval_Qualifier> ::= <Start_Field> <TO> <End_Field>
                       | <Single_Datetime_Field>
<Gen1954> ::= <Left_Paren> <Interval_Leading_Field_Precision> <Right_Paren>
<Gen1954_maybe> ::= <Gen1954>
<Gen1954_maybe> ::=
<Start_Field> ::= <Non_Second_Primary_Datetime_Field> <Gen1954_maybe>
<Gen1958> ::= <Left_Paren> <Interval_Fractional_Seconds_Precision> <Right_Paren>
<Gen1958_maybe> ::= <Gen1958>
<Gen1958_maybe> ::=
<End_Field> ::= <Non_Second_Primary_Datetime_Field>
              | <SECOND> <Gen1958_maybe>
<Gen1963> ::= <Left_Paren> <Interval_Leading_Field_Precision> <Right_Paren>
<Gen1963_maybe> ::= <Gen1963>
<Gen1963_maybe> ::=
<Gen1966> ::= <Comma> <Interval_Fractional_Seconds_Precision>
<Gen1966_maybe> ::= <Gen1966>
<Gen1966_maybe> ::=
<Gen1969> ::= <Left_Paren> <Interval_Leading_Field_Precision> <Gen1966_maybe> <Right_Paren>
<Gen1969_maybe> ::= <Gen1969>
<Gen1969_maybe> ::=
<Single_Datetime_Field> ::= <Non_Second_Primary_Datetime_Field> <Gen1963_maybe>
                          | <SECOND> <Gen1969_maybe>
<Primary_Datetime_Field> ::= <Non_Second_Primary_Datetime_Field>
                           | <SECOND>
<Non_Second_Primary_Datetime_Field> ::= <YEAR>
                                      | <MONTH>
                                      | <DAY>
                                      | <HOUR>
                                      | <MINUTE>
<Interval_Fractional_Seconds_Precision> ::= <Unsigned_Integer>
<Interval_Leading_Field_Precision> ::= <Unsigned_Integer>
<Language_Clause> ::= <LANGUAGE> <Language_Name>
<Language_Name> ::= <ADA>
                  | <C>
                  | <COBOL>
                  | <FORTRAN>
                  | <MUMPS>
                  | <PASCAL>
                  | <PLI>
                  | <SQL>
<Path_Specification> ::= <PATH> <Schema_Name_List>
<Gen1993> ::= <Comma> <Schema_Name>
<Gen1993_any> ::= <Gen1993>*
<Schema_Name_List> ::= <Schema_Name> <Gen1993_any>
<Routine_Invocation> ::= <Routine_Name> <SQL_Argument_List>
<Gen1997> ::= <Schema_Name> <Period>
<Gen1997_maybe> ::= <Gen1997>
<Gen1997_maybe> ::=
<Routine_Name> ::= <Gen1997_maybe> <Qualified_Identifier>
<Gen2001> ::= <Comma> <SQL_Argument>
<Gen2001_any> ::= <Gen2001>*
<Gen2003> ::= <SQL_Argument> <Gen2001_any>
<Gen2003_maybe> ::= <Gen2003>
<Gen2003_maybe> ::=
<SQL_Argument_List> ::= <Left_Paren> <Gen2003_maybe> <Right_Paren>
<SQL_Argument> ::= <Value_Expression>
                 | <Generalized_Expression>
                 | <Target_Specification>
<Generalized_Expression> ::= <Value_Expression> <AS> <Path_Resolved_User_Defined_Type_Name>
<Character_Set_Specification> ::= <Standard_Character_Set_Name>
                                | <Implementation_Defined_Character_Set_Name>
                                | <User_Defined_Character_Set_Name>
<Standard_Character_Set_Name> ::= <Character_Set_Name>
<Implementation_Defined_Character_Set_Name> ::= <Character_Set_Name>
<User_Defined_Character_Set_Name> ::= <Character_Set_Name>
<Gen2017> ::= <FOR> <Schema_Resolved_User_Defined_Type_Name>
<Gen2017_maybe> ::= <Gen2017>
<Gen2017_maybe> ::=
<Specific_Routine_Designator> ::= <SPECIFIC> <Routine_Type> <Specific_Name>
                                | <Routine_Type> <Member_Name> <Gen2017_maybe>
<Gen2022> ::= <INSTANCE>
            | <STATIC>
            | <CONSTRUCTOR>
<Gen2022_maybe> ::= <Gen2022>
<Gen2022_maybe> ::=
<Routine_Type> ::= <ROUTINE>
                 | <FUNCTION>
                 | <PROCEDURE>
                 | <Gen2022_maybe> <METHOD>
<Data_Type_List_maybe> ::= <Data_Type_List>
<Data_Type_List_maybe> ::=
<Member_Name> ::= <Member_Name_Alternatives> <Data_Type_List_maybe>
<Member_Name_Alternatives> ::= <Schema_Qualified_Routine_Name>
                             | <Method_Name>
<Gen2036> ::= <Comma> <Data_Type>
<Gen2036_any> ::= <Gen2036>*
<Gen2038> ::= <Data_Type> <Gen2036_any>
<Gen2038_maybe> ::= <Gen2038>
<Gen2038_maybe> ::=
<Data_Type_List> ::= <Left_Paren> <Gen2038_maybe> <Right_Paren>
<Collate_Clause> ::= <COLLATE> <Collation_Name>
<Constraint_Name_Definition> ::= <CONSTRAINT> <Constraint_Name>
<Gen2044> ::= <NOT_maybe> <DEFERRABLE>
<Gen2044_maybe> ::= <Gen2044>
<Gen2044_maybe> ::=
<Constraint_Check_Time_maybe> ::= <Constraint_Check_Time>
<Constraint_Check_Time_maybe> ::=
<Constraint_Characteristics> ::= <Constraint_Check_Time> <Gen2044_maybe>
                               | <NOT_maybe> <DEFERRABLE> <Constraint_Check_Time_maybe>
<Constraint_Check_Time> ::= <INITIALLY> <DEFERRED>
                          | <INITIALLY> <IMMEDIATE>
<Filter_Clause_maybe> ::= <Filter_Clause>
<Filter_Clause_maybe> ::=
<Aggregate_Function> ::= <COUNT> <Left_Paren> <Asterisk> <Right_Paren> <Filter_Clause_maybe>
                       | <General_Set_Function> <Filter_Clause_maybe>
                       | <Binary_Set_Function> <Filter_Clause_maybe>
                       | <Ordered_Set_Function> <Filter_Clause_maybe>
<General_Set_Function> ::= <Set_Function_Type> <Left_Paren> <Set_Quantifier_maybe> <Value_Expression> <Right_Paren>
<Set_Function_Type> ::= <Computational_Operation>
<Computational_Operation> ::= <AVG>
                            | <MAX>
                            | <MIN>
                            | <SUM>
                            | <EVERY>
                            | <ANY>
                            | <SOME>
                            | <COUNT>
                            | <Lex261>
                            | <Lex262>
                            | <Lex531>
                            | <Lex530>
                            | <COLLECT>
                            | <FUSION>
                            | <INTERSECTION>
<Set_Quantifier> ::= <DISTINCT>
                   | <ALL>
<Filter_Clause> ::= <FILTER> <Left_Paren> <WHERE> <Search_Condition> <Right_Paren>
<Binary_Set_Function> ::= <Binary_Set_Function_Type> <Left_Paren> <Dependent_Variable_Expression> <Comma> <Independent_Variable_Expression> <Right_Paren>
<Binary_Set_Function_Type> ::= <Lex108>
                             | <Lex109>
                             | <CORR>
                             | <Lex470>
                             | <Lex468>
                             | <Lex467>
                             | <Lex469>
                             | <Lex465>
                             | <Lex466>
                             | <Lex471>
                             | <Lex473>
                             | <Lex472>
<Dependent_Variable_Expression> ::= <Numeric_Value_Expression>
<Independent_Variable_Expression> ::= <Numeric_Value_Expression>
<Ordered_Set_Function> ::= <Hypothetical_Set_Function>
                         | <Inverse_Distribution_Function>
<Hypothetical_Set_Function> ::= <Rank_Function_Type> <Left_Paren> <Hypothetical_Set_Function_Value_Expression_List> <Right_Paren> <Within_Group_Specification>
<Within_Group_Specification> ::= <WITHIN> <GROUP> <Left_Paren> <ORDER> <BY> <Sort_Specification_List> <Right_Paren>
<Gen2098> ::= <Comma> <Value_Expression>
<Gen2098_any> ::= <Gen2098>*
<Hypothetical_Set_Function_Value_Expression_List> ::= <Value_Expression> <Gen2098_any>
<Inverse_Distribution_Function> ::= <Inverse_Distribution_Function_Type> <Left_Paren> <Inverse_Distribution_Function_Argument> <Right_Paren> <Within_Group_Specification>
<Inverse_Distribution_Function_Argument> ::= <Numeric_Value_Expression>
<Inverse_Distribution_Function_Type> ::= <Lex211>
                                       | <Lex212>
<Gen2105> ::= <Comma> <Sort_Specification>
<Gen2105_any> ::= <Gen2105>*
<Sort_Specification_List> ::= <Sort_Specification> <Gen2105_any>
<Ordering_Specification_maybe> ::= <Ordering_Specification>
<Ordering_Specification_maybe> ::=
<Null_Ordering_maybe> ::= <Null_Ordering>
<Null_Ordering_maybe> ::=
<Sort_Specification> ::= <Sort_Key> <Ordering_Specification_maybe> <Null_Ordering_maybe>
<Sort_Key> ::= <Value_Expression>
<Ordering_Specification> ::= <ASC>
                           | <DESC>
<Null_Ordering> ::= <NULLS> <FIRST>
                  | <NULLS> <LAST>
<Schema_Character_Set_Or_Path_maybe> ::= <Schema_Character_Set_Or_Path>
<Schema_Character_Set_Or_Path_maybe> ::=
<Schema_Element_any> ::= <Schema_Element>*
<Schema_Definition> ::= <CREATE> <SCHEMA> <Schema_Name_Clause> <Schema_Character_Set_Or_Path_maybe> <Schema_Element_any>
<Schema_Character_Set_Or_Path> ::= <Schema_Character_Set_Specification>
                                 | <Schema_Path_Specification>
                                 | <Schema_Character_Set_Specification> <Schema_Path_Specification>
                                 | <Schema_Path_Specification> <Schema_Character_Set_Specification>
<Schema_Name_Clause> ::= <Schema_Name>
                       | <AUTHORIZATION> <Schema_Authorization_Identifier>
                       | <Schema_Name> <AUTHORIZATION> <Schema_Authorization_Identifier>
<Schema_Authorization_Identifier> ::= <Authorization_Identifier>
<Schema_Character_Set_Specification> ::= <DEFAULT> <CHARACTER> <SET> <Character_Set_Specification>
<Schema_Path_Specification> ::= <Path_Specification>
<Schema_Element> ::= <Table_Definition>
                   | <View_Definition>
                   | <Domain_Definition>
                   | <Character_Set_Definition>
                   | <Collation_Definition>
                   | <Transliteration_Definition>
                   | <Assertion_Definition>
                   | <Trigger_Definition>
                   | <User_Defined_Type_Definition>
                   | <User_Defined_Cast_Definition>
                   | <User_Defined_Ordering_Definition>
                   | <Transform_Definition>
                   | <Schema_Routine>
                   | <Sequence_Generator_Definition>
                   | <Grant_Statement>
                   | <Role_Definition>
<Drop_Schema_Statement> ::= <DROP> <SCHEMA> <Schema_Name> <Drop_Behavior>
<Drop_Behavior> ::= <CASCADE>
                  | <RESTRICT>
<Table_Scope_maybe> ::= <Table_Scope>
<Table_Scope_maybe> ::=
<Gen2153> ::= <ON> <COMMIT> <Table_Commit_Action> <ROWS>
<Gen2153_maybe> ::= <Gen2153>
<Gen2153_maybe> ::=
<Table_Definition> ::= <CREATE> <Table_Scope_maybe> <TABLE> <Table_Name> <Table_Contents_Source> <Gen2153_maybe>
<Subtable_Clause_maybe> ::= <Subtable_Clause>
<Subtable_Clause_maybe> ::=
<Table_Element_List_maybe> ::= <Table_Element_List>
<Table_Element_List_maybe> ::=
<Table_Contents_Source> ::= <Table_Element_List>
                          | <OF> <Path_Resolved_User_Defined_Type_Name> <Subtable_Clause_maybe> <Table_Element_List_maybe>
                          | <As_Subquery_Clause>
<Table_Scope> ::= <Global_Or_Local> <TEMPORARY>
<Global_Or_Local> ::= <GLOBAL>
                    | <LOCAL>
<Table_Commit_Action> ::= <PRESERVE>
                        | <DELETE>
<Gen2169> ::= <Comma> <Table_Element>
<Gen2169_any> ::= <Gen2169>*
<Table_Element_List> ::= <Left_Paren> <Table_Element> <Gen2169_any> <Right_Paren>
<Table_Element> ::= <Column_Definition>
                  | <Table_Constraint_Definition>
                  | <Like_Clause>
                  | <Self_Referencing_Column_Specification>
                  | <Column_Options>
<Self_Referencing_Column_Specification> ::= <REF> <IS> <Self_Referencing_Column_Name> <Reference_Generation>
<Reference_Generation> ::= <SYSTEM> <GENERATED>
                         | <USER> <GENERATED>
                         | <DERIVED>
<Self_Referencing_Column_Name> ::= <Column_Name>
<Column_Options> ::= <Column_Name> <WITH> <OPTIONS> <Column_Option_List>
<Default_Clause_maybe> ::= <Default_Clause>
<Default_Clause_maybe> ::=
<Column_Constraint_Definition_any> ::= <Column_Constraint_Definition>*
<Column_Option_List> ::= <Scope_Clause_maybe> <Default_Clause_maybe> <Column_Constraint_Definition_any>
<Subtable_Clause> ::= <UNDER> <Supertable_Clause>
<Supertable_Clause> ::= <Supertable_Name>
<Supertable_Name> ::= <Table_Name>
<Like_Options_maybe> ::= <Like_Options>
<Like_Options_maybe> ::=
<Like_Clause> ::= <LIKE> <Table_Name> <Like_Options_maybe>
<Like_Options> ::= <Identity_Option>
                 | <Column_Default_Option>
<Identity_Option> ::= <INCLUDING> <IDENTITY>
                    | <EXCLUDING> <IDENTITY>
<Column_Default_Option> ::= <INCLUDING> <DEFAULTS>
                          | <EXCLUDING> <DEFAULTS>
<Gen2199> ::= <Left_Paren> <Column_Name_List> <Right_Paren>
<Gen2199_maybe> ::= <Gen2199>
<Gen2199_maybe> ::=
<As_Subquery_Clause> ::= <Gen2199_maybe> <AS> <Subquery> <With_Or_Without_Data>
<With_Or_Without_Data> ::= <WITH> <NO> <DATA>
                         | <WITH> <DATA>
<Gen2205> ::= <Data_Type>
            | <Domain_Name>
<Gen2205_maybe> ::= <Gen2205>
<Gen2205_maybe> ::=
<Gen2209> ::= <Default_Clause>
            | <Identity_Column_Specification>
            | <Generation_Clause>
<Gen2209_maybe> ::= <Gen2209>
<Gen2209_maybe> ::=
<Column_Definition> ::= <Column_Name> <Gen2205_maybe> <Reference_Scope_Check_maybe> <Gen2209_maybe> <Column_Constraint_Definition_any> <Collate_Clause_maybe>
<Constraint_Name_Definition_maybe> ::= <Constraint_Name_Definition>
<Constraint_Name_Definition_maybe> ::=
<Constraint_Characteristics_maybe> ::= <Constraint_Characteristics>
<Constraint_Characteristics_maybe> ::=
<Column_Constraint_Definition> ::= <Constraint_Name_Definition_maybe> <Column_Constraint> <Constraint_Characteristics_maybe>
<Column_Constraint> ::= <NOT> <NULL>
                      | <Unique_Specification>
                      | <References_Specification>
                      | <Check_Constraint_Definition>
<Gen2224> ::= <ON> <DELETE> <Reference_Scope_Check_Action>
<Gen2224_maybe> ::= <Gen2224>
<Gen2224_maybe> ::=
<Reference_Scope_Check> ::= <REFERENCES> <ARE> <NOT_maybe> <CHECKED> <Gen2224_maybe>
<Reference_Scope_Check_Action> ::= <Referential_Action>
<Gen2229> ::= <ALWAYS>
            | <BY> <DEFAULT>
<Gen2231> ::= <Left_Paren> <Common_Sequence_Generator_Options> <Right_Paren>
<Gen2231_maybe> ::= <Gen2231>
<Gen2231_maybe> ::=
<Identity_Column_Specification> ::= <GENERATED> <Gen2229> <AS> <IDENTITY> <Gen2231_maybe>
<Generation_Clause> ::= <Generation_Rule> <AS> <Generation_Expression>
<Generation_Rule> ::= <GENERATED> <ALWAYS>
<Generation_Expression> ::= <Left_Paren> <Value_Expression> <Right_Paren>
<Default_Clause> ::= <DEFAULT> <Default_Option>
<Default_Option> ::= <Literal>
                   | <Datetime_Value_Function>
                   | <USER>
                   | <Lex348>
                   | <Lex344>
                   | <Lex490>
                   | <Lex506>
                   | <Lex343>
                   | <Implicitly_Typed_Value_Specification>
<Table_Constraint_Definition> ::= <Constraint_Name_Definition_maybe> <Table_Constraint> <Constraint_Characteristics_maybe>
<Table_Constraint> ::= <Unique_Constraint_Definition>
                     | <Referential_Constraint_Definition>
                     | <Check_Constraint_Definition>
<Gen2252> ::= <VALUE>
<Unique_Constraint_Definition> ::= <Unique_Specification> <Left_Paren> <Unique_Column_List> <Right_Paren>
                                 | <UNIQUE> <Gen2252>
<Unique_Specification> ::= <UNIQUE>
                         | <PRIMARY> <KEY>
<Unique_Column_List> ::= <Column_Name_List>
<Referential_Constraint_Definition> ::= <FOREIGN> <KEY> <Left_Paren> <Referencing_Columns> <Right_Paren> <References_Specification>
<Gen2259> ::= <MATCH> <Match_Type>
<Gen2259_maybe> ::= <Gen2259>
<Gen2259_maybe> ::=
<Referential_Triggered_Action_maybe> ::= <Referential_Triggered_Action>
<Referential_Triggered_Action_maybe> ::=
<References_Specification> ::= <REFERENCES> <Referenced_Table_And_Columns> <Gen2259_maybe> <Referential_Triggered_Action_maybe>
<Match_Type> ::= <FULL>
               | <PARTIAL>
               | <SIMPLE>
<Referencing_Columns> ::= <Reference_Column_List>
<Gen2269> ::= <Left_Paren> <Reference_Column_List> <Right_Paren>
<Gen2269_maybe> ::= <Gen2269>
<Gen2269_maybe> ::=
<Referenced_Table_And_Columns> ::= <Table_Name> <Gen2269_maybe>
<Reference_Column_List> ::= <Column_Name_List>
<Delete_Rule_maybe> ::= <Delete_Rule>
<Delete_Rule_maybe> ::=
<Update_Rule_maybe> ::= <Update_Rule>
<Update_Rule_maybe> ::=
<Referential_Triggered_Action> ::= <Update_Rule> <Delete_Rule_maybe>
                                 | <Delete_Rule> <Update_Rule_maybe>
<Update_Rule> ::= <ON> <UPDATE> <Referential_Action>
<Delete_Rule> ::= <ON> <DELETE> <Referential_Action>
<Referential_Action> ::= <CASCADE>
                       | <SET> <NULL>
                       | <SET> <DEFAULT>
                       | <RESTRICT>
                       | <NO> <ACTION>
<Check_Constraint_Definition> ::= <CHECK> <Left_Paren> <Search_Condition> <Right_Paren>
<Alter_Table_Statement> ::= <ALTER> <TABLE> <Table_Name> <Alter_Table_Action>
<Alter_Table_Action> ::= <Add_Column_Definition>
                       | <Alter_Column_Definition>
                       | <Drop_Column_Definition>
                       | <Add_Table_Constraint_Definition>
                       | <Drop_Table_Constraint_Definition>
<COLUMN_maybe> ::= <COLUMN>
<COLUMN_maybe> ::=
<Add_Column_Definition> ::= <ADD> <COLUMN_maybe> <Column_Definition>
<Alter_Column_Definition> ::= <ALTER> <COLUMN_maybe> <Column_Name> <Alter_Column_Action>
<Alter_Column_Action> ::= <Set_Column_Default_Clause>
                        | <Drop_Column_Default_Clause>
                        | <Add_Column_Scope_Clause>
                        | <Drop_Column_Scope_Clause>
                        | <Alter_Identity_Column_Specification>
<Set_Column_Default_Clause> ::= <SET> <Default_Clause>
<Drop_Column_Default_Clause> ::= <DROP> <DEFAULT>
<Add_Column_Scope_Clause> ::= <ADD> <Scope_Clause>
<Drop_Column_Scope_Clause> ::= <DROP> <SCOPE> <Drop_Behavior>
<Alter_Identity_Column_Option_many> ::= <Alter_Identity_Column_Option>+
<Alter_Identity_Column_Specification> ::= <Alter_Identity_Column_Option_many>
<Alter_Identity_Column_Option> ::= <Alter_Sequence_Generator_Restart_Option>
                                 | <SET> <Basic_Sequence_Generator_Option>
<Drop_Column_Definition> ::= <DROP> <COLUMN_maybe> <Column_Name> <Drop_Behavior>
<Add_Table_Constraint_Definition> ::= <ADD> <Table_Constraint_Definition>
<Drop_Table_Constraint_Definition> ::= <DROP> <CONSTRAINT> <Constraint_Name> <Drop_Behavior>
<Drop_Table_Statement> ::= <DROP> <TABLE> <Table_Name> <Drop_Behavior>
<Levels_Clause_maybe> ::= <Levels_Clause>
<Levels_Clause_maybe> ::=
<Gen2317> ::= <WITH> <Levels_Clause_maybe> <CHECK> <OPTION>
<Gen2317_maybe> ::= <Gen2317>
<Gen2317_maybe> ::=
<View_Definition> ::= <CREATE> <RECURSIVE_maybe> <VIEW> <Table_Name> <View_Specification> <AS> <Query_Expression> <Gen2317_maybe>
<View_Specification> ::= <Regular_View_Specification>
                       | <Referenceable_View_Specification>
<Gen2323> ::= <Left_Paren> <View_Column_List> <Right_Paren>
<Gen2323_maybe> ::= <Gen2323>
<Gen2323_maybe> ::=
<Regular_View_Specification> ::= <Gen2323_maybe>
<Subview_Clause_maybe> ::= <Subview_Clause>
<Subview_Clause_maybe> ::=
<View_Element_List_maybe> ::= <View_Element_List>
<View_Element_List_maybe> ::=
<Referenceable_View_Specification> ::= <OF> <Path_Resolved_User_Defined_Type_Name> <Subview_Clause_maybe> <View_Element_List_maybe>
<Subview_Clause> ::= <UNDER> <Table_Name>
<Gen2333> ::= <Comma> <View_Element>
<Gen2333_any> ::= <Gen2333>*
<View_Element_List> ::= <Left_Paren> <View_Element> <Gen2333_any> <Right_Paren>
<View_Element> ::= <Self_Referencing_Column_Specification>
                 | <View_Column_Option>
<View_Column_Option> ::= <Column_Name> <WITH> <OPTIONS> <Scope_Clause>
<Levels_Clause> ::= <CASCADED>
                  | <LOCAL>
<View_Column_List> ::= <Column_Name_List>
<Drop_View_Statement> ::= <DROP> <VIEW> <Table_Name> <Drop_Behavior>
<Domain_Constraint_any> ::= <Domain_Constraint>*
<Domain_Definition> ::= <CREATE> <DOMAIN> <Domain_Name> <AS_maybe> <Data_Type> <Default_Clause_maybe> <Domain_Constraint_any> <Collate_Clause_maybe>
<Domain_Constraint> ::= <Constraint_Name_Definition_maybe> <Check_Constraint_Definition> <Constraint_Characteristics_maybe>
<Alter_Domain_Statement> ::= <ALTER> <DOMAIN> <Domain_Name> <Alter_Domain_Action>
<Alter_Domain_Action> ::= <Set_Domain_Default_Clause>
                        | <Drop_Domain_Default_Clause>
                        | <Add_Domain_Constraint_Definition>
                        | <Drop_Domain_Constraint_Definition>
<Set_Domain_Default_Clause> ::= <SET> <Default_Clause>
<Drop_Domain_Default_Clause> ::= <DROP> <DEFAULT>
<Add_Domain_Constraint_Definition> ::= <ADD> <Domain_Constraint>
<Drop_Domain_Constraint_Definition> ::= <DROP> <CONSTRAINT> <Constraint_Name>
<Drop_Domain_Statement> ::= <DROP> <DOMAIN> <Domain_Name> <Drop_Behavior>
<Character_Set_Definition> ::= <CREATE> <CHARACTER> <SET> <Character_Set_Name> <AS_maybe> <Character_Set_Source> <Collate_Clause_maybe>
<Character_Set_Source> ::= <GET> <Character_Set_Specification>
<Drop_Character_Set_Statement> ::= <DROP> <CHARACTER> <SET> <Character_Set_Name>
<Pad_Characteristic_maybe> ::= <Pad_Characteristic>
<Pad_Characteristic_maybe> ::=
<Collation_Definition> ::= <CREATE> <COLLATION> <Collation_Name> <FOR> <Character_Set_Specification> <FROM> <Existing_Collation_Name> <Pad_Characteristic_maybe>
<Existing_Collation_Name> ::= <Collation_Name>
<Pad_Characteristic> ::= <NO> <PAD>
                       | <PAD> <SPACE>
<Drop_Collation_Statement> ::= <DROP> <COLLATION> <Collation_Name> <Drop_Behavior>
<Transliteration_Definition> ::= <CREATE> <TRANSLATION> <Transliteration_Name> <FOR> <Source_Character_Set_Specification> <TO> <Target_Character_Set_Specification> <FROM> <Transliteration_Source>
<Source_Character_Set_Specification> ::= <Character_Set_Specification>
<Target_Character_Set_Specification> ::= <Character_Set_Specification>
<Transliteration_Source> ::= <Existing_Transliteration_Name>
                           | <Transliteration_Routine>
<Existing_Transliteration_Name> ::= <Transliteration_Name>
<Transliteration_Routine> ::= <Specific_Routine_Designator>
<Drop_Transliteration_Statement> ::= <DROP> <TRANSLATION> <Transliteration_Name>
<Assertion_Definition> ::= <CREATE> <ASSERTION> <Constraint_Name> <CHECK> <Left_Paren> <Search_Condition> <Right_Paren> <Constraint_Characteristics_maybe>
<Drop_Assertion_Statement> ::= <DROP> <ASSERTION> <Constraint_Name>
<Gen2376> ::= <REFERENCING> <Old_Or_New_Values_Alias_List>
<Gen2376_maybe> ::= <Gen2376>
<Gen2376_maybe> ::=
<Trigger_Definition> ::= <CREATE> <TRIGGER> <Trigger_Name> <Trigger_Action_Time> <Trigger_Event> <ON> <Table_Name> <Gen2376_maybe> <Triggered_Action>
<Trigger_Action_Time> ::= <BEFORE>
                        | <AFTER>
<Gen2382> ::= <OF> <Trigger_Column_List>
<Gen2382_maybe> ::= <Gen2382>
<Gen2382_maybe> ::=
<Trigger_Event> ::= <INSERT>
                  | <DELETE>
                  | <UPDATE> <Gen2382_maybe>
<Trigger_Column_List> ::= <Column_Name_List>
<Gen2389> ::= <ROW>
            | <STATEMENT>
<Gen2391> ::= <FOR> <EACH> <Gen2389>
<Gen2391_maybe> ::= <Gen2391>
<Gen2391_maybe> ::=
<Gen2394> ::= <WHEN> <Left_Paren> <Search_Condition> <Right_Paren>
<Gen2394_maybe> ::= <Gen2394>
<Gen2394_maybe> ::=
<Triggered_Action> ::= <Gen2391_maybe> <Gen2394_maybe> <Triggered_SQL_Statement>
<Gen2398> ::= <SQL_Procedure_Statement> <Semicolon>
<Gen2398_many> ::= <Gen2398>+
<Triggered_SQL_Statement> ::= <SQL_Procedure_Statement>
                            | <BEGIN> <ATOMIC> <Gen2398_many> <END>
<Old_Or_New_Values_Alias_many> ::= <Old_Or_New_Values_Alias>+
<Old_Or_New_Values_Alias_List> ::= <Old_Or_New_Values_Alias_many>
<ROW_maybe> ::= <ROW>
<ROW_maybe> ::=
<Old_Or_New_Values_Alias> ::= <OLD> <ROW_maybe> <AS_maybe> <Old_Values_Correlation_Name>
                            | <NEW> <ROW_maybe> <AS_maybe> <New_Values_Correlation_Name>
                            | <OLD> <TABLE> <AS_maybe> <Old_Values_Table_Alias>
                            | <NEW> <TABLE> <AS_maybe> <New_Values_Table_Alias>
<Old_Values_Table_Alias> ::= <Identifier>
<New_Values_Table_Alias> ::= <Identifier>
<Old_Values_Correlation_Name> ::= <Correlation_Name>
<New_Values_Correlation_Name> ::= <Correlation_Name>
<Drop_Trigger_Statement> ::= <DROP> <TRIGGER> <Trigger_Name>
<User_Defined_Type_Definition> ::= <CREATE> <TYPE> <User_Defined_Type_Body>
<Subtype_Clause_maybe> ::= <Subtype_Clause>
<Subtype_Clause_maybe> ::=
<Gen2418> ::= <AS> <Representation>
<Gen2418_maybe> ::= <Gen2418>
<Gen2418_maybe> ::=
<User_Defined_Type_Option_List_maybe> ::= <User_Defined_Type_Option_List>
<User_Defined_Type_Option_List_maybe> ::=
<Method_Specification_List_maybe> ::= <Method_Specification_List>
<Method_Specification_List_maybe> ::=
<User_Defined_Type_Body> ::= <Schema_Resolved_User_Defined_Type_Name> <Subtype_Clause_maybe> <Gen2418_maybe> <User_Defined_Type_Option_List_maybe> <Method_Specification_List_maybe>
<User_Defined_Type_Option_any> ::= <User_Defined_Type_Option>*
<User_Defined_Type_Option_List> ::= <User_Defined_Type_Option> <User_Defined_Type_Option_any>
<User_Defined_Type_Option> ::= <Instantiable_Clause>
                             | <Finality>
                             | <Reference_Type_Specification>
                             | <Ref_Cast_Option>
                             | <Cast_Option>
<Subtype_Clause> ::= <UNDER> <Supertype_Name>
<Supertype_Name> ::= <Path_Resolved_User_Defined_Type_Name>
<Representation> ::= <Predefined_Type>
                   | <Member_List>
<Gen2437> ::= <Comma> <Member>
<Gen2437_any> ::= <Gen2437>*
<Member_List> ::= <Left_Paren> <Member> <Gen2437_any> <Right_Paren>
<Member> ::= <Attribute_Definition>
<Instantiable_Clause> ::= <INSTANTIABLE>
                        | <NOT> <INSTANTIABLE>
<Finality> ::= <FINAL>
             | <NOT> <FINAL>
<Reference_Type_Specification> ::= <User_Defined_Representation>
                                 | <Derived_Representation>
                                 | <System_Generated_Representation>
<User_Defined_Representation> ::= <REF> <USING> <Predefined_Type>
<Derived_Representation> ::= <REF> <FROM> <List_Of_Attributes>
<System_Generated_Representation> ::= <REF> <IS> <SYSTEM> <GENERATED>
<Cast_To_Type_maybe> ::= <Cast_To_Type>
<Cast_To_Type_maybe> ::=
<Ref_Cast_Option> ::= <Cast_To_Ref> <Cast_To_Type_maybe>
                    | <Cast_To_Type>
<Cast_To_Ref> ::= <CAST> <Left_Paren> <SOURCE> <AS> <REF> <Right_Paren> <WITH> <Cast_To_Ref_Identifier>
<Cast_To_Ref_Identifier> ::= <Identifier>
<Cast_To_Type> ::= <CAST> <Left_Paren> <REF> <AS> <SOURCE> <Right_Paren> <WITH> <Cast_To_Type_Identifier>
<Cast_To_Type_Identifier> ::= <Identifier>
<Gen2459> ::= <Comma> <Attribute_Name>
<Gen2459_any> ::= <Gen2459>*
<List_Of_Attributes> ::= <Left_Paren> <Attribute_Name> <Gen2459_any> <Right_Paren>
<Cast_To_Distinct_maybe> ::= <Cast_To_Distinct>
<Cast_To_Distinct_maybe> ::=
<Cast_Option> ::= <Cast_To_Distinct_maybe> <Cast_To_Source>
                | <Cast_To_Source>
<Cast_To_Distinct> ::= <CAST> <Left_Paren> <SOURCE> <AS> <DISTINCT> <Right_Paren> <WITH> <Cast_To_Distinct_Identifier>
<Cast_To_Distinct_Identifier> ::= <Identifier>
<Cast_To_Source> ::= <CAST> <Left_Paren> <DISTINCT> <AS> <SOURCE> <Right_Paren> <WITH> <Cast_To_Source_Identifier>
<Cast_To_Source_Identifier> ::= <Identifier>
<Gen2470> ::= <Comma> <Method_Specification>
<Gen2470_any> ::= <Gen2470>*
<Method_Specification_List> ::= <Method_Specification> <Gen2470_any>
<Method_Specification> ::= <Original_Method_Specification>
                         | <Overriding_Method_Specification>
<Gen2475> ::= <SELF> <AS> <RESULT>
<Gen2475_maybe> ::= <Gen2475>
<Gen2475_maybe> ::=
<Gen2478> ::= <SELF> <AS> <LOCATOR>
<Gen2478_maybe> ::= <Gen2478>
<Gen2478_maybe> ::=
<Method_Characteristics_maybe> ::= <Method_Characteristics>
<Method_Characteristics_maybe> ::=
<Original_Method_Specification> ::= <Partial_Method_Specification> <Gen2475_maybe> <Gen2478_maybe> <Method_Characteristics_maybe>
<Overriding_Method_Specification> ::= <OVERRIDING> <Partial_Method_Specification>
<Gen2485> ::= <INSTANCE>
            | <STATIC>
            | <CONSTRUCTOR>
<Gen2485_maybe> ::= <Gen2485>
<Gen2485_maybe> ::=
<Gen2490> ::= <SPECIFIC> <Specific_Method_Name>
<Gen2490_maybe> ::= <Gen2490>
<Gen2490_maybe> ::=
<Partial_Method_Specification> ::= <Gen2485_maybe> <METHOD> <Method_Name> <SQL_Parameter_Declaration_List> <Returns_Clause> <Gen2490_maybe>
<Gen2494> ::= <Schema_Name> <Period>
<Gen2494_maybe> ::= <Gen2494>
<Gen2494_maybe> ::=
<Specific_Method_Name> ::= <Gen2494_maybe> <Qualified_Identifier>
<Method_Characteristic_many> ::= <Method_Characteristic>+
<Method_Characteristics> ::= <Method_Characteristic_many>
<Method_Characteristic> ::= <Language_Clause>
                          | <Parameter_Style_Clause>
                          | <Deterministic_Characteristic>
                          | <SQL_Data_Access_Indication>
                          | <Null_Call_Clause>
<Attribute_Default_maybe> ::= <Attribute_Default>
<Attribute_Default_maybe> ::=
<Attribute_Definition> ::= <Attribute_Name> <Data_Type> <Reference_Scope_Check_maybe> <Attribute_Default_maybe> <Collate_Clause_maybe>
<Attribute_Default> ::= <Default_Clause>
<Alter_Type_Statement> ::= <ALTER> <TYPE> <Schema_Resolved_User_Defined_Type_Name> <Alter_Type_Action>
<Alter_Type_Action> ::= <Add_Attribute_Definition>
                      | <Drop_Attribute_Definition>
                      | <Add_Original_Method_Specification>
                      | <Add_Overriding_Method_Specification>
                      | <Drop_Method_Specification>
<Add_Attribute_Definition> ::= <ADD> <ATTRIBUTE> <Attribute_Definition>
<Drop_Attribute_Definition> ::= <DROP> <ATTRIBUTE> <Attribute_Name> <RESTRICT>
<Add_Original_Method_Specification> ::= <ADD> <Original_Method_Specification>
<Add_Overriding_Method_Specification> ::= <ADD> <Overriding_Method_Specification>
<Drop_Method_Specification> ::= <DROP> <Specific_Method_Specification_Designator> <RESTRICT>
<Gen2520> ::= <INSTANCE>
            | <STATIC>
            | <CONSTRUCTOR>
<Gen2520_maybe> ::= <Gen2520>
<Gen2520_maybe> ::=
<Specific_Method_Specification_Designator> ::= <Gen2520_maybe> <METHOD> <Method_Name> <Data_Type_List>
<Drop_Data_Type_Statement> ::= <DROP> <TYPE> <Schema_Resolved_User_Defined_Type_Name> <Drop_Behavior>
<SQL_Invoked_Routine> ::= <Schema_Routine>
<Schema_Routine> ::= <Schema_Procedure>
                   | <Schema_Function>
<Schema_Procedure> ::= <CREATE> <SQL_Invoked_Procedure>
<Schema_Function> ::= <CREATE> <SQL_Invoked_Function>
<SQL_Invoked_Procedure> ::= <PROCEDURE> <Schema_Qualified_Routine_Name> <SQL_Parameter_Declaration_List> <Routine_Characteristics> <Routine_Body>
<Gen2533> ::= <Function_Specification>
            | <Method_Specification_Designator>
<SQL_Invoked_Function> ::= <Gen2533> <Routine_Body>
<Gen2536> ::= <Comma> <SQL_Parameter_Declaration>
<Gen2536_any> ::= <Gen2536>*
<Gen2538> ::= <SQL_Parameter_Declaration> <Gen2536_any>
<Gen2538_maybe> ::= <Gen2538>
<Gen2538_maybe> ::=
<SQL_Parameter_Declaration_List> ::= <Left_Paren> <Gen2538_maybe> <Right_Paren>
<Parameter_Mode_maybe> ::= <Parameter_Mode>
<Parameter_Mode_maybe> ::=
<SQL_Parameter_Name_maybe> ::= <SQL_Parameter_Name>
<SQL_Parameter_Name_maybe> ::=
<RESULT_maybe> ::= <RESULT>
<RESULT_maybe> ::=
<SQL_Parameter_Declaration> ::= <Parameter_Mode_maybe> <SQL_Parameter_Name_maybe> <Parameter_Type> <RESULT_maybe>
<Parameter_Mode> ::= <IN>
                   | <OUT>
                   | <INOUT>
<Locator_Indication_maybe> ::= <Locator_Indication>
<Locator_Indication_maybe> ::=
<Parameter_Type> ::= <Data_Type> <Locator_Indication_maybe>
<Locator_Indication> ::= <AS> <LOCATOR>
<Dispatch_Clause_maybe> ::= <Dispatch_Clause>
<Dispatch_Clause_maybe> ::=
<Function_Specification> ::= <FUNCTION> <Schema_Qualified_Routine_Name> <SQL_Parameter_Declaration_List> <Returns_Clause> <Routine_Characteristics> <Dispatch_Clause_maybe>
<Gen2559> ::= <INSTANCE>
            | <STATIC>
            | <CONSTRUCTOR>
<Gen2559_maybe> ::= <Gen2559>
<Gen2559_maybe> ::=
<Returns_Clause_maybe> ::= <Returns_Clause>
<Returns_Clause_maybe> ::=
<Method_Specification_Designator> ::= <SPECIFIC> <METHOD> <Specific_Method_Name>
                                    | <Gen2559_maybe> <METHOD> <Method_Name> <SQL_Parameter_Declaration_List> <Returns_Clause_maybe> <FOR> <Schema_Resolved_User_Defined_Type_Name>
<Routine_Characteristic_any> ::= <Routine_Characteristic>*
<Routine_Characteristics> ::= <Routine_Characteristic_any>
<Routine_Characteristic> ::= <Language_Clause>
                           | <Parameter_Style_Clause>
                           | <SPECIFIC> <Specific_Name>
                           | <Deterministic_Characteristic>
                           | <SQL_Data_Access_Indication>
                           | <Null_Call_Clause>
                           | <Dynamic_Result_Sets_Characteristic>
                           | <Savepoint_Level_Indication>
<Savepoint_Level_Indication> ::= <NEW> <SAVEPOINT> <LEVEL>
                               | <OLD> <SAVEPOINT> <LEVEL>
<Dynamic_Result_Sets_Characteristic> ::= <DYNAMIC> <RESULT> <SETS> <Maximum_Dynamic_Result_Sets>
<Parameter_Style_Clause> ::= <PARAMETER> <STYLE> <Parameter_Style>
<Dispatch_Clause> ::= <STATIC> <DISPATCH>
<Returns_Clause> ::= <RETURNS> <Returns_Type>
<Result_Cast_maybe> ::= <Result_Cast>
<Result_Cast_maybe> ::=
<Returns_Type> ::= <Returns_Data_Type> <Result_Cast_maybe>
                 | <Returns_Table_Type>
<Returns_Table_Type> ::= <TABLE> <Table_Function_Column_List>
<Gen2589> ::= <Comma> <Table_Function_Column_List_Element>
<Gen2589_any> ::= <Gen2589>*
<Table_Function_Column_List> ::= <Left_Paren> <Table_Function_Column_List_Element> <Gen2589_any> <Right_Paren>
<Table_Function_Column_List_Element> ::= <Column_Name> <Data_Type>
<Result_Cast> ::= <CAST> <FROM> <Result_Cast_From_Type>
<Result_Cast_From_Type> ::= <Data_Type> <Locator_Indication_maybe>
<Returns_Data_Type> ::= <Data_Type> <Locator_Indication_maybe>
<Routine_Body> ::= <SQL_Routine_Spec>
                 | <External_Body_Reference>
<Rights_Clause_maybe> ::= <Rights_Clause>
<Rights_Clause_maybe> ::=
<SQL_Routine_Spec> ::= <Rights_Clause_maybe> <SQL_Routine_Body>
<Rights_Clause> ::= <SQL> <SECURITY> <INVOKER>
                  | <SQL> <SECURITY> <DEFINER>
<SQL_Routine_Body> ::= <SQL_Procedure_Statement>
<Gen2604> ::= <NAME> <External_Routine_Name>
<Gen2604_maybe> ::= <Gen2604>
<Gen2604_maybe> ::=
<Parameter_Style_Clause_maybe> ::= <Parameter_Style_Clause>
<Parameter_Style_Clause_maybe> ::=
<Transform_Group_Specification_maybe> ::= <Transform_Group_Specification>
<Transform_Group_Specification_maybe> ::=
<External_Security_Clause_maybe> ::= <External_Security_Clause>
<External_Security_Clause_maybe> ::=
<External_Body_Reference> ::= <EXTERNAL> <Gen2604_maybe> <Parameter_Style_Clause_maybe> <Transform_Group_Specification_maybe> <External_Security_Clause_maybe>
<External_Security_Clause> ::= <EXTERNAL> <SECURITY> <DEFINER>
                             | <EXTERNAL> <SECURITY> <INVOKER>
                             | <EXTERNAL> <SECURITY> <IMPLEMENTATION> <DEFINED>
<Parameter_Style> ::= <SQL>
                    | <GENERAL>
<Deterministic_Characteristic> ::= <DETERMINISTIC>
                                 | <NOT> <DETERMINISTIC>
<SQL_Data_Access_Indication> ::= <NO> <SQL>
                               | <CONTAINS> <SQL>
                               | <READS> <SQL> <DATA>
                               | <MODIFIES> <SQL> <DATA>
<Null_Call_Clause> ::= <RETURNS> <NULL> <ON> <NULL> <INPUT>
                     | <CALLED> <ON> <NULL> <INPUT>
<Maximum_Dynamic_Result_Sets> ::= <Unsigned_Integer>
<Gen2628> ::= <Single_Group_Specification>
            | <Multiple_Group_Specification>
<Transform_Group_Specification> ::= <TRANSFORM> <GROUP> <Gen2628>
<Single_Group_Specification> ::= <Group_Name>
<Gen2632> ::= <Comma> <Group_Specification>
<Gen2632_any> ::= <Gen2632>*
<Multiple_Group_Specification> ::= <Group_Specification> <Gen2632_any>
<Group_Specification> ::= <Group_Name> <FOR> <TYPE> <Path_Resolved_User_Defined_Type_Name>
<Alter_Routine_Statement> ::= <ALTER> <Specific_Routine_Designator> <Alter_Routine_Characteristics> <Alter_Routine_Behavior>
<Alter_Routine_Characteristic_many> ::= <Alter_Routine_Characteristic>+
<Alter_Routine_Characteristics> ::= <Alter_Routine_Characteristic_many>
<Alter_Routine_Characteristic> ::= <Language_Clause>
                                 | <Parameter_Style_Clause>
                                 | <SQL_Data_Access_Indication>
                                 | <Null_Call_Clause>
                                 | <Dynamic_Result_Sets_Characteristic>
                                 | <NAME> <External_Routine_Name>
<Alter_Routine_Behavior> ::= <RESTRICT>
<Drop_Routine_Statement> ::= <DROP> <Specific_Routine_Designator> <Drop_Behavior>
<Gen2647> ::= <AS> <ASSIGNMENT>
<Gen2647_maybe> ::= <Gen2647>
<Gen2647_maybe> ::=
<User_Defined_Cast_Definition> ::= <CREATE> <CAST> <Left_Paren> <Source_Data_Type> <AS> <Target_Data_Type> <Right_Paren> <WITH> <Cast_Function> <Gen2647_maybe>
<Cast_Function> ::= <Specific_Routine_Designator>
<Source_Data_Type> ::= <Data_Type>
<Target_Data_Type> ::= <Data_Type>
<Drop_User_Defined_Cast_Statement> ::= <DROP> <CAST> <Left_Paren> <Source_Data_Type> <AS> <Target_Data_Type> <Right_Paren> <Drop_Behavior>
<User_Defined_Ordering_Definition> ::= <CREATE> <ORDERING> <FOR> <Schema_Resolved_User_Defined_Type_Name> <Ordering_Form>
<Ordering_Form> ::= <Equals_Ordering_Form>
                  | <Full_Ordering_Form>
<Equals_Ordering_Form> ::= <EQUALS> <ONLY> <BY> <Ordering_Category>
<Full_Ordering_Form> ::= <ORDER> <FULL> <BY> <Ordering_Category>
<Ordering_Category> ::= <Relative_Category>
                      | <Map_Category>
                      | <State_Category>
<Relative_Category> ::= <RELATIVE> <WITH> <Relative_Function_Specification>
<Map_Category> ::= <MAP> <WITH> <Map_Function_Specification>
<Specific_Name_maybe> ::= <Specific_Name>
<Specific_Name_maybe> ::=
<State_Category> ::= <STATE> <Specific_Name_maybe>
<Relative_Function_Specification> ::= <Specific_Routine_Designator>
<Map_Function_Specification> ::= <Specific_Routine_Designator>
<Drop_User_Defined_Ordering_Statement> ::= <DROP> <ORDERING> <FOR> <Schema_Resolved_User_Defined_Type_Name> <Drop_Behavior>
<Gen2671> ::= <TRANSFORM>
            | <TRANSFORMS>
<Transform_Group_many> ::= <Transform_Group>+
<Transform_Definition> ::= <CREATE> <Gen2671> <FOR> <Schema_Resolved_User_Defined_Type_Name> <Transform_Group_many>
<Transform_Group> ::= <Group_Name> <Left_Paren> <Transform_Element_List> <Right_Paren>
<Group_Name> ::= <Identifier>
<Gen2677> ::= <Comma> <Transform_Element>
<Gen2677_maybe> ::= <Gen2677>
<Gen2677_maybe> ::=
<Transform_Element_List> ::= <Transform_Element> <Gen2677_maybe>
<Transform_Element> ::= <To_Sql>
                      | <From_Sql>
<To_Sql> ::= <TO> <SQL> <WITH> <To_Sql_Function>
<From_Sql> ::= <FROM> <SQL> <WITH> <From_Sql_Function>
<To_Sql_Function> ::= <Specific_Routine_Designator>
<From_Sql_Function> ::= <Specific_Routine_Designator>
<Gen2687> ::= <TRANSFORM>
            | <TRANSFORMS>
<Alter_Group_many> ::= <Alter_Group>+
<Alter_Transform_Statement> ::= <ALTER> <Gen2687> <FOR> <Schema_Resolved_User_Defined_Type_Name> <Alter_Group_many>
<Alter_Group> ::= <Group_Name> <Left_Paren> <Alter_Transform_Action_List> <Right_Paren>
<Gen2692> ::= <Comma> <Alter_Transform_Action>
<Gen2692_any> ::= <Gen2692>*
<Alter_Transform_Action_List> ::= <Alter_Transform_Action> <Gen2692_any>
<Alter_Transform_Action> ::= <Add_Transform_Element_List>
                           | <Drop_Transform_Element_List>
<Add_Transform_Element_List> ::= <ADD> <Left_Paren> <Transform_Element_List> <Right_Paren>
<Gen2698> ::= <Comma> <Transform_Kind>
<Gen2698_maybe> ::= <Gen2698>
<Gen2698_maybe> ::=
<Drop_Transform_Element_List> ::= <DROP> <Left_Paren> <Transform_Kind> <Gen2698_maybe> <Drop_Behavior> <Right_Paren>
<Transform_Kind> ::= <TO> <SQL>
                   | <FROM> <SQL>
<Gen2704> ::= <TRANSFORM>
            | <TRANSFORMS>
<Drop_Transform_Statement> ::= <DROP> <Gen2704> <Transforms_To_Be_Dropped> <FOR> <Schema_Resolved_User_Defined_Type_Name> <Drop_Behavior>
<Transforms_To_Be_Dropped> ::= <ALL>
                             | <Transform_Group_Element>
<Transform_Group_Element> ::= <Group_Name>
<Sequence_Generator_Options_maybe> ::= <Sequence_Generator_Options>
<Sequence_Generator_Options_maybe> ::=
<Sequence_Generator_Definition> ::= <CREATE> <SEQUENCE> <Sequence_Generator_Name> <Sequence_Generator_Options_maybe>
<Sequence_Generator_Option_many> ::= <Sequence_Generator_Option>+
<Sequence_Generator_Options> ::= <Sequence_Generator_Option_many>
<Sequence_Generator_Option> ::= <Sequence_Generator_Data_Type_Option>
                              | <Common_Sequence_Generator_Options>
<Common_Sequence_Generator_Option_many> ::= <Common_Sequence_Generator_Option>+
<Common_Sequence_Generator_Options> ::= <Common_Sequence_Generator_Option_many>
<Common_Sequence_Generator_Option> ::= <Sequence_Generator_Start_With_Option>
                                     | <Basic_Sequence_Generator_Option>
<Basic_Sequence_Generator_Option> ::= <Sequence_Generator_Increment_By_Option>
                                    | <Sequence_Generator_Maxvalue_Option>
                                    | <Sequence_Generator_Minvalue_Option>
                                    | <Sequence_Generator_Cycle_Option>
<Sequence_Generator_Data_Type_Option> ::= <AS> <Data_Type>
<Sequence_Generator_Start_With_Option> ::= <START> <WITH> <Sequence_Generator_Start_Value>
<Sequence_Generator_Start_Value> ::= <Signed_Numeric_Literal>
<Sequence_Generator_Increment_By_Option> ::= <INCREMENT> <BY> <Sequence_Generator_Increment>
<Sequence_Generator_Increment> ::= <Signed_Numeric_Literal>
<Sequence_Generator_Maxvalue_Option> ::= <MAXVALUE> <Sequence_Generator_Max_Value>
                                       | <NO> <MAXVALUE>
<Sequence_Generator_Max_Value> ::= <Signed_Numeric_Literal>
<Sequence_Generator_Minvalue_Option> ::= <MINVALUE> <Sequence_Generator_Min_Value>
                                       | <NO> <MINVALUE>
<Sequence_Generator_Min_Value> ::= <Signed_Numeric_Literal>
<Sequence_Generator_Cycle_Option> ::= <CYCLE>
                                    | <NO> <CYCLE>
<Alter_Sequence_Generator_Statement> ::= <ALTER> <SEQUENCE> <Sequence_Generator_Name> <Alter_Sequence_Generator_Options>
<Alter_Sequence_Generator_Option_many> ::= <Alter_Sequence_Generator_Option>+
<Alter_Sequence_Generator_Options> ::= <Alter_Sequence_Generator_Option_many>
<Alter_Sequence_Generator_Option> ::= <Alter_Sequence_Generator_Restart_Option>
                                    | <Basic_Sequence_Generator_Option>
<Alter_Sequence_Generator_Restart_Option> ::= <RESTART> <WITH> <Sequence_Generator_Restart_Value>
<Sequence_Generator_Restart_Value> ::= <Signed_Numeric_Literal>
<Drop_Sequence_Generator_Statement> ::= <DROP> <SEQUENCE> <Sequence_Generator_Name> <Drop_Behavior>
<Grant_Statement> ::= <Grant_Privilege_Statement>
                    | <Grant_Role_Statement>
<Gen2748> ::= <Comma> <Grantee>
<Gen2748_any> ::= <Gen2748>*
<Gen2750> ::= <WITH> <HIERARCHY> <OPTION>
<Gen2750_maybe> ::= <Gen2750>
<Gen2750_maybe> ::=
<Gen2753> ::= <WITH> <GRANT> <OPTION>
<Gen2753_maybe> ::= <Gen2753>
<Gen2753_maybe> ::=
<Gen2756> ::= <GRANTED> <BY> <Grantor>
<Gen2756_maybe> ::= <Gen2756>
<Gen2756_maybe> ::=
<Grant_Privilege_Statement> ::= <GRANT> <Privileges> <TO> <Grantee> <Gen2748_any> <Gen2750_maybe> <Gen2753_maybe> <Gen2756_maybe>
<Privileges> ::= <Object_Privileges> <ON> <Object_Name>
<TABLE_maybe> ::= <TABLE>
<TABLE_maybe> ::=
<Object_Name> ::= <TABLE_maybe> <Table_Name>
                | <DOMAIN> <Domain_Name>
                | <COLLATION> <Collation_Name>
                | <CHARACTER> <SET> <Character_Set_Name>
                | <TRANSLATION> <Transliteration_Name>
                | <TYPE> <Schema_Resolved_User_Defined_Type_Name>
                | <SEQUENCE> <Sequence_Generator_Name>
                | <Specific_Routine_Designator>
<Gen2771> ::= <Comma> <Action>
<Gen2771_any> ::= <Gen2771>*
<Object_Privileges> ::= <ALL> <PRIVILEGES>
                      | <Action> <Gen2771_any>
<Gen2775> ::= <Left_Paren> <Privilege_Column_List> <Right_Paren>
<Gen2775_maybe> ::= <Gen2775>
<Gen2775_maybe> ::=
<Gen2778> ::= <Left_Paren> <Privilege_Column_List> <Right_Paren>
<Gen2778_maybe> ::= <Gen2778>
<Gen2778_maybe> ::=
<Gen2781> ::= <Left_Paren> <Privilege_Column_List> <Right_Paren>
<Gen2781_maybe> ::= <Gen2781>
<Gen2781_maybe> ::=
<Action> ::= <SELECT>
           | <SELECT> <Left_Paren> <Privilege_Column_List> <Right_Paren>
           | <SELECT> <Left_Paren> <Privilege_Method_List> <Right_Paren>
           | <DELETE>
           | <INSERT> <Gen2775_maybe>
           | <UPDATE> <Gen2778_maybe>
           | <REFERENCES> <Gen2781_maybe>
           | <USAGE>
           | <TRIGGER>
           | <UNDER>
           | <EXECUTE>
<Gen2795> ::= <Comma> <Specific_Routine_Designator>
<Gen2795_any> ::= <Gen2795>*
<Privilege_Method_List> ::= <Specific_Routine_Designator> <Gen2795_any>
<Privilege_Column_List> ::= <Column_Name_List>
<Grantee> ::= <PUBLIC>
            | <Authorization_Identifier>
<Grantor> ::= <Lex348>
            | <Lex344>
<Gen2803> ::= <WITH> <ADMIN> <Grantor>
<Gen2803_maybe> ::= <Gen2803>
<Gen2803_maybe> ::=
<Role_Definition> ::= <CREATE> <ROLE> <Role_Name> <Gen2803_maybe>
<Gen2807> ::= <Comma> <Role_Granted>
<Gen2807_any> ::= <Gen2807>*
<Gen2809> ::= <Comma> <Grantee>
<Gen2809_any> ::= <Gen2809>*
<Gen2811> ::= <WITH> <ADMIN> <OPTION>
<Gen2811_maybe> ::= <Gen2811>
<Gen2811_maybe> ::=
<Gen2814> ::= <GRANTED> <BY> <Grantor>
<Gen2814_maybe> ::= <Gen2814>
<Gen2814_maybe> ::=
<Grant_Role_Statement> ::= <GRANT> <Role_Granted> <Gen2807_any> <TO> <Grantee> <Gen2809_any> <Gen2811_maybe> <Gen2814_maybe>
<Role_Granted> ::= <Role_Name>
<Drop_Role_Statement> ::= <DROP> <ROLE> <Role_Name>
<Revoke_Statement> ::= <Revoke_Privilege_Statement>
                     | <Revoke_Role_Statement>
<Revoke_Option_Extension_maybe> ::= <Revoke_Option_Extension>
<Revoke_Option_Extension_maybe> ::=
<Gen2824> ::= <Comma> <Grantee>
<Gen2824_any> ::= <Gen2824>*
<Gen2826> ::= <GRANTED> <BY> <Grantor>
<Gen2826_maybe> ::= <Gen2826>
<Gen2826_maybe> ::=
<Revoke_Privilege_Statement> ::= <REVOKE> <Revoke_Option_Extension_maybe> <Privileges> <FROM> <Grantee> <Gen2824_any> <Gen2826_maybe> <Drop_Behavior>
<Revoke_Option_Extension> ::= <GRANT> <OPTION> <FOR>
                            | <HIERARCHY> <OPTION> <FOR>
<Gen2832> ::= <ADMIN> <OPTION> <FOR>
<Gen2832_maybe> ::= <Gen2832>
<Gen2832_maybe> ::=
<Gen2835> ::= <Comma> <Role_Revoked>
<Gen2835_any> ::= <Gen2835>*
<Gen2837> ::= <Comma> <Grantee>
<Gen2837_any> ::= <Gen2837>*
<Gen2839> ::= <GRANTED> <BY> <Grantor>
<Gen2839_maybe> ::= <Gen2839>
<Gen2839_maybe> ::=
<Revoke_Role_Statement> ::= <REVOKE> <Gen2832_maybe> <Role_Revoked> <Gen2835_any> <FROM> <Grantee> <Gen2837_any> <Gen2839_maybe> <Drop_Behavior>
<Role_Revoked> ::= <Role_Name>
<Module_Path_Specification_maybe> ::= <Module_Path_Specification>
<Module_Path_Specification_maybe> ::=
<Module_Transform_Group_Specification_maybe> ::= <Module_Transform_Group_Specification>
<Module_Transform_Group_Specification_maybe> ::=
<Module_Collations_maybe> ::= <Module_Collations>
<Module_Collations_maybe> ::=
<Temporary_Table_Declaration_any> ::= <Temporary_Table_Declaration>*
<Module_Contents_many> ::= <Module_Contents>+
<SQL_Client_Module_Definition> ::= <Module_Name_Clause> <Language_Clause> <Module_Authorization_Clause> <Module_Path_Specification_maybe> <Module_Transform_Group_Specification_maybe> <Module_Collations_maybe> <Temporary_Table_Declaration_any> <Module_Contents_many>
<Gen2853> ::= <ONLY>
            | <AND> <DYNAMIC>
<Gen2855> ::= <FOR> <STATIC> <Gen2853>
<Gen2855_maybe> ::= <Gen2855>
<Gen2855_maybe> ::=
<Gen2858> ::= <ONLY>
            | <AND> <DYNAMIC>
<Gen2860> ::= <FOR> <STATIC> <Gen2858>
<Gen2860_maybe> ::= <Gen2860>
<Gen2860_maybe> ::=
<Module_Authorization_Clause> ::= <SCHEMA> <Schema_Name>
                                | <AUTHORIZATION> <Module_Authorization_Identifier> <Gen2855_maybe>
                                | <SCHEMA> <Schema_Name> <AUTHORIZATION> <Module_Authorization_Identifier> <Gen2860_maybe>
<Module_Authorization_Identifier> ::= <Authorization_Identifier>
<Module_Path_Specification> ::= <Path_Specification>
<Module_Transform_Group_Specification> ::= <Transform_Group_Specification>
<Module_Collation_Specification_many> ::= <Module_Collation_Specification>+
<Module_Collations> ::= <Module_Collation_Specification_many>
<Gen2871> ::= <FOR> <Character_Set_Specification_List>
<Gen2871_maybe> ::= <Gen2871>
<Gen2871_maybe> ::=
<Module_Collation_Specification> ::= <COLLATION> <Collation_Name> <Gen2871_maybe>
<Gen2875> ::= <Comma> <Character_Set_Specification>
<Gen2875_any> ::= <Gen2875>*
<Character_Set_Specification_List> ::= <Character_Set_Specification> <Gen2875_any>
<Module_Contents> ::= <Declare_Cursor>
                    | <Dynamic_Declare_Cursor>
                    | <Externally_Invoked_Procedure>
<SQL_Client_Module_Name_maybe> ::= <SQL_Client_Module_Name>
<SQL_Client_Module_Name_maybe> ::=
<Module_Character_Set_Specification_maybe> ::= <Module_Character_Set_Specification>
<Module_Character_Set_Specification_maybe> ::=
<Module_Name_Clause> ::= <MODULE> <SQL_Client_Module_Name_maybe> <Module_Character_Set_Specification_maybe>
<Module_Character_Set_Specification> ::= <NAMES> <ARE> <Character_Set_Specification>
<Externally_Invoked_Procedure> ::= <PROCEDURE> <Procedure_Name> <Host_Parameter_Declaration_List> <Semicolon> <SQL_Procedure_Statement> <Semicolon>
<Gen2888> ::= <Comma> <Host_Parameter_Declaration>
<Gen2888_any> ::= <Gen2888>*
<Host_Parameter_Declaration_List> ::= <Left_Paren> <Host_Parameter_Declaration> <Gen2888_any> <Right_Paren>
<Host_Parameter_Declaration> ::= <Host_Parameter_Name> <Host_Parameter_Data_Type>
                               | <Status_Parameter>
<Host_Parameter_Data_Type> ::= <Data_Type> <Locator_Indication_maybe>
<Status_Parameter> ::= <SQLSTATE>
<SQL_Procedure_Statement> ::= <SQL_Executable_Statement>
<SQL_Executable_Statement> ::= <SQL_Schema_Statement>
                             | <SQL_Data_Statement>
                             | <SQL_Control_Statement>
                             | <SQL_Transaction_Statement>
                             | <SQL_Connection_Statement>
                             | <SQL_Session_Statement>
                             | <SQL_Diagnostics_Statement>
                             | <SQL_Dynamic_Statement>
<SQL_Schema_Statement> ::= <SQL_Schema_Definition_Statement>
                         | <SQL_Schema_Manipulation_Statement>
<SQL_Schema_Definition_Statement> ::= <Schema_Definition>
                                    | <Table_Definition>
                                    | <View_Definition>
                                    | <SQL_Invoked_Routine>
                                    | <Grant_Statement>
                                    | <Role_Definition>
                                    | <Domain_Definition>
                                    | <Character_Set_Definition>
                                    | <Collation_Definition>
                                    | <Transliteration_Definition>
                                    | <Assertion_Definition>
                                    | <Trigger_Definition>
                                    | <User_Defined_Type_Definition>
                                    | <User_Defined_Cast_Definition>
                                    | <User_Defined_Ordering_Definition>
                                    | <Transform_Definition>
                                    | <Sequence_Generator_Definition>
<SQL_Schema_Manipulation_Statement> ::= <Drop_Schema_Statement>
                                      | <Alter_Table_Statement>
                                      | <Drop_Table_Statement>
                                      | <Drop_View_Statement>
                                      | <Alter_Routine_Statement>
                                      | <Drop_Routine_Statement>
                                      | <Drop_User_Defined_Cast_Statement>
                                      | <Revoke_Statement>
                                      | <Drop_Role_Statement>
                                      | <Alter_Domain_Statement>
                                      | <Drop_Domain_Statement>
                                      | <Drop_Character_Set_Statement>
                                      | <Drop_Collation_Statement>
                                      | <Drop_Transliteration_Statement>
                                      | <Drop_Assertion_Statement>
                                      | <Drop_Trigger_Statement>
                                      | <Alter_Type_Statement>
                                      | <Drop_Data_Type_Statement>
                                      | <Drop_User_Defined_Ordering_Statement>
                                      | <Alter_Transform_Statement>
                                      | <Drop_Transform_Statement>
                                      | <Alter_Sequence_Generator_Statement>
                                      | <Drop_Sequence_Generator_Statement>
<SQL_Data_Statement> ::= <Open_Statement>
                       | <Fetch_Statement>
                       | <Close_Statement>
                       | <Select_Statement_Single_Row>
                       | <Free_Locator_Statement>
                       | <Hold_Locator_Statement>
                       | <SQL_Data_Change_Statement>
<SQL_Data_Change_Statement> ::= <Delete_Statement_Positioned>
                              | <Delete_Statement_Searched>
                              | <Insert_Statement>
                              | <Update_Statement_Positioned>
                              | <Update_Statement_Searched>
                              | <Merge_Statement>
<SQL_Control_Statement> ::= <Call_Statement>
                          | <Return_Statement>
<SQL_Transaction_Statement> ::= <Start_Transaction_Statement>
                              | <Set_Transaction_Statement>
                              | <Set_Constraints_Mode_Statement>
                              | <Savepoint_Statement>
                              | <Release_Savepoint_Statement>
                              | <Commit_Statement>
                              | <Rollback_Statement>
<SQL_Connection_Statement> ::= <Connect_Statement>
                             | <Set_Connection_Statement>
                             | <Disconnect_Statement>
<SQL_Session_Statement> ::= <Set_Session_User_Identifier_Statement>
                          | <Set_Role_Statement>
                          | <Set_Local_Time_Zone_Statement>
                          | <Set_Session_Characteristics_Statement>
                          | <Set_Catalog_Statement>
                          | <Set_Schema_Statement>
                          | <Set_Names_Statement>
                          | <Set_Path_Statement>
                          | <Set_Transform_Group_Statement>
                          | <Set_Session_Collation_Statement>
<SQL_Diagnostics_Statement> ::= <Get_Diagnostics_Statement>
<SQL_Dynamic_Statement> ::= <System_Descriptor_Statement>
                          | <Prepare_Statement>
                          | <Deallocate_Prepared_Statement>
                          | <Describe_Statement>
                          | <Execute_Statement>
                          | <Execute_Immediate_Statement>
                          | <SQL_Dynamic_Data_Statement>
<SQL_Dynamic_Data_Statement> ::= <Allocate_Cursor_Statement>
                               | <Dynamic_Open_Statement>
                               | <Dynamic_Fetch_Statement>
                               | <Dynamic_Close_Statement>
                               | <Dynamic_Delete_Statement_Positioned>
                               | <Dynamic_Update_Statement_Positioned>
<System_Descriptor_Statement> ::= <Allocate_Descriptor_Statement>
                                | <Deallocate_Descriptor_Statement>
                                | <Set_Descriptor_Statement>
                                | <Get_Descriptor_Statement>
<Cursor_Sensitivity_maybe> ::= <Cursor_Sensitivity>
<Cursor_Sensitivity_maybe> ::=
<Cursor_Scrollability_maybe> ::= <Cursor_Scrollability>
<Cursor_Scrollability_maybe> ::=
<Cursor_Holdability_maybe> ::= <Cursor_Holdability>
<Cursor_Holdability_maybe> ::=
<Cursor_Returnability_maybe> ::= <Cursor_Returnability>
<Cursor_Returnability_maybe> ::=
<Declare_Cursor> ::= <DECLARE> <Cursor_Name> <Cursor_Sensitivity_maybe> <Cursor_Scrollability_maybe> <CURSOR> <Cursor_Holdability_maybe> <Cursor_Returnability_maybe> <FOR> <Cursor_Specification>
<Cursor_Sensitivity> ::= <SENSITIVE>
                       | <INSENSITIVE>
                       | <ASENSITIVE>
<Cursor_Scrollability> ::= <SCROLL>
                         | <NO> <SCROLL>
<Cursor_Holdability> ::= <WITH> <HOLD>
                       | <WITHOUT> <HOLD>
<Cursor_Returnability> ::= <WITH> <RETURN>
                         | <WITHOUT> <RETURN>
<Updatability_Clause_maybe> ::= <Updatability_Clause>
<Updatability_Clause_maybe> ::=
<Cursor_Specification> ::= <Query_Expression> <Order_By_Clause_maybe> <Updatability_Clause_maybe>
<Gen3020> ::= <OF> <Column_Name_List>
<Gen3020_maybe> ::= <Gen3020>
<Gen3020_maybe> ::=
<Gen3023> ::= <READ> <ONLY>
            | <UPDATE> <Gen3020_maybe>
<Updatability_Clause> ::= <FOR> <Gen3023>
<Order_By_Clause> ::= <ORDER> <BY> <Sort_Specification_List>
<Open_Statement> ::= <OPEN> <Cursor_Name>
<Fetch_Orientation_maybe> ::= <Fetch_Orientation>
<Fetch_Orientation_maybe> ::=
<Gen3030> ::= <Fetch_Orientation_maybe> <FROM>
<Gen3030_maybe> ::= <Gen3030>
<Gen3030_maybe> ::=
<Fetch_Statement> ::= <FETCH> <Gen3030_maybe> <Cursor_Name> <INTO> <Fetch_Target_List>
<Gen3034> ::= <ABSOLUTE>
            | <RELATIVE>
<Fetch_Orientation> ::= <NEXT>
                      | <PRIOR>
                      | <FIRST>
                      | <LAST>
                      | <Gen3034> <Simple_Value_Specification>
<Gen3041> ::= <Comma> <Target_Specification>
<Gen3041_any> ::= <Gen3041>*
<Fetch_Target_List> ::= <Target_Specification> <Gen3041_any>
<Close_Statement> ::= <CLOSE> <Cursor_Name>
<Select_Statement_Single_Row> ::= <SELECT> <Set_Quantifier_maybe> <Select_List> <INTO> <Select_Target_List> <Table_Expression>
<Gen3046> ::= <Comma> <Target_Specification>
<Gen3046_any> ::= <Gen3046>*
<Select_Target_List> ::= <Target_Specification> <Gen3046_any>
<Delete_Statement_Positioned> ::= <DELETE> <FROM> <Target_Table> <WHERE> <CURRENT> <OF> <Cursor_Name>
<Target_Table> ::= <Table_Name>
                 | <ONLY> <Left_Paren> <Table_Name> <Right_Paren>
<Gen3052> ::= <WHERE> <Search_Condition>
<Gen3052_maybe> ::= <Gen3052>
<Gen3052_maybe> ::=
<Delete_Statement_Searched> ::= <DELETE> <FROM> <Target_Table> <Gen3052_maybe>
<Insert_Statement> ::= <INSERT> <INTO> <Insertion_Target> <Insert_Columns_And_Source>
<Insertion_Target> ::= <Table_Name>
<Insert_Columns_And_Source> ::= <From_Subquery>
                              | <From_Constructor>
                              | <From_Default>
<Gen3061> ::= <Left_Paren> <Insert_Column_List> <Right_Paren>
<Gen3061_maybe> ::= <Gen3061>
<Gen3061_maybe> ::=
<Override_Clause_maybe> ::= <Override_Clause>
<Override_Clause_maybe> ::=
<From_Subquery> ::= <Gen3061_maybe> <Override_Clause_maybe> <Query_Expression>
<Gen3067> ::= <Left_Paren> <Insert_Column_List> <Right_Paren>
<Gen3067_maybe> ::= <Gen3067>
<Gen3067_maybe> ::=
<From_Constructor> ::= <Gen3067_maybe> <Override_Clause_maybe> <Contextually_Typed_Table_Value_Constructor>
<Override_Clause> ::= <OVERRIDING> <USER> <VALUE>
                    | <OVERRIDING> <SYSTEM> <VALUE>
<From_Default> ::= <DEFAULT> <VALUES>
<Insert_Column_List> ::= <Column_Name_List>
<Gen3075> ::= <AS_maybe> <Merge_Correlation_Name>
<Gen3075_maybe> ::= <Gen3075>
<Gen3075_maybe> ::=
<Merge_Statement> ::= <MERGE> <INTO> <Target_Table> <Gen3075_maybe> <USING> <Table_Reference> <ON> <Search_Condition> <Merge_Operation_Specification>
<Merge_Correlation_Name> ::= <Correlation_Name>
<Merge_When_Clause_many> ::= <Merge_When_Clause>+
<Merge_Operation_Specification> ::= <Merge_When_Clause_many>
<Merge_When_Clause> ::= <Merge_When_Matched_Clause>
                      | <Merge_When_Not_Matched_Clause>
<Merge_When_Matched_Clause> ::= <WHEN> <MATCHED> <THEN> <Merge_Update_Specification>
<Merge_When_Not_Matched_Clause> ::= <WHEN> <NOT> <MATCHED> <THEN> <Merge_Insert_Specification>
<Merge_Update_Specification> ::= <UPDATE> <SET> <Set_Clause_List>
<Gen3087> ::= <Left_Paren> <Insert_Column_List> <Right_Paren>
<Gen3087_maybe> ::= <Gen3087>
<Gen3087_maybe> ::=
<Merge_Insert_Specification> ::= <INSERT> <Gen3087_maybe> <Override_Clause_maybe> <VALUES> <Merge_Insert_Value_List>
<Gen3091> ::= <Comma> <Merge_Insert_Value_Element>
<Gen3091_any> ::= <Gen3091>*
<Merge_Insert_Value_List> ::= <Left_Paren> <Merge_Insert_Value_Element> <Gen3091_any> <Right_Paren>
<Merge_Insert_Value_Element> ::= <Value_Expression>
                               | <Contextually_Typed_Value_Specification>
<Update_Statement_Positioned> ::= <UPDATE> <Target_Table> <SET> <Set_Clause_List> <WHERE> <CURRENT> <OF> <Cursor_Name>
<Gen3097> ::= <WHERE> <Search_Condition>
<Gen3097_maybe> ::= <Gen3097>
<Gen3097_maybe> ::=
<Update_Statement_Searched> ::= <UPDATE> <Target_Table> <SET> <Set_Clause_List> <Gen3097_maybe>
<Gen3101> ::= <Comma> <Set_Clause>
<Gen3101_any> ::= <Gen3101>*
<Set_Clause_List> ::= <Set_Clause> <Gen3101_any>
<Set_Clause> ::= <Multiple_Column_Assignment>
               | <Set_Target> <Equals_Operator> <Update_Source>
<Set_Target> ::= <Update_Target>
               | <Mutated_Set_Clause>
<Multiple_Column_Assignment> ::= <Set_Target_List> <Equals_Operator> <Assigned_Row>
<Gen3109> ::= <Comma> <Set_Target>
<Gen3109_any> ::= <Gen3109>*
<Set_Target_List> ::= <Left_Paren> <Set_Target> <Gen3109_any> <Right_Paren>
<Assigned_Row> ::= <Contextually_Typed_Row_Value_Expression>
<Update_Target> ::= <Object_Column>
                  | <Object_Column> <Left_Bracket_Or_Trigraph> <Simple_Value_Specification> <Right_Bracket_Or_Trigraph>
<Object_Column> ::= <Column_Name>
<Mutated_Set_Clause> ::= <Mutated_Target> <Period> <Method_Name>
<Mutated_Target> ::= <Object_Column>
                   | <Mutated_Set_Clause>
<Update_Source> ::= <Value_Expression>
                  | <Contextually_Typed_Value_Specification>
<Gen3121> ::= <ON> <COMMIT> <Table_Commit_Action> <ROWS>
<Gen3121_maybe> ::= <Gen3121>
<Gen3121_maybe> ::=
<Temporary_Table_Declaration> ::= <DECLARE> <LOCAL> <TEMPORARY> <TABLE> <Table_Name> <Table_Element_List> <Gen3121_maybe>
<Gen3125> ::= <Comma> <Locator_Reference>
<Gen3125_any> ::= <Gen3125>*
<Free_Locator_Statement> ::= <FREE> <LOCATOR> <Locator_Reference> <Gen3125_any>
<Locator_Reference> ::= <Host_Parameter_Name>
                      | <Embedded_Variable_Name>
<Gen3130> ::= <Comma> <Locator_Reference>
<Gen3130_any> ::= <Gen3130>*
<Hold_Locator_Statement> ::= <HOLD> <LOCATOR> <Locator_Reference> <Gen3130_any>
<Call_Statement> ::= <CALL> <Routine_Invocation>
<Return_Statement> ::= <RETURN> <Return_Value>
<Return_Value> ::= <Value_Expression>
                 | <NULL>
<Gen3137> ::= <Comma> <Transaction_Mode>
<Gen3137_any> ::= <Gen3137>*
<Gen3139> ::= <Transaction_Mode> <Gen3137_any>
<Gen3139_maybe> ::= <Gen3139>
<Gen3139_maybe> ::=
<Start_Transaction_Statement> ::= <START> <TRANSACTION> <Gen3139_maybe>
<Transaction_Mode> ::= <Isolation_Level>
                     | <Transaction_Access_Mode>
                     | <Diagnostics_Size>
<Transaction_Access_Mode> ::= <READ> <ONLY>
                            | <READ> <WRITE>
<Isolation_Level> ::= <ISOLATION> <LEVEL> <Level_Of_Isolation>
<Level_Of_Isolation> ::= <READ> <UNCOMMITTED>
                       | <READ> <COMMITTED>
                       | <REPEATABLE> <READ>
                       | <SERIALIZABLE>
<Diagnostics_Size> ::= <DIAGNOSTICS> <SIZE> <Number_Of_Conditions>
<Number_Of_Conditions> ::= <Simple_Value_Specification>
<LOCAL_maybe> ::= <LOCAL>
<LOCAL_maybe> ::=
<Set_Transaction_Statement> ::= <SET> <LOCAL_maybe> <Transaction_Characteristics>
<Gen3158> ::= <Comma> <Transaction_Mode>
<Gen3158_any> ::= <Gen3158>*
<Transaction_Characteristics> ::= <TRANSACTION> <Transaction_Mode> <Gen3158_any>
<Gen3161> ::= <DEFERRED>
            | <IMMEDIATE>
<Set_Constraints_Mode_Statement> ::= <SET> <CONSTRAINTS> <Constraint_Name_List> <Gen3161>
<Gen3164> ::= <Comma> <Constraint_Name>
<Gen3164_any> ::= <Gen3164>*
<Constraint_Name_List> ::= <ALL>
                         | <Constraint_Name> <Gen3164_any>
<Savepoint_Statement> ::= <SAVEPOINT> <Savepoint_Specifier>
<Savepoint_Specifier> ::= <Savepoint_Name>
<Release_Savepoint_Statement> ::= <RELEASE> <SAVEPOINT> <Savepoint_Specifier>
<WORK_maybe> ::= <WORK>
<WORK_maybe> ::=
<NO_maybe> ::= <NO>
<NO_maybe> ::=
<Gen3175> ::= <AND> <NO_maybe> <CHAIN>
<Gen3175_maybe> ::= <Gen3175>
<Gen3175_maybe> ::=
<Commit_Statement> ::= <COMMIT> <WORK_maybe> <Gen3175_maybe>
<Gen3179> ::= <AND> <NO_maybe> <CHAIN>
<Gen3179_maybe> ::= <Gen3179>
<Gen3179_maybe> ::=
<Savepoint_Clause_maybe> ::= <Savepoint_Clause>
<Savepoint_Clause_maybe> ::=
<Rollback_Statement> ::= <ROLLBACK> <WORK_maybe> <Gen3179_maybe> <Savepoint_Clause_maybe>
<Savepoint_Clause> ::= <TO> <SAVEPOINT> <Savepoint_Specifier>
<Connect_Statement> ::= <CONNECT> <TO> <Connection_Target>
<Gen3187> ::= <AS> <Connection_Name>
<Gen3187_maybe> ::= <Gen3187>
<Gen3187_maybe> ::=
<Gen3190> ::= <USER> <Connection_User_Name>
<Gen3190_maybe> ::= <Gen3190>
<Gen3190_maybe> ::=
<Connection_Target> ::= <Sql_Server_Name> <Gen3187_maybe> <Gen3190_maybe>
                      | <DEFAULT>
<Set_Connection_Statement> ::= <SET> <CONNECTION> <Connection_Object>
<Connection_Object> ::= <DEFAULT>
                      | <Connection_Name>
<Disconnect_Statement> ::= <DISCONNECT> <Disconnect_Object>
<Disconnect_Object> ::= <Connection_Object>
                      | <ALL>
                      | <CURRENT>
<Set_Session_Characteristics_Statement> ::= <SET> <SESSION> <CHARACTERISTICS> <AS> <Session_Characteristic_List>
<Gen3203> ::= <Comma> <Session_Characteristic>
<Gen3203_any> ::= <Gen3203>*
<Session_Characteristic_List> ::= <Session_Characteristic> <Gen3203_any>
<Session_Characteristic> ::= <Transaction_Characteristics>
<Set_Session_User_Identifier_Statement> ::= <SET> <SESSION> <AUTHORIZATION> <Value_Specification>
<Set_Role_Statement> ::= <SET> <ROLE> <Role_Specification>
<Role_Specification> ::= <Value_Specification>
                       | <NONE>
<Set_Local_Time_Zone_Statement> ::= <SET> <TIME> <ZONE> <Set_Time_Zone_Value>
<Set_Time_Zone_Value> ::= <Interval_Value_Expression>
                        | <LOCAL>
<Set_Catalog_Statement> ::= <SET> <Catalog_Name_Characteristic>
<Catalog_Name_Characteristic> ::= <CATALOG> <Value_Specification>
<Set_Schema_Statement> ::= <SET> <Schema_Name_Characteristic>
<Schema_Name_Characteristic> ::= <SCHEMA> <Value_Specification>
<Set_Names_Statement> ::= <SET> <Character_Set_Name_Characteristic>
<Character_Set_Name_Characteristic> ::= <NAMES> <Value_Specification>
<Set_Path_Statement> ::= <SET> <SQL_Path_Characteristic>
<SQL_Path_Characteristic> ::= <PATH> <Value_Specification>
<Set_Transform_Group_Statement> ::= <SET> <Transform_Group_Characteristic>
<Transform_Group_Characteristic> ::= <DEFAULT> <TRANSFORM> <GROUP> <Value_Specification>
                                   | <TRANSFORM> <GROUP> <FOR> <TYPE> <Path_Resolved_User_Defined_Type_Name> <Value_Specification>
<Gen3225> ::= <FOR> <Character_Set_Specification_List>
<Gen3225_maybe> ::= <Gen3225>
<Gen3225_maybe> ::=
<Gen3228> ::= <FOR> <Character_Set_Specification_List>
<Gen3228_maybe> ::= <Gen3228>
<Gen3228_maybe> ::=
<Set_Session_Collation_Statement> ::= <SET> <COLLATION> <Collation_Specification> <Gen3225_maybe>
                                    | <SET> <NO> <COLLATION> <Gen3228_maybe>
<Gen3233> ::= <Lex013> <Character_Set_Specification>
<Gen3233_any> ::= <Gen3233>*
<Character_Set_Specification_List> ::= <Character_Set_Specification> <Gen3233_any>
<Collation_Specification> ::= <Value_Specification>
<SQL_maybe> ::= <SQL>
<SQL_maybe> ::=
<Gen3239> ::= <WITH> <MAX> <Occurrences>
<Gen3239_maybe> ::= <Gen3239>
<Gen3239_maybe> ::=
<Allocate_Descriptor_Statement> ::= <ALLOCATE> <SQL_maybe> <DESCRIPTOR> <Descriptor_Name> <Gen3239_maybe>
<Occurrences> ::= <Simple_Value_Specification>
<Deallocate_Descriptor_Statement> ::= <DEALLOCATE> <SQL_maybe> <DESCRIPTOR> <Descriptor_Name>
<Get_Descriptor_Statement> ::= <GET> <SQL_maybe> <DESCRIPTOR> <Descriptor_Name> <Get_Descriptor_Information>
<Gen3246> ::= <Comma> <Get_Header_Information>
<Gen3246_any> ::= <Gen3246>*
<Gen3248> ::= <Comma> <Get_Item_Information>
<Gen3248_any> ::= <Gen3248>*
<Get_Descriptor_Information> ::= <Get_Header_Information> <Gen3246_any>
                               | <VALUE> <Item_Number> <Get_Item_Information> <Gen3248_any>
<Get_Header_Information> ::= <Simple_Target_Specification_1> <Equals_Operator> <Header_Item_Name>
<Header_Item_Name> ::= <COUNT>
                     | <Lex162>
                     | <Lex130>
                     | <Lex131>
                     | <Lex272>
<Get_Item_Information> ::= <Simple_Target_Specification_2> <Equals_Operator> <Descriptor_Item_Name>
<Item_Number> ::= <Simple_Value_Specification>
<Simple_Target_Specification_1> ::= <Simple_Target_Specification>
<Simple_Target_Specification_2> ::= <Simple_Target_Specification>
<Descriptor_Item_Name> ::= <CARDINALITY>
                         | <Lex078>
                         | <Lex079>
                         | <Lex080>
                         | <Lex088>
                         | <Lex089>
                         | <Lex090>
                         | <DATA>
                         | <Lex114>
                         | <Lex115>
                         | <DEGREE>
                         | <INDICATOR>
                         | <Lex161>
                         | <LENGTH>
                         | <LEVEL>
                         | <NAME>
                         | <NULLABLE>
                         | <Lex193>
                         | <Lex202>
                         | <Lex204>
                         | <Lex205>
                         | <Lex206>
                         | <Lex207>
                         | <PRECISION>
                         | <Lex228>
                         | <Lex229>
                         | <Lex230>
                         | <SCALE>
                         | <Lex242>
                         | <Lex243>
                         | <Lex244>
                         | <TYPE>
                         | <UNNAMED>
                         | <Lex290>
                         | <Lex292>
                         | <Lex293>
                         | <Lex291>
<Set_Descriptor_Statement> ::= <SET> <SQL_maybe> <DESCRIPTOR> <Descriptor_Name> <Set_Descriptor_Information>
<Gen3300> ::= <Comma> <Set_Header_Information>
<Gen3300_any> ::= <Gen3300>*
<Gen3302> ::= <Comma> <Set_Item_Information>
<Gen3302_any> ::= <Gen3302>*
<Set_Descriptor_Information> ::= <Set_Header_Information> <Gen3300_any>
                               | <VALUE> <Item_Number> <Set_Item_Information> <Gen3302_any>
<Set_Header_Information> ::= <Header_Item_Name> <Equals_Operator> <Simple_Value_Specification_1>
<Set_Item_Information> ::= <Descriptor_Item_Name> <Equals_Operator> <Simple_Value_Specification_2>
<Simple_Value_Specification_1> ::= <Simple_Value_Specification>
<Simple_Value_Specification_2> ::= <Simple_Value_Specification>
<Attributes_Specification_maybe> ::= <Attributes_Specification>
<Attributes_Specification_maybe> ::=
<Prepare_Statement> ::= <PREPARE> <SQL_Statement_Name> <Attributes_Specification_maybe> <FROM> <SQL_Statement_Variable>
<Attributes_Specification> ::= <ATTRIBUTES> <Attributes_Variable>
<Attributes_Variable> ::= <Simple_Value_Specification>
<SQL_Statement_Variable> ::= <Simple_Value_Specification>
<Preparable_Statement> ::= <Preparable_SQL_Data_Statement>
                         | <Preparable_SQL_Schema_Statement>
                         | <Preparable_SQL_Transaction_Statement>
                         | <Preparable_SQL_Control_Statement>
                         | <Preparable_SQL_Session_Statement>
<Preparable_SQL_Data_Statement> ::= <Delete_Statement_Searched>
                                  | <Dynamic_Single_Row_Select_Statement>
                                  | <Insert_Statement>
                                  | <Dynamic_Select_Statement>
                                  | <Update_Statement_Searched>
                                  | <Merge_Statement>
                                  | <Preparable_Dynamic_Delete_Statement_Positioned>
                                  | <Preparable_Dynamic_Update_Statement_Positioned>
<Preparable_SQL_Schema_Statement> ::= <SQL_Schema_Statement>
<Preparable_SQL_Transaction_Statement> ::= <SQL_Transaction_Statement>
<Preparable_SQL_Control_Statement> ::= <SQL_Control_Statement>
<Preparable_SQL_Session_Statement> ::= <SQL_Session_Statement>
<Dynamic_Select_Statement> ::= <Cursor_Specification>
<Cursor_Attribute_many> ::= <Cursor_Attribute>+
<Cursor_Attributes> ::= <Cursor_Attribute_many>
<Cursor_Attribute> ::= <Cursor_Sensitivity>
                     | <Cursor_Scrollability>
                     | <Cursor_Holdability>
                     | <Cursor_Returnability>
<Deallocate_Prepared_Statement> ::= <DEALLOCATE> <PREPARE> <SQL_Statement_Name>
<Describe_Statement> ::= <Describe_Input_Statement>
                       | <Describe_Output_Statement>
<Nesting_Option_maybe> ::= <Nesting_Option>
<Nesting_Option_maybe> ::=
<Describe_Input_Statement> ::= <DESCRIBE> <INPUT> <SQL_Statement_Name> <Using_Descriptor> <Nesting_Option_maybe>
<OUTPUT_maybe> ::= <OUTPUT>
<OUTPUT_maybe> ::=
<Describe_Output_Statement> ::= <DESCRIBE> <OUTPUT_maybe> <Described_Object> <Using_Descriptor> <Nesting_Option_maybe>
<Nesting_Option> ::= <WITH> <NESTING>
                   | <WITHOUT> <NESTING>
<Using_Descriptor> ::= <USING> <SQL_maybe> <DESCRIPTOR> <Descriptor_Name>
<Described_Object> ::= <SQL_Statement_Name>
                     | <CURSOR> <Extended_Cursor_Name> <STRUCTURE>
<Input_Using_Clause> ::= <Using_Arguments>
                       | <Using_Input_Descriptor>
<Gen3356> ::= <Comma> <Using_Argument>
<Gen3356_any> ::= <Gen3356>*
<Using_Arguments> ::= <USING> <Using_Argument> <Gen3356_any>
<Using_Argument> ::= <General_Value_Specification>
<Using_Input_Descriptor> ::= <Using_Descriptor>
<Output_Using_Clause> ::= <Into_Arguments>
                        | <Into_Descriptor>
<Gen3363> ::= <Comma> <Into_Argument>
<Gen3363_any> ::= <Gen3363>*
<Into_Arguments> ::= <INTO> <Into_Argument> <Gen3363_any>
<Into_Argument> ::= <Target_Specification>
<Into_Descriptor> ::= <INTO> <SQL_maybe> <DESCRIPTOR> <Descriptor_Name>
<Result_Using_Clause_maybe> ::= <Result_Using_Clause>
<Result_Using_Clause_maybe> ::=
<Parameter_Using_Clause_maybe> ::= <Parameter_Using_Clause>
<Parameter_Using_Clause_maybe> ::=
<Execute_Statement> ::= <EXECUTE> <SQL_Statement_Name> <Result_Using_Clause_maybe> <Parameter_Using_Clause_maybe>
<Result_Using_Clause> ::= <Output_Using_Clause>
<Parameter_Using_Clause> ::= <Input_Using_Clause>
<Execute_Immediate_Statement> ::= <EXECUTE> <IMMEDIATE> <SQL_Statement_Variable>
<Dynamic_Declare_Cursor> ::= <DECLARE> <Cursor_Name> <Cursor_Sensitivity_maybe> <Cursor_Scrollability_maybe> <CURSOR> <Cursor_Holdability_maybe> <Cursor_Returnability_maybe> <FOR> <Statement_Name>
<Allocate_Cursor_Statement> ::= <ALLOCATE> <Extended_Cursor_Name> <Cursor_Intent>
<Cursor_Intent> ::= <Statement_Cursor>
                  | <Result_Set_Cursor>
<Statement_Cursor> ::= <Cursor_Sensitivity_maybe> <Cursor_Scrollability_maybe> <CURSOR> <Cursor_Holdability_maybe> <Cursor_Returnability_maybe> <FOR> <Extended_Statement_Name>
<Result_Set_Cursor> ::= <FOR> <PROCEDURE> <Specific_Routine_Designator>
<Input_Using_Clause_maybe> ::= <Input_Using_Clause>
<Input_Using_Clause_maybe> ::=
<Dynamic_Open_Statement> ::= <OPEN> <Dynamic_Cursor_Name> <Input_Using_Clause_maybe>
<Gen3385> ::= <Fetch_Orientation_maybe> <FROM>
<Gen3385_maybe> ::= <Gen3385>
<Gen3385_maybe> ::=
<Dynamic_Fetch_Statement> ::= <FETCH> <Gen3385_maybe> <Dynamic_Cursor_Name> <Output_Using_Clause>
<Dynamic_Single_Row_Select_Statement> ::= <Query_Specification>
<Dynamic_Close_Statement> ::= <CLOSE> <Dynamic_Cursor_Name>
<Dynamic_Delete_Statement_Positioned> ::= <DELETE> <FROM> <Target_Table> <WHERE> <CURRENT> <OF> <Dynamic_Cursor_Name>
<Dynamic_Update_Statement_Positioned> ::= <UPDATE> <Target_Table> <SET> <Set_Clause_List> <WHERE> <CURRENT> <OF> <Dynamic_Cursor_Name>
<Gen3393> ::= <FROM> <Target_Table>
<Gen3393_maybe> ::= <Gen3393>
<Gen3393_maybe> ::=
<Preparable_Dynamic_Delete_Statement_Positioned> ::= <DELETE> <Gen3393_maybe> <WHERE> <CURRENT> <OF> <Scope_Option_maybe> <Cursor_Name>
<Target_Table_maybe> ::= <Target_Table>
<Target_Table_maybe> ::=
<Preparable_Dynamic_Update_Statement_Positioned> ::= <UPDATE> <Target_Table_maybe> <SET> <Set_Clause_List> <WHERE> <CURRENT> <OF> <Scope_Option_maybe> <Cursor_Name>
<Embedded_SQL_Host_Program> ::= <Embedded_SQL_Ada_Program>
                              | <Embedded_SQL_C_Program>
                              | <Embedded_SQL_Cobol_Program>
                              | <Embedded_SQL_Fortran_Program>
                              | <Embedded_SQL_Mumps_Program>
                              | <Embedded_SQL_Pascal_Program>
                              | <Embedded_SQL_Pl_I_Program>
<SQL_Terminator_maybe> ::= <SQL_Terminator>
<SQL_Terminator_maybe> ::=
<Embedded_SQL_Statement> ::= <SQL_Prefix> <Statement_Or_Declaration> <SQL_Terminator_maybe>
<Statement_Or_Declaration> ::= <Declare_Cursor>
                             | <Dynamic_Declare_Cursor>
                             | <Temporary_Table_Declaration>
                             | <Embedded_Authorization_Declaration>
                             | <Embedded_Path_Specification>
                             | <Embedded_Transform_Group_Specification>
                             | <Embedded_Collation_Specification>
                             | <Embedded_Exception_Declaration>
                             | <SQL_Procedure_Statement>
<SQL_Prefix> ::= <EXEC> <SQL>
               | <Ampersand> <SQL> <Left_Paren>
<SQL_Terminator> ::= <Lex371>
                   | <Semicolon>
                   | <Right_Paren>
<Embedded_Authorization_Declaration> ::= <DECLARE> <Embedded_Authorization_Clause>
<Gen3425> ::= <ONLY>
            | <AND> <DYNAMIC>
<Gen3427> ::= <FOR> <STATIC> <Gen3425>
<Gen3427_maybe> ::= <Gen3427>
<Gen3427_maybe> ::=
<Gen3430> ::= <ONLY>
            | <AND> <DYNAMIC>
<Gen3432> ::= <FOR> <STATIC> <Gen3430>
<Gen3432_maybe> ::= <Gen3432>
<Gen3432_maybe> ::=
<Embedded_Authorization_Clause> ::= <SCHEMA> <Schema_Name>
                                  | <AUTHORIZATION> <Embedded_Authorization_Identifier> <Gen3427_maybe>
                                  | <SCHEMA> <Schema_Name> <AUTHORIZATION> <Embedded_Authorization_Identifier> <Gen3432_maybe>
<Embedded_Authorization_Identifier> ::= <Module_Authorization_Identifier>
<Embedded_Path_Specification> ::= <Path_Specification>
<Embedded_Transform_Group_Specification> ::= <Transform_Group_Specification>
<Embedded_Collation_Specification> ::= <Module_Collations>
<Embedded_Character_Set_Declaration_maybe> ::= <Embedded_Character_Set_Declaration>
<Embedded_Character_Set_Declaration_maybe> ::=
<Host_Variable_Definition_any> ::= <Host_Variable_Definition>*
<Embedded_SQL_Declare_Section> ::= <Embedded_SQL_Begin_Declare> <Embedded_Character_Set_Declaration_maybe> <Host_Variable_Definition_any> <Embedded_SQL_End_Declare>
                                 | <Embedded_SQL_Mumps_Declare>
<Embedded_Character_Set_Declaration> ::= <SQL> <NAMES> <ARE> <Character_Set_Specification>
<Embedded_SQL_Begin_Declare> ::= <SQL_Prefix> <BEGIN> <DECLARE> <SECTION> <SQL_Terminator_maybe>
<Embedded_SQL_End_Declare> ::= <SQL_Prefix> <END> <DECLARE> <SECTION> <SQL_Terminator_maybe>
<Embedded_SQL_Mumps_Declare> ::= <SQL_Prefix> <BEGIN> <DECLARE> <SECTION> <Embedded_Character_Set_Declaration_maybe> <Host_Variable_Definition_any> <END> <DECLARE> <SECTION> <SQL_Terminator>
<Host_Variable_Definition> ::= <Ada_Variable_Definition>
                             | <C_Variable_Definition>
                             | <Cobol_Variable_Definition>
                             | <Fortran_Variable_Definition>
                             | <Mumps_Variable_Definition>
                             | <Pascal_Variable_Definition>
                             | <Pl_I_Variable_Definition>
<Embedded_Variable_Name> ::= <Colon> <Host_Identifier>
<Host_Identifier> ::= <Ada_Host_Identifier>
                    | <C_Host_Identifier>
                    | <Cobol_Host_Identifier>
                    | <Fortran_Host_Identifier>
                    | <Mumps_Host_Identifier>
                    | <Pascal_Host_Identifier>
                    | <Pl_I_Host_Identifier>
<Embedded_Exception_Declaration> ::= <WHENEVER> <Condition> <Condition_Action>
<Condition> ::= <SQL_Condition>
<Gen3468> ::= <Lex013> <Sqlstate_Subclass_Value>
<Gen3468_maybe> ::= <Gen3468>
<Gen3468_maybe> ::=
<Gen3471> ::= <Sqlstate_Class_Value> <Gen3468_maybe>
<SQL_Condition> ::= <Major_Category>
                  | <SQLSTATE> <Gen3471>
                  | <CONSTRAINT> <Constraint_Name>
<Major_Category> ::= <SQLEXCEPTION>
                   | <SQLWARNING>
                   | <NOT> <FOUND>
<Sqlstate_Class_Value> ::= <Sqlstate_Char> <Sqlstate_Char>
<Sqlstate_Subclass_Value> ::= <Sqlstate_Char> <Sqlstate_Char> <Sqlstate_Char>
<Sqlstate_Char> ::= <Simple_Latin_Upper_Case_Letter>
                  | <Digit>
<Condition_Action> ::= <CONTINUE>
                     | <Go_To>
<Gen3484> ::= <GOTO>
            | <GO> <TO>
<Go_To> ::= <Gen3484> <Goto_Target>
<Goto_Target> ::= <Unsigned_Integer>
<Embedded_SQL_Ada_Program> ::= <EXEC> <SQL>
<Gen3489> ::= <Comma> <Ada_Host_Identifier>
<Gen3489_any> ::= <Gen3489>*
<Ada_Initial_Value_maybe> ::= <Ada_Initial_Value>
<Ada_Initial_Value_maybe> ::=
<Ada_Variable_Definition> ::= <Ada_Host_Identifier> <Gen3489_any> <Colon> <Ada_Type_Specification> <Ada_Initial_Value_maybe>
<Character_Representation_many> ::= <Character_Representation>+
<Ada_Initial_Value> ::= <Ada_Assignment_Operator> <Character_Representation_many>
<Ada_Assignment_Operator> ::= <Colon> <Equals_Operator>
<Ada_Host_Identifier> ::= <Lex568_many>
<Ada_Type_Specification> ::= <Ada_Qualified_Type_Specification>
                           | <Ada_Unqualified_Type_Specification>
                           | <Ada_Derived_Type_Specification>
<IS_maybe> ::= <IS>
<IS_maybe> ::=
<Gen3503> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3503_maybe> ::= <Gen3503>
<Gen3503_maybe> ::=
<Ada_Qualified_Type_Specification> ::= <Lex569> <Period> <CHAR> <Gen3503_maybe> <Left_Paren> <Lex570> <Double_Period> <Length> <Right_Paren>
                                     | <Lex569> <Period> <SMALLINT>
                                     | <Lex569> <Period> <INT>
                                     | <Lex569> <Period> <BIGINT>
                                     | <Lex569> <Period> <REAL>
                                     | <Lex569> <Period> <Lex571>
                                     | <Lex569> <Period> <BOOLEAN>
                                     | <Lex569> <Period> <Lex572>
                                     | <Lex569> <Period> <Lex573>
<Ada_Unqualified_Type_Specification> ::= <CHAR> <Left_Paren> <Lex570> <Double_Period> <Length> <Right_Paren>
                                       | <SMALLINT>
                                       | <INT>
                                       | <BIGINT>
                                       | <REAL>
                                       | <Lex571>
                                       | <BOOLEAN>
                                       | <Lex572>
                                       | <Lex573>
<Ada_Derived_Type_Specification> ::= <Ada_Clob_Variable>
                                   | <Ada_Clob_Locator_Variable>
                                   | <Ada_Blob_Variable>
                                   | <Ada_Blob_Locator_Variable>
                                   | <Ada_User_Defined_Type_Variable>
                                   | <Ada_User_Defined_Type_Locator_Variable>
                                   | <Ada_Ref_Variable>
                                   | <Ada_Array_Locator_Variable>
                                   | <Ada_Multiset_Locator_Variable>
<Gen3533> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3533_maybe> ::= <Gen3533>
<Gen3533_maybe> ::=
<Ada_Clob_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3533_maybe>
<Ada_Clob_Locator_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <AS> <LOCATOR>
<Ada_Blob_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <Left_Paren> <Large_Object_Length> <Right_Paren>
<Ada_Blob_Locator_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <AS> <LOCATOR>
<Ada_User_Defined_Type_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <Predefined_Type>
<Ada_User_Defined_Type_Locator_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <LOCATOR>
<Ada_Ref_Variable> ::= <SQL> <TYPE> <IS> <Reference_Type>
<Ada_Array_Locator_Variable> ::= <SQL> <TYPE> <IS> <Array_Type> <AS> <LOCATOR>
<Ada_Multiset_Locator_Variable> ::= <SQL> <TYPE> <IS> <Multiset_Type> <AS> <LOCATOR>
<Embedded_SQL_C_Program> ::= <EXEC> <SQL>
<C_Storage_Class_maybe> ::= <C_Storage_Class>
<C_Storage_Class_maybe> ::=
<C_Class_Modifier_maybe> ::= <C_Class_Modifier>
<C_Class_Modifier_maybe> ::=
<C_Variable_Definition> ::= <C_Storage_Class_maybe> <C_Class_Modifier_maybe> <C_Variable_Specification> <Semicolon>
<C_Variable_Specification> ::= <C_Numeric_Variable>
                             | <C_Character_Variable>
                             | <C_Derived_Variable>
<C_Storage_Class> ::= <auto>
                    | <extern>
                    | <static>
<C_Class_Modifier> ::= <const>
                     | <volatile>
<Gen3559> ::= <long> <long>
            | <long>
            | <short>
            | <float>
            | <double>
<C_Initial_Value_maybe> ::= <C_Initial_Value>
<C_Initial_Value_maybe> ::=
<Gen3566> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3566_any> ::= <Gen3566>*
<C_Numeric_Variable> ::= <Gen3559> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3566_any>
<Gen3569> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3569_maybe> ::= <Gen3569>
<Gen3569_maybe> ::=
<Gen3572> ::= <Comma> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe>
<Gen3572_any> ::= <Gen3572>*
<C_Character_Variable> ::= <C_Character_Type> <Gen3569_maybe> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> <Gen3572_any>
<C_Character_Type> ::= <char>
                     | <unsigned> <char>
                     | <unsigned> <short>
<C_Array_Specification> ::= <Left_Bracket> <Length> <Right_Bracket>
<C_Host_Identifier> ::= <Lex585_many>
<C_Derived_Variable> ::= <C_Varchar_Variable>
                       | <C_Nchar_Variable>
                       | <C_Nchar_Varying_Variable>
                       | <C_Clob_Variable>
                       | <C_Nclob_Variable>
                       | <C_Blob_Variable>
                       | <C_User_Defined_Type_Variable>
                       | <C_Clob_Locator_Variable>
                       | <C_Blob_Locator_Variable>
                       | <C_Array_Locator_Variable>
                       | <C_Multiset_Locator_Variable>
                       | <C_User_Defined_Type_Locator_Variable>
                       | <C_Ref_Variable>
<Gen3593> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3593_maybe> ::= <Gen3593>
<Gen3593_maybe> ::=
<Gen3596> ::= <Comma> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe>
<Gen3596_any> ::= <Gen3596>*
<C_Varchar_Variable> ::= <VARCHAR> <Gen3593_maybe> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> <Gen3596_any>
<Gen3599> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3599_maybe> ::= <Gen3599>
<Gen3599_maybe> ::=
<Gen3602> ::= <Comma> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe>
<Gen3602_any> ::= <Gen3602>*
<C_Nchar_Variable> ::= <NCHAR> <Gen3599_maybe> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> <Gen3602_any>
<Gen3605> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3605_maybe> ::= <Gen3605>
<Gen3605_maybe> ::=
<Gen3608> ::= <Comma> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe>
<Gen3608_any> ::= <Gen3608>*
<C_Nchar_Varying_Variable> ::= <NCHAR> <VARYING> <Gen3605_maybe> <C_Host_Identifier> <C_Array_Specification> <C_Initial_Value_maybe> <Gen3608_any>
<Gen3611> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3611_maybe> ::= <Gen3611>
<Gen3611_maybe> ::=
<Gen3614> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3614_any> ::= <Gen3614>*
<C_Clob_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3611_maybe> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3614_any>
<Gen3617> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3617_maybe> ::= <Gen3617>
<Gen3617_maybe> ::=
<Gen3620> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3620_any> ::= <Gen3620>*
<C_Nclob_Variable> ::= <SQL> <TYPE> <IS> <NCLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3617_maybe> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3620_any>
<Gen3623> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3623_any> ::= <Gen3623>*
<C_User_Defined_Type_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <Predefined_Type> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3623_any>
<Gen3626> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3626_any> ::= <Gen3626>*
<C_Blob_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3626_any>
<Gen3629> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3629_any> ::= <Gen3629>*
<C_Clob_Locator_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <AS> <LOCATOR> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3629_any>
<Gen3632> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3632_any> ::= <Gen3632>*
<C_Blob_Locator_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <AS> <LOCATOR> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3632_any>
<Gen3635> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3635_any> ::= <Gen3635>*
<C_Array_Locator_Variable> ::= <SQL> <TYPE> <IS> <Array_Type> <AS> <LOCATOR> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3635_any>
<Gen3638> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3638_any> ::= <Gen3638>*
<C_Multiset_Locator_Variable> ::= <SQL> <TYPE> <IS> <Multiset_Type> <AS> <LOCATOR> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3638_any>
<Gen3641> ::= <Comma> <C_Host_Identifier> <C_Initial_Value_maybe>
<Gen3641_any> ::= <Gen3641>*
<C_User_Defined_Type_Locator_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <LOCATOR> <C_Host_Identifier> <C_Initial_Value_maybe> <Gen3641_any>
<C_Ref_Variable> ::= <SQL> <TYPE> <IS> <Reference_Type>
<C_Initial_Value> ::= <Equals_Operator> <Character_Representation_many>
<Embedded_SQL_Cobol_Program> ::= <EXEC> <SQL>
<Cobol_Host_Identifier> ::= <Lex586_many>
<Gen3648> ::= <Lex587>
            | <Lex588>
<Cobol_Variable_Definition> ::= <Gen3648> <Cobol_Host_Identifier> <Cobol_Type_Specification> <Character_Representation_any> <Period>
<Cobol_Type_Specification> ::= <Cobol_Character_Type>
                             | <Cobol_National_Character_Type>
                             | <Cobol_Numeric_Type>
                             | <Cobol_Integer_Type>
                             | <Cobol_Derived_Type_Specification>
<Cobol_Derived_Type_Specification> ::= <Cobol_Clob_Variable>
                                     | <Cobol_Nclob_Variable>
                                     | <Cobol_Blob_Variable>
                                     | <Cobol_User_Defined_Type_Variable>
                                     | <Cobol_Clob_Locator_Variable>
                                     | <Cobol_Blob_Locator_Variable>
                                     | <Cobol_Array_Locator_Variable>
                                     | <Cobol_Multiset_Locator_Variable>
                                     | <Cobol_User_Defined_Type_Locator_Variable>
                                     | <Cobol_Ref_Variable>
<Gen3666> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3666_maybe> ::= <Gen3666>
<Gen3666_maybe> ::=
<Gen3669> ::= <PIC>
            | <PICTURE>
<Gen3671> ::= <Left_Paren> <Length> <Right_Paren>
<Gen3671_maybe> ::= <Gen3671>
<Gen3671_maybe> ::=
<Gen3674> ::= <X> <Gen3671_maybe>
<Gen3674_many> ::= <Gen3674>+
<Cobol_Character_Type> ::= <Gen3666_maybe> <Gen3669> <IS_maybe> <Gen3674_many>
<Gen3677> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3677_maybe> ::= <Gen3677>
<Gen3677_maybe> ::=
<Gen3680> ::= <PIC>
            | <PICTURE>
<Gen3682> ::= <Left_Paren> <Length> <Right_Paren>
<Gen3682_maybe> ::= <Gen3682>
<Gen3682_maybe> ::=
<Gen3685> ::= <N> <Gen3682_maybe>
<Gen3685_many> ::= <Gen3685>+
<Cobol_National_Character_Type> ::= <Gen3677_maybe> <Gen3680> <IS_maybe> <Gen3685_many>
<Gen3688> ::= <USAGE> <IS_maybe>
<Gen3688_maybe> ::= <Gen3688>
<Gen3688_maybe> ::=
<Gen3691> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3691_maybe> ::= <Gen3691>
<Gen3691_maybe> ::=
<Cobol_Clob_Variable> ::= <Gen3688_maybe> <SQL> <TYPE> <IS> <CLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3691_maybe>
<Gen3695> ::= <USAGE> <IS_maybe>
<Gen3695_maybe> ::= <Gen3695>
<Gen3695_maybe> ::=
<Gen3698> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3698_maybe> ::= <Gen3698>
<Gen3698_maybe> ::=
<Cobol_Nclob_Variable> ::= <Gen3695_maybe> <SQL> <TYPE> <IS> <NCLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3698_maybe>
<Gen3702> ::= <USAGE> <IS_maybe>
<Gen3702_maybe> ::= <Gen3702>
<Gen3702_maybe> ::=
<Cobol_Blob_Variable> ::= <Gen3702_maybe> <SQL> <TYPE> <IS> <BLOB> <Left_Paren> <Large_Object_Length> <Right_Paren>
<Gen3706> ::= <USAGE> <IS_maybe>
<Gen3706_maybe> ::= <Gen3706>
<Gen3706_maybe> ::=
<Cobol_User_Defined_Type_Variable> ::= <Gen3706_maybe> <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <Predefined_Type>
<Gen3710> ::= <USAGE> <IS_maybe>
<Gen3710_maybe> ::= <Gen3710>
<Gen3710_maybe> ::=
<Cobol_Clob_Locator_Variable> ::= <Gen3710_maybe> <SQL> <TYPE> <IS> <CLOB> <AS> <LOCATOR>
<Gen3714> ::= <USAGE> <IS_maybe>
<Gen3714_maybe> ::= <Gen3714>
<Gen3714_maybe> ::=
<Cobol_Blob_Locator_Variable> ::= <Gen3714_maybe> <SQL> <TYPE> <IS> <BLOB> <AS> <LOCATOR>
<Gen3718> ::= <USAGE> <IS_maybe>
<Gen3718_maybe> ::= <Gen3718>
<Gen3718_maybe> ::=
<Cobol_Array_Locator_Variable> ::= <Gen3718_maybe> <SQL> <TYPE> <IS> <Array_Type> <AS> <LOCATOR>
<Gen3722> ::= <USAGE> <IS_maybe>
<Gen3722_maybe> ::= <Gen3722>
<Gen3722_maybe> ::=
<Cobol_Multiset_Locator_Variable> ::= <Gen3722_maybe> <SQL> <TYPE> <IS> <Multiset_Type> <AS> <LOCATOR>
<Gen3726> ::= <USAGE> <IS_maybe>
<Gen3726_maybe> ::= <Gen3726>
<Gen3726_maybe> ::=
<Cobol_User_Defined_Type_Locator_Variable> ::= <Gen3726_maybe> <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <LOCATOR>
<Gen3730> ::= <USAGE> <IS_maybe>
<Gen3730_maybe> ::= <Gen3730>
<Gen3730_maybe> ::=
<Cobol_Ref_Variable> ::= <Gen3730_maybe> <SQL> <TYPE> <IS> <Reference_Type>
<Gen3734> ::= <PIC>
            | <PICTURE>
<Gen3736> ::= <USAGE> <IS_maybe>
<Gen3736_maybe> ::= <Gen3736>
<Gen3736_maybe> ::=
<Cobol_Numeric_Type> ::= <Gen3734> <IS_maybe> <S> <Cobol_Nines_Specification> <Gen3736_maybe> <DISPLAY> <SIGN> <LEADING> <SEPARATE>
<Cobol_Nines_maybe> ::= <Cobol_Nines>
<Cobol_Nines_maybe> ::=
<Gen3742> ::= <V> <Cobol_Nines_maybe>
<Gen3742_maybe> ::= <Gen3742>
<Gen3742_maybe> ::=
<Cobol_Nines_Specification> ::= <Cobol_Nines> <Gen3742_maybe>
                              | <V> <Cobol_Nines>
<Cobol_Integer_Type> ::= <Cobol_Binary_Integer>
<Gen3748> ::= <PIC>
            | <PICTURE>
<Gen3750> ::= <USAGE> <IS_maybe>
<Gen3750_maybe> ::= <Gen3750>
<Gen3750_maybe> ::=
<Cobol_Binary_Integer> ::= <Gen3748> <IS_maybe> <S> <Cobol_Nines> <Gen3750_maybe> <BINARY>
<Gen3754> ::= <Left_Paren> <Length> <Right_Paren>
<Gen3754_maybe> ::= <Gen3754>
<Gen3754_maybe> ::=
<Gen3757> ::= <Lex596> <Gen3754_maybe>
<Gen3757_many> ::= <Gen3757>+
<Cobol_Nines> ::= <Gen3757_many>
<Embedded_SQL_Fortran_Program> ::= <EXEC> <SQL>
<Fortran_Host_Identifier> ::= <Lex597_many>
<Gen3762> ::= <Comma> <Fortran_Host_Identifier>
<Gen3762_any> ::= <Gen3762>*
<Fortran_Variable_Definition> ::= <Fortran_Type_Specification> <Fortran_Host_Identifier> <Gen3762_any>
<Gen3765> ::= <Asterisk> <Length>
<Gen3765_maybe> ::= <Gen3765>
<Gen3765_maybe> ::=
<Gen3768> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3768_maybe> ::= <Gen3768>
<Gen3768_maybe> ::=
<Gen3771> ::= <Lex003_many>
<Gen3771> ::=
<Gen3773> ::= <Asterisk> <Length>
<Gen3773_maybe> ::= <Gen3773>
<Gen3773_maybe> ::=
<Gen3776> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3776_maybe> ::= <Gen3776>
<Gen3776_maybe> ::=
<Fortran_Type_Specification> ::= <CHARACTER> <Gen3765_maybe> <Gen3768_maybe>
                               | <CHARACTER> <KIND> <Lex020> <Lex003> <Gen3771> <Gen3773_maybe> <Gen3776_maybe>
                               | <INTEGER>
                               | <REAL>
                               | <DOUBLE> <PRECISION>
                               | <LOGICAL>
                               | <Fortran_Derived_Type_Specification>
<Fortran_Derived_Type_Specification> ::= <Fortran_Clob_Variable>
                                       | <Fortran_Blob_Variable>
                                       | <Fortran_User_Defined_Type_Variable>
                                       | <Fortran_Clob_Locator_Variable>
                                       | <Fortran_Blob_Locator_Variable>
                                       | <Fortran_User_Defined_Type_Locator_Variable>
                                       | <Fortran_Array_Locator_Variable>
                                       | <Fortran_Multiset_Locator_Variable>
                                       | <Fortran_Ref_Variable>
<Gen3795> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3795_maybe> ::= <Gen3795>
<Gen3795_maybe> ::=
<Fortran_Clob_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3795_maybe>
<Fortran_Blob_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <Left_Paren> <Large_Object_Length> <Right_Paren>
<Fortran_User_Defined_Type_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <Predefined_Type>
<Fortran_Clob_Locator_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <AS> <LOCATOR>
<Fortran_Blob_Locator_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <AS> <LOCATOR>
<Fortran_User_Defined_Type_Locator_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <LOCATOR>
<Fortran_Array_Locator_Variable> ::= <SQL> <TYPE> <IS> <Array_Type> <AS> <LOCATOR>
<Fortran_Multiset_Locator_Variable> ::= <SQL> <TYPE> <IS> <Multiset_Type> <AS> <LOCATOR>
<Fortran_Ref_Variable> ::= <SQL> <TYPE> <IS> <Reference_Type>
<Embedded_SQL_Mumps_Program> ::= <EXEC> <SQL>
<Mumps_Variable_Definition> ::= <Mumps_Numeric_Variable> <Semicolon>
                              | <Mumps_Character_Variable> <Semicolon>
                              | <Mumps_Derived_Type_Specification> <Semicolon>
<Mumps_Host_Identifier> ::= <Lex601_many>
<Gen3812> ::= <Comma> <Mumps_Host_Identifier> <Mumps_Length_Specification>
<Gen3812_any> ::= <Gen3812>*
<Mumps_Character_Variable> ::= <VARCHAR> <Mumps_Host_Identifier> <Mumps_Length_Specification> <Gen3812_any>
<Mumps_Length_Specification> ::= <Left_Paren> <Length> <Right_Paren>
<Gen3816> ::= <Comma> <Mumps_Host_Identifier>
<Gen3816_any> ::= <Gen3816>*
<Mumps_Numeric_Variable> ::= <Mumps_Type_Specification> <Mumps_Host_Identifier> <Gen3816_any>
<Gen3819> ::= <Comma> <Scale>
<Gen3819_maybe> ::= <Gen3819>
<Gen3819_maybe> ::=
<Gen3822> ::= <Left_Paren> <Precision> <Gen3819_maybe> <Right_Paren>
<Gen3822_maybe> ::= <Gen3822>
<Gen3822_maybe> ::=
<Mumps_Type_Specification> ::= <INT>
                             | <DEC> <Gen3822_maybe>
                             | <REAL>
<Mumps_Derived_Type_Specification> ::= <Mumps_Clob_Variable>
                                     | <Mumps_Blob_Variable>
                                     | <Mumps_User_Defined_Type_Variable>
                                     | <Mumps_Clob_Locator_Variable>
                                     | <Mumps_Blob_Locator_Variable>
                                     | <Mumps_User_Defined_Type_Locator_Variable>
                                     | <Mumps_Array_Locator_Variable>
                                     | <Mumps_Multiset_Locator_Variable>
                                     | <Mumps_Ref_Variable>
<Gen3837> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3837_maybe> ::= <Gen3837>
<Gen3837_maybe> ::=
<Mumps_Clob_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3837_maybe>
<Mumps_Blob_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <Left_Paren> <Large_Object_Length> <Right_Paren>
<Mumps_User_Defined_Type_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <Predefined_Type>
<Mumps_Clob_Locator_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <AS> <LOCATOR>
<Mumps_Blob_Locator_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <AS> <LOCATOR>
<Mumps_User_Defined_Type_Locator_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <LOCATOR>
<Mumps_Array_Locator_Variable> ::= <SQL> <TYPE> <IS> <Array_Type> <AS> <LOCATOR>
<Mumps_Multiset_Locator_Variable> ::= <SQL> <TYPE> <IS> <Multiset_Type> <AS> <LOCATOR>
<Mumps_Ref_Variable> ::= <SQL> <TYPE> <IS> <Reference_Type>
<Embedded_SQL_Pascal_Program> ::= <EXEC> <SQL>
<Pascal_Host_Identifier> ::= <Lex602_many>
<Gen3851> ::= <Comma> <Pascal_Host_Identifier>
<Gen3851_any> ::= <Gen3851>*
<Pascal_Variable_Definition> ::= <Pascal_Host_Identifier> <Gen3851_any> <Colon> <Pascal_Type_Specification> <Semicolon>
<Gen3854> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3854_maybe> ::= <Gen3854>
<Gen3854_maybe> ::=
<Gen3857> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3857_maybe> ::= <Gen3857>
<Gen3857_maybe> ::=
<Pascal_Type_Specification> ::= <PACKED> <ARRAY> <Left_Bracket> <Lex570> <Double_Period> <Length> <Right_Bracket> <OF> <CHAR> <Gen3854_maybe>
                              | <INTEGER>
                              | <REAL>
                              | <CHAR> <Gen3857_maybe>
                              | <BOOLEAN>
                              | <Pascal_Derived_Type_Specification>
<Pascal_Derived_Type_Specification> ::= <Pascal_Clob_Variable>
                                      | <Pascal_Blob_Variable>
                                      | <Pascal_User_Defined_Type_Variable>
                                      | <Pascal_Clob_Locator_Variable>
                                      | <Pascal_Blob_Locator_Variable>
                                      | <Pascal_User_Defined_Type_Locator_Variable>
                                      | <Pascal_Array_Locator_Variable>
                                      | <Pascal_Multiset_Locator_Variable>
                                      | <Pascal_Ref_Variable>
<Gen3875> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3875_maybe> ::= <Gen3875>
<Gen3875_maybe> ::=
<Pascal_Clob_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3875_maybe>
<Pascal_Blob_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <Left_Paren> <Large_Object_Length> <Right_Paren>
<Pascal_Clob_Locator_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <AS> <LOCATOR>
<Pascal_User_Defined_Type_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <Predefined_Type>
<Pascal_Blob_Locator_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <AS> <LOCATOR>
<Pascal_User_Defined_Type_Locator_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <LOCATOR>
<Pascal_Array_Locator_Variable> ::= <SQL> <TYPE> <IS> <Array_Type> <AS> <LOCATOR>
<Pascal_Multiset_Locator_Variable> ::= <SQL> <TYPE> <IS> <Multiset_Type> <AS> <LOCATOR>
<Pascal_Ref_Variable> ::= <SQL> <TYPE> <IS> <Reference_Type>
<Embedded_SQL_Pl_I_Program> ::= <EXEC> <SQL>
<Pl_I_Host_Identifier> ::= <Lex604_many>
<Gen3889> ::= <DCL>
            | <DECLARE>
<Gen3891> ::= <Comma> <Pl_I_Host_Identifier>
<Gen3891_any> ::= <Gen3891>*
<Pl_I_Variable_Definition> ::= <Gen3889> <Pl_I_Host_Identifier> <Left_Paren> <Pl_I_Host_Identifier> <Gen3891_any> <Right_Paren> <Pl_I_Type_Specification> <Character_Representation_any> <Semicolon>
<Gen3894> ::= <CHAR>
            | <CHARACTER>
<VARYING_maybe> ::= <VARYING>
<VARYING_maybe> ::=
<Gen3898> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3898_maybe> ::= <Gen3898>
<Gen3898_maybe> ::=
<Gen3901> ::= <Comma> <Scale>
<Gen3901_maybe> ::= <Gen3901>
<Gen3901_maybe> ::=
<Gen3904> ::= <Left_Paren> <Precision> <Right_Paren>
<Gen3904_maybe> ::= <Gen3904>
<Gen3904_maybe> ::=
<Pl_I_Type_Specification> ::= <Gen3894> <VARYING_maybe> <Left_Paren> <Length> <Right_Paren> <Gen3898_maybe>
                            | <Pl_I_Type_Fixed_Decimal> <Left_Paren> <Precision> <Gen3901_maybe> <Right_Paren>
                            | <Pl_I_Type_Fixed_Binary> <Gen3904_maybe>
                            | <Pl_I_Type_Float_Binary> <Left_Paren> <Precision> <Right_Paren>
                            | <Pl_I_Derived_Type_Specification>
<Pl_I_Derived_Type_Specification> ::= <Pl_I_Clob_Variable>
                                    | <Pl_I_Blob_Variable>
                                    | <Pl_I_User_Defined_Type_Variable>
                                    | <Pl_I_Clob_Locator_Variable>
                                    | <Pl_I_Blob_Locator_Variable>
                                    | <Pl_I_User_Defined_Type_Locator_Variable>
                                    | <Pl_I_Array_Locator_Variable>
                                    | <Pl_I_Multiset_Locator_Variable>
                                    | <Pl_I_Ref_Variable>
<Gen3921> ::= <CHARACTER> <SET> <IS_maybe> <Character_Set_Specification>
<Gen3921_maybe> ::= <Gen3921>
<Gen3921_maybe> ::=
<Pl_I_Clob_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <Left_Paren> <Large_Object_Length> <Right_Paren> <Gen3921_maybe>
<Pl_I_Blob_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <Left_Paren> <Large_Object_Length> <Right_Paren>
<Pl_I_User_Defined_Type_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <Predefined_Type>
<Pl_I_Clob_Locator_Variable> ::= <SQL> <TYPE> <IS> <CLOB> <AS> <LOCATOR>
<Pl_I_Blob_Locator_Variable> ::= <SQL> <TYPE> <IS> <BLOB> <AS> <LOCATOR>
<Pl_I_User_Defined_Type_Locator_Variable> ::= <SQL> <TYPE> <IS> <Path_Resolved_User_Defined_Type_Name> <AS> <LOCATOR>
<Pl_I_Array_Locator_Variable> ::= <SQL> <TYPE> <IS> <Array_Type> <AS> <LOCATOR>
<Pl_I_Multiset_Locator_Variable> ::= <SQL> <TYPE> <IS> <Multiset_Type> <AS> <LOCATOR>
<Pl_I_Ref_Variable> ::= <SQL> <TYPE> <IS> <Reference_Type>
<Gen3933> ::= <DEC>
            | <DECIMAL>
<Gen3935> ::= <DEC>
            | <DECIMAL>
<Pl_I_Type_Fixed_Decimal> ::= <Gen3933> <FIXED>
                            | <FIXED> <Gen3935>
<Gen3939> ::= <BIN>
            | <BINARY>
<Gen3941> ::= <BIN>
            | <BINARY>
<Pl_I_Type_Fixed_Binary> ::= <Gen3939> <FIXED>
                           | <FIXED> <Gen3941>
<Gen3945> ::= <BIN>
            | <BINARY>
<Gen3947> ::= <BIN>
            | <BINARY>
<Pl_I_Type_Float_Binary> ::= <Gen3945> <FLOAT>
                           | <FLOAT> <Gen3947>
<Direct_SQL_Statement> ::= <Directly_Executable_Statement> <Semicolon>
<Directly_Executable_Statement> ::= <Direct_SQL_Data_Statement>
                                  | <SQL_Schema_Statement>
                                  | <SQL_Transaction_Statement>
                                  | <SQL_Connection_Statement>
                                  | <SQL_Session_Statement>
<Direct_SQL_Data_Statement> ::= <Delete_Statement_Searched>
                              | <Direct_Select_Statement_Multiple_Rows>
                              | <Insert_Statement>
                              | <Update_Statement_Searched>
                              | <Merge_Statement>
                              | <Temporary_Table_Declaration>
<Direct_Select_Statement_Multiple_Rows> ::= <Cursor_Specification>
<Get_Diagnostics_Statement> ::= <GET> <DIAGNOSTICS> <SQL_Diagnostics_Information>
<SQL_Diagnostics_Information> ::= <Statement_Information>
                                | <Condition_Information>
<Gen3967> ::= <Comma> <Statement_Information_Item>
<Gen3967_any> ::= <Gen3967>*
<Statement_Information> ::= <Statement_Information_Item> <Gen3967_any>
<Statement_Information_Item> ::= <Simple_Target_Specification> <Equals_Operator> <Statement_Information_Item_Name>
<Statement_Information_Item_Name> ::= <NUMBER>
                                    | <MORE>
                                    | <Lex093>
                                    | <Lex094>
                                    | <Lex130>
                                    | <Lex131>
                                    | <Lex237>
                                    | <Lex274>
                                    | <Lex275>
                                    | <Lex276>
<Gen3981> ::= <EXCEPTION>
            | <CONDITION>
<Gen3983> ::= <Comma> <Condition_Information_Item>
<Gen3983_any> ::= <Gen3983>*
<Condition_Information> ::= <Gen3981> <Condition_Number> <Condition_Information_Item> <Gen3983_any>
<Condition_Information_Item> ::= <Simple_Target_Specification> <Equals_Operator> <Condition_Information_Item_Name>
<Condition_Information_Item_Name> ::= <Lex071>
                                    | <Lex083>
                                    | <Lex092>
                                    | <Lex097>
                                    | <Lex098>
                                    | <Lex100>
                                    | <Lex101>
                                    | <Lex102>
                                    | <Lex112>
                                    | <Lex173>
                                    | <Lex174>
                                    | <Lex175>
                                    | <Lex202>
                                    | <Lex203>
                                    | <Lex204>
                                    | <Lex231>
                                    | <Lex234>
                                    | <Lex235>
                                    | <Lex236>
                                    | <Lex241>
                                    | <Lex250>
                                    | <Lex257>
                                    | <Lex265>
                                    | <Lex269>
                                    | <Lex280>
                                    | <Lex281>
                                    | <Lex282>
<Condition_Number> ::= <Simple_Value_Specification>
<A> ~ 'A':i
<ABS> ~ 'ABS':i
<ABSOLUTE> ~ 'ABSOLUTE':i
<ACTION> ~ 'ACTION':i
<ADA> ~ 'ADA':i
<ADD> ~ 'ADD':i
<ADMIN> ~ 'ADMIN':i
<AFTER> ~ 'AFTER':i
<ALL> ~ 'ALL':i
<ALLOCATE> ~ 'ALLOCATE':i
<ALTER> ~ 'ALTER':i
<ALWAYS> ~ 'ALWAYS':i
<AND> ~ 'AND':i
<ANY> ~ 'ANY':i
<ARE> ~ 'ARE':i
<ARRAY> ~ 'ARRAY':i
<AS> ~ 'AS':i
<ASC> ~ 'ASC':i
<ASENSITIVE> ~ 'ASENSITIVE':i
<ASSERTION> ~ 'ASSERTION':i
<ASSIGNMENT> ~ 'ASSIGNMENT':i
<ASYMMETRIC> ~ 'ASYMMETRIC':i
<AT> ~ 'AT':i
<ATOMIC> ~ 'ATOMIC':i
<ATTRIBUTE> ~ 'ATTRIBUTE':i
<ATTRIBUTES> ~ 'ATTRIBUTES':i
<AUTHORIZATION> ~ 'AUTHORIZATION':i
<AVG> ~ 'AVG':i
<B> ~ 'B':i
<BEFORE> ~ 'BEFORE':i
<BEGIN> ~ 'BEGIN':i
<BERNOULLI> ~ 'BERNOULLI':i
<BETWEEN> ~ 'BETWEEN':i
<BIGINT> ~ 'BIGINT':i
<BIN> ~ 'BIN':i
<BINARY> ~ 'BINARY':i
<BLOB> ~ 'BLOB':i
<BOOLEAN> ~ 'BOOLEAN':i
<BOTH> ~ 'BOTH':i
<BREADTH> ~ 'BREADTH':i
<BY> ~ 'BY':i
<C> ~ 'C':i
<CALL> ~ 'CALL':i
<CALLED> ~ 'CALLED':i
<CARDINALITY> ~ 'CARDINALITY':i
<CASCADE> ~ 'CASCADE':i
<CASCADED> ~ 'CASCADED':i
<CASE> ~ 'CASE':i
<CAST> ~ 'CAST':i
<CATALOG> ~ 'CATALOG':i
<CEIL> ~ 'CEIL':i
<CEILING> ~ 'CEILING':i
<CHAIN> ~ 'CHAIN':i
<CHAR> ~ 'CHAR':i
<CHARACTER> ~ 'CHARACTER':i
<CHARACTERISTICS> ~ 'CHARACTERISTICS':i
<CHARACTERS> ~ 'CHARACTERS':i
<CHECK> ~ 'CHECK':i
<CHECKED> ~ 'CHECKED':i
<CLOB> ~ 'CLOB':i
<CLOSE> ~ 'CLOSE':i
<COALESCE> ~ 'COALESCE':i
<COBOL> ~ 'COBOL':i
<COLLATE> ~ 'COLLATE':i
<COLLATION> ~ 'COLLATION':i
<COLLECT> ~ 'COLLECT':i
<COLUMN> ~ 'COLUMN':i
<COMMIT> ~ 'COMMIT':i
<COMMITTED> ~ 'COMMITTED':i
<CONDITION> ~ 'CONDITION':i
<CONNECT> ~ 'CONNECT':i
<CONNECTION> ~ 'CONNECTION':i
<CONSTRAINT> ~ 'CONSTRAINT':i
<CONSTRAINTS> ~ 'CONSTRAINTS':i
<CONSTRUCTOR> ~ 'CONSTRUCTOR':i
<CONSTRUCTORS> ~ 'CONSTRUCTORS':i
<CONTAINS> ~ 'CONTAINS':i
<CONTINUE> ~ 'CONTINUE':i
<CONVERT> ~ 'CONVERT':i
<CORR> ~ 'CORR':i
<CORRESPONDING> ~ 'CORRESPONDING':i
<COUNT> ~ 'COUNT':i
<CREATE> ~ 'CREATE':i
<CROSS> ~ 'CROSS':i
<CUBE> ~ 'CUBE':i
<CURRENT> ~ 'CURRENT':i
<CURSOR> ~ 'CURSOR':i
<CYCLE> ~ 'CYCLE':i
<D> ~ 'D':i
<DATA> ~ 'DATA':i
<DATE> ~ 'DATE':i
<DAY> ~ 'DAY':i
<DCL> ~ 'DCL':i
<DEALLOCATE> ~ 'DEALLOCATE':i
<DEC> ~ 'DEC':i
<DECIMAL> ~ 'DECIMAL':i
<DECLARE> ~ 'DECLARE':i
<DEFAULT> ~ 'DEFAULT':i
<DEFAULTS> ~ 'DEFAULTS':i
<DEFERRABLE> ~ 'DEFERRABLE':i
<DEFERRED> ~ 'DEFERRED':i
<DEFINED> ~ 'DEFINED':i
<DEFINER> ~ 'DEFINER':i
<DEGREE> ~ 'DEGREE':i
<DELETE> ~ 'DELETE':i
<DEPTH> ~ 'DEPTH':i
<DEREF> ~ 'DEREF':i
<DERIVED> ~ 'DERIVED':i
<DESC> ~ 'DESC':i
<DESCRIBE> ~ 'DESCRIBE':i
<DESCRIPTOR> ~ 'DESCRIPTOR':i
<DETERMINISTIC> ~ 'DETERMINISTIC':i
<DIAGNOSTICS> ~ 'DIAGNOSTICS':i
<DISCONNECT> ~ 'DISCONNECT':i
<DISPATCH> ~ 'DISPATCH':i
<DISPLAY> ~ 'DISPLAY':i
<DISTINCT> ~ 'DISTINCT':i
<DOMAIN> ~ 'DOMAIN':i
<DOUBLE> ~ 'DOUBLE':i
<DROP> ~ 'DROP':i
<DYNAMIC> ~ 'DYNAMIC':i
<E> ~ 'E':i
<EACH> ~ 'EACH':i
<ELEMENT> ~ 'ELEMENT':i
<ELSE> ~ 'ELSE':i
<END> ~ 'END':i
<EQUALS> ~ 'EQUALS':i
<ESCAPE> ~ 'ESCAPE':i
<EVERY> ~ 'EVERY':i
<EXCEPT> ~ 'EXCEPT':i
<EXCEPTION> ~ 'EXCEPTION':i
<EXCLUDE> ~ 'EXCLUDE':i
<EXCLUDING> ~ 'EXCLUDING':i
<EXEC> ~ 'EXEC':i
<EXECUTE> ~ 'EXECUTE':i
<EXISTS> ~ 'EXISTS':i
<EXP> ~ 'EXP':i
<EXTERNAL> ~ 'EXTERNAL':i
<EXTRACT> ~ 'EXTRACT':i
<F> ~ 'F':i
<FALSE> ~ 'FALSE':i
<FETCH> ~ 'FETCH':i
<FILTER> ~ 'FILTER':i
<FINAL> ~ 'FINAL':i
<FIRST> ~ 'FIRST':i
<FIXED> ~ 'FIXED':i
<FLOAT> ~ 'FLOAT':i
<FLOOR> ~ 'FLOOR':i
<FOLLOWING> ~ 'FOLLOWING':i
<FOR> ~ 'FOR':i
<FOREIGN> ~ 'FOREIGN':i
<FORTRAN> ~ 'FORTRAN':i
<FOUND> ~ 'FOUND':i
<FREE> ~ 'FREE':i
<FROM> ~ 'FROM':i
<FULL> ~ 'FULL':i
<FUNCTION> ~ 'FUNCTION':i
<FUSION> ~ 'FUSION':i
<G> ~ 'G':i
<GENERAL> ~ 'GENERAL':i
<GENERATED> ~ 'GENERATED':i
<GET> ~ 'GET':i
<GLOBAL> ~ 'GLOBAL':i
<GO> ~ 'GO':i
<GOTO> ~ 'GOTO':i
<GRANT> ~ 'GRANT':i
<GRANTED> ~ 'GRANTED':i
<GROUP> ~ 'GROUP':i
<GROUPING> ~ 'GROUPING':i
<HAVING> ~ 'HAVING':i
<HIERARCHY> ~ 'HIERARCHY':i
<HOLD> ~ 'HOLD':i
<HOUR> ~ 'HOUR':i
<IDENTITY> ~ 'IDENTITY':i
<IMMEDIATE> ~ 'IMMEDIATE':i
<IMPLEMENTATION> ~ 'IMPLEMENTATION':i
<IN> ~ 'IN':i
<INCLUDING> ~ 'INCLUDING':i
<INCREMENT> ~ 'INCREMENT':i
<INDICATOR> ~ 'INDICATOR':i
<INITIALLY> ~ 'INITIALLY':i
<INNER> ~ 'INNER':i
<INOUT> ~ 'INOUT':i
<INPUT> ~ 'INPUT':i
<INSENSITIVE> ~ 'INSENSITIVE':i
<INSERT> ~ 'INSERT':i
<INSTANCE> ~ 'INSTANCE':i
<INSTANTIABLE> ~ 'INSTANTIABLE':i
<INT> ~ 'INT':i
<INTEGER> ~ 'INTEGER':i
<INTERSECT> ~ 'INTERSECT':i
<INTERSECTION> ~ 'INTERSECTION':i
<INTERVAL> ~ 'INTERVAL':i
<INTO> ~ 'INTO':i
<INVOKER> ~ 'INVOKER':i
<IS> ~ 'IS':i
<ISOLATION> ~ 'ISOLATION':i
<JOIN> ~ 'JOIN':i
<K> ~ 'K':i
<KEY> ~ 'KEY':i
<KIND> ~ 'KIND':i
<LANGUAGE> ~ 'LANGUAGE':i
<LARGE> ~ 'LARGE':i
<LAST> ~ 'LAST':i
<LATERAL> ~ 'LATERAL':i
<LEADING> ~ 'LEADING':i
<LEFT> ~ 'LEFT':i
<LENGTH> ~ 'LENGTH':i
<LEVEL> ~ 'LEVEL':i
<LIKE> ~ 'LIKE':i
<LN> ~ 'LN':i
<LOCAL> ~ 'LOCAL':i
<LOCALTIME> ~ 'LOCALTIME':i
<LOCALTIMESTAMP> ~ 'LOCALTIMESTAMP':i
<LOCATOR> ~ 'LOCATOR':i
<LOGICAL> ~ 'LOGICAL':i
<LOWER> ~ 'LOWER':i
<Lex001> ~ [A-Z]
<Lex002> ~ [a-z]
<Lex003> ~ [0-9]
<Lex003_many> ~ [0-9]*
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
<Lex024> ~ '??('
<Lex025> ~ ']'
<Lex026> ~ '??)'
<Lex027> ~ '^'
<Lex028> ~ '_':i
<Lex029> ~ '|'
<Lex030> ~ '{'
<Lex031> ~ '}'
<Lex035> ~ '"'
<Lex036> ~ '"'
<Lex037> ~ 'U':i
<Lex038> ~ '&'
<Lex039> ~ '"'
<Lex040> ~ '"'
<Lex041> ~ 'UESCAPE':i
<Lex042> ~ [']
<Lex043> ~ [']
<Lex044> ~ [a-fA-f0-9]
<Lex045> ~ '+'
<Lex046> ~ [\x{1b}]
<Lex047> ~ [^"]
<Lex048> ~ '""'
<Lex049> ~ [\n]
<Lex071> ~ 'CATALOG_NAME':i
<Lex077> ~ 'CHARACTER_LENGTH':i
<Lex078> ~ 'CHARACTER_SET_CATALOG':i
<Lex079> ~ 'CHARACTER_SET_NAME':i
<Lex080> ~ 'CHARACTER_SET_SCHEMA':i
<Lex081> ~ 'CHAR_LENGTH':i
<Lex083> ~ 'CLASS_ORIGIN':i
<Lex086> ~ 'CODE_UNITS':i
<Lex088> ~ 'COLLATION_CATALOG':i
<Lex089> ~ 'COLLATION_NAME':i
<Lex090> ~ 'COLLATION_SCHEMA':i
<Lex092> ~ 'COLUMN_NAME':i
<Lex093> ~ 'COMMAND_FUNCTION':i
<Lex094> ~ 'COMMAND_FUNCTION_CODE':i
<Lex097> ~ 'CONDITION_NUMBER':i
<Lex098> ~ 'CONNECTION_NAME':i
<Lex100> ~ 'CONSTRAINT_CATALOG':i
<Lex101> ~ 'CONSTRAINT_NAME':i
<Lex102> ~ 'CONSTRAINT_SCHEMA':i
<Lex108> ~ 'COVAR_POP':i
<Lex109> ~ 'COVAR_SAMP':i
<Lex110> ~ 'CUME_DIST':i
<Lex111> ~ 'CURRENT_COLLATION':i
<Lex112> ~ 'CURSOR_NAME':i
<Lex114> ~ 'DATETIME_INTERVAL_CODE':i
<Lex115> ~ 'DATETIME_INTERVAL_PRECISION':i
<Lex122> ~ 'DENSE_RANK':i
<Lex130> ~ 'DYNAMIC_FUNCTION':i
<Lex131> ~ 'DYNAMIC_FUNCTION_CODE':i
<Lex161> ~ 'KEY_MEMBER':i
<Lex162> ~ 'KEY_TYPE':i
<Lex173> ~ 'MESSAGE_LENGTH':i
<Lex174> ~ 'MESSAGE_OCTET_LENGTH':i
<Lex175> ~ 'MESSAGE_TEXT':i
<Lex193> ~ 'OCTET_LENGTH':i
<Lex202> ~ 'PARAMETER_MODE':i
<Lex203> ~ 'PARAMETER_NAME':i
<Lex204> ~ 'PARAMETER_ORDINAL_POSITION':i
<Lex205> ~ 'PARAMETER_SPECIFIC_CATALOG':i
<Lex206> ~ 'PARAMETER_SPECIFIC_NAME':i
<Lex207> ~ 'PARAMETER_SPECIFIC_SCHEMA':i
<Lex211> ~ 'PERCENTILE_CONT':i
<Lex212> ~ 'PERCENTILE_DISC':i
<Lex213> ~ 'PERCENT_RANK':i
<Lex228> ~ 'RETURNED_CARDINALITY':i
<Lex229> ~ 'RETURNED_LENGTH':i
<Lex230> ~ 'RETURNED_OCTET_LENGTH':i
<Lex231> ~ 'RETURNED_SQLSTATE':i
<Lex234> ~ 'ROUTINE_CATALOG':i
<Lex235> ~ 'ROUTINE_NAME':i
<Lex236> ~ 'ROUTINE_SCHEMA':i
<Lex237> ~ 'ROW_COUNT':i
<Lex238> ~ 'ROW_NUMBER':i
<Lex241> ~ 'SCHEMA_NAME':i
<Lex242> ~ 'SCOPE_CATALOG':i
<Lex243> ~ 'SCOPE_NAME':i
<Lex244> ~ 'SCOPE_SCHEMA':i
<Lex250> ~ 'SERVER_NAME':i
<Lex257> ~ 'SPECIFIC_NAME':i
<Lex261> ~ 'STDDEV_POP':i
<Lex262> ~ 'STDDEV_SAMP':i
<Lex265> ~ 'SUBCLASS_ORIGIN':i
<Lex269> ~ 'TABLE_NAME':i
<Lex272> ~ 'TOP_LEVEL_COUNT':i
<Lex274> ~ 'TRANSACTIONS_COMMITTED':i
<Lex275> ~ 'TRANSACTIONS_ROLLED_BACK':i
<Lex276> ~ 'TRANSACTION_ACTIVE':i
<Lex280> ~ 'TRIGGER_CATALOG':i
<Lex281> ~ 'TRIGGER_NAME':i
<Lex282> ~ 'TRIGGER_SCHEMA':i
<Lex290> ~ 'USER_DEFINED_TYPE_CATALOG':i
<Lex291> ~ 'USER_DEFINED_TYPE_CODE':i
<Lex292> ~ 'USER_DEFINED_TYPE_NAME':i
<Lex293> ~ 'USER_DEFINED_TYPE_SCHEMA':i
<Lex341> ~ 'CURRENT_DATE':i
<Lex342> ~ 'CURRENT_DEFAULT_TRANSFORM_GROUP':i
<Lex343> ~ 'CURRENT_PATH':i
<Lex344> ~ 'CURRENT_ROLE':i
<Lex345> ~ 'CURRENT_TIME':i
<Lex346> ~ 'CURRENT_TIMESTAMP':i
<Lex347> ~ 'CURRENT_TRANSFORM_GROUP_FOR_TYPE':i
<Lex348> ~ 'CURRENT_USER':i
<Lex371> ~ 'END-EXEC'
<Lex465> ~ 'REGR_AVGX':i
<Lex466> ~ 'REGR_AVGY':i
<Lex467> ~ 'REGR_COUNT':i
<Lex468> ~ 'REGR_INTERCEPT':i
<Lex469> ~ 'REGR_R2'
<Lex470> ~ 'REGR_SLOPE':i
<Lex471> ~ 'REGR_SXX':i
<Lex472> ~ 'REGR_SXY':i
<Lex473> ~ 'REGR_SYY':i
<Lex490> ~ 'SESSION_USER':i
<Lex506> ~ 'SYSTEM_USER':i
<Lex511> ~ 'TIMEZONE_HOUR':i
<Lex512> ~ 'TIMEZONE_MINUTE':i
<Lex530> ~ 'VAR_POP':i
<Lex531> ~ 'VAR_SAMP':i
<Lex537> ~ 'WIDTH_BUCKET':i
<Lex543> ~ [^']
<Lex557_many> ~ [\d]+
<Lex558> ~ [a-zA-Z]
<Lex559> ~ [a-zA-Z0-9_]
<Lex561> ~ [^\[\]()|\^\-+*_%?{\\]
<Lex562> ~ [\x{5c}]
<Lex563> ~ [\[\]()|\^\-+*_%?{\\]
<Lex568_many> ~ [^\s]+
<Lex569> ~ 'Interfaces.SQL'
<Lex570> ~ '1'
<Lex571> ~ 'DOUBLE_PRECISION':i
<Lex572> ~ 'SQLSTATE_TYPE':i
<Lex573> ~ 'INDICATOR_TYPE':i
<Lex585_many> ~ [^\s]+
<Lex586_many> ~ [^\s]+
<Lex587> ~ '01'
<Lex588> ~ '77'
<Lex596> ~ '9'
<Lex597_many> ~ [^\s]+
<Lex601_many> ~ [^\s]+
<Lex602_many> ~ [^\s]+
<Lex604_many> ~ [^\s]+
<M> ~ 'M':i
<MAP> ~ 'MAP':i
<MATCH> ~ 'MATCH':i
<MATCHED> ~ 'MATCHED':i
<MAX> ~ 'MAX':i
<MAXVALUE> ~ 'MAXVALUE':i
<MEMBER> ~ 'MEMBER':i
<MERGE> ~ 'MERGE':i
<METHOD> ~ 'METHOD':i
<MIN> ~ 'MIN':i
<MINUTE> ~ 'MINUTE':i
<MINVALUE> ~ 'MINVALUE':i
<MOD> ~ 'MOD':i
<MODIFIES> ~ 'MODIFIES':i
<MODULE> ~ 'MODULE':i
<MONTH> ~ 'MONTH':i
<MORE> ~ 'MORE':i
<MULTISET> ~ 'MULTISET':i
<MUMPS> ~ 'MUMPS':i
<N> ~ 'N':i
<NAME> ~ 'NAME':i
<NAMES> ~ 'NAMES':i
<NATIONAL> ~ 'NATIONAL':i
<NATURAL> ~ 'NATURAL':i
<NCHAR> ~ 'NCHAR':i
<NCLOB> ~ 'NCLOB':i
<NESTING> ~ 'NESTING':i
<NEW> ~ 'NEW':i
<NEXT> ~ 'NEXT':i
<NO> ~ 'NO':i
<NONE> ~ 'NONE':i
<NORMALIZE> ~ 'NORMALIZE':i
<NORMALIZED> ~ 'NORMALIZED':i
<NOT> ~ 'NOT':i
<NULL> ~ 'NULL':i
<NULLABLE> ~ 'NULLABLE':i
<NULLIF> ~ 'NULLIF':i
<NULLS> ~ 'NULLS':i
<NUMBER> ~ 'NUMBER':i
<NUMERIC> ~ 'NUMERIC':i
<OBJECT> ~ 'OBJECT':i
<OCTETS> ~ 'OCTETS':i
<OF> ~ 'OF':i
<OLD> ~ 'OLD':i
<ON> ~ 'ON':i
<ONLY> ~ 'ONLY':i
<OPEN> ~ 'OPEN':i
<OPTION> ~ 'OPTION':i
<OPTIONS> ~ 'OPTIONS':i
<OR> ~ 'OR':i
<ORDER> ~ 'ORDER':i
<ORDERING> ~ 'ORDERING':i
<ORDINALITY> ~ 'ORDINALITY':i
<OTHERS> ~ 'OTHERS':i
<OUT> ~ 'OUT':i
<OUTER> ~ 'OUTER':i
<OUTPUT> ~ 'OUTPUT':i
<OVER> ~ 'OVER':i
<OVERLAPS> ~ 'OVERLAPS':i
<OVERLAY> ~ 'OVERLAY':i
<OVERRIDING> ~ 'OVERRIDING':i
<PACKED> ~ 'PACKED':i
<PAD> ~ 'PAD':i
<PARAMETER> ~ 'PARAMETER':i
<PARTIAL> ~ 'PARTIAL':i
<PARTITION> ~ 'PARTITION':i
<PASCAL> ~ 'PASCAL':i
<PATH> ~ 'PATH':i
<PIC> ~ 'PIC':i
<PICTURE> ~ 'PICTURE':i
<PLACING> ~ 'PLACING':i
<PLI> ~ 'PLI':i
<POSITION> ~ 'POSITION':i
<POWER> ~ 'POWER':i
<PRECEDING> ~ 'PRECEDING':i
<PRECISION> ~ 'PRECISION':i
<PREPARE> ~ 'PREPARE':i
<PRESERVE> ~ 'PRESERVE':i
<PRIMARY> ~ 'PRIMARY':i
<PRIOR> ~ 'PRIOR':i
<PRIVILEGES> ~ 'PRIVILEGES':i
<PROCEDURE> ~ 'PROCEDURE':i
<PUBLIC> ~ 'PUBLIC':i
<RANGE> ~ 'RANGE':i
<RANK> ~ 'RANK':i
<READ> ~ 'READ':i
<READS> ~ 'READS':i
<REAL> ~ 'REAL':i
<RECURSIVE> ~ 'RECURSIVE':i
<REF> ~ 'REF':i
<REFERENCES> ~ 'REFERENCES':i
<REFERENCING> ~ 'REFERENCING':i
<RELATIVE> ~ 'RELATIVE':i
<RELEASE> ~ 'RELEASE':i
<REPEATABLE> ~ 'REPEATABLE':i
<RESTART> ~ 'RESTART':i
<RESTRICT> ~ 'RESTRICT':i
<RESULT> ~ 'RESULT':i
<RETURN> ~ 'RETURN':i
<RETURNS> ~ 'RETURNS':i
<REVOKE> ~ 'REVOKE':i
<RIGHT> ~ 'RIGHT':i
<ROLE> ~ 'ROLE':i
<ROLLBACK> ~ 'ROLLBACK':i
<ROLLUP> ~ 'ROLLUP':i
<ROUTINE> ~ 'ROUTINE':i
<ROW> ~ 'ROW':i
<ROWS> ~ 'ROWS':i
<S> ~ 'S':i
<SAVEPOINT> ~ 'SAVEPOINT':i
<SCALE> ~ 'SCALE':i
<SCHEMA> ~ 'SCHEMA':i
<SCOPE> ~ 'SCOPE':i
<SCROLL> ~ 'SCROLL':i
<SEARCH> ~ 'SEARCH':i
<SECOND> ~ 'SECOND':i
<SECTION> ~ 'SECTION':i
<SECURITY> ~ 'SECURITY':i
<SELECT> ~ 'SELECT':i
<SELF> ~ 'SELF':i
<SENSITIVE> ~ 'SENSITIVE':i
<SEPARATE> ~ 'SEPARATE':i
<SEQUENCE> ~ 'SEQUENCE':i
<SERIALIZABLE> ~ 'SERIALIZABLE':i
<SESSION> ~ 'SESSION':i
<SET> ~ 'SET':i
<SETS> ~ 'SETS':i
<SIGN> ~ 'SIGN':i
<SIMILAR> ~ 'SIMILAR':i
<SIMPLE> ~ 'SIMPLE':i
<SIZE> ~ 'SIZE':i
<SMALLINT> ~ 'SMALLINT':i
<SOME> ~ 'SOME':i
<SOURCE> ~ 'SOURCE':i
<SPACE> ~ 'SPACE':i
<SPECIFIC> ~ 'SPECIFIC':i
<SPECIFICTYPE> ~ 'SPECIFICTYPE':i
<SQL> ~ 'SQL':i
<SQLEXCEPTION> ~ 'SQLEXCEPTION':i
<SQLSTATE> ~ 'SQLSTATE':i
<SQLWARNING> ~ 'SQLWARNING':i
<SQRT> ~ 'SQRT':i
<START> ~ 'START':i
<STATE> ~ 'STATE':i
<STATEMENT> ~ 'STATEMENT':i
<STATIC> ~ 'STATIC':i
<STRUCTURE> ~ 'STRUCTURE':i
<STYLE> ~ 'STYLE':i
<SUBMULTISET> ~ 'SUBMULTISET':i
<SUBSTRING> ~ 'SUBSTRING':i
<SUM> ~ 'SUM':i
<SYMMETRIC> ~ 'SYMMETRIC':i
<SYSTEM> ~ 'SYSTEM':i
<TABLE> ~ 'TABLE':i
<TABLESAMPLE> ~ 'TABLESAMPLE':i
<TEMPORARY> ~ 'TEMPORARY':i
<THEN> ~ 'THEN':i
<TIES> ~ 'TIES':i
<TIME> ~ 'TIME':i
<TIMESTAMP> ~ 'TIMESTAMP':i
<TO> ~ 'TO':i
<TRAILING> ~ 'TRAILING':i
<TRANSACTION> ~ 'TRANSACTION':i
<TRANSFORM> ~ 'TRANSFORM':i
<TRANSFORMS> ~ 'TRANSFORMS':i
<TRANSLATE> ~ 'TRANSLATE':i
<TRANSLATION> ~ 'TRANSLATION':i
<TREAT> ~ 'TREAT':i
<TRIGGER> ~ 'TRIGGER':i
<TRIM> ~ 'TRIM':i
<TRUE> ~ 'TRUE':i
<TYPE> ~ 'TYPE':i
<U> ~ 'U':i
<UESCAPE> ~ 'UESCAPE':i
<UNBOUNDED> ~ 'UNBOUNDED':i
<UNCOMMITTED> ~ 'UNCOMMITTED':i
<UNDER> ~ 'UNDER':i
<UNION> ~ 'UNION':i
<UNIQUE> ~ 'UNIQUE':i
<UNKNOWN> ~ 'UNKNOWN':i
<UNNAMED> ~ 'UNNAMED':i
<UNNEST> ~ 'UNNEST':i
<UPDATE> ~ 'UPDATE':i
<UPPER> ~ 'UPPER':i
<USAGE> ~ 'USAGE':i
<USER> ~ 'USER':i
<USING> ~ 'USING':i
<V> ~ 'V':i
<VALUE> ~ 'VALUE':i
<VALUES> ~ 'VALUES':i
<VARCHAR> ~ 'VARCHAR':i
<VARYING> ~ 'VARYING':i
<VIEW> ~ 'VIEW':i
<WHEN> ~ 'WHEN':i
<WHENEVER> ~ 'WHENEVER':i
<WHERE> ~ 'WHERE':i
<WINDOW> ~ 'WINDOW':i
<WITH> ~ 'WITH':i
<WITHIN> ~ 'WITHIN':i
<WITHOUT> ~ 'WITHOUT':i
<WORK> ~ 'WORK':i
<WRITE> ~ 'WRITE':i
<X> ~ 'X':i
<YEAR> ~ 'YEAR':i
<ZONE> ~ 'ZONE':i
<a> ~ 'a'
<auto> ~ 'auto'
<b> ~ 'b'
<c> ~ 'c'
<char> ~ 'char'
<const> ~ 'const'
<d> ~ 'd'
<double> ~ 'double'
<e> ~ 'e'
<extern> ~ 'extern'
<f> ~ 'f'
<float> ~ 'float'
<long> ~ 'long'
<short> ~ 'short'
<static> ~ 'static'
<unsigned> ~ 'unsigned'
<volatile> ~ 'volatile'

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

