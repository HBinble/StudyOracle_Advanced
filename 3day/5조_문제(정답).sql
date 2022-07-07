--<<1번문제>>
-- 제품이름이 남성과 여성으로 시작하는 제품의 각각의 소매점 대기시간 평균을 집계하세요
-- 소매점대기시간은 주문일 - 매입일
-- 소매점 대기시간이 0 이하인 값들은 제외
-- 대기시간 평균을 소수점 둘째자리까지만 나타내어주세요
-- alias명을 성별제품, 소매점대기시간으로 나타내어주세요

SELECT SUBSTR(prod_name, 1,2) AS 성별제품,
   ROUND(AVG((CAST(SUBSTR(cart_no, 1, 8) AS date) - buy_date)),2) AS 소매점대기시간
  FROM prod, cart, buyprod
 WHERE buy_prod = prod_id
   AND cart_prod = prod_id
   AND (prod_name LIKE '남성%' OR prod_name LIKE '여성%')
   AND (CAST(SUBSTR(cart_no, 1, 8) AS date) - buy_date) > 0
 GROUP BY SUBSTR(prod_name, 1,2);
 
 

-- 방법1
SELECT SUBSTR(prod_name, 1,2) AS 성별제품, 
       AVG(SUBSTR(cart_no,1,8)- TO_CHAR(buy_date, 'yyyymmdd'))
  FROM prod, cart, buyprod
 WHERE buy_prod = prod_id
   AND cart_prod = prod_id
   AND (prod_name LIKE '남성%' OR prod_name LIKE '여성%')
   AND (SUBSTR(cart_no,1,8)- TO_CHAR(buy_date, 'yyyymmdd')) >0 
 GROUP BY SUBSTR(prod_name, 1,2);

-- 방법2    
SELECT SUBSTR(prod_name, 1,2) AS 성별제품,
   ROUND(AVG((SUBSTR(cart_no,1,8)- TO_CHAR(buy_date, 'yyyymmdd'))),2) AS 소매점대기시간
  FROM prod, cart, buyprod
 WHERE buy_prod = prod_id
   AND cart_prod = prod_id
   AND (prod_name LIKE '남성%' OR prod_name LIKE '여성%')
   AND (SUBSTR(cart_no,1,8)- TO_CHAR(buy_date, 'yyyymmdd')) > 0
 GROUP BY SUBSTR(prod_name, 1,2);


/*
 1. 지금까지 회원들이 구매했던 주문을 마일리지로 적립해주는 이벤트를 한다고 합니다.
사람들이 구매한 상품 수량만큼 마일리지를 적립, 가지고 있는 마일리지와 더해서 회원번호 별로 현재 얼마인지 보여주세요
조회하는 컬럼은 회원번호, 회원명, 가지고 있던 마일리지, 
이벤트로 적립되는 마일리지(컬럼명은 eve_mile로 별칭), 최종 마일리지(컬럼명은 total로 별칭)
상품 테이블의 상품 마일리지 컬럼을 업데이트하여 이용해주세요.(마일리지 적립율은 5%)
개인정보 보호를 위해서 회원명의 중간 글자는 *로 바꿔주세요
회원번호 순으로 오름차순 정렬
*/

SELECT *
  FROM prod;

















