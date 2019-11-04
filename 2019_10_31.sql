--테이블에서 데이터 조회
/*
    SELECT 컬럼 | express (문자열 상수) [as] 별칭
    FROM 데이터를 조회할 테이블(VIEW)
    WHERE 조건 (condition)
*/

DESC user_tables;


SELECT *
 from user_tables;
 ----------------------------복습내용----------------------------
 -- 숫자 비교 연산
 -- 부서번호가 30번 보다 크거나 같은 부서에 속한 직원 조회
 SELECT * 
 FROM emp
 WHERE deptno >= 30;
 
 -- 부서번호가 30번보다 작은 부서에 속한 직원 조회;
 SELECT * 
 FROM emp
 WHERE deptno < 30;
 
--입사일자가 1982년 1월 1일 이후의 직원 조회
 SELECT * 
 FROM emp
-- WHERE hiredate < '82/01/01'; --환경설정에 데이터베이스의 날짜형식이 저장되어있어서 날짜 형식으로 인식함.
 WHERE hiredate >= TO_DATE('01011982', 'MMDDYYYY'); --미국 날짜 형식(월,일,연도)
-- WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');
-- WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

--BETWEEN X AND Y 연산
--컬럼의 값이 X보다 크거나 같고, Y보다 작거나 같은 데이터
--급여가(sal)가 1000보다 크거나 같고, 2000보다 작거나 같은 데이터를 조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--위의 BETWEEN AND 연산자는 아래의 <=, >= 조합과 같다
SELECT *
FROM emp
WHERE sal >= 1000
  AND sal <= 2000
  AND deptno = 30;
  
--실습1 : 조건에 맞는 데이터 조회하기( BETWEEN...AND...실습 where1)
/*
    emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터
    1983년 1월 1일 이전인 사원의 ename, hiredate 데이터를
    조회하는 쿼리를 작성하시오.
    단, 연산자는 between을 사용한다.
*/

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE(19820101, 'YYYYMMDD') AND TO_DATE(19830101,'YYYYMMDD');

--실습2 : 조건에 맞는 데이터 조회하기(>=, >, <=, < 실습 where2)
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE(19820101,'YYYYMMDD')
  AND hiredate <=  TO_DATE(19830101,'YYYYMMDD');
  

-- IN 연산자
-- COL IN (values....)
-- 부서번호가 10 혹은 20인 직원 조회

SELECT *
FROM emp
WHERE deptno in(10,20);


--IN 연산자는 OR 연산자로 표현할 수 있다.
SELECT *
FROM emp
WHERE deptno = 10
   OR deptno = 20;


--실습3 (IN 실습where3)
/*
    user 테이블에서 userid가 brown, cony, sally인 데이터를
    다음과 같이 조회 하시오.(IN 연산자 사용)
*/
desc users; --테이블 정보를 출력(이름, 널?, 유형)을 알고싶을때 사용
SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid in('brown', 'cony', 'sally');

--COL LIKE 'S%'
--COL의 값이 대문자 S로 시작하는 모든 값
--COL LIKE 's____'  
--COL의 값이 대문자 S로 시작하고 이어서 4개의 문자열이 존재하는 값

--emp 테이블에서 직원이름이 S로 시작하는 모든 직원 조회
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

--값은 대소문자를 구별함
--WHERE ename LIKE 'SMITH';
--WHERE ename LIKE 'sMITH';

-- 실습3 (LIKE, %, _ 실습 where4)
/*
    member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name
    을 조회하는 쿼리를 작성하시오.
*/

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE'신%';

--실습4 (LIKE, %,_ 실습 where5)
/*
    member 테이블에서 회원의 이름에 글자[이]가 들어가는 모든 사람의
    mem_id, mem_name을 조회하는 쿼리를 작성하시오.
*/
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE'%이%'; -- mem_name이 문자열 안에 '이'가 포함된 데이터
--WHERE mem_name LIKE'이%'; -- mem_name이 '이'로 시작하는 데이터

--NULL 비교
--col IS NULL
--EMP 테이블에서 MGR 정보가 없는 사람(NULL) 조회

SELECT *
FROM emp
WHERE mgr IS NULL;
--WHERE mgr != nill; -- null 비교가 실패한다

--소속부서가 10번이 아닌 직원들
SELECT *
FROM emp
WHERE deptno != '10';
--(=, !=)
--(is null, is not null)

--실습5 (IS NULL 실습 where6)
/*
    emp 테이블에서 상여(comm)가 있는 회원의 정보를 다음과 같이
    조회되도록 쿼리를 작성하시오.
*/
SELECT *
FROM emp
WHERE comm is not null;

--AND / OR
--관리자(mgr) 사번이 7698이고 급여가 1000 이상인 사람
SELECT *
FROM emp
WHERE mgr  = 7698
  AND sal >= 1000;

--emp 테이블에서 관리자(mgr) 사번이 7698 이거나
--      급여(sal)가 1000 이상인 직원 조회
SELECT *
FROM emp
WHERE mgr  = 7698
  OR sal >= 1000;

--emp 테이블에서 관리자(mgr) 사번이 7698이 아니고, 7839가 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839); -- IN --> OR

--위의 쿼리를 AND/OR 연산자로 변환
SELECT *
FROM emp
WHERE mgr != 7698
  AND mgr != 7839;
  
--IN, NOT IN  연산자의 NULL 처리
--emp 테이블에서 관리자(mgr) 사번이 7698 또는 null이 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839, NULL);
--IN 연산자에서 결과값에 NULL이 있을 경우 의도하지 않은 동작을 한다.

SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839)
   AND mgr IS NOT NULL;

--실습7 논리연산(AND,OR 실습 where7)
/*
    emp테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일
    이후인 직원의 정보를 다음과 같이 조회 하세요.
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

--실습8 논리연산(AND,OR 실습 where8)
/*
    emp테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일
    이후인 직원의 정보를 다음과 같이 조회하세요.
    (IN, NOT IN 연산자 사용금지)
*/
desc emp;
SELECT *
FROM emp
WHERE deptno != 10
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');
  
--실습9 논리연산(AND,OR 실습 where9)
/* 
    emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일
    이후인 직원의 정보를 다음과 같이 조회하세요.
    (NOT IN  연산자 사용)
*/
SELECT *
FROM emp
WHERE deptno NOT IN 10
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');
 
 --실습10 논리연산(AND,OR 실습 where10)
 /*
    emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일
    이후인 직원의 정보를 다음과 같이 조회하세요.
    (부서는 10, 20, 30 만 있다고 가정하고 IN 연산자를 사용)
*/
SELECT *
FROM emp
WHERE deptno IN (20, 30)
  AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

 --실습11 논리연산(AND,OR 실습 where11)
 /*
    emp테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일
    이후인 직원의 정보를 다음과 같이 조회하세요.
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
  OR hiredate >= TO_DATE('19810601', 'YYYYMMDD');
--실습12 논리연산(AND,OR 실습 where12)
/*
    emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는
    직원의 정보를 다음과 같이 조회 하세요.
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno LIKE '78%';
 --실습13 논리연산(AND,OR 실습 where13)
 /*
    emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는
    직원의 정보를 다음과 같이 조회 하세요.
    (LIKE를 사용하지 마라)
*/
SELECT *
FROM emp
WHERE job = 'SALESMAN'
   OR empno/100 = 78;
   