--조인복습
--조인 왜 ??
--RDBMS의 특성상 데이터 중복을 최대 배제한 설계를 한다
--EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는
-- 부서번호만 갖고있고, 부서번호를 통해 dept 테이블과 조인을 통해
-- 해당 부서의 정보를 가져올 수 있다.

--직원 번호, 직원이름, 직원의 소속 부서번호, 부서이름
SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--부서번호, 부서명, 해당부서의 인원수
--count(col) : col값이 존재하면 1, null : 0
--             행수가 궁금한 것이면 *
SELECT *FROM EMP; SELECT *FROM DEPT;
SELECT emp.deptno, dname,count(empno) cnt
FROM dept, emp
WHERE emp.deptno = dept.deptno
GROUP BY  emp.deptno, dname;

--TOTAL ROW : 14
SELECT count(*), count(empno), count(mgr), count(comm)
FROM emp;

--OUTER JOIN : 조인에 실패도 기준이 되는 테이블의 데이터는 조회결과가
--              나오도록 하는 조인 형태
--LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이
--                    되도록 하느 조인 형태
--RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이
--                    되도록 하는 조인 형태
--FULL OUTER JOIN : LEFT OUTER JOIN + RIGHT OUTER JOIN - 중복제거

--직원정보와 해당 직원의 관리자 정보 outer join
--직원번호, 직원이름, 관리자 번호, 관리자 이름

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a  JOIN emp b ON(a.mgr = b.empno);

--oracle outer join (left, right만 존재 fullouter는 지원하지 않음)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

--ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename -- b.ename 직원의 매니저 정보(a.mgr = b.empno)
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno AND b.deptno=10); --b.deptno=10이 조인의 조건임

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON(a.mgr = b.empno)
WHERE b.deptno =10; --조인후 조건절 b.deptno=10


--oracle outer 문법에서는 outer 테이블이 되는 모든 컬럼에 (+)를 붙여줘야
-- outer joing이 정상적으로 동작한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
ANd B.deptno(+) = 10;


--ANSI RIGHT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON(a.mgr = b.empno);

--실습 outerjoin1
/*
    buyprod테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목 밖에 없다.
    모든 품목이 나올수 있도록 쿼리를 작성해 보세요
*/
--ANSI
select * from buyprod;
select * from prod;
SELECT a.buy_date, a.buy_prod, b.prod_id, b.prod_name, a.buy_qty
FROM buyprod a right OUTER JOIN prod b ON(a.buy_prod = b.prod_id AND a.buy_date = '20050125');

--oracle
SELECT b.buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM  prod a, buyprod b
WHERE a.prod_id = b.buy_prod(+) --기준 반대에(+)붙여준다
AND b.buy_date(+)= TO_DATE('20050125','YYYYMMDD');

--실습 outerjoin2
/*
    
    outerjoin1에서 작업을 시작하세요. buy_date컬럼이 null인 항목이 안나오도록
    다음처럼 데이터를 채워지도록 쿼리를 작성하세요.
*/
SELECT TO_DATE('20050125','YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, b.buy_qty
FROM  prod a, buyprod b
WHERE a.prod_id = b.buy_prod(+) 
AND b.buy_date(+) = TO_DATE('20050125','YYYYMMDD');

--실습 outerjoin3
/*
    outerjoin2에서 작업을 시작하세요. buy_qty 컬럼이 null일 경우 0으로 보이도록
    쿼리를 수정하세요.
*/
SELECT TO_DATE('20050125','YYYYMMDD') buy_date, b.buy_prod, a.prod_id, a.prod_name, NVL(b.buy_qty,0)
FROM  prod a, buyprod b
WHERE a.prod_id = b.buy_prod(+) 
AND b.buy_date(+) = TO_DATE('20050125','YYYYMMDD');

--실습 outerjoin4
/*
    cycle, product테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고,
    애음하지 않는 제품도 다음과 같이 조회되도록 쿼리를 작성하세요.
    (고객은 cid=1인 고객만 나오도록 제한,null처리)
    */
SELECT *FROM CYCLE;
SELECT*FROM PRODUCT;

SELECT b.pid, b.pnm, NVL(a.cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM cycle a, product b
WHERE a.pid(+) = b.pid
ANd a.cid(+) = 1;

--실습 outerjoin5
/*
     cycle, product테이블을 이용하여 고객이 애음하는 제품 명칭을 표현하고,
     애음하지 않는 제품도 다음과 같이 조회되며, 고객이름을 포함하여 쿼리를
     작성하세요.
     (고객은 cid=1인 고객만 나오도록 제한,null처리)
     */
SELECT ab.pid, pnm,  ab.cid, cnm , day,  cnt  --겹치는 이름은 inline veiw의 별칭
FROM
    (SELECT b.pid, b.pnm, NVL(a.cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
    FROM cycle a, product b
    WHERE a.pid(+) = b.pid
    ANd a.cid(+) = 1)  , customer c
WHERE ab.cid = c.cid
ORDER BY pid desc, day desc;

--실습 crossjoin1
/*
    customer, product테이블을 이용하여 고객이 애음 가능한 모든 제품의
    정보를 결합하여 다음과 같이 조회되도록 쿼리를 작성하세요.
    */
-- CROSS JOIN은 WHERE절이 필요없음.

--ORACLE    
SELECT cid, cnm, pid, pnm
FROM customer, product;

--ANSI
SELECT *
FROM customer CROSS JOIN product;


--subquery : main쿼리에 속하는 부분 쿼리
--사용되는 위치 :
-- SELECT - scalar subquery(하나의 행과, 하나의 컬럼만 조회되는 쿼리이어야 한다)
-- FROM - inline view
-- WHERE - subquery

--SCALAR subquery
SELECT empno, ename, SYSDATE now/*현재날짜*/
FROM emp;

SELECT empno, ename, (SELECT SYSDATE FROM dual) now --SELECT절 안에 SELECT절에는 하나의 컬럼만 조회가능, 두개이상은 오류)
FROM emp;

--'SMITH'가 속한 부서의 정보
SELECT deptno  --20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

SELECT *
FROM emp
WHERE deptno = (SELECT deptno  --20
                FROM emp
                WHERE ename = 'SMITH');

--실습 SUB1
--평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요.
SELECT empno
FROM emp;

SELECT AVG(sal) --2073.21
FROM emp;

SELECT count(*)
FROM emp
WHERE sal >(SELECT AVG(sal) --2073.21
            FROM emp);
--실습 SUB2
--평균 급여보다 높은급여를 받는 직원의 정보를 조회하세요.
SELECT *
FROM emp
WHERE sal >(SELECT AVG(sal) --2073.21
            FROM emp);
            
--실습 SUB3
/*
    SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요.
    */

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno 
                FROM emp 
                WHERE ename IN('SMITH', 'WARD'));
