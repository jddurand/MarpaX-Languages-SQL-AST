#env perl
use strict;
use diagnostics;
use Marpa::R2;

my $grammar_source = do {local $/; <DATA>};
my $input = <<INPUT;
-- With the knowledge of a "GROUP BY" clause as explained above,
-- people go overboard and do something like this:

SELECT
   Customers.*,
   MAX(Orders.OrderTime) AS LatestOrderTime
FROM
   dbo.Customers INNER JOIN dbo.Orders
       ON Customers.ID = Orders.CustomerID
GROUP BY
   Customers.ID, Customers.FirstName, Customers.LastName, Customers.Address,
       Customers.City, Customers.State, Customers.Zip
INPUT
my $grammar = Marpa::R2::Scanless::G->new( { source => \$grammar_source } );
my $re = Marpa::R2::Scanless::R->new( { grammar => $grammar, trace_terminals => 1 } );
eval {$re->read(\$input)} || die "Parse error: $@\n\nContext:\n" . $re->show_progress();

__DATA__
#
# References: http://savage.net.au/SQL/sql-2003-1.bnf, http://savage.net.au/SQL/sql-2003-2.bnf
#

:start ::= <SQL start>
:discard ~ <_separator>

<SQL start> ::= <SQL executable statement>
              | <direct SQL statement>
              | <preparable statement>
              | <embedded SQL declare section>
              | <embedded SQL host program>
              | <embedded SQL statement>
              | <SQL_client module definition>

#
# G0 Lexical Elements
# -------------------

<simple Latin letter> ::= <simple Latin upper case letter> | <simple Latin lower case letter>

<simple Latin upper case letter> ~ [A-Z]

<simple Latin lower case letter> ~ [a-z]

<_digit> ~ [0-9]
<digit> ~ <_digit>

<space> ~ [\N{U+0020}]

<_double quote> ~ '"'
<double quote> ~ <_double quote>

<percent> ~ '%'

<_ampersand> ~ '&'
<ampersand> ~ <_ampersand>

