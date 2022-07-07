-- 2day

-- 회원정보 전체 조회
SELECT * 
  FROM member ;

-- 취미가 수영인 회원들 중에 
-- 마일리지의 값이 1000 이상인 
-- 회원아이디, 회원이름, 회원취미, 회원마일리지 조회
-- 정렬은 회원이름 기준 오름차순
SELECT mem_id, mem_name, mem_like, mem_mileage
  FROM member
 WHERE mem_like = '수영' 
   AND mem_mileage >= 1000
 ORDER BY mem_name ASC;
 
-- 김은대 회원과 동일한 취미를 가지는
-- 회원아이디, 회원이름, 회원취미 조회하기
SELECT mem_id, mem_name, mem_like
  FROM member
 WHERE mem_like = (SELECT mem_like 
                     FROM member 
                    WHERE mem_name = '김은대');

-- 주문내역이 있는 회원에 대한 정보를 조회하려 합니다.
-- 회원아이디, 회원이름, 주문번호, 주문수량 조회하기 (column 서브쿼리)
SELECT cart_member, cart_no, cart_qty,
        (SELECT mem_name
           FROM member
          WHERE mem_id = cart_member) as name 
  FROM cart;

-- 주문내역이 있는 회원에 대한 정보를 조회하려 합니다.
-- 회원아이디, 회원이름, 주문번호, 주문수량, 상품명 조회하기
SELECT cart_member, cart_no, cart_qty,
        (SELECT mem_name
           FROM member
          WHERE mem_id = cart_member) as name,
        (SELECT prod_name
           FROM prod
          WHERE prod_id = cart_prod) as prod_name
  FROM cart;

-- a001 회원이 주문한 상품에 대한 
-- 상품분류코드, 상품분류명 조회하기
SELECT lprod_gu, lprod_nm
  FROM lprod
 WHERE lprod_gu IN (SELECT prod_lgu
                      FROM prod
                     WHERE prod_id IN (SELECT cart_prod
                                         FROM cart
                                        WHERE cart_member = 'a001'));   

-- 이쁜이라는 회원이 주문한 상품 중에
-- 상품분류코드가 P201이고,
-- 거래처코드가 P20101인
-- 상품코드, 상품명을 조회해주세요
SELECT prod_id, prod_name
  FROM prod
 WHERE prod_lgu = 'P201'
   AND prod_buyer = 'P20101'
   AND prod_id IN (
        SELECT cart_prod
          FROM cart
         WHERE cart_member IN (
               SELECT mem_id
                 FROM member
                WHERE mem_name = '이쁜이'));

-- 서브쿼리(SubQuery) 정리
--(방법1) SELECT 조회 컬럼 대신에 사용하는 경우
--   : 단일 컬럼의 단일행만 조회

--(방법2) WHERE 절에 사용하는 경우
--   IN () : 단일컬럼의 단일행 또는 다중행 조회 가능
--   =     : 단일컬럼의 단일행만 조회 가능


-- LIKE '형태' 또는 NOT LIKE '형태'
SELECT prod_id 상품코드, prod_name 상품명 
  FROM prod
 WHERE prod_name LIKE '삼%'; --처음부터 '삼'으로 시작하는 모든 것을 찾아라

SELECT prod_id 상품코드, prod_name 상품명
  FROM prod
 WHERE prod_name LIKE '_성%'; --두번째부터'성'으로 시작하는 모든 것
 
SELECT prod_id 상품코드, prod_name 상품명
  FROM prod
 WHERE prod_name LIKE '%치'; -- '치'로 끝나는 모든 것

SELECT prod_id 상품코드, prod_name 상품명
  FROM prod
 WHERE prod_name NOT LIKE '치%';
 
SELECT prod_id 상품코드, prod_name 상품명
  FROM prod
 WHERE prod_name LIKE '%여름%';
 
SELECT lprod_gu 분류코드, lprod_nm 분류명
  FROM lprod
 WHERE lprod_nm LIKE '%홍\%' ESCAPE '\';

-- 함수(문자열) 
SELECT 'a' || 'bcde'
  FROM dual;
  
SELECT mem_id || 'name is' || mem_name 
  FROM member;

-- TRIM
SELECT '<' || TRIM('   A   AA   ') || '>' TRIM1,
       '<' || TRIM(LEADING 'a' FROM 'aaAaBaAaa') || '>' TRIM2,
       '<' || TRIM('a' FROM 'aaAaBaAaa') || '>' TRIM3
FROM dual;

-- ★SUBSTR(c,m,[n] = c문자열 m위치 n만큼 문자 리턴)
SELECT mem_id, SUBSTR(mem_name, 1, 1) 성씨
  FROM member;

