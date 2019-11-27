SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) d_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) rown
FROM emp;
-- PARTITION BY 컬럼명: 그룹으로 묶음. 


-- 실습 ana1
/*
    사원의 전체 급여 순위를 rank,dense_rank, row_number를 이용하여 구하세요
    단 급여가 동일한 경우 사번이 빠른 사림이 높은순위가 되도록 작성하세요.
    */
SELECT empno, ename, sal, deptno,
       RANK() OVER (ORDER BY sal desc, empno) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal desc, empno) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal desc, empno) sal_row_number
FROM emp;

--실습 ana2
/*
    기존의 배운 내용을 활용하여,
    모든 사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서의 사워 수를
    조회하는 쿼리를 작성하세요.
    */
SELECT a.empno, a.ename, a.deptno, b.cnt
FROM 
    (SELECT empno, ename, deptno
    FROM emp) a,
    (SELECT deptno, count(deptno) cnt
    FROM emp
    GROUP BY deptno)b
WHERE a.deptno = b.deptno
ORDER BY deptno, empno;

--분석함수를 통한 부서별 직원수 (COUNT)
SELECT ename, empno, deptno,
       COUNT(*) OVER(PARTITION BY deptno) cnt
FROM emp;

--부서별 사원의 급여 합계
--SUM 분석함수
SELECT ename, empno, deptno, sal,
       SUM(sal) OVER(PARTITION BY deptno) sum_sal
FROM emp;

--실습 ana2
/*
    window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,
    본인급여, 부서번호와 해당 사원이 속한 부서의 급여 평균을 조회하는 쿼리
    를 작성하세요(급여 평균은 소수점 둘째자리까지)
    */
SELECT empno, ename, sal, deptno,
       ROUND(AVG(sal) OVER(PARTITION BY deptno),2) cnt
FROM emp;

--실습 ana3
/*
    window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,
    본인급여, 부서번호와 해당사원이 속한 부서의 가장높은 급여를 조회하는
    쿼리를 작성하세요.
    */
SELECT empno, ename, sal, deptno,
       MAX(sal) OVER(PARTITION BY deptno) max_sal
FROM emp;

--실습 ana4
/*
    window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,
    본인급여, 부서번호와 해당사원이 속한 부서의 낮은높은 급여를 조회하는
    쿼리를 작성하세요.
    */
SELECT empno, ename, sal, deptno,
       MIN(sal) OVER(PARTITION BY deptno) min_sal
FROM emp;

--부서별 사원번호가 가장 빠른사람
--부서별 사원번호가 가장 느린사람
SELECT empno, ename, deptno,
       FIRST_VALUE (empno) OVER(PARTITION BY deptno ORDER BY empno) f_emp,
       LAST_VALUE (empno) OVER(PARTITION BY deptno ORDER BY empno) l_emp
FROM emp;

--LAG (이전행)
--현재형
--LEAD (다음행)
--급여가 높은순으로 했을때 자기보다 한단계 급여가 낮은 사람의 급여,
--                            한단계 급여가 높은 사람의 급여

SELECT empno, ename, sal,
       LAG(sal) OVER(ORDER BY sal) lag_sal,
       LEAD(sal) OVER(ORDER BY sal) lead_sal
FROM emp;

--실습 ana5
/*
    window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,
    입사일자, 급여, 전체 사원중 급여순위가 1단게 낮은 사람의 급여 조회하는
    쿼리를 작성하세요.
    */
SELECT empno, ename, hiredate, sal,
       LEAD(sal) OVER(ORDER BY sal desc, hiredate) lead_sal
FROM emp;

--실습 ana6
/*
    window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,
    입사일자, 직군(job),급여 정보와 담당업무(JOB)별 급여 순위가 1단계
    높은 사람의 급여를 조회하는 쿼리를 작성하세요.
    (급여가 같은 겨우 입사일이 빠른 사람이 높은순위)
    */
SELECT empno, ename, hiredate, job ,sal,
       LAG(sal) OVER(PARTITION BY job ORDER BY sal desc, hiredate) lag_sal
FROM emp;

--실습 no_ana3
/*
    -모든 사원에 대해 사원번호,사원이름,입사일자,급여를 급여가 낮은순으로
     조회해보자.
    
    -자신보다 급여가 낮은 사람의 급여 합을 새로운 컬럼에 넣어보자
     (window 함수 없이..)
    */
(SELECT a.empno, a.ename, a.sal ,ROWNUM rn
FROM 
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal)a)a;

(select b.sal, b.rn
FROM
    (SELECT b.sal, rownum rn
    FROM 
        (SELECT sal
        FROM emp
        GROUP BY sal
        ORDER BY sal) b)b  
WHERE a.rn = b.rn; 

--선생님 풀이
SELECT a.empno, a.ename, a.sal, sum(b.sal) sal_sum
FROM
    (SELECT a.empno, a.ename, a.sal ,ROWNUM rn
    FROM 
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)a)a,
    
    (SELECT b.empno, b.ename, b.sal , ROWNUM rn
    FROM 
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)b)b
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;
---------------------------

--WINdOWING
--UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든행
--CURRENT ROW : 현재 행
--UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든행
--N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
--N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

-- ROWS BETWEEN 시작 AND 끝
SELECT empno, ename, sal,
       SUM(sal) OVER(ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal, -- 선행하는 행부터 현재행까지
       
       SUM(sal) OVER(ORDER BY sal, empno 
       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,    --선행하는 행부터 후행하는 행까지
       
       SUM(sal) OVER(ORDER BY sal, empno 
       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3 --현재행 기준 위아래 행만
FROM emp;

--실습 ana7
/*
    사원번호, 사원이름, 부서번호, 급여정보를 부서별로
    급여, 사원번호 오름차순으로 정렬했을때, 자신의급여와 선행하는
    사원들의 급여 합을 조회하는 쿼리를 작성하세요.
(window함수 사용)
    */
select empno, ename, deptno, sal,
       sum(sal) over(partition by deptno 
                     order by sal, empno
                     rows between unbounded preceding and current row) c_sum
                     --rows between unbounded preceding and current row) default값
from emp;

--range함수
select empno, ename, deptno, sal,
       sum(sal) over (order by sal 
                      rows between unbounded preceding and current row) row_sum,
       sum(sal) over (order by sal 
                      rows unbounded preceding) row_sum2,
       
       sum(sal) over (order by sal 
                      range between unbounded preceding and current row) range_sum,
       sum(sal) over (order by sal 
                      range unbounded preceding) range_sum2
        -- rows는 값이 같더라도 별로도 인식함.
        -- range는 sal이 같은 부분을 하나의 행으로 인식함
        
from emp;