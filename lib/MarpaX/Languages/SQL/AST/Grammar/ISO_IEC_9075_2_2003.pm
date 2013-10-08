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
#
# Defaults
#
:default ::= action => [values] bless => ::lhs
lexeme default = action => [start,length,value]

#
# References: http://savage.net.au/SQL/sql-2003-1.bnf, http://savage.net.au/SQL/sql-2003-2.bnf
#

:start ::= <sqlStartSequence>
:discard ~ <__separator>
#
# For the empty statements, or statements ending with ';' while this is not in the grammar
#
:discard ~ <__semicolon>

<sqlStartSequence>  ::= <sqlStart>+

<sqlStart>  ::= <preparableStatement>
              | <directSqlStatement>
              | <embeddedSqlDeclareSection>
              | <embeddedSqlHostProgram>
              | <embeddedSqlStatement>
              | <sqlClientModuleDefinition>

# -----------------------------------------------------------------------------------
# Lexemes are always: <CONSTANT> or <_something>
# Any rule starting with <__XXX> is internal to G0 and cannot be exported as a lexeme
# -----------------------------------------------------------------------------------

<_simple Latin letter> ~ <__simple Latin upper case letter> | <__simple Latin lower case letter>

<__simple Latin upper case letter> ~ [A-Z]
<_simple Latin upper case letter> ~ <__simple Latin upper case letter>

<__simple Latin lower case letter> ~ [a-z]

<__digit>     ~ [0-9]
<_digit>      ~ <__digit>
<__digit many> ~ <__digit>+

<_space> ~ [\N{U+0020}]

<__double quote>  ~ '"'

<_percent> ~ '%'

<__ampersand> ~ '&'
<_ampersand>  ~ <__ampersand>

