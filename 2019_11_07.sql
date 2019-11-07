--emp ���̺��� �μ���ȣ(deptno)�� ����
--emp ���̺��� �μ����� ��ȸ�ϱ� ���ؼ���
--dept ���̺�� ������ ���� �μ��� ��ȸ

--���� ����
--ANSI : ���̺� JOIN ���̺�2 ON(���̺�.COL = ���̺�2.COL)
--       emp JOIN dept ON (emp.deptno = dept.deptno)
--ORACLE : FROM ���̺�, ���̺�2 WHERE ���̺�.COL = ���̺�2.COL
--         FROM emp, dept WHERE emp.deptno = dept.deptno

--�����ȣ, �����, �μ���ȣ, �μ���
--ANSI
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--ORACLE
SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--------------------<< �� �� >>-----------------------

--�ǽ� join0_2
/*
    emp, dept���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
    (�޿��� 2500�ʰ�)
*/
select * --emp���̺�
from emp;

select * --dept���̺�
from dept;

SELECT a.empno, a.ename, a.sal, b.deptno, b.dname
FROM emp a, dept b
WHERE a.sal > '2500'
  AND a.deptno = b.deptno
ORDER BY deptno;

--�ǽ� join0_3
/*
    emp, dept���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
    (�޿� 2500�ʰ�, ����� 7600���� ū ����)
*/
SELECT a.empno, a.ename, a.sal, b.deptno, b.dname
FROM emp a, dept b
WHERE a.deptno = b.deptno
  AND a.sal > 2500
  AND a.empno > 7600;
  
--�ǽ� join0_4
/*
    emp, dept���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���.
    (�޿� 2500�ʰ�, ����� 7600���� ũ�� �μ����� RESEARCH�� �μ��� ���� ����)
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

--�ǽ� join1
/*
    erd ���̾�׷��� �����Ͽ� prod���̺�� lprod ���̺��� �����Ͽ�
    ������ ���� ����� ������ ������ �ۼ��غ�����.
*/
select *
from prod;

select *
from lprod;
-- �����̸��� �÷��� �����ϸ� ��÷����� ��ȸ�ϴ°����� ��Ȯ�� ��� ����� ��.
-- �ٸ� �̸��� �÷����� �տ� �÷����� �� ��� �����൵ �������.
SELECT b.lprod_gu, b.lprod_nm, a.prod_id, a.prod_name
FROM prod a, lprod b
WHERE a.prod_lgu = b.lprod_gu
ORDER BY b.lprod_gu; 

SELECT b.lprod_gu, b.lprod_nm, a.prod_id, a.prod_name
FROM prod a natural join lprod b;

--�ǽ� join2
/*
    erd ���̾�׷��� �����Ͽ� prod���̺�� buyer ���̺��� �����Ͽ�
    buyer�� ����ϴ���ǰ ������ ������ ���� ����� �������� ������
    �ۼ��غ�����.
*/
SELECT prod_buyer buyer_id,prod_name buyer_name, prod_id, prod_name
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu
ORDER BY lprod.lprod_gu;
--------------------------------�ٽ�----------------------------

--�ǽ� join3
/*
    erd �����ͱ׷��� �����Ͽ� member, cart, prod ���̺��� �����Ͽ�
    ȸ���� ��ٱ��Ͽ� ���� ��ǰ ������ ������ ���� ����� ������ ������
    �ۼ��غ�����.
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

--�ǽ� join4
/*
    erd���̾�׷��� �����Ͽ� customer, cycle ���̺��� �����Ͽ�
    ���� ���� ��ǰ, ��������, ������ ������ ���� ����� �������� ������
    �ۼ��غ�����.(������ brown, sally�� ���� ��ȸ)
*/
SELECT *
FROM customer;
SELECT *
FROM  cycle;

SELECT customer.cid, cnm, cycle.pid, day, cnt 
FROM customer, cycle
WHERE customer.cid = cycle.cid
  AND cnm IN('brown', 'sally');

--�ǽ� join5
/*
    erd���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ�
    ���� ���� ��ǰ, ��������, ������ ������ ���� ����� �������� ������
    �ۼ��غ�����.(������ brown, sally�� ���� ��ȸ)
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

--�ǽ� join6
/*
    erd���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ�
    �������ϰ� ������� ���� ���� ��ǰ��, ������ �հ�, ��ǰ���� ������ ����
    ����� �������� ������ �ۼ��غ�����.
*/

