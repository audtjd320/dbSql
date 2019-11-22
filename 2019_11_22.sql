--h_2 �����ý��ۺ� ������ ���� �������� ��ȸ (dept0_02)
SELECT level lv, deptcd, lpad(' ', (level-1)*4,' ') || deptnm deptnm, P_deptcd
FROM dept_h a
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd; -- PRIOR�� ���� ���� ���� �����͸� ����Ŵ

--����� ��������
--Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž���� �ƴϴ�)
--���������� �������� ���� �μ��� ��ȸ
--�������� dept0_00_0
SELECT *
FROM dept_h;
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;

create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

commit;

--�������� �ǽ� h_4
/*
    ���������� ����.sql�� �̿��Ͽ� ���̺��� �����ϰ� ����������
    ����� �������� ������ �ۼ� �Ͻÿ�.
    s_id  : ��� ���̵�
    ps_od : �θ� ��� ���̵�
    value : ��� ��
    */
--h_4 : ����� ����
SELECT LPAD(' ',4*(level-1),' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

--�������� �ǽ� h_5
/*
    ���������� ��ũ��Ʈ.sql�� �̿��Ͽ� ���̺��� �����ϰ� ����������
    ����� �������� ������ �ۼ� �Ͻÿ�.
    org_cd  : �μ��ڵ�
    parent_org_cd : �θ� �μ��ڵ�
    no_emp : �μ� �ο���
    -- PRIOR�� ���� ���� ���� �����͸� ����Ŵ
    */
select *
from no_emp;

select level, LPAD(' ',4*(level-1),' ') || org_cd  org_cd, no_emp
from no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd =  parent_org_cd;

--pruning branch (����ġ��)
--������������ [WHERE]���� START WITH, CONNECT BY ���� ���� ����� ���Ŀ� ����ȴ�.

--dept_h���̺��� �ֻ��� ������ ��������� ��ȸ
select deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
from dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--���������� �ϼ��� ���� where���� ����ȴ�. 
-- ������ȹ�� �� �Ѱ��� ������
select level,deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
from dept_h
where deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--������ȹ�� �Ҽ� �� ������
select level,deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
from dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
             AND deptnm != '������ȹ��';

             
--CONNECT_BY_ROOT(col) : col�� �ֻ��� ��� �÷� ��
--SYS_CONNECT_BY_PATH(col, ������) : col�� �������� ������ �����ڷ� ���� ���
--  . LTRIM�� ���� �ֻ��� ��� ������ �����ڸ� ���� �ִ� ���°� �Ϲ���
--CONNECT_BY_ISLEAF : �ش� row�� ������ leaf node���� �Ǻ�(1 : O, 0 : X)

select LPAD(' ', 4*(level-1), ' ') || org_cd ord_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-') path_org_cd,
       CONNECT_BY_ISLEAF isleaf -- ���� ���� �������� 1�� ǥ�� �������� 0
from no_emp
start with org_cd = 'XXȸ��'
connect by prior org_cd = parent_org_cd;

create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

--h6
select *
from board_test;

--�ǽ� �Խñ� ���������� h6
/*
    �Խñ��� �����ϴ� board_test ���̺��� �̿��Ͽ� ���� ������ �ۼ��Ͻÿ�.
    */
select seq, lpad(' ', (level-1)*4,' ') || title title
from board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq;

--�ǽ� �Խñ� h7,H8
/*
    �Խñ��� ���� �ֽű��� �ֻ����� �´�. ���� �ֽű��� ������ �����Ͻÿ�.
    */
select seq, lpad(' ', (level-1)*4,' ') || title title
from board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY SEQ DESC; --SIBLINGS : ���� => ���� ������� ����

--�ǽ� �Խñ� H9
/*
    �Ϲ����� �Խ����� ����
    �ֻ������� �ֽű��� ���� ����, ����� ��� �ۼ��� ������� ������ �ȴ�.
    ��� �ϸ� �ֻ������� �ֽű� ��(desc)���� �����ϰ�,
    ����� ����(asc)������ ���� �� �� ������?
    */