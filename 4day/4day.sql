-- 4day
-- [문제1]
-- 상품테이블과 상품분류테이블에서 상품분류코드가 'P101'인 것에 대한
-- 상품분류코드(상품테이블에 있는 컬럼), 상품명, 상품분류명을 조회해주세요
-- 정렬은 상품아이디로 내림차순

-- <일반방식>
SELECT prod_lgu, prod_name, lprod_nm
  FROM prod, lprod
 WHERE prod_lgu = lprod_gu
   AND lprod_gu = 'P101'
 ORDER BY prod_id DESC;
 
-- <표준방식>
SELECT prod_lgu, prod_name, lprod_nm
  FROM lprod INNER JOIN prod
                ON (lprod_gu = prod_lgu)
               AND lprod_gu = 'P101'
 ORDER BY prod_id DESC;
 
-- [문제2]
-- 김형모 회원이 구매한 상품에 대한
-- 거래처 정보를 확인하려고 합니다.
-- 거래처코드, 거래처명, 회원거주지역(서울 or 인천) 조회
-- 단, 상품분류명 중에 캐주얼 단어가 포함된 제품에 대해서만

-- <일반>
SELECT buyer_id, buyer_name, SUBSTR(buyer_add1,1,2) AS add1
  FROM buyer, prod, lprod ,cart, member
 WHERE buyer_id = prod_buyer
   AND lprod_gu = prod_lgu
   AND cart_prod = prod_id
   AND cart_member = mem_id
   AND mem_name = '김형모'
   AND lprod_nm LIKE '%캐주얼%';
   
-- <표준>  
SELECT buyer_id, buyer_name, SUBSTR(buyer_add1,1,2) AS add1
  FROM buyer INNER JOIN prod
                     ON (buyer_id = prod_buyer)
             INNER JOIN lprod
                     ON (lprod_gu = prod_lgu
                    AND lprod_nm LIKE '%캐주얼%')
             INNER JOIN cart
                     ON (cart_prod = prod_id)
             INNER JOIN member
                     ON (cart_member = mem_id
                    AND mem_name = '김형모');

-- [문제3]                    
-- 상품분류명에 '전자'가 포함된 상품을 구매한 회원 조회하기
-- 회원아이디, 회원이름, 상품분류명 조회하기
-- 단, 상품명에 삼성전자가 포함된 상품을 구매한 회원과
--     회원의 취미가 수영인 회원

-- 1. TABLE = lprod, prod, cart, member
SELECT mem_id, mem_name, lprod_nm
  FROM lprod, prod, cart, member
 WHERE lprod_gu = prod_lgu
   AND cart_prod = prod_id
   AND cart_member = mem_id
   AND lprod_nm LIKE '%전자%'
   AND prod_name LIKE '%삼성전자%'
   AND mem_like = '수영';

-- [문제4]
-- 상품분류테이블과 상품테이블과 거래처테이블과 장바구니 테이블 사용
-- 상품분류코드가 'P101' 인것을 조회
-- 그리고, 정렬은 상품분류명을 기준으로 내림차순
--                상품아이디를 기준으로 오름차순 하세요
-- 상품분류명, 상품아이디, 상품판매가, 거래처담당자, 회원아이디, 주문수량 을 조회

-- 1. TABLE = lprod, prod, buyer, cart
-- 2. 관계
-- lprod_gu = prod_lgu
-- buyer_id = prod_buyer
-- cart_prod = prod_id

-- <일반>
SELECT lprod_nm, prod_id, prod_sale, buyer_charger, cart_member, cart_qty
  FROM lprod, prod, buyer, cart
 WHERE lprod_gu = prod_lgu
   AND buyer_id = prod_buyer
   AND cart_prod = prod_id
   AND lprod_gu = 'P101'
 ORDER BY lprod_nm DESC, prod_id ASC;

