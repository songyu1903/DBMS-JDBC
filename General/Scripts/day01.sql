-- SELECT
-- 테이블에서 데이터를 조회할 때 사용하는 명령어

-- 사용방법
-- SELECT 칼럼명 FROM 테이블명;
-- 해당 테이블에서 특정 칼럼을 선택하여 조회하겠다.
SELECT first_name 
FROM employees;

SELECT last_name from employees;

SELECT LAST_NAME FROM EMPLOYEES;

-- 테이블 명을 작성할 때 정확하게 작성하려면 계정명을 작성하고 (.) 을 사용한다.
-- 계정명을 생략하면 기본적으로 현재 접속한 계정을 기반으로 테이블을 찾는다.
-- 그러므로 생략이 가능하다.
 
SELECT FIRST_NAME FROM HR.EMPLOYEES;

SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES; 

-- [실습]
-- 직원의 성, 이름, 전화번호, 이메일, 사원번호를 한 번에 조회하기
SELECT LAST_NAME, FIRST_NAME, PHONE_NUMBER, EMAIL, EMPLOYEE_ID 
FROM EMPLOYEES;

-- SQL에서 명령어를 구성하는 단위를 '절' 이라고 부른다.
-- SELECT 칼럼명 FROM 테이블명; 에서 실질적인 명령어(키워드)는
-- SELECT 와 FROM이다.
-- 이 SELECT 와 FROM 나누어 부를 때 SELECT절, FROM절 이라고 부른다.
SELECT
	LAST_NAME,
	FIRST_NAME,
	EMPLOYEE_ID,
	EMAIL,
	PHONE_NUMBER,
	SALARY
FROM
	EMPLOYEES e;

-- 모든 컬럼 조회하기
-- * : 모든, ALL
SELECT * FROM EMPLOYEES e;

-- 정렬해서 조회하기
-- ORDER BY 절
-- 사원의 이름, 성, 봉급을 봉급 낮은 순서부터 조회하기
SELECT FIRST_NAME , LAST_NAME , SALARY 
FROM EMPLOYEES
-- ORDER BY SALARY ASC -> 봉급 오름차순
-- ORDER BY SALARY ASC;
ORDER BY SALARY DESC -- 봉급 내림차순

-- ORDER BY -> 정렬하겠다
-- ORDER BY는 항상 가장 마지막에 사용한다.
-- ORDER BY는 오름차순이 디폴트이므로 ASC를 생략하도된다

----------------------------------------------------------

-- 직원의 이름, 성, 고용일을 고용일 순서로 정렬
-- 날짜 타입의 값도 정렬이 가능하다
SELECT FIRST_NAME , LAST_NAME , HIRE_DATE , SALARY 
FROM EMPLOYEES
ORDER BY HIRE_DATE ;

SELECT FIRST_NAME , LAST_NAME , HIRE_DATE , SALARY 
FROM EMPLOYEES
ORDER BY LAST_NAME;

-- 여러 칼럼을 기반으로 정렬할 경우
-- 앞에 컬럼 순서로 정렬한 뒤 뒷 컬럼 순서로 정렬된다.

SELECT FIRST_NAME , SALARY , HIRE_DATE
FROM EMPLOYEES
ORDER BY SALARY DESC, HIRE_DATE DESC;

------------------------------------------------------------------

-- 회사에 존재하는 직무(JOB_ID) 조회
-- DISTINCT : 중복 행을 제거해준다.
SELECT DISTINCT JOB_ID  FROM EMPLOYEES e;

-- 칼럼을 여러개 조회하게 된다면 모든 칼럼이 일치하는
-- 중복 행을 찾아 제거해준다.
SELECT DISTINCT JOB_ID , HIRE_DATE
FROM EMPLOYEES e;

------------------------------------------------------------------

-- 테이블 칼럼명을 별칭(ALIAS)로 설정
SELECT
	FIRST_NAME AS "이름" ,
	LAST_NAME AS "성",
	SALARY AS "봉급",
	EMPLOYEE_ID AS "사원 번호"
FROM
	EMPLOYEES e;