-- 상품테이블의 상품명의 4째 자리부터 2글자가 '칼라'인 상품의 상품코드, 상품명을 검색하시오
SELECT prod_id, prod_name, SUBSTR(prod_name, 4, 2) AS subNM
  FROM prod
 WHERE SUBSTR(prod_name, 4, 2) = '칼라';
 
-- REPLACE(c1,c2,[c3] = c1에 포함된 c2문자를 c3값으로 치환
SELECT buyer_name, REPLACE(buyer_name, '삼', '육') "삼->육"
  FROM buyer;
-- 회원테이블의 회원성명 중 '이' 씨 성을 '리' 씨 성으로 치환 검색하시오 (성씨를 바꾼 후 이름조회)
SELECT REPLACE(SUBSTR(mem_name,1,1), '이', '리') ||
               SUBSTR(mem_name,2,2) "이 -> 리"
  FROM member;
  
-- 상품분류 중에 '전자'가 포함된 상품을 구매한 회원 조회하기
-- 회원아이디, 회원이름 조회하기
-- 단, 상품명에 삼성전자가 포함된 상품을 구매한 회원
-- 그리고, 회원의 취미가 수영인 회원
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
                       AND prod_lgu IN(
                        SELECT lprod_gu
                          FROM lprod
                         WHERE lprod_nm LIKE '%전자%')));
                         
--함수(숫자열)
-- ROUND(n,l) = (컬럼명, 위치) : 반올림
-- ROUND(n,l) = (컬럼명, 위치) : 절삭
-- 회원 테이블이 마일리지를 12로 나눈 값을 검색 
-- (소수3째자리 반올림, 절삭)
SELECT mem_mileage, (mem_mileage / 12),
        ROUND(mem_mileage / 12, 2),
        TRUNC(mem_mileage / 12, 2)
  FROM member;

-- MOD(c,n)= n으로 나눈 나머지
SELECT MOD(10,3)
  FROM dual;
  
-- 회원조회, 남자 = 1 여자 = 0 으로 조회  
SELECT mem_id, mem_name, mem_regno1, mem_regno2, 
        MOD(SUBSTR(mem_regno2,1,1), 2) as sex
  FROM member;
  
-- SYSDATE(시스템에서 제공하는 현재 날짜와 시간 값)
SELECT SYSDATE "현재시간",
       SYSDATE-1 "어제 이시간",
       SYSDATE+1 "내일 이시간"
  FROM dual;
-- 회원테이블의 생일과 12000일째 되는 날을 검색하시오?
SELECT mem_name, mem_bir, mem_bir + 12000 "12000일째"
  FROM member;
  
SELECT ADD_MONTHS(SYSDATE, 5)
  FROM dual;
  
SELECT NEXT_DAY(SYSDATE,'월요일'),
       LAST_DAY(SYSDATE)
  FROM dual;
  
SELECT LAST_DAY(SYSDATE) - SYSDATE
  FROM dual; 
 
-- ROUND = 반올림
SELECT ROUND(SYSDATE, 'YYYY'),
       ROUND(SYSDATE, 'Q')
  FROM dual;

-- EXTRACT (fmt FROM date) = 날짜에서 필요한 부분만 추출 - 년도,월,일,시간,분,초 각각 추출 가능
-- fmt = YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
SELECT EXTRACT(YEAR FROM SYSDATE) "년도",
       EXTRACT(MONTH FROM SYSDATE) "월",
       EXTRACT(DAY FROM SYSDATE) "일"
  FROM dual;
-- 생일이 3월인 회원을 검색하시오?  
SELECT mem_id, mem_name, mem_bir
  FROM member
 WHERE EXTRACT(MONTH FROM mem_bir) = 3;
 
-- CAST(expr AS type) = 명시적으로 형 변환
-- CHAR(메모리 비효율 : 명시적)
SELECT '[' || CAST('Hello' AS CHAR(30)) || ']' "형변환"
  FROM dual;
-- VARCHAR(메모리 효율 : 가변적)
SELECT '[' || CAST('Hello' AS VARCHAR(30)) || ']' "형변환"
  FROM dual;  
  
-- 0000-00-00, 0000/00/00, 0000.00.00, 00000000,
--   00-00-00,  00/00/00,   00.00.00
SELECT CAST('1997/12/25' AS DATE)
  FROM dual;

-- TO_CHAR : 숫자,문자,날짜를 지정한 형식의 문자열 반환
-- TO_NUMBER : 숫자형식의 문자열을 숫자로 반환
-- TO_
SELECT TO_CHAR(SYSDATE, 'AD YYYY,CC"세기"')
  FROM dual;
--
SELECT
        TO_CHAR(CAST('2008-12-25' AS DATE),
                'YYYY.MM.DD HH24:MI')
  FROM dual;
