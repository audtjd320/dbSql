--복습
--WHERE
--연산자
-- 비교 : =, !=, <>, >=, >, <=, <
-- BETWEEN start AND end
-- IN (set)
-- LIKE 'S%' (% : 다수의 문자열과 매칭, _ : 정확히 한글자 매칭
-- NULL ( != NULL )
-- AND, OR, NOT

-- emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는
-- 직원 정보조회

-- BETWEEN AND 사용
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01', 'YYYY/MM/DD')
                  AND TO_DATE('1986/12/01', 'YYYY/MM/DD');
-- >=, <=
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD')
  AND hiredate <= TO_DATE('1986/12/01', 'YYYY/MM/DD');
  
-- emp 테이블에서 관리자(mgr)이 있는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL; -- (!= NULL은 안됨)

--where12
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
   
--where13
--empno는 정수4자리까지 허용
desc emp;
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno/100  >= 78 AND empno/100 < 79;

--where14
/*
    emp 테이블에서  job이 SALESMAN이거나 사원번호가 78로 시작하면서
    입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요.
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');
   
--order by 컬럼명 | 별칭 | 컬럼인덱스 [ASC | DESC]
--order by 구문은 WHERE절 다음에 기술
--WHERE 절이 없을 경우 FROM절 다음에 기술
-- emane 기준으로 오름차순 정렬

SELECT *
FROM emp
ORDER BY ename ASC;

--ASC : dafault
--ASC를 안붙여도 위 쿼리와 동일함
SELECT *
FROM emp
ORDER BY ename; --ASC (기본 오름차순)

--이름(ename)을 기준으로 내림차순
SELECT *
FROM emp
ORDER BY ename DESC;

--job을 기준으로 내림차순으로 정렬, 만약 job이 같은경우
--사번 (empno)으로 올림차순 정렬
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

--별칭으로 정렬하기
--사원 번호(empno). 사원명(ename), 연봉(sal * 12) as year_sal
--year_sal 별칭으로 오름차순 정렬
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT절 컬럼 순서 인덱스로 정렬
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY 2; -- 2번째 컬럼 순서로 오름차순

--(실습 oderby1)
/*
    - dept 테이블의 모든정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요.
    - dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요.
*/
SELECT *
FROM dept
ORDER BY dname, loc desc;

--(실습 orderby2)
/*
    emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고,
    상여(comm)를 많이 받는 사람이 먼저 조회되도록 하고, 상여가 같은경우
    사번으로 오름차순 정렬하세요.
*/
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno;

--(실습 orderby3)
/*
    emp 테이블에서 관리자가 있는 사람들만 조회하고,
    직군(job)순으로 오름차순 정렬하고, 직업이 같을 경우
    사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요.
*/
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job ASC, empno DESC;

--(실습 orderby4)
/*
    emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람중
    급여(sal)가 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록
    쿼리를 작성하세요.
*/
SELECT *
FROM emp
WHERE deptno IN (10,30)
  AND sal > 1500
ORDER BY ename DESC;

desc emp;
SELECT ROWNUM empno, ename
FROM emp
WHERE ROWNUM <= 2;
--WHERE ROWNUM <= 10;

--emp 테이블에서 사번(empno), 이름(ename)을 급여 기준으로 오름차순 정렬하고
-- 정렬된 결과순으로 ROWBUM
SELECT ROWNUM, empno , ename, sal
FROM emp 
ORDER BY sal;

SELECT ROWNUM, a.*
FROM
(SELECT empno , ename, sal
FROM emp 
ORDER BY sal) a ;

--가상컬럼 ROWNUM 실습 row 1
/*
    emp 테이블에서 ROwNUM 값이 1_10인 값만 조회하는 쿼리를
    작성해보세요. (정렬없이 진행)
*/
SELECT ROWNUM, a.*
FROM
    (SELECT empno , ename, sal
    FROM emp
    ORDER BY sal) a
WHERE ROWNUM <=10;

--ROWNUM 실습 row_2
/*
    ROWNUM 값이 11~20인 값만 조회하는 쿼리를 작성해 보세요.
    HINT : alias, inline-view
(정리 : ROWNUM에 별칭을 주고, 
*/

SELECT b.*
FROM
    (SELECT ROWNUM rn, a.* --ROWNUM은 1부터검색을 시작해야하는데 별칭을 주어 테이블 형태로 조건을 주면 가능
    FROM
        (SELECT empno, ename,sal
        FROM emp
        ORDER BY sal) a 
    WHERE ROWNUM <= 14) b
WHERE rn >10;

---------- 선생님 해설 ----------
SELECT *
FROM
    ( SELECT ROWNUM rn, B.*
    FROM
        (SELECT empno, ename,sal
        FROM emp
        ORDER BY sal) B)
WHERE rn BETWEEN 11 AND 14;
---------------------------------

--FUNCTION
--DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

-- 문자열 대소문자 관련된 함수
-- LOWER, UPPER, INITCAP
SELECT LOWER('Hellon World'),
        UPPER('Hellon World'),
        INITCAP('Hellon World')
FROM emp
WHERE job = 'SALESMAN';

--FUNCTION은 WHERE절에서도 사용가능
SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
--WHERE ename = UPPER('smith'); --위의 내용과 동일(하지만 잘 사용하지 않음)

--개발자 SQL 칠거지악
-- 1. 좌변을 가공하지 말아라
-- 좌변(TABLE 의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
-- Function Based Index -> FBI

--CONCAT : 문자열 결합 - 두개의 문자열을 결합하는 함수
--(인자 두개만 결합이 가능)
--SUBSTR : 문자열의 부분 문자열(java : String.substring)
--LENGTH : 문자열의 길이
--INSTR : 문자열에 특정 문자열이 등장하는 첫번째 인덱스
--LPAD : 문자열에 특정 문자열을 삽입
SELECT CONCAT(CONCAT('HELLO',', ') ,' WORLD')CONCAT,
        SUBSTR('HELLO, WORLD', 0 , 5) substr,
        SUBSTR('HELLO, WORLD', 1 , 5) substr1,
        LENGTH('HELLO, WORLD') length,
        --INSTR(문자열, 찾을 문자열, 문자열의 특정 위치 이후 표시)
        INSTR('HELLO, WORLD', 'O', 6) instr1, --6이후의 O를 찾음
        --LPAD(문자열, 전체 문자열 길이, 문자열이 전체 문자열길이에 미치지 못할경우 추가할 문자)
        --    (추가할 문자를 지정하지 않으면 " "공백이 들어감)
        LPAD('HELLO, WORLD', 15, '*') lpad,
        LPAD('HELLO, WORLD', 15) lpad,
        LPAD('HELLO, WORLD', 15, ' ') lpad,
        RPAD('HELLO, WORLD', 15, '*') lpad
FROM dual;