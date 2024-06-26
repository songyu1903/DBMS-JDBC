-- 형변환 함수
-- TO_CHAR() : CHAR 형으로 변환
-- 날짜 포맷 변경시에 유용하다.
-- TO_CHAR(SYSDATE, 'YYYY-MM-DD')
-- YYYY : 연도 , MM : 월, DD : 일
-- HH24 : 24시간, HH : 12시간, MI : 분 , SS : 초
SELECT SYSDATE FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD-HH-MI') FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"') FROM DUAL; 

SELECT TO_CHAR(HIRE_DATE, 'YYYY') FROM EMPLOYEES e; 

-- 숫자에 콤마 찍기

SELECT SAL FROM EMP;

SELECT 123123 FROM DUAL;

SELECT TO_CHAR(123123, '9,999,999') FROM DUAL;

-- 형식보다 큰 자리수가 들어오면 데이터가 손상
SELECT TO_CHAR(123123123123, '9,999,999') FROM DUAL;

-- 형식보다 작은 자리수가 들어오면 공백으로 채워진다.
SELECT TO_CHAR(123123, '9,999,999,999,999') FROM DUAL;

-- FM을 형식 가장 앞에 붙여주면 불필요한 공백을 없애준다.
SELECT TO_CHAR(123123, 'FM9,999,999,999,999') FROM DUAL;

-- 형식을 지정할 때 0 또는 9를 사용한다
-- 9를 사용하면 남는 자리수를 공백으로 채우고 
-- 0을 사용하면 남는 자리수를 0으로 채운다
SELECT TO_CHAR(123123, '0,000,000,000,000') FROM DUAL;

-- TO_NUMBER() : NUMBER 형으로 변환
SELECT '1000' FROM DUAL; -- 문자열

SELECT TO_NUMBER ('1000') FROM DUAL; -- NUMBER 형식으로 변환

SELECT '1000' + '1000' FROM DUAL; -- 문자열을 서로 더하면 연산이 된다

-- TO_DATE() : DATE 형으로 변환
SELECT TO_DATE('1900.01.02' , 'YYYY.MM.DD')FROM DUAL; -- 문자열을 DATE타입으로 변환
 
----------------------------------------------------------------------------------
-- 집합
/*
 * UNION : 합집합 , 중복을 허용하지 않는다
 * UNION ALL : 합집합 , 중복을 허용한다
 * INTERSECT : 교집합
 * MINUS : 차집합
 */
 
-- 실무에서 생각보다 많이 사용한다
SELECT * FROM EMP e
WHERE DEPTNO = 30;

SELECT * FROM EMP
WHERE DEPTNO = 10;

-- 두 쿼리의 결과를 UNION으로 연결한다.
SELECT * FROM EMP e
WHERE DEPTNO = 30
UNION
SELECT * FROM EMP
WHERE DEPTNO = 10;

/*
 * EMP 테이블에서 SAL이 1000이상 2000이하,
 * 1500 이상 3000 이하의 결과를 같이 조회
 */

-- UNION은 중복제거가 자동으로 됨
SELECT * FROM EMP e 
WHERE SAL BETWEEN  1000 AND 2000
UNION 
SELECT * FROM EMP e
WHERE SAL BETWEEN 1500 AND 3000;

-- UNION ALL은 중복제거를 하지 않는다.
SELECT * FROM EMP e 
WHERE SAL BETWEEN  1000 AND 2000
UNION ALL 
SELECT * FROM EMP e
WHERE SAL BETWEEN 1500 AND 3000;

---------------------------------------------------------------------
SELECT * FROM EMP;
SELECT * FROM DEPT;

-- 오류 발생! : 열(COLUMNS)의 수가 다르면 UNION 불가능!!
SELECT * FROM EMP
UNION ALL
SELECT * FROM DEPT;

-- 오류 발생! : 열(COLUMNS)의 타입이 일치하지 않으면 불가능!!
SELECT EMPNO, DEPTNO ,JOB FROM EMP
UNION ALL
SELECT * FROM DEPT;

