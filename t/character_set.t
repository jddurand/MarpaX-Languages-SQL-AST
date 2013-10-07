#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;

BEGIN {
    use_ok( 'MarpaX::Languages::SQL::AST' ) || print "Bail out!\n";
}

my $sqlSourceCode = do { local $/; <DATA> };
my $sqlAst = MarpaX::Languages::SQL::AST->new();
my $valuep = $sqlAst->parse(\$sqlSourceCode)->value();
ok(defined($valuep), 'Output from parse()->value() is ok');

__DATA__
CREATE CHARACTER SET bob.charset_1 GET LATIN1
