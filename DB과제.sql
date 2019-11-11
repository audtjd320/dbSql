--데이터 결합(hr계정, 실습 join 8~13)

--실습 join8
/*
    erd 다이어그램을 참고하여 countries, regions테이블을 이용하여
    지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
    (지역은 유럽만 한정)
    */


SELECT a.region_id, region_name, a.country_name
FROM countries a, regions b
WHERE a.region_id = b.region_id
AND region_name = 'Europe';

--실습 join9
/*
     erd 다이어그램을 참고하여 countries, regions locations테이블을
     이용하여 지역별 소속 국가, 국가에 소속된 도시 이름을 다음과 같은 결과가
     나오도록 쿼리를 작성하세요.
     (지역은 유럽만 한정)
     */
SELECT  a.region_id, region_name, a.country_name, CITY  
FROM countries a, regions b, locations c
WHERE a.region_id = b.region_id
AND a.country_id = c.country_id
AND region_name = 'Europe';   

--실습join10
/*
    erd다이어그램을 참고하여 countries, regions, locations, departments
    테이블을 이용하여 지역별 소속 국가,국가에 소속된 도시 이름 및 도시에 있는
    부서를 다음과 같은 결과가 나오도록 쿼리를 작성해 보세요.
    (지역은 유럽만 한정)
    */

SELECT  a.region_id, region_name, a.country_name, CITY, department_name
FROM countries a, regions b, locations c,departments d
WHERE a.region_id = b.region_id
AND a.country_id = c.country_id
AND c.location_id = d.location_id
AND region_name = 'Europe'; 

--실습join 11
/*
     erd다이어그램을 참고하여 countries, regions, locations, departments
    employees테이블을 이용하여 지역별 소속 국가,국가에 소속된 도시 이름 및 도시에 있는
    부서, 부서에 소속된 직원정보를 다음과 같은 결과가 나오도록 쿼리를 작성해 보세요.
    (지역은 유럽만 한정)
 */
 
 SELECT  a.region_id, region_name, a.country_name, CITY, d.department_name, CONCAT(first_name,last_name) name
FROM countries a, regions b, locations c,departments d,employees e
WHERE a.region_id = b.region_id
AND a.country_id = c.country_id
AND c.location_id = d.location_id
AND d.department_id = e.department_id
AND region_name = 'Europe';

--실습join 12
/*
     erd다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의
     담당업무 명칭을 포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
 */
SELECT employee_id, CONCAT(first_name,last_name) name, a.job_id, job_title
FROM employees a, jobs b
WHERE a.job_id= b.job_id;

--실습join 13
/*
    erd다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의
     담당업무 명칭, 직원의 매니저 정보 포함하여 다음과 같은 결과가 나오도록
     쿼리를 작성해보세요
 */
SELECT  manager_id, 'StevenKing' name,  employee_id, CONCAT(first_name,last_name) name, a.job_id, job_title
FROM employees a, jobs b
WHERE a.job_id= b.job_id
AND employee_id >= 120
AND a.job_id IN('ST_MAN', 'SA_MAN')
ORDER BY employee_id;

SELECT  manager_id, 'StevenKing' name,  employee_id, CONCAT(first_name,last_name) name, a.job_id, job_title
FROM employees a, jobs b
WHERE a.job_id= b.job_id
AND a.job_id IN('ST_MAN', 'SA_MAN')
ORDER BY employee_id;

select b.manager_id, CONCAT(a.first_name,a.last_name) mgr_name, b.employee_id, CONCAT(b.first_name,b.last_name) name, c.job_id, c.job_title
FROM employees a JOIN employees b ON(a.employee_id = b.manager_id) JOIN jobs c ON(b.job_id= c.job_id);



select * from countries;
select * from regions;
select * from locations;
select * from departments;
select * from employees;
select * from jobs;
desc employees;