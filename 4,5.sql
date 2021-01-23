
4.1 --  Создать представление для отображения рейтинга детективов при ранжировании по: 
--– количеству завершённых дел; – среднему времени, затраченному на дело; – сумме дохода от клиентов.
CREATE OR REPLACE VIEW Rating AS 
(
	SELECT detectiveid,COUNT(caseid), age(dateofcseclose, caseregistrationdate) "average time", SUM(serviceprice)
	FROM Detective 
	INNER JOIN Cases USING(detectiveid)
	INNER JOIN Listofservice USING(caseid)
	INNER JOIN Service USING(serviceid)
	WHERE dateofcseclose IS NOT NULL
	GROUP BY 1,3
);

SELECT detectiveid, RANK() OVER (ORDER BY count DESC), RANK() OVER (ORDER BY "average time" ),
		RANK() OVER (ORDER BY SUM DESC)
FROM Rating;

4.2--Определить клиентов с наибольшим количеством незавершённых дел (их м.б. несколько с одинаковым количеством).
WITH caseCount AS (
	SELECT clientid, RANK() OVER(ORDER BY COUNT(caseid) DESC)
	FROM Client
	INNER JOIN Cases USING(clientid)
	WHERE dateofcseclose IS NULL
	GROUP BY 1)
SELECT *
FROM caseCount
WHERE rank = 1

4.3 --Создать представление для отображения «прибыльности» 
--сотрудников (соотношение дохода от дел (клиентов) и зарплаты, выплаченной за время их решения).

CREATE OR REPLACE VIEW profitability AS 
(
	SELECT detectiveid, SUM(serviceprice)
	FROM Detective
	INNER JOIN Cases USING(detectiveid)
	INNER JOIN listofservice USING(caseid)
	INNER JOIN service USING(serviceid)
	GROUP BY 1
	
);

SELECT *
FROM Profitability




5.1--Создать триггер, блокрующий оформление дела, если количество незавершенных дел у детектива больше 5 

CREATE OR REPLACE FUNCTION AddCaseFunc()
          RETURNS TRIGGER 
AS $$
  DECLARE totalSum INT;
BEGIN
  SELECT COUNT(caseid) INTO totalSum
  FROM Cases
  WHERE detectiveid = new.detectiveid AND dateofcseclose IS NULL;
  
  IF(totalSum >= 5)
  THEN 
    RAISE EXCEPTION 'Превышено количество незакрытых дел. Выберите другого детектива';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;
/*
CREATE TRIGGER AddCase
BEFORE INSERT ON Cases
FOR EACH ROW
EXECUTE PROCEDURE AddCaseFunc();*/


5.2--Составить хранимую процедуру для отображения информации о состоянии текущего дела конкретного клиента (подключённые сотрудники, версии, 
--																улики, артефакты, документы, действия – в зависимости от типа дела)
--. ФИО клиента передавать как параметр.

5.3--Составить хранимую процедуру для увольнения сотрудника и передачи дела наименее загруженному. ФИО сотрудника передавать как параметр.
CREATE OR REPLACE FUNCTION dismissalDetective (first_name varchar, last_name varchar)
							RETURNS int
AS $$
	DECLARE newDetective int;
			oldDetective int;
BEGIN
	WITH caseCount AS
	(
		SELECT detectiveid, COUNT(caseid)
		FROM Detective
		INNER JOIN Cases USING(detectiveid)
		GROUP BY 1
		ORDER BY 2
	)
	SELECT detectiveid INTO newDetective
	FROM caseCount;
	
	SELECT detectiveid INTO oldDetective
	FROM Detective
	WHERE firstname = first_name AND lastname = last_name;
	
	UPDATE CASES
		SET detectiveid = newDetective
	WHERE detectiveid = oldDetective;
	
	DELETE FROM Detective
	WHERE detectiveid = oldDetective;
	
	RETURN newDetective;
	
END;
$$ LANGUAGE plpgSQL;