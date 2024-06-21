/*
 * SUB 쿼리
 * - 하나의 쿼리 내에 작성하는 또 다른 쿼리
 * - 서브 쿼리의 위치에 따른 종류
 * 1. FROM 절 : INLINE VIEW
 * 2. SELECT 절 : SCALAR
 * 3. WHERE 절 : SUB QUERY
 * 
 */

-- PLAYER 테이블에서 전체 평균 키와 포지션별 평균 키 조회
SELECT AVG(HEIGHT) FROM PLAYER p 

SELECT AVG(HEIGHT) FROM PLAYER p
GROUP BY "POSITION" 
HAVING "POSITION" IS NOT NULL;

-- 집계함수를 사용하고 싶다면 GROUP BY를 사용해야한다
-- SELECT 절에서 사용하는 SUB QUERY (SCALAR)
SELECT "POSITION", 
		AVG(HEIGHT), 
		(SELECT AVG(HEIGHT) FROM PLAYER p) "전체 평균키"
FROM PLAYER p 
WHERE "POSITION" IS NOT NULL
GROUP BY "POSITION"

-- FROM 절에서 사용하는 SUB QUERY (INLINE VIEW)

/*
 * PLAYER 테이블에서 TEAM_ID가 'K01'인 선수 중 POSITION이
 * 'GK'인 선수를 조회하기(서브쿼리 활용하기)
 * 
 */

SELECT * FROM PLAYER p 
WHERE TEAM_ID = 'K01';

SELECT * FROM PLAYER p 
WHERE "POSITION" = 'GK';


SELECT *
FROM (
	SELECT * FROM PLAYER p 
	WHERE TEAM_ID = 'K01'
)  
WHERE "POSITION" = 'GK';

-- 서브쿼리를 안쓰는게 더 빠르다. (효율)
-- 서브쿼리를 쓰기전에 안써도 해결 되는지 먼저 고민하고 사용한다.

-- WHERE절에 사용하는 서브쿼리

/*
 * PLAYER 테이블에서 평균 몸무게보다 더 많이 나가는 선수들 조회
 */

SELECT ROUND(AVG(WEIGHT) , 2)  
FROM PLAYER p 

SELECT * FROM PLAYER p 
WHERE WEIGHT > (SELECT AVG(WEIGHT) FROM PLAYER p );


-- PLAYER 테이블에서 정남일 선수가 소속된 팀의 선수를 전체 정보 조회

SELECT TEAM_ID 
FROM PLAYER p 
WHERE TEAM_ID  = 'K07'

SELECT * FROM PLAYER p 
WHERE TEAM_ID  = (
	SELECT TEAM_ID 
	FROM PLAYER p 
	WHERE PLAYER_NAME = '정남일'
);

-- SCHEDULE 테이블에서 경기 일정이
-- '20120501 ~ 20120502 ' 있는 경기장 전체 정보 조회
SELECT * FROM SCHEDULE s; 
SELECT * FROM STADIUM s;

-- 문자 비교로 결과가 잘 나오는 지 확인
SELECT SCHE_DATE 
FROM SCHEDULE s 
WHERE SCHE_DATE >= '20120512'
ORDER BY SCHE_DATE ;

SELECT STADIUM_ID , SCHE_DATE  FROM SCHEDULE s 
WHERE SCHE_DATE >= '20120501' AND SCHE_DATE <= '20120502'

SELECT STADIUM_ID FROM SCHEDULE s 
WHERE SCHE_DATE >= '20120501' AND SCHE_DATE <= '20120502'



-- STADIUM_ID와 비교하는 대상이 여러개다.
-- 우리는 STADIUM_ID = 'C02' OR STADIUM_ID = 'B05' OR  ....
-- 이런식으로 비교를 해야한다.
-- 그러나 이 경우 OR를 직접 작성하는게 불가능하다
-- 이럴때는 IN 을 사용한다. 
SELECT * FROM STADIUM s 
WHERE STADIUM_ID IN (
	SELECT STADIUM_ID FROM SCHEDULE s 
	WHERE SCHE_DATE >= '20120501' AND SCHE_DATE <= '20120502'
);

