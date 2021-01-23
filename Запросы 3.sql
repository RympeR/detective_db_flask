// Получить список завершённых дел. //
SELECT * FROM cases WHERE DateOfCseClose IS NOT NULL
//
//Получить список клиентов, упорядоченных по количеству заключённых договоров.//  
SELECT firstname, lastname, surname,  count( cs.clientid) AS clientss
FROM Cases cs
JOIN Client cl ON cl.clientid = cs.clientid
GROUP BY firstname, lastname, surname
ORDER BY clientss DESC
//
//Определить 5 самых дорогих услуг.
SELECT * FROM Service ORDER BY ServicePrice DESC LIMIT 5
//
//Получить список улик, в описании которых есть слово «[не]чёткий(-ая|-ое|-ому|-ого|-ие|-им|-ой)».
SELECT * FROM Evidence WHERE DescropyionOfEvidence ~*'((не)*ч(е|ё)тк((о(е|го|му|й))|(и(й|е|м))|ая))'
//
//Удалить информацию о конкретном подозреваемом. При необходимости выполнить несколько запросов.
UPDATE Suspect
SET description = DEFAULT,
Hight = DEFAULT,
Weight = DEFAULT,
DateOfBirthday = DEFAULT,
Profession = DEFAULT
WHERE suspectid ---ID ПОДОЗРЕВАЕМОГО---
//
//Определить ФИО детективов, которые стали клиентами своего агентства.
SELECT  d.FirstName, d.LastName, d.SurName FROM Detective d
JOIN client cl ON d.surname = cl.surname 
WHERE d.surname = cl.surname 
AND d.FirstName = cl.FirstName
AND d.SurName = cl.SurName
//
//Для услуг, в описании которых есть слово «наблюдение», поднят стоимость на 20%.
UPDATE service SET serviceprice = serviceprice + serviceprice* 0.2 WHERE DescropyionOfService ~*'(наблюдение)'

SELECT * FROM Service
//
// Получить общий список описаний улик и заметок, внесённых в конкретную дату (на усмотрение студента), с указанием «заметка» это или «услуга» (словом в доп. поле результата). ---
--SELECT DateOfEvidenceAppearance AS дата_добавления_улики,EvidenceType, dateOfLastChange AS дата_добавления_заметки,DescriptionOfNote  FROM Evidence e, ListOfNotes n
--WHERE dateOfLastChange = '11.12.2019' 
--AND DateOfEvidenceAppearance = '11.12.2019'

SELECT e.descropyionofevidence, 'улика' result   FROM  evidence e
WHERE e.DateOfEvidenceAppearance = '11.12.2019' 
UNION
SELECT n.descriptionofnote,  'заметка' FROM listofnotes n 
WHERE n.dateOfLastChange = '11.12.2019' 
//
// Получить список дел, в которых есть улики, но нет подозреваемых.
SELECT DISTINCT ca.caseid From cases ca
LEFT join listofsuspects ls ON ca.caseid = ls.caseid
JOIN Listofevidence lo ON ca.CaseId = lo.CaseId
WHERE ls.caseid IS NULL
//