-- 열의 수와 타입이 일치한다면 다른 테이블과 UNION이 가능하다.
-- 위쪽에 작성한 쿼리의 칼럼명을 결과 테이블 칼럼명으로 사용한다
SELECT EMPNO 번호, ENAME 이름,JOB 업무 FROM EMP
UNION ALL
SELECT * FROM DEPT;

-- UNION이 두 테이블을 합치고 ORDER BY 가 실행되므로
-- 합쳐지기 이전의 칼럼명이나 소속을 이용해도 정렬이 되지 않는다
SELECT EMPNO 번호, ENAME 이름,JOB 업무 FROM EMP E
UNION ALL
SELECT * FROM DEPT D
ORDER BY E.ENAME;

-- 정렬은 별칭을 사용한다
SELECT EMPNO 번호, ENAME 이름,JOB 업무 FROM EMP
UNION ALL
SELECT * FROM DEPT
ORDER BY 번호;


-- 교집합
SELECT PLAYER_NAME , TEAM_ID , HEIGHT , WEIGHT 
FROM PLAYER p 
WHERE HEIGHT BETWEEN 185 AND 186
INTERSECT
SELECT PLAYER_NAME , TEAM_ID , HEIGHT , WEIGHT 
FROM PLAYER p 
WHERE WEIGHT BETWEEN 76 AND 78;


SELECT PLAYER_NAME , TEAM_ID , HEIGHT , WEIGHT 
FROM PLAYER p 
WHERE HEIGHT BETWEEN 185 AND 186
MINUS 
SELECT PLAYER_NAME , TEAM_ID , HEIGHT , WEIGHT 
FROM PLAYER p 
WHERE WEIGHT BETWEEN 76 AND 78;

------------------------------------------------------------------------
/*
 * VIEW
 * 기존의 테이블은 그대로 놔둔 채 필요한 컬럼들 및 새로운 컬럼을 만든 가상 테이블
 * 실제 데이터가 저장되는 것은 아니지만 VIEW를 통해서 데이터를 조회 및 관리가 가능하다.
 * 
 * - 독립성 : 다른 곳에서 원본 테이블에 접근하지 못하도록 하는 성질
 * - 편리성 : 긴 쿼리문을 짧게 만드는 성질 
 * - 보안성 : 기존의 쿼리문을 감추어 준다.
 * 
 * VIEW 문법
 * CREATE VIEW 뷰이름 AS 쿼리문;
 */

-- PLAYER 테이블에서 나이 칼럼을 추가한 뷰 만들기
SELECT * FROM PLAYER p 

SELECT P.* , SYSDATE - BIRTH_DATE  FROM PLAYER p 

SELECT P.* ,
	TO_CHAR(SYSDATE , 'YYYY') - TO_CHAR(BIRTH_DATE, 'YYYY') + 1 AGE
FROM PLAYER p 

CREATE VIEW VIEW_PLAYER AS
SELECT P.* ,
	TO_CHAR(SYSDATE , 'YYYY') - TO_CHAR(BIRTH_DATE, 'YYYY') + 1 AGE
FROM PLAYER p 

SELECT * FROM VIEW_PLAYER vp ;

SELECT PLAYER_NAME ,AGE FROM VIEW_PLAYER vp ;

/*
 * EMPLOYEES 테이블에서 사원 이름과 그 사원의 매니저 이름이 있는 VIEW를 만들기
 * 이름은 LAST_NAME 과 FIRST_NAME 을 연결하여 저장
 * PK, FK는 반드시 포함 시킬것
 */

SELECT * FROM EMPLOYEES e ;

-- SELF JOIN
SELECT E.EMPLOYEE_ID 사원번호 , E.LAST_NAME || ' ' ||E.FIRST_NAME 사원이름,
	M.EMPLOYEE_ID 매니저번호,
	M.LAST_NAME || ' ' || M.FIRST_NAME 매니저이름,
	E.DEPARTMENT_ID,
	E.JOB_ID
