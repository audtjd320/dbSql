--emp 테이블에는 부서번호(deptno)만 존재
--emp 테이블에서 부서명을 조회하기 위해서는
--dept 테이블과 조인을 통해 부서명 조회

--조인 문법
--ANSI : 테이블 JOIN 테이블2 ON(테이블.COL = 테이블2.COL)
--       emp JOIN dept ON (emp.deptno = dept.deptno)
--ORACLE : FROM 테이블, 테이블2 WHERE 테이블.COL = 테이블2.COL
--         FROM emp, dept WHERE emp.deptno = dept.deptno

--사원번호, 사원명, 부서번호, 부서명
--ANSI
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--ORACLE
SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--------------------<< 복 습 >>-----------------------

--실습 join0_2
/*
    emp, dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
    (급여가 2500초과)
*/
select * --emp테이블
from emp;

select * --dept테이블
from dept;

SELECT a.empno, a.ename, a.sal, b.deptno, b.dname
FROM emp a, dept b
WHERE a.sal > '2500'
  AND a.deptno = b.deptno
ORDER BY deptno;

--실습 join0_3
/*
    emp, dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
    (급여 2500초과, 사번이 7600보다 큰 직원)
*/
SELECT a.empno, a.ename, a.sal, b.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
  AND a.sal > 2500
  AND a.empno > 7600;
  
--실습 join0_4
/*
    emp, dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요.
    (급여 2500초과, 사번이 7600보다 크고 부서명이 RESEARCH인 부서에 속한 직원)
*/
--ORACLE
SELECT a.empno, a.ename, a.sal, b.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
  AND a.sal > 2500
  AND a.empno > 7600
  AND B.dname = 'RESEARCH';

--ANSI
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno)
WHERE emp.sal > 2500
  AND emp.empno > 7600
  AND dept.dname = 'RESEARCH';

--실습 join1
/*
    erd 다이어그램을 참고하여 prod테이블과 lprod 테이블을 조인하여
    다음과 같은 결과가 나오는 쿼리를 작성해보세요.
*/
select *
from prod;

select *
from lprod;
-- 같은이름의 컬럼이 존재하면 어떤컬럼에서 조회하는건지는 명확히 명시 해줘야 함.
-- 다른 이름의 컬럼들은 앞에 컬럼명을 꼭 명시 안해줘도 상관없음.
SELECT b.lprod_gu, b.lprod_nm, a.prod_id, a.prod_name
FROM prod a, lprod b
WHERE a.prod_lgu = b.lprod_gu
ORDER BY b.lprod_gu; 

SELECT b.lprod_gu, b.lprod_nm, a.prod_id, a.prod_name
FROM prod a natural join lprod b;

--실습 join2
/*
    erd 다이어그램을 참고하여 prod테이블과 buyer 테이블을 조인하여
    buyer별 담당하는제품 정보를 다음과 같은 결과가 나오도록 쿼리를
    작성해보세요.
*/
SELECT prod_buyer buyer_id,prod_name buyer_name, prod_id, prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu
ORDER BY lprod.lprod_gu;
--------------------------------다시----------------------------

--실습 join3
/*
    erd 다이터그램을 참고하여 member, cart, prod 테이블을 조인하여
    회원별 장바구니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리를
    작성해보세요.
*/
select *
from member;
select *
from cart;
select *
from prod;
--ORACLE
SELECT mem_id, mem_name, prod_id, prod_name, cart.CART_QTY
FROM member, cart, prod
WHERE mem_id = cart_member
  AND prod_id = cart_prod;
--ANSI
SELECT mem_id, mem_name, prod_id, prod_name, cart.CART_QTY
FROM member JOIN cart ON(mem_id = cart_member) JOIN prod ON(prod_id = cart_prod);

--실습 join4
/*
    erd다이어그램을 참고하여 customer, cycle 테이블을 조인하여
    고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를
    작성해보세요.(고객명이 brown, sally인 고객만 조회)
*/
SELECT *
FROM customer;
SELECT *
FROM  cycle;

SELECT customer.cid, cnm, cycle.pid, day, cnt 
FROM customer, cycle
WHERE customer.cid = cycle.cid
  AND cnm IN('brown', 'sally');

