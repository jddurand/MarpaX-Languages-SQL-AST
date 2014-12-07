#!env perl
use strict;
use warnings FATAL => 'all';
use MarpaX::Languages::SQL::AST;
use Log::Log4perl qw/:easy/;
use Log::Any::Adapter;
use Log::Any qw/$log/;
use Data::Dumper;
#
# Init log
#
our $defaultLog4perlConf = '
    log4perl.rootLogger              = INFO, Screen
    log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.stderr  = 0
    log4perl.appender.Screen.layout  = PatternLayout
    log4perl.appender.Screen.layout.ConversionPattern = %d %-5p %6P %m{chomp}%n
    ';
Log::Log4perl::init(\$defaultLog4perlConf);
Log::Any::Adapter->set('Log4perl');
#
# Parse SQL
#
my $sqlSourceCode = 'select * from myTable;';
my $sqlAstObject = MarpaX::Languages::SQL::AST->new();
my $valuep = $sqlAstObject->parse(\$sqlSourceCode)->value();
$log->infof('%s', ${$valuep}->toString(1));
