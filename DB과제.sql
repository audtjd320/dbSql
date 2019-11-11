--������ ����(hr����, �ǽ� join 8~13)

--�ǽ� join8
/*
    erd ���̾�׷��� �����Ͽ� countries, regions���̺��� �̿��Ͽ�
    ������ �Ҽ� ������ ������ ���� ����� �������� ������ �ۼ��غ�����
    (������ ������ ����)
    */


SELECT a.region_id, region_name, a.country_name
FROM countries a, regions b
WHERE a.region_id = b.region_id
AND region_name = 'Europe';

--�ǽ� join9
/*
     erd ���̾�׷��� �����Ͽ� countries, regions locations���̺���
     �̿��Ͽ� ������ �Ҽ� ����, ������ �Ҽӵ� ���� �̸��� ������ ���� �����
     �������� ������ �ۼ��ϼ���.
     (������ ������ ����)
     */
SELECT  a.region_id, region_name, a.country_name, CITY  
FROM countries a, regions b, locations c
WHERE a.region_id = b.region_id
AND a.country_id = c.country_id
AND region_name = 'Europe';   

--�ǽ�join10
/*
    erd���̾�׷��� �����Ͽ� countries, regions, locations, departments
    ���̺��� �̿��Ͽ� ������ �Ҽ� ����,������ �Ҽӵ� ���� �̸� �� ���ÿ� �ִ�
    �μ��� ������ ���� ����� �������� ������ �ۼ��� ������.
    (������ ������ ����)
    */

SELECT  a.region_id, region_name, a.country_name, CITY, department_name
FROM countries a, regions b, locations c,departments d
WHERE a.region_id = b.region_id
AND a.country_id = c.country_id
AND c.location_id = d.location_id
AND region_name = 'Europe'; 

--�ǽ�join 11
/*
     erd���̾�׷��� �����Ͽ� countries, regions, locations, departments
    employees���̺��� �̿��Ͽ� ������ �Ҽ� ����,������ �Ҽӵ� ���� �̸� �� ���ÿ� �ִ�
    �μ�, �μ��� �Ҽӵ� ���������� ������ ���� ����� �������� ������ �ۼ��� ������.
    (������ ������ ����)
 */
 
 SELECT  a.region_id, region_name, a.country_name, CITY, d.department_name, CONCAT(first_name,last_name) name
FROM countries a, regions b, locations c,departments d,employees e
WHERE a.region_id = b.region_id
AND a.country_id = c.country_id
AND c.location_id = d.location_id
AND d.department_id = e.department_id
AND region_name = 'Europe';

--�ǽ�join 12
/*
     erd���̾�׷��� �����Ͽ� employees, jobs ���̺��� �̿��Ͽ� ������
     ������ ��Ī�� �����Ͽ� ������ ���� ����� �������� ������ �ۼ��غ�����
 */
SELECT employee_id, CONCAT(first_name,last_name) name, a.job_id, job_title
FROM employees a, jobs b
WHERE a.job_id= b.job_id;

--�ǽ�join 13
/*
    erd���̾�׷��� �����Ͽ� employees, jobs ���̺��� �̿��Ͽ� ������
     ������ ��Ī, ������ �Ŵ��� ���� �����Ͽ� ������ ���� ����� ��������
     ������ �ۼ��غ�����
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