--실습 join5
/*
    erd다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
    고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를
    작성해보세요.(고객명이 brown, sally인 고객만 조회)
*/
SELECT *
FROM customer;
SELECT *
FROM  cycle;
SELECT *
FROM product;
--ORACLE
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt 
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
  AND cycle.pid = product.pid
  AND cnm IN('brown', 'sally');
  
--ANSI
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt 
FROM customer JOIN cycle ON(customer.cid = cycle.cid) JOIN product ON (cycle.pid = product.pid)
WHERE cnm IN('brown', 'sally');

--실습 join6
/*
    erd다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
    애음요일과 관계없이 고객별 애음 제품별, 개수의 합과, 제품명을 다음과 같은
    결과가 나오도록 쿼리를 작성해보세요.
*/

--고객, 제품별 애음건수 (요일과 관계없이)
--with cycle_groupby as(
--SELECT cid, pid, SUM(cnt) cnt
--    FROM cycle
--    GROUP BY cid, pid)
방법1
SELECT customer.cid, cnm ,cycle_groupby.pid, pnm, product.pid, cnt
FROM  (SELECT cid, pid, SUM(cnt) cnt
       FROM cycle
       GROUP BY cid, pid)cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid
  AND cycle_groupby.pid = product.pid;

-- 방법2
SELECT customer.cid, cnm, cycle.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY  cnm,customer.cid, cycle.pid, pnm;

--실습 join7
/*
    erd다이어그램을 참고하여 cycle, product 테이블을 이용하여
    제품별, 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를
    작성해보세요.
*/
SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT cycle.pid, pnm, SUM(cnt) CNT -- SUM(cnt) cnt
FROM cycle, product
WHERE cycle.pid =  product.pid
GROUP BY cycle.pid, pnm     --GROUP BY에 있는건 무조건 SELECT에 기술되어야한다.(함수빼고)
ORDER BY cycle.pid, pnm;

-- GROUP BY 전에 ORDER BY를 먼저 해보면 잘보임
SELECT cycle.pid, pnm 
FROM cycle, product
WHERE cycle.pid =  product.pid
ORDER BY cycle.pid;
------------------------------------





































































drop table batch;
drop table daily;
drop table cycle;
drop table product;
drop table customer;
/* 고객 */
CREATE TABLE CUSTOMER (
	CID NUMBER NOT NULL, /* 고객번호 */
	CNM VARCHAR2(50) NOT NULL /* 고객명 */
);

COMMENT ON TABLE CUSTOMER IS '고객';

COMMENT ON COLUMN CUSTOMER.CID IS '고객번호';

COMMENT ON COLUMN CUSTOMER.CNM IS '고객명';

CREATE UNIQUE INDEX PK_CUSTOMER
	ON CUSTOMER (
		CID ASC
	);

ALTER TABLE CUSTOMER
	ADD
		CONSTRAINT PK_CUSTOMER
		PRIMARY KEY (
			CID
		);

/* 제품 */
CREATE TABLE PRODUCT (
	PID NUMBER NOT NULL, /* 제품번호 */
	PNM VARCHAR2(50) NOT NULL /* 제품명 */
);

COMMENT ON TABLE PRODUCT IS '제품';

COMMENT ON COLUMN PRODUCT.PID IS '제품번호';

COMMENT ON COLUMN PRODUCT.PNM IS '제품명';

CREATE UNIQUE INDEX PK_PRODUCT
	ON PRODUCT (
		PID ASC
	);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT PK_PRODUCT
		PRIMARY KEY (
			PID
		);

/* 고객애음주기 */
CREATE TABLE CYCLE (
	CID NUMBER NOT NULL, /* 고객번호 */
	PID NUMBER NOT NULL, /* 제품번호 */
	DAY NUMBER NOT NULL, /* 요일 */
	CNT NUMBER NOT NULL /* 수량 */
);

COMMENT ON TABLE CYCLE IS '고객애음주기';

COMMENT ON COLUMN CYCLE.CID IS '고객번호';

COMMENT ON COLUMN CYCLE.PID IS '제품번호';

COMMENT ON COLUMN CYCLE.DAY IS '요일';

COMMENT ON COLUMN CYCLE.CNT IS '수량';