--��, ��ǰ�� �����Ǽ� (���ϰ� �������)
--with cycle_groupby as(
--SELECT cid, pid, SUM(cnt) cnt
--    FROM cycle
--    GROUP BY cid, pid)
���1
SELECT customer.cid, cnm ,cycle_groupby.pid, pnm, product.pid, cnt
FROM  (SELECT cid, pid, SUM(cnt) cnt
       FROM cycle
       GROUP BY cid, pid)cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid
  AND cycle_groupby.pid = product.pid;

-- ���2
SELECT customer.cid, cnm, cycle.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY  cnm,customer.cid, cycle.pid, pnm;

--�ǽ� join7
/*
    erd���̾�׷��� �����Ͽ� cycle, product ���̺��� �̿��Ͽ�
    ��ǰ��, ������ �հ�, ��ǰ���� ������ ���� ����� �������� ������
    �ۼ��غ�����.
*/
SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT cycle.pid, pnm, SUM(cnt) CNT -- SUM(cnt) cnt
FROM cycle, product
WHERE cycle.pid =  product.pid
GROUP BY cycle.pid, pnm     --GROUP BY�� �ִ°� ������ SELECT�� ����Ǿ���Ѵ�.(�Լ�����)
ORDER BY cycle.pid, pnm;

-- GROUP BY ���� ORDER BY�� ���� �غ��� �ߺ���
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
/* �� */
CREATE TABLE CUSTOMER (
	CID NUMBER NOT NULL, /* ����ȣ */
	CNM VARCHAR2(50) NOT NULL /* ���� */
);

COMMENT ON TABLE CUSTOMER IS '��';

COMMENT ON COLUMN CUSTOMER.CID IS '����ȣ';

COMMENT ON COLUMN CUSTOMER.CNM IS '����';

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

/* ��ǰ */
CREATE TABLE PRODUCT (
	PID NUMBER NOT NULL, /* ��ǰ��ȣ */
	PNM VARCHAR2(50) NOT NULL /* ��ǰ�� */
);

COMMENT ON TABLE PRODUCT IS '��ǰ';

COMMENT ON COLUMN PRODUCT.PID IS '��ǰ��ȣ';

COMMENT ON COLUMN PRODUCT.PNM IS '��ǰ��';

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

/* �������ֱ� */
CREATE TABLE CYCLE (
	CID NUMBER NOT NULL, /* ����ȣ */
	PID NUMBER NOT NULL, /* ��ǰ��ȣ */
	DAY NUMBER NOT NULL, /* ���� */
	CNT NUMBER NOT NULL /* ���� */
);

COMMENT ON TABLE CYCLE IS '�������ֱ�';

COMMENT ON COLUMN CYCLE.CID IS '����ȣ';

COMMENT ON COLUMN CYCLE.PID IS '��ǰ��ȣ';

COMMENT ON COLUMN CYCLE.DAY IS '����';

COMMENT ON COLUMN CYCLE.CNT IS '����';

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

/* �Ͻ��� */
CREATE TABLE DAILY (
	CID NUMBER NOT NULL, /* ����ȣ */
	PID NUMBER NOT NULL, /* ��ǰ��ȣ */
	DT VARCHAR2(8) NOT NULL, /* ���� */
	CNT NUMBER NOT NULL /* ���� */
);

COMMENT ON TABLE DAILY IS '�Ͻ���';

COMMENT ON COLUMN DAILY.CID IS '����ȣ';

COMMENT ON COLUMN DAILY.PID IS '��ǰ��ȣ';

COMMENT ON COLUMN DAILY.DT IS '����';

COMMENT ON COLUMN DAILY.CNT IS '����';

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


/* ��ġ */
CREATE TABLE BATCH (
	BID NUMBER NOT NULL, /* ��ġ��ȣ */
	BCD VARCHAR2(20) NOT NULL, /* ��ġ�۾� */
	ST VARCHAR2(20) NOT NULL, /* ��ġ���� */
	ST_DT DATE, /* ��ġ�������� */
	ED_DT DATE /* ��ġ�������� */
);

COMMENT ON TABLE BATCH IS '��ġ';

COMMENT ON COLUMN BATCH.BID IS '��ġ��ȣ';

COMMENT ON COLUMN BATCH.BCD IS '��ġ�۾�';

COMMENT ON COLUMN BATCH.ST IS '��ġ����';

COMMENT ON COLUMN BATCH.ST_DT IS '��ġ��������';

COMMENT ON COLUMN BATCH.ED_DT IS '��ġ��������';

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

--�ڷ�        
insert into customer values (1, 'brown');
insert into customer values (2, 'sally');
insert into customer values (3, 'cony');


insert into product values (100, '����Ʈ');
insert into product values (200, '��');
insert into product values (300, '���۽�');
insert into product values (400, '����Ʈ400');

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