-- <표준>
SELECT lprod_nm, prod_id, prod_sale, buyer_charger, cart_member, cart_qty
  FROM lprod INNER JOIN prod
                ON (lprod_gu = prod_lgu)
                AND lprod_gu = 'P101'
             INNER JOIN buyer
                ON (buyer_id = prod_buyer)
             INNER JOIN cart
                ON (cart_prod = prod_id)
 ORDER BY lprod_nm DESC, prod_id ASC;

--[문제5]
-- 상품코드별 구매수량에 대한 최대값, 최소값, 평균값, 합계, 갯수 조회하기
-- 단, 상품명에 삼성이 포함된 상품을 구매한 회원에 대해서만
-- 조회컬럼 상품코드, 최대값, 최소값, 평균값, 합계, 갯수

-- <일반>
SELECT cart_prod, MAX(cart_qty) AS mqty,
                  MIN(cart_qty) AS minqty,
                  ROUND(AVG(cart_qty), 2) AS aqty,
                  SUM(cart_qty) AS sqty,
                  COUNT(cart_qty) AS cqty
  FROM prod, cart
 WHERE prod_id = cart_prod
   AND prod_name LIKE '%삼성%'
 GROUP BY cart_prod;

-- <표준>
SELECT cart_prod, MAX(cart_qty) AS mqty,
                  MIN(cart_qty) AS minqty,
                  ROUND(AVG(cart_qty), 2) AS aqty,
                  SUM(cart_qty) AS sqty,
                  COUNT(cart_qty) AS cqty
  FROM prod INNER JOIN cart
               ON (prod_id = cart_prod)
              AND prod_name LIKE '%삼성%'
 GROUP by cart_prod; 
 
-- [문제6]
-- 거래처코드 및 상품분류코드별로,
-- 판매가에 대한 최고, 최소, 자료수, 평균, 합계를 조회해주세요
-- 조회컬럼, 거래처코드, 거래처명, 상품분류코드, 상품분류명,
--           판매가에 대한 최고, 최소, 자료수, 평균, 합계
-- 정렬은 평균을 기준으로 내림차순
-- 단, 판매가의 평균이 100 이상인 것

-- 1. table = buyer, lprod, prod(prod_sale)
-- 2. lprod_gu = prod_lgu / buyer_id = prod_buyer

--   
SELECT buyer_id, buyer_name, lprod_gu, lprod_nm,
        MAX(prod_sale) AS maxs,
        MIN(prod_sale) AS mins,
        COUNT(prod_sale) AS cs,
        ROUND(AVG(prod_sale), 2) AS asl,
        SUM(prod_sale) AS ss
  FROM buyer, lprod, prod
 WHERE buyer_id = prod_buyer
   AND lprod_gu = prod_lgu
 GROUP BY buyer_id, buyer_name, lprod_gu, lprod_nm
HAVING ROUND(AVG(prod_sale), 2) >= 100
 ORDER BY asl DESC;

-- 서브쿼리 사용 
SELECT buyer_id, 
        (SELECT DISTINCT buyer_name
           FROM buyer 
          WHERE buyer_id = prod_buyer) AS bname,
       lprod_gu, 
        (SELECT DISTINCT lprod_nm
           FROM lprod 
          WHERE lprod_gu = prod_lgu) AS pname,
        MAX(prod_sale) AS maxs,
        MIN(prod_sale) AS mins,
        COUNT(prod_sale) AS cs,
        ROUND(AVG(prod_sale), 2) AS asl,
        SUM(prod_sale) AS ss
  FROM buyer, lprod, prod
 WHERE buyer_id = prod_buyer
   AND lprod_gu = prod_lgu
 GROUP BY buyer_id, lprod_gu
 HAVING ROUND(AVG(prod_sale), 2) >= 100
 ORDER BY asl DESC;
  
-- [문제7]
/*
-- 거래처별로 group을 지어서 매입금액의 합을 검색하고자 합니다.
-- 조건은 상품입고테이블의 2005년도 1월의 매입일자(입고일자) 인것들
-- 매입금액 = 매입수량 * 매입금액
-- 조회컬럼 : 거래처코드, 거래처명, 매입금액의 합
-- (매입금액의 합이 NULL인 경우 0으로 조회)
-- 정렬은 거래처 코드 및 거래처명을 기준으로 내림차순
*/