-- 별칭 설정은 다음과 같이도 가능하다
-- AS 생략 가능!!
-- "" 생략 가능
SELECT
	FIRST_NAME 이름 ,
	LAST_NAME "성",
	SALARY 봉급,
	EMPLOYEE_ID "사원 번호" -- 뛰어 쓰기가 있는 애는 "" 로 감싸줘야한다
FROM
	EMPLOYEES e;

-- [실습]
-- 사원의 이름, 성, 봉급을, 봉급 내림차순(DESC) 정렬하여 조회
-- 단, 별칭을 사용하여 조회할것

-- ORDER BY절에 기준 칼럼을 별칭으로 설정할 수 있다.
SELECT
	FIRST_NAME 이름 ,
	LAST_NAME 성,
	SALARY 봉급
FROM
	EMPLOYEES e
ORDER BY
	봉급 DESC; -- 칼럼명말고 별칭으로 사용해도 조회가능

------------------------------------------------------------------
-- 자료형(TYPE)
-- 1. 문자 : CHAR / VARCHAR2 
-- CHAR(20) -> 불변(바뀌지않음) 20글자  
-- VARCHAR2(20) -> 가변(알아서 바뀜) 1글자면 1글자 20글자면 20글자
-- 2. 숫자 : NUMBER
-- 3. 날짜 : DATE
	
-- 연산자
-- 1. 연결 연산자 -> 문자
--  A || B : A와 B를 연결해준다.
-- 숫자, 날짜, 문자 타입이 피연산자로 울 수 있으며
-- 앞의 값과 뒤의 값을 연결하여 하나의 문자로 만들어준다.
	
-- DUAL 테이블 : 다른 테이블의 칼럼을 참조할 필요가 없이
-- 값을 확인하고 싶을 때 사용할 수 있는 가짜 테이블
--  (오라클에서 지원한다.)
SELECT  10 || 20 연결 FROM DUAL;

-- SELECT절에 조회 대상은 항상 하나의 칼럼으로 설정된다.
SELECT 10 || 20 AS "1020", 20 AS 숫자 FROM DUAL;

-- SQL에서 문자는 ''로 표현한다.
SELECT '연결' || '한다' 연결 FROM DUAL;

-- 칼럼 끼리도 연결이 가능하다
SELECT FIRST_NAME || LAST_NAME 풀네임
FROM EMPLOYEES e
ORDER BY 풀네임;

-- [실습]
-- 사원의 이름과 메일 주소를 조회한다.
-- 이름은 FIRST_NAME과 LAST_NAME이 띄워쓰기로 이어져있고,
-- 메일 주소는 사원 이메일@koreait.com 으로 조회한다

SELECT
	FIRST_NAME || ' ' || LAST_NAME 풀네임,
	EMAIL || '@koreait.com' "이메일 주소"
FROM
	EMPLOYEES e
ORDER BY 풀네임;

-- 2. 산술 연산자
-- +, -, *, /

SELECT
	EMPLOYEE_ID,
	EMPLOYEE_ID + 10,
	EMPLOYEE_ID - 10,
	EMPLOYEE_ID * 10,
	EMPLOYEE_ID / 10
FROM
	EMPLOYEES e;

-- [실습]
-- 직원의 이름, 봉급, 인상 봉급, 감축 봉급을 조회
-- 이름은 성과 함께 띄어쓰기로 연결되어있다
-- 인상 봉급은 기존 봉급의 10% 증가되었고
-- 감축 봉급은 기존 봉급의 10% 감소되었다.
-- 결과를 기존 봉급 오름차순(ASC) 정렬 조회

SELECT
	FIRST_NAME || ' ' || LAST_NAME 풀네임,
	SALARY 봉급,
	SALARY * 1.1 "인상 봉급",
	SALARY * 0.9 "감축 봉급"
FROM
	EMPLOYEES e 
ORDER BY 봉급 ASC;

-- 날짜 타입의 산술 연산

-- 날짜와 숫자
SELECT
	HIRE_DATE ,
	-- 기존날짜에서 10일 추가
	HIRE_DATE +10, 
	-- 기존날짜에서 10일 감소  
	HIRE_DATE -10 
