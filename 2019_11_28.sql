-- 실습 PRO_2
CREATE OR REPLACE PROCEDURE registdept_test (p_deptno IN dept.deptno%TYPE,
                                             p_dname IN dept.dname%TYPE,
                                             p_loc IN dept.loc%TYPE)
IS
    
BEGIN
    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);
END;
/
exec registdept_test(60, 'test', 'seoul'); --타입도 맞춰서 넣어야함.

select *
from dept_test;

--실습 PRO_3
CREATE OR REPLACE PROCEDURE UPDATEdept_test (p_deptno IN dept.deptno%TYPE,
                                             p_dname IN dept.dname%TYPE,
                                             p_loc IN dept.loc%TYPE)
IS

BEGIN
    UPDATE dept_test SET dname = p_dname, loc = p_loc
    WHERE deptno = p_deptno;
    commit;
END;
/
exec UPDATEdept_test(99, 'ddit_m', 'daejeon');

SELECT *
FROM dept_test;

----------------------------
--ROWTYPE : 테이블의 한 행의 데이터를 담을 수 있는 참조 타입
set serveroutput on;
DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ', ' || dept_row.dname || ', ' || dept_row.loc);
END;
/

--복합변수 : record
DECLARE
    --UserVo userVo;
    TYPE dept_row IS RECORD(  --dept_row라는 레토드타입 생성, 한행에 두개의 컬럼
        deptno NUMBER(2),
        dname dept.dname%TYPE);
    
    v_dname dept.dname%TYPE;    
    v_row dept_row;      -- 변수명 타입
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line( v_row.deptno || ', ' || v_row.dname);
END;
/

--tabletype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    
    --java : 타입 변수명;
    --pl/sql : 변수명 타입;
    v_dept dept_tab; 
    bi BINARY_INTEGER;
BEGIN
    bi := 100;

    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    DBMS_OUTPUT.PUT_LINE(bi);
    -- list.size() ==> 테이블명.count (길이??)
    FOR i IN 1..v_dept.count LOOP
    DBMS_OUTPUT.PUT_LINE(v_dept(i).dname); -- 인덱스 1부터 시작
    END LOOP;
END;
/

--IF
--  ELSE IF --> ELSIF
-- END IF;
DECLARE
    ind BINARY_INTEGER; --BINARY_INTEGER : 인덱스의 타입
BEGIN
    ind := 2; --대입연산자
    
    IF ind = 1 THEN
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN
        dbms_output.put_line('ELSIF ' || ind);
    ELSE 
        dbms_output.put_line('ELSE');
    END IF;
END;
/

--FOR LOOP :
--FOR 인덱스 변수 IN 시작값..종료값 LOOP
--END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        DBMS_OUTPUT.PUT_LINE('i : ' || i);
    END LOOP;
END;
/


--LOOP : 계속 실행 판단 로직을 LOOP 안에서 제어
--java : while(true)

DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        i := i + 1;
        -- LOOP 계속 진행여부 판단 (조건)
        EXIT WHEN i >=5;
    END LOOP;
END;
/

 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;

--실습 PRO_3
--dt테이블의 dt(날짜
-- 간격 평균 : 5일
DECLARE
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    
    dtdt dt_tab;
    i NUMBER;
    dt_sum NUMBER;
    --dt_sum NUMBER := 0; -- 변수 선언과 초기화 동시가능
BEGIN
    i := 1;
    dt_sum := 0;
    SELECT *
    BULK COLLECT INTO dtdt
    FROM dt
    ORDER BY dt desc ; -- 값의 조회순서가 변할 수 있으니 정렬후 하는것을 추천
    
    
    LOOP
       
        DBMS_OUTPUT.PUT_LINE(dtdt(i).dt-(dtdt(i+1).dt));
        dt_sum := dt_sum + dtdt(i).dt-(dtdt(i+1).dt);
         i := i + 1;
        
         EXIT WHEN i = dtdt.count;
    END LOOP;
         DBMS_OUTPUT.PUT_LINE('간격 평균 : ' || dt_sum/(dtdt.count-1) || '일');
END;
/

-- lead, lag 현재행의 이전, 이후 데이터를 가져올 수 있다.
select AVG(diff)
from
    (SELECT dt, lead(dt) over(order by dt desc),
           dt - lead(dt) over(order by dt desc) diff
     FROM dt
order by dt desc);

--분석함수를 사용하지 못하는 환경에서
select avg(c)
from
    (select a.dt, a.rn, b.rn, (a.dt-b.dt) c
    from
        (select rownum rn, dt
        from
            (select dt
             from dt
             order by dt desc) a)a,
        (select rownum rn, dt
        from
            (select dt
             from dt
             order by dt desc) b)b
    where a.rn = b.rn(+)-1);

-- HALL OF HONOR
select (max(dt)-MIN(dt))/ (count(*)-1)
from dt;


--cursor
--여러건의 데이터를 테이블타입 없이 작업
DECLARE
    --커서 선언
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    --커서 열기
    OPEN dept_cursor;
    LOOP 
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ', ' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; -- 더이상 읽을 데이커가 없을 때 종료
    END LOOP;
END;
/

--FOR LOOP CURSOR 결합
DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;    
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ', ' || rec.dname);
    END LOOP;
    
END;
/

--파라미터가 있는 명시적 커서
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;
        
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
    dbms_output.put_line(emp.empno || ', ' || emp.ename ||', '|| emp.job);
    END LOOP;
END;
/