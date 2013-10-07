#!perl -T
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
    use Log::Log4perl qw/:easy/;
    use Log::Any::Adapter;
    use Log::Any qw/$log/;
    use Data::Dumper;
    #
    # Init log
    #
    our $defaultLog4perlConf = '
    log4perl.rootLogger              = TRACE, Screen
    log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.stderr  = 0
    log4perl.appender.Screen.layout  = PatternLayout
    log4perl.appender.Screen.layout.ConversionPattern = %d %-5p %6P %m{chomp}%n
    ';
    Log::Log4perl::init(\$defaultLog4perlConf);
    Log::Any::Adapter->set('Log4perl');

BEGIN {
    use_ok( 'MarpaX::Languages::SQL::AST' ) || print "Bail out!\n";
}

my $sqlSourceCode = do { local $/; <DATA> };
my $sqlAst = MarpaX::Languages::SQL::AST->new();
my $valuep = $sqlAst->parse(\$sqlSourceCode);
ok(defined($valuep), 'Output from parse() is ok');

__DATA__
CREATE CHARACTER SET bob.charset_1 AS GET LATIN1
