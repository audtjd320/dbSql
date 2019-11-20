
--GROUPING (cube, rollup 절의 사용된 컬럼)
-- 해당 컬럼이 소계 계산에 사용된 경우1
-- 사용되지 않은 경우 0

--job 컬럼
-- case1. GROUPING(job)=1 AND GROUPING(deptno) = 1
--        job --> '총계'
--case else
--        job --> job


SELECT CASE WHEN GROUPING(job) = 1 AND GROUPING(deptno) = 1 THEN '총계'    
            ELSE job   
        END job,
       CASE WHEN GROUPING(job) = 0 AND GROUPING(deptno) = 1 THEN '소계'
            ELSE TO_CHAR(deptno)
        END deptno,
        GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--실습GROUP_AD3
--table : emp
--조건 : group by 절을 한번만 사용

SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--실습GROUP_AD4
--AD3에서 부서번호 ->부서명
SELECT dname ,job, SUM(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname, job)
ORDER BY dname, job desc;

--실습GROUP_AD5
--AD4에서 총합 row의 경우dname컬럼에 '총합'으로 표시
SELECT case WHEN GROUPING(dname) = 1 AND GROUPING(job) = 1 THEN '총합'
            ELSE dname
            end dname,
            job, SUM(sal) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname, job)
ORDER BY dname, job desc;







----------------------------
select *
from dept;
--CUBE (col1, col2...)
--CUBE 절에 나열된 컬럼의 가능한 모든 조합에 대해 서브 그룹으로 생성
--CUBE에 나열된 컬럼에 대해 방향성은 없다(rollup과의 차이)
--GROUP BY CUBE(job, deptno)
--00 : GROUP BY job, deptno
--0X : GROUP BY job
--X0 : GROUP BY deptno
--XX : GROUP BY --모든 데이터에 대해서... 



--GROUP BY CUBE(job, deptno, mgr) -- 8가지 2의3승

SELECT deptno, job, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--subquery를 통한 업데이트
drop table emp_test;

--emp테이블의 데이터를 포함해서 모든 컬럼을 이용하여 emp_test테이블로 생성
create table emp_test AS
select *
from emp;

--emp_test 테이블 dept테이블에서 관리되고 있는 dname 컬럼(VARCHAR2(14))을 추가
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

select *
FROM EMP_TEST;

--emp_test테이블의 dname컬럼을 dept테이블의 dname컬럼 값으로 업데이트하는
--쿼리 작성
UPDATE emp_test SET dname = (SELECT dname
                             FROM dept
                             WHERE dept.deptno = emp_test.deptno);
commit;
SELECT *
FROM dept_test;
drop table dept_test;
--실습sub_a1
--dept테이블을 이용하여 dept_test 테이블 생성
CREATE TABLE dept_test AS
SELECT *
FROM dept;
--dept_test 테이블에 empcnt(number) 컬럼 추가
ALTER TABLE dept_test ADD(empcnt NUMBER);

--subquery를 이용하여 dept_test테이블의 empcnt 컬럼에
--해당 부서원 수를 update쿼리를 작석하세요.
UPDATE dept_test SET empcnt = (SELECT count(*) cnt --cnt가  0이면 null로 들어감.
                               FROM EMP
                               WHERE emp.deptno = dept_test.deptno
                               group by deptno);

SELECT deptno, count(*)
FROM EMP
group by deptno
GROUP BY deptno;

--선생님 풀이 --cnt가0이면 0들어감
UPDATE dept_test SET empcnt = (SELECT count(*) cnt
                               FROM EMP
                               WHERE deptno = dept_test.deptno);
SELECT *
FROM dept_test;

--
SELECT *
FROM dept_test;
INSERT INTO dept_test VALUES (98, 'it','daejeon','0');
INSERT INTO dept_test VALUES (99, 'it','daejeon','0');
rollback;
--실습sub_a2
--dept테이블을 이용하여 dept_test테이블 생성
--dept_test 테이블에 신규 데이터 2건 추가
--  INSERT INTO dept_test VALUES (98, 'it','daejeon','0');
--  INSERT INTO dept_test VALUES (99, 'it','daejeon','0');
--emp 테이블의 직원들이 속하지 않은 부서 정보 삭제하는 쿼리를 서브쿼리를 이용하여 작성하세요.
DELETE FROM dept_test 
WHERE empcnt not in (select count(*)
                    FROM emp
                    where emp.deptno = dept_test.deptno
                    Group by deptno);
rollback;
delete dept_test
where not exists (select 'x'
                  from emp  
                  where emp.deptno = dept_test.deptno);

delete dept_test
where deptno not in (select deptno
                     from emp);

--실습 sub_a3
--emp테이블을 이용하여 emp_test 테이블 생성
create table emp_test AS select * from emp;
/*
    subquery를 이용하여 emp_test 테이블에서 본인이 속한 부서의 
    (sal)평균 급여보다 급여가 작은 직원의 급여를 현 급여에서 200을
    추가해서 업데이트 하는 쿼리를 작성하세요.
    */
select ename, deptno, sal from emp_test order by deptno;     

--STEP1 -
select ename, deptno, sal
from emp_test a
where sal <(select round(avg(sal),2)
            from emp_test b
            where a.deptno = b.deptno);
--update로 변형
UPDATE emp_test a SET sal = sal + 200
where sal <(select avg(sal)
            from emp_test b
            where a.deptno = b.deptno);

--emp, emp_test empno컬럼으로 같은값끼리 조회
--1. emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
where emp.empno= emp_test.empno;
/*
    2. emp.empno, emp.ename, emp.sal, emp_test.sal,
       해당사원(emp테이블 기준)이 속한 부서의 급여평균
       */
SELECT emp.empno, emp.ename, emp.sal, emp_test.sal, emp.deptno, (select round(avg(sal),2)
                                                                 from emp
                                                                 where emp.deptno= emp_test.deptno
                                                                 group by deptno)avg_sal
FROM emp, emp_test
where emp.empno= emp_test.empno;