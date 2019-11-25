--member 테이블을 이용하여 member2 테이블 생성
--member2 테이블에서
--김은대 회원(mem_id='a001')의 직업(mem_id)을 '군인'으로 변경후
--commit하고 조회

CREATE TABLE member2 AS
SELECT *
FROM member;

SELECT *
FROM member2;

UPDATE member2 SET mem_job = '군인'
WHERE mem_id = 'a001';
commit;

SELECT mem_id, mem_name, mem_job
FROM member2
WHERE mem_id = 'a001';

--제품별 제품 구매 수량(BUY_QTY) 합계, 제품 구입 금액(BUY_COST) 합계
--제품코드, 제품명, 수량합계, 금액합계
--VW_PROD_BUY(view 생성)
select * from buyprod;
select * from prod;

CREATE OR REPLACE VIEW vw_prod_buy AS 
SELECT buy_prod, prod_name, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod a, prod b
WHERE a.buy_prod = b.prod_id
GROUP BY buy_prod, prod_name, buy_prod;

select *
from user_views;

--분석함수/window함수(도전해보기 실습ana0)
/*
    사원의 부서별 급여(sal)별 순위 구하기
    emp 테이블 사용
    */
SELECT *
FROM emp;

select b.*, decode(deptno, 20, rownum)
from
(select a.* , decode(a. deptno,10, rownum)
from
    (select ename, sal, deptno
    from emp
    group by ename, sal, deptno
    order by deptno, sal desc) a
where deptno = (select deptno
                from emp
                where emp.deptno = a.deptno
                group by deptno))b;
--선생님 풀이
--부서별 랭킹
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
     FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a, 
(SELECT b.rn, ROWNUM j_rn
FROM 
(SELECT a.deptno, b.rn 
 FROM
    (SELECT deptno, COUNT(*) cnt --3, 5, 6
     FROM emp
     GROUP BY deptno )a,
    (SELECT ROWNUM rn --1~14
     FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;

select ename, sal, deptno,
       row_number() over(partition by deptno order by sal desc) rank
from emp;