FROM EMPLOYEES E JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID ;

CREATE VIEW VIEW_EMPLOYEES AS
SELECT E.EMPLOYEE_ID 사원번호 , E.LAST_NAME || ' ' ||E.FIRST_NAME 사원이름,
	M.EMPLOYEE_ID 매니저번호,
	M.LAST_NAME || ' ' || M.FIRST_NAME 매니저이름,
	E.DEPARTMENT_ID,
	E.JOB_ID
FROM EMPLOYEES E JOIN EMPLOYEES M
ON E.MANAGER_ID = M.EMPLOYEE_ID ;

SELECT * FROM VIEW_EMPLOYEES ve ;

-- 권한 부여
GRANT UPDATE, DELETE, INSERT ON EMP TO TEST;
-- 권한 위복
REVOKE SELECT, UPDATE, DELETE, INSERT ON EMP FROM TEST;
-- 계정 삭제
DROP USER TEST;

-----------------------------------------------------------------------
/*
 * CASE 표현식
 * 
 * CASE
 *  WHEN 조건1 THEN 값1
 *  WHEN 조건2 THEN 값2
 *  ...
 *  ELSE 값
 * END
 * 
 * 조건 1을 만족하는 행은 값1을 결과로 갖는다.
 * 조건 2을 만족하는 행은 값2을 결과로 갖는다.
 * ...
 * 위에 모든 조건을 만족하지 않으면 ELSE의 값을 결과로 갖는다.
 * ELSE를 생략하면 모든 조건을 만족하지 않는 경우 NULL 이 된다.
 */

/*
 * EMPLOYEES 테이블에서
 * 부서 ID가 50인 부서는 기존 급여에서 10% 삭감
 * 부서 ID가 80인 부서는 기존 급여에서 10% 인상
 * 나머지는 그대로 유지
 * 사원의 이름과 기존급여, 조정급여를 조회
 */

SELECT
	FIRST_NAME,
	SALARY 기존급여,
	CASE
		WHEN DEPARTMENT_ID = 50 THEN SALARY * 0.9
		WHEN DEPARTMENT_ID = 80 THEN SALARY * 1.1
		ELSE SALARY
	END 조정급여,
	DEPARTMENT_ID 부서번호
FROM
	EMPLOYEES e; 

/*
 * EMP 테이블에서 사원들의 번호, 이름, 급여와
 * 최종 급여 칼럼을 같이 조회한다
 * 최종 급여는 커미션(COMM)이 존재하면 봉급과 더하고 -> 존재하면 = IS NOT NULL
 * 커미션이 존재하지 않으면 100을 더해준다 -> 존재하지 않으면 = IS NULL
 * 조회 결과는 최종급여 오름차순으로 정렬
 */

SELECT
	EMPNO 사원번호,
	ENAME 사원이름,
	SAL 급여,
	COMM 커미션,
	CASE 
		WHEN COMM IS NOT NULL THEN SAL + COMM
		WHEN COMM IS NULL THEN SAL + 100
	END "최종 급여"
FROM EMP e
ORDER BY "최종 급여";

SELECT ENAME , SAL, COMM FROM EMP;

------------------------------------------------------------------------

CREATE TABLE TBL_USER(
	USER_ID NUMBER,
	LOGIN_ID VARCHAR2(1000),
	PASSWORD VARCHAR2(1000),
	NAME VARCHAR2(1000),
	AGE NUMBER,
	GENDER CHAR(1) DEFAULT 'N',
	BIRTH DATE,
	CONSTRAINT PK_USER PRIMARY KEY(USER_ID)
);
CREATE SEQUENCE SEQ_USER;