-- 상품테이블에서 상품입고일을 "2008-09-28" 형식으로 나오게 검색하시오
SELECT prod_insdate, TO_CHAR(prod_insdate, 'YYYY-MM-DD')
  FROM prod;
-- 회원이름과 생일로 다음처럼 출력되게 작성하시오
-- ex) 김은대님은 1976년 1월 출생이고 태어난 요일은 목요일
SELECT mem_name || '님은 ' || TO_CHAR(mem_bir,'YYYY')|| '년 ' 
        || TO_CHAR(mem_bir, 'MM') || '월 출생이고 태어난 요일은 ' 
        || TO_CHAR(mem_bir, 'DAY')
  FROM member;

-- 숫자 FORMAT
SELECT TO_CHAR(1234.6, '99,999.00'),
       TO_CHAR(1234.6, '9999.99'),
       TO_CHAR(1234.6, '999,999,999.99'),
       TO_CHAR(1234.6, '999.99')
  FROM dual;
  
SELECT TO_CHAR(-1234.6, 'L9999.00PR'),
       TO_CHAR(-1234.6, 'L9999.99PR')
  FROM dual;
  
-- 계정 잠금 해제
Alter User 사용자계정 Account Unlock;
  
-- 여자인 회원이 구매한 상품 중에
-- 상품분류에 전자가 포함되어 있고,
-- 거래처의 지역이 서울인
-- 상품코드, 상품명 조회하기

-- 내 답
SELECT prod_id, prod_name
  FROM prod
 WHERE prod_name LIKE '%전자%'
     AND prod_buyer IN(
            SELECT buyer_id
              FROM buyer
             WHERE SUBSTR(buyer_add1, 1, 2) = '서울')
     AND prod_id IN (
            SELECT cart_prod
              FROM cart
             WHERE cart_member IN (
                 SELECT mem_id
                  FROM member
                 WHERE MOD(SUBSTR(mem_regno2,1,1), 2) = 0));

-- 정답     
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

-- 집계 함수(GROUP)
-- AVG(column) = DISTINCT 중복값 제외 / ALL : Defalut
SELECT ROUND(AVG(DISTINCT prod_cost),2) AS rnd1, 
        ROUND(AVG(ALL prod_cost), 2) AS rnd2, 
        ROUND(AVG(prod_cost), 3) AS rnd3
  FROM prod;
  
-- COUNT(col) , COUNT(*)
SELECT COUNT(DISTINCT prod_cost), COUNT(ALL prod_cost),
       COUNT(prod_cost), COUNT(*)
  FROM prod;
-- 회원테이블의 직업별 COUNT 집계하시오
SELECT mem_job, 
    COUNT(mem_job), COUNT(*)
  FROM member
  GROUP BY mem_job;
  
-- 그룹(집계) 함수만 사용하는 경우에는
-- - GROUP BY 절을 사용하지 않아도 됨.(생략시 전체 column)
-- 조회할 일반컬럼이 사용되는 경우에는 GROUP BY 절을 사용해야 합니다.
-- - GROUP BY 절에는 조회에 사용된 일반 컬럼은 무조건 넣어줍니다.
-- - 함수를 사용한 경우에는 함수를 사용한 원형 그대로를 넣어줍니다.
-- ORDER BY 절에 사용하는 일반컬럼 또는 함수를 이용한 컬럼은
-- - 무조건 GROUP BY 절에 넣어줍니다.
-- SUM(), AVG(), MIN(), MAX(), COUNT()
SELECT COUNT(mem_job), COUNT(*)
  FROM member;

SELECT mem_job, mem_like,
    COUNT(mem_job) AS cnt1, COUNT(*) AS cnt2
  FROM member
 WHERE mem_mileage > 10
   AND mem_mileage >= 10
 GROUP BY mem_job, mem_like, mem_id
 ORDER BY cnt1, mem_id DESC;    
 
-- 수영을 취미로 하는 회원들이
-- 주로 구매하는 상품에 대한 정보를 조회하려고 합니다.
-- 상품별로 count 집계합니다.
-- 조회컬럼, 상품명, 상품 count
-- 정렬은 상품코드를 기준으로 내림차순.

SELECT prod_name, COUNT(prod_name) as cnt_name
  FROM prod
 WHERE prod_id IN (
    SELECT cart_prod
      FROM cart
     WHERE cart_member IN (
        SELECT mem_id
          FROM member
         WHERE mem_like = '수영'))
 GROUP BY prod_name, prod_id
 ORDER BY prod_id DESC;
 
SELECT cart_prod
  FROM cart
 WHERE cart_member IN (
    SELECT mem_id
      FROM member
     WHERE mem_like = '수영');
 
