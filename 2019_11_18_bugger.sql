SELECT *
FROM fastfood
WHERE GB = '롯데리아';      -- 912

SELECT *
FROM fastfood
WHERE GB = '버거킹';       -- 282

SELECT SIDO, SIGUNGU, COUNT(*) CNT
FROM fastfood
WHERE GB = '맥도날드'
GROUP BY SIGUNGU, SIDO;     -- 468

SELECT COUNT(*)
FROM fastfood
WHERE GB = 'KFC';       -- 111

SELECT *
FROM
    (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '맥도날드'
    GROUP BY SIGUNGU, SIDO) a
    ,
     (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '버거킹'
    GROUP BY SIGUNGU, SIDO) b
    ,
    (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = 'KFC'
    GROUP BY SIGUNGU, SIDO) c;

--시도,시군구별 매장수(버거킹, 맥도날드, KFC) :
--시도,시군구별 매장수(롯데리아) :
SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '버거킹' OR  GB = '맥도날드' OR GB = 'KFC'  
    GROUP BY SIDO, SIGUNGU
    order by cnt desc;
    
SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '롯데리아'
    GROUP BY SIDO, SIGUNGU
    order by cnt desc;

SELECT a.sido, a.sigungu, a.cnt , b.cnt, ROUND(a.cnt/b.cnt,2) finalcnt
FROM 
    (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '버거킹' OR  GB = '맥도날드' OR GB = 'KFC'  
    GROUP BY SIDO, SIGUNGU ) a,
    
    (SELECT SIDO, SIGUNGU, COUNT(*) CNT
    FROM fastfood
    WHERE GB = '롯데리아'
    GROUP BY SIDO, SIGUNGU) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY finalcnt desc;