INSERT INTO TBL_USER(USER_ID, LOGIN_ID, PASSWORD, NAME, AGE, GENDER, BIRTH)
VALUES(SEQ_USER.NEXTVAL, 'AAA', '1234', '홍길동', 22, 'M', '20000101');
INSERT INTO TBL_USER(USER_ID, LOGIN_ID, PASSWORD, NAME, AGE, GENDER, BIRTH)
VALUES(SEQ_USER.NEXTVAL, 'BBB', '1234', '이유리', 24, 'F', '1999-03-05');
INSERT INTO TBL_USER(USER_ID, LOGIN_ID, PASSWORD, NAME, AGE, BIRTH)
VALUES(SEQ_USER.NEXTVAL, 'CCC', '1234', '김철수', 12, '1997-11-20');

SELECT * FROM TBL_USER tu ;



----------------------------------------------------------------------
-- 아이디 중복검사
SELECT USER_ID FROM TBL_USER WHERE LOGIN_ID = 'AAA';

-- 회원가입
SELECT * FROM TBL_USER tu 

INSERT INTO TBL_USER
(USER_ID, LOGIN_ID, PASSWORD, NAME, AGE, GENDER, BIRTH)
VALUES(SEQ_USER.NEXTVAL, 'DDD', '1234', '김송호', 26, 'M', '1999-11-22');

SELECT *
FROM ALL_SEQUENCES 
WHERE SEQUENCE_NAME = 'SEQ_USER';

SELECT USER_ID
FROM TBL_USER
WHERE LOGIN_ID = 'AAA' AND PASSWORD = '1234';

SELECT LOGIN_ID 
FROM TBL_USER
WHERE NAME = '홍길동' AND BIRTH = '2000-01-01'
ORDER BY USER_ID ;

UPDATE TBL_USER
SET LOGIN_ID='', PASSWORD='', NAME='', AGE=0, GENDER='N', BIRTH=''
WHERE USER_ID = 0;

SELECT * FROM TBL_USER
ORDER BY USER_ID ;

SELECT * FROM TBL_USER
WHERE USER_ID = 1

DELETE FROM TBL_USER
WHERE USER_ID = 1;

SELECT * FROM TBL_USER tu 
ORDER BY USER_ID;

INSERT INTO TBL_USER
(USER_ID, LOGIN_ID, PASSWORD, NAME, AGE, GENDER, BIRTH)
VALUES(1, 'AAA', '1234', '홍길동', 23, 'M', '20000101');

INSERT INTO TBL_USER
(USER_ID, LOGIN_ID, PASSWORD, NAME, AGE, GENDER, BIRTH)
VALUES(2, 'BBB', '1234', '이유리', 21, 'F', '20041109');

SELECT USER_ID, LOGIN_ID, PASSWORD, NAME, AGE, GENDER, BIRTH
FROM TBL_USER
WHERE BIRTH = '20000101'

--------------------------------------------------------------------------
--# 요구사항을 분석하고 DDL을 사용해서 테이블/뷰를 구현하세요.
--
--요구사항
--1. 학생 정보와 학교 정보를 저장하는 테이블이 필요하다.
--
--- 학교 정보는 학교번호, 학교이름
--- 학생 정보는 학생번호, 학생이름, 학생나이 가 필요하다.
--- 한 학교는 여러 학생을 등록할 수 있다. -> fK , pk

CREATE TABLE TBL_SCHOOL(
	SCHOOL_ID NUMBER,
	SCHOOL_NAME VARCHAR2(100),
	CONSTRAINT PK_SCHOOL PRIMARY KEY(SCHOOL_ID)
);

CREATE TABLE TBL_STUDENT(
	STUDENT_ID NUMBER,
	STUDENT_NAME VARCHAR2(100),
	AGE NUMBER,
	SCHOOL_ID NUMBER,
	CONSTRAINT PK_STUDENT PRIMARY KEY(STUDENT_ID),
	CONSTRAINT FK_STUDENT FOREIGN KEY(SCHOOL_ID)
		REFERENCES TBL_SCHOOL(SCHOOL_ID)
);

CREATE SEQUENCE SEQ_STUDENT;
CREATE SEQUENCE SEQ_SCHOOL;

