--h_2 정보시스템부 하위의 조직 계층구조 조회 (dept0_02)
SELECT level lv, deptcd, lpad(' ', (level-1)*4,' ') || deptnm deptnm, P_deptcd
FROM dept_h a
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd; -- PRIOR는 내가 현재 읽은 데이터를 가리킴

--상향식 계층쿼리
--특정 노드로부터 자신의 부모노드를 탐색(트리 전체 탐색이 아니다)
--디자인팀을 시작으로 상위 부서를 조회
--디자인팀 dept0_00_0
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

--계층쿼리 실습 h_4
/*
    계층형쿼리 복습.sql을 이용하여 테이블을 생성하고 다음과같은
    결과가 나오도록 쿼리를 작성 하시오.
    s_id  : 노드 아이디
    ps_od : 부모 노드 아이디
    value : 노드 값
    */
--h_4 : 하향식 쿼리
SELECT LPAD(' ',4*(level-1),' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

--계층쿼리 실습 h_5
/*
    계층형쿼리 스크립트.sql을 이용하여 테이블을 생성하고 다음과같은
    결과가 나오도록 쿼리를 작성 하시오.
    org_cd  : 부서코드
    parent_org_cd : 부모 부서코드
    no_emp : 부서 인원수
    -- PRIOR는 내가 현재 읽은 데이터를 가리킴
    */
select *
from no_emp;

select level, LPAD(' ',4*(level-1),' ') || org_cd  org_cd, no_emp
from no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd =  parent_org_cd;

--pruning branch (가지치기)
--계층쿼리에서 [WHERE]절은 START WITH, CONNECT BY 절이 전부 적용된 이후에 실행된다.

--dept_h테이블을 최상위 노드부터 하향식으로 조회
select deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
from dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--계층쿼리가 완성된 이후 where절이 적용된다. 
-- 정보기획부 인 한개만 없어짐
select level,deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
from dept_h
where deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--정보기획부 소속 다 없어짐
select level,deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
from dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
             AND deptnm != '정보기획부';

             
--CONNECT_BY_ROOT(col) : col의 최상위 노드 컬럼 값
--SYS_CONNECT_BY_PATH(col, 구분자) : col의 계층구조 순서를 구분자로 이은 경로
--  . LTRIM을 통해 최상위 노드 왼쪽의 구분자를 없애 주는 형태가 일반적
--CONNECT_BY_ISLEAF : 해당 row가 마지막 leaf node인지 판별(1 : O, 0 : X)

select LPAD(' ', 4*(level-1), ' ') || org_cd ord_cd,
       CONNECT_BY_ROOT(org_cd) root_org_cd,
       LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-') path_org_cd,
       CONNECT_BY_ISLEAF isleaf -- 제일 하위 계층에만 1을 표시 나머지는 0
from no_emp
start with org_cd = 'XX회사'
connect by prior org_cd = parent_org_cd;

create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

--h6
select *
from board_test;

--실습 게시글 계층형쿼리 h6
/*
    게시글을 저장하는 board_test 테이블을 이용하여 계층 쿼리를 작성하시오.
    */
select seq, lpad(' ', (level-1)*4,' ') || title title
from board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq;

--실습 게시글 h7,H8
/*
    게시글은 가장 최신글이 최상위로 온다. 가장 최신글이 오도록 정렬하시오.
    */
select seq, lpad(' ', (level-1)*4,' ') || title title
from board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY SEQ DESC; --SIBLINGS : 동기 => 같은 형제들로 묶음

--실습 게시글 H9
/*
    일반적인 게시판을 보면
    최상위글은 최신글이 먼저 오고, 답글의 경우 작성한 순서대로 정렬이 된다.
    어떻게 하면 최상위글은 최신글 순(desc)으로 정렬하고,
    답글은 순차(asc)적으로 정렬 할 수 있을까?
    */