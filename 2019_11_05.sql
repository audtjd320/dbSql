--년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
--201911 --> 30 / 201912 --> 31

-- 한달 더한후 원래값을 빼면 = 일수
-- 마지막 날짜 구한 후 --> DD만 추출
--SELECT TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD') day_cnt
SELECT :YYYYMM as param, TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD') DT
FROM DUAL;

explain plan for
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT empno, ename, sal, TO_CHAR(sal, 'L0009999,999.99') sal_fmt
FROM emp;

--function 
--nvl(coll, coll이 null일 경우 대체할 값) (중요!!)
SELECT empno, ename, comm, nvl(comm, 0) nvl_comm,
       sal + comm, sal + nvl(comm, 0), nvl(sal + comm, 0)
FROM emp;

--NVL2(coll, coll이 null이 아닐 경우  표현되는 값, coll이 null일 경우 표현되는 값)
SELECT empno, ename, sal, comm, NVL2(comm, 0, comm) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 같으면 null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...)
--함수 인자중 가장 null이 아닌 첫번째 인자
SELECT empno, ename, sal, comm, coalesce(comm, sal)
FROM emp;

--null 실습 fn4
/*
    emp테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
*/
desc emp;
SELECT empno, ename, mgr, NVL(mgr, 9999)as mgr_n, NVL2(mgr, mgr, 9999)as mgr_n,coalesce(mgr,9999) as mgr_n
FROM emp;


--null 실습 fn5
-- users테이블의 정보를 다음과같이 조회되도록 쿼리를 작성하세요
-- reg_dt가 null일 경우 sysdate를 적용
SELECT userid, usernm, reg_dt, NVL(reg_dt, sysdate) as n_reg_dt
FROM USERS;

--case when
SELECT empno, ename, job, sal,
       case
            when job ='SALESMAN' then sal*1.05
            when job ='MANAGER' then sal*1.10
            when job ='PRESIDENT' then sal*1.20
            else sal
       end case_sal
FROM emp;

--decode(col, search1, return1m search2, return2.....default)
SELECT empno, ename, job, sal,
       DECODE(job, 'SALESMAN', sal*1.05,
                   'MANAGER', sal*1.10, 
                   'PRESIDENT', sal*1.20, 
                    sal) decode_sal
FROM emp;

--condition 실습 cond1
/*
    emp 테이블을 이용하여 deptno에 따라 부서명으로 변경 해서
    다음과 같이 조횓히는 쿼리를 작성하세요
*/
    
SELECT empno, ename,
       case
            when deptno = 10 then 'ACCOUNTING'
            when deptno = 20 then 'RESEARCH'
            when deptno = 30 then 'SALES'
            when deptno = 40 then 'OPERATIONS'
            else 'DDIT'
       end dname
FROM emp;

--condition 실습 cond2
/*
    emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진
    대상자인지 조회하는 쿼리를 작성하세요.
    (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다)
    
    HINT) 나머지 구하는것은 MOD
*/
SELECT empno, ename, to_char(hiredate, 'YYYY/MM/DD') hiredate,
    
       DECODE (MOD(TO_CHAR(SYSDATE,'YY'),2),0,'건강검진 대상자',1,'건강검진 비대상자') contact_to_doctor

FROM emp;

-----------------샘 풀이---------------------
--올해는 짝수인가? 홀수인가?
--1.올해 년도 구하기 (DATE -> TO_CHAR(DATE, FORMAT)
--2.올해 년도가 짝수인지 계산
-- 어떤수를 2로 나누면 나머지는 항상 2보다 작다
-- 2로 나눌경우 나머지는 0,1
-- MOD(대상, 나눌값)
SELECT MOD(TO_CHAR(SYSDATE, 'YYYY'), 2)
FROM DUAL;

--emp 테이블에서 입사일자가 홀수년인지 짝수년인지 확인
-- 입사년도와 올해년도의 홀짝의 여부가 같을때
SELECT empno, ename, hiredate,
       case
        when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(hiredate, 'YYYY'), 2)
            then '건강검진 대상'
            else '건강검진 비대상자'
        end contact_to_doctor
FROM emp;

--condition 실습 cond3
/*
    users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진
    대상자인지 조회하는 쿼리를 작성하세요.
    (생년을 기준으로 하나는 여기서는 reg_dt를 기준으로 한다)
*/
SELECT userid, usernm, reg_dt,
       case
        when MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) = MOD(TO_CHAR(reg_dt, 'YYYY'), 2) --핵심
            then '건강검진 대상'
            else '건강검진 비대상자'
        end contact_to_doctor
FROM users;


--그룹함수 ( AVG, MAX, MIN, SUM, COUNT )
--그룹함수는 NULL값을 계산대상에서 제외한다
--SUM(comm), COUNT(*), COUNT(MGR)
--직원중 가장 높은 급여를 받는사람의 급여
--직원중 가장 낮은 급여를 받는사람의 급여
--직원의 급여 평균 (소수점 둘째자리 까지만 나오게 --> 소수점 3째자리에서 반올림)
--직원의 급여 전체합
--직원의 수
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp;

--부서별 가장 높은 급여를 받는사람의 급여
--GROUP BY 절에 기술되지 않은 컬럼이 SELECT절에 기술될 경우 에러
SELECT deptno, ename, MAX(sal) max_sal
FROM emp
GROUP BY deptno;


----------------------------------------------------------------------
SELECT deptno, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;
----------------------------------------------------------------------
SELECT *
FROM emp;

SELECT empno, ename, sal
FROM emp
ORDER BY sal;

--부서별 최대 급여
--그룹함수에서는 WHERE 조건절을 사용할수 없음 따라서 HAVING절을 이용한다.
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--group function 실습 grp1
/*
    emp테이블을 이용하여 다음을 구하시오
    - 직원중 가장 높은 급여
    - 직원중 가장 낮은 급여
    - 직원의 급여 평균
    - 직원의 급여 합
    - 직원중 급여가 있는 직원의 수(NULL제외)
    - 직원중 상급자가 있는 직원의 수(NULL제외)
    - 전체 직원의 수
*/
SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       AVG(sal) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp;

SELECT *
FROM EMP;

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