INSERT INTO TBL_STUDENT(STUDENT_ID, STUDENT_NAME, AGE, SCHOOL_ID)
VALUES(SEQ_STUDENT.NEXTVAL, '홍길동', 18, 1);
INSERT INTO TBL_STUDENT(STUDENT_ID, STUDENT_NAME, AGE, SCHOOL_ID)
VALUES(SEQ_STUDENT.NEXTVAL, '이유리', 19, 1);
INSERT INTO TBL_STUDENT(STUDENT_ID, STUDENT_NAME, AGE, SCHOOL_ID)
VALUES(SEQ_STUDENT.NEXTVAL, '윤세현', 19, 2);
INSERT INTO TBL_STUDENT(STUDENT_ID, STUDENT_NAME, AGE, SCHOOL_ID)
VALUES(SEQ_STUDENT.NEXTVAL, '김송호', 20, 3);
INSERT INTO TBL_STUDENT(STUDENT_ID, STUDENT_NAME, AGE, SCHOOL_ID)
VALUES(SEQ_STUDENT.NEXTVAL, '장미미', 22, 4);
INSERT INTO TBL_STUDENT(STUDENT_ID, STUDENT_NAME, AGE, SCHOOL_ID)
VALUES(SEQ_STUDENT.NEXTVAL, '윤가이', 22, 5);


INSERT INTO TBL_SCHOOL(SCHOOL_ID, SCHOOL_NAME)
VALUES(SEQ_SCHOOL.NEXTVAL, '장덕고');
INSERT INTO TBL_SCHOOL(SCHOOL_ID, SCHOOL_NAME)
VALUES(SEQ_SCHOOL.NEXTVAL, '운남고');
INSERT INTO TBL_SCHOOL(SCHOOL_ID, SCHOOL_NAME)
VALUES(SEQ_SCHOOL.NEXTVAL, '서영대');
INSERT INTO TBL_SCHOOL(SCHOOL_ID, SCHOOL_NAME)
VALUES(SEQ_SCHOOL.NEXTVAL, '고려대');
INSERT INTO TBL_SCHOOL(SCHOOL_ID, SCHOOL_NAME)
VALUES(SEQ_SCHOOL.NEXTVAL, '이화여대');


SELECT * FROM TBL_SCHOOL ts ;
SELECT * FROM TBL_STUDENT ts ;

--2. 학생 정보를 조회할 때 학교 이름을 함께 조회하는 경우가 많아졌다.
--잦은 JOIN사용으로 불편함을 느껴 한번에 조회할 수 있도록 가상의 테이블을 만들고 싶다.
--(모든 학생 정보와 학교 이름을 칼럼으로 가져야한다.) -> JOIN 사용
CREATE VIEW VIEW_STUDENT AS
SELECT S.SCHOOL_ID , S.STUDENT_ID, S.STUDENT_NAME, S.AGE, SC.SCHOOL_NAME 
FROM TBL_STUDENT S
JOIN TBL_SCHOOL SC 
ON S.SCHOOL_ID = SC.SCHOOL_ID;

SELECT * FROM VIEW_STUDENT vs 
ORDER BY STUDENT_ID ;

--3. 학교 정보를 저장하다보니 데이터가 많아져 조회 속도가 낮아져서 조회 속도를 향상 시키고 싶다.
--학교 테이블의 데이터는 다음과 같은 특징이 있다.
--A) 학교 정보는 한 번 등록하면 삭제할 일이 거의 없다.
--B) 학교 이름으로 조회하는 경우가 많다.
--C) 학교 이름은 중복되지 않는다.
CREATE UNIQUE INDEX IDX_SCHOOL ON TBL_SCHOOL(SCHOOL_NAME);

--4. 2번과 3번에서 만든 객체의 데이터 사전을 조회하는 명령어를 작성하세요
SELECT * FROM ALL_VIEWS WHERE VIEW_NAME = 'VIEW_STUDENT';
SELECT * FROM ALL_INDEXES WHERE INDEX_NAME = 'IDX_SCHOOL';



