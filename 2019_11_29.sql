--CURSOR�� ��������� �������� �ʰ�
--LOOP���� inline ���·� CURSOR ���

set serveroutput on;
--�͸���
DECLARE
    --cursor ���� --> LOOP���� inline ����
BEGIN
    --FOR ���ڵ� IN �����Ŀ�� LOOP
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

-- �ǽ� PRO_3
CREATE OR REPLACE PROCEDURE avgdt (p_deptno IN dt.dt%TYPE,
                                   p_loc IN dt.loc%TYPE)
IS
    --�����
BEGIN
    -- dt ���̺� ��� ������ ��ȸ
     i := 1;
     FOR rec IN (SELECT dt FROM dt ORDER BY dt) LOOP
     DBMS_OUTPUT.PUT_LINE(rec.dt);
     rs := rec.dt;
     rs := rs + rec.dt;
     END LOOP;
END;
/
SELECT *
FROM DT;