FROM
	EMPLOYEES e;

-- 현재 날짜와 시간 정보를 가지고있으며, 오라클에서 제공
SELECT SYSDATE FROM DUAL;

-- 날짜와 날짜의 - 연산은 몇 일이나 지났는지 나온다
SELECT HIRE_DATE 입사날짜 , SYSDATE 현재시간 , SYSDATE - HIRE_DATE "현재 경력"
FROM EMPLOYEES e ;

SELECT
	SYSDATE, 
	SYSDATE + 1 다음날,
	SYSDATE + 0.5 "12 시간 후",
	SYSDATE + 1/24 "1 시간 후",
	SYSDATE - 30/60/24 "30분 전"
FROM
	DUAL;

-- 3. 관계 연산자

-- > , < , >= , <=
-- A = B : A와 B가 같다. -> 자바에서는 ==
-- A <> B : A와 B가 다르다. -> 자바에서는 !=
-- A != B : 비표준(다른 DB에서는 안되는 경우도 있다)

-- 오라클에서 TRUE, FALSE 를 나타내는 BOOLEAN타읍은 존재하지 않는다.
-- 그러므로 SELECT를 통해 조회하는 것이 불가능하다.
-- SELECT 10 < 12 FROM DUAL;

-- WHERE절
-- 조건으로 행을 걸러서 조회한다.
-- SELECT 칼럼명 FROM 테이블명 WHERE 조건; 
SELECT FIRST_NAME , LAST_NAME , SALARY 
FROM EMPLOYEES e
WHERE SALARY >= 10000;

-- ORDER BY와 함께 사용할 수 있다
-- ORDER BY는 항상 마지막에 사용한다.
SELECT FIRST_NAME , LAST_NAME , SALARY 
FROM EMPLOYEES e
WHERE SALARY >= 10000
ORDER BY SALARY ;

-- [실습]
-- 직원의 이름과, 성을 조회
-- 단, 이름이 David인 직원만 골라서 조회한다 
SELECT FIRST_NAME 이름, LAST_NAME 성
FROM EMPLOYEES e 
-- 데이터는 대소문자 구분한다. 'David' <> 'david'
WHERE FIRST_NAME = 'David';

-- SQL 실행 순서
-- FROM > WHERE > SELECT > ORDER BY 
-- 별칭을 설정할 경우
SELECT FIRST_NAME 이름, LAST_NAME 성, SALARY 봉급  -- 3. 각 칼럼에 별칭을 붙여서 조회해라
FROM EMPLOYEES e	  -- 1. EMPLOYEES 테이블에서
--WHERE 봉급  >= 10000 -- 2. 봉급이 10000이상인 행을 걸러라 -> WHERE절이 SELECT 보다 먼저실행해서 별칭설정이 안된다.
WHERE SALARY >= 10000 
ORDER BY 봉급; -		  -- 4. 봉급 오름차순을 정렬


-- 4. SQL 연산자
-- BETWEEN a AND b : a 이상 b 이하인 조건
-- IN(a, b, c, .....) : a 또는 b 또는 c 또는 ...인 조건
-- LIKE : %와 _를 사용해 특정 글자 조회
-- IS NULL / IS NOT NULL

-- EMPLOYEES 테이블에서 SALARY가 10000 이상 12000이하인 직원의
-- 이름, 성, 봉급을 봉급 오름차순으로 조회해라

-- BETWEEN -> 값과 값 사이에 있는 모든 값을 가져올때
SELECT FIRST_NAME , LAST_NAME , SALARY 
FROM EMPLOYEES e 
-- WHERE 칼럼명 BETWEEN 값 AND 값
WHERE SALARY BETWEEN 10000 AND 12000 -- 10000 이상 12000 이하
ORDER BY SALARY ;

-- IN -> 정확한 값을 가져올때
-- 사원 테이블에서 봉급이 10000 또는 11000 또는 12000인 직원의
-- 이름, 성, 봉급을 봉급 오름차순으로 정렬하여 조회
SELECT FIRST_NAME , LAST_NAME , SALARY 
FROM EMPLOYEES e 
WHERE SALARY IN (10000, 11000, 12000)
ORDER BY SALARY ;