/*
 * TCL 트랜잭션 버튼 클릭 메뉴얼 커밋으로 변경 후 실습하기
 * 아래 실습 후 반드시 ROLLBACK 하기
 */

/*
 * PLAYER 테이블에서 NICKNAME이 NULL인 선수들을 정태민 선수의 닉네임으로 변경하기
 */

SELECT NICKNAME 
FROM PLAYER p 
WHERE p.PLAYER_NAME = '정태민';

UPDATE PLAYER 
SET NICKNAME = (
	SELECT NICKNAME 
	FROM PLAYER p 
	WHERE p.PLAYER_NAME = '정태민'
) 
WHERE NICKNAME IS NULL;

SELECT NICKNAME  FROM PLAYER p ;

ROLLBACK;

/*
 * EMPLOYEES 테이블에서 평균 급여보다 낮은 사원들의 급여를
 * 20% 인상 -> * 0.2
 */

-- 평균 급여 = 6,461
SELECT AVG(SALARY)
FROM EMPLOYEES e 

SELECT MIN(SALARY) FROM EMPLOYEES e 

UPDATE EMPLOYEES 
SET SALARY = SALARY * 1.2
WHERE SALARY < (
	SELECT AVG(SALARY)
	FROM EMPLOYEES e 
);

SELECT SALARY  FROM EMPLOYEES e ;

ROLLBACK;

/*
 * PLAYER 테이블에서 평균 키보다 큰 선수들을 삭제
 */

-- 179CM
SELECT AVG(HEIGHT) 
FROM PLAYER p; 

SELECT MAX(HEIGHT) FROM PLAYER p 

DELETE FROM PLAYER p 
WHERE HEIGHT > (SELECT AVG(HEIGHT) 
FROM PLAYER p 
);

SELECT HEIGHT FROM PLAYER p;

ROLLBACK;

---------------------------------------------------------------------

/*
 * ROWNUM
 * 결과 행 앞에 1부터 1씩 증가하는 값을 붙여준다.
 */

-- rownum은 그냥 칼럼처럼 사용하면 된다.
-- * 을 다른 컬럼과 함께 조회하려면 항상 소속을 명시해야한다
SELECT ROWNUM, e.*  FROM EMPLOYEES e;

SELECT ROWNUM, e.*  
FROM EMPLOYEES e
WHERE ROWNUM <= 5;

-- 조회 대상이 아니여도 WHERE에 조건으로 사용이 가능하다
SELECT FIRST_NAME 
FROM EMPLOYEES e 
WHERE SALARY > 12000;

-- ROWNUM도 조회하지 않아도 조건으로 사용이 가능하다.
SELECT *
FROM EMPLOYEES e 
WHERE ROWNUM <= 5;

/*
 * EMPLOYEES 테이블에서 SALARY를 내림차순으로 정렬한 후
 * ROWNUM을 붙여서 조회하기
 */

/*
 * ORDER BY 보다 SELECT가 먼저 실행된다
 * 즉, ROWNUM은 정렬하기 이전에 먼저 부여가 되고
 * 나중에 정렬이 되므로 뒤섞이게 된다.
 */
SELECT ROWNUM, e.*
FROM EMPLOYEES e 
ORDER BY SALARY DESC;

/*
 * ROWNUM을 부여하기 전에 먼저 정렬을 한 테이블을 만든다. 
 */
SELECT * FROM EMPLOYEES e 
ORDER BY SALARY DESC;

/*
 * 정렬이 끝난 테이블을 다시 조회하면서 ROWNUM을 부여하면
 * SALARY순으로 정렬된 데이터에 ROWNUM을 순차적으로 붙일 수 있다.
 */
SELECT ROWNUM, S1.* 
FROM ( -- FROM절 안에 서브쿼리를 만들어 정렬
	SELECT * FROM EMPLOYEES e 
	ORDER BY SALARY DESC
) S1;


/*
 * ROWNUM을 활용하면 결과의 상위 데이터만 조회가 가능하다.
 */
