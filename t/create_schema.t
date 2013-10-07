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
CREATE SCHEMA PERS

     CREATE TABLE ORG (DEPTNUMB  SMALLINT NOT NULL,
                        DEPTNAME VARCHAR(14),
                        MANAGER  SMALLINT,
                        DIVISION VARCHAR(10),
                        LOCATION VARCHAR(13),
                        CONSTRAINT PKEYDNO
                          PRIMARY KEY (DEPTNUMB),
                        CONSTRAINT FKEYMGR
                          FOREIGN KEY (MANAGER)
                          REFERENCES STAFF (ID) )

     CREATE TABLE STAFF (ID        SMALLINT NOT NULL,
                         NAME     VARCHAR(9),
                         DEPT     SMALLINT,
                         JOB      VARCHAR(5),
                         YEARS    SMALLINT,
                         SALARY   DECIMAL(7,2),
                         COMM     DECIMAL(7,2),
                         CONSTRAINT PKEYID
                           PRIMARY KEY (ID),
                         CONSTRAINT FKEYDNO
                           FOREIGN KEY (DEPT)
			 REFERENCES ORG (DEPTNUMB) )