-- LIKE : 문자열을 부분일치하는지 검사할 때 사용
-- % : 특정 단어 조회
-- _ : 글자 갯수 맞춰 조회
SELECT FIRST_NAME 
FROM EMPLOYEES e 
WHERE FIRST_NAME LIKE 'D%'; -- D% -> D로 시작하는 모든 정보 조회

SELECT FIRST_NAME 
FROM EMPLOYEES e 
WHERE FIRST_NAME LIKE '%e%'; -- %e% -> e 단어가 들어있는 모든 정보 조회

SELECT FIRST_NAME 
FROM EMPLOYEES e 
WHERE FIRST_NAME LIKE 'D__'; -- D__ -> D로 시작해서 뒤에 2글자가 더 붙은 정보 조회 (Den) -> D___ (Davi)

SELECT FIRST_NAME 
FROM EMPLOYEES e 
WHERE FIRST_NAME LIKE '%e_n%'; -- %e_n% -> e다음 아무철자 다음 n이 들어있는 모든 정보 조회

-- NULL : 값이 없을을 나타내는 값
-- NULL은 연산하면 결과가 항상 NULL이다.

SELECT NULL + 10 FROM DUAL;

SELECT FIRST_NAME , LAST_NAME , COMMISSION_PCT 
FROM EMPLOYEES e 
WHERE COMMISSION_PCT IS NULL; -- IS NULL -> NULL 인 값을 조회하고 싶을때

SELECT FIRST_NAME , LAST_NAME , COMMISSION_PCT 
FROM EMPLOYEES e 
WHERE COMMISSION_PCT IS NOT NULL; -- IS NOT NULL -> NULL이 아닌 값을 조회하고 싶을때

-- SQL 연산자
-- 비교연산자 ANY(a,b,c,....) : a, b, c 중 아무거나 만족하면 TRUE
-- 비교연산자 ALL(a,b,c,....) : a, b, c 전부 만족하면 TRUE

SELECT FIRST_NAME || ' ' || LAST_NAME , SALARY 
FROM EMPLOYEES e
WHERE SALARY > ANY(10000, 11000, 12000)
ORDER BY SALARY DESC;

SELECT FIRST_NAME || LAST_NAME , SALARY 
FROM EMPLOYEES e
WHERE SALARY IN (10000, 11000, 12000)
ORDER BY SALARY ;

SELECT FIRST_NAME || ' ' || LAST_NAME , SALARY 
FROM EMPLOYEES e
WHERE SALARY > ALL(10000, 11000, 12000)
ORDER BY SALARY DESC;

-- 5. 논리 연산자
-- a AND b : a와 b 둘다 TRUE면 TRUE
-- a OR b : a와 b 둘중 하나가 TRUE면 TRUE

-- 사원 테이블에서 부서가 영업 부서이면서 봉급이 10000이상인
-- 직원들의 이름, 성, 봉급, 부서ID를 봉급 오름차순(ASC) 조회

SELECT  * FROM EMPLOYEES e ;

SELECT
	FIRST_NAME 이름,
	LAST_NAME 성,
	SALARY 봉급,
	DEPARTMENT_ID 부서ID
FROM
	EMPLOYEES e
WHERE DEPARTMENT_ID = 80 AND SALARY >= 10000
ORDER BY SALARY ;

-- NOT 연산자
-- NOT a

SELECT
	FIRST_NAME 이름,
	LAST_NAME 성,
	SALARY 봉급,
	DEPARTMENT_ID 부서ID
FROM
	EMPLOYEES e
WHERE NOT DEPARTMENT_ID = 80 -- NOT 연산자로 부서ID가 80번이 아닌 직원을 조회
ORDER BY SALARY ;

-------------------------------------------------------------------------
-- 테이블 생성
CREATE TABLE TBL_MEMBER( -- TBL_MEMBER -> 테이블명
	NAME VARCHAR2(1000),
	AGE NUMBER
);






	


