SELECT ROWNUM, S1.* 
FROM ( -- FROM절 안에 서브쿼리를 만들어 정렬
	SELECT * FROM EMPLOYEES e 
	ORDER BY SALARY DESC
) S1
WHERE ROWNUM BETWEEN 1 AND 10;

/*
 * ROWNUM으로 11부터 조회를 하게되면 결과가 나오지 않는다.
 * ROWNUM은 무조건 1부터 조회가 가능하다
 */
SELECT ROWNUM, S1.* 
FROM ( -- FROM절 안에 서브쿼리를 만들어 정렬
	SELECT * FROM EMPLOYEES e 
	ORDER BY SALARY DESC
) S1
WHERE ROWNUM BETWEEN 11 AND 20;


/*
 * ROWNUM이 11 ~ 20 까지인 데이터를 조회하고 싶다면
 * 우선 마지막 번호까지의 데이터를 모두 조회한다
 */
SELECT ROWNUM, S1.* 
FROM ( -- FROM절 안에 서브쿼리를 만들어 정렬
	SELECT * FROM EMPLOYEES e 
	ORDER BY SALARY DESC
) S1
WHERE ROWNUM <= 20;


/*
 * 가장 외부에 있는 SELECT에서 시작 번호를 조건으로 사용해야하는데
 * ROWNUM이라고 사용하면 내부의 서브쿼리가 가진 칼럼이 아닌
 * 새로운 ROWNUM을 부여하므로 조건이 이상하게 적용된다.
 * 그러므로 서브쿼리에서 ROWNUM이 아닌 별칭을 부여해주고
 * 외부 쿼리에서 별칭으로 가져다 사용한다.
 */
SELECT *
FROM(
	SELECT ROWNUM rnum, S1.* 
	FROM ( -- FROM절 안에 서브쿼리를 만들어 정렬
		SELECT * FROM EMPLOYEES e 
		ORDER BY SALARY DESC
	) S1
	WHERE ROWNUM <= 20
) WHERE rnum > 10;

------------------------------------------------------------------------
-- JOIN

/*
 * EMP 테이블의 사원정보와 DEPT 테이블의 지역을 한번에 조회
 */

-- JOIN을 사용할 때 테이블간 관계를 먼저 파악한다
SELECT * FROM EMP e;
SELECT * FROM DEPT d;  

-- 두 테이블간 관계에서 DEPTNO를 FK로 사용하고 있다.
-- DEPTNO를 비교하여 등가 JOIN을 사용할 수 있다.
-- 테이블에 별칭을 부여해야 ON절에서 칼럼 구분이 가능하다.
SELECT * 
FROM EMP e INNER JOIN DEPT d
ON e.DEPTNO = d.DEPTNO 

-- JOIN을 통해 합쳐진 결과에서 원하는 칼럼만 SELECT한다.
SELECT e.ENAME, d.LOC , e.DEPTNO  
FROM EMP e INNER JOIN DEPT d
ON e.DEPTNO = d.DEPTNO 


-- PLAYER 테이블에서 송종국 선수가 속한 팀의 전화번호를 조회

-- 1. 테이블 데이터와 관계 확인하기
SELECT * FROM PLAYER p; 
SELECT * FROM TEAM t ;

-- 2. 일단 합치기
SELECT *
FROM PLAYER p INNER JOIN TEAM t 
ON p.TEAM_ID = t.TEAM_ID 

-- 3. 필요한 데이터만 추려내기
SELECT P.PLAYER_NAME , T.TEAM_NAME  ,  T.TEL
FROM PLAYER p INNER JOIN TEAM t 
ON p.TEAM_ID = t.TEAM_ID 
WHERE p.PLAYER_NAME = '송종국'

-- #. INNER JOIN은 INNER 생략 가능하다.
SELECT P.PLAYER_NAME , T.TEAM_NAME  ,  T.TEL
FROM PLAYER p JOIN TEAM t 
ON p.TEAM_ID = t.TEAM_ID AND p.PLAYER_NAME = '송종국' 





