-- 1. TABLE = buyer, buyprod, prod
-- 2. buyer_id = prod_buyer / prod_id = buy_prod

SELECT buyer_id, buyer_name, 
        SUM(NVL(buy_qty * buy_cost, 0)) AS SUMCOST
  FROM buyer, prod, buyprod
 WHERE buyer_id = prod_buyer
   AND prod_id = buy_prod
   AND buy_date BETWEEN '05/01/01' AND '05/01/31'
 GROUP BY buyer_id, buyer_name
 ORDER BY buyer_id DESC, buyer_name DESC ;

-- [문제8]
/*
-- 거래처별로 group을 지어서 매입금액의 합을 계산하여
-- 매입금액의 합이 1천만원 이상인 상품코드, 상품명을 검색하고자 합니다.
-- 조건은 상품입고테이블의 2005년도 1월의 매입일자(입고일자) 인것들
-- 매입금액 = 매입수량 * 매입금액
-- (매입금액의 합이 NULL인 경우 0으로 조회)
-- 조회컬럼 : 상품코드, 상품명
-- 정렬은 상품명을 기준으로 오름차순
*/

-- <서브쿼리>
SELECT prod_id, prod_name
  FROM prod
 WHERE prod_buyer IN( 
        SELECT buyer_id
          FROM buyer, prod, buyprod
         WHERE buyer_id = prod_buyer
           AND prod_id = buy_prod
           AND buy_date BETWEEN '05/01/01' AND '05/01/31'
         GROUP BY buyer_id
         HAVING SUM(NVL(buy_qty * buy_cost, 0)) >= 10000000)      
 ORDER BY prod_name ASC;

-- <JOIN>
SELECT prod_id, prod_name
  FROM buyer, prod, buyprod
 WHERE buyer_id = prod_buyer
   AND prod_id = buy_prod
   AND buy_date BETWEEN '05/01/01' AND '05/01/31'
 GROUP BY prod_id, prod_name
HAVING SUM(NVL(buy_qty * buy_cost, 0)) >= 10000000
 ORDER BY prod_name ASC;

-- 
/*
-- 거래처별로 group을 지어서 매입금액의 합을 검색하고자 합니다.
-- 조건은 상품입고테이블의 2005년도 1월의 매입일자(입고일자) 인것들
-- 매입금액 = 매입수량 * 매입금액
-- 조회컬럼 : 거래처코드, 거래처명, 매입금액의 합
-- (매입금액의 합이 NULL인 경우 0으로 조회)
-- 정렬은 거래처 코드 및 거래처명을 기준으로 내림차순

-- 위에 결과를 이용하여
-- 매입금액의 합이 1천만원 이상인 상품코드, 상품명을 검색
*/

-- <WHERE절 서브쿼리>
SELECT prod_id, prod_name
  FROM prod
 WHERE prod_buyer IN( 
        SELECT buyer_id
          FROM buyer, prod, buyprod
         WHERE buyer_id = prod_buyer
           AND prod_id = buy_prod
           AND buy_date BETWEEN '05/01/01' AND '05/01/31'
         GROUP BY buyer_id
         HAVING SUM(NVL(buy_qty * buy_cost, 0)) >= 10000000)
 ORDER BY prod_name ASC;
 
-- <FROM절 서브쿼리>
SELECT prod_id, prod_name
  FROM (SELECT buyer_id, buyer_name, 
                SUM(NVL(buy_qty * buy_cost, 0)) AS SUMCOST
          FROM buyer, prod, buyprod
         WHERE buyer_id = prod_buyer
           AND prod_id = buy_prod
           AND buy_date BETWEEN '05/01/01' AND '05/01/31'
         GROUP BY buyer_id, buyer_name
         ORDER BY buyer_id DESC, buyer_name DESC) A, prod P
 WHERE prod_buyer = A.buyer_id
   AND A.sumcost >= 10000000
 ORDER BY prod_name ASC;
                 
-- <OUTER JOIN>                
