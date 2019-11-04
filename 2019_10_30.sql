-- SELECT : ��ȸȰ �÷��� ���
--        - ��ü �÷���ȸ : *
--        - �Ϻ� �÷���ȸ : �ش� �÷��� ���� (,����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� �������.
--�� keyword�� �ٿ��� �ۼ�

--��� �÷��� ��ȸ
SELECT * FROM prod;

--Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;

-- lprod ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT *
FROM lprod;

-- buyer ���̺��� buyer_id,buyer_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���.
SELECT buyer_id,buyer_name
FROM buyer;

-- cart ���̺��� ��� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT *
FROM cart;

-- member ���̺��� mem_id, mem_pass, mem_name �÷��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT mem_id, mem_pass, mem_name
FROM member;

--������ / ��¥����
--date type + ���� : ���ڸ� ���Ѵ�.
-- null�� ������ ������ ����� �׻� null�̴�
SELECT userid, usernm, reg_dt,
       reg_dt + 5 reg_dtafter5,
       reg_dt - 5 as reg_dt_before5
FROM users;

COMMIT;
UPDATE users SET reg_dt = null
WHERE userid = 'moon';


DELETE USERS
WHERE userid not in('brown', 'cony', 'sally', 'james', 'moon');

SELECT
    *
FROM users;

commit;

-- prod ���̺��� prod_id, prod_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--  (�� prod_id -> id, prod_name -> name ���� �÷� ��Ī�� ����)
SELECT prod_id as id,prod_name as name
FROM prod;

--lprod ���̺��� lprod_gu, lprod_nm �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--  (�� lprod_gu -> gu, lprod_nm -> nm���� �÷� ��Ī�� ����)
SELECT lprod_gu as gu, lprod_nm as nm
FROM lprod;

--buyer ���̺��� buyer_id, buyer_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--  (�� buyer_id ->���̾���̵�, buyer_name -> �̸����� �÷���Ī�� ����)
SELECT buyer_id as ���̾���̵�, buyer_name as �̸�
FROM buyer;

--���ڿ� ����
-- java + --> sql ||
-- CONCAT(str,str) �Լ�
-- users���̺��� userid,usernm
SELECT userid, usernm,
       userid || usernm,
       CONCAT(userid, usernm)
FROM users;

--���ڿ� ��� (�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' || userid,
        CONCAT('����� ���̵� : ', userid)
FROM users;

--�ǽ� sel_con1
SELECT *
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name ||';' as QUERY
FROM user_tables;

--desc table : �ش� ���̺� ���� ������ ������ �˷���
--���̺� ���ǵ� �÷��� �˰� ���� ��
--1. desc
--2. select * ....
desc emp;

SELECT *
FROM emp;

--WHERE��, ���� ������
SELECT *
FROM users
WHERE userid = 'brown';


--usernm�� ������ �����͸� ��ȸ�ϴ� ������ �ۼ�
SELECT *
FROM users
WHERE usernm = '����';