<__quote> ~ [']

<_left paren> ~ '('

<_right paren> ~ ')'

<__asterisk> ~ '*'
<_asterisk>  ~ <__asterisk>

<__plus sign> ~ '+'
<_plus sign> ~ <__plus sign>

<_comma> ~ ','

<__minus sign> ~ '-'
<_minus sign>  ~ <__minus sign>

<__period> ~ '.'
<_period> ~ <__period>

<__solidus> ~ '/'
<_solidus>  ~ <__solidus>

<__colon> ~ ':'
<_colon> ~ <__colon>

<__semicolon> ~ ';'
<_semicolon> ~ <__semicolon>

<__less than operator> ~ '<'
<_less than operator> ~ <__less than operator>

<__equals operator> ~ '='
<_equals operator> ~ <__equals operator>

<__greater than operator> ~ '>'
<_greater than operator> ~ <__greater than operator>

<_question mark> ~ '?'

<__left bracket> ~ '['
<_left bracket>  ~ <__left bracket>

<__left bracket trigraph> ~ '??('

<_left bracket or trigraph> ~ <__left bracket> | <__left bracket trigraph>

<__right bracket> ~ ']'
<_right bracket>  ~ <__right bracket>

<__right bracket trigraph> ~ '??)'

<_right bracket or trigraph> ~ <__right bracket> | <__right bracket trigraph>

<_circumflex> ~ '^'

<__underscore> ~ '_'
<_underscore> ~ <__underscore>

<__vertical bar> ~ '|'
<_vertical bar> ~ <__vertical bar>

<_left brace> ~ '{'

<_right brace> ~ '}'

<_regular identifier> ~ <__identifier body>

<__identifier body> ~ <__identifier start>
                    | <__identifier body> <__identifier part>

<__identifier part> ~ <__identifier start> | <__identifier extend>

<__identifier start> ~ [\p{Lu}\p{Ll}\p{Lt}\p{Lm}\p{Lo}\p{Nl}]

<__identifier extend> ~ [\N{U+00B7}\p{Mn}\p{Mc}\p{Nd}\p{Pc}\p{Cf}]

<__multiplier> ~ [KMG]
<_multiplier>  ~ <__multiplier>

<_large object length token> ~ <__digit many> <__multiplier>

<_delimited identifier> ~ <__double quote> <_delimited identifier body> <__double quote>

<_delimited identifier part> ~ <_nondoublequote character> | <_doublequote symbol>

<_delimited identifier body> ~ <_delimited identifier part>+

<__Unicode escape character> ~ [^A-Fa-f0-9\-\+\p{Zs}\p{Zl}\p{Zp}\N{U+0009}\N{U+000A}\N{U+000B}\N{U+000C}\N{U+000D}\N{U+0085}]

<_Unicode identifier part> ~ <_delimited identifier part> | <__Unicode escape value>

<__Unicode escape value> ~ <_Unicode 4 digit escape value>
                        | <_Unicode 6 digit escape value>
                        | <_Unicode character escape value>

<__Unicode escape specifier> ~ <__UESCAPE><__separator><__quote><__Unicode escape character><__quote>

<_Unicode delimiter body> ~ <_Unicode identifier part>+

<_Unicode delimited identifier> ~ <__U><__ampersand><__double quote><_Unicode delimiter body><__double quote>
                                | <__U><__ampersand><__double quote><_Unicode delimiter body><__double quote><__separator><__Unicode escape specifier>

<_Unicode 4 digit escape value> ~ <__Unicode escape character><__hexit><__hexit><__hexit><__hexit>

<_Unicode 6 digit escape value> ~ <__Unicode escape character><__plus sign><__hexit><__hexit><__hexit><__hexit><__hexit><__hexit>

<_Unicode character escape value> ~ <__Unicode escape character><__Unicode escape character>

<_nondoublequote character> ~ [^"]

<_doublequote symbol> ~ <__double quote> <__double quote>

<_not equals operator> ~ <__less than operator> <__greater than operator>

<_greater than or equals operator> ~ <__greater than operator> <__equals operator>

<_less than or equals operator> ~ <__less than operator> <__equals operator>

<_concatenation operator> ~ <__vertical bar> <__vertical bar>

<_right arrow> ~ <__minus sign> <__greater than operator>

<_double colon> ~ <__colon> <__colon>

<_white space> ~ [\p{Zs}\p{Zl}\p{Zp}\N{U+0009}\N{U+000A}\N{U+000B}\N{U+000C}\N{U+000D}\N{U+0085}]

<_separator unit> ~ <_comment> | <_white space>

<__separator> ~ <_separator unit>+

<_comment> ~ <_simple comment> | <_bracketed comment>

#
# <__comment character> seems wrong to me: <__nonquote character> | <_quote character> will eat
# everything
#
<_not_newline> ~ [^\N{U+000A}\N{U+000D}]
<_comment character many> ~ <_not_newline>+

<_simple comment> ~ <_simple comment introducer> <_newline>
                  | <_simple comment introducer> <_comment character many> <_newline>

<_simple comment introducer> ~ <__minus sign><__minus sign>

<_bracketed comment> ~ <_bracketed comment introducer> <_bracketed comment contents> <_bracketed comment terminator>

<_bracketed comment introducer> ~ <__solidus> <__asterisk>

<_bracketed comment terminator> ~ <__asterisk> <__solidus>

<_bracketed comment contents unit> ~ <__comment character> | <__separator>

<_bracketed comment contents> ~ <_bracketed comment contents unit>*

<__comment character> ~ <__nonquote character> | <__quote>
#
# NOTE 93 — newline is typically represented by U+000A (“Line Feed”) and/or U+000D (“Carriage Return”); however,
# this representation is not required by ISO/IEC 9075.
#
<_newline> ~ [\N{U+000A}] [\N{U+000D}] | [\N{U+000D}] [\N{U+000A}] | [\N{U+000A}] | [\N{U+000D}]

<literal> ::= <signedNumericLiteral> | <generalLiteral>

<unsignedLiteral> ::= <unsignedNumericLiteral> | <generalLiteral>

<generalLiteral> ::= <_character string literal>
                    | <_national character string literal>
                    | <_Unicode character string literal>
                    | <_binary string literal>
                    | <_hex string literal>
                    | <datetimeLiteral>
                    | <intervalLiteral>
                    | <_boolean literal>

<__character representation any> ~ <__character representation>*

<__introducer character set specification maybe> ~ <_introducer><__character set specification>

<__character string literal> ~ <__introducer character set specification maybe> <__quote> <__character representation any> <__quote>
                             | <__quote> <__character representation any> <__quote>
                             | <__character string literal> <__separator> <__quote> <__character representation any> <__quote>

<_character string literal> ~ <__character string literal>

<_introducer> ~ <__underscore>

<__character representation> ~ <_nonquote character> | <_quote symbol>
<_character representation> ~ <__character representation>

<__nonquote character> ~ [^']
<_nonquote character> ~ <__nonquote character>

<__quote symbol> ~ <__quote><__quote>
<_quote symbol> ~ <__quote symbol>

<__national character string literal> ~ <__N> <__quote> <__character representation any> <__quote>
                                      | <__national character string literal> <__separator> <__quote> <__character representation any> <__quote>

<_national character string literal> ~ <__national character string literal>

<__Unicode representation any> ~  <_Unicode representation>*

<__separator AND quote AND Unicode representation any AND quote> ~ <__separator> <__quote> <__Unicode representation any> <__quote>

<__separator AND quote AND Unicode representation any AND quote any> ~ <__separator AND quote AND Unicode representation any AND quote>*

<_ESCAPE escape character> ~ <__ESCAPE> <__escape character>

<_ESCAPE escape character maybe> ~ <_ESCAPE escape character>
<_ESCAPE escape character maybe> ~

<_Unicode character string literal> ~ <__U><__ampersand><__quote><__Unicode representation any> <__quote> <__separator AND quote AND Unicode representation any AND quote any> <_ESCAPE escape character maybe>
                                    | <_introducer><__character set specification>
                                      <__U><__ampersand><__quote><__Unicode representation any> <__quote> <__separator AND quote AND Unicode representation any AND quote any> <_ESCAPE escape character maybe>

<_Unicode representation> ~ <__character representation> | <__Unicode escape value>

<__hexit AND hexit> ~ <__hexit> <__hexit>

<__hexit AND hexit any> ~ <__hexit AND hexit>*

<__hexit any> ~ <__hexit>*

<__separator AND quote AND hexit AND hexit any AND quote> ~  <__separator> <__quote> <__hexit AND hexit any> <__quote>

<__separator AND quote AND hexit AND hexit any AND quote any> ~ <__separator AND quote AND hexit AND hexit any AND quote>*

<__separator AND quote AND hexit any AND quote> ~  <__separator> <__quote> <__hexit any> <__quote>

<__separator AND quote AND hexit any AND quote any> ~ <__separator AND quote AND hexit any AND quote>*

<_hex string literal> ~
		<__X> <__quote> <__hexit any> <__quote>
		<__separator AND quote AND hexit any AND quote any>
		<_ESCAPE escape character maybe>

<_binary string literal> ~
		<__X> <__quote> <__hexit AND hexit any> <__quote>
		<__separator AND quote AND hexit AND hexit any AND quote any>
		<_ESCAPE escape character maybe>

<__hexit> ~ <__digit> | [A-Fa-f]

<signedNumericLiteral> ::= <unsignedNumericLiteral>
                         | <_sign> <unsignedNumericLiteral>

<unsignedNumericLiteral> ::= <_exact numeric literal> | <_approximate numeric literal>

<__exact numeric literal> ~
        		<__unsigned integer>
	       |	<__unsigned integer> <__period>
	       |	<__unsigned integer> <__period> <__unsigned integer>
	       |	<__period> <__unsigned integer>

<_exact numeric literal> ~ <__exact numeric literal>

<__sign> ~ <__plus sign> | <__minus sign>
<_sign> ~ <__sign>

<_approximate numeric literal> ~ <_mantissa> <__E> <_exponent>

<_mantissa> ~ <__exact numeric literal>

<_exponent> ~ <_signed integer>

<_signed integer> ~ <__unsigned integer>
                  | <__sign> <__unsigned integer>

<__unsigned integer> ~ <__digit>+
<_unsigned integer> ~ <__unsigned integer>

<datetimeLiteral> ::= <dateLiteral> | <timeLiteral> | <timestampLiteral>

<dateLiteral> ::= <DATE> <_date string>

<timeLiteral> ::= <TIME> <_time string>

<timestampLiteral> ::= <TIMESTAMP> <_timestamp string>

<_date string> ~ <__quote> <_unquoted date string> <__quote>

<_time string> ~ <__quote> <_unquoted time string> <__quote>

<_timestamp string> ~ <__quote> <_unquoted timestamp string> <__quote>

<_time zone interval> ~ <__sign> <_hours value> <__colon> <_minutes value>

<_date value> ~ <_years value> <__minus sign> <_months value> <__minus sign> <_days value>

<_time value> ~ <_hours value> <__colon> <_minutes value> <__colon> <_seconds value>

<intervalLiteral> ::= <INTERVAL>         <_interval string> <intervalQualifier>
                     | <INTERVAL> <_sign> <_interval string> <intervalQualifier>

<_interval string> ~ <__quote> <_unquoted interval string> <__quote>

<_unquoted date string> ~ <_date value>

<_unquoted time string> ~ <_time value>
                       | <_time value> <_time zone interval>

<_unquoted timestamp string> ~ <_unquoted date string> <_space> <_unquoted time string>

<_unquoted interval string> ~ <_year_month literal>
                           | <_day_time literal>
                           | <__sign> <_year_month literal>
                           | <__sign> <_day_time literal>

<_year_month literal> ~ <_years value>
                     | <_months value>
                     | <_years value> <__minus sign> <_months value>

<_day_time literal> ~ <_day_time interval>
                   | <_time interval>

<_day_time interval> ~
		<_days value>
	|	<_days value> <_space> <_hours value>
	|	<_days value> <_space> <_hours value> <__colon> <_minutes value>
	|	<_days value> <_space> <_hours value> <__colon> <_minutes value> <__colon> <_seconds value>

<_time interval> ~
		<_hours value>
	|	<_hours value> <__colon> <_minutes value>
	|	<_hours value> <__colon> <_minutes value> <__colon> <_seconds value>
	|	<_minutes value>
	|	<_minutes value> <__colon> <_seconds value>
	|	<_seconds value>

<_years value> ~ <_datetime value>

<_months value> ~ <_datetime value>

<_days value> ~ <_datetime value>

<_hours value> ~ <_datetime value>

<_minutes value> ~ <_datetime value>

<_seconds value> ~ <_seconds integer value>
                | <_seconds integer value> <__period>
                | <_seconds integer value> <__period> <_seconds fraction>

<_seconds integer value> ~ <__unsigned integer>

<_seconds fraction> ~ <__unsigned integer>

<_datetime value> ~ <__unsigned integer>

<_boolean literal> ~ <__TRUE> | <__FALSE> | <__UNKNOWN>

<__identifier> ~ <__actual identifier>

<_identifier> ~ <__identifier>

<__actual identifier> ~ <_regular identifier>
                      | <_delimited identifier>
                      | <_Unicode delimited identifier>


<_SQL language identifier> ~ <_SQL language identifier start>
                          | <_SQL language identifier> <__underscore>
                          | <_SQL language identifier> <_SQL language identifier part>

<_SQL language identifier start> ~ <_simple Latin letter>

<_SQL language identifier part> ~ <_simple Latin letter> | <__digit>

<_authorization identifier> ~ <__role name> | <_user identifier>

<_table name> ~ <_local or schema qualified name>

<_domain name> ~ <_schema qualified name>

<__schema name> ~ <_unqualified schema name>
                | <_catalog name> <__period> <_unqualified schema name>
<_schema name> ~ <__schema name>

<_unqualified schema name> ~ <__identifier>

<_catalog name> ~ <__identifier>

<_schema qualified name> ~ <__qualified identifier>
                         | <__schema name> <__period> <__qualified identifier>

<_local or schema qualified name> ~ <__qualified identifier>
                                 | <_local or schema qualifier> <__period> <__qualified identifier>

<_local or schema qualifier> ~ <__schema name> | <__MODULE>

<__qualified identifier> ~ <__identifier>
<_qualified identifier> ~ <__qualified identifier>

<__column name> ~ <__identifier>
<_column name> ~ <__column name>

<_correlation name> ~ <__identifier>

<_query name> ~ <__identifier>

<_SQL_client module name> ~ <__identifier>

<_procedure name> ~ <__identifier>

<_schema qualified routine name> ~ <_schema qualified name>

<_method name> ~ <__identifier>

<_specific name> ~ <_schema qualified name>

<_cursor name> ~ <_local qualified name>

<_local qualified name> ~ <__qualified identifier>
                       | <_local qualifier> <__period> <__qualified identifier>

<_local qualifier> ~ <__MODULE>

<_host parameter name> ~ <__colon> <__identifier>

<_SQL parameter name> ~ <__identifier>

<_constraint name> ~ <_schema qualified name>

<_external routine name> ~ <__identifier> | <__character string literal>

<_trigger name> ~ <_schema qualified name>

<_collation name> ~ <_schema qualified name>

<__character set name> ~ <_SQL language identifier>
                       | <__schema name> <__period> <_SQL language identifier>

<_character set name> ~ <__character set name>

<transliterationName> ~ <_schema qualified name>

<transcodingName> ~ <_schema qualified name>

<__user_defined type name> ~ <schemaQualifiedTypeName>
<_user_defined type name> ~ <__user_defined type name>

<schemaResolvedUserDefinedTypeName> ~ <__user_defined type name>

<schemaQualifiedTypeName> ~ <__qualified identifier>
                             | <__schema name> <__period> <__qualified identifier>

<attributeName> ~ <__identifier>

<fieldName> ~ <__identifier>

<savepointName> ~ <__identifier>

<sequenceGeneratorName> ~ <_schema qualified name>

<__role name> ~ <__identifier>
<_role name> ~ <__role name>

<_user identifier> ~ <__identifier>

<connectionName> ::= <simpleValueSpecification>

<sqlServerName> ::= <simpleValueSpecification>

<connectionUserName> ::= <simpleValueSpecification>

<sqlStatementName> ::= <statementName> | <extendedStatementName>

<statementName> ::= <_identifier>

<extendedStatementName> ::= <simpleValueSpecification>
                          | <scopeOption> <simpleValueSpecification>

<dynamicCursorName> ::= <_cursor name> | <extendedCursorName>

<extendedCursorName> ::= <simpleValueSpecification>
                       | <scopeOption> <simpleValueSpecification>

<descriptorName> ::= <simpleValueSpecification>
                  | <scopeOption> <simpleValueSpecification>

<scopeOption> ~ <__GLOBAL> | <__LOCAL>

<_window name> ~ <__identifier>

#
# G1 Scalar expressions
# ---------------------
<dataType> ::=
		<predefinedType>
	|	<rowType>
	|	<pathResolvedUserDefinedTypeName>
	|	<referenceType>
	|	<collectionType>

<predefinedType> ::=
		<characterStringType>
	|	<characterStringType> <collateClause>
	|	<characterStringType> <CHARACTER> <SET> <_character set specification>
	|	<characterStringType> <CHARACTER> <SET> <_character set specification> <collateClause>
	|	<nationalCharacterStringType>
	|	<nationalCharacterStringType>  <collateClause>
	|	<binaryLargeObjectStringType>
	|	<numericType>
	|	<booleanType>
	|	<datetimeType>
	|	<intervalType>

<characterStringType> ::=
		<CHARACTER>
	|	<CHARACTER> <_left paren> <length> <_right paren>
	|	<CHAR>
	|	<CHAR> <_left paren> <length> <_right paren>
	|	<CHARACTER> <VARYING> <_left paren> <length> <_right paren>
	|	<CHAR> <VARYING> <_left paren> <length> <_right paren>
	|	<VARCHAR> <_left paren> <length> <_right paren>
	|	<CHARACTER> <LARGE> <OBJECT>
	|	<CHARACTER> <LARGE> <OBJECT> <_left paren> <largeObjectLength> <_right paren>
	|	<CHAR> <LARGE> <OBJECT>
	|	<CHAR> <LARGE> <OBJECT> <_left paren> <largeObjectLength> <_right paren>
	|	<CLOB>
	|	<CLOB> <_left paren> <largeObjectLength> <_right paren>

<nationalCharacterStringType> ::=
		<NATIONAL> <CHARACTER>
	|	<NATIONAL> <CHARACTER> <_left paren> <length> <_right paren>
	|	<NATIONAL> <CHAR>
	|	<NATIONAL> <CHAR> <_left paren> <length> <_right paren>
	|	<NCHAR>
	|	<NCHAR> <_left paren> <length> <_right paren>
	|	<NATIONAL> <CHARACTER> <VARYING> <_left paren> <length> <_right paren>
	|	<NATIONAL> <CHAR> <VARYING> <_left paren> <length> <_right paren>
	|	<NCHAR> <VARYING> <_left paren> <length> <_right paren>
	|	<NATIONAL> <CHARACTER> <LARGE> <OBJECT>
	|	<NATIONAL> <CHARACTER> <LARGE> <OBJECT> <_left paren> <largeObjectLength> <_right paren>
	|	<NCHAR> <LARGE> <OBJECT>
	|	<NCHAR> <LARGE> <OBJECT> <_left paren> <largeObjectLength> <_right paren>
	|	<NCLOB>
	|	<NCLOB> <_left paren> <largeObjectLength> <_right paren>

<binaryLargeObjectStringType> ::=
		<BINARY> <LARGE> <OBJECT>
	|	<BINARY> <LARGE> <OBJECT> <_left paren> <largeObjectLength> <_right paren>
	|	<BLOB>
	|	<BLOB> <_left paren> <largeObjectLength> <_right paren>

<numericType> ::= <exactNumericType> | <approximateNumericType>

<exactNumericType> ::=
		<NUMERIC>
	|	<NUMERIC> <_left paren> <precision>  <_right paren>
	|	<NUMERIC> <_left paren> <precision> <_comma> <scale> <_right paren>
	|	<DECIMAL>
	|	<DECIMAL> <_left paren> <precision> <_right paren>
	|	<DECIMAL> <_left paren> <precision> <_comma> <scale> <_right paren>
	|	<DEC>
	|	<DEC> <_left paren> <precision> <_right paren>
	|	<DEC> <_left paren> <precision> <_comma> <scale> <_right paren>
	|	<SMALLINT>
	|	<INTEGER>
	|	<INT>
	|	<BIGINT>

<approximateNumericType> ::=
		<FLOAT>
	|	<FLOAT> <_left paren> <precision> <_right paren>
	|	<REAL>
	|	<DOUBLE> <PRECISION>

<length> ::= <_unsigned integer>

<largeObjectLength> ::=
		<_unsigned integer>
	|	<_unsigned integer> <charLengthUnits>
	|	<_unsigned integer> <_multiplier>
	|	<_unsigned integer> <_multiplier> <charLengthUnits>
	|	<_large object length token>
	|	<_large object length token> <charLengthUnits>

<charLengthUnits> ::= <CHARACTERS> | <CODE_UNITS> | <OCTETS>

<precision> ::= <_unsigned integer>

<scale> ::= <_unsigned integer>

<booleanType> ::= <BOOLEAN>

<datetimeType> ::=
		<DATE>
	|	<TIME>
	|	<TIME> <withOrWithoutTimeZone>
	|	<TIME> <_left paren> <timePrecision> <_right paren>
	|	<TIME> <_left paren> <timePrecision> <_right paren> <withOrWithoutTimeZone>
	|	<TIMESTAMP>
	|	<TIMESTAMP> <withOrWithoutTimeZone>
	|	<TIMESTAMP> <_left paren> <timestampPrecision> <_right paren>
	|	<TIMESTAMP> <_left paren> <timestampPrecision> <_right paren> <withOrWithoutTimeZone>

<withOrWithoutTimeZone> ::= <WITH> <TIME> <ZONE> | <WITHOUT> <TIME> <ZONE>

<timePrecision> ::= <timeFractionalSecondsPrecision>

<timestampPrecision> ::= <timeFractionalSecondsPrecision>

<timeFractionalSecondsPrecision> ::= <_unsigned integer>

<intervalType> ::= <INTERVAL> <intervalQualifier>

<rowType> ::= <ROW> <rowTypeBody>

<fieldDefinitions> ::= <fieldDefinition>
                      | <fieldDefinitions> <_comma> <fieldDefinition>

<rowTypeBody> ::= <_left paren> <fieldDefinitions> <_right paren>

<referenceType> ::= <REF> <_left paren> <referencedType> <_right paren>
                   | <REF> <_left paren> <referencedType> <_right paren> <scopeClause>

<scopeClause> ::= <SCOPE> <_table name>

<referencedType> ::= <pathResolvedUserDefinedTypeName>

<pathResolvedUserDefinedTypeName> ::= <_user_defined type name>

<collectionType> ::= <arrayType> | <multisetType>

<arrayType> ::= <dataType> <ARRAY>
               | <dataType> <ARRAY> <_left bracket or trigraph> <_unsigned integer> <_right bracket or trigraph>

<multisetType> ::= <dataType> <MULTISET>

<fieldDefinition> ::= <fieldName> <dataType>
                     | <fieldName> <dataType> <referenceScopeCheck>

<valueExpressionPrimary> ::=
		<parenthesizedValueExpression>
	|	<nonparenthesizedValueExpressionPrimary>

<parenthesizedValueExpression> ::= <_left paren> <valueExpression> <_right paren>

<nonparenthesizedValueExpressionPrimary> ::=
		<unsignedValueSpecification>
	|	<columnReference>
	|	<setFunctionSpecification>
	|	<windowFunction>
	|	<scalarSubquery>
	|	<caseExpression>
	|	<castSpecification>
	|	<fieldReference>
	|	<subtypeTreatment>
	|	<methodInvocation>
	|	<staticMethodInvocation>
	|	<newSpecification>
	|	<attributeOrMethodReference>
	|	<referenceResolution>
	|	<collectionValueConstructor>
	|	<arrayElementReference>
	|	<multisetElementReference>
	|	<routineInvocation>
	|	<nextValueExpression>

<valueSpecification> ::= <literal> | <generalValueSpecification>

<unsignedValueSpecification> ::= <unsignedLiteral> | <generalValueSpecification>

<generalValueSpecification> ::=
		<hostParameterSpecification>
	|	<sqlParameterReference>
	|	<dynamicParameterSpecification>
	|	<embeddedVariableSpecification>
	|	<currentCollationSpecification>
	|	<CURRENT_DEFAULT_TRANSFORM_GROUP>
	|	<CURRENT_PATH>
	|	<CURRENT_ROLE>
	|	<CURRENT_TRANSFORM_GROUP_FOR_TYPE> <pathResolvedUserDefinedTypeName>
	|	<CURRENT_USER>
	|	<SESSION_USER>
	|	<SYSTEM_USER>
	|	<USER>
	|	<VALUE>

<simpleValueSpecification> ::=
		<literal>
	|	<_host parameter name>
	|	<sqlParameterReference>
	|	<_embedded variable name>

<targetSpecification> ::=
		<hostParameterSpecification>
	|	<sqlParameterReference>
	|	<columnReference>
	|	<targetArrayElementSpecification>
	|	<dynamicParameterSpecification>
	|	<embeddedVariableSpecification>

<simpleTargetSpecification> ::=
		<hostParameterSpecification>
	|	<sqlParameterReference>
	|	<columnReference>
	|	<_embedded variable name>

<hostParameterSpecification> ::= <_host parameter name>
                                 | <_host parameter name> <indicatorParameter>

<dynamicParameterSpecification> ::= <_question mark>

<embeddedVariableSpecification> ::= <_embedded variable name>
                                    | <_embedded variable name> <indicatorVariable>

<indicatorVariable> ::= <_embedded variable name>
                       | <INDICATOR> <_embedded variable name>

<indicatorParameter> ::= <_host parameter name>
                        | <INDICATOR> <_host parameter name>

<targetArrayElementSpecification> ::=
		<targetArrayReference> <_left bracket or trigraph> <simpleValueSpecification> <_right bracket or trigraph> 

<targetArrayReference> ::= <sqlParameterReference> | <columnReference>

<currentCollationSpecification> ::= <CURRENT_COLLATION> <_left paren> <stringValueExpression> <_right paren>

<contextuallyTypedValueSpecification> ::=
		<implicitlyTypedValueSpecification> | <defaultSpecification>

<implicitlyTypedValueSpecification> ::= <nullSpecification> | <emptySpecification>

<nullSpecification> ::= <NULL>

<emptySpecification> ::=
		<ARRAY> <_left bracket or trigraph> <_right bracket or trigraph>
	|	<MULTISET> <_left bracket or trigraph> <_right bracket or trigraph>

<defaultSpecification> ::= <DEFAULT>

<__identifier chain> ~ <__identifier>
                     | <__identifier chain> <__period> <__identifier>

<__basic identifier chain> ~ <__identifier chain>
<_basic identifier chain> ~ <__basic identifier chain>

<columnReference> ~
		<__basic identifier chain>
	|	<__MODULE> <__period> <__qualified identifier> <__period> <__column name>

<sqlParameterReference> ::= <_basic identifier chain>

<setFunctionSpecification> ::= <aggregateFunction> | <groupingOperation>

<columnReferenceChain> ::= <columnReference>
                           | <columnReferenceChain> <_comma> <columnReference>
<groupingOperation> ::= <GROUPING> <_left paren> <columnReferenceChain> <_right paren>

<windowFunction> ::= <windowFunctionType> <OVER> <windowNameOrSpecification>

<windowFunctionType> ::=
		<rankFunctionType> <_left paren> <_right paren>
	|	<ROW_NUMBER> <_left paren> <_right paren>
	|	<aggregateFunction>

<rankFunctionType> ::= <RANK> | <DENSE_RANK> | <PERCENT_RANK> | <CUME_DIST>

<windowNameOrSpecification> ::= <_window name> | <inLineWindowSpecification>

<inLineWindowSpecification> ::= <windowSpecification>

<caseExpression> ::= <caseAbbreviation> | <caseSpecification>

<commaAndValueExpression> ::= <_comma> <valueExpression>

<commaAndValueExpressionMany> ::= <commaAndValueExpression>+

<caseAbbreviation> ::=
		<NULLIF> <_left paren> <valueExpression> <_comma> <valueExpression> <_right paren>
	|	<COALESCE> <_left paren> <valueExpression> <commaAndValueExpressionMany> <_right paren>

<caseSpecification> ::= <simpleCase> | <searchedCase>

<simpleWhenClauseMany> ::= <simpleWhenClause>+

<simpleCase> ::= <CASE> <caseOperand> <simpleWhenClauseMany> <END>
                | <CASE> <caseOperand> <simpleWhenClauseMany> <elseClause> <END>

<searchedWhenClauseMany> ::= <searchedWhenClause>+

<searchedCase> ::= <CASE> <searchedWhenClauseMany> <END>
                  | <CASE> <searchedWhenClauseMany> <elseClause> <END>

<simpleWhenClause> ::= <WHEN> <whenOperand> <THEN> <result>

<searchedWhenClause> ::= <WHEN> <searchCondition> <THEN> <result>

<elseClause> ::= <ELSE> <result>

<caseOperand> ::= <rowValuePredicand> | <overlapsPredicatePart1>

<whenOperand> ::=
		<rowValuePredicand>
	|	<comparisonPredicatePart2>
	|	<betweenPredicatePart2>
	|	<inPredicatePart2>
	|	<characterLikePredicatePart2>
	|	<octetLikePredicatePart2>
	|	<similarPredicatePart2>
	|	<nullPredicatePart2>
	|	<quantifiedComparisonPredicatePart2>
	|	<matchPredicatePart2>
	|	<overlapsPredicatePart2>
	|	<distinctPredicatePart2>
	|	<memberPredicatePart2>
	|	<submultisetPredicatePart2>
	|	<setPredicatePart2>
	|	<typePredicatePart2>

<result> ::= <resultExpression> | <NULL>

<resultExpression> ::= <valueExpression>

<castSpecification> ::= <CAST> <_left paren> <castOperand> <AS> <castTarget> <_right paren>

<castOperand> ::= <valueExpression> | <implicitlyTypedValueSpecification>

<castTarget> ::= <_domain name> | <dataType>

<nextValueExpression> ::= <NEXT> <VALUE> <FOR> <sequenceGeneratorName>

<fieldReference> ::= <valueExpressionPrimary> <_period> <fieldName>

<subtypeTreatment> ::=	<TREAT> <_left paren> <subtypeOperand> <AS> <targetSubtype> <_right paren>

<subtypeOperand> ::= <valueExpression>

<targetSubtype> ::=
		<pathResolvedUserDefinedTypeName>
	|	<referenceType>

<methodInvocation> ::= <directInvocation> | <generalizedInvocation>

<directInvocation> ::=	<valueExpressionPrimary> <_period> <_method name>
                      | <valueExpressionPrimary> <_period> <_method name> <sqlArgumentList>

<generalizedInvocation> ::= <_left paren> <valueExpressionPrimary> <AS> <dataType> <_right paren> <_period> <_method name>
                           | <_left paren> <valueExpressionPrimary> <AS> <dataType> <_right paren> <_period> <_method name> <sqlArgumentList>

<staticMethodInvocation> ::= <pathResolvedUserDefinedTypeName> <_double colon> <_method name>
                             | <pathResolvedUserDefinedTypeName> <_double colon> <_method name> <sqlArgumentList>

<newSpecification> ::= <NEW> <routineInvocation>

<attributeOrMethodReference> ::= <valueExpressionPrimary> <dereferenceOperator> <_qualified identifier>
                                  | <valueExpressionPrimary> <dereferenceOperator> <_qualified identifier> <sqlArgumentList>

<dereferenceOperator> ::= <_right arrow>

<referenceResolution> ::= <DEREF> <_left paren> <referenceValueExpression> <_right paren>

<arrayElementReference> ::= <arrayValueExpression> <_left bracket or trigraph> <numericValueExpression> <_right bracket or trigraph> 

<multisetElementReference> ::= <ELEMENT> <_left paren> <multisetValueExpression> <_right paren>

<valueExpression> ::=
		<commonValueExpression>
	|	<booleanValueExpression>
	|	<rowValueExpression>

<commonValueExpression> ::=
		<numericValueExpression>
	|	<stringValueExpression>
	|	<datetimeValueExpression>
	|	<intervalValueExpression>
	|	<userDefinedTypeValueExpression>
	|	<referenceValueExpression>
	|	<collectionValueExpression>

<userDefinedTypeValueExpression> ::= <valueExpressionPrimary>

<referenceValueExpression> ::= <valueExpressionPrimary>

<collectionValueExpression> ::= <arrayValueExpression> | <multisetValueExpression>

<collectionValueConstructor> ::= <arrayValueConstructor> | <multisetValueConstructor>

<numericValueExpression> ::=
		<term>
	|	<numericValueExpression> <_plus sign> <term>
	|	<numericValueExpression> <_minus sign> <term>

<term> ::=
		<factor>
	|	<term> <_asterisk> <factor>
	|	<term> <_solidus> <factor>

<factor> ::= <numericPrimary>
           | <_sign> <numericPrimary>

<numericPrimary> ::=
		<valueExpressionPrimary>
	|	<numericValueFunction>

<numericValueFunction> ::=
		<positionExpression>
	|	<extractExpression>
	|	<lengthExpression>
	|	<cardinalityExpression>
	|	<absoluteValueExpression>
	|	<modulusExpression>
	|	<naturalLogarithm>
	|	<exponentialFunction>
	|	<powerFunction>
	|	<squareRoot>
	|	<floorFunction>
	|	<ceilingFunction>
	|	<widthBucketFunction>

<positionExpression> ::=
		<stringPositionExpression>
	|	<blobPositionExpression>

<stringPositionExpression> ::= <POSITION> <_left paren> <stringValueExpression> <IN> <stringValueExpression>                             <_right paren>
                               | <POSITION> <_left paren> <stringValueExpression> <IN> <stringValueExpression> <USING> <charLengthUnits> <_right paren>

<blobPositionExpression> ::= <POSITION> <_left paren> <blobValueExpression> <IN> <blobValueExpression> <_right paren>

<lengthExpression> ::=
		<charLengthExpression>
	|	<octetLengthExpression>

<charLengthExpression> ::= <CHAR_LENGTH>      <_left paren> <stringValueExpression>                             <_right paren>
                           | <CHAR_LENGTH>      <_left paren> <stringValueExpression> <USING> <charLengthUnits> <_right paren>
                           | <CHARACTER_LENGTH> <_left paren> <stringValueExpression>                             <_right paren>
                           | <CHARACTER_LENGTH> <_left paren> <stringValueExpression> <USING> <charLengthUnits> <_right paren>

<octetLengthExpression> ::= <OCTET_LENGTH> <_left paren> <stringValueExpression> <_right paren>

<extractExpression> ::= <EXTRACT> <_left paren> <extractField> <FROM> <extractSource> <_right paren>

<extractField> ::= <primaryDatetimeField> | <timeZoneField>

<timeZoneField> ::= <TIMEZONE_HOUR> | <TIMEZONE_MINUTE>

<extractSource> ::= <datetimeValueExpression> | <intervalValueExpression>

<cardinalityExpression> ::= <CARDINALITY> <_left paren> <collectionValueExpression> <_right paren>

<absoluteValueExpression> ::= <ABS> <_left paren> <numericValueExpression> <_right paren>

<modulusExpression> ::= <MOD> <_left paren> <numericValueExpressionDividend> <_comma> <numericValueExpressionDivisor><_right paren>

<numericValueExpressionDividend> ::= <numericValueExpression>

<numericValueExpressionDivisor> ::= <numericValueExpression>

<naturalLogarithm> ::= <LN> <_left paren> <numericValueExpression> <_right paren>

<exponentialFunction> ::= <EXP> <_left paren> <numericValueExpression> <_right paren>

<powerFunction> ::= <POWER> <_left paren> <numericValueExpressionBase> <_comma> <numericValueExpressionExponent> <_right paren>

<numericValueExpressionBase> ::= <numericValueExpression>

<numericValueExpressionExponent> ::= <numericValueExpression>

<squareRoot> ::= <SQRT> <_left paren> <numericValueExpression> <_right paren>

<floorFunction> ::= <FLOOR> <_left paren> <numericValueExpression> <_right paren>

<ceilingFunction> ::= <CEIL>    <_left paren> <numericValueExpression> <_right paren>
                     | <CEILING> <_left paren> <numericValueExpression> <_right paren>

<widthBucketFunction> ::= <WIDTH_BUCKET> <_left paren> <widthBucketOperand> <_comma> <widthBucketBound1> <_comma> <widthBucketBound2> <_comma> <widthBucketCount> <_right paren>

<widthBucketOperand> ::= <numericValueExpression>

<widthBucketBound1> ::= <numericValueExpression>

<widthBucketBound2> ::= <numericValueExpression>

<widthBucketCount> ::= <numericValueExpression>

<stringValueExpression> ::= <characterValueExpression> | <blobValueExpression>

<characterValueExpression> ::= <concatenation> | <characterFactor>

<concatenation> ::= <characterValueExpression> <_concatenation operator> <characterFactor>

<characterFactor> ::= <characterPrimary>
                     | <characterPrimary> <collateClause>

<characterPrimary> ::= <valueExpressionPrimary> | <stringValueFunction>

<blobValueExpression> ::= <blobConcatenation> | <blobFactor>

<blobFactor> ::= <blobPrimary>

<blobPrimary> ::= <valueExpressionPrimary> | <stringValueFunction>

<blobConcatenation> ::= <blobValueExpression> <_concatenation operator> <blobFactor>

<stringValueFunction> ::= <characterValueFunction> | <blobValueFunction>

<characterValueFunction> ::=
		<characterSubstringFunction>
	|	<regularExpressionSubstringFunction>
	|	<fold>
	|	<transcoding>
	|	<characterTransliteration>
	|	<trimFunction>
	|	<characterOverlayFunction>
	|	<normalizeFunction>
	|	<specificTypeMethod>

<characterSubstringFunction> ::= <SUBSTRING> <_left paren> <characterValueExpression> <FROM> <startPosition> <_right paren>
                                 | <SUBSTRING> <_left paren> <characterValueExpression> <FROM> <startPosition> <FOR> <stringLength> <_right paren>
                                 | <SUBSTRING> <_left paren> <characterValueExpression> <FROM> <startPosition> <USING> <charLengthUnits> <_right paren>
                                 | <SUBSTRING> <_left paren> <characterValueExpression> <FROM> <startPosition> <FOR> <stringLength> <USING> <charLengthUnits> <_right paren>

<regularExpressionSubstringFunction> ::=
		<SUBSTRING> <_left paren> <characterValueExpression>
		<SIMILAR> <characterValueExpression> <ESCAPE> <_escape character> <_right paren>

<fold> ::= <UPPER> <_left paren> <characterValueExpression> <_right paren>
         | <LOWER> <_left paren> <characterValueExpression> <_right paren>

<transcoding> ::= <CONVERT> <_left paren> <characterValueExpression> <USING> <transcodingName> <_right paren>

<characterTransliteration> ::= <TRANSLATE> <_left paren> <characterValueExpression> <USING> <transliterationName> <_right paren>

<trimFunction> ::= <TRIM> <_left paren> <trimOperands> <_right paren>

<trimOperands> ::= <trimSource>
                  | <FROM> <trimSource>
                  | <trimSpecification> <FROM> <trimSource>
                  | <trimCharacter> <FROM> <trimSource>
                  | <trimSpecification> <trimCharacter> <FROM> <trimSource>

<trimSource> ::= <characterValueExpression>

<trimSpecification> ::= <LEADING> | <TRAILING> | <BOTH>

<trimCharacter> ::= <characterValueExpression>

<characterOverlayFunction> ::=
    <OVERLAY> <_left paren> <characterValueExpression> <PLACING> <characterValueExpression> <FROM> <startPosition>                                                   <_right paren>
 |  <OVERLAY> <_left paren> <characterValueExpression> <PLACING> <characterValueExpression> <FROM> <startPosition> <FOR> <stringLength>                             <_right paren>
 |  <OVERLAY> <_left paren> <characterValueExpression> <PLACING> <characterValueExpression> <FROM> <startPosition>                       <USING> <charLengthUnits> <_right paren>
 |  <OVERLAY> <_left paren> <characterValueExpression> <PLACING> <characterValueExpression> <FROM> <startPosition> <FOR> <stringLength> <USING> <charLengthUnits> <_right paren>

<normalizeFunction> ::= <NORMALIZE> <_left paren> <characterValueExpression> <_right paren>

<specificTypeMethod> ::= <userDefinedTypeValueExpression> <_period> <SPECIFICTYPE>

<blobValueFunction> ::=
		<blobSubstringFunction>
	|	<blobTrimFunction>
	|	<blobOverlayFunction>

<blobSubstringFunction> ::=
		<SUBSTRING> <_left paren> <blobValueExpression> <FROM> <startPosition>                       <_right paren>
	|	<SUBSTRING> <_left paren> <blobValueExpression> <FROM> <startPosition> <FOR> <stringLength> <_right paren>

<blobTrimFunction> ::= <TRIM> <_left paren> <blobTrimOperands> <_right paren>

<blobTrimOperands> ::=                                          <blobTrimSource>
                       |                                   <FROM> <blobTrimSource>
                       | <trimSpecification>              <FROM> <blobTrimSource>
                       |                      <trimOctet> <FROM> <blobTrimSource>
                       | <trimSpecification> <trimOctet> <FROM> <blobTrimSource>

<blobTrimSource> ::= <blobValueExpression>

<trimOctet> ::= <blobValueExpression>

<blobOverlayFunction> ::=
		<OVERLAY> <_left paren> <blobValueExpression> <PLACING> <blobValueExpression> <FROM> <startPosition> <FOR> <stringLength> <_right paren>
	|	<OVERLAY> <_left paren> <blobValueExpression> <PLACING> <blobValueExpression> <FROM> <startPosition>                       <_right paren>

<startPosition> ::= <numericValueExpression>

<stringLength> ::= <numericValueExpression>

<datetimeValueExpression> ::=
		<datetimeTerm>
	|	<intervalValueExpression> <_plus sign> <datetimeTerm>
	|	<datetimeValueExpression> <_plus sign> <intervalTerm>
	|	<datetimeValueExpression> <_minus sign> <intervalTerm>

<datetimeTerm> ::= <datetimeFactor>

<datetimeFactor> ::= <datetimePrimary>
                    | <datetimePrimary> <timeZone>

<datetimePrimary> ::= <valueExpressionPrimary> | <datetimeValueFunction>

<timeZone> ::= <AT> <timeZoneSpecifier>

<timeZoneSpecifier> ::= <LOCAL> | <TIME> <ZONE> <intervalPrimary>

<datetimeValueFunction> ::=
		<currentDateValueFunction>
	|	<currentTimeValueFunction>
	|	<currentTimestampValueFunction>
	|	<currentLocalTimeValueFunction>
	|	<currentLocalTimestampValueFunction>

<currentDateValueFunction> ::= <CURRENT_DATE>

<currentTimeValueFunction> ::= <CURRENT_TIME>
                                | <CURRENT_TIME> <_left paren> <timePrecision> <_right paren>

<currentLocalTimeValueFunction> ::= <LOCALTIME>
                                      | <LOCALTIME> <_left paren> <timePrecision> <_right paren>

<currentTimestampValueFunction> ::= <CURRENT_TIMESTAMP>
                                     | <CURRENT_TIMESTAMP> <_left paren> <timestampPrecision> <_right paren>

<currentLocalTimestampValueFunction> ::= <LOCALTIMESTAMP>
                                           | <LOCALTIMESTAMP> <_left paren> <timestampPrecision> <_right paren>

<intervalValueExpression> ::=
		<intervalTerm>
	|	<intervalValueExpression1> <_plus sign> <intervalTerm1>
	|	<intervalValueExpression1> <_minus sign> <intervalTerm1>
	|	<_left paren> <datetimeValueExpression> <_minus sign> <datetimeTerm> <_right paren> <intervalQualifier>

<intervalTerm> ::=
		<intervalFactor>
	|	<intervalTerm2> <_asterisk> <factor>
	|	<intervalTerm2> <_solidus> <factor>
	|	<term> <_asterisk> <intervalFactor>

<intervalFactor> ::= <intervalPrimary>
                    | <_sign> <intervalPrimary>

<intervalPrimary> ::=
		<valueExpressionPrimary>
	|	<valueExpressionPrimary> <intervalQualifier>
	|	<intervalValueFunction>

<intervalValueExpression1> ::= <intervalValueExpression>

<intervalTerm1> ::= <intervalTerm>

<intervalTerm2> ::= <intervalTerm>

<intervalValueFunction> ::= <intervalAbsoluteValueFunction>

<intervalAbsoluteValueFunction> ::= <ABS> <_left paren> <intervalValueExpression> <_right paren>

<booleanValueExpression> ::=
		<booleanTerm>
	|	<booleanValueExpression> <OR> <booleanTerm>

<booleanTerm> ::=
		<booleanFactor>
	|	<booleanTerm> <AND> <booleanFactor>

<booleanFactor> ::= <booleanTest>
                   | <NOT> <booleanTest>

<booleanTest> ::= <booleanPrimary>
                 | <booleanPrimary> <IS> <truthValue>
                 | <booleanPrimary> <IS> <NOT> <truthValue>

<truthValue> ::= <TRUE> | <FALSE> | <UNKNOWN>

<booleanPrimary> ::= <predicate> | <booleanPredicand>

<booleanPredicand> ::=
		<parenthesizedBooleanValueExpression>
	|	<nonparenthesizedValueExpressionPrimary>

<parenthesizedBooleanValueExpression> ::= <_left paren> <booleanValueExpression> <_right paren>

<arrayValueExpression> ::= <arrayConcatenation> | <arrayFactor>

<arrayConcatenation> ::= <arrayValueExpression1> <_concatenation operator> <arrayFactor>

<arrayValueExpression1> ::= <arrayValueExpression>

<arrayFactor> ::= <valueExpressionPrimary>

<arrayValueConstructor> ::=
		<arrayValueConstructorByEnumeration>
	|	<arrayValueConstructorByQuery>

<arrayValueConstructorByEnumeration> ::=
		<ARRAY> <_left bracket or trigraph> <arrayElementList> <_right bracket or trigraph>

<arrayElementList> ::= <arrayElement>
                       | <arrayElementList> <_comma> <arrayElement>

<arrayElement> ::= <valueExpression>

<arrayValueConstructorByQuery> ::= <ARRAY> <_left paren> <queryExpression> <_right paren>
                                     | <ARRAY> <_left paren> <queryExpression> <orderByClause> <_right paren>

<multisetValueExpression> ::=
		<multisetTerm>
	|	<multisetValueExpression> <MULTISET> <UNION>             <multisetTerm>
	|	<multisetValueExpression> <MULTISET> <UNION> <ALL>       <multisetTerm>
	|	<multisetValueExpression> <MULTISET> <UNION> <DISTINCT>  <multisetTerm>
	|	<multisetValueExpression> <MULTISET> <EXCEPT>            <multisetTerm>
	|	<multisetValueExpression> <MULTISET> <EXCEPT> <ALL>      <multisetTerm>
	|	<multisetValueExpression> <MULTISET> <EXCEPT> <DISTINCT> <multisetTerm>

<multisetTerm> ::=
		<multisetPrimary>
	|	<multisetTerm> <MULTISET> <INTERSECT>            <multisetPrimary>
	|	<multisetTerm> <MULTISET> <INTERSECT> <ALL>      <multisetPrimary>
	|	<multisetTerm> <MULTISET> <INTERSECT> <DISTINCT> <multisetPrimary>

<multisetPrimary> ::= <multisetValueFunction> | <valueExpressionPrimary>

<multisetValueFunction> ::= <multisetSetFunction>

<multisetSetFunction> ::= <SET> <_left paren> <multisetValueExpression> <_right paren>

<multisetValueConstructor> ::=
		<multisetValueConstructorByEnumeration>
	|	<multisetValueConstructorByQuery>
	|	<tableValueConstructorByQuery>

<multisetValueConstructorByEnumeration> ::= <MULTISET> <_left bracket or trigraph> <multisetElementList> <_right bracket or trigraph>

<multisetElementList> ::= <multisetElement>
                          | <multisetElementList> <_comma> <multisetElement>

<multisetElement> ::= <valueExpression>

<multisetValueConstructorByQuery> ::= <MULTISET> <_left paren> <queryExpression> <_right paren>

<tableValueConstructorByQuery> ::= <TABLE> <_left paren> <queryExpression> <_right paren>

<rowValueConstructor> ::=
		<commonValueExpression>
	|	<booleanValueExpression>
	|	<explicitRowValueConstructor>

<explicitRowValueConstructor> ::=
		<_left paren> <rowValueConstructorElement> <_comma> <rowValueConstructorElementList> <_right paren>
	|	<ROW> <_left paren> <rowValueConstructorElementList> <_right paren>
	|	<rowSubquery>

<rowValueConstructorElementList> ::= <rowValueConstructorElement>
                                       | <rowValueConstructorElementList> <_comma> <rowValueConstructorElement>

<rowValueConstructorElement> ::= <valueExpression>

<contextuallyTypedRowValueConstructor> ::=
		<commonValueExpression>
	|	<booleanValueExpression>
	|	<contextuallyTypedValueSpecification>
	|	<_left paren> <contextuallyTypedRowValueConstructorElement> <_comma> <contextuallyTypedRowValueConstructorElementList> <_right paren>
	|	<ROW> <_left paren> <contextuallyTypedRowValueConstructorElementList> <_right paren>

<contextuallyTypedRowValueConstructorElementList> ::= <contextuallyTypedRowValueConstructorElement>
                                                          | <contextuallyTypedRowValueConstructorElementList> <_comma> <contextuallyTypedRowValueConstructorElement>

<contextuallyTypedRowValueConstructorElement> ::=
		<valueExpression>
	|	<contextuallyTypedValueSpecification>

<rowValueConstructorPredicand> ::=
		<commonValueExpression>
	|	<booleanPredicand>
	|	<explicitRowValueConstructor>

<rowValueExpression> ::=
		<rowValueSpecialCase>
	|	<explicitRowValueConstructor>

<tableRowValueExpression> ::=
		<rowValueSpecialCase>
	|	<rowValueConstructor>

<contextuallyTypedRowValueExpression> ::=
		<rowValueSpecialCase>
	|	<contextuallyTypedRowValueConstructor>

<rowValuePredicand> ::=
		<rowValueSpecialCase>
	|	<rowValueConstructorPredicand>

<rowValueSpecialCase> ::= <nonparenthesizedValueExpressionPrimary>

<tableValueConstructor> ::= <VALUES> <rowValueExpressionList>

<rowValueExpressionList> ::= <tableRowValueExpression>
                              | <rowValueExpressionList> <_comma> <tableRowValueExpression>

<contextuallyTypedTableValueConstructor> ::= <VALUES> <contextuallyTypedRowValueExpressionList>

<contextuallyTypedRowValueExpressionList> ::= <contextuallyTypedRowValueExpression>
                                                 | <contextuallyTypedRowValueExpressionList> <_comma> <contextuallyTypedRowValueExpression>

<tableExpression> ::= <fromClause>
	|	<fromClause> <whereClause>
	|	<fromClause> <whereClause> <groupByClause>
	|	<fromClause> <whereClause> <groupByClause> <havingClause>
	|	<fromClause> <whereClause> <groupByClause> <havingClause> <windowClause>
	|	<fromClause> <whereClause> <groupByClause> <windowClause>
	|	<fromClause> <whereClause> <havingClause>
	|	<fromClause> <whereClause> <havingClause> <windowClause>
	|	<fromClause> <whereClause> <windowClause>
	|	<fromClause> <groupByClause>
	|	<fromClause> <groupByClause> <havingClause>
	|	<fromClause> <groupByClause> <havingClause> <windowClause>
	|	<fromClause> <groupByClause> <windowClause>
	|	<fromClause> <havingClause>
	|	<fromClause> <havingClause> <windowClause>
	|	<fromClause> <windowClause>

<fromClause> ::= <FROM> <tableReferenceList>

<tableReferenceList> ::= <tableReference>
                         | <tableReferenceList> <_comma> <tableReference>

<tableReference> ::= <tablePrimaryOrJoinedTable>
                    | <tablePrimaryOrJoinedTable> <sampleClause>

<tablePrimaryOrJoinedTable> ::= <tablePrimary> | <joinedTable>

<sampleClause> ::= <TABLESAMPLE> <sampleMethod> <_left paren> <samplePercentage> <_right paren>
                  | <TABLESAMPLE> <sampleMethod> <_left paren> <samplePercentage> <_right paren> <repeatableClause>

<sampleMethod> ::= <BERNOULLI> | <SYSTEM>

<repeatableClause> ::= <REPEATABLE> <_left paren> <repeatArgument> <_right paren>

<samplePercentage> ::= <numericValueExpression>

<repeatArgument> ::= <numericValueExpression>

<tablePrimary> ::=
		<tableOrQueryName>
	|	<tableOrQueryName>      <_correlation name>
	|	<tableOrQueryName>      <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<tableOrQueryName> <AS> <_correlation name>
	|	<tableOrQueryName> <AS> <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<derivedTable>      <_correlation name>
	|	<derivedTable>      <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<derivedTable> <AS> <_correlation name>
	|	<derivedTable> <AS> <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<lateralDerivedTable>      <_correlation name>
	|	<lateralDerivedTable>      <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<lateralDerivedTable> <AS> <_correlation name>
	|	<lateralDerivedTable> <AS> <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<collectionDerivedTable>      <_correlation name>
	|	<collectionDerivedTable>      <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<collectionDerivedTable> <AS> <_correlation name>
	|	<collectionDerivedTable> <AS> <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<tableFunctionDerivedTable>      <_correlation name>
	|	<tableFunctionDerivedTable>      <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<tableFunctionDerivedTable> <AS> <_correlation name>
	|	<tableFunctionDerivedTable> <AS> <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<onlySpec>
	|	<onlySpec>      <_correlation name>
	|	<onlySpec>      <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<onlySpec> <AS> <_correlation name>
	|	<onlySpec> <AS> <_correlation name> <_left paren> <derivedColumnList> <_right paren>
	|	<_left paren> <joinedTable> <_right paren>

<onlySpec> ::= <ONLY> <_left paren> <tableOrQueryName> <_right paren>

<lateralDerivedTable> ::= <LATERAL> <tableSubquery>

<collectionDerivedTable> ::= <UNNEST> <_left paren> <collectionValueExpression> <_right paren>
                             | <UNNEST> <_left paren> <collectionValueExpression> <_right paren> <WITH> <ORDINALITY>

<tableFunctionDerivedTable> ::= <TABLE> <_left paren> <collectionValueExpression> <_right paren>

<derivedTable> ::= <tableSubquery>

<tableOrQueryName> ::= <_table name> | <_query name>

<derivedColumnList> ::= <columnNameList>

<columnNameList> ::= <_column name>
                     | <columnNameList> <_comma> <_column name>

<joinedTable> ::=
		<crossJoin>
	|	<qualifiedJoin>
	|	<naturalJoin>
	|	<unionJoin>

<crossJoin> ::= <tableReference> <CROSS> <JOIN> <tablePrimary>

<qualifiedJoin> ::= <tableReference>             <JOIN> <tableReference> <joinSpecification>
                   | <tableReference> <joinType> <JOIN> <tableReference> <joinSpecification>

<naturalJoin> ::= <tableReference> <NATURAL>             <JOIN> <tablePrimary>
                 | <tableReference> <NATURAL> <joinType> <JOIN> <tablePrimary>

<unionJoin> ::= <tableReference> <UNION> <JOIN> <tablePrimary>

<joinSpecification> ::= <joinCondition> | <namedColumnsJoin>

<joinCondition> ::= <ON> <searchCondition>

<namedColumnsJoin> ::= <USING> <_left paren> <joinColumnList> <_right paren>

<joinType> ::= <INNER>
              | <outerJoinType>
              | <outerJoinType> <OUTER>

<outerJoinType> ::= <LEFT> | <RIGHT> | <FULL>

<joinColumnList> ::= <columnNameList>

<whereClause> ::= <WHERE> <searchCondition>

<groupByClause> ::= <GROUP> <BY>                  <groupingElementList>
                    | <GROUP> <BY> <setQuantifier> <groupingElementList>

<groupingElementList> ::= <groupingElement>
                          | <groupingElementList> <_comma> <groupingElement>

<groupingElement> ::=
		<ordinaryGroupingSet>
	|	<rollupList>
	|	<cubeList>
	|	<groupingSetsSpecification>
	|	<emptyGroupingSet>

<ordinaryGroupingSet> ::=
		<groupingColumnReference>
	|	<_left paren> <groupingColumnReferenceList> <_right paren>

<groupingColumnReference> ::= <columnReference>
                              | <columnReference> <collateClause>

<groupingColumnReferenceList> ::= <groupingColumnReference>
                                   | <groupingColumnReferenceList> <_comma> <groupingColumnReference>

<rollupList> ::= <ROLLUP> <_left paren> <ordinaryGroupingSetList> <_right paren>

<ordinaryGroupingSetList> ::= <ordinaryGroupingSet>
                               | <ordinaryGroupingSetList> <_comma> <ordinaryGroupingSet>

<cubeList> ::= <CUBE> <_left paren> <ordinaryGroupingSetList> <_right paren>

<groupingSetsSpecification> ::= <GROUPING> <SETS> <_left paren> <groupingSetList> <_right paren>

<groupingSetList> ::= <groupingSet>
                      | <groupingSetList> <_comma> <groupingSet>

<groupingSet> ::=
		<ordinaryGroupingSet>
	|	<rollupList>
	|	<cubeList>
	|	<groupingSetsSpecification>
	|	<emptyGroupingSet>

<emptyGroupingSet> ::= <_left paren> <_right paren>

<havingClause> ::= <HAVING> <searchCondition>

<windowClause> ::= <WINDOW> <windowDefinitionList>

<windowDefinitionList> ::= <windowDefinition>
                           | <windowDefinitionList> <_comma> <windowDefinition>

<windowDefinition> ::= <newWindowName> <AS> <windowSpecification>

<newWindowName> ::= <_window name>

#
# Little grammar deviation: I make <windowSpecificationDetails> explicitely optional in <windowSpecification> 
#
<windowSpecification> ::= <_left paren> <_right paren>
                         | <_left paren> <windowSpecificationDetails> <_right paren>

<windowSpecificationDetails> ::=
		<existingWindowName>
	|	<existingWindowName> <windowPartitionClause>
	|	<existingWindowName> <windowPartitionClause> <windowOrderClause>
	|	<existingWindowName> <windowPartitionClause> <windowOrderClause> <windowFrameClause>
	|	<existingWindowName> <windowPartitionClause> <windowFrameClause>
	|	<existingWindowName> <windowOrderClause>
	|	<existingWindowName> <windowOrderClause> <windowFrameClause>
	|	<existingWindowName> <windowFrameClause>
	|	<windowPartitionClause>
	|	<windowPartitionClause> <windowOrderClause>
	|	<windowPartitionClause> <windowOrderClause> <windowFrameClause>
	|	<windowPartitionClause> <windowFrameClause>
	|	<windowOrderClause>
	|	<windowOrderClause> <windowFrameClause>
	|	<windowFrameClause>

<existingWindowName> ::= <_window name>

<windowPartitionClause> ::= <PARTITION> <BY> <windowPartitionColumnReferenceList>

<windowPartitionColumnReferenceList> ::= <windowPartitionColumnReference>
                                           | <windowPartitionColumnReferenceList> <_comma> <windowPartitionColumnReference>

<windowPartitionColumnReference> ::= <columnReference>
                                      | <columnReference> <collateClause>

<windowOrderClause> ::= <ORDER> <BY> <sortSpecificationList>

<windowFrameClause> ::= <windowFrameUnits> <windowFrameExtent>
                        | <windowFrameUnits> <windowFrameExtent> <windowFrameExclusion>

<windowFrameUnits> ::= <ROWS> | <RANGE>

<windowFrameExtent> ::= <windowFrameStart> | <windowFrameBetween>

<windowFrameStart> ::= <UNBOUNDED> <PRECEDING> | <windowFramePreceding> | <CURRENT> <ROW>

<windowFramePreceding> ::= <unsignedValueSpecification> <PRECEDING>

<windowFrameBetween> ::= <BETWEEN> <windowFrameBound1> <AND> <windowFrameBound2>

<windowFrameBound1> ::= <windowFrameBound>

<windowFrameBound2> ::= <windowFrameBound>

<windowFrameBound> ::=
		<windowFrameStart>
	|	<UNBOUNDED> <FOLLOWING>
	|	<windowFrameFollowing>

<windowFrameFollowing> ::= <unsignedValueSpecification> <FOLLOWING>

<windowFrameExclusion> ::=
		<EXCLUDE> <CURRENT> <ROW>
	|	<EXCLUDE> <GROUP>
	|	<EXCLUDE> <TIES>
	|	<EXCLUDE> <NO> <OTHERS>

<querySpecification> ::= <SELECT>                  <selectList> <tableExpression>
                        | <SELECT> <setQuantifier> <selectList> <tableExpression>

#
# I create a <selectSublistList> explicit sequence here
#
<selectSublistList> ::= <selectSublist>
                        | <selectSublistList> <_comma> <selectSublist>

<selectList> ::= <_asterisk> | <selectSublistList>

<selectSublist> ::= <derivedColumn> | <qualifiedAsterisk>

<qualifiedAsterisk> ::=
		<asteriskedIdentifierChain> <_period> <_asterisk>
	|	<allFieldsReference>

<asteriskedIdentifierChain> ::= <asteriskedIdentifier>
                                | <asteriskedIdentifierChain> <_period> <asteriskedIdentifier>

<asteriskedIdentifier> ::= <_identifier>

<derivedColumn> ::= <valueExpression>
                   | <valueExpression> <asClause>

<asClause> ::=      <_column name>
              | <AS> <_column name>

<allFieldsReference> ::= <valueExpressionPrimary> <_period> <_asterisk>
                         | <valueExpressionPrimary> <_period> <_asterisk> <AS> <_left paren> <allFieldsColumnNameList> <_right paren>

<allFieldsColumnNameList> ::= <columnNameList>

<queryExpression> ::=               <queryExpressionBody>
                     | <withClause> <queryExpressionBody>

<withClause> ::= <WITH>             <withList>
                | <WITH> <RECURSIVE> <withList>

<withList> ::= <withListElement>
              | <withList> <_comma> <withListElement>

<withListElement> ::= <_query name>                                               <AS> <_left paren> <queryExpression> <_right paren>
                      | <_query name>                                               <AS> <_left paren> <queryExpression> <_right paren> <searchOrCycleClause>
                      | <_query name> <_left paren> <withColumnList> <_right paren> <AS> <_left paren> <queryExpression> <_right paren>
                      | <_query name> <_left paren> <withColumnList> <_right paren> <AS> <_left paren> <queryExpression> <_right paren> <searchOrCycleClause>

<withColumnList> ::= <columnNameList>

<queryExpressionBody> ::= <nonJoinQueryExpression> | <joinedTable>

<nonJoinQueryExpression> ::=
		<nonJoinQueryTerm>
	|	<queryExpressionBody> <UNION>                                  <queryTerm>
	|	<queryExpressionBody> <UNION>             <correspondingSpec> <queryTerm>
	|	<queryExpressionBody> <UNION>  <ALL>                           <queryTerm>
	|	<queryExpressionBody> <UNION>  <ALL>      <correspondingSpec> <queryTerm>
	|	<queryExpressionBody> <UNION>  <DISTINCT>                      <queryTerm>
	|	<queryExpressionBody> <UNION>  <DISTINCT> <correspondingSpec> <queryTerm>
	|	<queryExpressionBody> <EXCEPT>                                 <queryTerm>
	|	<queryExpressionBody> <EXCEPT>            <correspondingSpec> <queryTerm>
	|	<queryExpressionBody> <EXCEPT> <ALL>                           <queryTerm>
	|	<queryExpressionBody> <EXCEPT> <ALL>      <correspondingSpec> <queryTerm>
	|	<queryExpressionBody> <EXCEPT> <DISTINCT>                      <queryTerm>
	|	<queryExpressionBody> <EXCEPT> <DISTINCT> <correspondingSpec> <queryTerm>

<queryTerm> ::= <nonJoinQueryTerm> | <joinedTable>

<nonJoinQueryTerm> ::=
		<nonJoinQueryPrimary>
	|	<queryTerm> <INTERSECT>                                  <queryPrimary>
	|	<queryTerm> <INTERSECT>             <correspondingSpec> <queryPrimary>
	|	<queryTerm> <INTERSECT>  <ALL>                           <queryPrimary>
	|	<queryTerm> <INTERSECT>  <ALL>      <correspondingSpec> <queryPrimary>
	|	<queryTerm> <INTERSECT>  <DISTINCT>                      <queryPrimary>
	|	<queryTerm> <INTERSECT>  <DISTINCT> <correspondingSpec> <queryPrimary>

<queryPrimary> ::= <nonJoinQueryPrimary> | <joinedTable>

<nonJoinQueryPrimary> ::= <simpleTable> | <_left paren> <nonJoinQueryExpression> <_right paren>

<simpleTable> ::=
		<querySpecification>
	|	<tableValueConstructor>
	|	<explicitTable>

<explicitTable> ::= <TABLE> <tableOrQueryName>

<correspondingSpec> ::= <CORRESPONDING>
                       | <CORRESPONDING> <BY> <_left paren> <correspondingColumnList> <_right paren>

<correspondingColumnList> ::= <columnNameList>

<searchOrCycleClause> ::=
		<searchClause>
	|	<cycleClause>
	|	<searchClause> <cycleClause>

<searchClause> ::= <SEARCH> <recursiveSearchOrder> <SET> <sequenceColumn>

<recursiveSearchOrder> ::=
		<DEPTH> <FIRST> <BY> <sortSpecificationList>
	|	<BREADTH> <FIRST> <BY> <sortSpecificationList>

<sequenceColumn> ::= <_column name>

<cycleClause> ::=
		<CYCLE> <cycleColumnList>
		<SET> <cycleMarkColumn> <TO> <cycleMarkValue>
		<DEFAULT> <nonCycleMarkValue>
		<USING> <pathColumn>

<cycleColumnList> ::= <cycleColumn>
                      | <cycleColumnList> <_comma> <cycleColumn>

<cycleColumn> ::= <_column name>

<cycleMarkColumn> ::= <_column name>

<pathColumn> ::= <_column name>

<cycleMarkValue> ::= <valueExpression>

<nonCycleMarkValue> ::= <valueExpression>

<scalarSubquery> ::= <subquery>

<rowSubquery> ::= <subquery>

<tableSubquery> ::= <subquery>

<subquery> ::= <_left paren> <queryExpression> <_right paren>

<predicate> ::=
		<comparisonPredicate>
	|	<betweenPredicate>
	|	<inPredicate>
	|	<likePredicate>
	|	<similarPredicate>
	|	<nullPredicate>
	|	<quantifiedComparisonPredicate>
	|	<existsPredicate>
	|	<uniquePredicate>
	|	<normalizedPredicate>
	|	<matchPredicate>
	|	<overlapsPredicate>
	|	<distinctPredicate>
	|	<memberPredicate>
	|	<submultisetPredicate>
	|	<setPredicate>
	|	<typePredicate>

<comparisonPredicate> ::= <rowValuePredicand> <comparisonPredicatePart2>

<comparisonPredicatePart2> ::= <compOp> <rowValuePredicand>

<compOp> ::=
		<_equals operator>
	|	<_not equals operator>
	|	<_less than operator>
	|	<_greater than operator>
	|	<_less than or equals operator>
	|	<_greater than or equals operator>

<betweenPredicate> ::= <rowValuePredicand> <betweenPredicatePart2>

<betweenPredicatePart2> ::=       <BETWEEN>              <rowValuePredicand> <AND> <rowValuePredicand>
                             |       <BETWEEN> <ASYMMETRIC> <rowValuePredicand> <AND> <rowValuePredicand>
                             |       <BETWEEN> <SYMMETRIC>  <rowValuePredicand> <AND> <rowValuePredicand>
                             | <NOT> <BETWEEN>              <rowValuePredicand> <AND> <rowValuePredicand>
                             | <NOT> <BETWEEN> <ASYMMETRIC> <rowValuePredicand> <AND> <rowValuePredicand>
                             | <NOT> <BETWEEN> <SYMMETRIC>  <rowValuePredicand> <AND> <rowValuePredicand>

<inPredicate> ::= <rowValuePredicand> <inPredicatePart2> 

<inPredicatePart2> ::= <IN> <inPredicateValue>
                        | <NOT> <IN> <inPredicateValue>

<inPredicateValue> ::=
		<tableSubquery>
	|	<_left paren> <inValueList> <_right paren>

<inValueList> ::= <rowValueExpression>
                  | <inValueList> <_comma> <rowValueExpression>

<likePredicate> ::= <characterLikePredicate> | <octetLikePredicate>

<characterLikePredicate> ::= <rowValuePredicand> <characterLikePredicatePart2>

<characterLikePredicatePart2> ::=       <LIKE> <characterPattern>
                                    |       <LIKE> <characterPattern> <ESCAPE> <_escape character>
                                    | <NOT> <LIKE> <characterPattern>
                                    | <NOT> <LIKE> <characterPattern> <ESCAPE> <_escape character>

<characterPattern> ::= <characterValueExpression>

#
# Disgression from the standard: in the BNF there is
# <_escape character> ::= <characterValueExpression>
# and in reality this is always in the form 'X'
#
<__any character but quote> ~ [^']
<__escape character> ~ <__quote><__any character but quote><__quote>
                     | <__quote><__quote symbol><__quote>
<_escape character> ~ <__escape character>

<octetLikePredicate> ::= <rowValuePredicand> <octetLikePredicatePart2>

<octetLikePredicatePart2> ::=       <LIKE> <octetPattern>
                                |       <LIKE> <octetPattern> <ESCAPE> <escapeOctet>
                                | <NOT> <LIKE> <octetPattern>
                                | <NOT> <LIKE> <octetPattern> <ESCAPE> <escapeOctet>

<octetPattern> ::= <blobValueExpression>

<escapeOctet> ::= <blobValueExpression>

<similarPredicate> ::= <rowValuePredicand> <similarPredicatePart2>

<similarPredicatePart2> ::=       <SIMILAR> <TO> <similarPattern>
                             |       <SIMILAR> <TO> <similarPattern> <ESCAPE> <_escape character>
                             | <NOT> <SIMILAR> <TO> <similarPattern>
                             | <NOT> <SIMILAR> <TO> <similarPattern> <ESCAPE> <_escape character>

<similarPattern> ::= <regularExpression>

<regularExpression> ::=
		<regularTerm>
	|	<regularExpression> <_vertical bar> <regularTerm>

<regularTerm> ::=
		<regularFactor>
	|	<regularTerm> <regularFactor>

<regularFactor> ::=
		<regularPrimary>
	|	<regularPrimary> <_asterisk>
	|	<regularPrimary> <_plus sign>
	|	<regularPrimary> <_question mark>
	|	<regularPrimary> <repeatFactor>

<repeatFactor> ::= <_left brace> <lowValue> <_right brace>
                  | <_left brace> <lowValue> <upperLimit> <_right brace>

<upperLimit> ::= <_comma>
                | <_comma> <highValue>

<lowValue> ::= <_unsigned integer>

<highValue> ::= <_unsigned integer>

<regularPrimary> ::=
		<characterSpecifier>
	|	<_percent>
	|	<regularCharacterSet>
	|	<_left paren> <regularExpression> <_right paren>

<characterSpecifier> ::= <nonEscapedCharacter> | <escapedCharacter>

#
# This is the only disgression to the grammar:even if the ESCAPE lexeme in the rhs is supported
# it is ignored, always defaulting to '\'. Why ESCAPE is specified after the affected other
# rules? To support this feature, this would require going back in the stream and apply the
# escaped character that is defined... after.
#

<nonEscapedCharacter> ~ [^\[\]\(\)\|\^\-\+\*_%\?\{\\]

<escapedCharacter> ~ '\' [\[\]\(\)\|\^\-\+\*_%\?\{\\]

<characterEnumerationMany> ::= <characterEnumeration>+

<characterEnumerationIncludeMany> ::= <characterEnumerationInclude>+

<characterEnumerationExcludeMany> ::= <characterEnumerationExclude>+

<regularCharacterSet> ::=
		<_underscore>
	|	<_left bracket> <characterEnumerationMany> <_right bracket>
	|	<_left bracket> <_circumflex> <characterEnumerationMany> <_right bracket>
	|	<_left bracket> <characterEnumerationIncludeMany>  <_circumflex> <characterEnumerationExcludeMany> <_right bracket>

<characterEnumerationInclude> ::= <characterEnumeration>

<characterEnumerationExclude> ::= <characterEnumeration>

<characterEnumeration> ::=
		<characterSpecifier>
	|	<characterSpecifier> <_minus sign> <characterSpecifier>
	|	<_left bracket> <_colon> <regularCharacterSetIdentifier> <_colon> <_right bracket>

<regularCharacterSetIdentifier> ::= <_identifier>

<nullPredicate> ::= <rowValuePredicand> <nullPredicatePart2>

<nullPredicatePart2> ::= <IS> <NULL>
                          | <IS> <NOT> <NULL>

<quantifiedComparisonPredicate> ::= <rowValuePredicand> <quantifiedComparisonPredicatePart2>

<quantifiedComparisonPredicatePart2> ::= <compOp> <quantifier> <tableSubquery>

<quantifier> ::= <all> | <some>

<all> ::= <ALL>

<some> ::= <SOME> | <ANY>

<existsPredicate> ::= <EXISTS> <tableSubquery>

<uniquePredicate> ::= <UNIQUE> <tableSubquery>

<normalizedPredicate> ::= <stringValueExpression> <IS> <NORMALIZED>
                         | <stringValueExpression> <IS> <NOT> <NORMALIZED>

<matchPredicate> ::= <rowValuePredicand> <matchPredicatePart2>

<matchPredicatePart2> ::= <MATCH>                    <tableSubquery>
                           | <MATCH>          <SIMPLE>  <tableSubquery>
                           | <MATCH>          <PARTIAL> <tableSubquery>
                           | <MATCH>          <FULL>    <tableSubquery>
                           | <MATCH> <UNIQUE>           <tableSubquery>
                           | <MATCH> <UNIQUE> <SIMPLE>  <tableSubquery>
                           | <MATCH> <UNIQUE> <PARTIAL> <tableSubquery>
                           | <MATCH> <UNIQUE> <FULL>    <tableSubquery>

<overlapsPredicate> ::= <overlapsPredicatePart1> <overlapsPredicatePart2>

<overlapsPredicatePart1> ::= <rowValuePredicand1>

<overlapsPredicatePart2> ::= <OVERLAPS> <rowValuePredicand2>

<rowValuePredicand1> ::= <rowValuePredicand>

<rowValuePredicand2> ::= <rowValuePredicand>

<distinctPredicate> ::= <rowValuePredicand3> <distinctPredicatePart2>

<distinctPredicatePart2> ::= <IS> <DISTINCT> <FROM> <rowValuePredicand4>

<rowValuePredicand3> ::= <rowValuePredicand>

<rowValuePredicand4> ::= <rowValuePredicand>

<memberPredicate> ::= <rowValuePredicand> <memberPredicatePart2>

<memberPredicatePart2> ::=       <MEMBER>      <multisetValueExpression>
                            |       <MEMBER> <OF> <multisetValueExpression>
                            | <NOT> <MEMBER>      <multisetValueExpression>
                            | <NOT> <MEMBER> <OF> <multisetValueExpression>

<submultisetPredicate> ::= <rowValuePredicand> <submultisetPredicatePart2>

<submultisetPredicatePart2> ::=       <SUBMULTISET>      <multisetValueExpression>
                                 |       <SUBMULTISET> <OF> <multisetValueExpression>
                                 | <NOT> <SUBMULTISET>      <multisetValueExpression>
                                 | <NOT> <SUBMULTISET> <OF> <multisetValueExpression>

<setPredicate> ::= <rowValuePredicand> <setPredicatePart2>

<setPredicatePart2> ::= <IS>       <A> <SET>
                         | <IS> <NOT> <A> <SET>

<typePredicate> ::= <rowValuePredicand> <typePredicatePart2>

<typePredicatePart2> ::= <IS>       <OF> <_left paren> <typeList> <_right paren>
                          | <IS> <NOT> <OF> <_left paren> <typeList> <_right paren>

<typeList> ::= <userDefinedTypeSpecification>
              | <typeList> <_comma> <userDefinedTypeSpecification>

<userDefinedTypeSpecification> ::=
		<inclusiveUserDefinedTypeSpecification>
	|	<exclusiveUserDefinedTypeSpecification>

<inclusiveUserDefinedTypeSpecification> ::= <pathResolvedUserDefinedTypeName>

<exclusiveUserDefinedTypeSpecification> ::= <ONLY> <pathResolvedUserDefinedTypeName>

<searchCondition> ::= <booleanValueExpression>

<intervalQualifier> ::=
		<startField> <TO> <endField>
	|	<singleDatetimeField>

<startField> ::= <nonSecondPrimaryDatetimeField>
                | <nonSecondPrimaryDatetimeField> <_left paren> <intervalLeadingFieldPrecision> <_right paren>

<endField> ::=
		<nonSecondPrimaryDatetimeField>
	|	<SECOND>
	|	<SECOND> <_left paren> <intervalFractionalSecondsPrecision> <_right paren>

<singleDatetimeField> ::=
		<nonSecondPrimaryDatetimeField>
	|	<nonSecondPrimaryDatetimeField> <_left paren> <intervalLeadingFieldPrecision> <_right paren>
	|	<SECOND>
	|	<SECOND> <_left paren> <intervalLeadingFieldPrecision> <_right paren>
	|	<SECOND> <_left paren> <intervalLeadingFieldPrecision> <_comma> <intervalFractionalSecondsPrecision> <_right paren>

<primaryDatetimeField> ::=
		<nonSecondPrimaryDatetimeField>
	|	<SECOND>

<nonSecondPrimaryDatetimeField> ::= <YEAR> | <MONTH> | <DAY> | <HOUR> | <MINUTE>

<intervalFractionalSecondsPrecision> ::= <_unsigned integer>

<intervalLeadingFieldPrecision> ::= <_unsigned integer>

<languageClause> ::= <LANGUAGE> <languageName>

<languageName> ::= <C> | <SQL>

<pathSpecification> ::= <PATH> <schemaNameList>

<schemaNameList> ::= <_schema name>
                     | <schemaNameList> <_comma> <_schema name>

<routineInvocation> ::= <routineName> <sqlArgumentList>

<routineName> ::= <_qualified identifier>
                 | <_schema name> <_period> <_qualified identifier>

<sqlArguments> ::= <sqlArgument>
                  | <sqlArguments> <_comma> <sqlArgument>

<sqlArgumentList> ::= <_left paren> <_right paren>
                      | <_left paren> <sqlArguments> <_right paren>

<sqlArgument> ::=
		<valueExpression>
	|	<generalizedExpression>
	|	<targetSpecification>

<generalizedExpression> ::= <valueExpression> <AS> <pathResolvedUserDefinedTypeName>

<__character set specification> ~
		<_standard character set name>
	|	<_implementation_defined character set name>
	|	<_user_defined character set name>

<_character set specification> ~ <__character set specification>

<_standard character set name> ~ <__character set name>

<_implementation_defined character set name> ~ <__character set name>

<_user_defined character set name> ~ <__character set name>

<specificRoutineDesignator> ::=
		<SPECIFIC> <routineType> <_specific name>
	|	<routineType> <memberName>
	|	<routineType> <memberName> <FOR> <schemaResolvedUserDefinedTypeName>

<routineType> ::=
		<ROUTINE>
	|	<FUNCTION>
	|	<PROCEDURE>
	|	<METHOD>
	|	<INSTANCE> <METHOD>
	|	<STATIC> <METHOD>
	|	<CONSTRUCTOR> <METHOD>

<memberName> ::= <memberNameAlternatives>
                | <memberNameAlternatives> <dataTypeList>

<memberNameAlternatives> ::= <_schema qualified routine name> | <_method name>

<dataTypes> ::= <dataType>
               | <dataTypes> <_comma> <dataType>

<dataTypeList> ::= <_left paren> <_right paren>
                   | <_left paren> <dataTypes> <_right paren>

<collateClause> ::= <COLLATE> <_collation name>

<constraintNameDefinition> ::= <CONSTRAINT> <_constraint name>

<constraintCharacteristics> ::=
		<constraintCheckTime>
	|	<constraintCheckTime>       <DEFERRABLE>
	|	<constraintCheckTime> <NOT> <DEFERRABLE>
	|	      <DEFERRABLE>
	|	      <DEFERRABLE> <constraintCheckTime>
	|	<NOT> <DEFERRABLE>
	|	<NOT> <DEFERRABLE> <constraintCheckTime>

<constraintCheckTime> ::= <INITIALLY> <DEFERRED> | <INITIALLY> <IMMEDIATE>

<aggregateFunction> ::=
		<COUNT> <_left paren> <_asterisk> <_right paren>
	|	<COUNT> <_left paren> <_asterisk> <_right paren> <filterClause>
	|	<generalSetFunction>
	|	<generalSetFunction> <filterClause>
	|	<binarySetFunction>
	|	<binarySetFunction> <filterClause>
	|	<orderedSetFunction>
	|	<orderedSetFunction> <filterClause>

<generalSetFunction> ::= <setFunctionType> <_left paren> <valueExpression> <_right paren>
                         | <setFunctionType> <_left paren> <setQuantifier> <valueExpression> <_right paren>

<setFunctionType> ::= <computationalOperation>

<computationalOperation> ::=
		<AVG> | <MAX> | <MIN> | <SUM>
	|	<EVERY> | <ANY> | <SOME>
	|	<COUNT>
	|	<STDDEV_POP> | <STDDEV_SAMP> | <VAR_SAMP> | <VAR_POP>
	|	<COLLECT> | <FUSION> | <INTERSECTION>

<setQuantifier> ::= <DISTINCT> | <ALL>

<filterClause> ::= <FILTER> <_left paren> <WHERE> <searchCondition> <_right paren>

<binarySetFunction> ::= <binarySetFunctionType> <_left paren> <dependentVariableExpression> <_comma> <independentVariableExpression> <_right paren>

<binarySetFunctionType> ::=
		<COVAR_POP> | <COVAR_SAMP> | <CORR> | <REGR_SLOPE>
	|	<REGR_INTERCEPT> | <REGR_COUNT> | <REGR_R2> | <REGR_AVGX> | <REGR_AVGY>
	|	<REGR_SXX> | <REGR_SYY> | <REGR_SXY>

<dependentVariableExpression> ::= <numericValueExpression>

<independentVariableExpression> ::= <numericValueExpression>

<orderedSetFunction> ::= <hypotheticalSetFunction> | <inverseDistributionFunction>

<hypotheticalSetFunction> ::= <rankFunctionType> <_left paren> <hypotheticalSetFunctionValueExpressionList> <_right paren> <withinGroupSpecification>

<withinGroupSpecification> ::= <WITHIN> <GROUP> <_left paren> <ORDER> <BY> <sortSpecificationList> <_right paren>

<hypotheticalSetFunctionValueExpressionList> ::= <valueExpression>
                                                    | <hypotheticalSetFunctionValueExpressionList> <_comma> <valueExpression>

<inverseDistributionFunction> ::= <inverseDistributionFunctionType> <_left paren> <inverseDistributionFunctionArgument> <_right paren> <withinGroupSpecification>

<inverseDistributionFunctionArgument> ::= <numericValueExpression>

<inverseDistributionFunctionType> ::= <PERCENTILE_CONT> | <PERCENTILE_DISC>

<sortSpecificationList> ::= <sortSpecification>
                            | <sortSpecificationList> <_comma> <sortSpecification>

<sortSpecification> ::= <sortKey>
                       | <sortKey> <orderingSpecification>
                       | <sortKey> <orderingSpecification> <nullOrdering>
                       | <sortKey> <nullOrdering>

<sortKey> ::= <valueExpression>

<orderingSpecification> ::= <ASC> | <DESC>

<nullOrdering> ::= <NULLS> <FIRST> | <NULLS> <LAST>

<schemaElements> ::= <schemaElement>+

<schemaDefinition> ::= <CREATE> <SCHEMA> <schemaNameClause>
                      | <CREATE> <SCHEMA> <schemaNameClause> <schemaCharacterSetOrPath>
                      | <CREATE> <SCHEMA> <schemaNameClause> <schemaCharacterSetOrPath> <schemaElements>
                      | <CREATE> <SCHEMA> <schemaNameClause> <schemaElements>

<schemaCharacterSetOrPath> ::=
		<schemaCharacterSetSpecification>
	|	<schemaPathSpecification>
	|	<schemaCharacterSetSpecification> <schemaPathSpecification>
	|	<schemaPathSpecification> <schemaCharacterSetSpecification>

<schemaNameClause> ::=
		<_schema name>
	|	<AUTHORIZATION> <schemaAuthorizationIdentifier>
	|	<_schema name> <AUTHORIZATION> <schemaAuthorizationIdentifier>

<schemaAuthorizationIdentifier> ::= <_authorization identifier>

<schemaCharacterSetSpecification> ::= <DEFAULT> <CHARACTER> <SET> <_character set specification>

<schemaPathSpecification> ::= <pathSpecification>

<schemaElement> ::=
		<tableDefinition>
	|	<viewDefinition>
	|	<domainDefinition>
	|	<characterSetDefinition>
	|	<collationDefinition>
	|	<transliterationDefinition>
	|	<assertionDefinition>
	|	<triggerDefinition>
	|	<userDefinedTypeDefinition>
	|	<userDefinedCastDefinition>
	|	<userDefinedOrderingDefinition>
	|	<transformDefinition>
	|	<schemaRoutine>
	|	<sequenceGeneratorDefinition>
	|	<grantStatement>
	|	<roleDefinition>

<dropSchemaStatement> ::= <DROP> <SCHEMA> <_schema name> <dropBehavior>

<dropBehavior> ::= <CASCADE> | <RESTRICT>

<tableDefinition> ::=
		<CREATE>               <TABLE> <_table name> <tableContentsSource>
	|	<CREATE>               <TABLE> <_table name> <tableContentsSource> <ON> <COMMIT> <tableCommitAction> <ROWS>
	|	<CREATE> <tableScope> <TABLE> <_table name> <tableContentsSource>
	|	<CREATE> <tableScope> <TABLE> <_table name> <tableContentsSource> <ON> <COMMIT> <tableCommitAction> <ROWS>

<tableContentsSource> ::=
		<tableElementList>
	|	<OF> <pathResolvedUserDefinedTypeName>
	|	<OF> <pathResolvedUserDefinedTypeName> <subtableClause>
	|	<OF> <pathResolvedUserDefinedTypeName> <subtableClause> <tableElementList>
	|	<OF> <pathResolvedUserDefinedTypeName> <tableElementList>
	|	<asSubqueryClause>

<tableScope> ::= <globalOrLocal> <TEMPORARY>

<globalOrLocal> ::= <GLOBAL> | <LOCAL>

<tableCommitAction> ::= <PRESERVE> | <DELETE>

<tableElements> ::= <tableElement>
                   | <tableElements> <_comma> <tableElement>

<tableElementList> ::= <_left paren> <tableElements> <_right paren>

<tableElement> ::=
		<columnDefinition>
	|	<tableConstraintDefinition>
	|	<likeClause>
	|	<selfReferencingColumnSpecification>
	|	<columnOptions>

<selfReferencingColumnSpecification> ::= <REF> <IS> <selfReferencingColumnName> <referenceGeneration>

<referenceGeneration> ::= <SYSTEM> <GENERATED> | <USER> <GENERATED> | <DERIVED>

<selfReferencingColumnName> ::= <_column name>

#
# Little deviation: <columnOptionList> is made non-empty
#
<columnOptions> ::= <_column name> <WITH> <OPTIONS>
                   | <_column name> <WITH> <OPTIONS> <columnOptionList>

<columnConstraintDefinitions> ::= <columnConstraintDefinition>+

<columnOptionList> ::=
	  <scopeClause>
	| <scopeClause> <defaultClause>
	| <scopeClause> <defaultClause> <columnConstraintDefinitions>
	| <scopeClause> <columnConstraintDefinitions>
	| <defaultClause>
	| <defaultClause> <columnConstraintDefinitions>
	| <columnConstraintDefinitions>


<subtableClause> ::= <UNDER> <supertableClause>

<supertableClause> ::= <supertableName>

<supertableName> ::= <_table name>

<likeClause> ::= <LIKE> <_table name>
                | <LIKE> <_table name> <likeOptions>

<likeOptions> ::= <identityOption> | <columnDefaultOption>

<identityOption> ::= <INCLUDING> <IDENTITY> | <EXCLUDING> <IDENTITY>

<columnDefaultOption> ::= <INCLUDING> <DEFAULTS> | <EXCLUDING> <DEFAULTS>

<asSubqueryClause> ::= <AS> <subquery> <withOrWithoutData>
                       | <_left paren> <columnNameList> <_right paren> <AS> <subquery> <withOrWithoutData>

<withOrWithoutData> ::= <WITH> <NO> <DATA> | <WITH> <DATA>

<columnDefinition> ::=
	  <_column name> <dataType>
	| <_column name> <dataType> <referenceScopeCheck>
	| <_column name> <dataType> <referenceScopeCheck> <defaultClause>
	| <_column name> <dataType> <referenceScopeCheck> <defaultClause> <columnConstraintDefinitions>
	| <_column name> <dataType> <referenceScopeCheck> <defaultClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <dataType> <referenceScopeCheck> <defaultClause> <collateClause>
	| <_column name> <dataType> <referenceScopeCheck> <identityColumnSpecification>
	| <_column name> <dataType> <referenceScopeCheck> <identityColumnSpecification> <columnConstraintDefinitions>
	| <_column name> <dataType> <referenceScopeCheck> <identityColumnSpecification> <columnConstraintDefinitions> <collateClause>
	| <_column name> <dataType> <referenceScopeCheck> <identityColumnSpecification> <collateClause>
	| <_column name> <dataType> <referenceScopeCheck> <generationClause>
	| <_column name> <dataType> <referenceScopeCheck> <generationClause> <columnConstraintDefinitions>
	| <_column name> <dataType> <referenceScopeCheck> <generationClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <dataType> <referenceScopeCheck> <generationClause> <collateClause>
	| <_column name> <dataType> <referenceScopeCheck> <columnConstraintDefinitions>
	| <_column name> <dataType> <referenceScopeCheck> <columnConstraintDefinitions> <collateClause>
	| <_column name> <dataType> <referenceScopeCheck> <collateClause>
	| <_column name> <dataType> <defaultClause>
	| <_column name> <dataType> <defaultClause> <columnConstraintDefinitions>
	| <_column name> <dataType> <defaultClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <dataType> <defaultClause> <collateClause>
	| <_column name> <dataType> <identityColumnSpecification>
	| <_column name> <dataType> <identityColumnSpecification> <columnConstraintDefinitions>
	| <_column name> <dataType> <identityColumnSpecification> <columnConstraintDefinitions> <collateClause>
	| <_column name> <dataType> <identityColumnSpecification> <collateClause>
	| <_column name> <dataType> <generationClause>
	| <_column name> <dataType> <generationClause> <columnConstraintDefinitions>
	| <_column name> <dataType> <generationClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <dataType> <generationClause> <collateClause>
	| <_column name> <dataType> <columnConstraintDefinitions>
	| <_column name> <dataType> <columnConstraintDefinitions> <collateClause>
	| <_column name> <dataType> <collateClause>
	| <_column name> <_domain name>
	| <_column name> <_domain name> <referenceScopeCheck>
	| <_column name> <_domain name> <referenceScopeCheck> <defaultClause>
	| <_column name> <_domain name> <referenceScopeCheck> <defaultClause> <columnConstraintDefinitions>
	| <_column name> <_domain name> <referenceScopeCheck> <defaultClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <_domain name> <referenceScopeCheck> <defaultClause> <collateClause>
	| <_column name> <_domain name> <referenceScopeCheck> <identityColumnSpecification>
	| <_column name> <_domain name> <referenceScopeCheck> <identityColumnSpecification> <columnConstraintDefinitions>
	| <_column name> <_domain name> <referenceScopeCheck> <identityColumnSpecification> <columnConstraintDefinitions> <collateClause>
	| <_column name> <_domain name> <referenceScopeCheck> <identityColumnSpecification> <collateClause>
	| <_column name> <_domain name> <referenceScopeCheck> <generationClause>
	| <_column name> <_domain name> <referenceScopeCheck> <generationClause> <columnConstraintDefinitions>
	| <_column name> <_domain name> <referenceScopeCheck> <generationClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <_domain name> <referenceScopeCheck> <generationClause> <collateClause>
	| <_column name> <_domain name> <referenceScopeCheck> <columnConstraintDefinitions>
	| <_column name> <_domain name> <referenceScopeCheck> <columnConstraintDefinitions> <collateClause>
	| <_column name> <_domain name> <referenceScopeCheck> <collateClause>
	| <_column name> <_domain name> <defaultClause>
	| <_column name> <_domain name> <defaultClause> <columnConstraintDefinitions>
	| <_column name> <_domain name> <defaultClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <_domain name> <defaultClause> <collateClause>
	| <_column name> <_domain name> <identityColumnSpecification>
	| <_column name> <_domain name> <identityColumnSpecification> <columnConstraintDefinitions>
	| <_column name> <_domain name> <identityColumnSpecification> <columnConstraintDefinitions> <collateClause>
	| <_column name> <_domain name> <identityColumnSpecification> <collateClause>
	| <_column name> <_domain name> <generationClause>
	| <_column name> <_domain name> <generationClause> <columnConstraintDefinitions>
	| <_column name> <_domain name> <generationClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <_domain name> <generationClause> <collateClause>
	| <_column name> <_domain name> <columnConstraintDefinitions>
	| <_column name> <_domain name> <columnConstraintDefinitions> <collateClause>
	| <_column name> <_domain name> <collateClause>
	| <_column name> <referenceScopeCheck>
	| <_column name> <referenceScopeCheck> <defaultClause>
	| <_column name> <referenceScopeCheck> <defaultClause> <columnConstraintDefinitions>
	| <_column name> <referenceScopeCheck> <defaultClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <referenceScopeCheck> <defaultClause> <collateClause>
	| <_column name> <referenceScopeCheck> <identityColumnSpecification>
	| <_column name> <referenceScopeCheck> <identityColumnSpecification> <columnConstraintDefinitions>
	| <_column name> <referenceScopeCheck> <identityColumnSpecification> <columnConstraintDefinitions> <collateClause>
	| <_column name> <referenceScopeCheck> <identityColumnSpecification> <collateClause>
	| <_column name> <referenceScopeCheck> <generationClause>
	| <_column name> <referenceScopeCheck> <generationClause> <columnConstraintDefinitions>
	| <_column name> <referenceScopeCheck> <generationClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <referenceScopeCheck> <generationClause> <collateClause>
	| <_column name> <referenceScopeCheck> <columnConstraintDefinitions>
	| <_column name> <referenceScopeCheck> <columnConstraintDefinitions> <collateClause>
	| <_column name> <referenceScopeCheck> <collateClause>
	| <_column name> <defaultClause>
	| <_column name> <defaultClause> <columnConstraintDefinitions>
	| <_column name> <defaultClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <defaultClause> <collateClause>
	| <_column name> <identityColumnSpecification>
	| <_column name> <identityColumnSpecification> <columnConstraintDefinitions>
	| <_column name> <identityColumnSpecification> <columnConstraintDefinitions> <collateClause>
	| <_column name> <identityColumnSpecification> <collateClause>
	| <_column name> <generationClause>
	| <_column name> <generationClause> <columnConstraintDefinitions>
	| <_column name> <generationClause> <columnConstraintDefinitions> <collateClause>
	| <_column name> <generationClause> <collateClause>
	| <_column name> <columnConstraintDefinitions>
	| <_column name> <columnConstraintDefinitions> <collateClause>
	| <_column name> <collateClause>

<columnConstraintDefinition> ::=                              <columnConstraint>
                                 |                              <columnConstraint> <constraintCharacteristics>
                                 | <constraintNameDefinition> <columnConstraint>
                                 | <constraintNameDefinition> <columnConstraint> <constraintCharacteristics>

<columnConstraint> ::=
		<NOT> <NULL>
	|	<uniqueSpecification>
	|	<referencesSpecification>
	|	<checkConstraintDefinition>

<referenceScopeCheck> ::= <REFERENCES> <ARE>       <CHECKED>
                          | <REFERENCES> <ARE>       <CHECKED> <ON> <DELETE> <referenceScopeCheckAction>
                          | <REFERENCES> <ARE> <NOT> <CHECKED>
                          | <REFERENCES> <ARE> <NOT> <CHECKED> <ON> <DELETE> <referenceScopeCheckAction>

<referenceScopeCheckAction> ::= <referentialAction>

<identityColumnSpecification> ::= <GENERATED> <ALWAYS>       <AS> <IDENTITY>
                                  | <GENERATED> <ALWAYS>       <AS> <IDENTITY> <_left paren> <commonSequenceGeneratorOptions> <_right paren>
                                  | <GENERATED> <BY> <DEFAULT> <AS> <IDENTITY>
                                  | <GENERATED> <BY> <DEFAULT> <AS> <IDENTITY> <_left paren> <commonSequenceGeneratorOptions> <_right paren>

<generationClause> ::= <generationRule> <AS> <generationExpression>

<generationRule> ::= <GENERATED> <ALWAYS>

<generationExpression> ::= <_left paren> <valueExpression> <_right paren>

<defaultClause> ::= <DEFAULT> <defaultOption>

<defaultOption> ::=
		<literal>
	|	<datetimeValueFunction>
	|	<USER>
	|	<CURRENT_USER>
	|	<CURRENT_ROLE>
	|	<SESSION_USER>
	|	<SYSTEM_USER>
	|	<CURRENT_PATH>
	|	<implicitlyTypedValueSpecification>

<tableConstraintDefinition> ::=                              <tableConstraint>
                                |                              <tableConstraint> <constraintCharacteristics>
                                | <constraintNameDefinition> <tableConstraint>
                                | <constraintNameDefinition> <tableConstraint> <constraintCharacteristics>

<tableConstraint> ::=
		<uniqueConstraintDefinition>
	|	<referentialConstraintDefinition>
	|	<checkConstraintDefinition>

<uniqueConstraintDefinition> ::=
		<uniqueSpecification> <_left paren> <uniqueColumnList> <_right paren>
	|	<UNIQUE> '(' 'VALUE' ')'

<uniqueSpecification> ::= <UNIQUE> | <PRIMARY> <KEY>

<uniqueColumnList> ::= <columnNameList>

<referentialConstraintDefinition> ::= <FOREIGN> <KEY> <_left paren> <referencingColumns> <_right paren> <referencesSpecification>

<referencesSpecification> ::= <REFERENCES> <referencedTableAndColumns>
                             | <REFERENCES> <referencedTableAndColumns> <MATCH> <matchType>
                             | <REFERENCES> <referencedTableAndColumns> <MATCH> <matchType> <referentialTriggeredAction>
                             | <REFERENCES> <referencedTableAndColumns> <referentialTriggeredAction>

<matchType> ::= <FULL> | <PARTIAL> | <SIMPLE>

<referencingColumns> ::= <referenceColumnList>

<referencedTableAndColumns> ::= <_table name>
                                 | <_table name> <_left paren> <referenceColumnList> <_right paren>

<referenceColumnList> ::= <columnNameList>

<referentialTriggeredAction> ::= <updateRule>
                                 | <updateRule> <deleteRule>
                                 | <deleteRule>
                                 | <deleteRule> <updateRule>

<updateRule> ::= <ON> <UPDATE> <referentialAction>

<deleteRule> ::= <ON> <DELETE> <referentialAction>

<referentialAction> ::= <CASCADE> | <SET> <NULL> | <SET> <DEFAULT> | <RESTRICT> | <NO> <ACTION>

<checkConstraintDefinition> ::= <CHECK> <_left paren> <searchCondition> <_right paren>

<alterTableStatement> ::= <ALTER> <TABLE> <_table name> <alterTableAction>

<alterTableAction> ::=
		<addColumnDefinition>
	|	<alterColumnDefinition>
	|	<dropColumnDefinition>
	|	<addTableConstraintDefinition>
	|	<dropTableConstraintDefinition>

<addColumnDefinition> ::= <ADD>          <columnDefinition>
                          | <ADD> <COLUMN> <columnDefinition>

<alterColumnDefinition> ::= <ALTER>          <_column name> <alterColumnAction>
                            | <ALTER> <COLUMN> <_column name> <alterColumnAction>

<alterColumnAction> ::=
		<setColumnDefaultClause>
	|	<dropColumnDefaultClause>
	|	<addColumnScopeClause>
	|	<dropColumnScopeClause>
	|	<alterIdentityColumnSpecification>

<setColumnDefaultClause> ::= <SET> <defaultClause>

<dropColumnDefaultClause> ::= <DROP> <DEFAULT>

<addColumnScopeClause> ::= <ADD> <scopeClause>

<dropColumnScopeClause> ::= <DROP> <SCOPE> <dropBehavior>

<alterIdentityColumnSpecification> ::= <alterIdentityColumnOption>+

<alterIdentityColumnOption> ::=
		<alterSequenceGeneratorRestartOption>
	|	<SET> <basicSequenceGeneratorOption>

<dropColumnDefinition> ::= <DROP>          <_column name> <dropBehavior>
                           | <DROP> <COLUMN> <_column name> <dropBehavior>

<addTableConstraintDefinition> ::= <ADD> <tableConstraintDefinition>

<dropTableConstraintDefinition> ::= <DROP> <CONSTRAINT> <_constraint name> <dropBehavior>

<dropTableStatement> ::= <DROP> <TABLE> <_table name> <dropBehavior>

<viewDefinition> ::= <CREATE>             <VIEW> <_table name> <viewSpecification> <AS> <queryExpression>
                    | <CREATE>             <VIEW> <_table name> <viewSpecification> <AS> <queryExpression> <WITH>                 <CHECK> <OPTION>
                    | <CREATE>             <VIEW> <_table name> <viewSpecification> <AS> <queryExpression> <WITH> <levelsClause> <CHECK> <OPTION>
                    | <CREATE> <RECURSIVE> <VIEW> <_table name> <viewSpecification> <AS> <queryExpression>
                    | <CREATE> <RECURSIVE> <VIEW> <_table name> <viewSpecification> <AS> <queryExpression> <WITH>                 <CHECK> <OPTION>
                    | <CREATE> <RECURSIVE> <VIEW> <_table name> <viewSpecification> <AS> <queryExpression> <WITH> <levelsClause> <CHECK> <OPTION>

<viewSpecification> ::= <regularViewSpecification> | <referenceableViewSpecification>

<regularViewSpecification> ::= <_left paren> <viewColumnList> <_right paren>
<regularViewSpecification> ::=

<referenceableViewSpecification> ::= <OF> <pathResolvedUserDefinedTypeName>
                                     | <OF> <pathResolvedUserDefinedTypeName> <subviewClause>
                                     | <OF> <pathResolvedUserDefinedTypeName> <subviewClause> <viewElementList>
                                     | <OF> <pathResolvedUserDefinedTypeName> <viewElementList>

<subviewClause> ::= <UNDER> <_table name>

<viewElements> ::= <viewElement>
                  | <viewElements> <_comma> <viewElement>

<viewElementList> ::= <_left paren> <viewElements> <_right paren>

<viewElement> ::= <selfReferencingColumnSpecification> | <viewColumnOption>

<viewColumnOption> ::= <_column name> <WITH> <OPTIONS> <scopeClause>

<levelsClause> ::= <CASCADED> | <LOCAL>

<viewColumnList> ::= <columnNameList>

<dropViewStatement> ::= <DROP> <VIEW> <_table name> <dropBehavior>

<domainConstraints> ::= <domainConstraint>+

<domainDefinition> ::=
          <CREATE> <DOMAIN> <_domain name>      <dataType>
	| <CREATE> <DOMAIN> <_domain name>      <dataType> <defaultClause>
	| <CREATE> <DOMAIN> <_domain name>      <dataType> <defaultClause> <domainConstraints>
	| <CREATE> <DOMAIN> <_domain name>      <dataType> <defaultClause> <domainConstraints> <collateClause>
	| <CREATE> <DOMAIN> <_domain name>      <dataType> <defaultClause> <collateClause>
	| <CREATE> <DOMAIN> <_domain name>      <dataType> <domainConstraints>
	| <CREATE> <DOMAIN> <_domain name>      <dataType> <domainConstraints> <collateClause>
	| <CREATE> <DOMAIN> <_domain name>      <dataType> <collateClause>
        | <CREATE> <DOMAIN> <_domain name> <AS> <dataType>
	| <CREATE> <DOMAIN> <_domain name> <AS> <dataType> <defaultClause>
	| <CREATE> <DOMAIN> <_domain name> <AS> <dataType> <defaultClause> <domainConstraints>
	| <CREATE> <DOMAIN> <_domain name> <AS> <dataType> <defaultClause> <domainConstraints> <collateClause>
	| <CREATE> <DOMAIN> <_domain name> <AS> <dataType> <defaultClause> <collateClause>
	| <CREATE> <DOMAIN> <_domain name> <AS> <dataType> <domainConstraints>
	| <CREATE> <DOMAIN> <_domain name> <AS> <dataType> <domainConstraints> <collateClause>
	| <CREATE> <DOMAIN> <_domain name> <AS> <dataType> <collateClause>

<domainConstraint> ::=                              <checkConstraintDefinition>
                      |                              <checkConstraintDefinition> <constraintCharacteristics>
                      | <constraintNameDefinition> <checkConstraintDefinition>
                      | <constraintNameDefinition> <checkConstraintDefinition> <constraintCharacteristics>

<alterDomainStatement> ::= <ALTER> <DOMAIN> <_domain name> <alterDomainAction>

<alterDomainAction> ::=
		<setDomainDefaultClause>
	|	<dropDomainDefaultClause>
	|	<addDomainConstraintDefinition>
	|	<dropDomainConstraintDefinition>

<setDomainDefaultClause> ::= <SET> <defaultClause>

<dropDomainDefaultClause> ::= <DROP> <DEFAULT>

<addDomainConstraintDefinition> ::= <ADD> <domainConstraint>

<dropDomainConstraintDefinition> ::= <DROP> <CONSTRAINT> <_constraint name>

<dropDomainStatement> ::= <DROP> <DOMAIN> <_domain name> <dropBehavior>

<characterSetDefinition> ::= <CREATE> <CHARACTER> <SET> <_character set name>      <characterSetSource>
                             | <CREATE> <CHARACTER> <SET> <_character set name>      <characterSetSource> <collateClause>
                             | <CREATE> <CHARACTER> <SET> <_character set name> <AS> <characterSetSource>
                             | <CREATE> <CHARACTER> <SET> <_character set name> <AS> <characterSetSource> <collateClause>

<characterSetSource> ::= <GET> <_character set specification>

<dropCharacterSetStatement> ::= <DROP> <CHARACTER> <SET> <_character set name>

<collationDefinition> ::= <CREATE> <COLLATION> <_collation name> <FOR> <_character set specification> <FROM> <existingCollationName>
                         | <CREATE> <COLLATION> <_collation name> <FOR> <_character set specification> <FROM> <existingCollationName> <padCharacteristic>

<existingCollationName> ::= <_collation name>

<padCharacteristic> ::= <NO> <PAD> | <PAD> <SPACE>

<dropCollationStatement> ::= <DROP> <COLLATION> <_collation name> <dropBehavior>

<transliterationDefinition> ::= <CREATE> <TRANSLATION> <transliterationName> <FOR> <sourceCharacterSetSpecification> <TO> <targetCharacterSetSpecification> <FROM> <transliterationSource>

<sourceCharacterSetSpecification> ::= <_character set specification>

<targetCharacterSetSpecification> ::= <_character set specification>

<transliterationSource> ::= <existingTransliterationName> | <transliterationRoutine>

<existingTransliterationName> ::= <transliterationName>

<transliterationRoutine> ::= <specificRoutineDesignator>

<dropTransliterationStatement> ::= <DROP> <TRANSLATION> <transliterationName>

<assertionDefinition> ::= <CREATE> <ASSERTION> <_constraint name> <CHECK> <_left paren> <searchCondition> <_right paren>
                         | <CREATE> <ASSERTION> <_constraint name> <CHECK> <_left paren> <searchCondition> <_right paren> <constraintCharacteristics>

<dropAssertionStatement> ::= <DROP> <ASSERTION> <_constraint name>

<triggerDefinition> ::= <CREATE> <TRIGGER> <_trigger name> <triggerActionTime> <triggerEvent> <ON> <_table name>                                              <triggeredAction>
                       | <CREATE> <TRIGGER> <_trigger name> <triggerActionTime> <triggerEvent> <ON> <_table name> <REFERENCING> <oldOrNewValuesAliasList> <triggeredAction>

<triggerActionTime> ::= <BEFORE> | <AFTER>

<triggerEvent> ::= <INSERT>
                  | <DELETE>
                  | <UPDATE>
                  | <UPDATE> <OF> <triggerColumnList>

<triggerColumnList> ::= <columnNameList>

<triggeredAction> ::= <triggeredSqlStatement>
                     | <FOR> <EACH> <ROW>                                                            <triggeredSqlStatement>
                     | <FOR> <EACH> <STATEMENT>                                                      <triggeredSqlStatement>
                     | <FOR> <EACH> <ROW>       <WHEN> <_left paren> <searchCondition> <_right paren> <triggeredSqlStatement>
                     | <FOR> <EACH> <STATEMENT> <WHEN> <_left paren> <searchCondition> <_right paren> <triggeredSqlStatement>
                     |                          <WHEN> <_left paren> <searchCondition> <_right paren> <triggeredSqlStatement>

<sqlProcedureStatementAndSemicolon> ::= <sqlProcedureStatement> <_semicolon>

<sqlProcedureStatementAndSemicolonMany> ::= <sqlProcedureStatementAndSemicolon>+

<triggeredSqlStatement> ::=
		<sqlProcedureStatement>
	|	<BEGIN> <ATOMIC> <sqlProcedureStatementAndSemicolonMany> <END>

<oldOrNewValuesAliasList> ::= <oldOrNewValuesAlias>+

<oldOrNewValuesAlias> ::=
		<OLD>              <oldValuesCorrelationName>
	|	<OLD> <ROW>        <oldValuesCorrelationName>
	|	<OLD> <ROW> <AS>   <oldValuesCorrelationName>
	|	<OLD> <AS>         <oldValuesCorrelationName>
	|	<NEW>              <newValuesCorrelationName>
	|	<NEW> <ROW>        <newValuesCorrelationName>
	|	<NEW> <ROW> <AS>   <newValuesCorrelationName>
	|	<NEW> <AS>         <newValuesCorrelationName>
	|	<OLD> <TABLE>      <oldValuesTableAlias>
	|	<OLD> <TABLE> <AS> <oldValuesTableAlias>
	|	<NEW> <TABLE>      <newValuesTableAlias>
	|	<NEW> <TABLE> <AS> <newValuesTableAlias>

<oldValuesTableAlias> ::= <_identifier>

<newValuesTableAlias> ::= <_identifier>

<oldValuesCorrelationName> ::= <_correlation name>

<newValuesCorrelationName> ::= <_correlation name>

<dropTriggerStatement> ::= <DROP> <TRIGGER> <_trigger name>

<userDefinedTypeDefinition> ::= <CREATE> <TYPE> <userDefinedTypeBody>

<userDefinedTypeBody> ::=
	  <schemaResolvedUserDefinedTypeName>
	| <schemaResolvedUserDefinedTypeName> <subtypeClause>
	| <schemaResolvedUserDefinedTypeName> <subtypeClause> <AS> <representation>
	| <schemaResolvedUserDefinedTypeName> <subtypeClause> <AS> <representation> <userDefinedTypeOptionList>
	| <schemaResolvedUserDefinedTypeName> <subtypeClause> <AS> <representation> <userDefinedTypeOptionList> <methodSpecificationList>
	| <schemaResolvedUserDefinedTypeName> <subtypeClause> <AS> <representation> <methodSpecificationList>
	| <schemaResolvedUserDefinedTypeName> <subtypeClause> <userDefinedTypeOptionList>
	| <schemaResolvedUserDefinedTypeName> <subtypeClause> <userDefinedTypeOptionList> <methodSpecificationList>
	| <schemaResolvedUserDefinedTypeName> <subtypeClause> <methodSpecificationList>
	| <schemaResolvedUserDefinedTypeName> <AS> <representation>
	| <schemaResolvedUserDefinedTypeName> <AS> <representation> <userDefinedTypeOptionList>
	| <schemaResolvedUserDefinedTypeName> <AS> <representation> <userDefinedTypeOptionList> <methodSpecificationList>
	| <schemaResolvedUserDefinedTypeName> <AS> <representation> <methodSpecificationList>
	| <schemaResolvedUserDefinedTypeName> <userDefinedTypeOptionList>
	| <schemaResolvedUserDefinedTypeName> <userDefinedTypeOptionList> <methodSpecificationList>
	| <schemaResolvedUserDefinedTypeName> <methodSpecificationList>

<userDefinedTypeOptionList> ::= <userDefinedTypeOption>+

<userDefinedTypeOption> ::=
		<instantiableClause>
	|	<finality>
	|	<referenceTypeSpecification>
	|	<refCastOption>
	|	<castOption>

<subtypeClause> ::= <UNDER> <supertypeName>

<supertypeName> ::= <pathResolvedUserDefinedTypeName>

<representation> ::= <predefinedType> | <memberList>

<members> ::= <member>
            | <members> <_comma> <member>

<memberList> ::= <_left paren> <members> <_right paren>

<member> ::= <attributeDefinition>

<instantiableClause> ::= <INSTANTIABLE> | <NOT> <INSTANTIABLE>

<finality> ::= <FINAL> | <NOT> <FINAL>

<referenceTypeSpecification> ::=
		<userDefinedRepresentation>
	|	<derivedRepresentation>
	|	<systemGeneratedRepresentation>

<userDefinedRepresentation> ::= <REF> <USING> <predefinedType>

<derivedRepresentation> ::= <REF> <FROM> <listOfAttributes>

<systemGeneratedRepresentation> ::= <REF> <IS> <SYSTEM> <GENERATED>

<refCastOption> ::=
	  <castToRef>
	| <castToRef> <castToType>
	| <castToType>

<castToRef> ::= <CAST> <_left paren> <SOURCE> <AS> <REF> <_right paren> <WITH> <castToRefIdentifier>

<castToRefIdentifier> ::= <_identifier>

<castToType> ::= <CAST> <_left paren> <REF> <AS> <SOURCE> <_right paren> <WITH> <castToTypeIdentifier>

<castToTypeIdentifier> ::= <_identifier>

<attributeNames> ::= <attributeName>
                    | <attributeNames> <_comma> <attributeName>

<listOfAttributes> ::= <_left paren> <attributeNames> <_right paren>

<castOption> ::=
	  <castToDistinct>
	| <castToDistinct> <castToSource>
	| <castToSource>

<castToDistinct> ::= <CAST> <_left paren> <SOURCE> <AS> <DISTINCT> <_right paren> <WITH> <castToDistinctIdentifier>

<castToDistinctIdentifier> ::= <_identifier>

<castToSource> ::= <CAST> <_left paren> <DISTINCT> <AS> <SOURCE> <_right paren> <WITH> <castToSourceIdentifier>

<castToSourceIdentifier> ::= <_identifier>

<methodSpecificationList> ::= <methodSpecification>
                              | <methodSpecificationList> <_comma> <methodSpecification>

<methodSpecification> ::= <originalMethodSpecification> | <overridingMethodSpecification>

<originalMethodSpecification> ::=
	  <partialMethodSpecification> <SELF> <AS> <RESULT>
	| <partialMethodSpecification> <SELF> <AS> <RESULT> <SELF> <AS> <LOCATOR>
	| <partialMethodSpecification> <SELF> <AS> <RESULT> <SELF> <AS> <LOCATOR> <methodCharacteristics>
	| <partialMethodSpecification> <SELF> <AS> <RESULT> <methodCharacteristics>
	| <partialMethodSpecification> <SELF> <AS> <LOCATOR>
	| <partialMethodSpecification> <SELF> <AS> <LOCATOR> <methodCharacteristics>
	| <partialMethodSpecification> <methodCharacteristics>

<overridingMethodSpecification> ::= <OVERRIDING> <partialMethodSpecification>

<partialMethodSpecification> ::=               <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause>
                                 |               <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause> <SPECIFIC> <specificMethodName>
                                 | <INSTANCE>    <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause>
                                 | <STATIC>      <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause>
                                 | <CONSTRUCTOR> <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause>
                                 | <INSTANCE>    <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause> <SPECIFIC> <specificMethodName>
                                 | <STATIC>      <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause> <SPECIFIC> <specificMethodName>
                                 | <CONSTRUCTOR> <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause> <SPECIFIC> <specificMethodName>

<specificMethodName> ::= <_qualified identifier>
                         | <_schema name> <_period> <_qualified identifier>

<methodCharacteristics> ::= <methodCharacteristic>+

<methodCharacteristic> ::=
		<languageClause>
	|	<parameterStyleClause>
	|	<deterministicCharacteristic>
	|	<sqlDataAccessIndication>
	|	<nullCallClause>

<attributeDefinition> ::=
	  <attributeName> <dataType> <referenceScopeCheck>
	| <attributeName> <dataType> <referenceScopeCheck> <attributeDefault>
	| <attributeName> <dataType> <referenceScopeCheck> <attributeDefault> <collateClause>
	| <attributeName> <dataType> <referenceScopeCheck> <collateClause>
	| <attributeName> <dataType> <attributeDefault>
	| <attributeName> <dataType> <attributeDefault> <collateClause>
	| <attributeName> <dataType> <collateClause>

<attributeDefault> ::= <defaultClause>

<alterTypeStatement> ::= <ALTER> <TYPE> <schemaResolvedUserDefinedTypeName> <alterTypeAction>

<alterTypeAction> ::=
		<addAttributeDefinition>
	|	<dropAttributeDefinition>
	|	<addOriginalMethodSpecification>
	|	<addOverridingMethodSpecification>
	|	<dropMethodSpecification>

<addAttributeDefinition> ::= <ADD> <ATTRIBUTE> <attributeDefinition>

<dropAttributeDefinition> ::= <DROP> <ATTRIBUTE> <attributeName> <RESTRICT>

<addOriginalMethodSpecification> ::= <ADD> <originalMethodSpecification>

<addOverridingMethodSpecification> ::= <ADD> <overridingMethodSpecification>

<dropMethodSpecification> ::= <DROP> <specificMethodSpecificationDesignator> <RESTRICT>

<specificMethodSpecificationDesignator> ::=               <METHOD> <_method name> <dataTypeList>
                                             | <INSTANCE>    <METHOD> <_method name> <dataTypeList>
                                             | <STATIC>      <METHOD> <_method name> <dataTypeList>
                                             | <CONSTRUCTOR> <METHOD> <_method name> <dataTypeList>

<dropDataTypeStatement> ::= <DROP> <TYPE> <schemaResolvedUserDefinedTypeName> <dropBehavior>

<sqlInvokedRoutine> ::= <schemaRoutine>

<schemaRoutine> ::= <schemaProcedure> | <schemaFunction>

<schemaProcedure> ::= <CREATE> <sqlInvokedProcedure>

<schemaFunction> ::= <CREATE> <sqlInvokedFunction>

<sqlInvokedProcedure> ::= <PROCEDURE> <_schema qualified routine name> <sqlParameterDeclarationList> <routineCharacteristics> <routineBody>

<sqlInvokedFunction> ::= <functionSpecification> <routineBody>
                         | <methodSpecificationDesignator> <routineBody>

<sqlParameterDeclarations> ::= <sqlParameterDeclaration>
                               | <sqlParameterDeclarations> <_comma> <sqlParameterDeclaration>

<sqlParameterDeclarationList> ::= <_left paren> <_right paren>
                                   | <_left paren> <sqlParameterDeclarations> <_right paren>

<sqlParameterDeclaration> ::=
	  <parameterMode> <parameterType>
	|  <parameterMode> <parameterType> <RESULT>
	| <parameterMode> <_SQL parameter name> <parameterType>
	| <parameterMode> <_SQL parameter name> <parameterType> <RESULT>
	| <_SQL parameter name> <parameterType>
	| <_SQL parameter name> <parameterType> <RESULT>

<parameterMode> ::= <IN> | <OUT> | <INOUT>

<parameterType> ::= <dataType>
                   | <dataType> <locatorIndication>

<locatorIndication> ::= <AS> <LOCATOR>

<functionSpecification> ::= <FUNCTION> <_schema qualified routine name> <sqlParameterDeclarationList> <returnsClause> <routineCharacteristics>
                           | <FUNCTION> <_schema qualified routine name> <sqlParameterDeclarationList> <returnsClause> <routineCharacteristics> <dispatchClause>

<methodSpecificationDesignator> ::=
		<SPECIFIC>    <METHOD> <specificMethodName>
	|	              <METHOD> <_method name> <sqlParameterDeclarationList>                  <FOR> <schemaResolvedUserDefinedTypeName>
	|	              <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause> <FOR> <schemaResolvedUserDefinedTypeName>
	|	<INSTANCE>    <METHOD> <_method name> <sqlParameterDeclarationList>                  <FOR> <schemaResolvedUserDefinedTypeName>
	|	<STATIC>      <METHOD> <_method name> <sqlParameterDeclarationList>                  <FOR> <schemaResolvedUserDefinedTypeName>
	|	<CONSTRUCTOR> <METHOD> <_method name> <sqlParameterDeclarationList>                  <FOR> <schemaResolvedUserDefinedTypeName>
	|	<INSTANCE>    <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause> <FOR> <schemaResolvedUserDefinedTypeName>
	|	<STATIC>      <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause> <FOR> <schemaResolvedUserDefinedTypeName>
	|	<CONSTRUCTOR> <METHOD> <_method name> <sqlParameterDeclarationList> <returnsClause> <FOR> <schemaResolvedUserDefinedTypeName>

<routineCharacteristics> ::= <routineCharacteristic>*

<routineCharacteristic> ::=
		<languageClause>
	|	<parameterStyleClause>
	|	<SPECIFIC> <_specific name>
	|	<deterministicCharacteristic>
	|	<sqlDataAccessIndication>
	|	<nullCallClause>
	|	<dynamicResultSetsCharacteristic>
	|	<savepointLevelIndication>

<savepointLevelIndication> ::= <NEW> <SAVEPOINT> <LEVEL> | <OLD> <SAVEPOINT> <LEVEL>

<dynamicResultSetsCharacteristic> ::= <DYNAMIC> <RESULT> <SETS> <maximumDynamicResultSets>

<parameterStyleClause> ::= <PARAMETER> <STYLE> <parameterStyle>

<dispatchClause> ::= <STATIC> <DISPATCH>

<returnsClause> ::= <RETURNS> <returnsType>

<returnsType> ::=
		<returnsDataType>
	|	<returnsDataType> <resultCast>
	|	<returnsTableType>

<returnsTableType> ::= <TABLE> <tableFunctionColumnList>

<tableFunctionColumnListElements> ::= <tableFunctionColumnListElement>
                                        | <tableFunctionColumnListElements> <_comma> <tableFunctionColumnListElement>

<tableFunctionColumnList> ::= <_left paren> <tableFunctionColumnListElements> <_right paren>

<tableFunctionColumnListElement> ::= <_column name> <dataType>

<resultCast> ::= <CAST> <FROM> <resultCastFromType>

<resultCastFromType> ::= <dataType> <locatorIndication>
                          | <dataType>

<returnsDataType> ::= <dataType>
                      | <dataType> <locatorIndication>

<routineBody> ::=
		<sqlRoutineSpec>
	|	<externalBodyReference>

<sqlRoutineSpec> ::=                 <sqlRoutineBody>
                     | <rightsClause> <sqlRoutineBody>

<rightsClause> ::= <SQL> <SECURITY> <INVOKER> | <SQL> <SECURITY> <DEFINER>

<sqlRoutineBody> ::= <sqlProcedureStatement>

<externalBodyReference> ::=
	  <EXTERNAL><NAME> <_external routine name>
	| <EXTERNAL><NAME> <_external routine name> <parameterStyleClause>
	| <EXTERNAL><NAME> <_external routine name> <parameterStyleClause> <transformGroupSpecification>
	| <EXTERNAL><NAME> <_external routine name> <parameterStyleClause> <transformGroupSpecification> <externalSecurityClause>
	| <EXTERNAL><NAME> <_external routine name> <parameterStyleClause> <externalSecurityClause>
	| <EXTERNAL><NAME> <_external routine name> <transformGroupSpecification>
	| <EXTERNAL><NAME> <_external routine name> <transformGroupSpecification> <externalSecurityClause>
	| <EXTERNAL><NAME> <_external routine name> <externalSecurityClause>
	| <EXTERNAL><parameterStyleClause>
	| <EXTERNAL><parameterStyleClause> <transformGroupSpecification>
	| <EXTERNAL><parameterStyleClause> <transformGroupSpecification> <externalSecurityClause>
	| <EXTERNAL><parameterStyleClause> <externalSecurityClause>
	| <EXTERNAL><transformGroupSpecification>
	| <EXTERNAL><transformGroupSpecification> <externalSecurityClause>
	| <EXTERNAL><externalSecurityClause>

<externalSecurityClause> ::=
		<EXTERNAL> <SECURITY> <DEFINER>
	|	<EXTERNAL> <SECURITY> <INVOKER>
	|	<EXTERNAL> <SECURITY> <IMPLEMENTATION> <DEFINED>

<parameterStyle> ::= <SQL> | <GENERAL>

<deterministicCharacteristic> ::= <DETERMINISTIC> | <NOT> <DETERMINISTIC>

<sqlDataAccessIndication> ::=
		<NO> <SQL>
	|	<CONTAINS> <SQL>
	|	<READS> <SQL> <DATA>
	|	<MODIFIES> <SQL> <DATA>

<nullCallClause> ::=
		<RETURNS> <NULL> <ON> <NULL> <INPUT>
	|	<CALLED> <ON> <NULL> <INPUT>

<maximumDynamicResultSets> ::= <_unsigned integer>

<transformGroupSpecification> ::= <TRANSFORM> <GROUP> <singleGroupSpecification>
                                  | <TRANSFORM> <GROUP> <multipleGroupSpecification>

<singleGroupSpecification> ::= <groupName>

<multipleGroupSpecification> ::= <groupSpecification>
                                 | <multipleGroupSpecification> <_comma> <groupSpecification>

<groupSpecification> ::= <groupName> <FOR> <TYPE> <pathResolvedUserDefinedTypeName>

<alterRoutineStatement> ::= <ALTER> <specificRoutineDesignator> <alterRoutineCharacteristics> <alterRoutineBehavior>

<alterRoutineCharacteristics> ::= <alterRoutineCharacteristic>+

<alterRoutineCharacteristic> ::=
		<languageClause>
	|	<parameterStyleClause>
	|	<sqlDataAccessIndication>
	|	<nullCallClause>
	|	<dynamicResultSetsCharacteristic>
	|	<NAME> <_external routine name>

<alterRoutineBehavior> ::= <RESTRICT>

<dropRoutineStatement> ::= <DROP> <specificRoutineDesignator> <dropBehavior>

<userDefinedCastDefinition> ::= <CREATE> <CAST> <_left paren> <sourceDataType> <AS> <targetDataType> <_right paren> <WITH> <castFunction>
                                 | <CREATE> <CAST> <_left paren> <sourceDataType> <AS> <targetDataType> <_right paren> <WITH> <castFunction> <AS> <ASSIGNMENT>

<castFunction> ::= <specificRoutineDesignator>

<sourceDataType> ::= <dataType>

<targetDataType> ::= <dataType>

<dropUserDefinedCastStatement> ::= <DROP> <CAST> <_left paren> <sourceDataType> <AS> <targetDataType> <_right paren> <dropBehavior>

<userDefinedOrderingDefinition> ::= <CREATE> <ORDERING> <FOR> <schemaResolvedUserDefinedTypeName> <orderingForm>

<orderingForm> ::= <equalsOrderingForm> | <fullOrderingForm>

<equalsOrderingForm> ::= <EQUALS> <ONLY> <BY> <orderingCategory>

<fullOrderingForm> ::= <ORDER> <FULL> <BY> <orderingCategory>

<orderingCategory> ::= <relativeCategory> | <mapCategory> | <stateCategory>

<relativeCategory> ::= <RELATIVE> <WITH> <relativeFunctionSpecification>

<mapCategory> ::= <MAP> <WITH> <mapFunctionSpecification>

<stateCategory> ::= <STATE>
                   | <STATE> <_specific name>

<relativeFunctionSpecification> ::= <specificRoutineDesignator>

<mapFunctionSpecification> ::= <specificRoutineDesignator>

<dropUserDefinedOrderingStatement> ::= <DROP> <ORDERING> <FOR> <schemaResolvedUserDefinedTypeName> <dropBehavior>

<transformGroupMany> ::= <transformGroup>+

<transformDefinition> ::= <CREATE> <TRANSFORM>  <FOR> <schemaResolvedUserDefinedTypeName> <transformGroupMany>
                         | <CREATE> <TRANSFORMS> <FOR> <schemaResolvedUserDefinedTypeName> <transformGroupMany>

<transformGroup> ::= <groupName> <_left paren> <transformElementList> <_right paren>

<groupName> ::= <_identifier>

<transformElementList> ::= <transformElement>
                           | <transformElementList> <_comma> <transformElement>

<transformElement> ::= <toSql> | <fromSql>

<toSql> ::= <TO> <SQL> <WITH> <toSqlFunction>

<fromSql> ::= <FROM> <SQL> <WITH> <fromSqlFunction>

<toSqlFunction> ::= <specificRoutineDesignator>

<fromSqlFunction> ::= <specificRoutineDesignator>

<alterGroupMany> ::= <alterGroup>+

<alterTransformStatement> ::= <ALTER> <TRANSFORM>  <FOR> <schemaResolvedUserDefinedTypeName> <alterGroupMany>
                              | <ALTER> <TRANSFORMS> <FOR> <schemaResolvedUserDefinedTypeName> <alterGroupMany>

<alterGroup> ::= <groupName> <_left paren> <alterTransformActionList> <_right paren>

<alterTransformActionList> ::= <alterTransformAction>
                                | <alterTransformActionList> <_comma> <alterTransformAction>

<alterTransformAction> ::= <addTransformElementList> | <dropTransformElementList>

<addTransformElementList> ::= <ADD> <_left paren> <transformElementList> <_right paren>

<dropTransformElementList> ::= <DROP> <_left paren> <transformKind>                          <dropBehavior> <_right paren>
                                | <DROP> <_left paren> <transformKind> <_comma> <transformKind> <dropBehavior> <_right paren>

<transformKind> ::= <TO> <SQL> | <FROM> <SQL>

<dropTransformStatement> ::= <DROP> <TRANSFORM>  <transformsToBeDropped> <FOR> <schemaResolvedUserDefinedTypeName> <dropBehavior>
                             | <DROP> <TRANSFORMS> <transformsToBeDropped> <FOR> <schemaResolvedUserDefinedTypeName> <dropBehavior>

<transformsToBeDropped> ::= <ALL> | <transformGroupElement>

<transformGroupElement> ::= <groupName>

<sequenceGeneratorDefinition> ::= <CREATE> <SEQUENCE> <sequenceGeneratorName>
                                  | <CREATE> <SEQUENCE> <sequenceGeneratorName> <sequenceGeneratorOptions>

<sequenceGeneratorOptions> ::= <sequenceGeneratorOption>+

<sequenceGeneratorOption> ::= <sequenceGeneratorDataTypeOption> | <commonSequenceGeneratorOptions>

<commonSequenceGeneratorOptions> ::= <commonSequenceGeneratorOption>+

<commonSequenceGeneratorOption> ::= <sequenceGeneratorStartWithOption> | <basicSequenceGeneratorOption>

<basicSequenceGeneratorOption> ::=
		<sequenceGeneratorIncrementByOption>
	|	<sequenceGeneratorMaxvalueOption>
	|	<sequenceGeneratorMinvalueOption>
	|	<sequenceGeneratorCycleOption>

<sequenceGeneratorDataTypeOption> ::= <AS> <dataType>

<sequenceGeneratorStartWithOption> ::= <START> <WITH> <sequenceGeneratorStartValue>

<sequenceGeneratorStartValue> ::= <signedNumericLiteral>

<sequenceGeneratorIncrementByOption> ::= <INCREMENT> <BY> <sequenceGeneratorIncrement>

<sequenceGeneratorIncrement> ::= <signedNumericLiteral>

<sequenceGeneratorMaxvalueOption> ::=
		<MAXVALUE> <sequenceGeneratorMaxValue>
	|	<NO> <MAXVALUE>

<sequenceGeneratorMaxValue> ::= <signedNumericLiteral>

<sequenceGeneratorMinvalueOption> ::= <MINVALUE> <sequenceGeneratorMinValue> | <NO> <MINVALUE>

<sequenceGeneratorMinValue> ::= <signedNumericLiteral>

<sequenceGeneratorCycleOption> ::= <CYCLE> | <NO> <CYCLE>

<alterSequenceGeneratorStatement> ::= <ALTER> <SEQUENCE> <sequenceGeneratorName> <alterSequenceGeneratorOptions>

<alterSequenceGeneratorOptions> ::= <alterSequenceGeneratorOption>+

<alterSequenceGeneratorOption> ::=
		<alterSequenceGeneratorRestartOption>
	|	<basicSequenceGeneratorOption>

<alterSequenceGeneratorRestartOption> ::= <RESTART> <WITH> <sequenceGeneratorRestartValue>

<sequenceGeneratorRestartValue> ::= <signedNumericLiteral>

<dropSequenceGeneratorStatement> ::= <DROP> <SEQUENCE> <sequenceGeneratorName> <dropBehavior>

<grantStatement> ::= <grantPrivilegeStatement> | <grantRoleStatement>

<grantees> ::= <grantee>
             | <grantees> <_comma> <grantee>

<grantPrivilegeStatement> ::=
	  <GRANT> <privileges> <TO> <grantees> <WITH> <HIERARCHY> <OPTION>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <HIERARCHY> <OPTION> <WITH> <GRANT> <OPTION>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <HIERARCHY> <OPTION> <WITH> <GRANT> <OPTION> <GRANTED> <BY> <grantor>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <HIERARCHY> <OPTION> <GRANTED> <BY> <grantor>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <GRANT> <OPTION>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <GRANT> <OPTION> <GRANTED> <BY> <grantor>
	| <GRANT> <privileges> <TO> <grantees> <GRANTED> <BY> <grantor>

<privileges> ::= <objectPrivileges> <ON> <objectName>

<objectName> ::=
		<_table name>
	|	<TABLE> <_table name>
	|	<DOMAIN> <_domain name>
	|	<COLLATION> <_collation name>
	|	<CHARACTER> <SET> <_character set name>
	|	<TRANSLATION> <transliterationName>
	|	<TYPE> <schemaResolvedUserDefinedTypeName>
	|	<SEQUENCE> <sequenceGeneratorName>
	|	<specificRoutineDesignator>

<actions> ::= <action>
            | <actions> <_comma> <action>

<objectPrivileges> ::=
		<ALL> <PRIVILEGES>
	|	<actions>

<action> ::=
		<SELECT>
	|	<SELECT> <_left paren> <privilegeColumnList> <_right paren>
	|	<SELECT> <_left paren> <privilegeMethodList> <_right paren>
	|	<DELETE>
	|	<INSERT>
	|	<INSERT> <_left paren> <privilegeColumnList> <_right paren>
	|	<UPDATE>
	|	<UPDATE> <_left paren> <privilegeColumnList> <_right paren>
	|	<REFERENCES>
	|	<REFERENCES> <_left paren> <privilegeColumnList> <_right paren>
	|	<USAGE>
	|	<TRIGGER>
	|	<UNDER>
	|	<EXECUTE>

<privilegeMethodList> ::= <specificRoutineDesignator>
                          | <privilegeMethodList> <_comma> <specificRoutineDesignator>

<privilegeColumnList> ::= <columnNameList>

<grantee> ::= <PUBLIC> | <_authorization identifier>

<grantor> ::= <CURRENT_USER> | <CURRENT_ROLE>

<roleDefinition> ::= <CREATE> <ROLE> <_role name>
                    | <CREATE> <ROLE> <_role name> <WITH> <ADMIN> <grantor>

<roleGrantedMany> ::= <roleGranted>
                      | <roleGrantedMany> <_comma> <roleGranted>

<grantRoleStatement> ::=
	  <GRANT> <roleGrantedMany> <TO> <grantees> <WITH> <ADMIN> <OPTION>
	| <GRANT> <roleGrantedMany> <TO> <grantees> <WITH> <ADMIN> <OPTION> <GRANTED> <BY> <grantor>
	| <GRANT> <roleGrantedMany> <TO> <grantees> <GRANTED> <BY> <grantor>

<roleGranted> ::= <_role name>

<dropRoleStatement> ::= <DROP> <ROLE> <_role name>

<revokeStatement> ::=
		<revokePrivilegeStatement>
	|	<revokeRoleStatement>

<revokePrivilegeStatement> ::= <REVOKE>                           <privileges> <FROM> <grantees>                          <dropBehavior>
                               | <REVOKE>                           <privileges> <FROM> <grantees> <GRANTED> <BY> <grantor> <dropBehavior>
                               | <REVOKE> <revokeOptionExtension> <privileges> <FROM> <grantees>                          <dropBehavior>
                               | <REVOKE> <revokeOptionExtension> <privileges> <FROM> <grantees> <GRANTED> <BY> <grantor> <dropBehavior>

<revokeOptionExtension> ::= <GRANT> <OPTION> <FOR> | <HIERARCHY> <OPTION> <FOR>

<roleRevokedMany> ::= <roleRevoked>
                      | <roleRevokedMany> <_comma> <roleRevoked>

<revokeRoleStatement> ::= <REVOKE>                        <roleRevokedMany> <FROM> <grantees>                          <dropBehavior>
                          | <REVOKE>                        <roleRevokedMany> <FROM> <grantees> <GRANTED> <BY> <grantor> <dropBehavior>
                          | <REVOKE> <ADMIN> <OPTION> <FOR> <roleRevokedMany> <FROM> <grantees>                          <dropBehavior>
                          | <REVOKE> <ADMIN> <OPTION> <FOR> <roleRevokedMany> <FROM> <grantees> <GRANTED> <BY> <grantor> <dropBehavior>

<roleRevoked> ::= <_role name>

<moduleContentsMany> ::= <moduleContents>+

<temporaryTableDeclarations> ::= <temporaryTableDeclaration>+

<sqlClientModuleDefinition> ::=
	  <moduleNameClause> <languageClause> <moduleAuthorizationClause> <modulePathSpecification> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <modulePathSpecification> <moduleTransformGroupSpecification> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <modulePathSpecification> <moduleTransformGroupSpecification> <moduleCollations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <modulePathSpecification> <moduleTransformGroupSpecification> <moduleCollations> <temporaryTableDeclarations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <modulePathSpecification> <moduleTransformGroupSpecification> <temporaryTableDeclarations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <modulePathSpecification> <moduleCollations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <modulePathSpecification> <moduleCollations> <temporaryTableDeclarations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <modulePathSpecification> <temporaryTableDeclarations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <moduleTransformGroupSpecification> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <moduleTransformGroupSpecification> <moduleCollations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <moduleTransformGroupSpecification> <moduleCollations> <temporaryTableDeclarations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <moduleTransformGroupSpecification> <temporaryTableDeclarations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <moduleCollations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <moduleCollations> <temporaryTableDeclarations> <moduleContentsMany>
	| <moduleNameClause> <languageClause> <moduleAuthorizationClause> <temporaryTableDeclarations> <moduleContentsMany>

<moduleAuthorizationClause> ::=
		<SCHEMA> <_schema name>
	|	<AUTHORIZATION> <moduleAuthorizationIdentifier>
	|	<AUTHORIZATION> <moduleAuthorizationIdentifier> <FOR> <STATIC> <ONLY>
	|	<AUTHORIZATION> <moduleAuthorizationIdentifier> <FOR> <STATIC> <AND> <DYNAMIC>
	|	<SCHEMA> <_schema name> <AUTHORIZATION> <moduleAuthorizationIdentifier>
	|	<SCHEMA> <_schema name> <AUTHORIZATION> <moduleAuthorizationIdentifier> <FOR> <STATIC> <ONLY>
	|	<SCHEMA> <_schema name> <AUTHORIZATION> <moduleAuthorizationIdentifier> <FOR> <STATIC> <AND> <DYNAMIC>

<moduleAuthorizationIdentifier> ::= <_authorization identifier>

<modulePathSpecification> ::= <pathSpecification>

<moduleTransformGroupSpecification> ::= <transformGroupSpecification>

<moduleCollations> ::= <moduleCollationSpecification>+

<moduleCollationSpecification> ::= <COLLATION> <_collation name>
                                   | <COLLATION> <_collation name> <FOR> <characterSetSpecificationList>

<characterSetSpecificationList> ::= <_character set specification>
                                     | <characterSetSpecificationList> <_comma> <_character set specification>

<moduleContents> ::=
		<declareCursor>
	|	<dynamicDeclareCursor>
	|	<externallyInvokedProcedure>

<moduleNameClause> ::=
	  <MODULE> <_SQL_client module name> <moduleContentsMany>
	| <MODULE> <_SQL_client module name> <moduleCharacterSetSpecification> <moduleContentsMany>
	| <MODULE> <moduleCharacterSetSpecification> <moduleContentsMany>

<moduleCharacterSetSpecification> ::= <NAMES> <ARE> <_character set specification>

<externallyInvokedProcedure> ::= <PROCEDURE> <_procedure name> <hostParameterDeclarationList> <_semicolon> <sqlProcedureStatement> <_semicolon>

<hostParameterDeclarations> ::= <hostParameterDeclaration>
                                | <hostParameterDeclarations> <_comma> <hostParameterDeclaration>

<hostParameterDeclarationList> ::= <_left paren> <hostParameterDeclarations> <_right paren>

<hostParameterDeclaration> ::=
		<_host parameter name> <hostParameterDataType>
	|	<statusParameter>

<hostParameterDataType> ::= <dataType>
                             | <dataType> <locatorIndication>

<statusParameter> ::= <SQLSTATE>

<sqlProcedureStatement> ::= <sqlExecutableStatement>

<sqlExecutableStatement> ::=
		<sqlSchemaStatement>
	|	<sqlDataStatement>
	|	<sqlControlStatement>
	|	<sqlTransactionStatement>
	|	<sqlConnectionStatement>
	|	<sqlSessionStatement>
	|	<sqlDiagnosticsStatement>
	|	<sqlDynamicStatement>

<sqlSchemaStatement> ::=
		<sqlSchemaDefinitionStatement>
	|	<sqlSchemaManipulationStatement>

<sqlSchemaDefinitionStatement> ::=
		<schemaDefinition>
	|	<tableDefinition>
	|	<viewDefinition>
	|	<sqlInvokedRoutine>
	|	<grantStatement>
	|	<roleDefinition>
	|	<domainDefinition>
	|	<characterSetDefinition>
	|	<collationDefinition>
	|	<transliterationDefinition>
	|	<assertionDefinition>
	|	<triggerDefinition>
	|	<userDefinedTypeDefinition>
	|	<userDefinedCastDefinition>
	|	<userDefinedOrderingDefinition>
	|	<transformDefinition>
	|	<sequenceGeneratorDefinition>

<sqlSchemaManipulationStatement> ::=
		<dropSchemaStatement>
	|	<alterTableStatement>
	|	<dropTableStatement>
	|	<dropViewStatement>
	|	<alterRoutineStatement>
	|	<dropRoutineStatement>
	|	<dropUserDefinedCastStatement>
	|	<revokeStatement>
	|	<dropRoleStatement>
	|	<alterDomainStatement>
	|	<dropDomainStatement>
	|	<dropCharacterSetStatement>
	|	<dropCollationStatement>
	|	<dropTransliterationStatement>
	|	<dropAssertionStatement>
	|	<dropTriggerStatement>
	|	<alterTypeStatement>
	|	<dropDataTypeStatement>
	|	<dropUserDefinedOrderingStatement>
	|	<alterTransformStatement>
	|	<dropTransformStatement> | <alterSequenceGeneratorStatement>
	|	<dropSequenceGeneratorStatement>

<sqlDataStatement> ::=
		<openStatement>
	|	<fetchStatement>
	|	<closeStatement>
	|	<selectStatementSingleRow>
	|	<freeLocatorStatement>
	|	<holdLocatorStatement>
	|	<sqlDataChangeStatement>

<sqlDataChangeStatement> ::=
		<deleteStatementPositioned>
	|	<deleteStatementSearched>
	|	<insertStatement>
	|	<updateStatementPositioned>
	|	<updateStatementSearched>
	|	<mergeStatement>

<sqlControlStatement> ::=
		<callStatement>
	|	<returnStatement>

<sqlTransactionStatement> ::=
		<startTransactionStatement>
	|	<setTransactionStatement>
	|	<setConstraintsModeStatement>
	|	<savepointStatement>
	|	<releaseSavepointStatement>
	|	<commitStatement>
	|	<rollbackStatement>

<sqlConnectionStatement> ::=
		<connectStatement>
	|	<setConnectionStatement>
	|	<disconnectStatement>

<sqlSessionStatement> ::=
		<setSessionUserIdentifierStatement>
	|	<setRoleStatement>
	|	<setLocalTimeZoneStatement>
	|	<setSessionCharacteristicsStatement>
	|	<setCatalogStatement>
	|	<setSchemaStatement>
	|	<setNamesStatement>
	|	<setPathStatement>
	|	<setTransformGroupStatement>
	|	<setSessionCollationStatement>

<sqlDiagnosticsStatement> ::= <getDiagnosticsStatement>

<sqlDynamicStatement> ::=
		<systemDescriptorStatement>
	|	<prepareStatement>
	|	<deallocatePreparedStatement>
	|	<describeStatement>
	|	<executeStatement>
	|	<executeImmediateStatement>
	|	<sqlDynamicDataStatement>

<sqlDynamicDataStatement> ::=
		<allocateCursorStatement>
	|	<dynamicOpenStatement>
	|	<dynamicFetchStatement>
	|	<dynamicCloseStatement>
	|	<dynamicDeleteStatementPositioned>
	|	<dynamicUpdateStatementPositioned>

<systemDescriptorStatement> ::=
		<allocateDescriptorStatement>
	|	<deallocateDescriptorStatement>
	|	<setDescriptorStatement>
	|	<getDescriptorStatement>

<declareCursor> ::=
	  <DECLARE> <_cursor name> <cursorSensitivity>                        <CURSOR> <cursorHoldability> <FOR> <cursorSpecification>
	| <DECLARE> <_cursor name> <cursorSensitivity>                        <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <cursorSpecification>
	| <DECLARE> <_cursor name> <cursorSensitivity>                        <CURSOR> <cursorReturnability> <FOR> <cursorSpecification>
	| <DECLARE> <_cursor name> <cursorSensitivity> <cursorScrollability> <CURSOR> <cursorHoldability> <FOR> <cursorSpecification>
	| <DECLARE> <_cursor name> <cursorSensitivity> <cursorScrollability> <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <cursorSpecification>
	| <DECLARE> <_cursor name> <cursorSensitivity> <cursorScrollability> <CURSOR> <cursorReturnability> <FOR> <cursorSpecification>
	| <DECLARE> <_cursor name> <cursorScrollability>                      <CURSOR> <cursorHoldability> <FOR> <cursorSpecification>
	| <DECLARE> <_cursor name> <cursorScrollability>                      <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <cursorSpecification>
	| <DECLARE> <_cursor name> <cursorScrollability>                      <CURSOR> <cursorReturnability> <FOR> <cursorSpecification>


<cursorSensitivity> ::= <SENSITIVE> | <INSENSITIVE> | <ASENSITIVE>

<cursorScrollability> ::= <SCROLL> | <NO> <SCROLL>

<cursorHoldability> ::= <WITH> <HOLD> | <WITHOUT> <HOLD>

<cursorReturnability> ::= <WITH> <RETURN> | <WITHOUT> <RETURN>

<cursorSpecification> ::=
	  <queryExpression> <orderByClause>
	| <queryExpression> <orderByClause> <updatabilityClause>
	| <queryExpression> <updatabilityClause>

<updatabilityClause> ::= <FOR> <READ> <ONLY>
                        | <FOR> <UPDATE>
                        | <FOR> <UPDATE> <OF> <columnNameList>

<orderByClause> ::= <ORDER> <BY> <sortSpecificationList>

<openStatement> ::= <OPEN> <_cursor name>

<fetchStatement> ::= <FETCH>                            <_cursor name> <INTO> <fetchTargetList>
                    | <FETCH>                     <FROM> <_cursor name> <INTO> <fetchTargetList>
                    | <FETCH> <fetchOrientation> <FROM> <_cursor name> <INTO> <fetchTargetList>

<fetchOrientation> ::=
		<NEXT>
	|	<PRIOR>
	|	<FIRST>
	|	<LAST>
	|	<ABSOLUTE> <simpleValueSpecification>
	|	<RELATIVE> <simpleValueSpecification>

<fetchTargetList> ::= <targetSpecification>
                      | <fetchTargetList> <_comma> <targetSpecification>

<closeStatement> ::= <CLOSE> <_cursor name>

<selectStatementSingleRow> ::= <SELECT>                  <selectList> <INTO> <selectTargetList> <tableExpression>
                                | <SELECT> <setQuantifier> <selectList> <INTO> <selectTargetList> <tableExpression>

<selectTargetList> ::= <targetSpecification>
                       | <selectTargetList> <_comma> <targetSpecification>

<deleteStatementPositioned> ::= <DELETE> <FROM> <targetTable> <WHERE> <CURRENT> <OF> <_cursor name>

<targetTable> ::=
		<_table name>
	|	<ONLY> <_left paren> <_table name> <_right paren>

<deleteStatementSearched> ::= <DELETE> <FROM> <targetTable>
                              | <DELETE> <FROM> <targetTable> <WHERE> <searchCondition>

<insertStatement> ::= <INSERT> <INTO> <insertionTarget> <insertColumnsAndSource>

<insertionTarget> ::= <_table name>

<insertColumnsAndSource> ::=
		<fromSubquery>
	|	<fromConstructor>
	|	<fromDefault>

<fromSubquery> ::=
	  <_left paren> <insertColumnList> <_right paren> <queryExpression>
	| <_left paren> <insertColumnList> <_right paren> <overrideClause> <queryExpression>
	| <overrideClause> <queryExpression>

<fromConstructor> ::=
	  <_left paren> <insertColumnList> <_right paren> <contextuallyTypedTableValueConstructor>
	| <_left paren> <insertColumnList> <_right paren> <overrideClause> <contextuallyTypedTableValueConstructor>
	| <overrideClause> <contextuallyTypedTableValueConstructor>

<overrideClause> ::= <OVERRIDING> <USER> <VALUE> | <OVERRIDING> <SYSTEM> <VALUE>

<fromDefault> ::= <DEFAULT> <VALUES>

<insertColumnList> ::= <columnNameList>

<mergeStatement> ::= <MERGE> <INTO> <targetTable>                               <USING> <tableReference> <ON> <searchCondition> <mergeOperationSpecification>
                    | <MERGE> <INTO> <targetTable>      <mergeCorrelationName> <USING> <tableReference> <ON> <searchCondition> <mergeOperationSpecification>
                    | <MERGE> <INTO> <targetTable> <AS> <mergeCorrelationName> <USING> <tableReference> <ON> <searchCondition> <mergeOperationSpecification>

<mergeCorrelationName> ::= <_correlation name>

<mergeOperationSpecification> ::= <mergeWhenClause>+

<mergeWhenClause> ::= <mergeWhenMatchedClause> | <mergeWhenNotMatchedClause>

<mergeWhenMatchedClause> ::= <WHEN> <MATCHED> <THEN> <mergeUpdateSpecification>

<mergeWhenNotMatchedClause> ::= <WHEN> <NOT> <MATCHED> <THEN> <mergeInsertSpecification>

<mergeUpdateSpecification> ::= <UPDATE> <SET> <setClauseList>

<mergeInsertSpecification> ::=
	  <INSERT> <_left paren> <insertColumnList> <_right paren> <VALUES> <mergeInsertValueList>
	| <INSERT> <_left paren> <insertColumnList> <_right paren> <overrideClause> <VALUES> <mergeInsertValueList>
	| <INSERT> <overrideClause> <VALUES> <mergeInsertValueList>

<mergeInsertValueElementMany> ::= <mergeInsertValueElement>
                                    | <mergeInsertValueElementMany> <_comma> <mergeInsertValueElement>

<mergeInsertValueList> ::= <_left paren> <mergeInsertValueElementMany> <_right paren>

<mergeInsertValueElement> ::= <valueExpression> | <contextuallyTypedValueSpecification>

<updateStatementPositioned> ::= <UPDATE> <targetTable> <SET> <setClauseList> <WHERE> <CURRENT> <OF> <_cursor name>

<updateStatementSearched> ::= <UPDATE> <targetTable> <SET> <setClauseList>
                              | <UPDATE> <targetTable> <SET> <setClauseList> <WHERE> <searchCondition>

<setClauseList> ::= <setClause>
                    | <setClauseList> <_comma> <setClause>

<setClause> ::=
		<multipleColumnAssignment>
	|	<setTarget> <_equals operator> <updateSource>

<setTarget> ::= <updateTarget> | <mutatedSetClause>

<multipleColumnAssignment> ::= <setTargetList> <_equals operator> <assignedRow>

<setTargetMany> ::= <setTarget>
                    | <setTargetMany> <_comma> <setTarget>

<setTargetList> ::= <_left paren> <setTargetMany> <_right paren>

<assignedRow> ::= <contextuallyTypedRowValueExpression>

<updateTarget> ::=
		<objectColumn>
	|	<objectColumn> <_left bracket or trigraph> <simpleValueSpecification> <_right bracket or trigraph>

<objectColumn> ::= <_column name>

<mutatedSetClause> ::= <mutatedTarget> <_period> <_method name>

<mutatedTarget> ::= <objectColumn> | <mutatedSetClause>

<updateSource> ::= <valueExpression> | <contextuallyTypedValueSpecification>

<temporaryTableDeclaration> ::= <DECLARE> <LOCAL> <TEMPORARY> <TABLE> <_table name> <tableElementList>
                                | <DECLARE> <LOCAL> <TEMPORARY> <TABLE> <_table name> <tableElementList> <ON> <COMMIT> <tableCommitAction> <ROWS>

<locatorReferenceMany> ::= <locatorReference>
                           | <locatorReferenceMany> <_comma> <locatorReference>

<freeLocatorStatement> ::= <FREE> <LOCATOR> <locatorReferenceMany>

<locatorReference> ::= <_host parameter name> | <_embedded variable name>

<holdLocatorStatement> ::= <HOLD> <LOCATOR> <locatorReferenceMany>

<callStatement> ::= <CALL> <routineInvocation>

<returnStatement> ::= <RETURN> <returnValue>

<returnValue> ::= <valueExpression> | <NULL>

<transactionModeMany> ::= <transactionMode>
                          | <transactionModeMany> <_comma> <transactionMode>

<startTransactionStatement> ::= <START> <TRANSACTION>
                                | <START> <TRANSACTION> <transactionModeMany>

<transactionMode> ::= <isolationLevel> | <transactionAccessMode> | <diagnosticsSize>

<transactionAccessMode> ::= <READ> <ONLY> | <READ> <WRITE>

<isolationLevel> ::= <ISOLATION> <LEVEL> <levelOfIsolation>

<levelOfIsolation> ::= <READ> <UNCOMMITTED> | <READ> <COMMITTED> | <REPEATABLE> <READ> | <SERIALIZABLE>

<diagnosticsSize> ::= <DIAGNOSTICS> <SIZE> <numberOfConditions>

<numberOfConditions> ::= <simpleValueSpecification>

<setTransactionStatement> ::= <SET>         <transactionCharacteristics>
                              | <SET> <LOCAL> <transactionCharacteristics>

<transactionCharacteristics> ::= <TRANSACTION> <transactionModeMany>

#
# Little deviation from the grammar:
# <ALL> is disassociated from <constraintNameList>
#
<setConstraintsModeStatement> ::= <SET> <CONSTRAINTS> <ALL> <DEFERRED>
                                   | <SET> <CONSTRAINTS> <constraintNameList> <DEFERRED>
                                   | <SET> <CONSTRAINTS> <constraintNameList> <IMMEDIATE>
                                   | <SET> <CONSTRAINTS> <ALL> <IMMEDIATE>

<constraintNameList> ::= <_constraint name>
                         | <constraintNameList> <_comma> <_constraint name>

<savepointStatement> ::= <SAVEPOINT> <savepointSpecifier>

<savepointSpecifier> ::= <savepointName>

<releaseSavepointStatement> ::= <RELEASE> <SAVEPOINT> <savepointSpecifier>

<commitStatement> ::=
	  <COMMIT>
	| <COMMIT> <WORK>
	| <COMMIT> <WORK> <AND> <CHAIN>
	| <COMMIT> <WORK> <AND> <NO> <CHAIN>
	| <COMMIT> <AND> <CHAIN>
	| <COMMIT> <AND> <NO> <CHAIN>

<rollbackStatement> ::= <ROLLBACK>
	| <ROLLBACK> <WORK>
	| <ROLLBACK> <WORK> <AND> <CHAIN>
	| <ROLLBACK> <WORK> <AND> <NO> <CHAIN>
	| <ROLLBACK> <WORK> <AND> <CHAIN> <savepointClause>
	| <ROLLBACK> <WORK> <AND> <NO> <CHAIN> <savepointClause>
	| <ROLLBACK> <WORK> <savepointClause>
	| <ROLLBACK> <AND> <CHAIN>
	| <ROLLBACK> <AND> <NO> <CHAIN>
	| <ROLLBACK> <AND> <CHAIN> <savepointClause>
	| <ROLLBACK> <AND> <NO> <CHAIN> <savepointClause>
	| <ROLLBACK> <savepointClause>

<savepointClause> ::= <TO> <SAVEPOINT> <savepointSpecifier>

<connectStatement> ::= <CONNECT> <TO> <connectionTarget>

<connectionTarget> ::=
	  <sqlServerName>
	| <sqlServerName> <AS> <connectionName>
	| <sqlServerName> <AS> <connectionName> <USER> <connectionUserName>
	| <sqlServerName> <USER> <connectionUserName>
	| <DEFAULT>

<setConnectionStatement> ::= <SET> <CONNECTION> <connectionObject>

<connectionObject> ::= <DEFAULT> | <connectionName>

<disconnectStatement> ::= <DISCONNECT> <disconnectObject>

<disconnectObject> ::= <connectionObject> | <ALL> | <CURRENT>

<setSessionCharacteristicsStatement> ::= <SET> <SESSION> <CHARACTERISTICS> <AS> <sessionCharacteristicList>

<sessionCharacteristicList> ::= <sessionCharacteristic>
                                | <sessionCharacteristicList> <_comma> <sessionCharacteristic>

<sessionCharacteristic> ::= <transactionCharacteristics>

<setSessionUserIdentifierStatement> ::= <SET> <SESSION> <AUTHORIZATION> <valueSpecification>

<setRoleStatement> ::= <SET> <ROLE> <roleSpecification>

<roleSpecification> ::= <valueSpecification> | <NONE>

<setLocalTimeZoneStatement> ::= <SET> <TIME> <ZONE> <setTimeZoneValue>

<setTimeZoneValue> ::= <intervalValueExpression> | <LOCAL>

<setCatalogStatement> ::= <SET> <catalogNameCharacteristic>

<catalogNameCharacteristic> ::= <CATALOG> <valueSpecification>

<setSchemaStatement> ::= <SET> <schemaNameCharacteristic>

<schemaNameCharacteristic> ::= <SCHEMA> <valueSpecification>

<setNamesStatement> ::= <SET> <characterSetNameCharacteristic>

<characterSetNameCharacteristic> ::= <NAMES> <valueSpecification>

<setPathStatement> ::= <SET> <sqlPathCharacteristic>

<sqlPathCharacteristic> ::= <PATH> <valueSpecification>

<setTransformGroupStatement> ::= <SET> <transformGroupCharacteristic>

<transformGroupCharacteristic> ::=
		<DEFAULT> <TRANSFORM> <GROUP> <valueSpecification>
	|	<TRANSFORM> <GROUP> <FOR> <TYPE> <pathResolvedUserDefinedTypeName> <valueSpecification>

<setSessionCollationStatement> ::=
		<SET> <COLLATION> <collationSpecification>
	|	<SET> <COLLATION> <collationSpecification> <FOR> <characterSetSpecificationList>
	|	<SET> <NO> <COLLATION>
	|	<SET> <NO> <COLLATION> <FOR> <characterSetSpecificationList>

<collationSpecification> ::= <valueSpecification>

<allocateDescriptorStatement> ::= <ALLOCATE>       <DESCRIPTOR> <descriptorName>
                                  | <ALLOCATE>       <DESCRIPTOR> <descriptorName> <WITH> <MAX> <occurrences>
                                  | <ALLOCATE> <SQL> <DESCRIPTOR> <descriptorName>
                                  | <ALLOCATE> <SQL> <DESCRIPTOR> <descriptorName> <WITH> <MAX> <occurrences>

<occurrences> ::= <simpleValueSpecification>

<deallocateDescriptorStatement> ::= <DEALLOCATE>       <DESCRIPTOR> <descriptorName>
                                    | <DEALLOCATE> <SQL> <DESCRIPTOR> <descriptorName>

<getDescriptorStatement> ::= <GET>       <DESCRIPTOR> <descriptorName> <getDescriptorInformation>
                             | <GET> <SQL> <DESCRIPTOR> <descriptorName> <getDescriptorInformation>

<getHeaderInformationMany> ::= <getHeaderInformation>
                                | <getHeaderInformationMany> <_comma> <getHeaderInformation>

<getItemInformationMany> ::= <getItemInformation>
                              | <getItemInformationMany> <_comma> <getItemInformation>
<getDescriptorInformation> ::=
		<getHeaderInformationMany>
	|	<VALUE> <itemNumber> <getItemInformationMany>

<getHeaderInformation> ::= <simpleTargetSpecification1> <_equals operator> <headerItemName>

<headerItemName> ::= <COUNT> | <KEY_TYPE> | <DYNAMIC_FUNCTION> | <DYNAMIC_FUNCTION_CODE> | <TOP_LEVEL_COUNT>

<getItemInformation> ::= <simpleTargetSpecification2> <_equals operator> <descriptorItemName>

<itemNumber> ::= <simpleValueSpecification>

<simpleTargetSpecification1> ::= <simpleTargetSpecification>

<simpleTargetSpecification2> ::= <simpleTargetSpecification>

<descriptorItemName> ::=
		<CARDINALITY>
	|	<CHARACTER_SET_CATALOG>
	|	<CHARACTER_SET_NAME>
	|	<CHARACTER_SET_SCHEMA>
	|	<COLLATION_CATALOG>
	|	<COLLATION_NAME>
	|	<COLLATION_SCHEMA>
	|	<DATA>
	|	<DATETIME_INTERVAL_CODE>
	|	<DATETIME_INTERVAL_PRECISION>
	|	<DEGREE>
	|	<INDICATOR>
	|	<KEY_MEMBER>
	|	<LENGTH>
	|	<LEVEL>
	|	<NAME>
	|	<NULLABLE>
	|	<OCTET_LENGTH>
	|	<PARAMETER_MODE>
	|	<PARAMETER_ORDINAL_POSITION>
	|	<PARAMETER_SPECIFIC_CATALOG>
	|	<PARAMETER_SPECIFIC_NAME>
	|	<PARAMETER_SPECIFIC_SCHEMA>
	|	<PRECISION>
	|	<RETURNED_CARDINALITY>
	|	<RETURNED_LENGTH>
	|	<RETURNED_OCTET_LENGTH>
	|	<SCALE>
	|	<SCOPE_CATALOG>
	|	<SCOPE_NAME>
	|	<SCOPE_SCHEMA>
	|	<TYPE>
	|	<UNNAMED>
	|	<USER_DEFINED_TYPE_CATALOG>
	|	<USER_DEFINED_TYPE_NAME>
	|	<USER_DEFINED_TYPE_SCHEMA>
	|	<USER_DEFINED_TYPE_CODE>

<setDescriptorStatement> ::= <SET>       <DESCRIPTOR> <descriptorName> <setDescriptorInformation>
                             | <SET> <SQL> <DESCRIPTOR> <descriptorName> <setDescriptorInformation>

<setHeaderInformationMany> ::= <setHeaderInformation>
                                | <setHeaderInformationMany> <_comma> <setHeaderInformation>

<setItemInformationMany> ::= <setItemInformation>
                              | <setItemInformationMany> <_comma> <setItemInformation>

<setDescriptorInformation> ::=
		<setHeaderInformationMany>
	|	<VALUE> <itemNumber> <setItemInformationMany>

<setHeaderInformation> ::= <headerItemName> <_equals operator> <simpleValueSpecification1>

<setItemInformation> ::= <descriptorItemName> <_equals operator> <simpleValueSpecification2>

<simpleValueSpecification1> ::= <simpleValueSpecification>

<simpleValueSpecification2> ::= <simpleValueSpecification>

<prepareStatement> ::= <PREPARE> <sqlStatementName>                            <FROM> <sqlStatementVariable>
                      | <PREPARE> <sqlStatementName> <attributesSpecification> <FROM> <sqlStatementVariable>

<attributesSpecification> ::= <ATTRIBUTES> <attributesVariable>

<attributesVariable> ::= <simpleValueSpecification>

<sqlStatementVariable> ::= <simpleValueSpecification>

<preparableStatement> ::=
		<preparableSqlDataStatement>
	|	<preparableSqlSchemaStatement>
	|	<preparableSqlTransactionStatement>
	|	<preparableSqlControlStatement>
	|	<preparableSqlSessionStatement>
#	|	<preparableImplementationDefinedStatement>

<preparableSqlDataStatement> ::=
		<deleteStatementSearched>
	|	<dynamicSingleRowSelectStatement>
	|	<insertStatement>
	|	<dynamicSelectStatement>
	|	<updateStatementSearched>
	|	<mergeStatement>
	|	<preparableDynamicDeleteStatementPositioned>
	|	<preparableDynamicUpdateStatementPositioned>

<preparableSqlSchemaStatement> ::= <sqlSchemaStatement>

<preparableSqlTransactionStatement> ::= <sqlTransactionStatement>

<preparableSqlControlStatement> ::= <sqlControlStatement>

<preparableSqlSessionStatement> ::= <sqlSessionStatement>

<dynamicSelectStatement> ::= <cursorSpecification>

<deallocatePreparedStatement> ::= <DEALLOCATE> <PREPARE> <sqlStatementName>

<describeStatement> ::= <describeInputStatement> | <describeOutputStatement>

<describeInputStatement> ::= <DESCRIBE> <INPUT> <sqlStatementName> <usingDescriptor>
                             | <DESCRIBE> <INPUT> <sqlStatementName> <usingDescriptor> <nestingOption>

<describeOutputStatement> ::= <DESCRIBE>          <describedObject> <usingDescriptor>
                              | <DESCRIBE>          <describedObject> <usingDescriptor> <nestingOption>
                              | <DESCRIBE> <OUTPUT> <describedObject> <usingDescriptor>
                              | <DESCRIBE> <OUTPUT> <describedObject> <usingDescriptor> <nestingOption>

<nestingOption> ::= <WITH> <NESTING> | <WITHOUT> <NESTING>

<usingDescriptor> ::= <USING>       <DESCRIPTOR> <descriptorName>
                     | <USING> <SQL> <DESCRIPTOR> <descriptorName>

<describedObject> ::=
		<sqlStatementName>
	|	<CURSOR> <extendedCursorName> <STRUCTURE>

<inputUsingClause> ::= <usingArguments> | <usingInputDescriptor>

<usingArgumentMany> ::= <usingArgument>
                        | <usingArgumentMany> <_comma> <usingArgument>

<usingArguments> ::= <USING> <usingArgumentMany>

<usingArgument> ::= <generalValueSpecification>

<usingInputDescriptor> ::= <usingDescriptor>

<outputUsingClause> ::= <intoArguments> | <intoDescriptor>

<intoArgumentMany> ::= <intoArgument>
                       | <intoArgumentMany> <_comma> <intoArgument>

<intoArguments> ::= <INTO> <intoArgumentMany>

<intoArgument> ::= <targetSpecification>

<intoDescriptor> ::= <INTO>       <DESCRIPTOR> <descriptorName>
                    | <INTO> <SQL> <DESCRIPTOR> <descriptorName>

<executeStatement> ::= <EXECUTE> <sqlStatementName>
	| <EXECUTE> <sqlStatementName> <resultUsingClause>
	| <EXECUTE> <sqlStatementName> <resultUsingClause> <parameterUsingClause>
	| <EXECUTE> <sqlStatementName> <parameterUsingClause>

<resultUsingClause> ::= <outputUsingClause>

<parameterUsingClause> ::= <inputUsingClause>

<executeImmediateStatement> ::= <EXECUTE> <IMMEDIATE> <sqlStatementVariable>

<dynamicDeclareCursor> ::= <DECLARE> <_cursor name> <CURSOR> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorSensitivity> <CURSOR> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorSensitivity> <cursorScrollability> <CURSOR> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorSensitivity> <cursorScrollability> <CURSOR> <cursorHoldability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorSensitivity> <cursorScrollability> <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorSensitivity> <cursorScrollability> <CURSOR> <cursorReturnability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorSensitivity> <CURSOR> <cursorHoldability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorSensitivity> <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorSensitivity> <CURSOR> <cursorReturnability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorScrollability> <CURSOR> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorScrollability> <CURSOR> <cursorHoldability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorScrollability> <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <cursorScrollability> <CURSOR> <cursorReturnability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <CURSOR> <cursorHoldability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <statementName>
	| <DECLARE> <_cursor name> <CURSOR> <cursorReturnability> <FOR> <statementName>

<allocateCursorStatement> ::= <ALLOCATE> <extendedCursorName> <cursorIntent>

<cursorIntent> ::= <statementCursor> | <resultSetCursor>

<statementCursor> ::= <CURSOR> <FOR> <extendedStatementName>
	| <cursorSensitivity> <CURSOR> <FOR> <extendedStatementName>
	| <cursorSensitivity> <cursorScrollability> <CURSOR> <FOR> <extendedStatementName>
	| <cursorSensitivity> <cursorScrollability> <CURSOR> <cursorHoldability> <FOR> <extendedStatementName>
	| <cursorSensitivity> <cursorScrollability> <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <extendedStatementName>
	| <cursorSensitivity> <cursorScrollability> <CURSOR> <cursorReturnability> <FOR> <extendedStatementName>
	| <cursorSensitivity> <CURSOR> <cursorHoldability> <FOR> <extendedStatementName>
	| <cursorSensitivity> <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <extendedStatementName>
	| <cursorSensitivity> <CURSOR> <cursorReturnability> <FOR> <extendedStatementName>
	| <cursorScrollability> <CURSOR> <FOR> <extendedStatementName>
	| <cursorScrollability> <CURSOR> <cursorHoldability> <FOR> <extendedStatementName>
	| <cursorScrollability> <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <extendedStatementName>
	| <cursorScrollability> <CURSOR> <cursorReturnability> <FOR> <extendedStatementName>
	| <CURSOR> <cursorHoldability> <FOR> <extendedStatementName>
	| <CURSOR> <cursorHoldability> <cursorReturnability> <FOR> <extendedStatementName>
	| <CURSOR> <cursorReturnability> <FOR> <extendedStatementName>

<resultSetCursor> ::= <FOR> <PROCEDURE> <specificRoutineDesignator>

<dynamicOpenStatement> ::= <OPEN> <dynamicCursorName>
                           | <OPEN> <dynamicCursorName> <inputUsingClause>

<dynamicFetchStatement> ::= <FETCH>                            <dynamicCursorName> <outputUsingClause>
                            | <FETCH>                     <FROM> <dynamicCursorName> <outputUsingClause>
                            | <FETCH> <fetchOrientation> <FROM> <dynamicCursorName> <outputUsingClause>

<dynamicSingleRowSelectStatement> ::= <querySpecification>

<dynamicCloseStatement> ::= <CLOSE> <dynamicCursorName>

<dynamicDeleteStatementPositioned> ::= <DELETE> <FROM> <targetTable> <WHERE> <CURRENT> <OF> <dynamicCursorName>

<dynamicUpdateStatementPositioned> ::= <UPDATE> <targetTable> <SET> <setClauseList> <WHERE> <CURRENT> <OF> <dynamicCursorName>

<preparableDynamicDeleteStatementPositioned> ::= <DELETE>                       <WHERE> <CURRENT> <OF>                <_cursor name>
                                                   | <DELETE>                       <WHERE> <CURRENT> <OF> <scopeOption> <_cursor name>
                                                   | <DELETE> <FROM> <targetTable> <WHERE> <CURRENT> <OF>                <_cursor name>
                                                   | <DELETE> <FROM> <targetTable> <WHERE> <CURRENT> <OF> <scopeOption> <_cursor name>

<preparableDynamicUpdateStatementPositioned> ::= <UPDATE>                <SET> <setClauseList> <WHERE> <CURRENT> <OF>                <_cursor name>
                                                   | <UPDATE>                <SET> <setClauseList> <WHERE> <CURRENT> <OF> <scopeOption> <_cursor name>
                                                   | <UPDATE> <targetTable> <SET> <setClauseList> <WHERE> <CURRENT> <OF>                <_cursor name>
                                                   | <UPDATE> <targetTable> <SET> <setClauseList> <WHERE> <CURRENT> <OF> <scopeOption> <_cursor name>

<embeddedSqlHostProgram> ::=	<embeddedSqlCProgram>

<embeddedSqlStatement> ::= <sqlPrefix> <statementOrDeclaration>
                           | <sqlPrefix> <statementOrDeclaration> <sqlTerminator>

<statementOrDeclaration> ::=
		<declareCursor>
	|	<dynamicDeclareCursor>
	|	<temporaryTableDeclaration>
	|	<embeddedAuthorizationDeclaration>
	|	<embeddedPathSpecification>
	|	<embeddedTransformGroupSpecification>
	|	<embeddedCollationSpecification>
	|	<embeddedExceptionDeclaration>
	|	<sqlProcedureStatement>

<ampersandAndSqlAndLeftParen> ::= <_ampersand> <SQL> <_left paren>

<sqlPrefix> ::= <EXEC> <SQL> | <ampersandAndSqlAndLeftParen>

<sqlTerminator> ::= <END_EXEC> | <_semicolon> | <_right paren>

<embeddedAuthorizationDeclaration> ::= <DECLARE> <embeddedAuthorizationClause>

<embeddedAuthorizationClause> ::=
		<SCHEMA> <_schema name>
	|	<AUTHORIZATION> <embeddedAuthorizationIdentifier>
	|	<AUTHORIZATION> <embeddedAuthorizationIdentifier> <FOR> <STATIC> <ONLY>
	|	<AUTHORIZATION> <embeddedAuthorizationIdentifier> <FOR> <STATIC> <AND> <DYNAMIC>
	|	<SCHEMA> <_schema name> <AUTHORIZATION> <embeddedAuthorizationIdentifier>
	|	<SCHEMA> <_schema name> <AUTHORIZATION> <embeddedAuthorizationIdentifier> <FOR> <STATIC> <ONLY>
	|	<SCHEMA> <_schema name> <AUTHORIZATION> <embeddedAuthorizationIdentifier> <FOR> <STATIC> <AND> <DYNAMIC>

<embeddedAuthorizationIdentifier> ::= <moduleAuthorizationIdentifier>

<embeddedPathSpecification> ::= <pathSpecification>

<embeddedTransformGroupSpecification> ::= <transformGroupSpecification>

<embeddedCollationSpecification> ::= <moduleCollations>

<hostVariableDefinitionMany> ::= <hostVariableDefinition>+

<embeddedSqlDeclareSection> ::=
	  <embeddedSqlBeginDeclare> <embeddedSqlEndDeclare>
	| <embeddedSqlBeginDeclare> <embeddedCharacterSetDeclaration> <embeddedSqlEndDeclare>
	| <embeddedSqlBeginDeclare> <embeddedCharacterSetDeclaration> <hostVariableDefinitionMany> <embeddedSqlEndDeclare>
	| <embeddedSqlBeginDeclare> <hostVariableDefinitionMany> <embeddedSqlEndDeclare>
	| <embeddedSqlMumpsDeclare>

<embeddedCharacterSetDeclaration> ::= <SQL> <NAMES> <ARE> <_character set specification>

<embeddedSqlBeginDeclare> ::= <sqlPrefix> <BEGIN> <DECLARE> <SECTION>
                               | <sqlPrefix> <BEGIN> <DECLARE> <SECTION> <sqlTerminator>

<embeddedSqlEndDeclare> ::= <sqlPrefix> <END> <DECLARE> <SECTION>
                             | <sqlPrefix> <END> <DECLARE> <SECTION> <sqlTerminator>

<embeddedSqlMumpsDeclare> ::= <sqlPrefix> <BEGIN> <DECLARE> <SECTION> <END> <DECLARE> <SECTION> <sqlTerminator>
	| <sqlPrefix> <BEGIN> <DECLARE> <SECTION> <embeddedCharacterSetDeclaration> <END> <DECLARE> <SECTION> <sqlTerminator>
	| <sqlPrefix> <BEGIN> <DECLARE> <SECTION> <embeddedCharacterSetDeclaration> <hostVariableDefinitionMany> <END> <DECLARE> <SECTION> <sqlTerminator>
	| <sqlPrefix> <BEGIN> <DECLARE> <SECTION> <hostVariableDefinitionMany> <END> <DECLARE> <SECTION> <sqlTerminator>

<hostVariableDefinition> ::= <cVariableDefinition>

<_embedded variable name> ~ <__colon> <_host identifier>

<_host identifier> ~ <__C host identifier>

<embeddedExceptionDeclaration> ::= <WHENEVER> <condition> <conditionAction>

<condition> ::= <sqlCondition>

<sqlCondition> ::= <majorCategory>
	|	<SQLSTATE> '(' <sqlstateClassValue> ')'
	|	<SQLSTATE> '(' <sqlstateClassValue> <_comma> <sqlstateSubclassValue> ')'
	|	<CONSTRAINT> <_constraint name>

<majorCategory> ::= <SQLEXCEPTION> | <SQLWARNING> | <NOT> <FOUND>

<sqlstateClassValue> ::= <sqlstateChar><sqlstateChar>

<sqlstateSubclassValue> ::= <sqlstateChar><sqlstateChar><sqlstateChar>

<sqlstateChar> ::= <_simple Latin upper case letter> | <_digit>

<conditionAction> ::= <CONTINUE> | <goTo>

<goTo> ::= <GOTO> <gotoTarget>
          | <GO> <TO> <gotoTarget>

#
# Note: deviation from the grammar: we consider anything not starting with a digit nor <whiteSpace> and followed by anything not a <whiteSpace> to be the <hostLabelIdentifier>
#                                   Any embedded grammar but the C language, with EXEC SQL keywords, is removed.
#
<gotoTarget> ::=
		<hostLabelIdentifier>
	|	<_unsigned integer>

#
# We assume the host label identifier follows C convention
#

<hostLabelIdentifier> ::= <_C host identifier>

<embeddedSqlCProgram> ::= <EXEC> <SQL>

<cVariableDefinition> ::= <cVariableSpecification> <_semicolon>
	| <cStorageClass> <cVariableSpecification> <_semicolon>
	| <cStorageClass> <cClassModifier> <cVariableSpecification> <_semicolon>
	| <cClassModifier> <cVariableSpecification> <_semicolon>

<cVariableSpecification> ::= <cNumericVariable> | <cCharacterVariable> | <cDerivedVariable>

<cStorageClass> ::= 'auto' | 'extern' | 'static'

<cClassModifier> ::= 'const' | 'volatile'

<cHostIdentifierAndMaybeCInitialValue> ::= <_C host identifier>
                                                | <_C host identifier> <cInitialValue>

<cHostIdentifierAndMaybeCInitialValueList> ::= <cHostIdentifierAndMaybeCInitialValue>
                                                     | <cHostIdentifierAndMaybeCInitialValue> <_comma> <cHostIdentifierAndMaybeCInitialValue>
<cNumericVariable> ::= 'long' 'long' <cHostIdentifierAndMaybeCInitialValueList>
                       | 'long' <cHostIdentifierAndMaybeCInitialValueList>
                       | 'short' <cHostIdentifierAndMaybeCInitialValueList>
                       | 'float' <cHostIdentifierAndMaybeCInitialValueList>
                       | 'double' <cHostIdentifierAndMaybeCInitialValueList>

<cHostIdentifierAndCArraySpecificationAndMaybeCInitialValue> ::= <_C host identifier> <cArraySpecification>
                                                                          | <_C host identifier> <cArraySpecification> <cInitialValue>

<cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList> ::= <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValue>
                                                                               | <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList> <_comma> <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValue>

<cCharacterVariable> ::= <cCharacterType>                                                      <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>
                         | <cCharacterType> <CHARACTER> <SET> <_character set specification>      <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>
                         | <cCharacterType> <CHARACTER> <SET> <IS> <_character set specification> <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>

<cCharacterType> ::= 'char' | 'unsigned' 'char' | 'unsigned' 'short'

<cArraySpecification> ::= <_left bracket> <length> <_right bracket>

<C L>          ~ [a-zA-Z_]
<C A>          ~ [a-zA-Z_0-9]
<cAAny>      ~ <C A>*
<C IDENTIFIER>          ~ <C L> <cAAny>

<__C host identifier> ~ <C IDENTIFIER>
<_C host identifier> ~ <__C host identifier>

<cDerivedVariable> ::=
		<cVarcharVariable>
	|	<cNcharVariable>
	|	<cNcharVaryingVariable>
	|	<cClobVariable>
	|	<cNclobVariable>
	|	<cBlobVariable>
	|	<cUserDefinedTypeVariable>
	|	<cClobLocatorVariable>
	|	<cBlobLocatorVariable>
	|	<cArrayLocatorVariable>
	|	<cMultisetLocatorVariable>
	|	<cUserDefinedTypeLocatorVariable>
	|	<cRefVariable>

<cVarcharVariable> ::= <VARCHAR>                                                      <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>
                       | <VARCHAR> <CHARACTER> <SET>      <_character set specification> <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>
                       | <VARCHAR> <CHARACTER> <SET> <IS> <_character set specification> <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>

<cNcharVariable> ::= <NCHAR>                                                      <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>
                     | <NCHAR> <CHARACTER> <SET>      <_character set specification> <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>
                     | <NCHAR> <CHARACTER> <SET> <IS> <_character set specification> <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>

<cNcharVaryingVariable> ::= <NCHAR> <VARYING>                                                      <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>
                             | <NCHAR> <VARYING> <CHARACTER> <SET>      <_character set specification> <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>
                             | <NCHAR> <VARYING> <CHARACTER> <SET> <IS> <_character set specification> <cHostIdentifierAndCArraySpecificationAndMaybeCInitialValueList>

<cClobVariable> ::= <SQL> <TYPE> <IS> <CLOB> <_left paren> <largeObjectLength> <_right paren>	                                                     <cHostIdentifierAndMaybeCInitialValueList>
                    | <SQL> <TYPE> <IS> <CLOB> <_left paren> <largeObjectLength> <_right paren>	<CHARACTER> <SET>      <_character set specification> <cHostIdentifierAndMaybeCInitialValueList>
                    | <SQL> <TYPE> <IS> <CLOB> <_left paren> <largeObjectLength> <_right paren>	<CHARACTER> <SET> <IS> <_character set specification> <cHostIdentifierAndMaybeCInitialValueList>

<cNclobVariable> ::= <SQL> <TYPE> <IS> <NCLOB> <_left paren> <largeObjectLength> <_right paren>	                                                     <cHostIdentifierAndMaybeCInitialValueList>
                     | <SQL> <TYPE> <IS> <NCLOB> <_left paren> <largeObjectLength> <_right paren>	<CHARACTER> <SET>      <_character set specification> <cHostIdentifierAndMaybeCInitialValueList>
                     | <SQL> <TYPE> <IS> <NCLOB> <_left paren> <largeObjectLength> <_right paren>	<CHARACTER> <SET> <IS> <_character set specification> <cHostIdentifierAndMaybeCInitialValueList>

<cUserDefinedTypeVariable> ::= <SQL> <TYPE> <IS> <pathResolvedUserDefinedTypeName> <AS> <predefinedType>	                                                     <cHostIdentifierAndMaybeCInitialValueList>
                                 | <SQL> <TYPE> <IS> <pathResolvedUserDefinedTypeName> <AS> <predefinedType>	<CHARACTER> <SET>      <_character set specification> <cHostIdentifierAndMaybeCInitialValueList>
                                 | <SQL> <TYPE> <IS> <pathResolvedUserDefinedTypeName> <AS> <predefinedType>	<CHARACTER> <SET> <IS> <_character set specification> <cHostIdentifierAndMaybeCInitialValueList>

<cBlobVariable> ::= <SQL> <TYPE> <IS> <BLOB> <_left paren> <largeObjectLength> <_right paren>	                                                     <cHostIdentifierAndMaybeCInitialValueList>
                    | <SQL> <TYPE> <IS> <BLOB> <_left paren> <largeObjectLength> <_right paren>	<CHARACTER> <SET>      <_character set specification> <cHostIdentifierAndMaybeCInitialValueList>
                    | <SQL> <TYPE> <IS> <BLOB> <_left paren> <largeObjectLength> <_right paren>	<CHARACTER> <SET> <IS> <_character set specification> <cHostIdentifierAndMaybeCInitialValueList>

<cClobLocatorVariable> ::= <SQL> <TYPE> <IS> <CLOB> <AS> <LOCATOR> <cHostIdentifierAndMaybeCInitialValueList>

<cBlobLocatorVariable> ::= <SQL> <TYPE> <IS> <BLOB> <AS> <LOCATOR> <cHostIdentifierAndMaybeCInitialValueList>

<cArrayLocatorVariable> ::= <SQL> <TYPE> <IS> <arrayType> <AS> <LOCATOR> <cHostIdentifierAndMaybeCInitialValueList>

<cMultisetLocatorVariable> ::= <SQL> <TYPE> <IS> <multisetType> <AS> <LOCATOR> <cHostIdentifierAndMaybeCInitialValueList>

<cUserDefinedTypeLocatorVariable> ::= <SQL> <TYPE> <IS> <pathResolvedUserDefinedTypeName> <AS> <LOCATOR> <cHostIdentifierAndMaybeCInitialValueList>

<cRefVariable> ::= <SQL> <TYPE> <IS> <referenceType>

<characterRepresentations> ::= <_character representation>+

<cInitialValue> ::= <_equals operator> <characterRepresentations>

<directSqlStatement> ::= <directlyExecutableStatement> <_semicolon>

#
# <directImplementationDefinedStatement> is dropped
#

<directlyExecutableStatement> ::=
		<directSqlDataStatement>
	|	<sqlSchemaStatement>
	|	<sqlTransactionStatement>
	|	<sqlConnectionStatement>
	|	<sqlSessionStatement>

<directSqlDataStatement> ::=
		<deleteStatementSearched>
	|	<directSelectStatementMultipleRows>
	|	<insertStatement>
	|	<updateStatementSearched>
	|	<mergeStatement>
	|	<temporaryTableDeclaration>

<directSelectStatementMultipleRows> ::= <cursorSpecification>

<getDiagnosticsStatement> ::= <GET> <DIAGNOSTICS> <sqlDiagnosticsInformation>

<sqlDiagnosticsInformation> ::= <statementInformation> | <conditionInformation>

<statementInformation> ::= <statementInformationItem>
                          | <statementInformation> <_comma> <statementInformationItem>

<statementInformationItem> ::= <simpleTargetSpecification> <_equals operator> <statementInformationItemName>

<statementInformationItemName> ::=
		<NUMBER>
	|	<MORE>
	|	<COMMAND_FUNCTION>
	|	<COMMAND_FUNCTION_CODE>
	|	<DYNAMIC_FUNCTION>
	|	<DYNAMIC_FUNCTION_CODE>
	|	<ROW_COUNT>
	|	<TRANSACTIONS_COMMITTED>
	|	<TRANSACTIONS_ROLLED_BACK>
	|	<TRANSACTION_ACTIVE>

<conditionInformationItems> ::= <conditionInformationItem>
                                | <conditionInformationItems> <_comma> <conditionInformationItem>

<conditionInformation> ::=
		<EXCEPTION> <conditionNumber> <conditionInformationItems>
	|	<CONDITION> <conditionNumber> <conditionInformationItems>

<conditionInformationItem> ::= <simpleTargetSpecification> <_equals operator> <conditionInformationItemName>

<conditionInformationItemName> ::=
		<CATALOG_NAME>
	|	<CLASS_ORIGIN>
	|	<COLUMN_NAME>
	|	<CONDITION_NUMBER>
	|	<CONNECTION_NAME>
	|	<CONSTRAINT_CATALOG>
	|	<CONSTRAINT_NAME>
	|	<CONSTRAINT_SCHEMA>
	|	<CURSOR_NAME>
	|	<MESSAGE_LENGTH>
	|	<MESSAGE_OCTET_LENGTH>
	|	<MESSAGE_TEXT>
	|	<PARAMETER_MODE>
	|	<PARAMETER_NAME>
	|	<PARAMETER_ORDINAL_POSITION>
	|	<RETURNED_SQLSTATE>
	|	<ROUTINE_CATALOG>
	|	<ROUTINE_NAME>
	|	<ROUTINE_SCHEMA>
	|	<SCHEMA_NAME>
	|	<SERVER_NAME>
	|	<SPECIFIC_NAME>
	|	<SUBCLASS_ORIGIN>
	|	<TABLE_NAME>
	|	<TRIGGER_CATALOG>
	|	<TRIGGER_NAME>
	|	<TRIGGER_SCHEMA>

<conditionNumber> ::= <simpleValueSpecification>

#
# Case-insensitive versions of keywords
#
:lexeme ~ <A> priority => 1
<A> ~ [Aa]
:lexeme ~ <ABS> priority => 1
<ABS> ~ [Aa][Bb][Ss]
:lexeme ~ <ABSOLUTE> priority => 1
<ABSOLUTE> ~ [Aa][Bb][Ss][Oo][Ll][Uu][Tt][Ee]
:lexeme ~ <ACTION> priority => 1
<ACTION> ~ [Aa][Cc][Tt][Ii][Oo][Nn]
:lexeme ~ <ADD> priority => 1
<ADD> ~ [Aa][Dd][Dd]
:lexeme ~ <ADMIN> priority => 1
<ADMIN> ~ [Aa][Dd][Mm][Ii][Nn]
:lexeme ~ <AFTER> priority => 1
<AFTER> ~ [Aa][Ff][Tt][Ee][Rr]
:lexeme ~ <ALL> priority => 1
<ALL> ~ [Aa][Ll][Ll]
:lexeme ~ <ALLOCATE> priority => 1
<ALLOCATE> ~ [Aa][Ll][Ll][Oo][Cc][Aa][Tt][Ee]
:lexeme ~ <ALTER> priority => 1
<ALTER> ~ [Aa][Ll][Tt][Ee][Rr]
:lexeme ~ <ALWAYS> priority => 1
<ALWAYS> ~ [Aa][Ll][Ww][Aa][Yy][Ss]
:lexeme ~ <AND> priority => 1
<AND> ~ [Aa][Nn][Dd]
:lexeme ~ <ANY> priority => 1
<ANY> ~ [Aa][Nn][Yy]
:lexeme ~ <ARE> priority => 1
<ARE> ~ [Aa][Rr][Ee]
:lexeme ~ <ARRAY> priority => 1
<ARRAY> ~ [Aa][Rr][Rr][Aa][Yy]
:lexeme ~ <AS> priority => 1
<AS> ~ [Aa][Ss]
:lexeme ~ <ASC> priority => 1
<ASC> ~ [Aa][Ss][Cc]
:lexeme ~ <ASENSITIVE> priority => 1
<ASENSITIVE> ~ [Aa][Ss][Ee][Nn][Ss][Ii][Tt][Ii][Vv][Ee]
:lexeme ~ <ASSERTION> priority => 1
<ASSERTION> ~ [Aa][Ss][Ss][Ee][Rr][Tt][Ii][Oo][Nn]
:lexeme ~ <ASSIGNMENT> priority => 1
<ASSIGNMENT> ~ [Aa][Ss][Ss][Ii][Gg][Nn][Mm][Ee][Nn][Tt]
:lexeme ~ <ASYMMETRIC> priority => 1
<ASYMMETRIC> ~ [Aa][Ss][Yy][Mm][Mm][Ee][Tt][Rr][Ii][Cc]
:lexeme ~ <AT> priority => 1
<AT> ~ [Aa][Tt]
:lexeme ~ <ATOMIC> priority => 1
<ATOMIC> ~ [Aa][Tt][Oo][Mm][Ii][Cc]
:lexeme ~ <ATTRIBUTE> priority => 1
<ATTRIBUTE> ~ [Aa][Tt][Tt][Rr][Ii][Bb][Uu][Tt][Ee]
:lexeme ~ <ATTRIBUTES> priority => 1
<ATTRIBUTES> ~ [Aa][Tt][Tt][Rr][Ii][Bb][Uu][Tt][Ee][Ss]
:lexeme ~ <AUTHORIZATION> priority => 1
<AUTHORIZATION> ~ [Aa][Uu][Tt][Hh][Oo][Rr][Ii][Zz][Aa][Tt][Ii][Oo][Nn]
:lexeme ~ <AVG> priority => 1
<AVG> ~ [Aa][Vv][Gg]
:lexeme ~ <BEFORE> priority => 1
<BEFORE> ~ [Bb][Ee][Ff][Oo][Rr][Ee]
:lexeme ~ <BEGIN> priority => 1
<BEGIN> ~ [Bb][Ee][Gg][Ii][Nn]
:lexeme ~ <BERNOULLI> priority => 1
<BERNOULLI> ~ [Bb][Ee][Rr][Nn][Oo][Uu][Ll][Ll][Ii]
:lexeme ~ <BETWEEN> priority => 1
<BETWEEN> ~ [Bb][Ee][Tt][Ww][Ee][Ee][Nn]
:lexeme ~ <BIGINT> priority => 1
<BIGINT> ~ [Bb][Ii][Gg][Ii][Nn][Tt]
:lexeme ~ <BINARY> priority => 1
<BINARY> ~ [Bb][Ii][Nn][Aa][Rr][Yy]
:lexeme ~ <BLOB> priority => 1
<BLOB> ~ [Bb][Ll][Oo][Bb]
:lexeme ~ <BOOLEAN> priority => 1
<BOOLEAN> ~ [Bb][Oo][Oo][Ll][Ee][Aa][Nn]
:lexeme ~ <BOTH> priority => 1
<BOTH> ~ [Bb][Oo][Tt][Hh]
:lexeme ~ <BREADTH> priority => 1
<BREADTH> ~ [Bb][Rr][Ee][Aa][Dd][Tt][Hh]
:lexeme ~ <BY> priority => 1
<BY> ~ [Bb][Yy]
:lexeme ~ <C> priority => 1
<C> ~ [Cc]
:lexeme ~ <CALL> priority => 1
<CALL> ~ [Cc][Aa][Ll][Ll]
:lexeme ~ <CALLED> priority => 1
<CALLED> ~ [Cc][Aa][Ll][Ll][Ee][Dd]
:lexeme ~ <CARDINALITY> priority => 1
<CARDINALITY> ~ [Cc][Aa][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy]
:lexeme ~ <CASCADE> priority => 1
<CASCADE> ~ [Cc][Aa][Ss][Cc][Aa][Dd][Ee]
:lexeme ~ <CASCADED> priority => 1
<CASCADED> ~ [Cc][Aa][Ss][Cc][Aa][Dd][Ee][Dd]
:lexeme ~ <CASE> priority => 1
<CASE> ~ [Cc][Aa][Ss][Ee]
:lexeme ~ <CAST> priority => 1
<CAST> ~ [Cc][Aa][Ss][Tt]
:lexeme ~ <CATALOG> priority => 1
<CATALOG> ~ [Cc][Aa][Tt][Aa][Ll][Oo][Gg]
:lexeme ~ <CATALOG_NAME> priority => 1
<CATALOG_NAME> ~ [Cc][Aa][Tt][Aa][Ll][Oo][Gg]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <CEIL> priority => 1
<CEIL> ~ [Cc][Ee][Ii][Ll]
:lexeme ~ <CEILING> priority => 1
<CEILING> ~ [Cc][Ee][Ii][Ll][Ii][Nn][Gg]
:lexeme ~ <CHAIN> priority => 1
<CHAIN> ~ [Cc][Hh][Aa][Ii][Nn]
:lexeme ~ <CHAR> priority => 1
<CHAR> ~ [Cc][Hh][Aa][Rr]
:lexeme ~ <CHARACTER> priority => 1
<CHARACTER> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]
:lexeme ~ <CHARACTERISTICS> priority => 1
<CHARACTERISTICS> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr][Ii][Ss][Tt][Ii][Cc][Ss]
:lexeme ~ <CHARACTERS> priority => 1
<CHARACTERS> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr][Ss]
:lexeme ~ <CHARACTER_LENGTH> priority => 1
<CHARACTER_LENGTH> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
:lexeme ~ <CHARACTER_SET_CATALOG> priority => 1
<CHARACTER_SET_CATALOG> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]'_'[Ss][Ee][Tt]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
:lexeme ~ <CHARACTER_SET_NAME> priority => 1
<CHARACTER_SET_NAME> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]'_'[Ss][Ee][Tt]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <CHARACTER_SET_SCHEMA> priority => 1
<CHARACTER_SET_SCHEMA> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]'_'[Ss][Ee][Tt]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
:lexeme ~ <CHAR_LENGTH> priority => 1
<CHAR_LENGTH> ~ [Cc][Hh][Aa][Rr]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
:lexeme ~ <CHECK> priority => 1
<CHECK> ~ [Cc][Hh][Ee][Cc][Kk]
:lexeme ~ <CHECKED> priority => 1
<CHECKED> ~ [Cc][Hh][Ee][Cc][Kk][Ee][Dd]
:lexeme ~ <CLASS_ORIGIN> priority => 1
<CLASS_ORIGIN> ~ [Cc][Ll][Aa][Ss][Ss]'_'[Oo][Rr][Ii][Gg][Ii][Nn]
:lexeme ~ <CLOB> priority => 1
<CLOB> ~ [Cc][Ll][Oo][Bb]
:lexeme ~ <CLOSE> priority => 1
<CLOSE> ~ [Cc][Ll][Oo][Ss][Ee]
:lexeme ~ <COALESCE> priority => 1
<COALESCE> ~ [Cc][Oo][Aa][Ll][Ee][Ss][Cc][Ee]
:lexeme ~ <CODE_UNITS> priority => 1
<CODE_UNITS> ~ [Cc][Oo][Dd][Ee]'_'[Uu][Nn][Ii][Tt][Ss]
:lexeme ~ <COLLATE> priority => 1
<COLLATE> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ee]
:lexeme ~ <COLLATION> priority => 1
<COLLATION> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]
:lexeme ~ <COLLATION_CATALOG> priority => 1
<COLLATION_CATALOG> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
:lexeme ~ <COLLATION_NAME> priority => 1
<COLLATION_NAME> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <COLLATION_SCHEMA> priority => 1
<COLLATION_SCHEMA> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
:lexeme ~ <COLLECT> priority => 1
<COLLECT> ~ [Cc][Oo][Ll][Ll][Ee][Cc][Tt]
:lexeme ~ <COLUMN> priority => 1
<COLUMN> ~ [Cc][Oo][Ll][Uu][Mm][Nn]
:lexeme ~ <COLUMN_NAME> priority => 1
<COLUMN_NAME> ~ [Cc][Oo][Ll][Uu][Mm][Nn]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <COMMAND_FUNCTION> priority => 1
<COMMAND_FUNCTION> ~ [Cc][Oo][Mm][Mm][Aa][Nn][Dd]'_'[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]
:lexeme ~ <COMMAND_FUNCTION_CODE> priority => 1
<COMMAND_FUNCTION_CODE> ~ [Cc][Oo][Mm][Mm][Aa][Nn][Dd]'_'[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]'_'[Cc][Oo][Dd][Ee]
:lexeme ~ <COMMIT> priority => 1
<COMMIT> ~ [Cc][Oo][Mm][Mm][Ii][Tt]
:lexeme ~ <COMMITTED> priority => 1
<COMMITTED> ~ [Cc][Oo][Mm][Mm][Ii][Tt][Tt][Ee][Dd]
:lexeme ~ <CONDITION> priority => 1
<CONDITION> ~ [Cc][Oo][Nn][Dd][Ii][Tt][Ii][Oo][Nn]
:lexeme ~ <CONDITION_NUMBER> priority => 1
<CONDITION_NUMBER> ~ [Cc][Oo][Nn][Dd][Ii][Tt][Ii][Oo][Nn]'_'[Nn][Uu][Mm][Bb][Ee][Rr]
:lexeme ~ <CONNECT> priority => 1
<CONNECT> ~ [Cc][Oo][Nn][Nn][Ee][Cc][Tt]
:lexeme ~ <CONNECTION> priority => 1
<CONNECTION> ~ [Cc][Oo][Nn][Nn][Ee][Cc][Tt][Ii][Oo][Nn]
:lexeme ~ <CONNECTION_NAME> priority => 1
<CONNECTION_NAME> ~ [Cc][Oo][Nn][Nn][Ee][Cc][Tt][Ii][Oo][Nn]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <CONSTRAINT> priority => 1
<CONSTRAINT> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]
:lexeme ~ <CONSTRAINTS> priority => 1
<CONSTRAINTS> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt][Ss]
:lexeme ~ <CONSTRAINT_CATALOG> priority => 1
<CONSTRAINT_CATALOG> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
:lexeme ~ <CONSTRAINT_NAME> priority => 1
<CONSTRAINT_NAME> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <CONSTRAINT_SCHEMA> priority => 1
<CONSTRAINT_SCHEMA> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
:lexeme ~ <CONSTRUCTOR> priority => 1
<CONSTRUCTOR> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Uu][Cc][Tt][Oo][Rr]
:lexeme ~ <CONTAINS> priority => 1
<CONTAINS> ~ [Cc][Oo][Nn][Tt][Aa][Ii][Nn][Ss]
:lexeme ~ <CONTINUE> priority => 1
<CONTINUE> ~ [Cc][Oo][Nn][Tt][Ii][Nn][Uu][Ee]
:lexeme ~ <CONVERT> priority => 1
<CONVERT> ~ [Cc][Oo][Nn][Vv][Ee][Rr][Tt]
:lexeme ~ <CORR> priority => 1
<CORR> ~ [Cc][Oo][Rr][Rr]
:lexeme ~ <CORRESPONDING> priority => 1
<CORRESPONDING> ~ [Cc][Oo][Rr][Rr][Ee][Ss][Pp][Oo][Nn][Dd][Ii][Nn][Gg]
:lexeme ~ <COUNT> priority => 1
<COUNT> ~ [Cc][Oo][Uu][Nn][Tt]
:lexeme ~ <COVAR_POP> priority => 1
<COVAR_POP> ~ [Cc][Oo][Vv][Aa][Rr]'_'[Pp][Oo][Pp]
:lexeme ~ <COVAR_SAMP> priority => 1
<COVAR_SAMP> ~ [Cc][Oo][Vv][Aa][Rr]'_'[Ss][Aa][Mm][Pp]
:lexeme ~ <CREATE> priority => 1
<CREATE> ~ [Cc][Rr][Ee][Aa][Tt][Ee]
:lexeme ~ <CROSS> priority => 1
<CROSS> ~ [Cc][Rr][Oo][Ss][Ss]
:lexeme ~ <CUBE> priority => 1
<CUBE> ~ [Cc][Uu][Bb][Ee]
:lexeme ~ <CUME_DIST> priority => 1
<CUME_DIST> ~ [Cc][Uu][Mm][Ee]'_'[Dd][Ii][Ss][Tt]
:lexeme ~ <CURRENT> priority => 1
<CURRENT> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]
:lexeme ~ <CURRENT_COLLATION> priority => 1
<CURRENT_COLLATION> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]
:lexeme ~ <CURRENT_DATE> priority => 1
<CURRENT_DATE> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Dd][Aa][Tt][Ee]
:lexeme ~ <CURRENT_DEFAULT_TRANSFORM_GROUP> priority => 1
<CURRENT_DEFAULT_TRANSFORM_GROUP> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Dd][Ee][Ff][Aa][Uu][Ll][Tt]'_'[Tt][Rr][Aa][Nn][Ss][Ff][Oo][Rr][Mm]'_'[Gg][Rr][Oo][Uu][Pp]
:lexeme ~ <CURRENT_PATH> priority => 1
<CURRENT_PATH> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Pp][Aa][Tt][Hh]
:lexeme ~ <CURRENT_ROLE> priority => 1
<CURRENT_ROLE> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Rr][Oo][Ll][Ee]
:lexeme ~ <CURRENT_TIME> priority => 1
<CURRENT_TIME> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Tt][Ii][Mm][Ee]
:lexeme ~ <CURRENT_TIMESTAMP> priority => 1
<CURRENT_TIMESTAMP> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Tt][Ii][Mm][Ee][Ss][Tt][Aa][Mm][Pp]
:lexeme ~ <CURRENT_TRANSFORM_GROUP_FOR_TYPE> priority => 1
<CURRENT_TRANSFORM_GROUP_FOR_TYPE> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Tt][Rr][Aa][Nn][Ss][Ff][Oo][Rr][Mm]'_'[Gg][Rr][Oo][Uu][Pp]'_'[Ff][Oo][Rr]'_'[Tt][Yy][Pp][Ee]
:lexeme ~ <CURRENT_USER> priority => 1
<CURRENT_USER> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Uu][Ss][Ee][Rr]
:lexeme ~ <CURSOR> priority => 1
<CURSOR> ~ [Cc][Uu][Rr][Ss][Oo][Rr]
:lexeme ~ <CURSOR_NAME> priority => 1
<CURSOR_NAME> ~ [Cc][Uu][Rr][Ss][Oo][Rr]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <CYCLE> priority => 1
<CYCLE> ~ [Cc][Yy][Cc][Ll][Ee]
:lexeme ~ <DATA> priority => 1
<DATA> ~ [Dd][Aa][Tt][Aa]
<__DATE> ~ [Dd][Aa][Tt][Ee]
:lexeme ~ <DATE> priority => 1
<DATE> ~ <__DATE>
:lexeme ~ <DATETIME_INTERVAL_CODE> priority => 1
<DATETIME_INTERVAL_CODE> ~ [Dd][Aa][Tt][Ee][Tt][Ii][Mm][Ee]'_'[Ii][Nn][Tt][Ee][Rr][Vv][Aa][Ll]'_'[Cc][Oo][Dd][Ee]
:lexeme ~ <DATETIME_INTERVAL_PRECISION> priority => 1
<DATETIME_INTERVAL_PRECISION> ~ [Dd][Aa][Tt][Ee][Tt][Ii][Mm][Ee]'_'[Ii][Nn][Tt][Ee][Rr][Vv][Aa][Ll]'_'[Pp][Rr][Ee][Cc][Ii][Ss][Ii][Oo][Nn]
:lexeme ~ <DAY> priority => 1
<DAY> ~ [Dd][Aa][Yy]
:lexeme ~ <DEALLOCATE> priority => 1
<DEALLOCATE> ~ [Dd][Ee][Aa][Ll][Ll][Oo][Cc][Aa][Tt][Ee]
:lexeme ~ <DEC> priority => 1
<DEC> ~ [Dd][Ee][Cc]
:lexeme ~ <DECIMAL> priority => 1
<DECIMAL> ~ [Dd][Ee][Cc][Ii][Mm][Aa][Ll]
:lexeme ~ <DECLARE> priority => 1
<DECLARE> ~ [Dd][Ee][Cc][Ll][Aa][Rr][Ee]
:lexeme ~ <DEFAULT> priority => 1
<DEFAULT> ~ [Dd][Ee][Ff][Aa][Uu][Ll][Tt]
:lexeme ~ <DEFAULTS> priority => 1
<DEFAULTS> ~ [Dd][Ee][Ff][Aa][Uu][Ll][Tt][Ss]
:lexeme ~ <DEFERRABLE> priority => 1
<DEFERRABLE> ~ [Dd][Ee][Ff][Ee][Rr][Rr][Aa][Bb][Ll][Ee]
:lexeme ~ <DEFERRED> priority => 1
<DEFERRED> ~ [Dd][Ee][Ff][Ee][Rr][Rr][Ee][Dd]
:lexeme ~ <DEFINED> priority => 1
<DEFINED> ~ [Dd][Ee][Ff][Ii][Nn][Ee][Dd]
:lexeme ~ <DEFINER> priority => 1
<DEFINER> ~ [Dd][Ee][Ff][Ii][Nn][Ee][Rr]
:lexeme ~ <DEGREE> priority => 1
<DEGREE> ~ [Dd][Ee][Gg][Rr][Ee][Ee]
:lexeme ~ <DELETE> priority => 1
<DELETE> ~ [Dd][Ee][Ll][Ee][Tt][Ee]
:lexeme ~ <DENSE_RANK> priority => 1
<DENSE_RANK> ~ [Dd][Ee][Nn][Ss][Ee]'_'[Rr][Aa][Nn][Kk]
:lexeme ~ <DEPTH> priority => 1
<DEPTH> ~ [Dd][Ee][Pp][Tt][Hh]
:lexeme ~ <DEREF> priority => 1
<DEREF> ~ [Dd][Ee][Rr][Ee][Ff]
:lexeme ~ <DERIVED> priority => 1
<DERIVED> ~ [Dd][Ee][Rr][Ii][Vv][Ee][Dd]
:lexeme ~ <DESC> priority => 1
<DESC> ~ [Dd][Ee][Ss][Cc]
:lexeme ~ <DESCRIBE> priority => 1
<DESCRIBE> ~ [Dd][Ee][Ss][Cc][Rr][Ii][Bb][Ee]
:lexeme ~ <DESCRIPTOR> priority => 1
<DESCRIPTOR> ~ [Dd][Ee][Ss][Cc][Rr][Ii][Pp][Tt][Oo][Rr]
:lexeme ~ <DETERMINISTIC> priority => 1
<DETERMINISTIC> ~ [Dd][Ee][Tt][Ee][Rr][Mm][Ii][Nn][Ii][Ss][Tt][Ii][Cc]
:lexeme ~ <DIAGNOSTICS> priority => 1
<DIAGNOSTICS> ~ [Dd][Ii][Aa][Gg][Nn][Oo][Ss][Tt][Ii][Cc][Ss]
:lexeme ~ <DISCONNECT> priority => 1
<DISCONNECT> ~ [Dd][Ii][Ss][Cc][Oo][Nn][Nn][Ee][Cc][Tt]
:lexeme ~ <DISPATCH> priority => 1
<DISPATCH> ~ [Dd][Ii][Ss][Pp][Aa][Tt][Cc][Hh]
:lexeme ~ <DISTINCT> priority => 1
<DISTINCT> ~ [Dd][Ii][Ss][Tt][Ii][Nn][Cc][Tt]
:lexeme ~ <DOMAIN> priority => 1
<DOMAIN> ~ [Dd][Oo][Mm][Aa][Ii][Nn]
:lexeme ~ <DOUBLE> priority => 1
<DOUBLE> ~ [Dd][Oo][Uu][Bb][Ll][Ee]
:lexeme ~ <DROP> priority => 1
<DROP> ~ [Dd][Rr][Oo][Pp]
:lexeme ~ <DYNAMIC> priority => 1
<DYNAMIC> ~ [Dd][Yy][Nn][Aa][Mm][Ii][Cc]
:lexeme ~ <DYNAMIC_FUNCTION> priority => 1
<DYNAMIC_FUNCTION> ~ [Dd][Yy][Nn][Aa][Mm][Ii][Cc]'_'[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]
:lexeme ~ <DYNAMIC_FUNCTION_CODE> priority => 1
<DYNAMIC_FUNCTION_CODE> ~ [Dd][Yy][Nn][Aa][Mm][Ii][Cc]'_'[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]'_'[Cc][Oo][Dd][Ee]
<__E> ~ [Ee]
:lexeme ~ <EACH> priority => 1
<EACH> ~ [Ee][Aa][Cc][Hh]
:lexeme ~ <ELEMENT> priority => 1
<ELEMENT> ~ [Ee][Ll][Ee][Mm][Ee][Nn][Tt]
:lexeme ~ <ELSE> priority => 1
<ELSE> ~ [Ee][Ll][Ss][Ee]
:lexeme ~ <END> priority => 1
<END> ~ [Ee][Nn][Dd]
:lexeme ~ <END_EXEC> priority => 1
<END_EXEC> ~ [Ee][Nn][Dd]'-'[Ee][Xx][Ee][Cc]
:lexeme ~ <EQUALS> priority => 1
<EQUALS> ~ [Ee][Qq][Uu][Aa][Ll][Ss]
<__ESCAPE> ~ [Ee][Ss][Cc][Aa][Pp][Ee]
:lexeme ~ <ESCAPE> priority => 1
<ESCAPE> ~ <__ESCAPE>
:lexeme ~ <EVERY> priority => 1
<EVERY> ~ [Ee][Vv][Ee][Rr][Yy]
:lexeme ~ <EXCEPT> priority => 1
<EXCEPT> ~ [Ee][Xx][Cc][Ee][Pp][Tt]
:lexeme ~ <EXCEPTION> priority => 1
<EXCEPTION> ~ [Ee][Xx][Cc][Ee][Pp][Tt][Ii][Oo][Nn]
:lexeme ~ <EXCLUDE> priority => 1
<EXCLUDE> ~ [Ee][Xx][Cc][Ll][Uu][Dd][Ee]
:lexeme ~ <EXCLUDING> priority => 1
<EXCLUDING> ~ [Ee][Xx][Cc][Ll][Uu][Dd][Ii][Nn][Gg]
:lexeme ~ <EXEC> priority => 1
<EXEC> ~ [Ee][Xx][Ee][Cc]
:lexeme ~ <EXECUTE> priority => 1
<EXECUTE> ~ [Ee][Xx][Ee][Cc][Uu][Tt][Ee]
:lexeme ~ <EXISTS> priority => 1
<EXISTS> ~ [Ee][Xx][Ii][Ss][Tt][Ss]
:lexeme ~ <EXP> priority => 1
<EXP> ~ [Ee][Xx][Pp]
:lexeme ~ <EXTERNAL> priority => 1
<EXTERNAL> ~ [Ee][Xx][Tt][Ee][Rr][Nn][Aa][Ll]
:lexeme ~ <EXTRACT> priority => 1
<EXTRACT> ~ [Ee][Xx][Tt][Rr][Aa][Cc][Tt]
<__FALSE> ~ [Ff][Aa][Ll][Ss][Ee]
:lexeme ~ <FALSE> priority => 1
<FALSE> ~ <__FALSE>
:lexeme ~ <FETCH> priority => 1
<FETCH> ~ [Ff][Ee][Tt][Cc][Hh]
:lexeme ~ <FILTER> priority => 1
<FILTER> ~ [Ff][Ii][Ll][Tt][Ee][Rr]
:lexeme ~ <FINAL> priority => 1
<FINAL> ~ [Ff][Ii][Nn][Aa][Ll]
:lexeme ~ <FIRST> priority => 1
<FIRST> ~ [Ff][Ii][Rr][Ss][Tt]
:lexeme ~ <FLOAT> priority => 1
<FLOAT> ~ [Ff][Ll][Oo][Aa][Tt]
:lexeme ~ <FLOOR> priority => 1
<FLOOR> ~ [Ff][Ll][Oo][Oo][Rr]
:lexeme ~ <FOLLOWING> priority => 1
<FOLLOWING> ~ [Ff][Oo][Ll][Ll][Oo][Ww][Ii][Nn][Gg]
:lexeme ~ <FOR> priority => 1
<FOR> ~ [Ff][Oo][Rr]
:lexeme ~ <FOREIGN> priority => 1
<FOREIGN> ~ [Ff][Oo][Rr][Ee][Ii][Gg][Nn]
:lexeme ~ <FOUND> priority => 1
<FOUND> ~ [Ff][Oo][Uu][Nn][Dd]
:lexeme ~ <FREE> priority => 1
<FREE> ~ [Ff][Rr][Ee][Ee]
:lexeme ~ <FROM> priority => 1
<FROM> ~ [Ff][Rr][Oo][Mm]
:lexeme ~ <FULL> priority => 1
<FULL> ~ [Ff][Uu][Ll][Ll]
:lexeme ~ <FUNCTION> priority => 1
<FUNCTION> ~ [Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]
:lexeme ~ <FUSION> priority => 1
<FUSION> ~ [Ff][Uu][Ss][Ii][Oo][Nn]
:lexeme ~ <GENERAL> priority => 1
<GENERAL> ~ [Gg][Ee][Nn][Ee][Rr][Aa][Ll]
:lexeme ~ <GENERATED> priority => 1
<GENERATED> ~ [Gg][Ee][Nn][Ee][Rr][Aa][Tt][Ee][Dd]
:lexeme ~ <GET> priority => 1
<GET> ~ [Gg][Ee][Tt]
<__GLOBAL> ~ [Gg][Ll][Oo][Bb][Aa][Ll]
:lexeme ~ <GLOBAL> priority => 1
<GLOBAL> ~ <__GLOBAL>
:lexeme ~ <GO> priority => 1
<GO> ~ [Gg][Oo]
:lexeme ~ <GOTO> priority => 1
<GOTO> ~ [Gg][Oo][Tt][Oo]
:lexeme ~ <GRANT> priority => 1
<GRANT> ~ [Gg][Rr][Aa][Nn][Tt]
:lexeme ~ <GRANTED> priority => 1
<GRANTED> ~ [Gg][Rr][Aa][Nn][Tt][Ee][Dd]
:lexeme ~ <GROUP> priority => 1
<GROUP> ~ [Gg][Rr][Oo][Uu][Pp]
:lexeme ~ <GROUPING> priority => 1
<GROUPING> ~ [Gg][Rr][Oo][Uu][Pp][Ii][Nn][Gg]
:lexeme ~ <HAVING> priority => 1
<HAVING> ~ [Hh][Aa][Vv][Ii][Nn][Gg]
:lexeme ~ <HIERARCHY> priority => 1
<HIERARCHY> ~ [Hh][Ii][Ee][Rr][Aa][Rr][Cc][Hh][Yy]
:lexeme ~ <HOLD> priority => 1
<HOLD> ~ [Hh][Oo][Ll][Dd]
:lexeme ~ <HOUR> priority => 1
<HOUR> ~ [Hh][Oo][Uu][Rr]
:lexeme ~ <IDENTITY> priority => 1
<IDENTITY> ~ [Ii][Dd][Ee][Nn][Tt][Ii][Tt][Yy]
:lexeme ~ <IMMEDIATE> priority => 1
<IMMEDIATE> ~ [Ii][Mm][Mm][Ee][Dd][Ii][Aa][Tt][Ee]
:lexeme ~ <IMPLEMENTATION> priority => 1
<IMPLEMENTATION> ~ [Ii][Mm][Pp][Ll][Ee][Mm][Ee][Nn][Tt][Aa][Tt][Ii][Oo][Nn]
:lexeme ~ <IN> priority => 1
<IN> ~ [Ii][Nn]
:lexeme ~ <INCLUDING> priority => 1
<INCLUDING> ~ [Ii][Nn][Cc][Ll][Uu][Dd][Ii][Nn][Gg]
:lexeme ~ <INCREMENT> priority => 1
<INCREMENT> ~ [Ii][Nn][Cc][Rr][Ee][Mm][Ee][Nn][Tt]
:lexeme ~ <INDICATOR> priority => 1
<INDICATOR> ~ [Ii][Nn][Dd][Ii][Cc][Aa][Tt][Oo][Rr]
:lexeme ~ <INITIALLY> priority => 1
<INITIALLY> ~ [Ii][Nn][Ii][Tt][Ii][Aa][Ll][Ll][Yy]
:lexeme ~ <INNER> priority => 1
<INNER> ~ [Ii][Nn][Nn][Ee][Rr]
:lexeme ~ <INOUT> priority => 1
<INOUT> ~ [Ii][Nn][Oo][Uu][Tt]
:lexeme ~ <INPUT> priority => 1
<INPUT> ~ [Ii][Nn][Pp][Uu][Tt]
:lexeme ~ <INSENSITIVE> priority => 1
<INSENSITIVE> ~ [Ii][Nn][Ss][Ee][Nn][Ss][Ii][Tt][Ii][Vv][Ee]
:lexeme ~ <INSERT> priority => 1
<INSERT> ~ [Ii][Nn][Ss][Ee][Rr][Tt]
:lexeme ~ <INSTANCE> priority => 1
<INSTANCE> ~ [Ii][Nn][Ss][Tt][Aa][Nn][Cc][Ee]
:lexeme ~ <INSTANTIABLE> priority => 1
<INSTANTIABLE> ~ [Ii][Nn][Ss][Tt][Aa][Nn][Tt][Ii][Aa][Bb][Ll][Ee]
:lexeme ~ <INT> priority => 1
<INT> ~ [Ii][Nn][Tt]
:lexeme ~ <INTEGER> priority => 1
<INTEGER> ~ [Ii][Nn][Tt][Ee][Gg][Ee][Rr]
:lexeme ~ <INTERSECT> priority => 1
<INTERSECT> ~ [Ii][Nn][Tt][Ee][Rr][Ss][Ee][Cc][Tt]
:lexeme ~ <INTERSECTION> priority => 1
<INTERSECTION> ~ [Ii][Nn][Tt][Ee][Rr][Ss][Ee][Cc][Tt][Ii][Oo][Nn]
<__INTERVAL> ~ [Ii][Nn][Tt][Ee][Rr][Vv][Aa][Ll]
:lexeme ~ <INTERVAL> priority => 1
<INTERVAL> ~ <__INTERVAL>
:lexeme ~ <INTO> priority => 1
<INTO> ~ [Ii][Nn][Tt][Oo]
:lexeme ~ <INVOKER> priority => 1
<INVOKER> ~ [Ii][Nn][Vv][Oo][Kk][Ee][Rr]
:lexeme ~ <IS> priority => 1
<IS> ~ [Ii][Ss]
:lexeme ~ <ISOLATION> priority => 1
<ISOLATION> ~ [Ii][Ss][Oo][Ll][Aa][Tt][Ii][Oo][Nn]
:lexeme ~ <JOIN> priority => 1
<JOIN> ~ [Jj][Oo][Ii][Nn]
:lexeme ~ <KEY> priority => 1
<KEY> ~ [Kk][Ee][Yy]
:lexeme ~ <KEY_MEMBER> priority => 1
<KEY_MEMBER> ~ [Kk][Ee][Yy]'_'[Mm][Ee][Mm][Bb][Ee][Rr]
:lexeme ~ <KEY_TYPE> priority => 1
<KEY_TYPE> ~ [Kk][Ee][Yy]'_'[Tt][Yy][Pp][Ee]
:lexeme ~ <LANGUAGE> priority => 1
<LANGUAGE> ~ [Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee]
:lexeme ~ <LARGE> priority => 1
<LARGE> ~ [Ll][Aa][Rr][Gg][Ee]
:lexeme ~ <LAST> priority => 1
<LAST> ~ [Ll][Aa][Ss][Tt]
:lexeme ~ <LATERAL> priority => 1
<LATERAL> ~ [Ll][Aa][Tt][Ee][Rr][Aa][Ll]
:lexeme ~ <LEADING> priority => 1
<LEADING> ~ [Ll][Ee][Aa][Dd][Ii][Nn][Gg]
:lexeme ~ <LEFT> priority => 1
<LEFT> ~ [Ll][Ee][Ff][Tt]
:lexeme ~ <LENGTH> priority => 1
<LENGTH> ~ [Ll][Ee][Nn][Gg][Tt][Hh]
:lexeme ~ <LEVEL> priority => 1
<LEVEL> ~ [Ll][Ee][Vv][Ee][Ll]
:lexeme ~ <LIKE> priority => 1
<LIKE> ~ [Ll][Ii][Kk][Ee]
:lexeme ~ <LN> priority => 1
<LN> ~ [Ll][Nn]
<__LOCAL> ~ [Ll][Oo][Cc][Aa][Ll]
:lexeme ~ <LOCAL> priority => 1
<LOCAL> ~ <__LOCAL>
:lexeme ~ <LOCALTIME> priority => 1
<LOCALTIME> ~ [Ll][Oo][Cc][Aa][Ll][Tt][Ii][Mm][Ee]
:lexeme ~ <LOCALTIMESTAMP> priority => 1
<LOCALTIMESTAMP> ~ [Ll][Oo][Cc][Aa][Ll][Tt][Ii][Mm][Ee][Ss][Tt][Aa][Mm][Pp]
:lexeme ~ <LOCATOR> priority => 1
<LOCATOR> ~ [Ll][Oo][Cc][Aa][Tt][Oo][Rr]
:lexeme ~ <LOWER> priority => 1
<LOWER> ~ [Ll][Oo][Ww][Ee][Rr]
:lexeme ~ <MAP> priority => 1
<MAP> ~ [Mm][Aa][Pp]
:lexeme ~ <MATCH> priority => 1
<MATCH> ~ [Mm][Aa][Tt][Cc][Hh]
:lexeme ~ <MATCHED> priority => 1
<MATCHED> ~ [Mm][Aa][Tt][Cc][Hh][Ee][Dd]
:lexeme ~ <MAX> priority => 1
<MAX> ~ [Mm][Aa][Xx]
:lexeme ~ <MAXVALUE> priority => 1
<MAXVALUE> ~ [Mm][Aa][Xx][Vv][Aa][Ll][Uu][Ee]
:lexeme ~ <MEMBER> priority => 1
<MEMBER> ~ [Mm][Ee][Mm][Bb][Ee][Rr]
:lexeme ~ <MERGE> priority => 1
<MERGE> ~ [Mm][Ee][Rr][Gg][Ee]
:lexeme ~ <MESSAGE_LENGTH> priority => 1
<MESSAGE_LENGTH> ~ [Mm][Ee][Ss][Ss][Aa][Gg][Ee]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
:lexeme ~ <MESSAGE_OCTET_LENGTH> priority => 1
<MESSAGE_OCTET_LENGTH> ~ [Mm][Ee][Ss][Ss][Aa][Gg][Ee]'_'[Oo][Cc][Tt][Ee][Tt]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
:lexeme ~ <MESSAGE_TEXT> priority => 1
<MESSAGE_TEXT> ~ [Mm][Ee][Ss][Ss][Aa][Gg][Ee]'_'[Tt][Ee][Xx][Tt]
:lexeme ~ <METHOD> priority => 1
<METHOD> ~ [Mm][Ee][Tt][Hh][Oo][Dd]
:lexeme ~ <MIN> priority => 1
<MIN> ~ [Mm][Ii][Nn]
:lexeme ~ <MINUTE> priority => 1
<MINUTE> ~ [Mm][Ii][Nn][Uu][Tt][Ee]
:lexeme ~ <MINVALUE> priority => 1
<MINVALUE> ~ [Mm][Ii][Nn][Vv][Aa][Ll][Uu][Ee]
:lexeme ~ <MOD> priority => 1
<MOD> ~ [Mm][Oo][Dd]
:lexeme ~ <MODIFIES> priority => 1
<MODIFIES> ~ [Mm][Oo][Dd][Ii][Ff][Ii][Ee][Ss]
<__MODULE> ~ [Mm][Oo][Dd][Uu][Ll][Ee]
:lexeme ~ <MODULE> priority => 1
<MODULE> ~ <__MODULE>
:lexeme ~ <MONTH> priority => 1
<MONTH> ~ [Mm][Oo][Nn][Tt][Hh]
:lexeme ~ <MORE> priority => 1
<MORE> ~ [Mm][Oo][Rr][Ee]
:lexeme ~ <MULTISET> priority => 1
<MULTISET> ~ [Mm][Uu][Ll][Tt][Ii][Ss][Ee][Tt]
<__N> ~ [Nn]
:lexeme ~ <NAME> priority => 1
<NAME> ~ [Nn][Aa][Mm][Ee]
:lexeme ~ <NAMES> priority => 1
<NAMES> ~ [Nn][Aa][Mm][Ee][Ss]
:lexeme ~ <NATIONAL> priority => 1
<NATIONAL> ~ [Nn][Aa][Tt][Ii][Oo][Nn][Aa][Ll]
:lexeme ~ <NATURAL> priority => 1
<NATURAL> ~ [Nn][Aa][Tt][Uu][Rr][Aa][Ll]
:lexeme ~ <NCHAR> priority => 1
<NCHAR> ~ [Nn][Cc][Hh][Aa][Rr]
:lexeme ~ <NCLOB> priority => 1
<NCLOB> ~ [Nn][Cc][Ll][Oo][Bb]
:lexeme ~ <NESTING> priority => 1
<NESTING> ~ [Nn][Ee][Ss][Tt][Ii][Nn][Gg]
:lexeme ~ <NEW> priority => 1
<NEW> ~ [Nn][Ee][Ww]
:lexeme ~ <NEXT> priority => 1
<NEXT> ~ [Nn][Ee][Xx][Tt]
:lexeme ~ <NO> priority => 1
<NO> ~ [Nn][Oo]
:lexeme ~ <NONE> priority => 1
<NONE> ~ [Nn][Oo][Nn][Ee]
:lexeme ~ <NORMALIZE> priority => 1
<NORMALIZE> ~ [Nn][Oo][Rr][Mm][Aa][Ll][Ii][Zz][Ee]
:lexeme ~ <NORMALIZED> priority => 1
<NORMALIZED> ~ [Nn][Oo][Rr][Mm][Aa][Ll][Ii][Zz][Ee][Dd]
:lexeme ~ <NOT> priority => 1
<NOT> ~ [Nn][Oo][Tt]
:lexeme ~ <NULL> priority => 1
<NULL> ~ [Nn][Uu][Ll][Ll]
:lexeme ~ <NULLABLE> priority => 1
<NULLABLE> ~ [Nn][Uu][Ll][Ll][Aa][Bb][Ll][Ee]
:lexeme ~ <NULLIF> priority => 1
<NULLIF> ~ [Nn][Uu][Ll][Ll][Ii][Ff]
:lexeme ~ <NULLS> priority => 1
<NULLS> ~ [Nn][Uu][Ll][Ll][Ss]
:lexeme ~ <NUMBER> priority => 1
<NUMBER> ~ [Nn][Uu][Mm][Bb][Ee][Rr]
:lexeme ~ <NUMERIC> priority => 1
<NUMERIC> ~ [Nn][Uu][Mm][Ee][Rr][Ii][Cc]
:lexeme ~ <OBJECT> priority => 1
<OBJECT> ~ [Oo][Bb][Jj][Ee][Cc][Tt]
:lexeme ~ <OCTETS> priority => 1
<OCTETS> ~ [Oo][Cc][Tt][Ee][Tt][Ss]
:lexeme ~ <OCTET_LENGTH> priority => 1
<OCTET_LENGTH> ~ [Oo][Cc][Tt][Ee][Tt]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
:lexeme ~ <OF> priority => 1
<OF> ~ [Oo][Ff]
:lexeme ~ <OLD> priority => 1
<OLD> ~ [Oo][Ll][Dd]
:lexeme ~ <ON> priority => 1
<ON> ~ [Oo][Nn]
:lexeme ~ <ONLY> priority => 1
<ONLY> ~ [Oo][Nn][Ll][Yy]
:lexeme ~ <OPEN> priority => 1
<OPEN> ~ [Oo][Pp][Ee][Nn]
:lexeme ~ <OPTION> priority => 1
<OPTION> ~ [Oo][Pp][Tt][Ii][Oo][Nn]
:lexeme ~ <OPTIONS> priority => 1
<OPTIONS> ~ [Oo][Pp][Tt][Ii][Oo][Nn][Ss]
:lexeme ~ <OR> priority => 1
<OR> ~ [Oo][Rr]
:lexeme ~ <ORDER> priority => 1
<ORDER> ~ [Oo][Rr][Dd][Ee][Rr]
:lexeme ~ <ORDERING> priority => 1
<ORDERING> ~ [Oo][Rr][Dd][Ee][Rr][Ii][Nn][Gg]
:lexeme ~ <ORDINALITY> priority => 1
<ORDINALITY> ~ [Oo][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy]
:lexeme ~ <OTHERS> priority => 1
<OTHERS> ~ [Oo][Tt][Hh][Ee][Rr][Ss]
:lexeme ~ <OUT> priority => 1
<OUT> ~ [Oo][Uu][Tt]
:lexeme ~ <OUTER> priority => 1
<OUTER> ~ [Oo][Uu][Tt][Ee][Rr]
:lexeme ~ <OUTPUT> priority => 1
<OUTPUT> ~ [Oo][Uu][Tt][Pp][Uu][Tt]
:lexeme ~ <OVER> priority => 1
<OVER> ~ [Oo][Vv][Ee][Rr]
:lexeme ~ <OVERLAPS> priority => 1
<OVERLAPS> ~ [Oo][Vv][Ee][Rr][Ll][Aa][Pp][Ss]
:lexeme ~ <OVERLAY> priority => 1
<OVERLAY> ~ [Oo][Vv][Ee][Rr][Ll][Aa][Yy]
:lexeme ~ <OVERRIDING> priority => 1
<OVERRIDING> ~ [Oo][Vv][Ee][Rr][Rr][Ii][Dd][Ii][Nn][Gg]
:lexeme ~ <PAD> priority => 1
<PAD> ~ [Pp][Aa][Dd]
:lexeme ~ <PARAMETER> priority => 1
<PARAMETER> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]
:lexeme ~ <PARAMETER_MODE> priority => 1
<PARAMETER_MODE> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Mm][Oo][Dd][Ee]
:lexeme ~ <PARAMETER_NAME> priority => 1
<PARAMETER_NAME> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <PARAMETER_ORDINAL_POSITION> priority => 1
<PARAMETER_ORDINAL_POSITION> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Oo][Rr][Dd][Ii][Nn][Aa][Ll]'_'[Pp][Oo][Ss][Ii][Tt][Ii][Oo][Nn]
:lexeme ~ <PARAMETER_SPECIFIC_CATALOG> priority => 1
<PARAMETER_SPECIFIC_CATALOG> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
:lexeme ~ <PARAMETER_SPECIFIC_NAME> priority => 1
<PARAMETER_SPECIFIC_NAME> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <PARAMETER_SPECIFIC_SCHEMA> priority => 1
<PARAMETER_SPECIFIC_SCHEMA> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
:lexeme ~ <PARTIAL> priority => 1
<PARTIAL> ~ [Pp][Aa][Rr][Tt][Ii][Aa][Ll]
:lexeme ~ <PARTITION> priority => 1
<PARTITION> ~ [Pp][Aa][Rr][Tt][Ii][Tt][Ii][Oo][Nn]
:lexeme ~ <PATH> priority => 1
<PATH> ~ [Pp][Aa][Tt][Hh]
:lexeme ~ <PERCENTILE_CONT> priority => 1
<PERCENTILE_CONT> ~ [Pp][Ee][Rr][Cc][Ee][Nn][Tt][Ii][Ll][Ee]'_'[Cc][Oo][Nn][Tt]
:lexeme ~ <PERCENTILE_DISC> priority => 1
<PERCENTILE_DISC> ~ [Pp][Ee][Rr][Cc][Ee][Nn][Tt][Ii][Ll][Ee]'_'[Dd][Ii][Ss][Cc]
:lexeme ~ <PERCENT_RANK> priority => 1
<PERCENT_RANK> ~ [Pp][Ee][Rr][Cc][Ee][Nn][Tt]'_'[Rr][Aa][Nn][Kk]
:lexeme ~ <PLACING> priority => 1
<PLACING> ~ [Pp][Ll][Aa][Cc][Ii][Nn][Gg]
:lexeme ~ <POSITION> priority => 1
<POSITION> ~ [Pp][Oo][Ss][Ii][Tt][Ii][Oo][Nn]
:lexeme ~ <POWER> priority => 1
<POWER> ~ [Pp][Oo][Ww][Ee][Rr]
:lexeme ~ <PRECEDING> priority => 1
<PRECEDING> ~ [Pp][Rr][Ee][Cc][Ee][Dd][Ii][Nn][Gg]
:lexeme ~ <PRECISION> priority => 1
<PRECISION> ~ [Pp][Rr][Ee][Cc][Ii][Ss][Ii][Oo][Nn]
:lexeme ~ <PREPARE> priority => 1
<PREPARE> ~ [Pp][Rr][Ee][Pp][Aa][Rr][Ee]
:lexeme ~ <PRESERVE> priority => 1
<PRESERVE> ~ [Pp][Rr][Ee][Ss][Ee][Rr][Vv][Ee]
:lexeme ~ <PRIMARY> priority => 1
<PRIMARY> ~ [Pp][Rr][Ii][Mm][Aa][Rr][Yy]
:lexeme ~ <PRIOR> priority => 1
<PRIOR> ~ [Pp][Rr][Ii][Oo][Rr]
:lexeme ~ <PRIVILEGES> priority => 1
<PRIVILEGES> ~ [Pp][Rr][Ii][Vv][Ii][Ll][Ee][Gg][Ee][Ss]
:lexeme ~ <PROCEDURE> priority => 1
<PROCEDURE> ~ [Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]
:lexeme ~ <PUBLIC> priority => 1
<PUBLIC> ~ [Pp][Uu][Bb][Ll][Ii][Cc]
:lexeme ~ <RANGE> priority => 1
<RANGE> ~ [Rr][Aa][Nn][Gg][Ee]
:lexeme ~ <RANK> priority => 1
<RANK> ~ [Rr][Aa][Nn][Kk]
:lexeme ~ <READ> priority => 1
<READ> ~ [Rr][Ee][Aa][Dd]
:lexeme ~ <READS> priority => 1
<READS> ~ [Rr][Ee][Aa][Dd][Ss]
:lexeme ~ <REAL> priority => 1
<REAL> ~ [Rr][Ee][Aa][Ll]
:lexeme ~ <RECURSIVE> priority => 1
<RECURSIVE> ~ [Rr][Ee][Cc][Uu][Rr][Ss][Ii][Vv][Ee]
:lexeme ~ <REF> priority => 1
<REF> ~ [Rr][Ee][Ff]
:lexeme ~ <REFERENCES> priority => 1
<REFERENCES> ~ [Rr][Ee][Ff][Ee][Rr][Ee][Nn][Cc][Ee][Ss]
:lexeme ~ <REFERENCING> priority => 1
<REFERENCING> ~ [Rr][Ee][Ff][Ee][Rr][Ee][Nn][Cc][Ii][Nn][Gg]
:lexeme ~ <REGR_AVGX> priority => 1
<REGR_AVGX> ~ [Rr][Ee][Gg][Rr]'_'[Aa][Vv][Gg][Xx]
:lexeme ~ <REGR_AVGY> priority => 1
<REGR_AVGY> ~ [Rr][Ee][Gg][Rr]'_'[Aa][Vv][Gg][Yy]
:lexeme ~ <REGR_COUNT> priority => 1
<REGR_COUNT> ~ [Rr][Ee][Gg][Rr]'_'[Cc][Oo][Uu][Nn][Tt]
:lexeme ~ <REGR_INTERCEPT> priority => 1
<REGR_INTERCEPT> ~ [Rr][Ee][Gg][Rr]'_'[Ii][Nn][Tt][Ee][Rr][Cc][Ee][Pp][Tt]
:lexeme ~ <REGR_R2> priority => 1
<REGR_R2> ~ [Rr][Ee][Gg][Rr]'_'[Rr]'2'
:lexeme ~ <REGR_SLOPE> priority => 1
<REGR_SLOPE> ~ [Rr][Ee][Gg][Rr]'_'[Ss][Ll][Oo][Pp][Ee]
:lexeme ~ <REGR_SXX> priority => 1
<REGR_SXX> ~ [Rr][Ee][Gg][Rr]'_'[Ss][Xx][Xx]
:lexeme ~ <REGR_SXY> priority => 1
<REGR_SXY> ~ [Rr][Ee][Gg][Rr]'_'[Ss][Xx][Yy]
:lexeme ~ <REGR_SYY> priority => 1
<REGR_SYY> ~ [Rr][Ee][Gg][Rr]'_'[Ss][Yy][Yy]
:lexeme ~ <RELATIVE> priority => 1
<RELATIVE> ~ [Rr][Ee][Ll][Aa][Tt][Ii][Vv][Ee]
:lexeme ~ <RELEASE> priority => 1
<RELEASE> ~ [Rr][Ee][Ll][Ee][Aa][Ss][Ee]
:lexeme ~ <REPEATABLE> priority => 1
<REPEATABLE> ~ [Rr][Ee][Pp][Ee][Aa][Tt][Aa][Bb][Ll][Ee]
:lexeme ~ <RESTART> priority => 1
<RESTART> ~ [Rr][Ee][Ss][Tt][Aa][Rr][Tt]
:lexeme ~ <RESTRICT> priority => 1
<RESTRICT> ~ [Rr][Ee][Ss][Tt][Rr][Ii][Cc][Tt]
:lexeme ~ <RESULT> priority => 1
<RESULT> ~ [Rr][Ee][Ss][Uu][Ll][Tt]
:lexeme ~ <RETURN> priority => 1
<RETURN> ~ [Rr][Ee][Tt][Uu][Rr][Nn]
:lexeme ~ <RETURNED_CARDINALITY> priority => 1
<RETURNED_CARDINALITY> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ee][Dd]'_'[Cc][Aa][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy]
:lexeme ~ <RETURNED_LENGTH> priority => 1
<RETURNED_LENGTH> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ee][Dd]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
:lexeme ~ <RETURNED_OCTET_LENGTH> priority => 1
<RETURNED_OCTET_LENGTH> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ee][Dd]'_'[Oo][Cc][Tt][Ee][Tt]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
:lexeme ~ <RETURNED_SQLSTATE> priority => 1
<RETURNED_SQLSTATE> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ee][Dd]'_'[Ss][Qq][Ll][Ss][Tt][Aa][Tt][Ee]
:lexeme ~ <RETURNS> priority => 1
<RETURNS> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ss]
:lexeme ~ <REVOKE> priority => 1
<REVOKE> ~ [Rr][Ee][Vv][Oo][Kk][Ee]
:lexeme ~ <RIGHT> priority => 1
<RIGHT> ~ [Rr][Ii][Gg][Hh][Tt]
:lexeme ~ <ROLE> priority => 1
<ROLE> ~ [Rr][Oo][Ll][Ee]
:lexeme ~ <ROLLBACK> priority => 1
<ROLLBACK> ~ [Rr][Oo][Ll][Ll][Bb][Aa][Cc][Kk]
:lexeme ~ <ROLLUP> priority => 1
<ROLLUP> ~ [Rr][Oo][Ll][Ll][Uu][Pp]
:lexeme ~ <ROUTINE> priority => 1
<ROUTINE> ~ [Rr][Oo][Uu][Tt][Ii][Nn][Ee]
:lexeme ~ <ROUTINE_CATALOG> priority => 1
<ROUTINE_CATALOG> ~ [Rr][Oo][Uu][Tt][Ii][Nn][Ee]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
:lexeme ~ <ROUTINE_NAME> priority => 1
<ROUTINE_NAME> ~ [Rr][Oo][Uu][Tt][Ii][Nn][Ee]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <ROUTINE_SCHEMA> priority => 1
<ROUTINE_SCHEMA> ~ [Rr][Oo][Uu][Tt][Ii][Nn][Ee]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
:lexeme ~ <ROW> priority => 1
<ROW> ~ [Rr][Oo][Ww]
:lexeme ~ <ROWS> priority => 1
<ROWS> ~ [Rr][Oo][Ww][Ss]
:lexeme ~ <ROW_COUNT> priority => 1
<ROW_COUNT> ~ [Rr][Oo][Ww]'_'[Cc][Oo][Uu][Nn][Tt]
:lexeme ~ <ROW_NUMBER> priority => 1
<ROW_NUMBER> ~ [Rr][Oo][Ww]'_'[Nn][Uu][Mm][Bb][Ee][Rr]
:lexeme ~ <SAVEPOINT> priority => 1
<SAVEPOINT> ~ [Ss][Aa][Vv][Ee][Pp][Oo][Ii][Nn][Tt]
:lexeme ~ <SCALE> priority => 1
<SCALE> ~ [Ss][Cc][Aa][Ll][Ee]
:lexeme ~ <SCHEMA> priority => 1
<SCHEMA> ~ [Ss][Cc][Hh][Ee][Mm][Aa]
:lexeme ~ <SCHEMA_NAME> priority => 1
<SCHEMA_NAME> ~ [Ss][Cc][Hh][Ee][Mm][Aa]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <SCOPE> priority => 1
<SCOPE> ~ [Ss][Cc][Oo][Pp][Ee]
:lexeme ~ <SCOPE_CATALOG> priority => 1
<SCOPE_CATALOG> ~ [Ss][Cc][Oo][Pp][Ee]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
:lexeme ~ <SCOPE_NAME> priority => 1
<SCOPE_NAME> ~ [Ss][Cc][Oo][Pp][Ee]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <SCOPE_SCHEMA> priority => 1
<SCOPE_SCHEMA> ~ [Ss][Cc][Oo][Pp][Ee]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
:lexeme ~ <SCROLL> priority => 1
<SCROLL> ~ [Ss][Cc][Rr][Oo][Ll][Ll]
:lexeme ~ <SEARCH> priority => 1
<SEARCH> ~ [Ss][Ee][Aa][Rr][Cc][Hh]
:lexeme ~ <SECOND> priority => 1
<SECOND> ~ [Ss][Ee][Cc][Oo][Nn][Dd]
:lexeme ~ <SECTION> priority => 1
<SECTION> ~ [Ss][Ee][Cc][Tt][Ii][Oo][Nn]
:lexeme ~ <SECURITY> priority => 1
<SECURITY> ~ [Ss][Ee][Cc][Uu][Rr][Ii][Tt][Yy]
:lexeme ~ <SELECT> priority => 1
<SELECT> ~ [Ss][Ee][Ll][Ee][Cc][Tt]
:lexeme ~ <SELF> priority => 1
<SELF> ~ [Ss][Ee][Ll][Ff]
:lexeme ~ <SENSITIVE> priority => 1
<SENSITIVE> ~ [Ss][Ee][Nn][Ss][Ii][Tt][Ii][Vv][Ee]
:lexeme ~ <SEQUENCE> priority => 1
<SEQUENCE> ~ [Ss][Ee][Qq][Uu][Ee][Nn][Cc][Ee]
:lexeme ~ <SERIALIZABLE> priority => 1
<SERIALIZABLE> ~ [Ss][Ee][Rr][Ii][Aa][Ll][Ii][Zz][Aa][Bb][Ll][Ee]
:lexeme ~ <SERVER_NAME> priority => 1
<SERVER_NAME> ~ [Ss][Ee][Rr][Vv][Ee][Rr]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <SESSION> priority => 1
<SESSION> ~ [Ss][Ee][Ss][Ss][Ii][Oo][Nn]
:lexeme ~ <SESSION_USER> priority => 1
<SESSION_USER> ~ [Ss][Ee][Ss][Ss][Ii][Oo][Nn]'_'[Uu][Ss][Ee][Rr]
:lexeme ~ <SET> priority => 1
<SET> ~ [Ss][Ee][Tt]
:lexeme ~ <SETS> priority => 1
<SETS> ~ [Ss][Ee][Tt][Ss]
:lexeme ~ <SIMILAR> priority => 1
<SIMILAR> ~ [Ss][Ii][Mm][Ii][Ll][Aa][Rr]
:lexeme ~ <SIMPLE> priority => 1
<SIMPLE> ~ [Ss][Ii][Mm][Pp][Ll][Ee]
:lexeme ~ <SIZE> priority => 1
<SIZE> ~ [Ss][Ii][Zz][Ee]
:lexeme ~ <SMALLINT> priority => 1
<SMALLINT> ~ [Ss][Mm][Aa][Ll][Ll][Ii][Nn][Tt]
:lexeme ~ <SOME> priority => 1
<SOME> ~ [Ss][Oo][Mm][Ee]
:lexeme ~ <SOURCE> priority => 1
<SOURCE> ~ [Ss][Oo][Uu][Rr][Cc][Ee]
:lexeme ~ <SPACE> priority => 1
<SPACE> ~ [Ss][Pp][Aa][Cc][Ee]
:lexeme ~ <SPECIFIC> priority => 1
<SPECIFIC> ~ [Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]
:lexeme ~ <SPECIFICTYPE> priority => 1
<SPECIFICTYPE> ~ [Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc][Tt][Yy][Pp][Ee]
:lexeme ~ <SPECIFIC_NAME> priority => 1
<SPECIFIC_NAME> ~ [Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <SQL> priority => 1
<SQL> ~ [Ss][Qq][Ll]
:lexeme ~ <SQLEXCEPTION> priority => 1
<SQLEXCEPTION> ~ [Ss][Qq][Ll][Ee][Xx][Cc][Ee][Pp][Tt][Ii][Oo][Nn]
:lexeme ~ <SQLSTATE> priority => 1
<SQLSTATE> ~ [Ss][Qq][Ll][Ss][Tt][Aa][Tt][Ee]
:lexeme ~ <SQLWARNING> priority => 1
<SQLWARNING> ~ [Ss][Qq][Ll][Ww][Aa][Rr][Nn][Ii][Nn][Gg]
:lexeme ~ <SQRT> priority => 1
<SQRT> ~ [Ss][Qq][Rr][Tt]
:lexeme ~ <START> priority => 1
<START> ~ [Ss][Tt][Aa][Rr][Tt]
:lexeme ~ <STATE> priority => 1
<STATE> ~ [Ss][Tt][Aa][Tt][Ee]
:lexeme ~ <STATEMENT> priority => 1
<STATEMENT> ~ [Ss][Tt][Aa][Tt][Ee][Mm][Ee][Nn][Tt]
:lexeme ~ <STATIC> priority => 1
<STATIC> ~ [Ss][Tt][Aa][Tt][Ii][Cc]
:lexeme ~ <STDDEV_POP> priority => 1
<STDDEV_POP> ~ [Ss][Tt][Dd][Dd][Ee][Vv]'_'[Pp][Oo][Pp]
:lexeme ~ <STDDEV_SAMP> priority => 1
<STDDEV_SAMP> ~ [Ss][Tt][Dd][Dd][Ee][Vv]'_'[Ss][Aa][Mm][Pp]
:lexeme ~ <STRUCTURE> priority => 1
<STRUCTURE> ~ [Ss][Tt][Rr][Uu][Cc][Tt][Uu][Rr][Ee]
:lexeme ~ <STYLE> priority => 1
<STYLE> ~ [Ss][Tt][Yy][Ll][Ee]
:lexeme ~ <SUBCLASS_ORIGIN> priority => 1
<SUBCLASS_ORIGIN> ~ [Ss][Uu][Bb][Cc][Ll][Aa][Ss][Ss]'_'[Oo][Rr][Ii][Gg][Ii][Nn]
:lexeme ~ <SUBMULTISET> priority => 1
<SUBMULTISET> ~ [Ss][Uu][Bb][Mm][Uu][Ll][Tt][Ii][Ss][Ee][Tt]
:lexeme ~ <SUBSTRING> priority => 1
<SUBSTRING> ~ [Ss][Uu][Bb][Ss][Tt][Rr][Ii][Nn][Gg]
:lexeme ~ <SUM> priority => 1
<SUM> ~ [Ss][Uu][Mm]
:lexeme ~ <SYMMETRIC> priority => 1
<SYMMETRIC> ~ [Ss][Yy][Mm][Mm][Ee][Tt][Rr][Ii][Cc]
:lexeme ~ <SYSTEM> priority => 1
<SYSTEM> ~ [Ss][Yy][Ss][Tt][Ee][Mm]
:lexeme ~ <SYSTEM_USER> priority => 1
<SYSTEM_USER> ~ [Ss][Yy][Ss][Tt][Ee][Mm]'_'[Uu][Ss][Ee][Rr]
:lexeme ~ <TABLE> priority => 1
<TABLE> ~ [Tt][Aa][Bb][Ll][Ee]
:lexeme ~ <TABLESAMPLE> priority => 1
<TABLESAMPLE> ~ [Tt][Aa][Bb][Ll][Ee][Ss][Aa][Mm][Pp][Ll][Ee]
:lexeme ~ <TABLE_NAME> priority => 1
<TABLE_NAME> ~ [Tt][Aa][Bb][Ll][Ee]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <TEMPORARY> priority => 1
<TEMPORARY> ~ [Tt][Ee][Mm][Pp][Oo][Rr][Aa][Rr][Yy]
:lexeme ~ <THEN> priority => 1
<THEN> ~ [Tt][Hh][Ee][Nn]
:lexeme ~ <TIES> priority => 1
<TIES> ~ [Tt][Ii][Ee][Ss]
<__TIME> ~ [Tt][Ii][Mm][Ee]
:lexeme ~ <TIME> priority => 1
<TIME> ~ <__TIME>
<__TIMESTAMP> ~ [Tt][Ii][Mm][Ee][Ss][Tt][Aa][Mm][Pp]
:lexeme ~ <TIMESTAMP> priority => 1
<TIMESTAMP> ~ <__TIMESTAMP>
:lexeme ~ <TIMEZONE_HOUR> priority => 1
<TIMEZONE_HOUR> ~ [Tt][Ii][Mm][Ee][Zz][Oo][Nn][Ee]'_'[Hh][Oo][Uu][Rr]
:lexeme ~ <TIMEZONE_MINUTE> priority => 1
<TIMEZONE_MINUTE> ~ [Tt][Ii][Mm][Ee][Zz][Oo][Nn][Ee]'_'[Mm][Ii][Nn][Uu][Tt][Ee]
:lexeme ~ <TO> priority => 1
<TO> ~ [Tt][Oo]
:lexeme ~ <TOP_LEVEL_COUNT> priority => 1
<TOP_LEVEL_COUNT> ~ [Tt][Oo][Pp]'_'[Ll][Ee][Vv][Ee][Ll]'_'[Cc][Oo][Uu][Nn][Tt]
:lexeme ~ <TRAILING> priority => 1
<TRAILING> ~ [Tt][Rr][Aa][Ii][Ll][Ii][Nn][Gg]
:lexeme ~ <TRANSACTION> priority => 1
<TRANSACTION> ~ [Tt][Rr][Aa][Nn][Ss][Aa][Cc][Tt][Ii][Oo][Nn]
:lexeme ~ <TRANSACTIONS_COMMITTED> priority => 1
<TRANSACTIONS_COMMITTED> ~ [Tt][Rr][Aa][Nn][Ss][Aa][Cc][Tt][Ii][Oo][Nn][Ss]'_'[Cc][Oo][Mm][Mm][Ii][Tt][Tt][Ee][Dd]
:lexeme ~ <TRANSACTIONS_ROLLED_BACK> priority => 1
<TRANSACTIONS_ROLLED_BACK> ~ [Tt][Rr][Aa][Nn][Ss][Aa][Cc][Tt][Ii][Oo][Nn][Ss]'_'[Rr][Oo][Ll][Ll][Ee][Dd]'_'[Bb][Aa][Cc][Kk]
:lexeme ~ <TRANSACTION_ACTIVE> priority => 1
<TRANSACTION_ACTIVE> ~ [Tt][Rr][Aa][Nn][Ss][Aa][Cc][Tt][Ii][Oo][Nn]'_'[Aa][Cc][Tt][Ii][Vv][Ee]
:lexeme ~ <TRANSFORM> priority => 1
<TRANSFORM> ~ [Tt][Rr][Aa][Nn][Ss][Ff][Oo][Rr][Mm]
:lexeme ~ <TRANSFORMS> priority => 1
<TRANSFORMS> ~ [Tt][Rr][Aa][Nn][Ss][Ff][Oo][Rr][Mm][Ss]
:lexeme ~ <TRANSLATE> priority => 1
<TRANSLATE> ~ [Tt][Rr][Aa][Nn][Ss][Ll][Aa][Tt][Ee]
:lexeme ~ <TRANSLATION> priority => 1
<TRANSLATION> ~ [Tt][Rr][Aa][Nn][Ss][Ll][Aa][Tt][Ii][Oo][Nn]
:lexeme ~ <TREAT> priority => 1
<TREAT> ~ [Tt][Rr][Ee][Aa][Tt]
:lexeme ~ <TRIGGER> priority => 1
<TRIGGER> ~ [Tt][Rr][Ii][Gg][Gg][Ee][Rr]
:lexeme ~ <TRIGGER_CATALOG> priority => 1
<TRIGGER_CATALOG> ~ [Tt][Rr][Ii][Gg][Gg][Ee][Rr]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
:lexeme ~ <TRIGGER_NAME> priority => 1
<TRIGGER_NAME> ~ [Tt][Rr][Ii][Gg][Gg][Ee][Rr]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <TRIGGER_SCHEMA> priority => 1
<TRIGGER_SCHEMA> ~ [Tt][Rr][Ii][Gg][Gg][Ee][Rr]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
:lexeme ~ <TRIM> priority => 1
<TRIM> ~ [Tt][Rr][Ii][Mm]
<__TRUE> ~ [Tt][Rr][Uu][Ee]
:lexeme ~ <TRUE> priority => 1
<TRUE> ~ <__TRUE>
:lexeme ~ <TYPE> priority => 1
<TYPE> ~ [Tt][Yy][Pp][Ee]
<__U> ~ [Uu]
<__UESCAPE> ~ [Uu][Ee][Ss][Cc][Aa][Pp][Ee]
:lexeme ~ <UNBOUNDED> priority => 1
<UNBOUNDED> ~ [Uu][Nn][Bb][Oo][Uu][Nn][Dd][Ee][Dd]
:lexeme ~ <UNCOMMITTED> priority => 1
<UNCOMMITTED> ~ [Uu][Nn][Cc][Oo][Mm][Mm][Ii][Tt][Tt][Ee][Dd]
:lexeme ~ <UNDER> priority => 1
<UNDER> ~ [Uu][Nn][Dd][Ee][Rr]
:lexeme ~ <UNION> priority => 1
<UNION> ~ [Uu][Nn][Ii][Oo][Nn]
:lexeme ~ <UNIQUE> priority => 1
<UNIQUE> ~ [Uu][Nn][Ii][Qq][Uu][Ee]
<__UNKNOWN> ~ [Uu][Nn][Kk][Nn][Oo][Ww][Nn]
:lexeme ~ <UNKNOWN> priority => 1
<UNKNOWN> ~ <__UNKNOWN>
:lexeme ~ <UNNAMED> priority => 1
<UNNAMED> ~ [Uu][Nn][Nn][Aa][Mm][Ee][Dd]
:lexeme ~ <UNNEST> priority => 1
<UNNEST> ~ [Uu][Nn][Nn][Ee][Ss][Tt]
:lexeme ~ <UPDATE> priority => 1
<UPDATE> ~ [Uu][Pp][Dd][Aa][Tt][Ee]
:lexeme ~ <UPPER> priority => 1
<UPPER> ~ [Uu][Pp][Pp][Ee][Rr]
:lexeme ~ <USAGE> priority => 1
<USAGE> ~ [Uu][Ss][Aa][Gg][Ee]
:lexeme ~ <USER> priority => 1
<USER> ~ [Uu][Ss][Ee][Rr]
:lexeme ~ <USER_DEFINED_TYPE_CATALOG> priority => 1
<USER_DEFINED_TYPE_CATALOG> ~ [Uu][Ss][Ee][Rr]'_'[Dd][Ee][Ff][Ii][Nn][Ee][Dd]'_'[Tt][Yy][Pp][Ee]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
:lexeme ~ <USER_DEFINED_TYPE_CODE> priority => 1
<USER_DEFINED_TYPE_CODE> ~ [Uu][Ss][Ee][Rr]'_'[Dd][Ee][Ff][Ii][Nn][Ee][Dd]'_'[Tt][Yy][Pp][Ee]'_'[Cc][Oo][Dd][Ee]
:lexeme ~ <USER_DEFINED_TYPE_NAME> priority => 1
<USER_DEFINED_TYPE_NAME> ~ [Uu][Ss][Ee][Rr]'_'[Dd][Ee][Ff][Ii][Nn][Ee][Dd]'_'[Tt][Yy][Pp][Ee]'_'[Nn][Aa][Mm][Ee]
:lexeme ~ <USER_DEFINED_TYPE_SCHEMA> priority => 1
<USER_DEFINED_TYPE_SCHEMA> ~ [Uu][Ss][Ee][Rr]'_'[Dd][Ee][Ff][Ii][Nn][Ee][Dd]'_'[Tt][Yy][Pp][Ee]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
:lexeme ~ <USING> priority => 1
<USING> ~ [Uu][Ss][Ii][Nn][Gg]
:lexeme ~ <VALUE> priority => 1
<VALUE> ~ [Vv][Aa][Ll][Uu][Ee]
:lexeme ~ <VALUES> priority => 1
<VALUES> ~ [Vv][Aa][Ll][Uu][Ee][Ss]
:lexeme ~ <VARCHAR> priority => 1
<VARCHAR> ~ [Vv][Aa][Rr][Cc][Hh][Aa][Rr]
:lexeme ~ <VARYING> priority => 1
<VARYING> ~ [Vv][Aa][Rr][Yy][Ii][Nn][Gg]
:lexeme ~ <VAR_POP> priority => 1
<VAR_POP> ~ [Vv][Aa][Rr]'_'[Pp][Oo][Pp]
:lexeme ~ <VAR_SAMP> priority => 1
<VAR_SAMP> ~ [Vv][Aa][Rr]'_'[Ss][Aa][Mm][Pp]
:lexeme ~ <VIEW> priority => 1
<VIEW> ~ [Vv][Ii][Ee][Ww]
:lexeme ~ <WHEN> priority => 1
<WHEN> ~ [Ww][Hh][Ee][Nn]
:lexeme ~ <WHENEVER> priority => 1
<WHENEVER> ~ [Ww][Hh][Ee][Nn][Ee][Vv][Ee][Rr]
:lexeme ~ <WHERE> priority => 1
<WHERE> ~ [Ww][Hh][Ee][Rr][Ee]
:lexeme ~ <WIDTH_BUCKET> priority => 1
<WIDTH_BUCKET> ~ [Ww][Ii][Dd][Tt][Hh]'_'[Bb][Uu][Cc][Kk][Ee][Tt]
:lexeme ~ <WINDOW> priority => 1
<WINDOW> ~ [Ww][Ii][Nn][Dd][Oo][Ww]
:lexeme ~ <WITH> priority => 1
<WITH> ~ [Ww][Ii][Tt][Hh]
:lexeme ~ <WITHIN> priority => 1
<WITHIN> ~ [Ww][Ii][Tt][Hh][Ii][Nn]
:lexeme ~ <WITHOUT> priority => 1
<WITHOUT> ~ [Ww][Ii][Tt][Hh][Oo][Uu][Tt]
:lexeme ~ <WORK> priority => 1
<WORK> ~ [Ww][Oo][Rr][Kk]
:lexeme ~ <WRITE> priority => 1
<WRITE> ~ [Ww][Rr][Ii][Tt][Ee]
<__X> ~ [Xx]
:lexeme ~ <YEAR> priority => 1
<YEAR> ~ [Yy][Ee][Aa][Rr]
:lexeme ~ <ZONE> priority => 1
<ZONE> ~ [Zz][Oo][Nn][Ee]
