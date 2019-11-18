SELECT *
FROM fastfood
WHERE GB = '�Ե�����';      -- 912

SELECT *
FROM fastfood
WHERE GB = '����ŷ';       -- 282

SELECT SIDO, SIGUNGU, COUNT(*) CNT
FROM fastfood
WHERE GB = '�Ƶ�����'
GROUP BY SIGUNGU, SIDO;     -- 468

SELECT COUNT(*)
FROM fastfood
WHERE GB = 'KFC';       -- 111

SELECT *
FROM
    (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '�Ƶ�����'
    GROUP BY SIGUNGU, SIDO) a
    ,
     (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '����ŷ'
    GROUP BY SIGUNGU, SIDO) b
    ,
    (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = 'KFC'
    GROUP BY SIGUNGU, SIDO) c;

--�õ�,�ñ����� �����(����ŷ, �Ƶ�����, KFC) :
--�õ�,�ñ����� �����(�Ե�����) :
SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '����ŷ' OR  GB = '�Ƶ�����' OR GB = 'KFC'  
    GROUP BY SIDO, SIGUNGU
    order by cnt desc;
    
SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '�Ե�����'
    GROUP BY SIDO, SIGUNGU
    order by cnt desc;

SELECT a.sido, a.sigungu, a.cnt , b.cnt, ROUND(a.cnt/b.cnt,2) finalcnt
FROM 
    (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '����ŷ' OR  GB = '�Ƶ�����' OR GB = 'KFC'  
    GROUP BY SIDO, SIGUNGU ) a,
    
    (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '�Ե�����'
    GROUP BY SIDO, SIGUNGU) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY finalcnt desc;