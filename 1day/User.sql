-- Oracle 12버전 이상부터는 아래를 실행해야 일반적인 구분 작성이 가능함.

Alter session set "_ORACLE_SCRIPT"=true;

-- 위에 실행은 최초한번 실행
-- 위에 실행안하면 아래처럼 구문을 작성해야함

Create User c##busan_06 Identified By dbdb;



-- 새로운 DB User 생성 과정(system 계정에서 실시)

-- 1. 사용자 생성하기(내가 작업할 공간)
Create User busan_06 Identified By dbdb;

-- 패스워드 수정하기
Alter User busan_06 Identified By 수정패스워드;

-- 사용자 삭제하기
Drop User busan_06;

-- 2. 권한 부여하기
Grant Connect, Resource, DBA to busan_06;

-- 권한 회수하기
Revoke DBA From busan_06;

