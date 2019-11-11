--SMITH, WARD가 속하는 부서의 직원들 조회
SELECT *
FROM emp
WHERE deptno IN (20, 30);

SELECT *
FROM emp
WHERE deptno = 20
   OR deptno = 30;
   
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno 
                 FROM emp 
                 WHERE ename IN (:name1, :name2));
                 
-- ANY : SET중에 만족하는게 하나라도 있으면 참으로(크기비교)
-- SMITH, WARD 두사람의 급여보다 적은 급여를 받는 직원 정보 조회
SELECT *
FROM emp
WHERE sal < any(SELECT sal --800, 1250 --> 1250보다 작은 급여를 받는 직원 정보
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
      
-- SMITH와 WARD보다 급여가 높은 직원 조회
-- SMITH보다도 급여가 높고, WARD보다도 급여가 높은 사람(AND)
SELECT *
FROM emp
WHERE sal > ALL(SELECT sal --800, 1250 --> 1250보다 높은 급여를 받는 직원 정보
                FROM emp
                WHERE ename IN ('SMITH', 'WARD'));
                
--NOT IN

--관리자의 직원정보
--1. 관리자인 사람만 조회
--  . mgr 컬럼에 값이 나오는 직원 (mgr은 나를 관리하는 사람의 사원번호)
SELECT DISTINCT mgr -- DISTINCT은 중복값 제거
FROM emp;

--어떤 직원의 관리자 역할을 하는 직원 정보 조회
SELECT *
FROM emp
WHERE empno IN (7839,7782,7698,7902,7566,7788);


SELECT *
FROM emp
WHERE empno IN (SELECT mgr 
                FROM emp);
                
 --관리자가 역할을 하지않는 평사원 정보 조회
 -- 단 NOT IN연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
 -- NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp       
WHERE empno NOT IN (SELECT mgr 
                FROM emp
                WHERE mgr is not null);
 -- NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp       
WHERE empno NOT IN (SELECT NVL(mgr, -9999)
                    FROM emp);
                    
--pair wise
--사번 7499, 7782인 직원의 관리자, 부서번호 조회
--직원중에 관리자와 부서번호가(7698, 30) 이거나 (7839, 10)인 사람
-- mgr, deptno 컬럼을 [동시]에 만족 시키는 직원 정보 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN(SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782));
--7698 39
--7839 10
--직원중 관리자와, 부서번호가 (7698, 30), (7698, 10), (7839, 30), (7839, 10) 인 직원 조회
SELECT *
FROM emp
WHERE mgr IN(SELECT mgr
                FROM emp
                WHERE empno IN(7499, 7782))          
AND deptno IN(SELECT deptno
                FROM emp
                WHERE empno IN(7499, 7782));
                
--SCALAR SUNQUERY : SELECT 절에 등장하는 서브쿼리(단. 값이 하나의 행, 하나의 컬럼)
--직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, (SELECT dname
                                FROM dept
                                WHERE dept.deptno = emp.deptno) dname
FROM emp;

SELECT dname
FROM dept
WHERE deptno = 20;

--sub4 데이터 생성
/*
    dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
    직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요.
    */
SELECT *
FROM dept;
INSERT INTO dept VALUES(99, 'ddit', 'daejeon');
COMMIT;
--정답
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno
                     FROM  emp);

--실습 sub5
/*
    cycle, product 테이블을 이용하여 cid=1인 고객이 애음하지 않는
    제품을 조회하는 쿼리를 작성하세요.
    */
select *from cycle;
select * from product;

select pid, cid
from cycle
where cid =1;

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid =1); 

--실습 sub6
/*
    cycle 테이블을 이용하여 cid=2인 고객이 애음하는 제품중 cid=1인
    고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요.
    */

SELECT *FROM cycle;
SELECT *FROM product;

SELECT * 
FROM cycle
WHERE cid = 1
AND pid IN(SELECT pid
             FROM cycle
             WHERE cid = 2);
--실습 sub7
/*
    cycle 테이블을 이용하여 cid=2인 고객이 애음하는 제품중 cid=1인
    고객도 애음하는 제품의 애음정보를 조회하고 고객명과 제품명까지
    포함하는 쿼리를 작성하세요.
    */
select * from cycle;
select * from product;
select * from customer;

SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt 
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN(SELECT pid
             FROM cycle
             WHERE cid = 2
             )
AND cycle.pid = product.pid
AND cycle.cid = customer.cid;
---------------------------------

    



--EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
--만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에
--성능면에서 유리

--MGR가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);

--MGR가 존재하지 않는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
              FROM emp
              WHERE empno = a.mgr);
              
--실습 sub8
-- 아래 쿼리를 subquery를 사용하지 않고 작성하세요.
-- 매니저가 존재하는 직원 조회
SELECT * 
FROM emp a
WHERE EXISTS(SELECT 'X'
             FROM emp b
             WHERE b.empno = a.mgr);

SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--부서에 소속된 직원이 있는 부서 정보 조회
select * from emp;

SELECT *
FROM dept
WHERE EXISTS(SELECT 'X'
             FROM emp
             WHERE deptno = dept.deptno);
--IN
SELECT *
FROM dept
WHERE deptno IN(SELECT deptno
             FROM emp);
            
--실습 sub9
/*
    cycle, product 테이블을 이용하여 cid=1인 고객이 애음하지 않는
    제품을 조회하는 쿼리를 EXISTS 연산자를 이용하여 작성하시오.
    */
select * from cycle;
select * from product;
select * from customer;
--EXISTS
SELECT *
FROM product
WHERE  NOT EXISTS(SELECT 'X'
                  FROM cycle
                  where cycle.cid = 1
                  AND cycle.pid = product.pid);
--NOT IN
select *
from product
where pid not in (select pid
                    from cycle
                    where cid = 1);

            
--집합연산
--UNION : 합집합 중복을 제거
--        DBMS에서는 중복을 제거하기위해 데이터를 정렬
--        (대량의 데이터에 대해 정렬시 부하)
--UNION ALL : UNION과 같은개념
--            중복을 제거하지 않고, 위 아래 집합을 결합 => 중복가능
--            위아래 집합에 중복되는 데이터가 없다는 것을 확신하면
--            UNION 연산자보다 성능면에서 유리
--사번이 7566 또는 7698dls 사원 조회(사번이랑, 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
--사번이 7369, 7499인 사원 조회(사번,이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno =7369 OR empno = 7499;

--UNION ALL(중복 허용, 위 아래 집합을 합치기만 한다)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL
--사번이 7369, 7499인 사원 조회(사번,이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno =7369 OR empno = 7499;


--INTERSECT(교집합 : 위 아래 집합간 공통된 데이터)
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698,7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566 ,7698,7499);

--MINUS(차집합 : 위 집합에서 아래 집합을 제거)
--순서가 존재 : 위의 있는 집합이 기준
SELECT empno, ename
FROM emp
WHERE empno IN (7566, 7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566 ,7698,7499);
















SELECT *
FROM USER_CONSTRAINTS
WHERE OWNER = 'PC14'
AND TABLE_NAME IN('PROD', 'LPROD')
AND CONSTRAINT_TYPE IN('P','R');