CREATE UNIQUE INDEX PK_CYCLE
	ON CYCLE (
		CID ASC,
		PID ASC,
		DAY ASC
	);

ALTER TABLE CYCLE
	ADD
		CONSTRAINT PK_CYCLE
		PRIMARY KEY (
			CID,
			PID,
			DAY
		);

/* 일실적 */
CREATE TABLE DAILY (
	CID NUMBER NOT NULL, /* 고객번호 */
	PID NUMBER NOT NULL, /* 제품번호 */
	DT VARCHAR2(8) NOT NULL, /* 일자 */
	CNT NUMBER NOT NULL /* 수량 */
);

COMMENT ON TABLE DAILY IS '일실적';

COMMENT ON COLUMN DAILY.CID IS '고객번호';

COMMENT ON COLUMN DAILY.PID IS '제품번호';

COMMENT ON COLUMN DAILY.DT IS '일자';

COMMENT ON COLUMN DAILY.CNT IS '수량';

CREATE UNIQUE INDEX PK_DAILY
	ON DAILY (
		CID ASC,
		PID ASC,
		DT ASC
	);

ALTER TABLE DAILY
	ADD
		CONSTRAINT PK_DAILY
		PRIMARY KEY (
			CID,
			PID,
			DT
		);

ALTER TABLE CYCLE
	ADD
		CONSTRAINT FK_CUSTOMER_TO_CYCLE
		FOREIGN KEY (
			CID
		)
		REFERENCES CUSTOMER (
			CID
		);

ALTER TABLE CYCLE
	ADD
		CONSTRAINT FK_PRODUCT_TO_CYCLE
		FOREIGN KEY (
			PID
		)
		REFERENCES PRODUCT (
			PID
		);

ALTER TABLE DAILY
	ADD
		CONSTRAINT FK_CUSTOMER_TO_DAILY
		FOREIGN KEY (
			CID
		)
		REFERENCES CUSTOMER (
			CID
		);

ALTER TABLE DAILY
	ADD
		CONSTRAINT FK_PRODUCT_TO_DAILY
		FOREIGN KEY (
			PID
		)
		REFERENCES PRODUCT (
			PID
		);


/* 배치 */
CREATE TABLE BATCH (
	BID NUMBER NOT NULL, /* 배치번호 */
	BCD VARCHAR2(20) NOT NULL, /* 배치작업 */
	ST VARCHAR2(20) NOT NULL, /* 배치상태 */
	ST_DT DATE, /* 배치시작일자 */
	ED_DT DATE /* 배치종료일자 */
);

COMMENT ON TABLE BATCH IS '배치';

COMMENT ON COLUMN BATCH.BID IS '배치번호';

COMMENT ON COLUMN BATCH.BCD IS '배치작업';

COMMENT ON COLUMN BATCH.ST IS '배치상태';

COMMENT ON COLUMN BATCH.ST_DT IS '배치시작일자';

COMMENT ON COLUMN BATCH.ED_DT IS '배치종료일자';

CREATE UNIQUE INDEX PK_BATCH
	ON BATCH (
		BID ASC
	);

ALTER TABLE BATCH
	ADD
		CONSTRAINT PK_BATCH
		PRIMARY KEY (
			BID
		);        

--자료        
insert into customer values (1, 'brown');
insert into customer values (2, 'sally');
insert into customer values (3, 'cony');


insert into product values (100, '야쿠르트');
insert into product values (200, '윌');
insert into product values (300, '쿠퍼스');
insert into product values (400, '야쿠르트400');

insert into cycle values (1, 100, 2, 1);
insert into cycle values (1, 400, 3, 1);
insert into cycle values (1, 100, 4, 1);
insert into cycle values (1, 400, 5, 1);
insert into cycle values (1, 100, 6, 1);

insert into cycle values (2, 200, 2, 2);
insert into cycle values (2, 100, 3, 1);
insert into cycle values (2, 200, 4, 2);
insert into cycle values (2, 100, 5, 1);
insert into cycle values (2, 200, 6, 2);

insert into cycle values (3, 300, 2, 1);
insert into cycle values (3, 100, 3, 2);
insert into cycle values (3, 300, 4, 1);
insert into cycle values (3, 100, 5, 2);
insert into cycle values (3, 300, 6, 1);

commit;