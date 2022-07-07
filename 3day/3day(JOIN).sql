-- JOIN : 여러개 테이블 연결

-- CROSS JOIN : FROM 에서 ','로 구분(일반방식)
SELECT *
  FROM lprod, prod;
-- 표준방식
SELECT *
  FROM lprod CROSS JOIN prod;
  
-- INNER JOIN 조건
-- PK와 FK가 있어야 합니다.
-- 관계조건 성립 : PK = FK
-- 관계조건의 갯수: FROM절에 제시된 (테이블의 갯수 -1개)

-- 상품테이블에서 상품코드, 상품명, 분류명을 조회
-- 1. prod, lprod
-- 2. prod_lgu = lprod_gu (PK = FK)
-- 3. lprod > prod(분모 먼저)

-- <일반방식>
SELECT prod_id, prod_name, lprod_nm, buyer_name, cart_qty, mem_name
  FROM lprod, prod, buyer,cart, member
-- 관계조건식
 WHERE lprod_gu = prod_lgu
   AND buyer_id = prod_buyer
   AND prod_id = cart_prod
   AND mem_id = cart_member
   AND mem_id = 'a001';
   
-- <국제표준방식>
SELECT prod_id, prod_name, lprod_nm, buyer_name, cart_qty, mem_name
  FROM lprod INNER JOIN prod
                ON(lprod_gu = prod_lgu)
             INNER JOIN buyer
                ON(buyer_id = prod_buyer)
             INNER JOIN cart
                ON(prod_id = cart_prod)
             INNER JOIN member
                ON(mem_id = cart_member
                   AND mem_id = 'a001');

-- 상품테이블에서 상품코드, 상품명, 분류명, 거래처명, 거래처주소를 조회
-- 1) 판매가격이 10만원 이하이고
-- 2) 거래처 주소가 부산인 경우에만 조회
-- 일반방식, 표준방식 모두 해보기
-- 1. 테이블 찾기
-- 2. 관계조건식 찾기
-- 3. 순서 정하기

-- 1. 테이블 찾기
-- prod, lprod, buyer
-- 2. 관계조건식 찾기
-- prod_lgu = lprod_gu 
-- prod_buyer = buyer_id
-- 3. 순서정하기

-- <일반방식>
SELECT prod_id, prod_name, lprod_nm, buyer_name, buyer_add1
  FROM prod, lprod, buyer
 WHERE lprod_gu = prod_lgu
   AND buyer_id = prod_buyer
   AND prod_sale <= 100000
   AND SUBSTR(buyer_add1,1,2) = '부산';
--   AND buyer_add1 LIKE '부산%';  

-- <표준방식>
SELECT prod_id, prod_name, lprod_nm, buyer_name, buyer_add1
  FROM prod INNER JOIN lprod
               ON(prod_lgu = lprod_gu 
                  AND prod_sale <= 100000)
            INNER JOIN buyer
               ON(prod_buyer = buyer_id
                  AND SUBSTR(buyer_add1,1,2) = '부산');

-- [문제]
-- 상품분류명, 상품명, 상품색상, 매입수량, 주문수량, 거래처명을 조회
-- 단, 상품분류 코드가 P101, P201, P301인것
--     매입수량이 15개 이상인 것
--     서울에 살고 있는 회원 중에 생일이 1974년생인 회원
-- 정렬은 회원 아이디 기준 내림차순, 매입수량 기준 오름차순
-- 일반방식, 표준방식

-- 1. 테이블 찾기
-- lprod, prod, buyprod, cart, buyer
-- 2. 관계조건식 찾기
-- lprod_gu = prod_lgu
-- prod_buyer = buyer_id
-- cart_prod = prod_id
-- buy_prod = prod_id
-- cart_member = mem_id
-- 3. 순서 정하기

-- <일반방식>
SELECT lprod_nm, prod_name, prod_color, buy_qty, cart_qty, buyer_name
  FROM lprod, prod, buyprod, cart, buyer, member
 WHERE lprod_gu = prod_lgu
   AND buyer_id = prod_buyer
   AND cart_prod = prod_id
   AND buy_prod = prod_id
   AND cart_member = mem_id
   AND lprod_gu IN ('P101','P201','P301')
   AND buy_qty >= 15
   AND SUBSTR(mem_add1, 1, 2) = '서울' AND TO_CHAR(mem_bir,'YYYY') = 1974
 ORDER BY mem_id DESC, buy_qty ASC ;

-- <표준방식>
SELECT lprod_nm, prod_name, prod_color, buy_qty, cart_qty, buyer_name
  FROM lprod INNER JOIN prod
                ON (lprod_gu = prod_lgu
                    AND lprod_gu IN ('P101','P201','P301'))
             INNER JOIN buyprod
                ON (buy_prod = prod_id
                    AND buy_qty >= 15)
             INNER JOIN cart
                ON (cart_prod = prod_id)
             INNER JOIN member
                ON (cart_member = mem_id 
                AND SUBSTR(mem_add1, 1, 2) = '서울' 
                AND TO_CHAR(mem_bir,'YYYY') = 1974)
             INNER JOIN buyer
                ON (buyer_id = prod_buyer)
 ORDER BY mem_id DESC, buy_qty ASC;
 
 --<성현이형 답>
 --[문제]
--상품분류명, 상품명, 상품색상, 매입수량, 주문수량, 거래처명을 조회
-- 단, 상품분류 코드가 P101, P201, P301인 것
--     매입수량이 15개 이상인 것
--     서울에 살고 있는 회원 중에 생일이 1974년생인 회원
-- 정렬은 회원아이디 기준 내림차순, 매입수량 기준 오름차순
-- 일반방식, 표준방식..
--1. 테이블
-- prod, buyprod, cart, buyer, lprod, member
--2. 관계
-- prod_id = buy_prod
-- prod_id = cart_prod
-- cart_member = mem_id
-- prod_buyer = buyer_id
-- prod_lgu = lprod_gu
--3. 순서
--<일반방식>
SELECT lprod_nm, prod_name, prod_color, buy_qty, cart_qty, buyer_name
  FROM prod, buyprod, cart, buyer, lprod, member
 WHERE prod_id = buy_prod
   AND prod_id = cart_prod
   AND cart_member = mem_id
   AND prod_buyer = buyer_id
   AND prod_lgu = lprod_gu
   AND prod_lgu IN ('P101', 'P201', 'P301')
   AND buy_qty >= 15
   AND mem_bir BETWEEN '74/01/01' AND '74/12/31'
   AND mem_add1 LIKE '서울%'
 ORDER BY mem_id DESC, buy_qty ASC;
   
--<표준방식>
SELECT lprod_nm, prod_name, prod_color, buy_qty, cart_qty, buyer_name
  FROM prod INNER JOIN buyprod
                ON(prod_id = buy_prod
                    AND buy_qty >= 15)
            INNER JOIN cart
                ON(prod_id = cart_prod)
            INNER JOIN buyer
                ON(prod_buyer = buyer_id)
            INNER JOIN lprod
                ON(prod_lgu = lprod_gu
                    AND lprod_gu IN ('P101', 'P201', 'P301'))
            INNER JOIN member
                ON(cart_member = mem_id
                    AND mem_bir BETWEEN '74/01/01' AND '74/12/31'
                    AND mem_add1 LIKE '서울%')
 ORDER BY mem_id DESC, buy_qty ASC;                