-- 서술형 문제
CREATE TABLE TBL_USER(
	USER_NAME VARCHAR2(1000),
	USER_AGE NUMBER
);

-- 1. 컬럼 추가(성별 추가)
ALTER TABLE TBL_USER 
ADD USER_SEX CHAR

-- 2. 컬럼 이름 수정(USER_NAME을 USER_NICKNAME으로)
ALTER TABLE TBL_USER 
RENAME COLUMN USER_NAME TO USER_NICKNAME;

-- 3. 컬럼 삭제(성별 삭제)
ALTER TABLE TBL_USER 
DROP COLUMN USER_SEX

-- 4. 컬럼 타입 수정(닉네임을 NUMBER로)
ALTER TABLE TBL_USER 
MODIFY(USER_NICKNAME NUMBER);

-- 5. USER_AGE에 제약조건 '기본키'를 설정하기
ALTER TABLE TBL_USER 
	ADD CONSTRAINT PK_USER PRIMARY KEY(USER_AGE);

-- 6. 유저 테이블 삭제
DROP TABLE TBL_USER;


CREATE TABLE TBL_USER(
  USER_NUMBER NUMBER,
  USER_NAME VARCHAR2(1000),
  USER_AGE NUMBER,
  CONSTRAINT PK_USER PRIMARY KEY(USER_NUMBER)
);


CREATE TABLE TBL_BOARD(
  BOARD_NUMBER NUMBER,
  BOARD_TITLE VARCHAR2(1000),
  BOARD_CONTENT VARCHAR2(1000),
  USER_NUMBER NUMBER,
  CONSTRAINT PK_BOARD PRIMARY KEY(BOARD_NUMBER),
  CONSTRAINT FK_BOARD FOREIGN KEY (USER_NUMBER)
         REFERENCES TBL_USER(USER_NUMBER)
);

SELECT *FROM TBL_USER tu ;
SELECT * FROM TBL_BOARD tb ;


-- 7. USER 정보 중 NAME에 '김' 이 들어가는 회원 전체 정보를 조회하는 쿼리 작성하기
INSERT INTO TBL_USER(USER_NUMBER, USER_NAME, USER_AGE)
VALUES(1, '김송호', 26);
INSERT INTO TBL_USER(USER_NUMBER, USER_NAME, USER_AGE)
VALUES(2, '김승우', 25);

SELECT *
FROM TBL_USER tu 
WHERE USER_NAME LIKE '김%'

-- 8. BOARD테이블의 게시물 전체를 조회할 때 작성자의 NAME을 같이 조회하는 쿼리 작성하기
SELECT TB.* , TU.USER_NAME 
FROM TBL_BOARD tb JOIN TBL_USER tu 
ON TB.USER_NUMBER  = TU.USER_NUMBER 



-- 9. USER 테이블과 BOARD 테이블에 데이터를 삽입하는 쿼리를 작성하고 트랜잭션 완료하기

SELECT * FROM TBL_USER tu ;
SELECT * FROM TBL_BOARD tb ;

INSERT INTO TBL_USER(USER_NUMBER, USER_NAME, USER_AGE)
VALUES(3, '윤따라', 25);
INSERT INTO TBL_USER(USER_NUMBER, USER_NAME, USER_AGE)
VALUES(4, '장모모', 30);

INSERT INTO TBL_BOARD(BOARD_NUMBER, BOARD_TITLE, BOARD_CONTENT, USER_NUMBER)
VALUES(1, '안녕', '만나서 반가워', 1);
INSERT INTO TBL_BOARD(BOARD_NUMBER, BOARD_TITLE, BOARD_CONTENT, USER_NUMBER)
VALUES(2, '배고파', '저녁 추전좀', 2);

COMMIT;

-- 10. 9번 문제에서 삽입한 BOARD테이블의 데이터를 삭제하고 트랜잭션 취소하기
DELETE FROM TBL_BOARD tb 
WHERE BOARD_NUMBER IN (1,2);

ROLLBACK;










