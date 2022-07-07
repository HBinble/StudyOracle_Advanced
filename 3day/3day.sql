-- 3day
-- [조회 방법 정리]
-- 상품분류 중에 '전자'가 포함된 상품을 구매한 회원 조회하기
-- 회원아이디, 회원이름 조회하기
-- 단, 상품명에 삼성전자가 포함된 상품을 구매한 회원
--      그리고, 회원의 취미가 수영인 회원

-- 1. 테이블 찾기
--  - 제시된 컬럼들의 소속 찾기
--  ex) lprod, cart, member, prod


-- 2. 테이블 간의 관계 찾기
--  - ERD에서 연결된 순서대로 PK와 FK컬럼 또는, 
--  - 성격이 같은 값으로 연결할 수 있는 컬럼 찾기
-- ex) lprod_gu = prod_lgu
-- ex) prod_id = cart_prod
-- ex) cart_member = mem_id


-- 3. 작성 순서 정하기
--  - 조회하는 컬럼이 속한 테이블이 가장 밖! 1순위!
--  - 1순위 테이블부터 ERD 순서대로 작성
--  - 조건은 : 해당 컬럼이 속한 테이블에서 조건 처리
-- ex) member > cart > prod > lprod

-- 4. 조건 입력하기
-- ex) WHERE 절에 나머지 조건 입력


SELECT mem_id, mem_name 
  FROM member
 WHERE mem_like = '수영'
   AND mem_id IN (
        SELECT cart_member
          FROM cart
         WHERE cart_prod IN (
            SELECT prod_id
              FROM prod
             WHERE prod_name LIKE '%삼성전자%'
                    AND prod_lgu IN (
                     SELECT lprod_gu
                       FROM lprod
                      WHERE lprod_nm LIKE '%전자%')));
                      
                      
-- [문제]
-- 김형모 회원이 구매한 상품에 대한
-- 거래처 정보를 확인하려고 합니다.
-- 거래처코드, 거래처명, 지역(서울 or 인천), 거래처 전화번호 조회
-- 단, 상품분류명 중에 캐주얼 단어가 포함된 제품에 대해서만 조회

-- 1. table
-- member, cart, prod, buyer, lprod

-- 2. 관계
-- mem_id = cart_member / cart_prod = prod_id / prod_lgu = lprod_gu / 
-- prod_buyer = buyer_id / buyer_lgu = lprod_gu

-- 3. 
-- buyer > prod > cart > member
-- buyer > iprod


--1번 한빈
SELECT buyer_id, buyer_name, SUBSTR(buyer_add1,1,2), buyer_comtel
  FROM buyer
 WHERE buyer_id IN(
        SELECT prod_buyer
          FROM prod
         WHERE prod_id IN (
                SELECT cart_prod
                  FROM cart
                 WHERE cart_member IN (
                        SELECT mem_id
                          FROM member
                          WHERE mem_name = '김형모')))
  AND buyer_lgu IN(
        SELECT lprod_gu
          FROM lprod
         WHERE lprod_nm LIKE '%캐주얼%');
         
-- 2번 한빈
SELECT buyer_id, buyer_name, SUBSTR(buyer_add1,1,2), buyer_comtel
  FROM buyer
 WHERE buyer_id IN(
        SELECT prod_buyer
          FROM prod
         WHERE prod_lgu IN(
                SELECT lprod_gu
                  FROM lprod
                 WHERE lprod_nm LIKE '%캐주얼%')         
           AND prod_id IN (
                SELECT cart_prod
                  FROM cart
                 WHERE cart_member IN (
                        SELECT mem_id
                          FROM member
                          WHERE mem_name = '김형모')));
                          
-- 정답(강사님)
-- 1. member, cart, buyer, lprod, prod
-- 2. mem_id = cart_member
--    cart_prod = prod_id
--    prod_buyer = buyer_id
--    prod_lgu = lprod_gu
-- 3. 

SELECT buyer_id, buyer_name, SUBSTR(buyer_add1,1,2), buyer_comtel
  FROM buyer
 WHERE buyer_id IN(
            SELECT prod_buyer
              FROM prod
             WHERE prod_lgu IN(
                    SELECT lprod_gu        
                      FROM lprod
                     WHERE lprod_nm LIKE '%캐주얼%')
               AND prod_id IN(
                    SELECT cart_prod
                      FROM cart
                     WHERE cart_member IN(
                            SELECT mem_id
                              FROM member
                             WHERE mem_name = '김형모')));
                             
-- 여자인 회원이 구매한 상품중에
-- 상품분류명에 전자가 포함되어있고
-- 거래처 지역이 서울인
-- 상품코드, 상품명 조회하시오

-- 1. prod, buyer, lprod, cart, member
-- 2. prod_id = cart_prod
--    prod_buyer = buyer_id
--    prod_lgu = lprod_gu

SELECT prod_id, prod_name
  FROM prod
 WHERE prod_buyer IN (
        SELECT buyer_id
          FROM buyer
         WHERE SUBSTR(buyer_add1, 1, 2) = '서울')
   AND prod_lgu IN (
        SELECT lprod_gu
          FROM lprod
         WHERE lprod_nm LIKE '%전자%')
   AND prod_id IN (
        SELECT cart_prod
          FROM cart
         WHERE cart_member IN (
                SELECT mem_id
                  FROM member
                 WHERE MOD(SUBSTR(mem_REGNO2,1,1),2) = 0));
 
-- 정답(강사님)
-- 1. member, cart, lprod, buyer, prod
-- 2. mem_id = cart_member
--    cart_prod = prod_id
--    prod_lgu = lprod_gu
--    prod_buyer = buyer_id
-- 3. prod > cart > member
--    prod > lprod
--    prod > buyer
                   
SELECT prod_id, prod_name
  FROM prod   
 WHERE prod_id IN(
    SELECT cart_prod
      FROM cart
     WHERE cart_member IN (
        SELECT mem_id
          FROM member
         WHERE MOD(SUBSTR(mem_regno2,1,1), 2) = 0))
   AND prod_lgu IN (
        SELECT lprod_gu
          FROM lprod
         WHERE lprod_nm LIKE '%전자%')
   AND prod_buyer IN (
        SELECT buyer_id
          FROM buyer
         WHERE SUBSTR(buyer_add1, 1, 2) = '서울');        
         