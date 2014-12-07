#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;

BEGIN {
    use_ok( 'MarpaX::Languages::SQL::AST' ) || print "Bail out!\n";
}

my $sqlSourceCode = do { local $/; <DATA> };
my $sqlAst = MarpaX::Languages::SQL::AST->new();
my $valuep = $sqlAst->parse(\$sqlSourceCode)->value(1);
ok(defined($valuep), 'Output from parse()->value() is ok');
use Data::Dumper;
my $i = 0;
foreach (@{$valuep}) {
    ++$i;
    open(THIS, '>', "/tmp/value$i");
    print THIS Dumper($valuep->[$i-1]);
    close THIS;
}
print "... $i parse tree values\n";
__DATA__
SELECT occurrence_binary
FROM   Binary_Examples
WHERE  occurrence_binary = X'44';
