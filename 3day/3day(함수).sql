-- 함수(Function)

-- 상품코드별 구매수량에 대한 최대값, 최소값, 평균값, 합계, 갯수 조회하기
-- 조회컬럼 상품코드, 최대값, 최소값, 평균값, 합계, 갯수 조회하기
-- 1. cart

SELECT cart_prod, MAX(cart_qty) AS mqty, 
                  MIN(cart_qty) AS mqty, 
                  ROUND(AVG(cart_qty), 2) AS aqty, 
                  SUM(cart_qty) AS sqty, 
                  COUNT(cart_qty) AS cqty
  FROM cart
 GROUP BY cart_prod;

-- [문제] 2005년도 7월 11일이라 가정하고 장바구니테이블에 발생될 추가 주문번호를 검색하시오
-- 조회컬럼 : 현재 마지막 주문번호, 추가 주문번호

SELECT MAX(cart_no) AS mno, MAX(cart_no)+1 AS mpno
  FROM cart
 WHERE SUBSTR(cart_no,1,8) = 20050711;

SELECT MAX(cart_no) AS mno, MAX(cart_no)+1 AS mpno
  FROM cart
 WHERE SUBSTR(cart_no,1,8) LIKE '20050711%';
 
-- [문제2] 회원테이블의 회원전체의 마일리지 평균, 마일리지 합계, 
-- 최고 마일리지, 최소 마일리지, 인원수를 검색하시오 

SELECT ROUND(AVG(mem_mileage),2) AS am, 
       SUM(mem_mileage) AS sm, 
       MAX(mem_mileage) AS mm,
       MIN(mem_mileage) AS mim, 
       COUNT(mem_mileage) AS cm
  FROM member;
  
-- [문제]
-- 상품테이블에서 거래처별, 상품분류코드별로,
-- 판매가에 대한 최고, 최소, 자료수, 평균, 합계를 조회해주세요
-- 정렬은 자료수를 기준으로 내림차순

SELECT prod_buyer, prod_lgu, 
        MAX(prod_sale) AS ms,
        MIN(prod_sale) AS mis, 
        COUNT(prod_sale) AS cs, 
        ROUND(AVG(prod_sale),2) AS asl, 
        SUM(prod_sale) AS sum_s
  FROM prod
 GROUP BY prod_buyer, prod_lgu
 ORDER BY cs DESC;
 
-- [문제2]
-- 상품테이블에서 거래처별, 상품분류코드별로,
-- 판매가에 대한 최고, 최소, 자료수, 평균, 합계를 조회해주세요
-- 정렬은 자료수를 기준으로 내림차순
--  + 추가로, 거래처명, 상품분류명도 조회
-- 1. prod

SELECT prod_buyer, prod_lgu, 
        MAX(prod_sale) AS ms,
        MIN(prod_sale) AS mis, 
        COUNT(prod_sale) AS cs, 
        ROUND(AVG(prod_sale),2) AS asl, 
        SUM(prod_sale) AS sum_s,
        (SELECT DISTINCT buyer_name
           FROM buyer 
          WHERE buyer_id = prod_buyer) AS bname,
        (SELECT DISTINCT lprod_nm
           FROM lprod 
          WHERE lprod_gu = prod_lgu) AS pname
  FROM prod
 GROUP BY prod_buyer, prod_lgu
 ORDER BY cs DESC;
 
-- [문제3]
-- 상품테이블에서 거래처별, 상품분류코드별로,
-- 판매가에 대한 최고, 최소, 자료수, 평균, 합계를 조회해주세요
-- 정렬은 자료수를 기준으로 내림차순
-- 2. 추가로, 거래처명, 상품분류명도 조회
-- 3. 단, 합계가 100 이상인 것

SELECT prod_buyer, prod_lgu, 
        MAX(prod_sale) AS ms,
        MIN(prod_sale) AS mis, 
        COUNT(prod_sale) AS cs, 
        ROUND(AVG(prod_sale),2) AS asl, 
        SUM(prod_sale) AS sum_s,
        (SELECT DISTINCT buyer_name
           FROM buyer 
          WHERE buyer_id = prod_buyer) AS bname,
        (SELECT DISTINCT lprod_nm
           FROM lprod 
          WHERE lprod_gu = prod_lgu) AS pname
  FROM prod
 GROUP BY prod_buyer, prod_lgu
 HAVING SUM(prod_sale) >= 100
 ORDER BY cs DESC;
 
-- NULL
UPDATE buyer 
   SET buyer_charger = NULL
 WHERE buyer_charger LIKE '김%';
 
UPDATE buyer 
   SET buyer_charger = ''
 WHERE buyer_charger LIKE '성%';
 
 SELECT buyer_charger  
   FROM buyer
  WHERE buyer_charger is NULL;
  
SELECT buyer_name, buyer_charger
  FROM buyer
 WHERE buyer_charger IS NULL;
 
SELECT buyer_name, buyer_charger
  FROM buyer
 WHERE buyer_charger IS NOT NULL;

SELECT buyer_name, 
       NVL(buyer_charger, '없다') AS charger
  FROM buyer;
-- NVL(col, 대체값)
  
-- ★ DECODE(조건문 함수) = IF
IF SUBSTR(prod_lgu, 1, 2) == 'P1':
    PRINT('컴퓨터/전자제품')
ELIF SUBSTR(prod_lgu, 1, 2) == 'P2':
    PRINT('의류')


SELECT prod_lgu,
       DECODE (SUBSTR(prod_lgu, 1, 2),
               'P1', '컴퓨터/전자제품',
               'P2', '의류',
               'P3', '잡화',
               '기타') AS lgu_nm
  FROM prod;
  
-- EXITS(한개의 TABLE 조회)
SELECT prod_id, prod_name, prod_lgu
  FROM prod
 WHERE EXISTS (
        SELECT lprod_gu
          FROM lprod
         WHERE lprod_gu = prod_lgu);
         
