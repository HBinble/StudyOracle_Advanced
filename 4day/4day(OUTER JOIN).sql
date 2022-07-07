-- <OUTER JOIN>                
-- 전체 분류의 상품자료 수를 검색 조회

-- 1. 분류테이블 조회
SELECT *
  FROM lprod;

-- 2. 일반 JOIN
SELECT lprod_gu,
       lprod_nm,
       COUNT(prod_lgu)
  FROM lprod, prod
 WHERE lprod_gu = prod_lgu
 GROUP BY lprod_gu, lprod_nm;
 
-- 3. OUTER JOIN 사용 확인 = 관계조건식에 -> (+) 있는 쪽 : 있으면 있는대로 없으면 없는대로 / 반대쪽 : 전체 
SELECT lprod_gu,
       lprod_nm,
       COUNT(prod_lgu)
  FROM lprod, prod
 WHERE lprod_gu = prod_lgu(+)
 GROUP BY lprod_gu, lprod_nm
 ORDER BY lprod_gu;
 
-- OUTER JOIN은 ★INNER JOIN을 만족하고 조건식에 전체 반대에 (+) 넣기
-- 집계할 때 많이 쓰이기 때문에 NVL을 많이 사용한다.

-- ANSI 형식 = 표준방식
-- LEFT, RIGHT, FULL 로 위치에 따라서 나뉜다.
-- (+) 보다 명확하게 결과가 나온다.
-- LEFT : 왼쪽 전체의 테이블을 조회하겠다.
SELECT lprod_gu,
       lprod_nm,
       COUNT(prod_lgu)
  FROM lprod LEFT OUTER JOIN prod
                     ON (lprod_gu = prod_lgu)
 GROUP BY lprod_gu, lprod_nm
 ORDER BY lprod_gu;
 
-- 전체상품의 2005년 1월 입고수량을 검색 조회

-- 1. 일반 JOIN
SELECT prod_id,
       prod_name,
       SUM(buy_qty)
  FROM prod, buyprod
 WHERE prod_id = buy_prod
   AND buy_date BETWEEN '2005-01-01' AND '2005-01-31'
 GROUP BY prod_id, prod_name;
 
-- 2. OUTER JOIN 사용 확인 -> (+) 할 경우 조건이 깨질 수 있다.
SELECT prod_id,
       prod_name,
       SUM(buy_qty)
  FROM prod, buyprod
 WHERE prod_id = buy_prod(+)
   AND buy_date BETWEEN '2005-01-01' AND '2005-01-31'
 GROUP BY prod_id, prod_name
 ORDER BY prod_id, prod_name;

-- 3. 표준방식 -> LEFT OUTER JOIN을 마지막으로 한다.(순서!)
SELECT prod_id,
       prod_name,
       SUM(buy_qty)
  FROM prod LEFT OUTER JOIN buyprod
              ON (prod_id = buy_prod
                AND buy_date BETWEEN '2005-01-01' AND '2005-01-31')
 GROUP BY prod_id, prod_name
 ORDER BY prod_id, prod_name;
 
-- SELF JOIN (A쪽 조건, B로 걸러냄)
-- 거래처코드가 'P30203(참존)'과 동일지역에 속한 거래처만 검색 조회
SELECT B.buyer_id,
       B.buyer_name,
       B.buyer_add1 ||''|| B.buyer_add2
  FROM buyer A, buyer B
 WHERE A.buyer_id = 'P30203'
   AND SUBSTR(A.buyer_add1,1,2) = SUBSTR(B.buyer_add1,1,2);