<_quote> ~ [']
<quote> ~ <_quote>

<left paren> ~ '('

<right paren> ~ ')'

<_asterisk> ~ '*'
<asterisk> ~ <_asterisk>

<plus sign> ~ '+'

<comma> ~ ','

<_minus sign> ~ '-'
<minus sign> ~ <_minus sign>

<period> ~ '.'

<_solidus> ~ '/'
<solidus> ~ <_solidus>

<colon> ~ ':'

<semicolon> ~ ';'

<less than operator> ~ '<'

<equals operator> ~ '='

<greater than operator> ~ '>'

<question mark> ~ '?'

<left bracket or trigraph> ~ <_left bracket> | <left bracket trigraph>

<right bracket or trigraph> ~ <_right bracket> | <right bracket trigraph>

<_left bracket> ~ '['
<left bracket> ~ <_left bracket>

<left bracket trigraph> ~ '??('

<_right bracket> ~ ']'
<right bracket> ~ <_right bracket>

<right bracket trigraph> ~ '??)'

<circumflex> ~ '^'

<underscore> ~ '_'

<vertical bar> ~ '|'

<left brace> ~ '{'

<right brace> ~ '}'

<regular identifier> ~ <identifier body>

<identifier body> ~ <identifier start>
                  | <identifier body> <identifier part>

<identifier part> ~ <identifier start> | <identifier extend>

<identifier start> ~ [\p{Lu}\p{Ll}\p{Lt}\p{Lm}\p{Lo}\p{Nl}]

<identifier extend> ~ [\N{U+00B7}\p{Mn}\p{Mc}\p{Nd}\p{Pc}\p{Cf}]

<digit many> ~ <_digit>+

<large object length token> ~ <digit many> <_multiplier>

<_multiplier> ~ [KMG]
<multiplier> ~ <_multiplier>

<delimited identifier> ::= <double quote> <delimited identifier body> <double quote>

<delimited identifier body> ::= <delimited identifier part>+

<delimited identifier part> ::= <nondoublequote character> | <doublequote symbol>

<U ampersand double quote> ~ <U><_ampersand><_double quote>
<U ampersand quote> ~ <U><_ampersand><_quote>

<Unicode delimited identifier> ::= <U ampersand double quote> <Unicode delimiter body> <double quote> <Unicode escape specifier>


<Unicode escape specifier> ::= '[' 'UESCAPE' <quote> <Unicode escape character> <quote> ']'

<Unicode delimiter body> ::= <Unicode identifier part>+

<Unicode identifier part> ::= <delimited identifier part> | <Unicode escape value>

<Unicode escape value> ::= <Unicode 4 digit escape value>
                         | <Unicode 6 digit escape value>
                         | <Unicode character escape value>

<Unicode 4 digit escape value> ::= <Unicode escape character><hexit><hexit><hexit><hexit>

<Unicode 6 digit escape value> ::= <Unicode escape character><plus sign><hexit><hexit><hexit><hexit><hexit><hexit>

<Unicode character escape value> ::= <Unicode escape character><Unicode escape character>

<Unicode escape character> ~ [^A-Fa-f0-9\-\+\p{Zs}\p{Zl}\p{Zp}\N{U+0009}\N{U+000A}\N{U+000B}\N{U+000C}\N{U+000D}\N{U+0085}]

<nondoublequote character> ~ [^"]

<doublequote symbol> ::= <double quote> <double quote>

<not equals operator> ::= <less than operator> <greater than operator>

<greater than or equals operator> ::= <greater than operator> <equals operator>

<less than or equals operator> ::= <less than operator> <equals operator>

<concatenation operator> ::= <vertical bar> <vertical bar>

<right arrow> ::= <minus sign> <greater than operator>

<double colon> ::= <colon> <colon>

<_white space> ~ [\p{Zs}\p{Zl}\p{Zp}\N{U+0009}\N{U+000A}\N{U+000B}\N{U+000C}\N{U+000D}\N{U+0085}]

<_separator unit> ~ <_comment> | <_white space>

<_separator> ~ <_separator unit>+
<separator> ~ <_separator>

<_comment> ~ <_simple comment> | <_bracketed comment>

#
# <_comment character> seems wrong to me: <_nonquote character> | <_quote character> will eat
# everything
#
<_not_newline> ~ [^\N{U+000A}\N{U+000D}]
<_comment character many> ~ <_not_newline>+

<_simple comment> ~ <_simple comment introducer> <_newline>
                  | <_simple comment introducer> <_comment character many> <_newline>

<_simple comment introducer> ~ <_minus sign><_minus sign>

<_bracketed comment> ~ <_bracketed comment introducer> <_bracketed comment contents> <_bracketed comment terminator>

<_bracketed comment introducer> ~ <_solidus> <_asterisk>

<_bracketed comment terminator> ~ <_asterisk> <_solidus>

<_bracketed comment contents unit> ~ <_comment character> | <_separator>

<_bracketed comment contents> ~ <_bracketed comment contents unit>*

<_comment character> ~ <_nonquote character> | <_quote>
#
# NOTE 93 — <newline> is typically represented by U+000A (“Line Feed”) and/or U+000D (“Carriage Return”); however,
# this representation is not required by ISO/IEC 9075.
#
<_newline> ~ [\N{U+000A}] [\N{U+000D}] | [\N{U+000D}] [\N{U+000A}] | [\N{U+000A}] | [\N{U+000D}]

<literal> ::= <signed numeric literal> | <general literal>

<unsigned literal> ::= <unsigned numeric literal> | <general literal>

<general literal> ::= <character string literal>
                    | <national character string literal>
                    | <Unicode character string literal>
                    | <binary string literal>
                    | <hex string literal>
                    | <datetime literal>
                    | <interval literal>
                    | <boolean literal>

<character representation any> ::= <character representation>*

<introducer character set specification maybe> ::= <introducer><character set specification>
<introducer character set specification maybe> ::=

<character string literal> ::= <introducer character set specification maybe> <quote> <character representation any> <quote>
                           | <character string literal> <separator> <quote> <character representation any> <quote>

<introducer> ::= <underscore>

<character representation> ::= <nonquote character> | <quote symbol>

<_nonquote character> ~ [^']
<nonquote character> ~ <_nonquote character>

<quote symbol> ::= <quote><quote>

<national character string literal> ::= <N> <quote> <character representation any> <quote>
                                    | <national character string literal> <separator> <quote> <character representation any> <quote>

<Unicode representation any> ::=  <Unicode representation>*

<separator AND quote AND Unicode representation any AND quote> ::= <separator> <quote> <Unicode representation any> <quote>

<separator AND quote AND Unicode representation any AND quote any> ::= <separator AND quote AND Unicode representation any AND quote>*

<ESCAPE escape character> ::= <ESCAPE> <escape character>

<ESCAPE escape character maybe> ::= <ESCAPE escape character>
<ESCAPE escape character maybe> ::=

<Unicode character string literal> ::= <U ampersand quote> <Unicode representation any> <quote> <separator AND quote AND Unicode representation any AND quote any> <ESCAPE escape character maybe>
                                   | <introducer><character set specification>
                                     <U ampersand quote> <Unicode representation any> <quote> <separator AND quote AND Unicode representation any AND quote any> <ESCAPE escape character maybe>

<Unicode representation> ::= <character representation> | <Unicode escape value>

<hexit AND hexit> ::= <hexit> <hexit>

<hexit AND hexit any> ::= <hexit AND hexit>*

<hexit any> ::= <hexit>*

<separator AND quote AND hexit AND hexit any AND quote> ::=  <separator> <quote> <hexit AND hexit any> <quote>

<separator AND quote AND hexit AND hexit any AND quote any> ::= <separator AND quote AND hexit AND hexit any AND quote>*

<separator AND quote AND hexit any AND quote> ::=  <separator> <quote> <hexit any> <quote>

<separator AND quote AND hexit any AND quote any> ::= <separator AND quote AND hexit any AND quote>*

<hex string literal> ::=
		<X> <quote> <hexit any> <quote>
		<separator AND quote AND hexit any AND quote any>
		<ESCAPE escape character maybe>

<binary string literal> ::=
		<X> <quote> <hexit AND hexit any> <quote>
		<separator AND quote AND hexit AND hexit any AND quote any>
		<ESCAPE escape character maybe>

<hexit> ::= <digit> | [A-Fa-f]

<signed numeric literal> ::= <unsigned numeric literal>
                         | <sign> <unsigned numeric literal>

<unsigned numeric literal> ::= <exact numeric literal> | <approximate numeric literal>

<exact numeric literal> ::=
		<unsigned integer>
	|	<unsigned integer> <period>
	|	<unsigned integer> <period> <unsigned integer>
	|	<period> <unsigned integer>

<sign> ::= <plus sign> | <minus sign>

<approximate numeric literal> ::= <mantissa> <E> <exponent>

<mantissa> ::= <exact numeric literal>

<exponent> ::= <signed integer>

<signed integer> ::= <unsigned integer>
                 | <sign> <unsigned integer>

<unsigned integer> ::= <digit>+

<datetime literal> ::= <date literal> | <time literal> | <timestamp literal>

<date literal> ::= <DATE> <date string>

<time literal> ::= <TIME> <time string>

<timestamp literal> ::= <TIMESTAMP> <timestamp string>

<date string> ::= <quote> <unquoted date string> <quote>

<time string> ::= <quote> <unquoted time string> <quote>

<timestamp string> ::= <quote> <unquoted timestamp string> <quote>

<time zone interval> ::= <sign> <hours value> <colon> <minutes value>

<date value> ::= <years value> <minus sign> <months value> <minus sign> <days value>

<time value> ::= <hours value> <colon> <minutes value> <colon> <seconds value>

<interval literal> ::= <INTERVAL> <interval string> <interval qualifier>
                   | <INTERVAL> <sign> <interval string> <interval qualifier>

<interval string> ::= <quote> <unquoted interval string> <quote>

<unquoted date string> ::= <date value>

<unquoted time string> ::= <time value>
                       | <time value> <time zone interval>

<unquoted timestamp string> ::= <unquoted date string> <space> <unquoted time string>

<unquoted interval string> ::= <year_month literal>
                           | <day_time literal>
                           | <sign> <year_month literal>
                           | <sign> <day_time literal>

<year_month literal> ::= <years value>
                     | <months value>
                     | <years value> <minus sign> <months value>

<day_time literal> ::= <day_time interval>
                   | <time interval>

<day_time interval> ::=
		<days value>
	|	<days value> <space> <hours value>
	|	<days value> <space> <hours value> <colon> <minutes value>
	|	<days value> <space> <hours value> <colon> <minutes value> <colon> <seconds value>

<time interval> ::=
		<hours value>
	|	<hours value> <colon> <minutes value>
	|	<hours value> <colon> <minutes value> <colon> <seconds value>
	|	<minutes value>
	|	<minutes value> <colon> <seconds value>
	|	<seconds value>

<years value> ::= <datetime value>

<months value> ::= <datetime value>

<days value> ::= <datetime value>

<hours value> ::= <datetime value>

<minutes value> ::= <datetime value>

<seconds value> ::= <seconds integer value>
                | <seconds integer value> <period>
                | <seconds integer value> <period> <seconds fraction>

<seconds integer value> ::= <unsigned integer>

<seconds fraction> ::= <unsigned integer>

<datetime value> ::= <unsigned integer>

<boolean literal> ::= <TRUE> | <FALSE> | <UNKNOWN>

<identifier> ::= <actual identifier>

<actual identifier> ::= <regular identifier>
                      | <delimited identifier>
                      | <Unicode delimited identifier>


<SQL language identifier> ::= <SQL language identifier start>
                          | <SQL language identifier> <underscore>
                          | <SQL language identifier> <SQL language identifier part>

<SQL language identifier start> ::= <simple Latin letter>

<SQL language identifier part> ::= <simple Latin letter> | <digit>

<authorization identifier> ::= <role name> | <user identifier>

<table name> ::= <local or schema qualified name>

<domain name> ::= <schema qualified name>

<schema name> ::= <unqualified schema name>
              | <catalog name> <period> <unqualified schema name>

<unqualified schema name> ::= <identifier>

<catalog name> ::= <identifier>

<schema qualified name> ::= <qualified identifier>
                        | <schema name> <period> <qualified identifier>

<local or schema qualified name> ::= <qualified identifier>
                                 | <local or schema qualifier> <period> <qualified identifier>

<local or schema qualifier> ::= <schema name> | <MODULE>

<qualified identifier> ::= <identifier>

<column name> ::= <identifier>

<correlation name> ::= <identifier>

<query name> ::= <identifier>

<SQL_client module name> ::= <identifier>

<procedure name> ::= <identifier>

<schema qualified routine name> ::= <schema qualified name>

<method name> ::= <identifier>

<specific name> ::= <schema qualified name>

<cursor name> ::= <local qualified name>

<local qualified name> ::= <qualified identifier>
                       | <local qualifier> <period> <qualified identifier>

<local qualifier> ::= <MODULE>

<host parameter name> ::= <colon> <identifier>

<SQL parameter name> ::= <identifier>

<constraint name> ::= <schema qualified name>

<external routine name> ::= <identifier> | <character string literal>

<trigger name> ::= <schema qualified name>

<collation name> ::= <schema qualified name>

<character set name> ::= <SQL language identifier>
                     | <schema name> <period> <SQL language identifier>

<transliteration name> ::= <schema qualified name>

<transcoding name> ::= <schema qualified name>

<user_defined type name> ::= <schema qualified type name>

<schema_resolved user_defined type name> ::= <user_defined type name>

<schema qualified type name> ::= <qualified identifier>
                             | <schema name> <period> <qualified identifier>

<attribute name> ::= <identifier>

<field name> ::= <identifier>

<savepoint name> ::= <identifier>

<sequence generator name> ::= <schema qualified name>

<role name> ::= <identifier>

<user identifier> ::= <identifier>

<connection name> ::= <simple value specification>

<SQL_server name> ::= <simple value specification>

<connection user name> ::= <simple value specification>

<SQL statement name> ::= <statement name> | <extended statement name>

<statement name> ::= <identifier>

<extended statement name> ::= <simple value specification>
                          | <scope option> <simple value specification>

<dynamic cursor name> ::= <cursor name> | <extended cursor name>

<extended cursor name> ::= <simple value specification>
                       | <scope option> <simple value specification>

<descriptor name> ::= <simple value specification>
                  | <scope option> <simple value specification>

<scope option> ::= <GLOBAL> | <LOCAL>

<window name> ::= <identifier>

#
# G1 Scalar expressions
# ---------------------
<data type> ::=
		<predefined type>
	|	<row type>
	|	<path_resolved user_defined type name>
	|	<reference type>
	|	<collection type>

<predefined type> ::=
		<character string type>
	|	<character string type> <collate clause>
	|	<character string type> <CHARACTER> <SET> <character set specification>
	|	<character string type> <CHARACTER> <SET> <character set specification> <collate clause>
	|	<national character string type>
	|	<national character string type>  <collate clause>
	|	<binary large object string type>
	|	<numeric type>
	|	<boolean type>
	|	<datetime type>
	|	<interval type>

<character string type> ::=
		<CHARACTER>
	|	<CHARACTER> <left paren> <length> <right paren>
	|	<CHAR>
	|	<CHAR> <left paren> <length> <right paren>
	|	<CHARACTER> <VARYING> <left paren> <length> <right paren>
	|	<CHAR> <VARYING> <left paren> <length> <right paren>
	|	<VARCHAR> <left paren> <length> <right paren>
	|	<CHARACTER> <LARGE> <OBJECT>
	|	<CHARACTER> <LARGE> <OBJECT> <left paren> <large object length> <right paren>
	|	<CHAR> <LARGE> <OBJECT>
	|	<CHAR> <LARGE> <OBJECT> <left paren> <large object length> <right paren>
	|	<CLOB>
	|	<CLOB> <left paren> <large object length> <right paren>

<national character string type> ::=
		<NATIONAL> <CHARACTER>
	|	<NATIONAL> <CHARACTER> <left paren> <length> <right paren>
	|	<NATIONAL> <CHAR>
	|	<NATIONAL> <CHAR> <left paren> <length> <right paren>
	|	<NCHAR>
	|	<NCHAR> <left paren> <length> <right paren>
	|	<NATIONAL> <CHARACTER> <VARYING> <left paren> <length> <right paren>
	|	<NATIONAL> <CHAR> <VARYING> <left paren> <length> <right paren>
	|	<NCHAR> <VARYING> <left paren> <length> <right paren>
	|	<NATIONAL> <CHARACTER> <LARGE> <OBJECT>
	|	<NATIONAL> <CHARACTER> <LARGE> <OBJECT> <left paren> <large object length> <right paren>
	|	<NCHAR> <LARGE> <OBJECT>
	|	<NCHAR> <LARGE> <OBJECT> <left paren> <large object length> <right paren>
	|	<NCLOB>
	|	<NCLOB> <left paren> <large object length> <right paren>

<binary large object string type> ::=
		<BINARY> <LARGE> <OBJECT>
	|	<BINARY> <LARGE> <OBJECT> <left paren> <large object length> <right paren>
	|	<BLOB>
	|	<BLOB> <left paren> <large object length> <right paren>

<numeric type> ::= <exact numeric type> | <approximate numeric type>

<exact numeric type> ::=
		<NUMERIC>
	|	<NUMERIC> <left paren> <precision>  <right paren>
	|	<NUMERIC> <left paren> <precision> <comma> <scale> <right paren>
	|	<DECIMAL>
	|	<DECIMAL> <left paren> <precision> <right paren>
	|	<DECIMAL> <left paren> <precision> <comma> <scale> <right paren>
	|	<DEC>
	|	<DEC> <left paren> <precision> <right paren>
	|	<DEC> <left paren> <precision> <comma> <scale> <right paren>
	|	<SMALLINT>
	|	<INTEGER>
	|	<INT>
	|	<BIGINT>

<approximate numeric type> ::=
		<FLOAT>
	|	<FLOAT> <left paren> <precision> <right paren>
	|	<REAL>
	|	<DOUBLE> <PRECISION>

<length> ::= <unsigned integer>

<large object length> ::=
		<unsigned integer>
	|	<unsigned integer> <char length units>
	|	<unsigned integer> <multiplier>
	|	<unsigned integer> <multiplier> <char length units>
	|	<large object length token>
	|	<large object length token> <char length units>

<char length units> ::= <CHARACTERS> | <CODE_UNITS> | <OCTETS>

<precision> ::= <unsigned integer>

<scale> ::= <unsigned integer>

<boolean type> ::= <BOOLEAN>

<datetime type> ::=
		<DATE>
	|	<TIME>
	|	<TIME> <with or without time zone>
	|	<TIME> <left paren> <time precision> <right paren>
	|	<TIME> <left paren> <time precision> <right paren> <with or without time zone>
	|	<TIMESTAMP>
	|	<TIMESTAMP> <with or without time zone>
	|	<TIMESTAMP> <left paren> <timestamp precision> <right paren>
	|	<TIMESTAMP> <left paren> <timestamp precision> <right paren> <with or without time zone>

<with or without time zone> ::= <WITH> <TIME> <ZONE> | <WITHOUT> <TIME> <ZONE>

<time precision> ::= <time fractional seconds precision>

<timestamp precision> ::= <time fractional seconds precision>

<time fractional seconds precision> ::= <unsigned integer>

<interval type> ::= <INTERVAL> <interval qualifier>

<row type> ::= <ROW> <row type body>

<field definitions> ::= <field definition>
                      | <field definitions> <comma> <field definition>

<row type body> ::= <left paren> <field definitions> <right paren>

<reference type> ::= <REF> <left paren> <referenced type> <right paren>
                   | <REF> <left paren> <referenced type> <right paren> <scope clause>

<scope clause> ::= <SCOPE> <table name>

<referenced type> ::= <path_resolved user_defined type name>

<path_resolved user_defined type name> ::= <user_defined type name>

<collection type> ::= <array type> | <multiset type>

<array type> ::= <data type> <ARRAY>
               | <data type> <ARRAY> <left bracket or trigraph> <unsigned integer> <right bracket or trigraph>

<multiset type> ::= <data type> <MULTISET>

<field definition> ::= <field name> <data type>
                     | <field name> <data type> <reference scope check>

<value expression primary> ::=
		<parenthesized value expression>
	|	<nonparenthesized value expression primary>

<parenthesized value expression> ::= <left paren> <value expression> <right paren>

<nonparenthesized value expression primary> ::=
		<unsigned value specification>
	|	<column reference>
	|	<set function specification>
	|	<window function>
	|	<scalar subquery>
	|	<case expression>
	|	<cast specification>
	|	<field reference>
	|	<subtype treatment>
	|	<method invocation>
	|	<static method invocation>
	|	<new specification>
	|	<attribute or method reference>
	|	<reference resolution>
	|	<collection value constructor>
	|	<array element reference>
	|	<multiset element reference>
	|	<routine invocation>
	|	<next value expression>

<value specification> ::= <literal> | <general value specification>

<unsigned value specification> ::= <unsigned literal> | <general value specification>

<general value specification> ::=
		<host parameter specification>
	|	<SQL parameter reference>
	|	<dynamic parameter specification>
	|	<embedded variable specification>
	|	<current collation specification>
	|	<CURRENT_DEFAULT_TRANSFORM_GROUP>
	|	<CURRENT_PATH>
	|	<CURRENT_ROLE>
	|	<CURRENT_TRANSFORM_GROUP_FOR_TYPE> <path_resolved user_defined type name>
	|	<CURRENT_USER>
	|	<SESSION_USER>
	|	<SYSTEM_USER>
	|	<USER>
	|	<VALUE>

<simple value specification> ::=
		<literal>
	|	<host parameter name>
	|	<SQL parameter reference>
	|	<embedded variable name>

<target specification> ::=
		<host parameter specification>
	|	<SQL parameter reference>
	|	<column reference>
	|	<target array element specification>
	|	<dynamic parameter specification>
	|	<embedded variable specification>

<simple target specification> ::=
		<host parameter specification>
	|	<SQL parameter reference>
	|	<column reference>
	|	<embedded variable name>

<host parameter specification> ::= <host parameter name>
                                 | <host parameter name> <indicator parameter>

<dynamic parameter specification> ::= <question mark>

<embedded variable specification> ::= <embedded variable name>
                                    | <embedded variable name> <indicator variable>

<indicator variable> ::= <embedded variable name>
                       | <INDICATOR> <embedded variable name>

<indicator parameter> ::= <host parameter name>
                        | <INDICATOR> <host parameter name>

<target array element specification> ::=
		<target array reference> <left bracket or trigraph> <simple value specification> <right bracket or trigraph> 

<target array reference> ::= <SQL parameter reference> | <column reference>

<current collation specification> ::= <CURRENT_COLLATION> <left paren> <string value expression> <right paren>

<contextually typed value specification> ::=
		<implicitly typed value specification> | <default specification>

<implicitly typed value specification> ::= <null specification> | <empty specification>

<null specification> ::= <NULL>

<empty specification> ::=
		<ARRAY> <left bracket or trigraph> <right bracket or trigraph>
	|	<MULTISET> <left bracket or trigraph> <right bracket or trigraph>

<default specification> ::= <DEFAULT>

<identifier chain> ::= <identifier>
                     | <identifier chain> <period> <identifier>

<basic identifier chain> ::= <identifier chain>

<column reference> ::=
		<basic identifier chain>
	|	<MODULE> <period> <qualified identifier> <period> <column name>

<SQL parameter reference> ::= <basic identifier chain>

<set function specification> ::= <aggregate function> | <grouping operation>

<column reference chain> ::= <column reference>
                           | <column reference chain> <comma> <column reference>
<grouping operation> ::= <GROUPING> <left paren> <column reference chain> <right paren>

<window function> ::= <window function type> <OVER> <window name or specification>

<window function type> ::=
		<rank function type> <left paren> <right paren>
	|	<ROW_NUMBER> <left paren> <right paren>
	|	<aggregate function>

<rank function type> ::= <RANK> | <DENSE_RANK> | <PERCENT_RANK> | <CUME_DIST>

<window name or specification> ::= <window name> | <in_line window specification>

<in_line window specification> ::= <window specification>

<case expression> ::= <case abbreviation> | <case specification>

<comma AND value expression> ::= <comma> <value expression>

<comma AND value expression many> ::= <comma AND value expression>+

<case abbreviation> ::=
		<NULLIF> <left paren> <value expression> <comma> <value expression> <right paren>
	|	<COALESCE> <left paren> <value expression> <comma AND value expression many> <right paren>

<case specification> ::= <simple case> | <searched case>

<simple when clause many> ::= <simple when clause>+

<simple case> ::= <CASE> <case operand> <simple when clause many> <END>
                | <CASE> <case operand> <simple when clause many> <else clause> <END>

<searched when clause many> ::= <searched when clause>+

<searched case> ::= <CASE> <searched when clause many> <END>
                  | <CASE> <searched when clause many> <else clause> <END>

<simple when clause> ::= <WHEN> <when operand> <THEN> <result>

<searched when clause> ::= <WHEN> <search condition> <THEN> <result>

<else clause> ::= <ELSE> <result>

<case operand> ::= <row value predicand> | <overlaps predicate part 1>

<when operand> ::=
		<row value predicand>
	|	<comparison predicate part 2>
	|	<between predicate part 2>
	|	<in predicate part 2>
	|	<character like predicate part 2>
	|	<octet like predicate part 2>
	|	<similar predicate part 2>
	|	<null predicate part 2>
	|	<quantified comparison predicate part 2>
	|	<match predicate part 2>
	|	<overlaps predicate part 2>
	|	<distinct predicate part 2>
	|	<member predicate part 2>
	|	<submultiset predicate part 2>
	|	<set predicate part 2>
	|	<type predicate part 2>

<result> ::= <result expression> | <NULL>

<result expression> ::= <value expression>

<cast specification> ::= <CAST> <left paren> <cast operand> <AS> <cast target> <right paren>

<cast operand> ::= <value expression> | <implicitly typed value specification>

<cast target> ::= <domain name> | <data type>

<next value expression> ::= <NEXT> <VALUE> <FOR> <sequence generator name>

<field reference> ::= <value expression primary> <period> <field name>

<subtype treatment> ::=	<TREAT> <left paren> <subtype operand> <AS> <target subtype> <right paren>

<subtype operand> ::= <value expression>

<target subtype> ::=
		<path_resolved user_defined type name>
	|	<reference type>

<method invocation> ::= <direct invocation> | <generalized invocation>

<direct invocation> ::=	<value expression primary> <period> <method name>
                      | <value expression primary> <period> <method name> <SQL argument list>

<generalized invocation> ::= <left paren> <value expression primary> <AS> <data type> <right paren> <period> <method name>
                           | <left paren> <value expression primary> <AS> <data type> <right paren> <period> <method name> <SQL argument list>

<static method invocation> ::= <path_resolved user_defined type name> <double colon> <method name>
                             | <path_resolved user_defined type name> <double colon> <method name> <SQL argument list>

<new specification> ::= <NEW> <routine invocation>

<attribute or method reference> ::= <value expression primary> <dereference operator> <qualified identifier>
                                  | <value expression primary> <dereference operator> <qualified identifier> <SQL argument list>

<dereference operator> ::= <right arrow>

<reference resolution> ::= <DEREF> <left paren> <reference value expression> <right paren>

<array element reference> ::= <array value expression> <left bracket or trigraph> <numeric value expression> <right bracket or trigraph> 

<multiset element reference> ::= <ELEMENT> <left paren> <multiset value expression> <right paren>

<value expression> ::=
		<common value expression>
	|	<boolean value expression>
	|	<row value expression>

<common value expression> ::=
		<numeric value expression>
	|	<string value expression>
	|	<datetime value expression>
	|	<interval value expression>
	|	<user_defined type value expression>
	|	<reference value expression>
	|	<collection value expression>

<user_defined type value expression> ::= <value expression primary>

<reference value expression> ::= <value expression primary>

<collection value expression> ::= <array value expression> | <multiset value expression>

<collection value constructor> ::= <array value constructor> | <multiset value constructor>

<numeric value expression> ::=
		<term>
	|	<numeric value expression> <plus sign> <term>
	|	<numeric value expression> <minus sign> <term>

<term> ::=
		<factor>
	|	<term> <asterisk> <factor>
	|	<term> <solidus> <factor>

<factor> ::= <numeric primary>
           | <sign> <numeric primary>

<numeric primary> ::=
		<value expression primary>
	|	<numeric value function>

<numeric value function> ::=
		<position expression>
	|	<extract expression>
	|	<length expression>
	|	<cardinality expression>
	|	<absolute value expression>
	|	<modulus expression>
	|	<natural logarithm>
	|	<exponential function>
	|	<power function>
	|	<square root>
	|	<floor function>
	|	<ceiling function>
	|	<width bucket function>

<position expression> ::=
		<string position expression>
	|	<blob position expression>

<string position expression> ::= <POSITION> <left paren> <string value expression> <IN> <string value expression>                             <right paren>
                               | <POSITION> <left paren> <string value expression> <IN> <string value expression> <USING> <char length units> <right paren>

<blob position expression> ::= <POSITION> <left paren> <blob value expression> <IN> <blob value expression> <right paren>

<length expression> ::=
		<char length expression>
	|	<octet length expression>

<char length expression> ::= <CHAR_LENGTH>      <left paren> <string value expression>                             <right paren>
                           | <CHAR_LENGTH>      <left paren> <string value expression> <USING> <char length units> <right paren>
                           | <CHARACTER_LENGTH> <left paren> <string value expression>                             <right paren>
                           | <CHARACTER_LENGTH> <left paren> <string value expression> <USING> <char length units> <right paren>

<octet length expression> ::= <OCTET_LENGTH> <left paren> <string value expression> <right paren>

<extract expression> ::= <EXTRACT> <left paren> <extract field> <FROM> <extract source> <right paren>

<extract field> ::= <primary datetime field> | <time zone field>

<time zone field> ::= <TIMEZONE_HOUR> | <TIMEZONE_MINUTE>

<extract source> ::= <datetime value expression> | <interval value expression>

<cardinality expression> ::= <CARDINALITY> <left paren> <collection value expression> <right paren>

<absolute value expression> ::= <ABS> <left paren> <numeric value expression> <right paren>

<modulus expression> ::= <MOD> <left paren> <numeric value expression dividend> <comma> <numeric value expression divisor><right paren>

<numeric value expression dividend> ::= <numeric value expression>

<numeric value expression divisor> ::= <numeric value expression>

<natural logarithm> ::= <LN> <left paren> <numeric value expression> <right paren>

<exponential function> ::= <EXP> <left paren> <numeric value expression> <right paren>

<power function> ::= <POWER> <left paren> <numeric value expression base> <comma> <numeric value expression exponent> <right paren>

<numeric value expression base> ::= <numeric value expression>

<numeric value expression exponent> ::= <numeric value expression>

<square root> ::= <SQRT> <left paren> <numeric value expression> <right paren>

<floor function> ::= <FLOOR> <left paren> <numeric value expression> <right paren>

<ceiling function> ::= <CEIL>    <left paren> <numeric value expression> <right paren>
                     | <CEILING> <left paren> <numeric value expression> <right paren>

<width bucket function> ::= <WIDTH_BUCKET> <left paren> <width bucket operand> <comma> <width bucket bound 1> <comma> <width bucket bound 2> <comma> <width bucket count> <right paren>

<width bucket operand> ::= <numeric value expression>

<width bucket bound 1> ::= <numeric value expression>

<width bucket bound 2> ::= <numeric value expression>

<width bucket count> ::= <numeric value expression>

<string value expression> ::= <character value expression> | <blob value expression>

<character value expression> ::= <concatenation> | <character factor>

<concatenation> ::= <character value expression> <concatenation operator> <character factor>

<character factor> ::= <character primary>
                     | <character primary> <collate clause>

<character primary> ::= <value expression primary> | <string value function>

<blob value expression> ::= <blob concatenation> | <blob factor>

<blob factor> ::= <blob primary>

<blob primary> ::= <value expression primary> | <string value function>

<blob concatenation> ::= <blob value expression> <concatenation operator> <blob factor>

<string value function> ::= <character value function> | <blob value function>

<character value function> ::=
		<character substring function>
	|	<regular expression substring function>
	|	<fold>
	|	<transcoding>
	|	<character transliteration>
	|	<trim function>
	|	<character overlay function>
	|	<normalize function>
	|	<specific type method>

<character substring function> ::= <SUBSTRING> <left paren> <character value expression> <FROM> <start position> <right paren>
                                 | <SUBSTRING> <left paren> <character value expression> <FROM> <start position> <FOR> <string length> <right paren>
                                 | <SUBSTRING> <left paren> <character value expression> <FROM> <start position> <USING> <char length units> <right paren>
                                 | <SUBSTRING> <left paren> <character value expression> <FROM> <start position> <FOR> <string length> <USING> <char length units> <right paren>

<regular expression substring function> ::=
		<SUBSTRING> <left paren> <character value expression>
		<SIMILAR> <character value expression> <ESCAPE> <escape character> <right paren>

<fold> ::= <UPPER> <left paren> <character value expression> <right paren>
         | <LOWER> <left paren> <character value expression> <right paren>

<transcoding> ::= <CONVERT> <left paren> <character value expression> <USING> <transcoding name> <right paren>

<character transliteration> ::= <TRANSLATE> <left paren> <character value expression> <USING> <transliteration name> <right paren>

<trim function> ::= <TRIM> <left paren> <trim operands> <right paren>

<trim operands> ::= <trim source>
                  | <FROM> <trim source>
                  | <trim specification> <FROM> <trim source>
                  | <trim character> <FROM> <trim source>
                  | <trim specification> <trim character> <FROM> <trim source>

<trim source> ::= <character value expression>

<trim specification> ::= <LEADING> | <TRAILING> | <BOTH>

<trim character> ::= <character value expression>

<character overlay function> ::=
    <OVERLAY> <left paren> <character value expression> <PLACING> <character value expression> <FROM> <start position>                                                   <right paren>
 |  <OVERLAY> <left paren> <character value expression> <PLACING> <character value expression> <FROM> <start position> <FOR> <string length>                             <right paren>
 |  <OVERLAY> <left paren> <character value expression> <PLACING> <character value expression> <FROM> <start position>                       <USING> <char length units> <right paren>
 |  <OVERLAY> <left paren> <character value expression> <PLACING> <character value expression> <FROM> <start position> <FOR> <string length> <USING> <char length units> <right paren>

<normalize function> ::= <NORMALIZE> <left paren> <character value expression> <right paren>

<specific type method> ::= <user_defined type value expression> <period> <SPECIFICTYPE>

<blob value function> ::=
		<blob substring function>
	|	<blob trim function>
	|	<blob overlay function>

<blob substring function> ::=
		<SUBSTRING> <left paren> <blob value expression> <FROM> <start position>                       <right paren>
	|	<SUBSTRING> <left paren> <blob value expression> <FROM> <start position> <FOR> <string length> <right paren>

<blob trim function> ::= <TRIM> <left paren> <blob trim operands> <right paren>

<blob trim operands> ::=                                          <blob trim source>
                       |                                   <FROM> <blob trim source>
                       | <trim specification>              <FROM> <blob trim source>
                       |                      <trim octet> <FROM> <blob trim source>
                       | <trim specification> <trim octet> <FROM> <blob trim source>

<blob trim source> ::= <blob value expression>

<trim octet> ::= <blob value expression>

<blob overlay function> ::=
		<OVERLAY> <left paren> <blob value expression> <PLACING> <blob value expression> <FROM> <start position> <FOR> <string length> <right paren>
	|	<OVERLAY> <left paren> <blob value expression> <PLACING> <blob value expression> <FROM> <start position>                       <right paren>

<start position> ::= <numeric value expression>

<string length> ::= <numeric value expression>

<datetime value expression> ::=
		<datetime term>
	|	<interval value expression> <plus sign> <datetime term>
	|	<datetime value expression> <plus sign> <interval term>
	|	<datetime value expression> <minus sign> <interval term>

<datetime term> ::= <datetime factor>

<datetime factor> ::= <datetime primary>
                    | <datetime primary> <time zone>

<datetime primary> ::= <value expression primary> | <datetime value function>

<time zone> ::= <AT> <time zone specifier>

<time zone specifier> ::= <LOCAL> | <TIME> <ZONE> <interval primary>

<datetime value function> ::=
		<current date value function>
	|	<current time value function>
	|	<current timestamp value function>
	|	<current local time value function>
	|	<current local timestamp value function>

<current date value function> ::= <CURRENT_DATE>

<current time value function> ::= <CURRENT_TIME>
                                | <CURRENT_TIME> <left paren> <time precision> <right paren>

<current local time value function> ::= <LOCALTIME>
                                      | <LOCALTIME> <left paren> <time precision> <right paren>

<current timestamp value function> ::= <CURRENT_TIMESTAMP>
                                     | <CURRENT_TIMESTAMP> <left paren> <timestamp precision> <right paren>

<current local timestamp value function> ::= <LOCALTIMESTAMP>
                                           | <LOCALTIMESTAMP> <left paren> <timestamp precision> <right paren>

<interval value expression> ::=
		<interval term>
	|	<interval value expression 1> <plus sign> <interval term 1>
	|	<interval value expression 1> <minus sign> <interval term 1>
	|	<left paren> <datetime value expression> <minus sign> <datetime term> <right paren> <interval qualifier>

<interval term> ::=
		<interval factor>
	|	<interval term 2> <asterisk> <factor>
	|	<interval term 2> <solidus> <factor>
	|	<term> <asterisk> <interval factor>

<interval factor> ::= <interval primary>
                    | <sign> <interval primary>

<interval primary> ::=
		<value expression primary>
	|	<value expression primary> <interval qualifier>
	|	<interval value function>

<interval value expression 1> ::= <interval value expression>

<interval term 1> ::= <interval term>

<interval term 2> ::= <interval term>

<interval value function> ::= <interval absolute value function>

<interval absolute value function> ::= <ABS> <left paren> <interval value expression> <right paren>

<boolean value expression> ::=
		<boolean term>
	|	<boolean value expression> <OR> <boolean term>

<boolean term> ::=
		<boolean factor>
	|	<boolean term> <AND> <boolean factor>

<boolean factor> ::= <boolean test>
                   | <NOT> <boolean test>

<boolean test> ::= <boolean primary>
                 | <boolean primary> <IS> <truth value>
                 | <boolean primary> <IS> <NOT> <truth value>

<truth value> ::= <TRUE> | <FALSE> | <UNKNOWN>

<boolean primary> ::= <predicate> | <boolean predicand>

<boolean predicand> ::=
		<parenthesized boolean value expression>
	|	<nonparenthesized value expression primary>

<parenthesized boolean value expression> ::= <left paren> <boolean value expression> <right paren>

<array value expression> ::= <array concatenation> | <array factor>

<array concatenation> ::= <array value expression 1> <concatenation operator> <array factor>

<array value expression 1> ::= <array value expression>

<array factor> ::= <value expression primary>

<array value constructor> ::=
		<array value constructor by enumeration>
	|	<array value constructor by query>

<array value constructor by enumeration> ::=
		<ARRAY> <left bracket or trigraph> <array element list> <right bracket or trigraph>

<array element list> ::= <array element>
                       | <array element list> <comma> <array element>

<array element> ::= <value expression>

<array value constructor by query> ::= <ARRAY> <left paren> <query expression> <right paren>
                                     | <ARRAY> <left paren> <query expression> <order by clause> <right paren>

<multiset value expression> ::=
		<multiset term>
	|	<multiset value expression> <MULTISET> <UNION>             <multiset term>
	|	<multiset value expression> <MULTISET> <UNION> <ALL>       <multiset term>
	|	<multiset value expression> <MULTISET> <UNION> <DISTINCT>  <multiset term>
	|	<multiset value expression> <MULTISET> <EXCEPT>            <multiset term>
	|	<multiset value expression> <MULTISET> <EXCEPT> <ALL>      <multiset term>
	|	<multiset value expression> <MULTISET> <EXCEPT> <DISTINCT> <multiset term>

<multiset term> ::=
		<multiset primary>
	|	<multiset term> <MULTISET> <INTERSECT>            <multiset primary>
	|	<multiset term> <MULTISET> <INTERSECT> <ALL>      <multiset primary>
	|	<multiset term> <MULTISET> <INTERSECT> <DISTINCT> <multiset primary>

<multiset primary> ::= <multiset value function> | <value expression primary>

<multiset value function> ::= <multiset set function>

<multiset set function> ::= <SET> <left paren> <multiset value expression> <right paren>

<multiset value constructor> ::=
		<multiset value constructor by enumeration>
	|	<multiset value constructor by query>
	|	<table value constructor by query>

<multiset value constructor by enumeration> ::= <MULTISET> <left bracket or trigraph> <multiset element list> <right bracket or trigraph>

<multiset element list> ::= <multiset element>
                          | <multiset element list> <comma> <multiset element>

<multiset element> ::= <value expression>

<multiset value constructor by query> ::= <MULTISET> <left paren> <query expression> <right paren>

<table value constructor by query> ::= <TABLE> <left paren> <query expression> <right paren>

<row value constructor> ::=
		<common value expression>
	|	<boolean value expression>
	|	<explicit row value constructor>

<explicit row value constructor> ::=
		<left paren> <row value constructor element> <comma> <row value constructor element list> <right paren>
	|	<ROW> <left paren> <row value constructor element list> <right paren>
	|	<row subquery>

<row value constructor element list> ::= <row value constructor element>
                                       | <row value constructor element list> <comma> <row value constructor element>

<row value constructor element> ::= <value expression>

<contextually typed row value constructor> ::=
		<common value expression>
	|	<boolean value expression>
	|	<contextually typed value specification>
	|	<left paren> <contextually typed row value constructor element> <comma> <contextually typed row value constructor element list> <right paren>
	|	<ROW> <left paren> <contextually typed row value constructor element list> <right paren>

<contextually typed row value constructor element list> ::= <contextually typed row value constructor element>
                                                          | <contextually typed row value constructor element list> <comma> <contextually typed row value constructor element>

<contextually typed row value constructor element> ::=
		<value expression>
	|	<contextually typed value specification>

<row value constructor predicand> ::=
		<common value expression>
	|	<boolean predicand>
	|	<explicit row value constructor>

<row value expression> ::=
		<row value special case>
	|	<explicit row value constructor>

<table row value expression> ::=
		<row value special case>
	|	<row value constructor>

<contextually typed row value expression> ::=
		<row value special case>
	|	<contextually typed row value constructor>

<row value predicand> ::=
		<row value special case>
	|	<row value constructor predicand>

<row value special case> ::= <nonparenthesized value expression primary>

<table value constructor> ::= <VALUES> <row value expression list>

<row value expression list> ::= <table row value expression>
                              | <row value expression list> <comma> <table row value expression>

<contextually typed table value constructor> ::= <VALUES> <contextually typed row value expression list>

<contextually typed row value expression list> ::= <contextually typed row value expression>
                                                 | <contextually typed row value expression list> <comma> <contextually typed row value expression>

<table expression> ::= <from clause>
	|	<from clause> <where clause>
	|	<from clause> <where clause> <group by clause>
	|	<from clause> <where clause> <group by clause> <having clause>
	|	<from clause> <where clause> <group by clause> <having clause> <window clause>
	|	<from clause> <where clause> <group by clause> <window clause>
	|	<from clause> <where clause> <having clause>
	|	<from clause> <where clause> <having clause> <window clause>
	|	<from clause> <where clause> <window clause>
	|	<from clause> <group by clause>
	|	<from clause> <group by clause> <having clause>
	|	<from clause> <group by clause> <having clause> <window clause>
	|	<from clause> <group by clause> <window clause>
	|	<from clause> <having clause>
	|	<from clause> <having clause> <window clause>
	|	<from clause> <window clause>

<from clause> ::= <FROM> <table reference list>

<table reference list> ::= <table reference>
                         | <table reference list> <comma> <table reference>

<table reference> ::= <table primary or joined table>
                    | <table primary or joined table> <sample clause>

<table primary or joined table> ::= <table primary> | <joined table>

<sample clause> ::= <TABLESAMPLE> <sample method> <left paren> <sample percentage> <right paren>
                  | <TABLESAMPLE> <sample method> <left paren> <sample percentage> <right paren> <repeatable clause>

<sample method> ::= <BERNOULLI> | <SYSTEM>

<repeatable clause> ::= <REPEATABLE> <left paren> <repeat argument> <right paren>

<sample percentage> ::= <numeric value expression>

<repeat argument> ::= <numeric value expression>

<table primary> ::=
		<table or query name>
	|	<table or query name>      <correlation name>
	|	<table or query name>      <correlation name> <left paren> <derived column list> <right paren>
	|	<table or query name> <AS> <correlation name>
	|	<table or query name> <AS> <correlation name> <left paren> <derived column list> <right paren>
	|	<derived table>      <correlation name>
	|	<derived table>      <correlation name> <left paren> <derived column list> <right paren>
	|	<derived table> <AS> <correlation name>
	|	<derived table> <AS> <correlation name> <left paren> <derived column list> <right paren>
	|	<lateral derived table>      <correlation name>
	|	<lateral derived table>      <correlation name> <left paren> <derived column list> <right paren>
	|	<lateral derived table> <AS> <correlation name>
	|	<lateral derived table> <AS> <correlation name> <left paren> <derived column list> <right paren>
	|	<collection derived table>      <correlation name>
	|	<collection derived table>      <correlation name> <left paren> <derived column list> <right paren>
	|	<collection derived table> <AS> <correlation name>
	|	<collection derived table> <AS> <correlation name> <left paren> <derived column list> <right paren>
	|	<table function derived table>      <correlation name>
	|	<table function derived table>      <correlation name> <left paren> <derived column list> <right paren>
	|	<table function derived table> <AS> <correlation name>
	|	<table function derived table> <AS> <correlation name> <left paren> <derived column list> <right paren>
	|	<only spec>
	|	<only spec>      <correlation name>
	|	<only spec>      <correlation name> <left paren> <derived column list> <right paren>
	|	<only spec> <AS> <correlation name>
	|	<only spec> <AS> <correlation name> <left paren> <derived column list> <right paren>
	|	<left paren> <joined table> <right paren>

<only spec> ::= <ONLY> <left paren> <table or query name> <right paren>

<lateral derived table> ::= <LATERAL> <table subquery>

<collection derived table> ::= <UNNEST> <left paren> <collection value expression> <right paren>
                             | <UNNEST> <left paren> <collection value expression> <right paren> <WITH> <ORDINALITY>

<table function derived table> ::= <TABLE> <left paren> <collection value expression> <right paren>

<derived table> ::= <table subquery>

<table or query name> ::= <table name> | <query name>

<derived column list> ::= <column name list>

<column name list> ::= <column name>
                     | <column name list> <comma> <column name>

<joined table> ::=
		<cross join>
	|	<qualified join>
	|	<natural join>
	|	<union join>

<cross join> ::= <table reference> <CROSS> <JOIN> <table primary>

<qualified join> ::= <table reference>             <JOIN> <table reference> <join specification>
                   | <table reference> <join type> <JOIN> <table reference> <join specification>

<natural join> ::= <table reference> <NATURAL>             <JOIN> <table primary>
                 | <table reference> <NATURAL> <join type> <JOIN> <table primary>

<union join> ::= <table reference> <UNION> <JOIN> <table primary>

<join specification> ::= <join condition> | <named columns join>

<join condition> ::= <ON> <search condition>

<named columns join> ::= <USING> <left paren> <join column list> <right paren>

<join type> ::= <INNER>
              | <outer join type>
              | <outer join type> <OUTER>

<outer join type> ::= <LEFT> | <RIGHT> | <FULL>

<join column list> ::= <column name list>

<where clause> ::= <WHERE> <search condition>

<group by clause> ::= <GROUP> <BY>                  <grouping element list>
                    | <GROUP> <BY> <set quantifier> <grouping element list>

<grouping element list> ::= <grouping element>
                          | <grouping element list> <comma> <grouping element>

<grouping element> ::=
		<ordinary grouping set>
	|	<rollup list>
	|	<cube list>
	|	<grouping sets specification>
	|	<empty grouping set>

<ordinary grouping set> ::=
		<grouping column reference>
	|	<left paren> <grouping column reference list> <right paren>

<grouping column reference> ::= <column reference>
                              | <column reference> <collate clause>

<grouping column reference list> ::= <grouping column reference>
                                   | <grouping column reference list> <comma> <grouping column reference>

<rollup list> ::= <ROLLUP> <left paren> <ordinary grouping set list> <right paren>

<ordinary grouping set list> ::= <ordinary grouping set>
                               | <ordinary grouping set list> <comma> <ordinary grouping set>

<cube list> ::= <CUBE> <left paren> <ordinary grouping set list> <right paren>

<grouping sets specification> ::= <GROUPING> <SETS> <left paren> <grouping set list> <right paren>

<grouping set list> ::= <grouping set>
                      | <grouping set list> <comma> <grouping set>

<grouping set> ::=
		<ordinary grouping set>
	|	<rollup list>
	|	<cube list>
	|	<grouping sets specification>
	|	<empty grouping set>

<empty grouping set> ::= <left paren> <right paren>

<having clause> ::= <HAVING> <search condition>

<window clause> ::= <WINDOW> <window definition list>

<window definition list> ::= <window definition>
                           | <window definition list> <comma> <window definition>

<window definition> ::= <new window name> <AS> <window specification>

<new window name> ::= <window name>

#
# Little grammar deviation: I make <window specification details> explicitely optional in <window specification> 
#
<window specification> ::= <left paren> <right paren>
                         | <left paren> <window specification details> <right paren>

<window specification details> ::=
		<existing window name>
	|	<existing window name> <window partition clause>
	|	<existing window name> <window partition clause> <window order clause>
	|	<existing window name> <window partition clause> <window order clause> <window frame clause>
	|	<existing window name> <window partition clause> <window frame clause>
	|	<existing window name> <window order clause>
	|	<existing window name> <window order clause> <window frame clause>
	|	<existing window name> <window frame clause>
	|	<window partition clause>
	|	<window partition clause> <window order clause>
	|	<window partition clause> <window order clause> <window frame clause>
	|	<window partition clause> <window frame clause>
	|	<window order clause>
	|	<window order clause> <window frame clause>
	|	<window frame clause>

<existing window name> ::= <window name>

<window partition clause> ::= <PARTITION> <BY> <window partition column reference list>

<window partition column reference list> ::= <window partition column reference>
                                           | <window partition column reference list> <comma> <window partition column reference>

<window partition column reference> ::= <column reference>
                                      | <column reference> <collate clause>

<window order clause> ::= <ORDER> <BY> <sort specification list>

<window frame clause> ::= <window frame units> <window frame extent>
                        | <window frame units> <window frame extent> <window frame exclusion>

<window frame units> ::= <ROWS> | <RANGE>

<window frame extent> ::= <window frame start> | <window frame between>

<window frame start> ::= <UNBOUNDED> <PRECEDING> | <window frame preceding> | <CURRENT> <ROW>

<window frame preceding> ::= <unsigned value specification> <PRECEDING>

<window frame between> ::= <BETWEEN> <window frame bound 1> <AND> <window frame bound 2>

<window frame bound 1> ::= <window frame bound>

<window frame bound 2> ::= <window frame bound>

<window frame bound> ::=
		<window frame start>
	|	<UNBOUNDED> <FOLLOWING>
	|	<window frame following>

<window frame following> ::= <unsigned value specification> <FOLLOWING>

<window frame exclusion> ::=
		<EXCLUDE> <CURRENT> <ROW>
	|	<EXCLUDE> <GROUP>
	|	<EXCLUDE> <TIES>
	|	<EXCLUDE> <NO> <OTHERS>

<query specification> ::= <SELECT>                  <select list> <table expression>
                        | <SELECT> <set quantifier> <select list> <table expression>

#
# I create a <select sublist list> explicit sequence here
#
<select sublist list> ::= <select sublist>
                        | <select sublist list> <comma> <select sublist>

<select list> ::= <asterisk> | <select sublist list>

<select sublist> ::= <derived column> | <qualified asterisk>

<qualified asterisk> ::=
		<asterisked identifier chain> <period> <asterisk>
	|	<all fields reference>

<asterisked identifier chain> ::= <asterisked identifier>
                                | <asterisked identifier chain> <period> <asterisked identifier>

<asterisked identifier> ::= <identifier>

<derived column> ::= <value expression>
                   | <value expression> <as clause>

<as clause> ::=      <column name>
              | <AS> <column name>

<all fields reference> ::= <value expression primary> <period> <asterisk>
                         | <value expression primary> <period> <asterisk> <AS> <left paren> <all fields column name list> <right paren>

<all fields column name list> ::= <column name list>

<query expression> ::=               <query expression body>
                     | <with clause> <query expression body>

<with clause> ::= <WITH>             <with list>
                | <WITH> <RECURSIVE> <with list>

<with list> ::= <with list element>
              | <with list> <comma> <with list element>

<with list element> ::= <query name>                                               <AS> <left paren> <query expression> <right paren>
                      | <query name>                                               <AS> <left paren> <query expression> <right paren> <search or cycle clause>
                      | <query name> <left paren> <with column list> <right paren> <AS> <left paren> <query expression> <right paren>
                      | <query name> <left paren> <with column list> <right paren> <AS> <left paren> <query expression> <right paren> <search or cycle clause>

<with column list> ::= <column name list>

<query expression body> ::= <non_join query expression> | <joined table>

<non_join query expression> ::=
		<non_join query term>
	|	<query expression body> <UNION>                                  <query term>
	|	<query expression body> <UNION>             <corresponding spec> <query term>
	|	<query expression body> <UNION>  <ALL>                           <query term>
	|	<query expression body> <UNION>  <ALL>      <corresponding spec> <query term>
	|	<query expression body> <UNION>  <DISTINCT>                      <query term>
	|	<query expression body> <UNION>  <DISTINCT> <corresponding spec> <query term>
	|	<query expression body> <EXCEPT>                                 <query term>
	|	<query expression body> <EXCEPT>            <corresponding spec> <query term>
	|	<query expression body> <EXCEPT> <ALL>                           <query term>
	|	<query expression body> <EXCEPT> <ALL>      <corresponding spec> <query term>
	|	<query expression body> <EXCEPT> <DISTINCT>                      <query term>
	|	<query expression body> <EXCEPT> <DISTINCT> <corresponding spec> <query term>

<query term> ::= <non_join query term> | <joined table>

<non_join query term> ::=
		<non_join query primary>
	|	<query term> <INTERSECT>                                  <query primary>
	|	<query term> <INTERSECT>             <corresponding spec> <query primary>
	|	<query term> <INTERSECT>  <ALL>                           <query primary>
	|	<query term> <INTERSECT>  <ALL>      <corresponding spec> <query primary>
	|	<query term> <INTERSECT>  <DISTINCT>                      <query primary>
	|	<query term> <INTERSECT>  <DISTINCT> <corresponding spec> <query primary>

<query primary> ::= <non_join query primary> | <joined table>

<non_join query primary> ::= <simple table> | <left paren> <non_join query expression> <right paren>

<simple table> ::=
		<query specification>
	|	<table value constructor>
	|	<explicit table>

<explicit table> ::= <TABLE> <table or query name>

<corresponding spec> ::= <CORRESPONDING>
                       | <CORRESPONDING> <BY> <left paren> <corresponding column list> <right paren>

<corresponding column list> ::= <column name list>

<search or cycle clause> ::=
		<search clause>
	|	<cycle clause>
	|	<search clause> <cycle clause>

<search clause> ::= <SEARCH> <recursive search order> <SET> <sequence column>

<recursive search order> ::=
		<DEPTH> <FIRST> <BY> <sort specification list>
	|	<BREADTH> <FIRST> <BY> <sort specification list>

<sequence column> ::= <column name>

<cycle clause> ::=
		<CYCLE> <cycle column list>
		<SET> <cycle mark column> <TO> <cycle mark value>
		<DEFAULT> <non_cycle mark value>
		<USING> <path column>

<cycle column list> ::= <cycle column>
                      | <cycle column list> <comma> <cycle column>

<cycle column> ::= <column name>

<cycle mark column> ::= <column name>

<path column> ::= <column name>

<cycle mark value> ::= <value expression>

<non_cycle mark value> ::= <value expression>

<scalar subquery> ::= <subquery>

<row subquery> ::= <subquery>

<table subquery> ::= <subquery>

<subquery> ::= <left paren> <query expression> <right paren>

<predicate> ::=
		<comparison predicate>
	|	<between predicate>
	|	<in predicate>
	|	<like predicate>
	|	<similar predicate>
	|	<null predicate>
	|	<quantified comparison predicate>
	|	<exists predicate>
	|	<unique predicate>
	|	<normalized predicate>
	|	<match predicate>
	|	<overlaps predicate>
	|	<distinct predicate>
	|	<member predicate>
	|	<submultiset predicate>
	|	<set predicate>
	|	<type predicate>

<comparison predicate> ::= <row value predicand> <comparison predicate part 2>

<comparison predicate part 2> ::= <comp op> <row value predicand>

<comp op> ::=
		<equals operator>
	|	<not equals operator>
	|	<less than operator>
	|	<greater than operator>
	|	<less than or equals operator>
	|	<greater than or equals operator>

<between predicate> ::= <row value predicand> <between predicate part 2>

<between predicate part 2> ::=       <BETWEEN>              <row value predicand> <AND> <row value predicand>
                             |       <BETWEEN> <ASYMMETRIC> <row value predicand> <AND> <row value predicand>
                             |       <BETWEEN> <SYMMETRIC>  <row value predicand> <AND> <row value predicand>
                             | <NOT> <BETWEEN>              <row value predicand> <AND> <row value predicand>
                             | <NOT> <BETWEEN> <ASYMMETRIC> <row value predicand> <AND> <row value predicand>
                             | <NOT> <BETWEEN> <SYMMETRIC>  <row value predicand> <AND> <row value predicand>

<in predicate> ::= <row value predicand> <in predicate part 2> 

<in predicate part 2> ::= <IN> <in predicate value>
                        | <NOT> <IN> <in predicate value>

<in predicate value> ::=
		<table subquery>
	|	<left paren> <in value list> <right paren>

<in value list> ::= <row value expression>
                  | <in value list> <comma> <row value expression>

<like predicate> ::= <character like predicate> | <octet like predicate>

<character like predicate> ::= <row value predicand> <character like predicate part 2>

<character like predicate part 2> ::=       <LIKE> <character pattern>
                                    |       <LIKE> <character pattern> <ESCAPE> <escape character>
                                    | <NOT> <LIKE> <character pattern>
                                    | <NOT> <LIKE> <character pattern> <ESCAPE> <escape character>

<character pattern> ::= <character value expression>

<escape character> ::= <character value expression>

<octet like predicate> ::= <row value predicand> <octet like predicate part 2>

<octet like predicate part 2> ::=       <LIKE> <octet pattern>
                                |       <LIKE> <octet pattern> <ESCAPE> <escape octet>
                                | <NOT> <LIKE> <octet pattern>
                                | <NOT> <LIKE> <octet pattern> <ESCAPE> <escape octet>

<octet pattern> ::= <blob value expression>

<escape octet> ::= <blob value expression>

<similar predicate> ::= <row value predicand> <similar predicate part 2>

<similar predicate part 2> ::=       <SIMILAR> <TO> <similar pattern>
                             |       <SIMILAR> <TO> <similar pattern> <ESCAPE> <escape character>
                             | <NOT> <SIMILAR> <TO> <similar pattern>
                             | <NOT> <SIMILAR> <TO> <similar pattern> <ESCAPE> <escape character>

<similar pattern> ::= <regular expression>

<regular expression> ::=
		<regular term>
	|	<regular expression> <vertical bar> <regular term>

<regular term> ::=
		<regular factor>
	|	<regular term> <regular factor>

<regular factor> ::=
		<regular primary>
	|	<regular primary> <asterisk>
	|	<regular primary> <plus sign>
	|	<regular primary> <question mark>
	|	<regular primary> <repeat factor>

<repeat factor> ::= <left brace> <low value> <right brace>
                  | <left brace> <low value> <upper limit> <right brace>

<upper limit> ::= <comma>
                | <comma> <high value>

<low value> ::= <unsigned integer>

<high value> ::= <unsigned integer>

<regular primary> ::=
		<character specifier>
	|	<percent>
	|	<regular character set>
	|	<left paren> <regular expression> <right paren>

<character specifier> ::= <non_escaped character> | <escaped character>

#
# This is the only disgression to the grammar:even if the ESCAPE lexeme in the rhs is supported
# it is ignored, always defaulting to '\'. Why ESCAPE is specified after the affected other
# rules? To support this feature, this would require going back in the stream and apply the
# escaped character that is defined... after.
#

<non_escaped character> ~ [^\[\]\(\)\|\^\-\+\*_%\?\{\\]

<escaped character> ~ '\' [\[\]\(\)\|\^\-\+\*_%\?\{\\]

<character enumeration many> ::= <character enumeration>+

<character enumeration include many> ::= <character enumeration include>+

<character enumeration exclude many> ::= <character enumeration exclude>+

<regular character set> ::=
		<underscore>
	|	<left bracket> <character enumeration many> <right bracket>
	|	<left bracket> <circumflex> <character enumeration many> <right bracket>
	|	<left bracket> <character enumeration include many>  <circumflex> <character enumeration exclude many> <right bracket>

<character enumeration include> ::= <character enumeration>

<character enumeration exclude> ::= <character enumeration>

<character enumeration> ::=
		<character specifier>
	|	<character specifier> <minus sign> <character specifier>
	|	<left bracket> <colon> <regular character set identifier> <colon> <right bracket>

<regular character set identifier> ::= <identifier>

<null predicate> ::= <row value predicand> <null predicate part 2>

<null predicate part 2> ::= <IS> <NULL>
                          | <IS> <NOT> <NULL>

<quantified comparison predicate> ::= <row value predicand> <quantified comparison predicate part 2>

<quantified comparison predicate part 2> ::= <comp op> <quantifier> <table subquery>

<quantifier> ::= <all> | <some>

<all> ::= <ALL>

<some> ::= <SOME> | <ANY>

<exists predicate> ::= <EXISTS> <table subquery>

<unique predicate> ::= <UNIQUE> <table subquery>

<normalized predicate> ::= <string value expression> <IS> <NORMALIZED>
                         | <string value expression> <IS> <NOT> <NORMALIZED>

<match predicate> ::= <row value predicand> <match predicate part 2>

<match predicate part 2> ::= <MATCH>                    <table subquery>
                           | <MATCH>          <SIMPLE>  <table subquery>
                           | <MATCH>          <PARTIAL> <table subquery>
                           | <MATCH>          <FULL>    <table subquery>
                           | <MATCH> <UNIQUE>           <table subquery>
                           | <MATCH> <UNIQUE> <SIMPLE>  <table subquery>
                           | <MATCH> <UNIQUE> <PARTIAL> <table subquery>
                           | <MATCH> <UNIQUE> <FULL>    <table subquery>

<overlaps predicate> ::= <overlaps predicate part 1> <overlaps predicate part 2>

<overlaps predicate part 1> ::= <row value predicand 1>

<overlaps predicate part 2> ::= <OVERLAPS> <row value predicand 2>

<row value predicand 1> ::= <row value predicand>

<row value predicand 2> ::= <row value predicand>

<distinct predicate> ::= <row value predicand 3> <distinct predicate part 2>

<distinct predicate part 2> ::= <IS> <DISTINCT> <FROM> <row value predicand 4>

<row value predicand 3> ::= <row value predicand>

<row value predicand 4> ::= <row value predicand>

<member predicate> ::= <row value predicand> <member predicate part 2>

<member predicate part 2> ::=       <MEMBER>      <multiset value expression>
                            |       <MEMBER> <OF> <multiset value expression>
                            | <NOT> <MEMBER>      <multiset value expression>
                            | <NOT> <MEMBER> <OF> <multiset value expression>

<submultiset predicate> ::= <row value predicand> <submultiset predicate part 2>

<submultiset predicate part 2> ::=       <SUBMULTISET>      <multiset value expression>
                                 |       <SUBMULTISET> <OF> <multiset value expression>
                                 | <NOT> <SUBMULTISET>      <multiset value expression>
                                 | <NOT> <SUBMULTISET> <OF> <multiset value expression>

<set predicate> ::= <row value predicand> <set predicate part 2>

<set predicate part 2> ::= <IS>       <A> <SET>
                         | <IS> <NOT> <A> <SET>

<type predicate> ::= <row value predicand> <type predicate part 2>

<type predicate part 2> ::= <IS>       <OF> <left paren> <type list> <right paren>
                          | <IS> <NOT> <OF> <left paren> <type list> <right paren>

<type list> ::= <user_defined type specification>
              | <type list> <comma> <user_defined type specification>

<user_defined type specification> ::=
		<inclusive user_defined type specification>
	|	<exclusive user_defined type specification>

<inclusive user_defined type specification> ::= <path_resolved user_defined type name>

<exclusive user_defined type specification> ::= <ONLY> <path_resolved user_defined type name>

<search condition> ::= <boolean value expression>

<interval qualifier> ::=
		<start field> <TO> <end field>
	|	<single datetime field>

<start field> ::= <non_second primary datetime field>
                | <non_second primary datetime field> <left paren> <interval leading field precision> <right paren>

<end field> ::=
		<non_second primary datetime field>
	|	<SECOND>
	|	<SECOND> <left paren> <interval fractional seconds precision> <right paren>

<single datetime field> ::=
		<non_second primary datetime field>
	|	<non_second primary datetime field> <left paren> <interval leading field precision> <right paren>
	|	<SECOND>
	|	<SECOND> <left paren> <interval leading field precision> <right paren>
	|	<SECOND> <left paren> <interval leading field precision> <comma> <interval fractional seconds precision> <right paren>

<primary datetime field> ::=
		<non_second primary datetime field>
	|	<SECOND>

<non_second primary datetime field> ::= <YEAR> | <MONTH> | <DAY> | <HOUR> | <MINUTE>

<interval fractional seconds precision> ::= <unsigned integer>

<interval leading field precision> ::= <unsigned integer>

<language clause> ::= <LANGUAGE> <language name>

<language name> ::= <C> | <SQL>

<path specification> ::= <PATH> <schema name list>

<schema name list> ::= <schema name>
                     | <schema name list> <comma> <schema name>

<routine invocation> ::= <routine name> <SQL argument list>

<routine name> ::= <qualified identifier>
                 | <schema name> <period> <qualified identifier>

<SQL arguments> ::= <SQL argument>
                  | <SQL arguments> <comma> <SQL argument>

<SQL argument list> ::= <left paren> <right paren>
                      | <left paren> <SQL arguments> <right paren>

<SQL argument> ::=
		<value expression>
	|	<generalized expression>
	|	<target specification>

<generalized expression> ::= <value expression> <AS> <path_resolved user_defined type name>

<character set specification> ::=
		<standard character set name>
	|	<implementation_defined character set name>
	|	<user_defined character set name>

<standard character set name> ::= <character set name>

<implementation_defined character set name> ::= <character set name>

<user_defined character set name> ::= <character set name>

<specific routine designator> ::=
		<SPECIFIC> <routine type> <specific name>
	|	<routine type> <member name>
	|	<routine type> <member name> <FOR> <schema_resolved user_defined type name>

<routine type> ::=
		<ROUTINE>
	|	<FUNCTION>
	|	<PROCEDURE>
	|	<METHOD>
	|	<INSTANCE> <METHOD>
	|	<STATIC> <METHOD>
	|	<CONSTRUCTOR> <METHOD>

<member name> ::= <member name alternatives>
                | <member name alternatives> <data type list>

<member name alternatives> ::= <schema qualified routine name> | <method name>

<data types> ::= <data type>
               | <data types> <comma> <data type>

<data type list> ::= <left paren> <right paren>
                   | <left paren> <data types> <right paren>

<collate clause> ::= <COLLATE> <collation name>

<constraint name definition> ::= <CONSTRAINT> <constraint name>

<constraint characteristics> ::=
		<constraint check time>
	|	<constraint check time>       <DEFERRABLE>
	|	<constraint check time> <NOT> <DEFERRABLE>
	|	      <DEFERRABLE>
	|	      <DEFERRABLE> <constraint check time>
	|	<NOT> <DEFERRABLE>
	|	<NOT> <DEFERRABLE> <constraint check time>

<constraint check time> ::= <INITIALLY> <DEFERRED> | <INITIALLY> <IMMEDIATE>

<aggregate function> ::=
		<COUNT> <left paren> <asterisk> <right paren>
	|	<COUNT> <left paren> <asterisk> <right paren> <filter clause>
	|	<general set function>
	|	<general set function> <filter clause>
	|	<binary set function>
	|	<binary set function> <filter clause>
	|	<ordered set function>
	|	<ordered set function> <filter clause>

<general set function> ::= <set function type> <left paren> <value expression> <right paren>
                         | <set function type> <left paren> <set quantifier> <value expression> <right paren>

<set function type> ::= <computational operation>

<computational operation> ::=
		<AVG> | <MAX> | <MIN> | <SUM>
	|	<EVERY> | <ANY> | <SOME>
	|	<COUNT>
	|	<STDDEV_POP> | <STDDEV_SAMP> | <VAR_SAMP> | <VAR_POP>
	|	<COLLECT> | <FUSION> | <INTERSECTION>

<set quantifier> ::= <DISTINCT> | <ALL>

<filter clause> ::= <FILTER> <left paren> <WHERE> <search condition> <right paren>

<binary set function> ::= <binary set function type> <left paren> <dependent variable expression> <comma> <independent variable expression> <right paren>

<binary set function type> ::=
		<COVAR_POP> | <COVAR_SAMP> | <CORR> | <REGR_SLOPE>
	|	<REGR_INTERCEPT> | <REGR_COUNT> | <REGR_R2> | <REGR_AVGX> | <REGR_AVGY>
	|	<REGR_SXX> | <REGR_SYY> | <REGR_SXY>

<dependent variable expression> ::= <numeric value expression>

<independent variable expression> ::= <numeric value expression>

<ordered set function> ::= <hypothetical set function> | <inverse distribution function>

<hypothetical set function> ::= <rank function type> <left paren> <hypothetical set function value expression list> <right paren> <within group specification>

<within group specification> ::= <WITHIN> <GROUP> <left paren> <ORDER> <BY> <sort specification list> <right paren>

<hypothetical set function value expression list> ::= <value expression>
                                                    | <hypothetical set function value expression list> <comma> <value expression>

<inverse distribution function> ::= <inverse distribution function type> <left paren> <inverse distribution function argument> <right paren> <within group specification>

<inverse distribution function argument> ::= <numeric value expression>

<inverse distribution function type> ::= <PERCENTILE_CONT> | <PERCENTILE_DISC>

<sort specification list> ::= <sort specification>
                            | <sort specification list> <comma> <sort specification>

<sort specification> ::= <sort key>
                       | <sort key> <ordering specification>
                       | <sort key> <ordering specification> <null ordering>
                       | <sort key> <null ordering>

<sort key> ::= <value expression>

<ordering specification> ::= <ASC> | <DESC>

<null ordering> ::= <NULLS> <FIRST> | <NULLS> <LAST>

<schema elements> ::= <schema element>+

<schema definition> ::= <CREATE> <SCHEMA> <schema name clause>
                      | <CREATE> <SCHEMA> <schema name clause> <schema character set or path>
                      | <CREATE> <SCHEMA> <schema name clause> <schema character set or path> <schema elements>
                      | <CREATE> <SCHEMA> <schema name clause> <schema elements>

<schema character set or path> ::=
		<schema character set specification>
	|	<schema path specification>
	|	<schema character set specification> <schema path specification>
	|	<schema path specification> <schema character set specification>

<schema name clause> ::=
		<schema name>
	|	<AUTHORIZATION> <schema authorization identifier>
	|	<schema name> <AUTHORIZATION> <schema authorization identifier>

<schema authorization identifier> ::= <authorization identifier>

<schema character set specification> ::= <DEFAULT> <CHARACTER> <SET> <character set specification>

<schema path specification> ::= <path specification>

<schema element> ::=
		<table definition>
	|	<view definition>
	|	<domain definition>
	|	<character set definition>
	|	<collation definition>
	|	<transliteration definition>
	|	<assertion definition>
	|	<trigger definition>
	|	<user_defined type definition>
	|	<user_defined cast definition>
	|	<user_defined ordering definition>
	|	<transform definition>
	|	<schema routine>
	|	<sequence generator definition>
	|	<grant statement>
	|	<role definition>

<drop schema statement> ::= <DROP> <SCHEMA> <schema name> <drop behavior>

<drop behavior> ::= <CASCADE> | <RESTRICT>

<table definition> ::=
		<CREATE>               <TABLE> <table name> <table contents source>
	|	<CREATE>               <TABLE> <table name> <table contents source> <ON> <COMMIT> <table commit action> <ROWS>
	|	<CREATE> <table scope> <TABLE> <table name> <table contents source>
	|	<CREATE> <table scope> <TABLE> <table name> <table contents source> <ON> <COMMIT> <table commit action> <ROWS>

<table contents source> ::=
		<table element list>
	|	<OF> <path_resolved user_defined type name>
	|	<OF> <path_resolved user_defined type name> <subtable clause>
	|	<OF> <path_resolved user_defined type name> <subtable clause> <table element list>
	|	<OF> <path_resolved user_defined type name> <table element list>
	|	<as subquery clause>

<table scope> ::= <global or local> <TEMPORARY>

<global or local> ::= <GLOBAL> | <LOCAL>

<table commit action> ::= <PRESERVE> | <DELETE>

<table elements> ::= <table element>
                   | <table elements> <comma> <table element>

<table element list> ::= <left paren> <table elements> <right paren>

<table element> ::=
		<column definition>
	|	<table constraint definition>
	|	<like clause>
	|	<self_referencing column specification>
	|	<column options>

<self_referencing column specification> ::= <REF> <IS> <self_referencing column name> <reference generation>

<reference generation> ::= <SYSTEM> <GENERATED> | <USER> <GENERATED> | <DERIVED>

<self_referencing column name> ::= <column name>

#
# Little deviation: <column option list> is made non-empty
#
<column options> ::= <column name> <WITH> <OPTIONS>
                   | <column name> <WITH> <OPTIONS> <column option list>

<column constraint definitions> ::= <column constraint definition>+

<column option list> ::=
	  <scope clause>
	| <scope clause> <default clause>
	| <scope clause> <default clause> <column constraint definitions>
	| <scope clause> <column constraint definitions>
	| <default clause>
	| <default clause> <column constraint definitions>
	| <column constraint definitions>


<subtable clause> ::= <UNDER> <supertable clause>

<supertable clause> ::= <supertable name>

<supertable name> ::= <table name>

<like clause> ::= <LIKE> <table name>
                | <LIKE> <table name> <like options>

<like options> ::= <identity option> | <column default option>

<identity option> ::= <INCLUDING> <IDENTITY> | <EXCLUDING> <IDENTITY>

<column default option> ::= <INCLUDING> <DEFAULTS> | <EXCLUDING> <DEFAULTS>

<as subquery clause> ::= <AS> <subquery> <with or without data>
                       | <left paren> <column name list> <right paren> <AS> <subquery> <with or without data>

<with or without data> ::= <WITH> <NO> <DATA> | <WITH> <DATA>

<column definition> ::=
	  <column name> <data type>
	| <column name> <data type> <reference scope check>
	| <column name> <data type> <reference scope check> <default clause>
	| <column name> <data type> <reference scope check> <default clause> <column constraint definitions>
	| <column name> <data type> <reference scope check> <default clause> <column constraint definitions> <collate clause>
	| <column name> <data type> <reference scope check> <default clause> <collate clause>
	| <column name> <data type> <reference scope check> <identity column specification>
	| <column name> <data type> <reference scope check> <identity column specification> <column constraint definitions>
	| <column name> <data type> <reference scope check> <identity column specification> <column constraint definitions> <collate clause>
	| <column name> <data type> <reference scope check> <identity column specification> <collate clause>
	| <column name> <data type> <reference scope check> <generation clause>
	| <column name> <data type> <reference scope check> <generation clause> <column constraint definitions>
	| <column name> <data type> <reference scope check> <generation clause> <column constraint definitions> <collate clause>
	| <column name> <data type> <reference scope check> <generation clause> <collate clause>
	| <column name> <data type> <reference scope check> <column constraint definitions>
	| <column name> <data type> <reference scope check> <column constraint definitions> <collate clause>
	| <column name> <data type> <reference scope check> <collate clause>
	| <column name> <data type> <default clause>
	| <column name> <data type> <default clause> <column constraint definitions>
	| <column name> <data type> <default clause> <column constraint definitions> <collate clause>
	| <column name> <data type> <default clause> <collate clause>
	| <column name> <data type> <identity column specification>
	| <column name> <data type> <identity column specification> <column constraint definitions>
	| <column name> <data type> <identity column specification> <column constraint definitions> <collate clause>
	| <column name> <data type> <identity column specification> <collate clause>
	| <column name> <data type> <generation clause>
	| <column name> <data type> <generation clause> <column constraint definitions>
	| <column name> <data type> <generation clause> <column constraint definitions> <collate clause>
	| <column name> <data type> <generation clause> <collate clause>
	| <column name> <data type> <column constraint definitions>
	| <column name> <data type> <column constraint definitions> <collate clause>
	| <column name> <data type> <collate clause>
	| <column name> <domain name>
	| <column name> <domain name> <reference scope check>
	| <column name> <domain name> <reference scope check> <default clause>
	| <column name> <domain name> <reference scope check> <default clause> <column constraint definitions>
	| <column name> <domain name> <reference scope check> <default clause> <column constraint definitions> <collate clause>
	| <column name> <domain name> <reference scope check> <default clause> <collate clause>
	| <column name> <domain name> <reference scope check> <identity column specification>
	| <column name> <domain name> <reference scope check> <identity column specification> <column constraint definitions>
	| <column name> <domain name> <reference scope check> <identity column specification> <column constraint definitions> <collate clause>
	| <column name> <domain name> <reference scope check> <identity column specification> <collate clause>
	| <column name> <domain name> <reference scope check> <generation clause>
	| <column name> <domain name> <reference scope check> <generation clause> <column constraint definitions>
	| <column name> <domain name> <reference scope check> <generation clause> <column constraint definitions> <collate clause>
	| <column name> <domain name> <reference scope check> <generation clause> <collate clause>
	| <column name> <domain name> <reference scope check> <column constraint definitions>
	| <column name> <domain name> <reference scope check> <column constraint definitions> <collate clause>
	| <column name> <domain name> <reference scope check> <collate clause>
	| <column name> <domain name> <default clause>
	| <column name> <domain name> <default clause> <column constraint definitions>
	| <column name> <domain name> <default clause> <column constraint definitions> <collate clause>
	| <column name> <domain name> <default clause> <collate clause>
	| <column name> <domain name> <identity column specification>
	| <column name> <domain name> <identity column specification> <column constraint definitions>
	| <column name> <domain name> <identity column specification> <column constraint definitions> <collate clause>
	| <column name> <domain name> <identity column specification> <collate clause>
	| <column name> <domain name> <generation clause>
	| <column name> <domain name> <generation clause> <column constraint definitions>
	| <column name> <domain name> <generation clause> <column constraint definitions> <collate clause>
	| <column name> <domain name> <generation clause> <collate clause>
	| <column name> <domain name> <column constraint definitions>
	| <column name> <domain name> <column constraint definitions> <collate clause>
	| <column name> <domain name> <collate clause>
	| <column name> <reference scope check>
	| <column name> <reference scope check> <default clause>
	| <column name> <reference scope check> <default clause> <column constraint definitions>
	| <column name> <reference scope check> <default clause> <column constraint definitions> <collate clause>
	| <column name> <reference scope check> <default clause> <collate clause>
	| <column name> <reference scope check> <identity column specification>
	| <column name> <reference scope check> <identity column specification> <column constraint definitions>
	| <column name> <reference scope check> <identity column specification> <column constraint definitions> <collate clause>
	| <column name> <reference scope check> <identity column specification> <collate clause>
	| <column name> <reference scope check> <generation clause>
	| <column name> <reference scope check> <generation clause> <column constraint definitions>
	| <column name> <reference scope check> <generation clause> <column constraint definitions> <collate clause>
	| <column name> <reference scope check> <generation clause> <collate clause>
	| <column name> <reference scope check> <column constraint definitions>
	| <column name> <reference scope check> <column constraint definitions> <collate clause>
	| <column name> <reference scope check> <collate clause>
	| <column name> <default clause>
	| <column name> <default clause> <column constraint definitions>
	| <column name> <default clause> <column constraint definitions> <collate clause>
	| <column name> <default clause> <collate clause>
	| <column name> <identity column specification>
	| <column name> <identity column specification> <column constraint definitions>
	| <column name> <identity column specification> <column constraint definitions> <collate clause>
	| <column name> <identity column specification> <collate clause>
	| <column name> <generation clause>
	| <column name> <generation clause> <column constraint definitions>
	| <column name> <generation clause> <column constraint definitions> <collate clause>
	| <column name> <generation clause> <collate clause>
	| <column name> <column constraint definitions>
	| <column name> <column constraint definitions> <collate clause>
	| <column name> <collate clause>

<column constraint definition> ::=                              <column constraint>
                                 |                              <column constraint> <constraint characteristics>
                                 | <constraint name definition> <column constraint>
                                 | <constraint name definition> <column constraint> <constraint characteristics>

<column constraint> ::=
		<NOT> <NULL>
	|	<unique specification>
	|	<references specification>
	|	<check constraint definition>

<reference scope check> ::= <REFERENCES> <ARE>       <CHECKED>
                          | <REFERENCES> <ARE>       <CHECKED> <ON> <DELETE> <reference scope check action>
                          | <REFERENCES> <ARE> <NOT> <CHECKED>
                          | <REFERENCES> <ARE> <NOT> <CHECKED> <ON> <DELETE> <reference scope check action>

<reference scope check action> ::= <referential action>

<identity column specification> ::= <GENERATED> <ALWAYS>       <AS> <IDENTITY>
                                  | <GENERATED> <ALWAYS>       <AS> <IDENTITY> <left paren> <common sequence generator options> <right paren>
                                  | <GENERATED> <BY> <DEFAULT> <AS> <IDENTITY>
                                  | <GENERATED> <BY> <DEFAULT> <AS> <IDENTITY> <left paren> <common sequence generator options> <right paren>

<generation clause> ::= <generation rule> <AS> <generation expression>

<generation rule> ::= <GENERATED> <ALWAYS>

<generation expression> ::= <left paren> <value expression> <right paren>

<default clause> ::= <DEFAULT> <default option>

<default option> ::=
		<literal>
	|	<datetime value function>
	|	<USER>
	|	<CURRENT_USER>
	|	<CURRENT_ROLE>
	|	<SESSION_USER>
	|	<SYSTEM_USER>
	|	<CURRENT_PATH>
	|	<implicitly typed value specification>

<table constraint definition> ::=                              <table constraint>
                                |                              <table constraint> <constraint characteristics>
                                | <constraint name definition> <table constraint>
                                | <constraint name definition> <table constraint> <constraint characteristics>

<table constraint> ::=
		<unique constraint definition>
	|	<referential constraint definition>
	|	<check constraint definition>

<unique constraint definition> ::=
		<unique specification> <left paren> <unique column list> <right paren>
	|	<UNIQUE> '(' 'VALUE' ')'

<unique specification> ::= <UNIQUE> | <PRIMARY> <KEY>

<unique column list> ::= <column name list>

<referential constraint definition> ::= <FOREIGN> <KEY> <left paren> <referencing columns> <right paren> <references specification>

<references specification> ::= <REFERENCES> <referenced table and columns>
                             | <REFERENCES> <referenced table and columns> <MATCH> <match type>
                             | <REFERENCES> <referenced table and columns> <MATCH> <match type> <referential triggered action>
                             | <REFERENCES> <referenced table and columns> <referential triggered action>

<match type> ::= <FULL> | <PARTIAL> | <SIMPLE>

<referencing columns> ::= <reference column list>

<referenced table and columns> ::= <table name>
                                 | <table name> <left paren> <reference column list> <right paren>

<reference column list> ::= <column name list>

<referential triggered action> ::= <update rule>
                                 | <update rule> <delete rule>
                                 | <delete rule>
                                 | <delete rule> <update rule>

<update rule> ::= <ON> <UPDATE> <referential action>

<delete rule> ::= <ON> <DELETE> <referential action>

<referential action> ::= <CASCADE> | <SET> <NULL> | <SET> <DEFAULT> | <RESTRICT> | <NO> <ACTION>

<check constraint definition> ::= <CHECK> <left paren> <search condition> <right paren>

<alter table statement> ::= <ALTER> <TABLE> <table name> <alter table action>

<alter table action> ::=
		<add column definition>
	|	<alter column definition>
	|	<drop column definition>
	|	<add table constraint definition>
	|	<drop table constraint definition>

<add column definition> ::= <ADD>          <column definition>
                          | <ADD> <COLUMN> <column definition>

<alter column definition> ::= <ALTER>          <column name> <alter column action>
                            | <ALTER> <COLUMN> <column name> <alter column action>

<alter column action> ::=
		<set column default clause>
	|	<drop column default clause>
	|	<add column scope clause>
	|	<drop column scope clause>
	|	<alter identity column specification>

<set column default clause> ::= <SET> <default clause>

<drop column default clause> ::= <DROP> <DEFAULT>

<add column scope clause> ::= <ADD> <scope clause>

<drop column scope clause> ::= <DROP> <SCOPE> <drop behavior>

<alter identity column specification> ::= <alter identity column option>+

<alter identity column option> ::=
		<alter sequence generator restart option>
	|	<SET> <basic sequence generator option>

<drop column definition> ::= <DROP>          <column name> <drop behavior>
                           | <DROP> <COLUMN> <column name> <drop behavior>

<add table constraint definition> ::= <ADD> <table constraint definition>

<drop table constraint definition> ::= <DROP> <CONSTRAINT> <constraint name> <drop behavior>

<drop table statement> ::= <DROP> <TABLE> <table name> <drop behavior>

<view definition> ::= <CREATE>             <VIEW> <table name> <view specification> <AS> <query expression>
                    | <CREATE>             <VIEW> <table name> <view specification> <AS> <query expression> <WITH>                 <CHECK> <OPTION>
                    | <CREATE>             <VIEW> <table name> <view specification> <AS> <query expression> <WITH> <levels clause> <CHECK> <OPTION>
                    | <CREATE> <RECURSIVE> <VIEW> <table name> <view specification> <AS> <query expression>
                    | <CREATE> <RECURSIVE> <VIEW> <table name> <view specification> <AS> <query expression> <WITH>                 <CHECK> <OPTION>
                    | <CREATE> <RECURSIVE> <VIEW> <table name> <view specification> <AS> <query expression> <WITH> <levels clause> <CHECK> <OPTION>

<view specification> ::= <regular view specification> | <referenceable view specification>

<regular view specification> ::= <left paren> <view column list> <right paren>
<regular view specification> ::=

<referenceable view specification> ::= <OF> <path_resolved user_defined type name>
                                     | <OF> <path_resolved user_defined type name> <subview clause>
                                     | <OF> <path_resolved user_defined type name> <subview clause> <view element list>
                                     | <OF> <path_resolved user_defined type name> <view element list>

<subview clause> ::= <UNDER> <table name>

<view elements> ::= <view element>
                  | <view elements> <comma> <view element>

<view element list> ::= <left paren> <view elements> <right paren>

<view element> ::= <self_referencing column specification> | <view column option>

<view column option> ::= <column name> <WITH> <OPTIONS> <scope clause>

<levels clause> ::= <CASCADED> | <LOCAL>

<view column list> ::= <column name list>

<drop view statement> ::= <DROP> <VIEW> <table name> <drop behavior>

<domain constraints> ::= <domain constraint>+

<domain definition> ::=
          <CREATE> <DOMAIN> <domain name>      <data type>
	| <CREATE> <DOMAIN> <domain name>      <data type> <default clause>
	| <CREATE> <DOMAIN> <domain name>      <data type> <default clause> <domain constraints>
	| <CREATE> <DOMAIN> <domain name>      <data type> <default clause> <domain constraints> <collate clause>
	| <CREATE> <DOMAIN> <domain name>      <data type> <default clause> <collate clause>
	| <CREATE> <DOMAIN> <domain name>      <data type> <domain constraints>
	| <CREATE> <DOMAIN> <domain name>      <data type> <domain constraints> <collate clause>
	| <CREATE> <DOMAIN> <domain name>      <data type> <collate clause>
        | <CREATE> <DOMAIN> <domain name> <AS> <data type>
	| <CREATE> <DOMAIN> <domain name> <AS> <data type> <default clause>
	| <CREATE> <DOMAIN> <domain name> <AS> <data type> <default clause> <domain constraints>
	| <CREATE> <DOMAIN> <domain name> <AS> <data type> <default clause> <domain constraints> <collate clause>
	| <CREATE> <DOMAIN> <domain name> <AS> <data type> <default clause> <collate clause>
	| <CREATE> <DOMAIN> <domain name> <AS> <data type> <domain constraints>
	| <CREATE> <DOMAIN> <domain name> <AS> <data type> <domain constraints> <collate clause>
	| <CREATE> <DOMAIN> <domain name> <AS> <data type> <collate clause>

<domain constraint> ::=                              <check constraint definition>
                      |                              <check constraint definition> <constraint characteristics>
                      | <constraint name definition> <check constraint definition>
                      | <constraint name definition> <check constraint definition> <constraint characteristics>

<alter domain statement> ::= <ALTER> <DOMAIN> <domain name> <alter domain action>

<alter domain action> ::=
		<set domain default clause>
	|	<drop domain default clause>
	|	<add domain constraint definition>
	|	<drop domain constraint definition>

<set domain default clause> ::= <SET> <default clause>

<drop domain default clause> ::= <DROP> <DEFAULT>

<add domain constraint definition> ::= <ADD> <domain constraint>

<drop domain constraint definition> ::= <DROP> <CONSTRAINT> <constraint name>

<drop domain statement> ::= <DROP> <DOMAIN> <domain name> <drop behavior>

<character set definition> ::= <CREATE> <CHARACTER> <SET> <character set name>      <character set source>
                             | <CREATE> <CHARACTER> <SET> <character set name>      <character set source> <collate clause>
                             | <CREATE> <CHARACTER> <SET> <character set name> <AS> <character set source>
                             | <CREATE> <CHARACTER> <SET> <character set name> <AS> <character set source> <collate clause>

<character set source> ::= <GET> <character set specification>

<drop character set statement> ::= <DROP> <CHARACTER> <SET> <character set name>

<collation definition> ::= <CREATE> <COLLATION> <collation name> <FOR> <character set specification> <FROM> <existing collation name>
                         | <CREATE> <COLLATION> <collation name> <FOR> <character set specification> <FROM> <existing collation name> <pad characteristic>

<existing collation name> ::= <collation name>

<pad characteristic> ::= <NO> <PAD> | <PAD> <SPACE>

<drop collation statement> ::= <DROP> <COLLATION> <collation name> <drop behavior>

<transliteration definition> ::= <CREATE> <TRANSLATION> <transliteration name> <FOR> <source character set specification> <TO> <target character set specification> <FROM> <transliteration source>

<source character set specification> ::= <character set specification>

<target character set specification> ::= <character set specification>

<transliteration source> ::= <existing transliteration name> | <transliteration routine>

<existing transliteration name> ::= <transliteration name>

<transliteration routine> ::= <specific routine designator>

<drop transliteration statement> ::= <DROP> <TRANSLATION> <transliteration name>

<assertion definition> ::= <CREATE> <ASSERTION> <constraint name> <CHECK> <left paren> <search condition> <right paren>
                         | <CREATE> <ASSERTION> <constraint name> <CHECK> <left paren> <search condition> <right paren> <constraint characteristics>

<drop assertion statement> ::= <DROP> <ASSERTION> <constraint name>

<trigger definition> ::= <CREATE> <TRIGGER> <trigger name> <trigger action time> <trigger event> <ON> <table name>                                              <triggered action>
                       | <CREATE> <TRIGGER> <trigger name> <trigger action time> <trigger event> <ON> <table name> <REFERENCING> <old or new values alias list> <triggered action>

<trigger action time> ::= <BEFORE> | <AFTER>

<trigger event> ::= <INSERT>
                  | <DELETE>
                  | <UPDATE>
                  | <UPDATE> <OF> <trigger column list>

<trigger column list> ::= <column name list>

<triggered action> ::= <triggered SQL statement>
                     | <FOR> <EACH> <ROW>                                                            <triggered SQL statement>
                     | <FOR> <EACH> <STATEMENT>                                                      <triggered SQL statement>
                     | <FOR> <EACH> <ROW>       <WHEN> <left paren> <search condition> <right paren> <triggered SQL statement>
                     | <FOR> <EACH> <STATEMENT> <WHEN> <left paren> <search condition> <right paren> <triggered SQL statement>
                     |                          <WHEN> <left paren> <search condition> <right paren> <triggered SQL statement>

<SQL procedure statement AND semicolon> ::= <SQL procedure statement> <semicolon>

<SQL procedure statement AND semicolon many> ::= <SQL procedure statement AND semicolon>+

<triggered SQL statement> ::=
		<SQL procedure statement>
	|	<BEGIN> <ATOMIC> <SQL procedure statement AND semicolon many> <END>

<old or new values alias list> ::= <old or new values alias>+

<old or new values alias> ::=
		<OLD>              <old values correlation name>
	|	<OLD> <ROW>        <old values correlation name>
	|	<OLD> <ROW> <AS>   <old values correlation name>
	|	<OLD> <AS>         <old values correlation name>
	|	<NEW>              <new values correlation name>
	|	<NEW> <ROW>        <new values correlation name>
	|	<NEW> <ROW> <AS>   <new values correlation name>
	|	<NEW> <AS>         <new values correlation name>
	|	<OLD> <TABLE>      <old values table alias>
	|	<OLD> <TABLE> <AS> <old values table alias>
	|	<NEW> <TABLE>      <new values table alias>
	|	<NEW> <TABLE> <AS> <new values table alias>

<old values table alias> ::= <identifier>

<new values table alias> ::= <identifier>

<old values correlation name> ::= <correlation name>

<new values correlation name> ::= <correlation name>

<drop trigger statement> ::= <DROP> <TRIGGER> <trigger name>

<user_defined type definition> ::= <CREATE> <TYPE> <user_defined type body>

<user_defined type body> ::=
	  <schema_resolved user_defined type name>
	| <schema_resolved user_defined type name> <subtype clause>
	| <schema_resolved user_defined type name> <subtype clause> <AS> <representation>
	| <schema_resolved user_defined type name> <subtype clause> <AS> <representation> <user_defined type option list>
	| <schema_resolved user_defined type name> <subtype clause> <AS> <representation> <user_defined type option list> <method specification list>
	| <schema_resolved user_defined type name> <subtype clause> <AS> <representation> <method specification list>
	| <schema_resolved user_defined type name> <subtype clause> <user_defined type option list>
	| <schema_resolved user_defined type name> <subtype clause> <user_defined type option list> <method specification list>
	| <schema_resolved user_defined type name> <subtype clause> <method specification list>
	| <schema_resolved user_defined type name> <AS> <representation>
	| <schema_resolved user_defined type name> <AS> <representation> <user_defined type option list>
	| <schema_resolved user_defined type name> <AS> <representation> <user_defined type option list> <method specification list>
	| <schema_resolved user_defined type name> <AS> <representation> <method specification list>
	| <schema_resolved user_defined type name> <user_defined type option list>
	| <schema_resolved user_defined type name> <user_defined type option list> <method specification list>
	| <schema_resolved user_defined type name> <method specification list>

<user_defined type option list> ::= <user_defined type option>+

<user_defined type option> ::=
		<instantiable clause>
	|	<finality>
	|	<reference type specification>
	|	<ref cast option>
	|	<cast option>

<subtype clause> ::= <UNDER> <supertype name>

<supertype name> ::= <path_resolved user_defined type name>

<representation> ::= <predefined type> | <member list>

<members> ::= <member>
            | <members> <comma> <member>

<member list> ::= <left paren> <members> <right paren>

<member> ::= <attribute definition>

<instantiable clause> ::= <INSTANTIABLE> | <NOT> <INSTANTIABLE>

<finality> ::= <FINAL> | <NOT> <FINAL>

<reference type specification> ::=
		<user_defined representation>
	|	<derived representation>
	|	<system_generated representation>

<user_defined representation> ::= <REF> <USING> <predefined type>

<derived representation> ::= <REF> <FROM> <list of attributes>

<system_generated representation> ::= <REF> <IS> <SYSTEM> <GENERATED>

<ref cast option> ::=
	  <cast to ref>
	| <cast to ref> <cast to type>
	| <cast to type>

<cast to ref> ::= <CAST> <left paren> <SOURCE> <AS> <REF> <right paren> <WITH> <cast to ref identifier>

<cast to ref identifier> ::= <identifier>

<cast to type> ::= <CAST> <left paren> <REF> <AS> <SOURCE> <right paren> <WITH> <cast to type identifier>

<cast to type identifier> ::= <identifier>

<attribute names> ::= <attribute name>
                    | <attribute names> <comma> <attribute name>

<list of attributes> ::= <left paren> <attribute names> <right paren>

<cast option> ::=
	  <cast to distinct>
	| <cast to distinct> <cast to source>
	| <cast to source>

<cast to distinct> ::= <CAST> <left paren> <SOURCE> <AS> <DISTINCT> <right paren> <WITH> <cast to distinct identifier>

<cast to distinct identifier> ::= <identifier>

<cast to source> ::= <CAST> <left paren> <DISTINCT> <AS> <SOURCE> <right paren> <WITH> <cast to source identifier>

<cast to source identifier> ::= <identifier>

<method specification list> ::= <method specification>
                              | <method specification list> <comma> <method specification>

<method specification> ::= <original method specification> | <overriding method specification>

<original method specification> ::=
	  <partial method specification> <SELF> <AS> <RESULT>
	| <partial method specification> <SELF> <AS> <RESULT> <SELF> <AS> <LOCATOR>
	| <partial method specification> <SELF> <AS> <RESULT> <SELF> <AS> <LOCATOR> <method characteristics>
	| <partial method specification> <SELF> <AS> <RESULT> <method characteristics>
	| <partial method specification> <SELF> <AS> <LOCATOR>
	| <partial method specification> <SELF> <AS> <LOCATOR> <method characteristics>
	| <partial method specification> <method characteristics>

<overriding method specification> ::= <OVERRIDING> <partial method specification>

<partial method specification> ::=               <METHOD> <method name> <SQL parameter declaration list> <returns clause>
                                 |               <METHOD> <method name> <SQL parameter declaration list> <returns clause> <SPECIFIC> <specific method name>
                                 | <INSTANCE>    <METHOD> <method name> <SQL parameter declaration list> <returns clause>
                                 | <STATIC>      <METHOD> <method name> <SQL parameter declaration list> <returns clause>
                                 | <CONSTRUCTOR> <METHOD> <method name> <SQL parameter declaration list> <returns clause>
                                 | <INSTANCE>    <METHOD> <method name> <SQL parameter declaration list> <returns clause> <SPECIFIC> <specific method name>
                                 | <STATIC>      <METHOD> <method name> <SQL parameter declaration list> <returns clause> <SPECIFIC> <specific method name>
                                 | <CONSTRUCTOR> <METHOD> <method name> <SQL parameter declaration list> <returns clause> <SPECIFIC> <specific method name>

<specific method name> ::= <qualified identifier>
                         | <schema name> <period> <qualified identifier>

<method characteristics> ::= <method characteristic>+

<method characteristic> ::=
		<language clause>
	|	<parameter style clause>
	|	<deterministic characteristic>
	|	<SQL_data access indication>
	|	<null_call clause>

<attribute definition> ::=
	  <attribute name> <data type> <reference scope check>
	| <attribute name> <data type> <reference scope check> <attribute default>
	| <attribute name> <data type> <reference scope check> <attribute default> <collate clause>
	| <attribute name> <data type> <reference scope check> <collate clause>
	| <attribute name> <data type> <attribute default>
	| <attribute name> <data type> <attribute default> <collate clause>
	| <attribute name> <data type> <collate clause>

<attribute default> ::= <default clause>

<alter type statement> ::= <ALTER> <TYPE> <schema_resolved user_defined type name> <alter type action>

<alter type action> ::=
		<add attribute definition>
	|	<drop attribute definition>
	|	<add original method specification>
	|	<add overriding method specification>
	|	<drop method specification>

<add attribute definition> ::= <ADD> <ATTRIBUTE> <attribute definition>

<drop attribute definition> ::= <DROP> <ATTRIBUTE> <attribute name> <RESTRICT>

<add original method specification> ::= <ADD> <original method specification>

<add overriding method specification> ::= <ADD> <overriding method specification>

<drop method specification> ::= <DROP> <specific method specification designator> <RESTRICT>

<specific method specification designator> ::=               <METHOD> <method name> <data type list>
                                             | <INSTANCE>    <METHOD> <method name> <data type list>
                                             | <STATIC>      <METHOD> <method name> <data type list>
                                             | <CONSTRUCTOR> <METHOD> <method name> <data type list>

<drop data type statement> ::= <DROP> <TYPE> <schema_resolved user_defined type name> <drop behavior>

<SQL_invoked routine> ::= <schema routine>

<schema routine> ::= <schema procedure> | <schema function>

<schema procedure> ::= <CREATE> <SQL_invoked procedure>

<schema function> ::= <CREATE> <SQL_invoked function>

<SQL_invoked procedure> ::= <PROCEDURE> <schema qualified routine name> <SQL parameter declaration list> <routine characteristics> <routine body>

<SQL_invoked function> ::= <function specification> <routine body>
                         | <method specification designator> <routine body>

<SQL parameter declarations> ::= <SQL parameter declaration>
                               | <SQL parameter declarations> <comma> <SQL parameter declaration>

<SQL parameter declaration list> ::= <left paren> <right paren>
                                   | <left paren> <SQL parameter declarations> <right paren>

<SQL parameter declaration> ::=
	  <parameter mode> <parameter type>
	|  <parameter mode> <parameter type> <RESULT>
	| <parameter mode> <SQL parameter name> <parameter type>
	| <parameter mode> <SQL parameter name> <parameter type> <RESULT>
	| <SQL parameter name> <parameter type>
	| <SQL parameter name> <parameter type> <RESULT>

<parameter mode> ::= <IN> | <OUT> | <INOUT>

<parameter type> ::= <data type>
                   | <data type> <locator indication>

<locator indication> ::= <AS> <LOCATOR>

<function specification> ::= <FUNCTION> <schema qualified routine name> <SQL parameter declaration list> <returns clause> <routine characteristics>
                           | <FUNCTION> <schema qualified routine name> <SQL parameter declaration list> <returns clause> <routine characteristics> <dispatch clause>

<method specification designator> ::=
		<SPECIFIC>    <METHOD> <specific method name>
	|	              <METHOD> <method name> <SQL parameter declaration list>                  <FOR> <schema_resolved user_defined type name>
	|	              <METHOD> <method name> <SQL parameter declaration list> <returns clause> <FOR> <schema_resolved user_defined type name>
	|	<INSTANCE>    <METHOD> <method name> <SQL parameter declaration list>                  <FOR> <schema_resolved user_defined type name>
	|	<STATIC>      <METHOD> <method name> <SQL parameter declaration list>                  <FOR> <schema_resolved user_defined type name>
	|	<CONSTRUCTOR> <METHOD> <method name> <SQL parameter declaration list>                  <FOR> <schema_resolved user_defined type name>
	|	<INSTANCE>    <METHOD> <method name> <SQL parameter declaration list> <returns clause> <FOR> <schema_resolved user_defined type name>
	|	<STATIC>      <METHOD> <method name> <SQL parameter declaration list> <returns clause> <FOR> <schema_resolved user_defined type name>
	|	<CONSTRUCTOR> <METHOD> <method name> <SQL parameter declaration list> <returns clause> <FOR> <schema_resolved user_defined type name>

<routine characteristics> ::= <routine characteristic>*

<routine characteristic> ::=
		<language clause>
	|	<parameter style clause>
	|	<SPECIFIC> <specific name>
	|	<deterministic characteristic>
	|	<SQL_data access indication>
	|	<null_call clause>
	|	<dynamic result sets characteristic>
	|	<savepoint level indication>

<savepoint level indication> ::= <NEW> <SAVEPOINT> <LEVEL> | <OLD> <SAVEPOINT> <LEVEL>

<dynamic result sets characteristic> ::= <DYNAMIC> <RESULT> <SETS> <maximum dynamic result sets>

<parameter style clause> ::= <PARAMETER> <STYLE> <parameter style>

<dispatch clause> ::= <STATIC> <DISPATCH>

<returns clause> ::= <RETURNS> <returns type>

<returns type> ::=
		<returns data type>
	|	<returns data type> <result cast>
	|	<returns table type>

<returns table type> ::= <TABLE> <table function column list>

<table function column list elements> ::= <table function column list element>
                                        | <table function column list elements> <comma> <table function column list element>

<table function column list> ::= <left paren> <table function column list elements> <right paren>

<table function column list element> ::= <column name> <data type>

<result cast> ::= <CAST> <FROM> <result cast from type>

<result cast from type> ::= <data type> <locator indication>
                          | <data type>

<returns data type> ::= <data type>
                      | <data type> <locator indication>

<routine body> ::=
		<SQL routine spec>
	|	<external body reference>

<SQL routine spec> ::=                 <SQL routine body>
                     | <rights clause> <SQL routine body>

<rights clause> ::= <SQL> <SECURITY> <INVOKER> | <SQL> <SECURITY> <DEFINER>

<SQL routine body> ::= <SQL procedure statement>

<external body reference> ::=
	  <EXTERNAL><NAME> <external routine name>
	| <EXTERNAL><NAME> <external routine name> <parameter style clause>
	| <EXTERNAL><NAME> <external routine name> <parameter style clause> <transform group specification>
	| <EXTERNAL><NAME> <external routine name> <parameter style clause> <transform group specification> <external security clause>
	| <EXTERNAL><NAME> <external routine name> <parameter style clause> <external security clause>
	| <EXTERNAL><NAME> <external routine name> <transform group specification>
	| <EXTERNAL><NAME> <external routine name> <transform group specification> <external security clause>
	| <EXTERNAL><NAME> <external routine name> <external security clause>
	| <EXTERNAL><parameter style clause>
	| <EXTERNAL><parameter style clause> <transform group specification>
	| <EXTERNAL><parameter style clause> <transform group specification> <external security clause>
	| <EXTERNAL><parameter style clause> <external security clause>
	| <EXTERNAL><transform group specification>
	| <EXTERNAL><transform group specification> <external security clause>
	| <EXTERNAL><external security clause>

<external security clause> ::=
		<EXTERNAL> <SECURITY> <DEFINER>
	|	<EXTERNAL> <SECURITY> <INVOKER>
	|	<EXTERNAL> <SECURITY> <IMPLEMENTATION> <DEFINED>

<parameter style> ::= <SQL> | <GENERAL>

<deterministic characteristic> ::= <DETERMINISTIC> | <NOT> <DETERMINISTIC>

<SQL_data access indication> ::=
		<NO> <SQL>
	|	<CONTAINS> <SQL>
	|	<READS> <SQL> <DATA>
	|	<MODIFIES> <SQL> <DATA>

<null_call clause> ::=
		<RETURNS> <NULL> <ON> <NULL> <INPUT>
	|	<CALLED> <ON> <NULL> <INPUT>

<maximum dynamic result sets> ::= <unsigned integer>

<transform group specification> ::= <TRANSFORM> <GROUP> <single group specification>
                                  | <TRANSFORM> <GROUP> <multiple group specification>

<single group specification> ::= <group name>

<multiple group specification> ::= <group specification>
                                 | <multiple group specification> <comma> <group specification>

<group specification> ::= <group name> <FOR> <TYPE> <path_resolved user_defined type name>

<alter routine statement> ::= <ALTER> <specific routine designator> <alter routine characteristics> <alter routine behavior>

<alter routine characteristics> ::= <alter routine characteristic>+

<alter routine characteristic> ::=
		<language clause>
	|	<parameter style clause>
	|	<SQL_data access indication>
	|	<null_call clause>
	|	<dynamic result sets characteristic>
	|	<NAME> <external routine name>

<alter routine behavior> ::= <RESTRICT>

<drop routine statement> ::= <DROP> <specific routine designator> <drop behavior>

<user_defined cast definition> ::= <CREATE> <CAST> <left paren> <source data type> <AS> <target data type> <right paren> <WITH> <cast function>
                                 | <CREATE> <CAST> <left paren> <source data type> <AS> <target data type> <right paren> <WITH> <cast function> <AS> <ASSIGNMENT>

<cast function> ::= <specific routine designator>

<source data type> ::= <data type>

<target data type> ::= <data type>

<drop user_defined cast statement> ::= <DROP> <CAST> <left paren> <source data type> <AS> <target data type> <right paren> <drop behavior>

<user_defined ordering definition> ::= <CREATE> <ORDERING> <FOR> <schema_resolved user_defined type name> <ordering form>

<ordering form> ::= <equals ordering form> | <full ordering form>

<equals ordering form> ::= <EQUALS> <ONLY> <BY> <ordering category>

<full ordering form> ::= <ORDER> <FULL> <BY> <ordering category>

<ordering category> ::= <relative category> | <map category> | <state category>

<relative category> ::= <RELATIVE> <WITH> <relative function specification>

<map category> ::= <MAP> <WITH> <map function specification>

<state category> ::= <STATE>
                   | <STATE> <specific name>

<relative function specification> ::= <specific routine designator>

<map function specification> ::= <specific routine designator>

<drop user_defined ordering statement> ::= <DROP> <ORDERING> <FOR> <schema_resolved user_defined type name> <drop behavior>

<transform group many> ::= <transform group>+

<transform definition> ::= <CREATE> <TRANSFORM>  <FOR> <schema_resolved user_defined type name> <transform group many>
                         | <CREATE> <TRANSFORMS> <FOR> <schema_resolved user_defined type name> <transform group many>

<transform group> ::= <group name> <left paren> <transform element list> <right paren>

<group name> ::= <identifier>

<transform element list> ::= <transform element>
                           | <transform element list> <comma> <transform element>

<transform element> ::= <to sql> | <from sql>

<to sql> ::= <TO> <SQL> <WITH> <to sql function>

<from sql> ::= <FROM> <SQL> <WITH> <from sql function>

<to sql function> ::= <specific routine designator>

<from sql function> ::= <specific routine designator>

<alter group many> ::= <alter group>+

<alter transform statement> ::= <ALTER> <TRANSFORM>  <FOR> <schema_resolved user_defined type name> <alter group many>
                              | <ALTER> <TRANSFORMS> <FOR> <schema_resolved user_defined type name> <alter group many>

<alter group> ::= <group name> <left paren> <alter transform action list> <right paren>

<alter transform action list> ::= <alter transform action>
                                | <alter transform action list> <comma> <alter transform action>

<alter transform action> ::= <add transform element list> | <drop transform element list>

<add transform element list> ::= <ADD> <left paren> <transform element list> <right paren>

<drop transform element list> ::= <DROP> <left paren> <transform kind>                          <drop behavior> <right paren>
                                | <DROP> <left paren> <transform kind> <comma> <transform kind> <drop behavior> <right paren>

<transform kind> ::= <TO> <SQL> | <FROM> <SQL>

<drop transform statement> ::= <DROP> <TRANSFORM>  <transforms to be dropped> <FOR> <schema_resolved user_defined type name> <drop behavior>
                             | <DROP> <TRANSFORMS> <transforms to be dropped> <FOR> <schema_resolved user_defined type name> <drop behavior>

<transforms to be dropped> ::= <ALL> | <transform group element>

<transform group element> ::= <group name>

<sequence generator definition> ::= <CREATE> <SEQUENCE> <sequence generator name>
                                  | <CREATE> <SEQUENCE> <sequence generator name> <sequence generator options>

<sequence generator options> ::= <sequence generator option>+

<sequence generator option> ::= <sequence generator data type option> | <common sequence generator options>

<common sequence generator options> ::= <common sequence generator option>+

<common sequence generator option> ::= <sequence generator start with option> | <basic sequence generator option>

<basic sequence generator option> ::=
		<sequence generator increment by option>
	|	<sequence generator maxvalue option>
	|	<sequence generator minvalue option>
	|	<sequence generator cycle option>

<sequence generator data type option> ::= <AS> <data type>

<sequence generator start with option> ::= <START> <WITH> <sequence generator start value>

<sequence generator start value> ::= <signed numeric literal>

<sequence generator increment by option> ::= <INCREMENT> <BY> <sequence generator increment>

<sequence generator increment> ::= <signed numeric literal>

<sequence generator maxvalue option> ::=
		<MAXVALUE> <sequence generator max value>
	|	<NO> <MAXVALUE>

<sequence generator max value> ::= <signed numeric literal>

<sequence generator minvalue option> ::= <MINVALUE> <sequence generator min value> | <NO> <MINVALUE>

<sequence generator min value> ::= <signed numeric literal>

<sequence generator cycle option> ::= <CYCLE> | <NO> <CYCLE>

<alter sequence generator statement> ::= <ALTER> <SEQUENCE> <sequence generator name> <alter sequence generator options>

<alter sequence generator options> ::= <alter sequence generator option>+

<alter sequence generator option> ::=
		<alter sequence generator restart option>
	|	<basic sequence generator option>

<alter sequence generator restart option> ::= <RESTART> <WITH> <sequence generator restart value>

<sequence generator restart value> ::= <signed numeric literal>

<drop sequence generator statement> ::= <DROP> <SEQUENCE> <sequence generator name> <drop behavior>

<grant statement> ::= <grant privilege statement> | <grant role statement>

<grantees> ::= <grantee>
             | <grantees> <comma> <grantee>

<grant privilege statement> ::=
	  <GRANT> <privileges> <TO> <grantees> <WITH> <HIERARCHY> <OPTION>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <HIERARCHY> <OPTION> <WITH> <GRANT> <OPTION>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <HIERARCHY> <OPTION> <WITH> <GRANT> <OPTION> <GRANTED> <BY> <grantor>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <HIERARCHY> <OPTION> <GRANTED> <BY> <grantor>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <GRANT> <OPTION>
	| <GRANT> <privileges> <TO> <grantees> <WITH> <GRANT> <OPTION> <GRANTED> <BY> <grantor>
	| <GRANT> <privileges> <TO> <grantees> <GRANTED> <BY> <grantor>

<privileges> ::= <object privileges> <ON> <object name>

<object name> ::=
		<table name>
	|	<TABLE> <table name>
	|	<DOMAIN> <domain name>
	|	<COLLATION> <collation name>
	|	<CHARACTER> <SET> <character set name>
	|	<TRANSLATION> <transliteration name>
	|	<TYPE> <schema_resolved user_defined type name>
	|	<SEQUENCE> <sequence generator name>
	|	<specific routine designator>

<actions> ::= <action>
            | <actions> <comma> <action>

<object privileges> ::=
		<ALL> <PRIVILEGES>
	|	<actions>

<action> ::=
		<SELECT>
	|	<SELECT> <left paren> <privilege column list> <right paren>
	|	<SELECT> <left paren> <privilege method list> <right paren>
	|	<DELETE>
	|	<INSERT>
	|	<INSERT> <left paren> <privilege column list> <right paren>
	|	<UPDATE>
	|	<UPDATE> <left paren> <privilege column list> <right paren>
	|	<REFERENCES>
	|	<REFERENCES> <left paren> <privilege column list> <right paren>
	|	<USAGE>
	|	<TRIGGER>
	|	<UNDER>
	|	<EXECUTE>

<privilege method list> ::= <specific routine designator>
                          | <privilege method list> <comma> <specific routine designator>

<privilege column list> ::= <column name list>

<grantee> ::= <PUBLIC> | <authorization identifier>

<grantor> ::= <CURRENT_USER> | <CURRENT_ROLE>

<role definition> ::= <CREATE> <ROLE> <role name>
                    | <CREATE> <ROLE> <role name> <WITH> <ADMIN> <grantor>

<role granted many> ::= <role granted>
                      | <role granted many> <comma> <role granted>

<grant role statement> ::=
	  <GRANT> <role granted many> <TO> <grantees> <WITH> <ADMIN> <OPTION>
	| <GRANT> <role granted many> <TO> <grantees> <WITH> <ADMIN> <OPTION> <GRANTED> <BY> <grantor>
	| <GRANT> <role granted many> <TO> <grantees> <GRANTED> <BY> <grantor>

<role granted> ::= <role name>

<drop role statement> ::= <DROP> <ROLE> <role name>

<revoke statement> ::=
		<revoke privilege statement>
	|	<revoke role statement>

<revoke privilege statement> ::= <REVOKE>                           <privileges> <FROM> <grantees>                          <drop behavior>
                               | <REVOKE>                           <privileges> <FROM> <grantees> <GRANTED> <BY> <grantor> <drop behavior>
                               | <REVOKE> <revoke option extension> <privileges> <FROM> <grantees>                          <drop behavior>
                               | <REVOKE> <revoke option extension> <privileges> <FROM> <grantees> <GRANTED> <BY> <grantor> <drop behavior>

<revoke option extension> ::= <GRANT> <OPTION> <FOR> | <HIERARCHY> <OPTION> <FOR>

<role revoked many> ::= <role revoked>
                      | <role revoked many> <comma> <role revoked>

<revoke role statement> ::= <REVOKE>                        <role revoked many> <FROM> <grantees>                          <drop behavior>
                          | <REVOKE>                        <role revoked many> <FROM> <grantees> <GRANTED> <BY> <grantor> <drop behavior>
                          | <REVOKE> <ADMIN> <OPTION> <FOR> <role revoked many> <FROM> <grantees>                          <drop behavior>
                          | <REVOKE> <ADMIN> <OPTION> <FOR> <role revoked many> <FROM> <grantees> <GRANTED> <BY> <grantor> <drop behavior>

<role revoked> ::= <role name>

<module contents many> ::= <module contents>+

<temporary table declarations> ::= <temporary table declaration>+

<SQL_client module definition> ::=
	  <module name clause> <language clause> <module authorization clause> <module path specification> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module path specification> <module transform group specification> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module path specification> <module transform group specification> <module collations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module path specification> <module transform group specification> <module collations> <temporary table declarations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module path specification> <module transform group specification> <temporary table declarations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module path specification> <module collations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module path specification> <module collations> <temporary table declarations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module path specification> <temporary table declarations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module transform group specification> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module transform group specification> <module collations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module transform group specification> <module collations> <temporary table declarations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module transform group specification> <temporary table declarations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module collations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <module collations> <temporary table declarations> <module contents many>
	| <module name clause> <language clause> <module authorization clause> <temporary table declarations> <module contents many>

<module authorization clause> ::=
		<SCHEMA> <schema name>
	|	<AUTHORIZATION> <module authorization identifier>
	|	<AUTHORIZATION> <module authorization identifier> <FOR> <STATIC> <ONLY>
	|	<AUTHORIZATION> <module authorization identifier> <FOR> <STATIC> <AND> <DYNAMIC>
	|	<SCHEMA> <schema name> <AUTHORIZATION> <module authorization identifier>
	|	<SCHEMA> <schema name> <AUTHORIZATION> <module authorization identifier> <FOR> <STATIC> <ONLY>
	|	<SCHEMA> <schema name> <AUTHORIZATION> <module authorization identifier> <FOR> <STATIC> <AND> <DYNAMIC>

<module authorization identifier> ::= <authorization identifier>

<module path specification> ::= <path specification>

<module transform group specification> ::= <transform group specification>

<module collations> ::= <module collation specification>+

<module collation specification> ::= <COLLATION> <collation name>
                                   | <COLLATION> <collation name> <FOR> <character set specification list>

<character set specification list> ::= <character set specification>
                                     | <character set specification list> <comma> <character set specification>

<module contents> ::=
		<declare cursor>
	|	<dynamic declare cursor>
	|	<externally_invoked procedure>

<module name clause> ::=
	  <MODULE> <SQL_client module name> <module contents many>
	| <MODULE> <SQL_client module name> <module character set specification> <module contents many>
	| <MODULE> <module character set specification> <module contents many>

<module character set specification> ::= <NAMES> <ARE> <character set specification>

<externally_invoked procedure> ::= <PROCEDURE> <procedure name> <host parameter declaration list> <semicolon> <SQL procedure statement> <semicolon>

<host parameter declarations> ::= <host parameter declaration>
                                | <host parameter declarations> <comma> <host parameter declaration>

<host parameter declaration list> ::= <left paren> <host parameter declarations> <right paren>

<host parameter declaration> ::=
		<host parameter name> <host parameter data type>
	|	<status parameter>

<host parameter data type> ::= <data type>
                             | <data type> <locator indication>

<status parameter> ::= <SQLSTATE>

<SQL procedure statement> ::= <SQL executable statement>

<SQL executable statement> ::=
		<SQL schema statement>
	|	<SQL data statement>
	|	<SQL control statement>
	|	<SQL transaction statement>
	|	<SQL connection statement>
	|	<SQL session statement>
	|	<SQL diagnostics statement>
	|	<SQL dynamic statement>

<SQL schema statement> ::=
		<SQL schema definition statement>
	|	<SQL schema manipulation statement>

<SQL schema definition statement> ::=
		<schema definition>
	|	<table definition>
	|	<view definition>
	|	<SQL_invoked routine>
	|	<grant statement>
	|	<role definition>
	|	<domain definition>
	|	<character set definition>
	|	<collation definition>
	|	<transliteration definition>
	|	<assertion definition>
	|	<trigger definition>
	|	<user_defined type definition>
	|	<user_defined cast definition>
	|	<user_defined ordering definition>
	|	<transform definition>
	|	<sequence generator definition>

<SQL schema manipulation statement> ::=
		<drop schema statement>
	|	<alter table statement>
	|	<drop table statement>
	|	<drop view statement>
	|	<alter routine statement>
	|	<drop routine statement>
	|	<drop user_defined cast statement>
	|	<revoke statement>
	|	<drop role statement>
	|	<alter domain statement>
	|	<drop domain statement>
	|	<drop character set statement>
	|	<drop collation statement>
	|	<drop transliteration statement>
	|	<drop assertion statement>
	|	<drop trigger statement>
	|	<alter type statement>
	|	<drop data type statement>
	|	<drop user_defined ordering statement>
	|	<alter transform statement>
	|	<drop transform statement> | <alter sequence generator statement>
	|	<drop sequence generator statement>

<SQL data statement> ::=
		<open statement>
	|	<fetch statement>
	|	<close statement>
	|	<select statement single row>
	|	<free locator statement>
	|	<hold locator statement>
	|	<SQL data change statement>

<SQL data change statement> ::=
		<delete statement positioned>
	|	<delete statement searched>
	|	<insert statement>
	|	<update statement positioned>
	|	<update statement searched>
	|	<merge statement>

<SQL control statement> ::=
		<call statement>
	|	<return statement>

<SQL transaction statement> ::=
		<start transaction statement>
	|	<set transaction statement>
	|	<set constraints mode statement>
	|	<savepoint statement>
	|	<release savepoint statement>
	|	<commit statement>
	|	<rollback statement>

<SQL connection statement> ::=
		<connect statement>
	|	<set connection statement>
	|	<disconnect statement>

<SQL session statement> ::=
		<set session user identifier statement>
	|	<set role statement>
	|	<set local time zone statement>
	|	<set session characteristics statement>
	|	<set catalog statement>
	|	<set schema statement>
	|	<set names statement>
	|	<set path statement>
	|	<set transform group statement>
	|	<set session collation statement>

<SQL diagnostics statement> ::= <get diagnostics statement>

<SQL dynamic statement> ::=
		<system descriptor statement>
	|	<prepare statement>
	|	<deallocate prepared statement>
	|	<describe statement>
	|	<execute statement>
	|	<execute immediate statement>
	|	<SQL dynamic data statement>

<SQL dynamic data statement> ::=
		<allocate cursor statement>
	|	<dynamic open statement>
	|	<dynamic fetch statement>
	|	<dynamic close statement>
	|	<dynamic delete statement positioned>
	|	<dynamic update statement positioned>

<system descriptor statement> ::=
		<allocate descriptor statement>
	|	<deallocate descriptor statement>
	|	<set descriptor statement>
	|	<get descriptor statement>

<declare cursor> ::=
	  <DECLARE> <cursor name> <cursor sensitivity>                        <CURSOR> <cursor holdability> <FOR> <cursor specification>
	| <DECLARE> <cursor name> <cursor sensitivity>                        <CURSOR> <cursor holdability> <cursor returnability> <FOR> <cursor specification>
	| <DECLARE> <cursor name> <cursor sensitivity>                        <CURSOR> <cursor returnability> <FOR> <cursor specification>
	| <DECLARE> <cursor name> <cursor sensitivity> <cursor scrollability> <CURSOR> <cursor holdability> <FOR> <cursor specification>
	| <DECLARE> <cursor name> <cursor sensitivity> <cursor scrollability> <CURSOR> <cursor holdability> <cursor returnability> <FOR> <cursor specification>
	| <DECLARE> <cursor name> <cursor sensitivity> <cursor scrollability> <CURSOR> <cursor returnability> <FOR> <cursor specification>
	| <DECLARE> <cursor name> <cursor scrollability>                      <CURSOR> <cursor holdability> <FOR> <cursor specification>
	| <DECLARE> <cursor name> <cursor scrollability>                      <CURSOR> <cursor holdability> <cursor returnability> <FOR> <cursor specification>
	| <DECLARE> <cursor name> <cursor scrollability>                      <CURSOR> <cursor returnability> <FOR> <cursor specification>


<cursor sensitivity> ::= <SENSITIVE> | <INSENSITIVE> | <ASENSITIVE>

<cursor scrollability> ::= <SCROLL> | <NO> <SCROLL>

<cursor holdability> ::= <WITH> <HOLD> | <WITHOUT> <HOLD>

<cursor returnability> ::= <WITH> <RETURN> | <WITHOUT> <RETURN>

<cursor specification> ::=
	  <query expression> <order by clause>
	| <query expression> <order by clause> <updatability clause>
	| <query expression> <updatability clause>

<updatability clause> ::= <FOR> <READ> <ONLY>
                        | <FOR> <UPDATE>
                        | <FOR> <UPDATE> <OF> <column name list>

<order by clause> ::= <ORDER> <BY> <sort specification list>

<open statement> ::= <OPEN> <cursor name>

<fetch statement> ::= <FETCH>                            <cursor name> <INTO> <fetch target list>
                    | <FETCH>                     <FROM> <cursor name> <INTO> <fetch target list>
                    | <FETCH> <fetch orientation> <FROM> <cursor name> <INTO> <fetch target list>

<fetch orientation> ::=
		<NEXT>
	|	<PRIOR>
	|	<FIRST>
	|	<LAST>
	|	<ABSOLUTE> <simple value specification>
	|	<RELATIVE> <simple value specification>

<fetch target list> ::= <target specification>
                      | <fetch target list> <comma> <target specification>

<close statement> ::= <CLOSE> <cursor name>

<select statement single row> ::= <SELECT>                  <select list> <INTO> <select target list> <table expression>
                                | <SELECT> <set quantifier> <select list> <INTO> <select target list> <table expression>

<select target list> ::= <target specification>
                       | <select target list> <comma> <target specification>

<delete statement positioned> ::= <DELETE> <FROM> <target table> <WHERE> <CURRENT> <OF> <cursor name>

<target table> ::=
		<table name>
	|	<ONLY> <left paren> <table name> <right paren>

<delete statement searched> ::= <DELETE> <FROM> <target table>
                              | <DELETE> <FROM> <target table> <WHERE> <search condition>

<insert statement> ::= <INSERT> <INTO> <insertion target> <insert columns and source>

<insertion target> ::= <table name>

<insert columns and source> ::=
		<from subquery>
	|	<from constructor>
	|	<from default>

<from subquery> ::=
	  <left paren> <insert column list> <right paren> <query expression>
	| <left paren> <insert column list> <right paren> <override clause> <query expression>
	| <override clause> <query expression>

<from constructor> ::=
	  <left paren> <insert column list> <right paren> <contextually typed table value constructor>
	| <left paren> <insert column list> <right paren> <override clause> <contextually typed table value constructor>
	| <override clause> <contextually typed table value constructor>

<override clause> ::= <OVERRIDING> <USER> <VALUE> | <OVERRIDING> <SYSTEM> <VALUE>

<from default> ::= <DEFAULT> <VALUES>

<insert column list> ::= <column name list>

<merge statement> ::= <MERGE> <INTO> <target table>                               <USING> <table reference> <ON> <search condition> <merge operation specification>
                    | <MERGE> <INTO> <target table>      <merge correlation name> <USING> <table reference> <ON> <search condition> <merge operation specification>
                    | <MERGE> <INTO> <target table> <AS> <merge correlation name> <USING> <table reference> <ON> <search condition> <merge operation specification>

<merge correlation name> ::= <correlation name>

<merge operation specification> ::= <merge when clause>+

<merge when clause> ::= <merge when matched clause> | <merge when not matched clause>

<merge when matched clause> ::= <WHEN> <MATCHED> <THEN> <merge update specification>

<merge when not matched clause> ::= <WHEN> <NOT> <MATCHED> <THEN> <merge insert specification>

<merge update specification> ::= <UPDATE> <SET> <set clause list>

<merge insert specification> ::=
	  <INSERT> <left paren> <insert column list> <right paren> <VALUES> <merge insert value list>
	| <INSERT> <left paren> <insert column list> <right paren> <override clause> <VALUES> <merge insert value list>
	| <INSERT> <override clause> <VALUES> <merge insert value list>

<merge insert value element many> ::= <merge insert value element>
                                    | <merge insert value element many> <comma> <merge insert value element>

<merge insert value list> ::= <left paren> <merge insert value element many> <right paren>

<merge insert value element> ::= <value expression> | <contextually typed value specification>

<update statement positioned> ::= <UPDATE> <target table> <SET> <set clause list> <WHERE> <CURRENT> <OF> <cursor name>

<update statement searched> ::= <UPDATE> <target table> <SET> <set clause list>
                              | <UPDATE> <target table> <SET> <set clause list> <WHERE> <search condition>

<set clause list> ::= <set clause>
                    | <set clause list> <comma> <set clause>

<set clause> ::=
		<multiple column assignment>
	|	<set target> <equals operator> <update source>

<set target> ::= <update target> | <mutated set clause>

<multiple column assignment> ::= <set target list> <equals operator> <assigned row>

<set target many> ::= <set target>
                    | <set target many> <comma> <set target>

<set target list> ::= <left paren> <set target many> <right paren>

<assigned row> ::= <contextually typed row value expression>

<update target> ::=
		<object column>
	|	<object column> <left bracket or trigraph> <simple value specification> <right bracket or trigraph>

<object column> ::= <column name>

<mutated set clause> ::= <mutated target> <period> <method name>

<mutated target> ::= <object column> | <mutated set clause>

<update source> ::= <value expression> | <contextually typed value specification>

<temporary table declaration> ::= <DECLARE> <LOCAL> <TEMPORARY> <TABLE> <table name> <table element list>
                                | <DECLARE> <LOCAL> <TEMPORARY> <TABLE> <table name> <table element list> <ON> <COMMIT> <table commit action> <ROWS>

<locator reference many> ::= <locator reference>
                           | <locator reference many> <comma> <locator reference>

<free locator statement> ::= <FREE> <LOCATOR> <locator reference many>

<locator reference> ::= <host parameter name> | <embedded variable name>

<hold locator statement> ::= <HOLD> <LOCATOR> <locator reference many>

<call statement> ::= <CALL> <routine invocation>

<return statement> ::= <RETURN> <return value>

<return value> ::= <value expression> | <NULL>

<transaction mode many> ::= <transaction mode>
                          | <transaction mode many> <comma> <transaction mode>

<start transaction statement> ::= <START> <TRANSACTION>
                                | <START> <TRANSACTION> <transaction mode many>

<transaction mode> ::= <isolation level> | <transaction access mode> | <diagnostics size>

<transaction access mode> ::= <READ> <ONLY> | <READ> <WRITE>

<isolation level> ::= <ISOLATION> <LEVEL> <level of isolation>

<level of isolation> ::= <READ> <UNCOMMITTED> | <READ> <COMMITTED> | <REPEATABLE> <READ> | <SERIALIZABLE>

<diagnostics size> ::= <DIAGNOSTICS> <SIZE> <number of conditions>

<number of conditions> ::= <simple value specification>

<set transaction statement> ::= <SET>         <transaction characteristics>
                              | <SET> <LOCAL> <transaction characteristics>

<transaction characteristics> ::= <TRANSACTION> <transaction mode many>

#
# Little deviation from the grammar:
# <ALL> is disassociated from <constraint name list>
#
<set constraints mode statement> ::= <SET> <CONSTRAINTS> <ALL> <DEFERRED>
                                   | <SET> <CONSTRAINTS> <constraint name list> <DEFERRED>
                                   | <SET> <CONSTRAINTS> <constraint name list> <IMMEDIATE>
                                   | <SET> <CONSTRAINTS> <ALL> <IMMEDIATE>

<constraint name list> ::= <constraint name>
                         | <constraint name list> <comma> <constraint name>

<savepoint statement> ::= <SAVEPOINT> <savepoint specifier>

<savepoint specifier> ::= <savepoint name>

<release savepoint statement> ::= <RELEASE> <SAVEPOINT> <savepoint specifier>

<commit statement> ::=
	  <COMMIT>
	| <COMMIT> <WORK>
	| <COMMIT> <WORK> <AND> <CHAIN>
	| <COMMIT> <WORK> <AND> <NO> <CHAIN>
	| <COMMIT> <AND> <CHAIN>
	| <COMMIT> <AND> <NO> <CHAIN>

<rollback statement> ::= <ROLLBACK>
	| <ROLLBACK> <WORK>
	| <ROLLBACK> <WORK> <AND> <CHAIN>
	| <ROLLBACK> <WORK> <AND> <NO> <CHAIN>
	| <ROLLBACK> <WORK> <AND> <CHAIN> <savepoint clause>
	| <ROLLBACK> <WORK> <AND> <NO> <CHAIN> <savepoint clause>
	| <ROLLBACK> <WORK> <savepoint clause>
	| <ROLLBACK> <AND> <CHAIN>
	| <ROLLBACK> <AND> <NO> <CHAIN>
	| <ROLLBACK> <AND> <CHAIN> <savepoint clause>
	| <ROLLBACK> <AND> <NO> <CHAIN> <savepoint clause>
	| <ROLLBACK> <savepoint clause>

<savepoint clause> ::= <TO> <SAVEPOINT> <savepoint specifier>

<connect statement> ::= <CONNECT> <TO> <connection target>

<connection target> ::=
	  <SQL_server name>
	| <SQL_server name> <AS> <connection name>
	| <SQL_server name> <AS> <connection name> <USER> <connection user name>
	| <SQL_server name> <USER> <connection user name>
	| <DEFAULT>

<set connection statement> ::= <SET> <CONNECTION> <connection object>

<connection object> ::= <DEFAULT> | <connection name>

<disconnect statement> ::= <DISCONNECT> <disconnect object>

<disconnect object> ::= <connection object> | <ALL> | <CURRENT>

<set session characteristics statement> ::= <SET> <SESSION> <CHARACTERISTICS> <AS> <session characteristic list>

<session characteristic list> ::= <session characteristic>
                                | <session characteristic list> <comma> <session characteristic>

<session characteristic> ::= <transaction characteristics>

<set session user identifier statement> ::= <SET> <SESSION> <AUTHORIZATION> <value specification>

<set role statement> ::= <SET> <ROLE> <role specification>

<role specification> ::= <value specification> | <NONE>

<set local time zone statement> ::= <SET> <TIME> <ZONE> <set time zone value>

<set time zone value> ::= <interval value expression> | <LOCAL>

<set catalog statement> ::= <SET> <catalog name characteristic>

<catalog name characteristic> ::= <CATALOG> <value specification>

<set schema statement> ::= <SET> <schema name characteristic>

<schema name characteristic> ::= <SCHEMA> <value specification>

<set names statement> ::= <SET> <character set name characteristic>

<character set name characteristic> ::= <NAMES> <value specification>

<set path statement> ::= <SET> <SQL_path characteristic>

<SQL_path characteristic> ::= <PATH> <value specification>

<set transform group statement> ::= <SET> <transform group characteristic>

<transform group characteristic> ::=
		<DEFAULT> <TRANSFORM> <GROUP> <value specification>
	|	<TRANSFORM> <GROUP> <FOR> <TYPE> <path_resolved user_defined type name> <value specification>

<set session collation statement> ::=
		<SET> <COLLATION> <collation specification>
	|	<SET> <COLLATION> <collation specification> <FOR> <character set specification list>
	|	<SET> <NO> <COLLATION>
	|	<SET> <NO> <COLLATION> <FOR> <character set specification list>

<collation specification> ::= <value specification>

<allocate descriptor statement> ::= <ALLOCATE>       <DESCRIPTOR> <descriptor name>
                                  | <ALLOCATE>       <DESCRIPTOR> <descriptor name> <WITH> <MAX> <occurrences>
                                  | <ALLOCATE> <SQL> <DESCRIPTOR> <descriptor name>
                                  | <ALLOCATE> <SQL> <DESCRIPTOR> <descriptor name> <WITH> <MAX> <occurrences>

<occurrences> ::= <simple value specification>

<deallocate descriptor statement> ::= <DEALLOCATE>       <DESCRIPTOR> <descriptor name>
                                    | <DEALLOCATE> <SQL> <DESCRIPTOR> <descriptor name>

<get descriptor statement> ::= <GET>       <DESCRIPTOR> <descriptor name> <get descriptor information>
                             | <GET> <SQL> <DESCRIPTOR> <descriptor name> <get descriptor information>

<get header information many> ::= <get header information>
                                | <get header information many> <comma> <get header information>

<get item information many> ::= <get item information>
                              | <get item information many> <comma> <get item information>
<get descriptor information> ::=
		<get header information many>
	|	<VALUE> <item number> <get item information many>

<get header information> ::= <simple target specification 1> <equals operator> <header item name>

<header item name> ::= <COUNT> | <KEY_TYPE> | <DYNAMIC_FUNCTION> | <DYNAMIC_FUNCTION_CODE> | <TOP_LEVEL_COUNT>

<get item information> ::= <simple target specification 2> <equals operator> <descriptor item name>

<item number> ::= <simple value specification>

<simple target specification 1> ::= <simple target specification>

<simple target specification 2> ::= <simple target specification>

<descriptor item name> ::=
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

<set descriptor statement> ::= <SET>       <DESCRIPTOR> <descriptor name> <set descriptor information>
                             | <SET> <SQL> <DESCRIPTOR> <descriptor name> <set descriptor information>

<set header information many> ::= <set header information>
                                | <set header information many> <comma> <set header information>

<set item information many> ::= <set item information>
                              | <set item information many> <comma> <set item information>

<set descriptor information> ::=
		<set header information many>
	|	<VALUE> <item number> <set item information many>

<set header information> ::= <header item name> <equals operator> <simple value specification 1>

<set item information> ::= <descriptor item name> <equals operator> <simple value specification 2>

<simple value specification 1> ::= <simple value specification>

<simple value specification 2> ::= <simple value specification>

<prepare statement> ::= <PREPARE> <SQL statement name>                            <FROM> <SQL statement variable>
                      | <PREPARE> <SQL statement name> <attributes specification> <FROM> <SQL statement variable>

<attributes specification> ::= <ATTRIBUTES> <attributes variable>

<attributes variable> ::= <simple value specification>

<SQL statement variable> ::= <simple value specification>

<preparable statement> ::=
		<preparable SQL data statement>
	|	<preparable SQL schema statement>
	|	<preparable SQL transaction statement>
	|	<preparable SQL control statement>
	|	<preparable SQL session statement>
#	|	<preparable implementation_defined statement>

<preparable SQL data statement> ::=
		<delete statement searched>
	|	<dynamic single row select statement>
	|	<insert statement>
	|	<dynamic select statement>
	|	<update statement searched>
	|	<merge statement>
	|	<preparable dynamic delete statement positioned>
	|	<preparable dynamic update statement positioned>

<preparable SQL schema statement> ::= <SQL schema statement>

<preparable SQL transaction statement> ::= <SQL transaction statement>

<preparable SQL control statement> ::= <SQL control statement>

<preparable SQL session statement> ::= <SQL session statement>

<dynamic select statement> ::= <cursor specification>

<deallocate prepared statement> ::= <DEALLOCATE> <PREPARE> <SQL statement name>

<describe statement> ::= <describe input statement> | <describe output statement>

<describe input statement> ::= <DESCRIBE> <INPUT> <SQL statement name> <using descriptor>
                             | <DESCRIBE> <INPUT> <SQL statement name> <using descriptor> <nesting option>

<describe output statement> ::= <DESCRIBE>          <described object> <using descriptor>
                              | <DESCRIBE>          <described object> <using descriptor> <nesting option>
                              | <DESCRIBE> <OUTPUT> <described object> <using descriptor>
                              | <DESCRIBE> <OUTPUT> <described object> <using descriptor> <nesting option>

<nesting option> ::= <WITH> <NESTING> | <WITHOUT> <NESTING>

<using descriptor> ::= <USING>       <DESCRIPTOR> <descriptor name>
                     | <USING> <SQL> <DESCRIPTOR> <descriptor name>

<described object> ::=
		<SQL statement name>
	|	<CURSOR> <extended cursor name> <STRUCTURE>

<input using clause> ::= <using arguments> | <using input descriptor>

<using argument many> ::= <using argument>
                        | <using argument many> <comma> <using argument>

<using arguments> ::= <USING> <using argument many>

<using argument> ::= <general value specification>

<using input descriptor> ::= <using descriptor>

<output using clause> ::= <into arguments> | <into descriptor>

<into argument many> ::= <into argument>
                       | <into argument many> <comma> <into argument>

<into arguments> ::= <INTO> <into argument many>

<into argument> ::= <target specification>

<into descriptor> ::= <INTO>       <DESCRIPTOR> <descriptor name>
                    | <INTO> <SQL> <DESCRIPTOR> <descriptor name>

<execute statement> ::= <EXECUTE> <SQL statement name>
	| <EXECUTE> <SQL statement name> <result using clause>
	| <EXECUTE> <SQL statement name> <result using clause> <parameter using clause>
	| <EXECUTE> <SQL statement name> <parameter using clause>

<result using clause> ::= <output using clause>

<parameter using clause> ::= <input using clause>

<execute immediate statement> ::= <EXECUTE> <IMMEDIATE> <SQL statement variable>

<dynamic declare cursor> ::= <DECLARE> <cursor name> <CURSOR> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor sensitivity> <CURSOR> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor sensitivity> <cursor scrollability> <CURSOR> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor sensitivity> <cursor scrollability> <CURSOR> <cursor holdability> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor sensitivity> <cursor scrollability> <CURSOR> <cursor holdability> <cursor returnability> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor sensitivity> <cursor scrollability> <CURSOR> <cursor returnability> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor sensitivity> <CURSOR> <cursor holdability> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor sensitivity> <CURSOR> <cursor holdability> <cursor returnability> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor sensitivity> <CURSOR> <cursor returnability> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor scrollability> <CURSOR> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor scrollability> <CURSOR> <cursor holdability> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor scrollability> <CURSOR> <cursor holdability> <cursor returnability> <FOR> <statement name>
	| <DECLARE> <cursor name> <cursor scrollability> <CURSOR> <cursor returnability> <FOR> <statement name>
	| <DECLARE> <cursor name> <CURSOR> <cursor holdability> <FOR> <statement name>
	| <DECLARE> <cursor name> <CURSOR> <cursor holdability> <cursor returnability> <FOR> <statement name>
	| <DECLARE> <cursor name> <CURSOR> <cursor returnability> <FOR> <statement name>

<allocate cursor statement> ::= <ALLOCATE> <extended cursor name> <cursor intent>

<cursor intent> ::= <statement cursor> | <result set cursor>

<statement cursor> ::= <CURSOR> <FOR> <extended statement name>
	| <cursor sensitivity> <CURSOR> <FOR> <extended statement name>
	| <cursor sensitivity> <cursor scrollability> <CURSOR> <FOR> <extended statement name>
	| <cursor sensitivity> <cursor scrollability> <CURSOR> <cursor holdability> <FOR> <extended statement name>
	| <cursor sensitivity> <cursor scrollability> <CURSOR> <cursor holdability> <cursor returnability> <FOR> <extended statement name>
	| <cursor sensitivity> <cursor scrollability> <CURSOR> <cursor returnability> <FOR> <extended statement name>
	| <cursor sensitivity> <CURSOR> <cursor holdability> <FOR> <extended statement name>
	| <cursor sensitivity> <CURSOR> <cursor holdability> <cursor returnability> <FOR> <extended statement name>
	| <cursor sensitivity> <CURSOR> <cursor returnability> <FOR> <extended statement name>
	| <cursor scrollability> <CURSOR> <FOR> <extended statement name>
	| <cursor scrollability> <CURSOR> <cursor holdability> <FOR> <extended statement name>
	| <cursor scrollability> <CURSOR> <cursor holdability> <cursor returnability> <FOR> <extended statement name>
	| <cursor scrollability> <CURSOR> <cursor returnability> <FOR> <extended statement name>
	| <CURSOR> <cursor holdability> <FOR> <extended statement name>
	| <CURSOR> <cursor holdability> <cursor returnability> <FOR> <extended statement name>
	| <CURSOR> <cursor returnability> <FOR> <extended statement name>

<result set cursor> ::= <FOR> <PROCEDURE> <specific routine designator>

<dynamic open statement> ::= <OPEN> <dynamic cursor name>
                           | <OPEN> <dynamic cursor name> <input using clause>

<dynamic fetch statement> ::= <FETCH>                            <dynamic cursor name> <output using clause>
                            | <FETCH>                     <FROM> <dynamic cursor name> <output using clause>
                            | <FETCH> <fetch orientation> <FROM> <dynamic cursor name> <output using clause>

<dynamic single row select statement> ::= <query specification>

<dynamic close statement> ::= <CLOSE> <dynamic cursor name>

<dynamic delete statement positioned> ::= <DELETE> <FROM> <target table> <WHERE> <CURRENT> <OF> <dynamic cursor name>

<dynamic update statement positioned> ::= <UPDATE> <target table> <SET> <set clause list> <WHERE> <CURRENT> <OF> <dynamic cursor name>

<preparable dynamic delete statement positioned> ::= <DELETE>                       <WHERE> <CURRENT> <OF>                <cursor name>
                                                   | <DELETE>                       <WHERE> <CURRENT> <OF> <scope option> <cursor name>
                                                   | <DELETE> <FROM> <target table> <WHERE> <CURRENT> <OF>                <cursor name>
                                                   | <DELETE> <FROM> <target table> <WHERE> <CURRENT> <OF> <scope option> <cursor name>

<preparable dynamic update statement positioned> ::= <UPDATE>                <SET> <set clause list> <WHERE> <CURRENT> <OF>                <cursor name>
                                                   | <UPDATE>                <SET> <set clause list> <WHERE> <CURRENT> <OF> <scope option> <cursor name>
                                                   | <UPDATE> <target table> <SET> <set clause list> <WHERE> <CURRENT> <OF>                <cursor name>
                                                   | <UPDATE> <target table> <SET> <set clause list> <WHERE> <CURRENT> <OF> <scope option> <cursor name>

<embedded SQL host program> ::=	<embedded SQL C program>

<embedded SQL statement> ::= <SQL prefix> <statement or declaration>
                           | <SQL prefix> <statement or declaration> <SQL terminator>

<statement or declaration> ::=
		<declare cursor>
	|	<dynamic declare cursor>
	|	<temporary table declaration>
	|	<embedded authorization declaration>
	|	<embedded path specification>
	|	<embedded transform group specification>
	|	<embedded collation specification>
	|	<embedded exception declaration>
	|	<SQL procedure statement>

<ampersand AND SQL AND left paren> ::= <ampersand> <SQL> <left paren>

<SQL prefix> ::= <EXEC> <SQL> | <ampersand AND SQL AND left paren>

<SQL terminator> ::= <END_EXEC> | <semicolon> | <right paren>

<embedded authorization declaration> ::= <DECLARE> <embedded authorization clause>

<embedded authorization clause> ::=
		<SCHEMA> <schema name>
	|	<AUTHORIZATION> <embedded authorization identifier>
	|	<AUTHORIZATION> <embedded authorization identifier> <FOR> <STATIC> <ONLY>
	|	<AUTHORIZATION> <embedded authorization identifier> <FOR> <STATIC> <AND> <DYNAMIC>
	|	<SCHEMA> <schema name> <AUTHORIZATION> <embedded authorization identifier>
	|	<SCHEMA> <schema name> <AUTHORIZATION> <embedded authorization identifier> <FOR> <STATIC> <ONLY>
	|	<SCHEMA> <schema name> <AUTHORIZATION> <embedded authorization identifier> <FOR> <STATIC> <AND> <DYNAMIC>

<embedded authorization identifier> ::= <module authorization identifier>

<embedded path specification> ::= <path specification>

<embedded transform group specification> ::= <transform group specification>

<embedded collation specification> ::= <module collations>

<host variable definition many> ::= <host variable definition>+

<embedded SQL declare section> ::=
	  <embedded SQL begin declare> <embedded SQL end declare>
	| <embedded SQL begin declare> <embedded character set declaration> <embedded SQL end declare>
	| <embedded SQL begin declare> <embedded character set declaration> <host variable definition many> <embedded SQL end declare>
	| <embedded SQL begin declare> <host variable definition many> <embedded SQL end declare>
	| <embedded SQL MUMPS declare>

<embedded character set declaration> ::= <SQL> <NAMES> <ARE> <character set specification>

<embedded SQL begin declare> ::= <SQL prefix> <BEGIN> <DECLARE> <SECTION>
                               | <SQL prefix> <BEGIN> <DECLARE> <SECTION> <SQL terminator>

<embedded SQL end declare> ::= <SQL prefix> <END> <DECLARE> <SECTION>
                             | <SQL prefix> <END> <DECLARE> <SECTION> <SQL terminator>

<embedded SQL MUMPS declare> ::= <SQL prefix> <BEGIN> <DECLARE> <SECTION> <END> <DECLARE> <SECTION> <SQL terminator>
	| <SQL prefix> <BEGIN> <DECLARE> <SECTION> <embedded character set declaration> <END> <DECLARE> <SECTION> <SQL terminator>
	| <SQL prefix> <BEGIN> <DECLARE> <SECTION> <embedded character set declaration> <host variable definition many> <END> <DECLARE> <SECTION> <SQL terminator>
	| <SQL prefix> <BEGIN> <DECLARE> <SECTION> <host variable definition many> <END> <DECLARE> <SECTION> <SQL terminator>

<host variable definition> ::= <C variable definition>

<embedded variable name> ::= <colon> <host identifier>

<host identifier> ::= <C host identifier>

<embedded exception declaration> ::= <WHENEVER> <condition> <condition action>

<condition> ::= <SQL condition>

<SQL condition> ::= <major category>
	|	<SQLSTATE> '(' <SQLSTATE class value> ')'
	|	<SQLSTATE> '(' <SQLSTATE class value> <comma> <SQLSTATE subclass value> ')'
	|	<CONSTRAINT> <constraint name>

<major category> ::= <SQLEXCEPTION> | <SQLWARNING> | <NOT> <FOUND>

<SQLSTATE class value> ::= <SQLSTATE char><SQLSTATE char>

<SQLSTATE subclass value> ::= <SQLSTATE char><SQLSTATE char><SQLSTATE char>

<SQLSTATE char> ::= <simple Latin upper case letter> | <digit>

<condition action> ::= <CONTINUE> | <go to>

<go to> ::= <GOTO> <goto target>
          | <GO> <TO> <goto target>

#
# Note: deviation from the grammar: we consider anything not starting with a digit nor <white space> and followed by anything not a <white space> to be the <host label identifier>
#                                   Any embedded grammar but the C language, with EXEC SQL keywords, is removed.
#
<goto target> ::=
		<host label identifier>
	|	<unsigned integer>

#
# We assume the host label identifier follows C convention
#

<host label identifier> ::= <C host identifier>

<embedded SQL C program> ::= <EXEC> <SQL>

<C variable definition> ::= <C variable specification> <semicolon>
	| <C storage class> <C variable specification> <semicolon>
	| <C storage class> <C class modifier> <C variable specification> <semicolon>
	| <C class modifier> <C variable specification> <semicolon>

<C variable specification> ::= <C numeric variable> | <C character variable> | <C derived variable>

<C storage class> ::= 'auto' | 'extern' | 'static'

<C class modifier> ::= 'const' | 'volatile'

<C host identifier AND MAYBE C initial value> ::= <C host identifier>
                                                | <C host identifier> <C initial value>

<C host identifier AND MAYBE C initial value list> ::= <C host identifier AND MAYBE C initial value>
                                                     | <C host identifier AND MAYBE C initial value> <comma> <C host identifier AND MAYBE C initial value>
<C numeric variable> ::= 'long' 'long' <C host identifier AND MAYBE C initial value list>
                       | 'long' <C host identifier AND MAYBE C initial value list>
                       | 'short' <C host identifier AND MAYBE C initial value list>
                       | 'float' <C host identifier AND MAYBE C initial value list>
                       | 'double' <C host identifier AND MAYBE C initial value list>

<C host identifier AND C array specification AND MAYBE C initial value> ::= <C host identifier> <C array specification>
                                                                          | <C host identifier> <C array specification> <C initial value>

<C host identifier AND C array specification AND MAYBE C initial value list> ::= <C host identifier AND C array specification AND MAYBE C initial value>
                                                                               | <C host identifier AND C array specification AND MAYBE C initial value list> <comma> <C host identifier AND C array specification AND MAYBE C initial value>

<C character variable> ::= <C character type>                                                      <C host identifier AND C array specification AND MAYBE C initial value list>
                         | <C character type> <CHARACTER> <SET> <character set specification>      <C host identifier AND C array specification AND MAYBE C initial value list>
                         | <C character type> <CHARACTER> <SET> <IS> <character set specification> <C host identifier AND C array specification AND MAYBE C initial value list>

<C character type> ::= 'char' | 'unsigned' 'char' | 'unsigned' 'short'

<C array specification> ::= <left bracket> <length> <right bracket>

<C L>          ~ [a-zA-Z_]
<C A>          ~ [a-zA-Z_0-9]
<C A_any>      ~ <C A>*
<C IDENTIFIER>          ~ <C L> <C A_any>

<C host identifier> ~ <C IDENTIFIER>

<C derived variable> ::=
		<C VARCHAR variable>
	|	<C NCHAR variable>
	|	<C NCHAR VARYING variable>
	|	<C CLOB variable>
	|	<C NCLOB variable>
	|	<C BLOB variable>
	|	<C user_defined type variable>
	|	<C CLOB locator variable>
	|	<C BLOB locator variable>
	|	<C array locator variable>
	|	<C multiset locator variable>
	|	<C user_defined type locator variable>
	|	<C REF variable>

<C VARCHAR variable> ::= <VARCHAR>                                                      <C host identifier AND C array specification AND MAYBE C initial value list>
                       | <VARCHAR> <CHARACTER> <SET>      <character set specification> <C host identifier AND C array specification AND MAYBE C initial value list>
                       | <VARCHAR> <CHARACTER> <SET> <IS> <character set specification> <C host identifier AND C array specification AND MAYBE C initial value list>

<C NCHAR variable> ::= <NCHAR>                                                      <C host identifier AND C array specification AND MAYBE C initial value list>
                     | <NCHAR> <CHARACTER> <SET>      <character set specification> <C host identifier AND C array specification AND MAYBE C initial value list>
                     | <NCHAR> <CHARACTER> <SET> <IS> <character set specification> <C host identifier AND C array specification AND MAYBE C initial value list>

<C NCHAR VARYING variable> ::= <NCHAR> <VARYING>                                                      <C host identifier AND C array specification AND MAYBE C initial value list>
                             | <NCHAR> <VARYING> <CHARACTER> <SET>      <character set specification> <C host identifier AND C array specification AND MAYBE C initial value list>
                             | <NCHAR> <VARYING> <CHARACTER> <SET> <IS> <character set specification> <C host identifier AND C array specification AND MAYBE C initial value list>

<C CLOB variable> ::= <SQL> <TYPE> <IS> <CLOB> <left paren> <large object length> <right paren>	                                                     <C host identifier AND MAYBE C initial value list>
                    | <SQL> <TYPE> <IS> <CLOB> <left paren> <large object length> <right paren>	<CHARACTER> <SET>      <character set specification> <C host identifier AND MAYBE C initial value list>
                    | <SQL> <TYPE> <IS> <CLOB> <left paren> <large object length> <right paren>	<CHARACTER> <SET> <IS> <character set specification> <C host identifier AND MAYBE C initial value list>

<C NCLOB variable> ::= <SQL> <TYPE> <IS> <NCLOB> <left paren> <large object length> <right paren>	                                                     <C host identifier AND MAYBE C initial value list>
                     | <SQL> <TYPE> <IS> <NCLOB> <left paren> <large object length> <right paren>	<CHARACTER> <SET>      <character set specification> <C host identifier AND MAYBE C initial value list>
                     | <SQL> <TYPE> <IS> <NCLOB> <left paren> <large object length> <right paren>	<CHARACTER> <SET> <IS> <character set specification> <C host identifier AND MAYBE C initial value list>

<C user_defined type variable> ::= <SQL> <TYPE> <IS> <path_resolved user_defined type name> <AS> <predefined type>	                                                     <C host identifier AND MAYBE C initial value list>
                                 | <SQL> <TYPE> <IS> <path_resolved user_defined type name> <AS> <predefined type>	<CHARACTER> <SET>      <character set specification> <C host identifier AND MAYBE C initial value list>
                                 | <SQL> <TYPE> <IS> <path_resolved user_defined type name> <AS> <predefined type>	<CHARACTER> <SET> <IS> <character set specification> <C host identifier AND MAYBE C initial value list>

<C BLOB variable> ::= <SQL> <TYPE> <IS> <BLOB> <left paren> <large object length> <right paren>	                                                     <C host identifier AND MAYBE C initial value list>
                    | <SQL> <TYPE> <IS> <BLOB> <left paren> <large object length> <right paren>	<CHARACTER> <SET>      <character set specification> <C host identifier AND MAYBE C initial value list>
                    | <SQL> <TYPE> <IS> <BLOB> <left paren> <large object length> <right paren>	<CHARACTER> <SET> <IS> <character set specification> <C host identifier AND MAYBE C initial value list>

<C CLOB locator variable> ::= <SQL> <TYPE> <IS> <CLOB> <AS> <LOCATOR> <C host identifier AND MAYBE C initial value list>

<C BLOB locator variable> ::= <SQL> <TYPE> <IS> <BLOB> <AS> <LOCATOR> <C host identifier AND MAYBE C initial value list>

<C array locator variable> ::= <SQL> <TYPE> <IS> <array type> <AS> <LOCATOR> <C host identifier AND MAYBE C initial value list>

<C multiset locator variable> ::= <SQL> <TYPE> <IS> <multiset type> <AS> <LOCATOR> <C host identifier AND MAYBE C initial value list>

<C user_defined type locator variable> ::= <SQL> <TYPE> <IS> <path_resolved user_defined type name> <AS> <LOCATOR> <C host identifier AND MAYBE C initial value list>

<C REF variable> ::= <SQL> <TYPE> <IS> <reference type>

<character representations> ::= <character representation>+

<C initial value> ::= <equals operator> <character representations>

<direct SQL statement> ::= <directly executable statement> <semicolon>

#
# <direct implementation_defined statement> is dropped
#

<directly executable statement> ::=
		<direct SQL data statement>
	|	<SQL schema statement>
	|	<SQL transaction statement>
	|	<SQL connection statement>
	|	<SQL session statement>

<direct SQL data statement> ::=
		<delete statement searched>
	|	<direct select statement multiple rows>
	|	<insert statement>
	|	<update statement searched>
	|	<merge statement>
	|	<temporary table declaration>

<direct select statement multiple rows> ::= <cursor specification>

<get diagnostics statement> ::= <GET> <DIAGNOSTICS> <SQL diagnostics information>

<SQL diagnostics information> ::= <statement information> | <condition information>

<statement information> ::= <statement information item>
                          | <statement information> <comma> <statement information item>

<statement information item> ::= <simple target specification> <equals operator> <statement information item name>

<statement information item name> ::=
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

<condition information items> ::= <condition information item>
                                | <condition information items> <comma> <condition information item>

<condition information> ::=
		<EXCEPTION> <condition number> <condition information items>
	|	<CONDITION> <condition number> <condition information items>

<condition information item> ::= <simple target specification> <equals operator> <condition information item name>

<condition information item name> ::=
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

<condition number> ::= <simple value specification>

#
# Case-insensitive versions of keywords
#
<A> ~ [Aa]
<ABS> ~ [Aa][Bb][Ss]
<ABSOLUTE> ~ [Aa][Bb][Ss][Oo][Ll][Uu][Tt][Ee]
<ACTION> ~ [Aa][Cc][Tt][Ii][Oo][Nn]
<ADD> ~ [Aa][Dd][Dd]
<ADMIN> ~ [Aa][Dd][Mm][Ii][Nn]
<AFTER> ~ [Aa][Ff][Tt][Ee][Rr]
<ALL> ~ [Aa][Ll][Ll]
<ALLOCATE> ~ [Aa][Ll][Ll][Oo][Cc][Aa][Tt][Ee]
<ALTER> ~ [Aa][Ll][Tt][Ee][Rr]
<ALWAYS> ~ [Aa][Ll][Ww][Aa][Yy][Ss]
<AND> ~ [Aa][Nn][Dd]
<ANY> ~ [Aa][Nn][Yy]
<ARE> ~ [Aa][Rr][Ee]
<ARRAY> ~ [Aa][Rr][Rr][Aa][Yy]
<AS> ~ [Aa][Ss]
<ASC> ~ [Aa][Ss][Cc]
<ASENSITIVE> ~ [Aa][Ss][Ee][Nn][Ss][Ii][Tt][Ii][Vv][Ee]
<ASSERTION> ~ [Aa][Ss][Ss][Ee][Rr][Tt][Ii][Oo][Nn]
<ASSIGNMENT> ~ [Aa][Ss][Ss][Ii][Gg][Nn][Mm][Ee][Nn][Tt]
<ASYMMETRIC> ~ [Aa][Ss][Yy][Mm][Mm][Ee][Tt][Rr][Ii][Cc]
<AT> ~ [Aa][Tt]
<ATOMIC> ~ [Aa][Tt][Oo][Mm][Ii][Cc]
<ATTRIBUTE> ~ [Aa][Tt][Tt][Rr][Ii][Bb][Uu][Tt][Ee]
<ATTRIBUTES> ~ [Aa][Tt][Tt][Rr][Ii][Bb][Uu][Tt][Ee][Ss]
<AUTHORIZATION> ~ [Aa][Uu][Tt][Hh][Oo][Rr][Ii][Zz][Aa][Tt][Ii][Oo][Nn]
<AVG> ~ [Aa][Vv][Gg]
<BEFORE> ~ [Bb][Ee][Ff][Oo][Rr][Ee]
<BEGIN> ~ [Bb][Ee][Gg][Ii][Nn]
<BERNOULLI> ~ [Bb][Ee][Rr][Nn][Oo][Uu][Ll][Ll][Ii]
<BETWEEN> ~ [Bb][Ee][Tt][Ww][Ee][Ee][Nn]
<BIGINT> ~ [Bb][Ii][Gg][Ii][Nn][Tt]
<BINARY> ~ [Bb][Ii][Nn][Aa][Rr][Yy]
<BLOB> ~ [Bb][Ll][Oo][Bb]
<BOOLEAN> ~ [Bb][Oo][Oo][Ll][Ee][Aa][Nn]
<BOTH> ~ [Bb][Oo][Tt][Hh]
<BREADTH> ~ [Bb][Rr][Ee][Aa][Dd][Tt][Hh]
<BY> ~ [Bb][Yy]
<C> ~ [Cc]
<CALL> ~ [Cc][Aa][Ll][Ll]
<CALLED> ~ [Cc][Aa][Ll][Ll][Ee][Dd]
<CARDINALITY> ~ [Cc][Aa][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy]
<CASCADE> ~ [Cc][Aa][Ss][Cc][Aa][Dd][Ee]
<CASCADED> ~ [Cc][Aa][Ss][Cc][Aa][Dd][Ee][Dd]
<CASE> ~ [Cc][Aa][Ss][Ee]
<CAST> ~ [Cc][Aa][Ss][Tt]
<CATALOG> ~ [Cc][Aa][Tt][Aa][Ll][Oo][Gg]
<CATALOG_NAME> ~ [Cc][Aa][Tt][Aa][Ll][Oo][Gg]'_'[Nn][Aa][Mm][Ee]
<CEIL> ~ [Cc][Ee][Ii][Ll]
<CEILING> ~ [Cc][Ee][Ii][Ll][Ii][Nn][Gg]
<CHAIN> ~ [Cc][Hh][Aa][Ii][Nn]
<CHAR> ~ [Cc][Hh][Aa][Rr]
<CHARACTER> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]
<CHARACTERISTICS> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr][Ii][Ss][Tt][Ii][Cc][Ss]
<CHARACTERS> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr][Ss]
<CHARACTER_LENGTH> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
<CHARACTER_SET_CATALOG> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]'_'[Ss][Ee][Tt]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
<CHARACTER_SET_NAME> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]'_'[Ss][Ee][Tt]'_'[Nn][Aa][Mm][Ee]
<CHARACTER_SET_SCHEMA> ~ [Cc][Hh][Aa][Rr][Aa][Cc][Tt][Ee][Rr]'_'[Ss][Ee][Tt]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
<CHAR_LENGTH> ~ [Cc][Hh][Aa][Rr]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
<CHECK> ~ [Cc][Hh][Ee][Cc][Kk]
<CHECKED> ~ [Cc][Hh][Ee][Cc][Kk][Ee][Dd]
<CLASS_ORIGIN> ~ [Cc][Ll][Aa][Ss][Ss]'_'[Oo][Rr][Ii][Gg][Ii][Nn]
<CLOB> ~ [Cc][Ll][Oo][Bb]
<CLOSE> ~ [Cc][Ll][Oo][Ss][Ee]
<COALESCE> ~ [Cc][Oo][Aa][Ll][Ee][Ss][Cc][Ee]
<CODE_UNITS> ~ [Cc][Oo][Dd][Ee]'_'[Uu][Nn][Ii][Tt][Ss]
<COLLATE> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ee]
<COLLATION> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]
<COLLATION_CATALOG> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
<COLLATION_NAME> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]'_'[Nn][Aa][Mm][Ee]
<COLLATION_SCHEMA> ~ [Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
<COLLECT> ~ [Cc][Oo][Ll][Ll][Ee][Cc][Tt]
<COLUMN> ~ [Cc][Oo][Ll][Uu][Mm][Nn]
<COLUMN_NAME> ~ [Cc][Oo][Ll][Uu][Mm][Nn]'_'[Nn][Aa][Mm][Ee]
<COMMAND_FUNCTION> ~ [Cc][Oo][Mm][Mm][Aa][Nn][Dd]'_'[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]
<COMMAND_FUNCTION_CODE> ~ [Cc][Oo][Mm][Mm][Aa][Nn][Dd]'_'[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]'_'[Cc][Oo][Dd][Ee]
<COMMIT> ~ [Cc][Oo][Mm][Mm][Ii][Tt]
<COMMITTED> ~ [Cc][Oo][Mm][Mm][Ii][Tt][Tt][Ee][Dd]
<CONDITION> ~ [Cc][Oo][Nn][Dd][Ii][Tt][Ii][Oo][Nn]
<CONDITION_NUMBER> ~ [Cc][Oo][Nn][Dd][Ii][Tt][Ii][Oo][Nn]'_'[Nn][Uu][Mm][Bb][Ee][Rr]
<CONNECT> ~ [Cc][Oo][Nn][Nn][Ee][Cc][Tt]
<CONNECTION> ~ [Cc][Oo][Nn][Nn][Ee][Cc][Tt][Ii][Oo][Nn]
<CONNECTION_NAME> ~ [Cc][Oo][Nn][Nn][Ee][Cc][Tt][Ii][Oo][Nn]'_'[Nn][Aa][Mm][Ee]
<CONSTRAINT> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]
<CONSTRAINTS> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt][Ss]
<CONSTRAINT_CATALOG> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
<CONSTRAINT_NAME> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]'_'[Nn][Aa][Mm][Ee]
<CONSTRAINT_SCHEMA> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Aa][Ii][Nn][Tt]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
<CONSTRUCTOR> ~ [Cc][Oo][Nn][Ss][Tt][Rr][Uu][Cc][Tt][Oo][Rr]
<CONTAINS> ~ [Cc][Oo][Nn][Tt][Aa][Ii][Nn][Ss]
<CONTINUE> ~ [Cc][Oo][Nn][Tt][Ii][Nn][Uu][Ee]
<CONVERT> ~ [Cc][Oo][Nn][Vv][Ee][Rr][Tt]
<CORR> ~ [Cc][Oo][Rr][Rr]
<CORRESPONDING> ~ [Cc][Oo][Rr][Rr][Ee][Ss][Pp][Oo][Nn][Dd][Ii][Nn][Gg]
<COUNT> ~ [Cc][Oo][Uu][Nn][Tt]
<COVAR_POP> ~ [Cc][Oo][Vv][Aa][Rr]'_'[Pp][Oo][Pp]
<COVAR_SAMP> ~ [Cc][Oo][Vv][Aa][Rr]'_'[Ss][Aa][Mm][Pp]
<CREATE> ~ [Cc][Rr][Ee][Aa][Tt][Ee]
<CROSS> ~ [Cc][Rr][Oo][Ss][Ss]
<CUBE> ~ [Cc][Uu][Bb][Ee]
<CUME_DIST> ~ [Cc][Uu][Mm][Ee]'_'[Dd][Ii][Ss][Tt]
<CURRENT> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]
<CURRENT_COLLATION> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Cc][Oo][Ll][Ll][Aa][Tt][Ii][Oo][Nn]
<CURRENT_DATE> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Dd][Aa][Tt][Ee]
<CURRENT_DEFAULT_TRANSFORM_GROUP> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Dd][Ee][Ff][Aa][Uu][Ll][Tt]'_'[Tt][Rr][Aa][Nn][Ss][Ff][Oo][Rr][Mm]'_'[Gg][Rr][Oo][Uu][Pp]
<CURRENT_PATH> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Pp][Aa][Tt][Hh]
<CURRENT_ROLE> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Rr][Oo][Ll][Ee]
<CURRENT_TIME> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Tt][Ii][Mm][Ee]
<CURRENT_TIMESTAMP> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Tt][Ii][Mm][Ee][Ss][Tt][Aa][Mm][Pp]
<CURRENT_TRANSFORM_GROUP_FOR_TYPE> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Tt][Rr][Aa][Nn][Ss][Ff][Oo][Rr][Mm]'_'[Gg][Rr][Oo][Uu][Pp]'_'[Ff][Oo][Rr]'_'[Tt][Yy][Pp][Ee]
<CURRENT_USER> ~ [Cc][Uu][Rr][Rr][Ee][Nn][Tt]'_'[Uu][Ss][Ee][Rr]
<CURSOR> ~ [Cc][Uu][Rr][Ss][Oo][Rr]
<CURSOR_NAME> ~ [Cc][Uu][Rr][Ss][Oo][Rr]'_'[Nn][Aa][Mm][Ee]
<CYCLE> ~ [Cc][Yy][Cc][Ll][Ee]
<DATA> ~ [Dd][Aa][Tt][Aa]
<DATE> ~ [Dd][Aa][Tt][Ee]
<DATETIME_INTERVAL_CODE> ~ [Dd][Aa][Tt][Ee][Tt][Ii][Mm][Ee]'_'[Ii][Nn][Tt][Ee][Rr][Vv][Aa][Ll]'_'[Cc][Oo][Dd][Ee]
<DATETIME_INTERVAL_PRECISION> ~ [Dd][Aa][Tt][Ee][Tt][Ii][Mm][Ee]'_'[Ii][Nn][Tt][Ee][Rr][Vv][Aa][Ll]'_'[Pp][Rr][Ee][Cc][Ii][Ss][Ii][Oo][Nn]
<DAY> ~ [Dd][Aa][Yy]
<DEALLOCATE> ~ [Dd][Ee][Aa][Ll][Ll][Oo][Cc][Aa][Tt][Ee]
<DEC> ~ [Dd][Ee][Cc]
<DECIMAL> ~ [Dd][Ee][Cc][Ii][Mm][Aa][Ll]
<DECLARE> ~ [Dd][Ee][Cc][Ll][Aa][Rr][Ee]
<DEFAULT> ~ [Dd][Ee][Ff][Aa][Uu][Ll][Tt]
<DEFAULTS> ~ [Dd][Ee][Ff][Aa][Uu][Ll][Tt][Ss]
<DEFERRABLE> ~ [Dd][Ee][Ff][Ee][Rr][Rr][Aa][Bb][Ll][Ee]
<DEFERRED> ~ [Dd][Ee][Ff][Ee][Rr][Rr][Ee][Dd]
<DEFINED> ~ [Dd][Ee][Ff][Ii][Nn][Ee][Dd]
<DEFINER> ~ [Dd][Ee][Ff][Ii][Nn][Ee][Rr]
<DEGREE> ~ [Dd][Ee][Gg][Rr][Ee][Ee]
<DELETE> ~ [Dd][Ee][Ll][Ee][Tt][Ee]
<DENSE_RANK> ~ [Dd][Ee][Nn][Ss][Ee]'_'[Rr][Aa][Nn][Kk]
<DEPTH> ~ [Dd][Ee][Pp][Tt][Hh]
<DEREF> ~ [Dd][Ee][Rr][Ee][Ff]
<DERIVED> ~ [Dd][Ee][Rr][Ii][Vv][Ee][Dd]
<DESC> ~ [Dd][Ee][Ss][Cc]
<DESCRIBE> ~ [Dd][Ee][Ss][Cc][Rr][Ii][Bb][Ee]
<DESCRIPTOR> ~ [Dd][Ee][Ss][Cc][Rr][Ii][Pp][Tt][Oo][Rr]
<DETERMINISTIC> ~ [Dd][Ee][Tt][Ee][Rr][Mm][Ii][Nn][Ii][Ss][Tt][Ii][Cc]
<DIAGNOSTICS> ~ [Dd][Ii][Aa][Gg][Nn][Oo][Ss][Tt][Ii][Cc][Ss]
<DISCONNECT> ~ [Dd][Ii][Ss][Cc][Oo][Nn][Nn][Ee][Cc][Tt]
<DISPATCH> ~ [Dd][Ii][Ss][Pp][Aa][Tt][Cc][Hh]
<DISTINCT> ~ [Dd][Ii][Ss][Tt][Ii][Nn][Cc][Tt]
<DOMAIN> ~ [Dd][Oo][Mm][Aa][Ii][Nn]
<DOUBLE> ~ [Dd][Oo][Uu][Bb][Ll][Ee]
<DROP> ~ [Dd][Rr][Oo][Pp]
<DYNAMIC> ~ [Dd][Yy][Nn][Aa][Mm][Ii][Cc]
<DYNAMIC_FUNCTION> ~ [Dd][Yy][Nn][Aa][Mm][Ii][Cc]'_'[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]
<DYNAMIC_FUNCTION_CODE> ~ [Dd][Yy][Nn][Aa][Mm][Ii][Cc]'_'[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]'_'[Cc][Oo][Dd][Ee]
<E> ~ [Ee]
<EACH> ~ [Ee][Aa][Cc][Hh]
<ELEMENT> ~ [Ee][Ll][Ee][Mm][Ee][Nn][Tt]
<ELSE> ~ [Ee][Ll][Ss][Ee]
<END> ~ [Ee][Nn][Dd]
<END_EXEC> ~ [Ee][Nn][Dd]'-'[Ee][Xx][Ee][Cc]
<EQUALS> ~ [Ee][Qq][Uu][Aa][Ll][Ss]
<ESCAPE> ~ [Ee][Ss][Cc][Aa][Pp][Ee]
<EVERY> ~ [Ee][Vv][Ee][Rr][Yy]
<EXCEPT> ~ [Ee][Xx][Cc][Ee][Pp][Tt]
<EXCEPTION> ~ [Ee][Xx][Cc][Ee][Pp][Tt][Ii][Oo][Nn]
<EXCLUDE> ~ [Ee][Xx][Cc][Ll][Uu][Dd][Ee]
<EXCLUDING> ~ [Ee][Xx][Cc][Ll][Uu][Dd][Ii][Nn][Gg]
<EXEC> ~ [Ee][Xx][Ee][Cc]
<EXECUTE> ~ [Ee][Xx][Ee][Cc][Uu][Tt][Ee]
<EXISTS> ~ [Ee][Xx][Ii][Ss][Tt][Ss]
<EXP> ~ [Ee][Xx][Pp]
<EXTERNAL> ~ [Ee][Xx][Tt][Ee][Rr][Nn][Aa][Ll]
<EXTRACT> ~ [Ee][Xx][Tt][Rr][Aa][Cc][Tt]
<FALSE> ~ [Ff][Aa][Ll][Ss][Ee]
<FETCH> ~ [Ff][Ee][Tt][Cc][Hh]
<FILTER> ~ [Ff][Ii][Ll][Tt][Ee][Rr]
<FINAL> ~ [Ff][Ii][Nn][Aa][Ll]
<FIRST> ~ [Ff][Ii][Rr][Ss][Tt]
<FLOAT> ~ [Ff][Ll][Oo][Aa][Tt]
<FLOOR> ~ [Ff][Ll][Oo][Oo][Rr]
<FOLLOWING> ~ [Ff][Oo][Ll][Ll][Oo][Ww][Ii][Nn][Gg]
<FOR> ~ [Ff][Oo][Rr]
<FOREIGN> ~ [Ff][Oo][Rr][Ee][Ii][Gg][Nn]
<FOUND> ~ [Ff][Oo][Uu][Nn][Dd]
<FREE> ~ [Ff][Rr][Ee][Ee]
<FROM> ~ [Ff][Rr][Oo][Mm]
<FULL> ~ [Ff][Uu][Ll][Ll]
<FUNCTION> ~ [Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]
<FUSION> ~ [Ff][Uu][Ss][Ii][Oo][Nn]
<GENERAL> ~ [Gg][Ee][Nn][Ee][Rr][Aa][Ll]
<GENERATED> ~ [Gg][Ee][Nn][Ee][Rr][Aa][Tt][Ee][Dd]
<GET> ~ [Gg][Ee][Tt]
<GLOBAL> ~ [Gg][Ll][Oo][Bb][Aa][Ll]
<GO> ~ [Gg][Oo]
<GOTO> ~ [Gg][Oo][Tt][Oo]
<GRANT> ~ [Gg][Rr][Aa][Nn][Tt]
<GRANTED> ~ [Gg][Rr][Aa][Nn][Tt][Ee][Dd]
<GROUP> ~ [Gg][Rr][Oo][Uu][Pp]
<GROUPING> ~ [Gg][Rr][Oo][Uu][Pp][Ii][Nn][Gg]
<HAVING> ~ [Hh][Aa][Vv][Ii][Nn][Gg]
<HIERARCHY> ~ [Hh][Ii][Ee][Rr][Aa][Rr][Cc][Hh][Yy]
<HOLD> ~ [Hh][Oo][Ll][Dd]
<HOUR> ~ [Hh][Oo][Uu][Rr]
<IDENTITY> ~ [Ii][Dd][Ee][Nn][Tt][Ii][Tt][Yy]
<IMMEDIATE> ~ [Ii][Mm][Mm][Ee][Dd][Ii][Aa][Tt][Ee]
<IMPLEMENTATION> ~ [Ii][Mm][Pp][Ll][Ee][Mm][Ee][Nn][Tt][Aa][Tt][Ii][Oo][Nn]
<IN> ~ [Ii][Nn]
<INCLUDING> ~ [Ii][Nn][Cc][Ll][Uu][Dd][Ii][Nn][Gg]
<INCREMENT> ~ [Ii][Nn][Cc][Rr][Ee][Mm][Ee][Nn][Tt]
<INDICATOR> ~ [Ii][Nn][Dd][Ii][Cc][Aa][Tt][Oo][Rr]
<INITIALLY> ~ [Ii][Nn][Ii][Tt][Ii][Aa][Ll][Ll][Yy]
<INNER> ~ [Ii][Nn][Nn][Ee][Rr]
<INOUT> ~ [Ii][Nn][Oo][Uu][Tt]
<INPUT> ~ [Ii][Nn][Pp][Uu][Tt]
<INSENSITIVE> ~ [Ii][Nn][Ss][Ee][Nn][Ss][Ii][Tt][Ii][Vv][Ee]
<INSERT> ~ [Ii][Nn][Ss][Ee][Rr][Tt]
<INSTANCE> ~ [Ii][Nn][Ss][Tt][Aa][Nn][Cc][Ee]
<INSTANTIABLE> ~ [Ii][Nn][Ss][Tt][Aa][Nn][Tt][Ii][Aa][Bb][Ll][Ee]
<INT> ~ [Ii][Nn][Tt]
<INTEGER> ~ [Ii][Nn][Tt][Ee][Gg][Ee][Rr]
<INTERSECT> ~ [Ii][Nn][Tt][Ee][Rr][Ss][Ee][Cc][Tt]
<INTERSECTION> ~ [Ii][Nn][Tt][Ee][Rr][Ss][Ee][Cc][Tt][Ii][Oo][Nn]
<INTERVAL> ~ [Ii][Nn][Tt][Ee][Rr][Vv][Aa][Ll]
<INTO> ~ [Ii][Nn][Tt][Oo]
<INVOKER> ~ [Ii][Nn][Vv][Oo][Kk][Ee][Rr]
<IS> ~ [Ii][Ss]
<ISOLATION> ~ [Ii][Ss][Oo][Ll][Aa][Tt][Ii][Oo][Nn]
<JOIN> ~ [Jj][Oo][Ii][Nn]
<KEY> ~ [Kk][Ee][Yy]
<KEY_MEMBER> ~ [Kk][Ee][Yy]'_'[Mm][Ee][Mm][Bb][Ee][Rr]
<KEY_TYPE> ~ [Kk][Ee][Yy]'_'[Tt][Yy][Pp][Ee]
<LANGUAGE> ~ [Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee]
<LARGE> ~ [Ll][Aa][Rr][Gg][Ee]
<LAST> ~ [Ll][Aa][Ss][Tt]
<LATERAL> ~ [Ll][Aa][Tt][Ee][Rr][Aa][Ll]
<LEADING> ~ [Ll][Ee][Aa][Dd][Ii][Nn][Gg]
<LEFT> ~ [Ll][Ee][Ff][Tt]
<LENGTH> ~ [Ll][Ee][Nn][Gg][Tt][Hh]
<LEVEL> ~ [Ll][Ee][Vv][Ee][Ll]
<LIKE> ~ [Ll][Ii][Kk][Ee]
<LN> ~ [Ll][Nn]
<LOCAL> ~ [Ll][Oo][Cc][Aa][Ll]
<LOCALTIME> ~ [Ll][Oo][Cc][Aa][Ll][Tt][Ii][Mm][Ee]
<LOCALTIMESTAMP> ~ [Ll][Oo][Cc][Aa][Ll][Tt][Ii][Mm][Ee][Ss][Tt][Aa][Mm][Pp]
<LOCATOR> ~ [Ll][Oo][Cc][Aa][Tt][Oo][Rr]
<LOWER> ~ [Ll][Oo][Ww][Ee][Rr]
<MAP> ~ [Mm][Aa][Pp]
<MATCH> ~ [Mm][Aa][Tt][Cc][Hh]
<MATCHED> ~ [Mm][Aa][Tt][Cc][Hh][Ee][Dd]
<MAX> ~ [Mm][Aa][Xx]
<MAXVALUE> ~ [Mm][Aa][Xx][Vv][Aa][Ll][Uu][Ee]
<MEMBER> ~ [Mm][Ee][Mm][Bb][Ee][Rr]
<MERGE> ~ [Mm][Ee][Rr][Gg][Ee]
<MESSAGE_LENGTH> ~ [Mm][Ee][Ss][Ss][Aa][Gg][Ee]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
<MESSAGE_OCTET_LENGTH> ~ [Mm][Ee][Ss][Ss][Aa][Gg][Ee]'_'[Oo][Cc][Tt][Ee][Tt]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
<MESSAGE_TEXT> ~ [Mm][Ee][Ss][Ss][Aa][Gg][Ee]'_'[Tt][Ee][Xx][Tt]
<METHOD> ~ [Mm][Ee][Tt][Hh][Oo][Dd]
<MIN> ~ [Mm][Ii][Nn]
<MINUTE> ~ [Mm][Ii][Nn][Uu][Tt][Ee]
<MINVALUE> ~ [Mm][Ii][Nn][Vv][Aa][Ll][Uu][Ee]
<MOD> ~ [Mm][Oo][Dd]
<MODIFIES> ~ [Mm][Oo][Dd][Ii][Ff][Ii][Ee][Ss]
<MODULE> ~ [Mm][Oo][Dd][Uu][Ll][Ee]
<MONTH> ~ [Mm][Oo][Nn][Tt][Hh]
<MORE> ~ [Mm][Oo][Rr][Ee]
<MULTISET> ~ [Mm][Uu][Ll][Tt][Ii][Ss][Ee][Tt]
<N> ~ [Nn]
<NAME> ~ [Nn][Aa][Mm][Ee]
<NAMES> ~ [Nn][Aa][Mm][Ee][Ss]
<NATIONAL> ~ [Nn][Aa][Tt][Ii][Oo][Nn][Aa][Ll]
<NATURAL> ~ [Nn][Aa][Tt][Uu][Rr][Aa][Ll]
<NCHAR> ~ [Nn][Cc][Hh][Aa][Rr]
<NCLOB> ~ [Nn][Cc][Ll][Oo][Bb]
<NESTING> ~ [Nn][Ee][Ss][Tt][Ii][Nn][Gg]
<NEW> ~ [Nn][Ee][Ww]
<NEXT> ~ [Nn][Ee][Xx][Tt]
<NO> ~ [Nn][Oo]
<NONE> ~ [Nn][Oo][Nn][Ee]
<NORMALIZE> ~ [Nn][Oo][Rr][Mm][Aa][Ll][Ii][Zz][Ee]
<NORMALIZED> ~ [Nn][Oo][Rr][Mm][Aa][Ll][Ii][Zz][Ee][Dd]
<NOT> ~ [Nn][Oo][Tt]
<NULL> ~ [Nn][Uu][Ll][Ll]
<NULLABLE> ~ [Nn][Uu][Ll][Ll][Aa][Bb][Ll][Ee]
<NULLIF> ~ [Nn][Uu][Ll][Ll][Ii][Ff]
<NULLS> ~ [Nn][Uu][Ll][Ll][Ss]
<NUMBER> ~ [Nn][Uu][Mm][Bb][Ee][Rr]
<NUMERIC> ~ [Nn][Uu][Mm][Ee][Rr][Ii][Cc]
<OBJECT> ~ [Oo][Bb][Jj][Ee][Cc][Tt]
<OCTETS> ~ [Oo][Cc][Tt][Ee][Tt][Ss]
<OCTET_LENGTH> ~ [Oo][Cc][Tt][Ee][Tt]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
<OF> ~ [Oo][Ff]
<OLD> ~ [Oo][Ll][Dd]
<ON> ~ [Oo][Nn]
<ONLY> ~ [Oo][Nn][Ll][Yy]
<OPEN> ~ [Oo][Pp][Ee][Nn]
<OPTION> ~ [Oo][Pp][Tt][Ii][Oo][Nn]
<OPTIONS> ~ [Oo][Pp][Tt][Ii][Oo][Nn][Ss]
<OR> ~ [Oo][Rr]
<ORDER> ~ [Oo][Rr][Dd][Ee][Rr]
<ORDERING> ~ [Oo][Rr][Dd][Ee][Rr][Ii][Nn][Gg]
<ORDINALITY> ~ [Oo][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy]
<OTHERS> ~ [Oo][Tt][Hh][Ee][Rr][Ss]
<OUT> ~ [Oo][Uu][Tt]
<OUTER> ~ [Oo][Uu][Tt][Ee][Rr]
<OUTPUT> ~ [Oo][Uu][Tt][Pp][Uu][Tt]
<OVER> ~ [Oo][Vv][Ee][Rr]
<OVERLAPS> ~ [Oo][Vv][Ee][Rr][Ll][Aa][Pp][Ss]
<OVERLAY> ~ [Oo][Vv][Ee][Rr][Ll][Aa][Yy]
<OVERRIDING> ~ [Oo][Vv][Ee][Rr][Rr][Ii][Dd][Ii][Nn][Gg]
<PAD> ~ [Pp][Aa][Dd]
<PARAMETER> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]
<PARAMETER_MODE> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Mm][Oo][Dd][Ee]
<PARAMETER_NAME> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Nn][Aa][Mm][Ee]
<PARAMETER_ORDINAL_POSITION> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Oo][Rr][Dd][Ii][Nn][Aa][Ll]'_'[Pp][Oo][Ss][Ii][Tt][Ii][Oo][Nn]
<PARAMETER_SPECIFIC_CATALOG> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
<PARAMETER_SPECIFIC_NAME> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]'_'[Nn][Aa][Mm][Ee]
<PARAMETER_SPECIFIC_SCHEMA> ~ [Pp][Aa][Rr][Aa][Mm][Ee][Tt][Ee][Rr]'_'[Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
<PARTIAL> ~ [Pp][Aa][Rr][Tt][Ii][Aa][Ll]
<PARTITION> ~ [Pp][Aa][Rr][Tt][Ii][Tt][Ii][Oo][Nn]
<PATH> ~ [Pp][Aa][Tt][Hh]
<PERCENTILE_CONT> ~ [Pp][Ee][Rr][Cc][Ee][Nn][Tt][Ii][Ll][Ee]'_'[Cc][Oo][Nn][Tt]
<PERCENTILE_DISC> ~ [Pp][Ee][Rr][Cc][Ee][Nn][Tt][Ii][Ll][Ee]'_'[Dd][Ii][Ss][Cc]
<PERCENT_RANK> ~ [Pp][Ee][Rr][Cc][Ee][Nn][Tt]'_'[Rr][Aa][Nn][Kk]
<PLACING> ~ [Pp][Ll][Aa][Cc][Ii][Nn][Gg]
<POSITION> ~ [Pp][Oo][Ss][Ii][Tt][Ii][Oo][Nn]
<POWER> ~ [Pp][Oo][Ww][Ee][Rr]
<PRECEDING> ~ [Pp][Rr][Ee][Cc][Ee][Dd][Ii][Nn][Gg]
<PRECISION> ~ [Pp][Rr][Ee][Cc][Ii][Ss][Ii][Oo][Nn]
<PREPARE> ~ [Pp][Rr][Ee][Pp][Aa][Rr][Ee]
<PRESERVE> ~ [Pp][Rr][Ee][Ss][Ee][Rr][Vv][Ee]
<PRIMARY> ~ [Pp][Rr][Ii][Mm][Aa][Rr][Yy]
<PRIOR> ~ [Pp][Rr][Ii][Oo][Rr]
<PRIVILEGES> ~ [Pp][Rr][Ii][Vv][Ii][Ll][Ee][Gg][Ee][Ss]
<PROCEDURE> ~ [Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]
<PUBLIC> ~ [Pp][Uu][Bb][Ll][Ii][Cc]
<RANGE> ~ [Rr][Aa][Nn][Gg][Ee]
<RANK> ~ [Rr][Aa][Nn][Kk]
<READ> ~ [Rr][Ee][Aa][Dd]
<READS> ~ [Rr][Ee][Aa][Dd][Ss]
<REAL> ~ [Rr][Ee][Aa][Ll]
<RECURSIVE> ~ [Rr][Ee][Cc][Uu][Rr][Ss][Ii][Vv][Ee]
<REF> ~ [Rr][Ee][Ff]
<REFERENCES> ~ [Rr][Ee][Ff][Ee][Rr][Ee][Nn][Cc][Ee][Ss]
<REFERENCING> ~ [Rr][Ee][Ff][Ee][Rr][Ee][Nn][Cc][Ii][Nn][Gg]
<REGR_AVGX> ~ [Rr][Ee][Gg][Rr]'_'[Aa][Vv][Gg][Xx]
<REGR_AVGY> ~ [Rr][Ee][Gg][Rr]'_'[Aa][Vv][Gg][Yy]
<REGR_COUNT> ~ [Rr][Ee][Gg][Rr]'_'[Cc][Oo][Uu][Nn][Tt]
<REGR_INTERCEPT> ~ [Rr][Ee][Gg][Rr]'_'[Ii][Nn][Tt][Ee][Rr][Cc][Ee][Pp][Tt]
<REGR_R2> ~ [Rr][Ee][Gg][Rr]'_'[Rr]'2'
<REGR_SLOPE> ~ [Rr][Ee][Gg][Rr]'_'[Ss][Ll][Oo][Pp][Ee]
<REGR_SXX> ~ [Rr][Ee][Gg][Rr]'_'[Ss][Xx][Xx]
<REGR_SXY> ~ [Rr][Ee][Gg][Rr]'_'[Ss][Xx][Yy]
<REGR_SYY> ~ [Rr][Ee][Gg][Rr]'_'[Ss][Yy][Yy]
<RELATIVE> ~ [Rr][Ee][Ll][Aa][Tt][Ii][Vv][Ee]
<RELEASE> ~ [Rr][Ee][Ll][Ee][Aa][Ss][Ee]
<REPEATABLE> ~ [Rr][Ee][Pp][Ee][Aa][Tt][Aa][Bb][Ll][Ee]
<RESTART> ~ [Rr][Ee][Ss][Tt][Aa][Rr][Tt]
<RESTRICT> ~ [Rr][Ee][Ss][Tt][Rr][Ii][Cc][Tt]
<RESULT> ~ [Rr][Ee][Ss][Uu][Ll][Tt]
<RETURN> ~ [Rr][Ee][Tt][Uu][Rr][Nn]
<RETURNED_CARDINALITY> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ee][Dd]'_'[Cc][Aa][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy]
<RETURNED_LENGTH> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ee][Dd]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
<RETURNED_OCTET_LENGTH> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ee][Dd]'_'[Oo][Cc][Tt][Ee][Tt]'_'[Ll][Ee][Nn][Gg][Tt][Hh]
<RETURNED_SQLSTATE> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ee][Dd]'_'[Ss][Qq][Ll][Ss][Tt][Aa][Tt][Ee]
<RETURNS> ~ [Rr][Ee][Tt][Uu][Rr][Nn][Ss]
<REVOKE> ~ [Rr][Ee][Vv][Oo][Kk][Ee]
<RIGHT> ~ [Rr][Ii][Gg][Hh][Tt]
<ROLE> ~ [Rr][Oo][Ll][Ee]
<ROLLBACK> ~ [Rr][Oo][Ll][Ll][Bb][Aa][Cc][Kk]
<ROLLUP> ~ [Rr][Oo][Ll][Ll][Uu][Pp]
<ROUTINE> ~ [Rr][Oo][Uu][Tt][Ii][Nn][Ee]
<ROUTINE_CATALOG> ~ [Rr][Oo][Uu][Tt][Ii][Nn][Ee]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
<ROUTINE_NAME> ~ [Rr][Oo][Uu][Tt][Ii][Nn][Ee]'_'[Nn][Aa][Mm][Ee]
<ROUTINE_SCHEMA> ~ [Rr][Oo][Uu][Tt][Ii][Nn][Ee]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
<ROW> ~ [Rr][Oo][Ww]
<ROWS> ~ [Rr][Oo][Ww][Ss]
<ROW_COUNT> ~ [Rr][Oo][Ww]'_'[Cc][Oo][Uu][Nn][Tt]
<ROW_NUMBER> ~ [Rr][Oo][Ww]'_'[Nn][Uu][Mm][Bb][Ee][Rr]
<SAVEPOINT> ~ [Ss][Aa][Vv][Ee][Pp][Oo][Ii][Nn][Tt]
<SCALE> ~ [Ss][Cc][Aa][Ll][Ee]
<SCHEMA> ~ [Ss][Cc][Hh][Ee][Mm][Aa]
<SCHEMA_NAME> ~ [Ss][Cc][Hh][Ee][Mm][Aa]'_'[Nn][Aa][Mm][Ee]
<SCOPE> ~ [Ss][Cc][Oo][Pp][Ee]
<SCOPE_CATALOG> ~ [Ss][Cc][Oo][Pp][Ee]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
<SCOPE_NAME> ~ [Ss][Cc][Oo][Pp][Ee]'_'[Nn][Aa][Mm][Ee]
<SCOPE_SCHEMA> ~ [Ss][Cc][Oo][Pp][Ee]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
<SCROLL> ~ [Ss][Cc][Rr][Oo][Ll][Ll]
<SEARCH> ~ [Ss][Ee][Aa][Rr][Cc][Hh]
<SECOND> ~ [Ss][Ee][Cc][Oo][Nn][Dd]
<SECTION> ~ [Ss][Ee][Cc][Tt][Ii][Oo][Nn]
<SECURITY> ~ [Ss][Ee][Cc][Uu][Rr][Ii][Tt][Yy]
<SELECT> ~ [Ss][Ee][Ll][Ee][Cc][Tt]
<SELF> ~ [Ss][Ee][Ll][Ff]
<SENSITIVE> ~ [Ss][Ee][Nn][Ss][Ii][Tt][Ii][Vv][Ee]
<SEQUENCE> ~ [Ss][Ee][Qq][Uu][Ee][Nn][Cc][Ee]
<SERIALIZABLE> ~ [Ss][Ee][Rr][Ii][Aa][Ll][Ii][Zz][Aa][Bb][Ll][Ee]
<SERVER_NAME> ~ [Ss][Ee][Rr][Vv][Ee][Rr]'_'[Nn][Aa][Mm][Ee]
<SESSION> ~ [Ss][Ee][Ss][Ss][Ii][Oo][Nn]
<SESSION_USER> ~ [Ss][Ee][Ss][Ss][Ii][Oo][Nn]'_'[Uu][Ss][Ee][Rr]
<SET> ~ [Ss][Ee][Tt]
<SETS> ~ [Ss][Ee][Tt][Ss]
<SIMILAR> ~ [Ss][Ii][Mm][Ii][Ll][Aa][Rr]
<SIMPLE> ~ [Ss][Ii][Mm][Pp][Ll][Ee]
<SIZE> ~ [Ss][Ii][Zz][Ee]
<SMALLINT> ~ [Ss][Mm][Aa][Ll][Ll][Ii][Nn][Tt]
<SOME> ~ [Ss][Oo][Mm][Ee]
<SOURCE> ~ [Ss][Oo][Uu][Rr][Cc][Ee]
<SPACE> ~ [Ss][Pp][Aa][Cc][Ee]
<SPECIFIC> ~ [Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]
<SPECIFICTYPE> ~ [Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc][Tt][Yy][Pp][Ee]
<SPECIFIC_NAME> ~ [Ss][Pp][Ee][Cc][Ii][Ff][Ii][Cc]'_'[Nn][Aa][Mm][Ee]
<SQL> ~ [Ss][Qq][Ll]
<SQLEXCEPTION> ~ [Ss][Qq][Ll][Ee][Xx][Cc][Ee][Pp][Tt][Ii][Oo][Nn]
<SQLSTATE> ~ [Ss][Qq][Ll][Ss][Tt][Aa][Tt][Ee]
<SQLWARNING> ~ [Ss][Qq][Ll][Ww][Aa][Rr][Nn][Ii][Nn][Gg]
<SQRT> ~ [Ss][Qq][Rr][Tt]
<START> ~ [Ss][Tt][Aa][Rr][Tt]
<STATE> ~ [Ss][Tt][Aa][Tt][Ee]
<STATEMENT> ~ [Ss][Tt][Aa][Tt][Ee][Mm][Ee][Nn][Tt]
<STATIC> ~ [Ss][Tt][Aa][Tt][Ii][Cc]
<STDDEV_POP> ~ [Ss][Tt][Dd][Dd][Ee][Vv]'_'[Pp][Oo][Pp]
<STDDEV_SAMP> ~ [Ss][Tt][Dd][Dd][Ee][Vv]'_'[Ss][Aa][Mm][Pp]
<STRUCTURE> ~ [Ss][Tt][Rr][Uu][Cc][Tt][Uu][Rr][Ee]
<STYLE> ~ [Ss][Tt][Yy][Ll][Ee]
<SUBCLASS_ORIGIN> ~ [Ss][Uu][Bb][Cc][Ll][Aa][Ss][Ss]'_'[Oo][Rr][Ii][Gg][Ii][Nn]
<SUBMULTISET> ~ [Ss][Uu][Bb][Mm][Uu][Ll][Tt][Ii][Ss][Ee][Tt]
<SUBSTRING> ~ [Ss][Uu][Bb][Ss][Tt][Rr][Ii][Nn][Gg]
<SUM> ~ [Ss][Uu][Mm]
<SYMMETRIC> ~ [Ss][Yy][Mm][Mm][Ee][Tt][Rr][Ii][Cc]
<SYSTEM> ~ [Ss][Yy][Ss][Tt][Ee][Mm]
<SYSTEM_USER> ~ [Ss][Yy][Ss][Tt][Ee][Mm]'_'[Uu][Ss][Ee][Rr]
<TABLE> ~ [Tt][Aa][Bb][Ll][Ee]
<TABLESAMPLE> ~ [Tt][Aa][Bb][Ll][Ee][Ss][Aa][Mm][Pp][Ll][Ee]
<TABLE_NAME> ~ [Tt][Aa][Bb][Ll][Ee]'_'[Nn][Aa][Mm][Ee]
<TEMPORARY> ~ [Tt][Ee][Mm][Pp][Oo][Rr][Aa][Rr][Yy]
<THEN> ~ [Tt][Hh][Ee][Nn]
<TIES> ~ [Tt][Ii][Ee][Ss]
<TIME> ~ [Tt][Ii][Mm][Ee]
<TIMESTAMP> ~ [Tt][Ii][Mm][Ee][Ss][Tt][Aa][Mm][Pp]
<TIMEZONE_HOUR> ~ [Tt][Ii][Mm][Ee][Zz][Oo][Nn][Ee]'_'[Hh][Oo][Uu][Rr]
<TIMEZONE_MINUTE> ~ [Tt][Ii][Mm][Ee][Zz][Oo][Nn][Ee]'_'[Mm][Ii][Nn][Uu][Tt][Ee]
<TO> ~ [Tt][Oo]
<TOP_LEVEL_COUNT> ~ [Tt][Oo][Pp]'_'[Ll][Ee][Vv][Ee][Ll]'_'[Cc][Oo][Uu][Nn][Tt]
<TRAILING> ~ [Tt][Rr][Aa][Ii][Ll][Ii][Nn][Gg]
<TRANSACTION> ~ [Tt][Rr][Aa][Nn][Ss][Aa][Cc][Tt][Ii][Oo][Nn]
<TRANSACTIONS_COMMITTED> ~ [Tt][Rr][Aa][Nn][Ss][Aa][Cc][Tt][Ii][Oo][Nn][Ss]'_'[Cc][Oo][Mm][Mm][Ii][Tt][Tt][Ee][Dd]
<TRANSACTIONS_ROLLED_BACK> ~ [Tt][Rr][Aa][Nn][Ss][Aa][Cc][Tt][Ii][Oo][Nn][Ss]'_'[Rr][Oo][Ll][Ll][Ee][Dd]'_'[Bb][Aa][Cc][Kk]
<TRANSACTION_ACTIVE> ~ [Tt][Rr][Aa][Nn][Ss][Aa][Cc][Tt][Ii][Oo][Nn]'_'[Aa][Cc][Tt][Ii][Vv][Ee]
<TRANSFORM> ~ [Tt][Rr][Aa][Nn][Ss][Ff][Oo][Rr][Mm]
<TRANSFORMS> ~ [Tt][Rr][Aa][Nn][Ss][Ff][Oo][Rr][Mm][Ss]
<TRANSLATE> ~ [Tt][Rr][Aa][Nn][Ss][Ll][Aa][Tt][Ee]
<TRANSLATION> ~ [Tt][Rr][Aa][Nn][Ss][Ll][Aa][Tt][Ii][Oo][Nn]
<TREAT> ~ [Tt][Rr][Ee][Aa][Tt]
<TRIGGER> ~ [Tt][Rr][Ii][Gg][Gg][Ee][Rr]
<TRIGGER_CATALOG> ~ [Tt][Rr][Ii][Gg][Gg][Ee][Rr]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
<TRIGGER_NAME> ~ [Tt][Rr][Ii][Gg][Gg][Ee][Rr]'_'[Nn][Aa][Mm][Ee]
<TRIGGER_SCHEMA> ~ [Tt][Rr][Ii][Gg][Gg][Ee][Rr]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
<TRIM> ~ [Tt][Rr][Ii][Mm]
<TRUE> ~ [Tt][Rr][Uu][Ee]
<TYPE> ~ [Tt][Yy][Pp][Ee]
<U> ~ [Uu]
<UNBOUNDED> ~ [Uu][Nn][Bb][Oo][Uu][Nn][Dd][Ee][Dd]
<UNCOMMITTED> ~ [Uu][Nn][Cc][Oo][Mm][Mm][Ii][Tt][Tt][Ee][Dd]
<UNDER> ~ [Uu][Nn][Dd][Ee][Rr]
<UNION> ~ [Uu][Nn][Ii][Oo][Nn]
<UNIQUE> ~ [Uu][Nn][Ii][Qq][Uu][Ee]
<UNKNOWN> ~ [Uu][Nn][Kk][Nn][Oo][Ww][Nn]
<UNNAMED> ~ [Uu][Nn][Nn][Aa][Mm][Ee][Dd]
<UNNEST> ~ [Uu][Nn][Nn][Ee][Ss][Tt]
<UPDATE> ~ [Uu][Pp][Dd][Aa][Tt][Ee]
<UPPER> ~ [Uu][Pp][Pp][Ee][Rr]
<USAGE> ~ [Uu][Ss][Aa][Gg][Ee]
<USER> ~ [Uu][Ss][Ee][Rr]
<USER_DEFINED_TYPE_CATALOG> ~ [Uu][Ss][Ee][Rr]'_'[Dd][Ee][Ff][Ii][Nn][Ee][Dd]'_'[Tt][Yy][Pp][Ee]'_'[Cc][Aa][Tt][Aa][Ll][Oo][Gg]
<USER_DEFINED_TYPE_CODE> ~ [Uu][Ss][Ee][Rr]'_'[Dd][Ee][Ff][Ii][Nn][Ee][Dd]'_'[Tt][Yy][Pp][Ee]'_'[Cc][Oo][Dd][Ee]
<USER_DEFINED_TYPE_NAME> ~ [Uu][Ss][Ee][Rr]'_'[Dd][Ee][Ff][Ii][Nn][Ee][Dd]'_'[Tt][Yy][Pp][Ee]'_'[Nn][Aa][Mm][Ee]
<USER_DEFINED_TYPE_SCHEMA> ~ [Uu][Ss][Ee][Rr]'_'[Dd][Ee][Ff][Ii][Nn][Ee][Dd]'_'[Tt][Yy][Pp][Ee]'_'[Ss][Cc][Hh][Ee][Mm][Aa]
<USING> ~ [Uu][Ss][Ii][Nn][Gg]
<VALUE> ~ [Vv][Aa][Ll][Uu][Ee]
<VALUES> ~ [Vv][Aa][Ll][Uu][Ee][Ss]
<VARCHAR> ~ [Vv][Aa][Rr][Cc][Hh][Aa][Rr]
<VARYING> ~ [Vv][Aa][Rr][Yy][Ii][Nn][Gg]
<VAR_POP> ~ [Vv][Aa][Rr]'_'[Pp][Oo][Pp]
<VAR_SAMP> ~ [Vv][Aa][Rr]'_'[Ss][Aa][Mm][Pp]
<VIEW> ~ [Vv][Ii][Ee][Ww]
<WHEN> ~ [Ww][Hh][Ee][Nn]
<WHENEVER> ~ [Ww][Hh][Ee][Nn][Ee][Vv][Ee][Rr]
<WHERE> ~ [Ww][Hh][Ee][Rr][Ee]
<WIDTH_BUCKET> ~ [Ww][Ii][Dd][Tt][Hh]'_'[Bb][Uu][Cc][Kk][Ee][Tt]
<WINDOW> ~ [Ww][Ii][Nn][Dd][Oo][Ww]
<WITH> ~ [Ww][Ii][Tt][Hh]
<WITHIN> ~ [Ww][Ii][Tt][Hh][Ii][Nn]
<WITHOUT> ~ [Ww][Ii][Tt][Hh][Oo][Uu][Tt]
<WORK> ~ [Ww][Oo][Rr][Kk]
<WRITE> ~ [Ww][Rr][Ii][Tt][Ee]
<X> ~ [Xx]
<YEAR> ~ [Yy][Ee][Aa][Rr]
<ZONE> ~ [Zz][Oo][Nn][Ee]

