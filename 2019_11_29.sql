--CURSOR를 명시적으로 선언하지 않고
--LOOP에서 inline 형태로 CURSOR 사용

set serveroutput on;
--익명블록
DECLARE
    --cursor 선언 --> LOOP에서 inline 선언
BEGIN
    --FOR 레코드 IN 선언된커서 LOOP
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
END;
/

-- 실습 PRO_3
CREATE OR REPLACE PROCEDURE avgdt (p_deptno IN dt.dt%TYPE,
                                   p_loc IN dt.loc%TYPE)
IS
    --선언부
BEGIN
    -- dt 테이블 모든 데이터 조회
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