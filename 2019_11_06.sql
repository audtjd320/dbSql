--그룹함수
--multi row function : 여러개의 행을 입력으로 하나의 결과 행을 생성
--SUM, MAX, MIN, AVG, COUNT
-- GROUNP BY col | express
--SELECT 절에는 GROUP BY 절에 기술된 COL, EXPRESS 표기 가능

--직원중 가장 높은 급여를 조회
-- 14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

--부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM dept;


--group function 실습 grp2
/*
    emp테이블을 이용하여 다음을 구하시오
    - 부서기준 직원중 가장 높은 급여
    - 부서기준 직원중 가장 낮은 급여
    - 부서기준 직원의 급여 평균
    - 부서기준 직원의 급여 합
    - 부서의 직원중 급여가 있는 직원의 수(NULL제외)
    - 부서의 직원중 상급자가 있는 직원의 수(NULL제외)
    - 부서의 전체 직원의 수
*/
SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;
--group function 실습 grp3
/*
    emp테이블을 이용하여 다음을 구하시오.
    - grp2에서 직상힌 쿼리를 활용하여
      deptno 대신 부서명이 나올수 있도록 수정하시오.
*/
desc emp;

SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) count_all,
       COUNT(sal) count_sal_,
       COUNT(mgr) count_mgr,
       SUM(comm) comm_sum
FROM emp
GROUP BY  DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES')
ORDER BY DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES');

--group function 실습 grp4
/*
    emp테이블을 이용하여 다음을 구하시오.
    직원의 입사 년월별로 몇명의 직원이 입사했는지
    조회하는 쿼리를 작성하세요.
*/

SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');


--group function 실습 grp5
/*
    emp테이블을 이용하여 다음을 구하시오.
    직원의 입사 년별로 몇명의 직원이 입사했는지
    조회하는 쿼리를 작성하세요.
*/
SELECT TO_CHAR(hiredate, 'YYYY') hire_yyyymm, COUNT(*)cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');

--group function 실습 grp6
/*
    회사에 존재하는 부서의 개수는 몇개인지 조회하는 쿼리를 작성하시오.
*/
desc dept;
SELECT COUNT(deptno) cnt, count(*) cnt
FROM dept;

SELECT distinct deptno --중복을 제거함
FROM emp;

--JOIN
--emp 테이블에는 dname 컬럼이 없다 --> 부서번호 (deptno)밖에 없음

--emp 테이블에 부서이름을 저장할수 있는 dname 컬럼추가
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname ='ACCOUNTING' WHERE DEPTNO=10;
UPDATE emp SET dname ='RESEARCH' WHERE DEPTNO=20;
UPDATE emp SET dname ='SALES' WHERE DEPTNO=30;
COMMIT;

SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP COLUMN DNAME;
SELECT *
FROM emp;

--ansi natual join : 조인하는 테이블의 컬럼명이 같은 컬럼을 기준으로 join
SELECT DEPTNO,ENAME,DNAME
FROM emp NATURAL JOIN DEPT;
  
--ORACLE join
SELECT e.deptno , e.ename, e.deptno, d.dname, d.loc --중복되는 값은 명확하게 지정해줘야함.
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI JOING WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno);

--from 절에 조인대상 테이블 나열
--where절에 조인조건 기술
--기존에 사용하던 조건 제약도 기술가능
SELECT  emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN'; --job이 SALES인 사람만 대상으로 조회
 ------------------------------------- 
SELECT  emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
  AND emp.job = 'SALESMAN'; 
  -------------------------------------
--JOIN with ON (개발자가 조인 컬럼을 ON절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF join : 같은 테이블끼리 조인
--emp테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야한다
--a : 직원정보, b : 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno between 7369 AND 7698;

--위의 예시를 oracle join으로 변경해보자.
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.empno between 7369 AND 7698;

--non-equijoing(등식 조인이 아닌경우)
SELECT *
FROM salgrade;

--직원의 급여 등급은????
SELECT *
FROM emp;
--oracle
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

--ansi의 on절
SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--non equi joing
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr != b.empno
AND a.empno =7369;
------------------------------------------------
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a, emp b
WHERE a.empno =7369;  --조인 조건을 기술하지 않아 a의 7369와 b의 모든 경우의수인 14개가 추력 
-------------------------------------------------
--실습 join0
/*
    emp, dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
*/
desc emp;
desc dept;
SELECT a.empno, a.ename, b.deptno, b.dname 
FROM emp a, dept b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;
