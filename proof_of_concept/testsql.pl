#!env perl
use strict;
use diagnostics;
use File::Slurp qw/read_file/;
use Marpa::R2;

my $G = read_file(shift);

my $g = Marpa::R2::Scanless::G->new({source => \$G});
my $r = Marpa::R2::Scanless::R->new({grammar => $g,
                                    trace_terminals => 1});

our $DATA = do {local $/; <DATA>;};

eval {$r->read(\$DATA)} || print STDERR "$@\n" . $r->show_progress() . "\n";

__DATA__
SELECT * from THIS;
CREATE SCHEMA PERS;
CREATE TABLE ORG (DEPTNUMB  SMALLINT NOT NULL,
                  DEPTNAME VARCHAR(14),
                  MANAGER  SMALLINT,
                  DIVISION VARCHAR(10),
                  LOCATION VARCHAR(13),
                  CONSTRAINT PKEYDNO
                  PRIMARY KEY (DEPTNUMB),
                  CONSTRAINT FKEYMGR
                  FOREIGN KEY (MANAGER)
                  REFERENCES STAFF (ID) );

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
                    REFERENCES ORG (DEPTNUMB) );
--
-- http://www.bullraider.com/database/sql-tutorial/7-complex-queries-in-sql
-- I have replace &n by :n to use a fake host variable
--
select * from emp where rowid in (select decode(mod(rownum,2),0,rowid, null) from emp);
select * from emp where rowid in (select decode(mod(rownum,2),0,null ,rowid) from emp);
select distinct sal from emp e1 where 3 = (select count(distinct sal) from emp e2 where e1.sal <= e2.sal);
select distinct sal from emp e1 where 3 = (select count(distinct sal) from emp e2 where e1.sal >= e2.sal);
select * from emp where rownum <= :n;
select * from emp minus select * from emp where rownum <= (select count(*) - :n from emp);
select * from dept where deptno not in (select deptno from emp);
select distinct sal from emp a where 3 >= (select count(distinct sal) from emp b where a.sal <= b.sal) order by a.sal desc;
select distinct sal from emp a  where 3 >= (select count(distinct sal) from emp b  where a.sal >= b.sal);
select distinct hiredate from emp a where :n =  (select count(distinct sal) from emp b where a.sal >= b.sal);
select * from emp a where rowid = (select max(rowid) from emp b where  a.empno=b.empno);

select ename,sal/12 as monthlysal from emp;

select * from emp where deptno=30 or deptno=10;
SELECT  deptno, sum(sal) As totalsal
FROM emp
GROUP BY deptno /* A comment */
HAVING COUNT(empno) > 2;
