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

-- 내가 원하는 칼럼에 데이터를 추가할 때 사용
INSERT INTO TBL_MEMBER(NAME, AGE)
VALUES('김송호', 26);

-- 모든 칼럼에 데이터를 추가할 떄 사용, 단 순서가 일치해야함
INSERT INTO TBL_MEMBER
VALUES('장희재', 33);

INSERT INTO TBL_MEMBER(NAME)
VALUES('박정민');

INSERT INTO TBL_MEMBER(AGE, NAME)
VALUES(26, '윤세현');


SELECT * FROM TBL_MEMBER tm ;


UPDATE TBL_MEMBER 
SET NAME = '아무무';

UPDATE TBL_MEMBER 
SET NAME = '김송호'
WHERE AGE = 26;

-- [실습]
-- 나이가 NULL인 회원의 이름을 홍길동으로 수정하기
UPDATE TBL_MEMBER
SET NAME = '홍길동'
WHERE AGE IS NULL;

-- 삭제
DELETE FROM TBL_MEMBER tm
WHERE NAME = '아무무';

DELETE FROM TBL_MEMBER tm 

SELECT * FROM TBL_MEMBER tm ;

CREATE TABLE TBL_STUDENT(
	STUDENT_ID  NUMBER,
	STUDENT_NAME  VARCHAR2(50),
	MATH NUMBER,
	ENG NUMBER,
	KOR NUMBER,
	GRADE CHAR(1)
);

/*
 * [실습]
 * 학생 테이블에 데이터를 추가한다.
 * 학생번호, 이름, 수학, 영어, 국어
 * 1. '김철수', 90, 90, 90
 * 2. '홍길동', 70, 25, 55
 * 3. '이유리', 89, 91, 77
 * 4. '김웅이', 48, 100, 92
 * 5. '신짱구', 22, 13, 9
 */

/*
 * [실습]
 * 전체 학생들의 이름과 평균점수를 조회(별칭 사용)
 */

INSERT INTO TBL_STUDENT(STUDENT_ID,STUDENT_NAME,MATH,ENG,KOR)
VALUES(1, '김철수' , 90 , 90 , 90)

INSERT INTO TBL_STUDENT(STUDENT_ID,STUDENT_NAME,MATH,ENG,KOR)
VALUES(2, '홍길동' , 70 , 25 , 55)

INSERT INTO TBL_STUDENT(STUDENT_ID,STUDENT_NAME,MATH,ENG,KOR)
VALUES(3, '이유리' , 89 , 91 , 77)

INSERT INTO TBL_STUDENT(STUDENT_ID,STUDENT_NAME,MATH,ENG,KOR)
VALUES(4, '김웅이' , 48 , 100 , 92)

INSERT INTO TBL_STUDENT(STUDENT_ID,STUDENT_NAME,MATH,ENG,KOR)
VALUES(5, '신짱구' , 22 , 13 , 9)

SELECT
	STUDENT_ID "학생 번호",
	STUDENT_NAME 이름,
	MATH 수학,
	ENG 영어,
	KOR 국어,
	(MATH + ENG + KOR) / 3 "평균 점수"
FROM
	TBL_STUDENT ts 
ORDER BY STUDENT_ID ASC;

/*
 * [실습]
 * 학생의 평균점수를 구하고 학점을 수정하기 -> UPDATE
 * A : 90점 이상
 * B : 80점 이상 90점 미만
 * C : 50점 이상 80점 미만
 * F : 50점 미만
 */

UPDATE TBL_STUDENT 
SET GRADE = 'A'
WHERE (MATH + ENG + KOR) / 3 >= 90

UPDATE TBL_STUDENT 
SET GRADE = 'B'
WHERE (MATH + ENG + KOR) / 3 >= 80 AND (MATH + ENG + KOR) / 3 < 90 

UPDATE TBL_STUDENT 
SET GRADE = 'C'
WHERE (MATH + ENG + KOR) / 3 >= 50 AND (MATH + ENG + KOR) / 3 < 80

UPDATE TBL_STUDENT 
SET GRADE = 'F'
WHERE (MATH + ENG + KOR) / 3 < 50


SELECT
	STUDENT_NAME 이름,
	MATH 수학,
	ENG 영어,
	KOR 국어,
	(MATH + ENG + KOR) / 3 "평균 점수",
	GRADE 학점
FROM
	TBL_STUDENT ts
ORDER BY
	GRADE ASC;


/*
 * [실습]
 * 학점이 잘 들어갔는지 확인하기 위해서
 * 학생번호, 이름, 평균, 학점 조회 (별칭 사용)
 */

SELECT
	STUDENT_ID "학생 번호",
	STUDENT_NAME 이름,
	(MATH + ENG + KOR) / 3 "평균 점수",
	GRADE 학점
FROM
	TBL_STUDENT ts 
ORDER BY STUDENT_ID; 

SELECT * 
FROM TBL_STUDENT ts
ORDER BY STUDENT_ID ;

/*
 * [실습]
 * 학생의 수학, 영어, 국어 점수 중 한 과목이라도 50점 미만이 아니고
 * 학점이 B 이상인 학생만 학생 번호, 이름, 학점 조회
 */

SELECT
	STUDENT_ID "학생 번호",
	STUDENT_NAME "학생 이름",
	MATH 수학,
	ENG 영어,
	KOR 국어,
	GRADE 학점
FROM
	TBL_STUDENT ts
WHERE
	MATH > 50
	AND ENG > 50
	AND KOR > 50
	AND GRADE <= 'B'
ORDER BY GRADE ;


SELECT
	STUDENT_ID "학생 번호",
	STUDENT_NAME "학생 이름",
	MATH 수학,
	ENG 영어,
	KOR 국어,
	GRADE 학점
FROM
	TBL_STUDENT ts
WHERE NOT (MATH < 50 OR ENG < 50 OR KOR < 50)
	AND (GRADE <= 'B')
ORDER BY GRADE ;


SELECT * FROM TBL_STUDENT ts 


/*
 * [실습]
 * 학생의 수학, 영어, 국어 점수 중
 * 한 과목이라도 30점 미만이면 퇴학시키기(DB에서 삭제) -> DELETE
 */

-- AND 는 3개가 다 TRUE면 삭제
-- OR 는 3중 하나라도 TRUE면 삭제

DELETE FROM TBL_STUDENT ts 
WHERE MATH < 30 OR ENG < 30 OR KOR < 30;

SELECT * FROM TBL_STUDENT ts 
ORDER BY STUDENT_ID ;


































