
CREATE DOMAIN TypeOfEvidence VARCHAR CHECK(VALUE IN('Фото','Документ','Другое','Видео'));
CREATE DOMAIN SuspectStatus VARCHAR CHECK(VALUE IN('Не причастен','Причастен','Не виновен','Виновен'));


CREATE TABLE Client
(
	ClientId SERIAL PRIMARY KEY,
	FirstName VARCHAR NOT NULL,
	LastName VARCHAR NOT NULL,
    SurName VARCHAR NOT NULL,
	Email VARCHAR NOT NULL,
	Phone CHAR(13) NOT NULL,
	DateOfBirthday DATE NOT NULL,
    login_ text unique not null,
    pass_ text not null
);

CREATE TABLE Detective
(
	DetectiveId SERIAL PRIMARY KEY,
	FirstName VARCHAR NOT NULL,
	LastName VARCHAR NOT NULL,
    SurName VARCHAR NOT NULL,
	Passport VARCHAR NOT NULL,
	Address VARCHAR NOT NULL,
	DateOfBirthday DATE NOT NULL,
	EmploymentDate DATE NOT NULL,
    Hight integer NOT NULL,
    Weight integer NOT NULL,
    role_ text not null,
    login_ text unique not null,
    pass_ text not null
);

CREATE TABLE Suspect
(
	SuspectId SERIAL PRIMARY KEY,
	FirstName VARCHAR NOT NULL,
	LastName VARCHAR NOT NULL,
    SurName VARCHAR NOT NULL,
    DateOfBirthday DATE,
    Description VARCHAR,
    Profession VARCHAR,
    Hight integer,
    Weight integer 
);


CREATE TABLE Evidence
(
    EvidenceId SERIAL PRIMARY KEY,
    DateOfEvidenceAppearance DATE NOT NULL,
    EvidenceType TypeOfEvidence NOT NULL,
    EvidanceUrl VARCHAR NOT NULL,
    DescropyionOfEvidence VARCHAR NOT NULL
);

CREATE TABLE Service
(
    ServiceId SERIAL PRIMARY KEY,
    NameOfService VARCHAR NOT NULL,
    DescropyionOfService VARCHAR NOT NULL,
    ServicePrice integer NOT NULL
);

CREATE TABLE CaseStatus(
    StatusId SERIAL PRIMARY KEY,
    statusDescription text
);

CREATE TABLE Cases
(
    CaseId SERIAL PRIMARY KEY,
    ClientId integer NOT NULL REFERENCES Client (ClientId),
    DetectiveId integer NOT NULL REFERENCES Detective (DetectiveId),
    CaseRegistrationDate DATE NOT NULL,
    CaseDescription VARCHAR NOT NULL,
    DateOfCseClose DATE,
    StatusId integer NOT NULL REFERENCES CaseStatus (StatusId) DEFAULT 1
);

CREATE TABLE ListOfSuspects
(
    SuspectId integer NOT NULL REFERENCES Suspect (SuspectId),
    CaseId integer NOT NULL REFERENCES Cases (CaseId),
    SuspectStatus SuspectStatus,
    PRIMARY KEY (SuspectId,CaseId)

);

CREATE TABLE ListOfEvidence
(

    EvidenceId integer NOT NULL  REFERENCES Evidence (EvidenceId),
    CaseId integer  NOT NULL REFERENCES Cases (CaseId),
    DateOfAdd DATE NOT NULL,
    PRIMARY KEY (EvidenceId,CaseId)
);

CREATE TABLE ListOfNotes
(
    ID SERIAL PRIMARY KEY,
    CaseId integer NOT NULL REFERENCES Cases (CaseId),
    DateOfLastChange DATE NOT NULL,
    DescriptionOfNote VARCHAR NOT NULL
);

CREATE TABLE ListOfService
(
    ServiceId integer NOT NULL REFERENCES Service (ServiceId),
    CaseId integer NOT NULL REFERENCES Cases (CaseId),
    StatusId integer NOT NULL REFERENCES CaseStatus (StatusId) DEFAULT 1,
    PRIMARY KEY (ServiceId,CaseId)
);

CREATE TABLE ServiceOrder
(
    serviceOrderId SERIAL PRIMARY KEY,
    ClientId integer NOT NULL REFERENCES Client (ClientId),
    ServiceId integer NOT NULL REFERENCES Service (ServiceId),
    StatusId integer NOT NULL REFERENCES CaseStatus (StatusId) DEFAULT 1,
    DetectiveId integer NOT NULL REFERENCES Detective (DetectiveId),
    meet_date date not null
);
    
INSERT INTO Client(FirstName, LastName, SurName, Email, Phone, DateOfBirthday, login_, pass_) VALUES('Василий', 'Васильевич','Пупкин','pupkin@gmail.com','0998546197','16.09.1953', 'client1', '1234');
INSERT INTO Client(FirstName, LastName, SurName, Email, Phone, DateOfBirthday, login_, pass_) VALUES('Петр', 'Иванович','Гусев','gusev@gmail.com','0998549647','20.01.1997', 'client2', '1234');
INSERT INTO Client(FirstName, LastName, SurName, Email, Phone, DateOfBirthday, login_, pass_) VALUES('Антон', 'Петровчи','Петров','petrov@gmail.com','0609546197','06.06.1966', 'client3', '1234');
INSERT INTO Client(FirstName, LastName, SurName, Email, Phone, DateOfBirthday, login_, pass_) VALUES('Иван', 'Васильевич','Царь','king@gmail.com','0078546007','07.07.1977', 'client4', '1234');
INSERT INTO Client(FirstName, LastName, SurName, Email, Phone, DateOfBirthday, login_, pass_) VALUES('Евгений', 'Николевич','Прораб','prorab@gmail.com','0992648197','13.11.1983', 'client5', '1234');
INSERT INTO Client(FirstName, LastName, SurName, Email, Phone, DateOfBirthday, login_, pass_) VALUES('Джеймс', 'Филлипов','Рейнор','raynor@gmail.com','0992648197','01.01.163', 'client6', '1234');

INSERT INTO Detective (FirstName, LastName, SurName, Passport, Address, DateOfBirthday,EmploymentDate,Hight,Weight,role_,login_,pass_) VALUES('Джеймс', 'Богданович','Бонд','КМ98304','Переулок Героев 7, 7 квартира ','12.03.1979','19.10.2016','155','80','director','director','1234');
INSERT INTO Detective (FirstName, LastName, SurName, Passport, Address, DateOfBirthday,EmploymentDate,Hight,Weight,role_,login_,pass_) VALUES('Адальф', 'Рамзанович','Гындлер','ВН98984','Сады победы 45, 15 квартира ','06.12.1959','13.10.2016','197','60','detective','detective1','1234');
INSERT INTO Detective (FirstName, LastName, SurName, Passport, Address, DateOfBirthday,EmploymentDate,Hight,Weight,role_,login_,pass_) VALUES('Михаил', 'Петрович','Зубенко','КС98390','Улица Мафизия, 89 квартира ','30.05.1986','16.05.2013','169','100','detective','detective2','1234');
INSERT INTO Detective (FirstName, LastName, SurName, Passport, Address, DateOfBirthday,EmploymentDate,Hight,Weight,role_,login_,pass_) VALUES('Стив', 'Майнкампфов','Джобс','ОР98304','Переулок Айфонова 10Х, 2 квартира ','29.10.1996','06.12.2015','180','96','detective','detective3','1234');
INSERT INTO Detective (FirstName, LastName, SurName, Passport, Address, DateOfBirthday,EmploymentDate,Hight,Weight,role_,login_,pass_) VALUES('Джеймс', 'Филлипов','Рейнор','МС99323','Зерговская 37, 13 квартира ','01.01.163','17.01.2010','172','87','detective','detective4','1234');

INSERT INTO CaseStatus (statusDescription) VALUES('На рассмотрении');
INSERT INTO CaseStatus (statusDescription) VALUES('В процессе');
INSERT INTO CaseStatus (statusDescription) VALUES('Выполнено');
INSERT INTO CaseStatus (statusDescription) VALUES('Отменено');
INSERT INTO CaseStatus (statusDescription) VALUES('Клиент умер');
INSERT INTO CaseStatus (statusDescription) VALUES('Не актуально');

INSERT INTO Cases (ClientId, DetectiveId, CaseRegistrationDate, CaseDescription, StatusId) VALUES('4', '1','13.08.2018','У меня украли козу. Зовут ее Княжна. Я ее очень люблю. Мне еажется, что во всем виноват мой сосет Жека. Верните мен мою козу.', 1);
INSERT INTO Cases (ClientId, DetectiveId, CaseRegistrationDate, CaseDescription, DateOfCseClose, StatusId) VALUES('5', '3','07.11.2018','Моя жена не ночует дома. каждый деь вечером после 18:00 куда-то пропадает и приходит толкьо под утро. Говорит, что работает, но я ей не верю. Хочу ухнать куда ходит моя жена','09.12.2018', 4);
INSERT INTO Cases (ClientId, DetectiveId, CaseRegistrationDate, CaseDescription, DateOfCseClose, StatusId) VALUES('2', '1','01.10.2019','Хочу знать где лежит заначка моего босса! Исключительно в познавательных целях...','14.10.2019', 5);
INSERT INTO Cases (ClientId, DetectiveId, CaseRegistrationDate, CaseDescription, StatusId) VALUES('3', '3','07.11.2018','Кто-то ворует мои носки. Срочно найдите их!!!', 3);
INSERT INTO Cases (ClientId, DetectiveId, CaseRegistrationDate, CaseDescription, DateOfCseClose, StatusId) VALUES('1', '5','11.12.2019','Кто то снял  клеса с моего ланоса. Вы не могли бы помочь мне найти того, кто это сделал','24.12.2019', 2);

INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Степан', 'Геогиевич','Зозуля','13.11.1983','Имеет две судимости. Не женат. Употребляет алкоголь и героин','Слесарь','190','76');
INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Артем', 'Геогиевич','Ханджи','19.11.1999','Сын депутата. В школе был отличником. Отчислили из института за то, что украл у преподавателя степлер','Бизнесмен','173','83');
INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Филлип', 'Бедросович','Киркоров','16.03.1986','Моряк.Однажды уплыл и не вернулся','Капитан','180','90');
INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Анатолий', 'Иванович','Шепелев','20.02.1963','В СССР был генеролом армии. Всю свою жизнь служил Советскому собзю. После пенсии занялся своим хозяйством','Безработный','167','86');
INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Илона', 'Сергеевна','Миронова','13.11.1983','Имеет гражданство Армении. Трехкратный олимпийский чемпион по Сумо','Консультант','160','120');
INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Парамон', 'Иринеевич','Гурьев','19.01.1956','Дагестанец','Учитель','152','79');
INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Семен', 'Рубенович','Шаров','30.06.1987','Учитель прирдоведения. Работает в шокле боьше 20 лет. Любит котиков','Учитель припродоведния','180','72');
INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Ростислав', 'Тимофеевич','Крылова','11.09.1983','Нет особенностей','Рабочий на заводе','170','95');
INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Харитон', 'Александрович','Смирнов','06.11.1893','Профессор физики. Доктор наук. Постоянно находиться в своей лабораторриии. Говорят, он там живет.','Профессор','170','90');
INSERT INTO Suspect(FirstName, LastName, SurName, DateOfBirthday, Description, Profession, Hight, Weight) VALUES('Владислав', 'Сергеевич','Бойченко','21.10.1999','Неоднократно судим за кражу ключей. Виновем во могих громких преступлениях.','Студент','180','70');

INSERT INTO Evidence( DateOfEvidenceAppearance, EvidanceUrl, DescropyionOfEvidence,EvidenceType) VALUES('13.08.2018', 'URL','Нечеткое фото загона для козы','Фото');
INSERT INTO Evidence( DateOfEvidenceAppearance, EvidanceUrl, DescropyionOfEvidence,EvidenceType) VALUES('09.11.2018', 'URL','Фото жены клиента, за рулем такси','Фото');
INSERT INTO Evidence( DateOfEvidenceAppearance, EvidanceUrl, DescropyionOfEvidence,EvidenceType) VALUES('01.11.2019', 'URL','Левый носок клиента','Другое');
INSERT INTO Evidence( DateOfEvidenceAppearance, EvidanceUrl, DescropyionOfEvidence,EvidenceType) VALUES('11.12.2019', 'URL','Четкоефото машины без колес','Фото');
INSERT INTO Evidence( DateOfEvidenceAppearance, EvidanceUrl, DescropyionOfEvidence,EvidenceType) VALUES('11.12.2019', 'URL','Запись камеры наблюдения','Видео');
INSERT INTO Evidence( DateOfEvidenceAppearance, EvidanceUrl, DescropyionOfEvidence,EvidenceType) VALUES('24.12.2019', 'URL','Объявление о продаже колес','Другое');
INSERT INTO Evidence( DateOfEvidenceAppearance, EvidanceUrl, DescropyionOfEvidence,EvidenceType) VALUES('11.11.2018', 'URL','Скриншот из приложения по заказу такси','Фото');

INSERT INTO Service( NameOfService, DescropyionOfService, ServicePrice) VALUES('Наблюдение', 'Наблюдение на протяжении суток','50');   
INSERT INTO Service( NameOfService, DescropyionOfService, ServicePrice) VALUES('Наблюдение за авто', 'Наблюдение на протяжении суток на автомобиле. Для максимальной скрытности','80');   
INSERT INTO Service( NameOfService, DescropyionOfService, ServicePrice) VALUES('Фотосъемка', 'Цена указана за каждое отдельное фото, сделанное детективом','2');   
INSERT INTO Service( NameOfService, DescropyionOfService, ServicePrice) VALUES('Расследование', 'Комплексное многоэтапное расследование дела, включащее в себя множество услуг. Указана минимальная сумма','400');   
INSERT INTO Service( NameOfService, DescropyionOfService, ServicePrice) VALUES('Информация', 'Получение информации о цели','40');   
INSERT INTO Service( NameOfService, DescropyionOfService, ServicePrice) VALUES('НЛП', 'Нейролингвистическое программирование.','300');   
INSERT INTO Service( NameOfService, DescropyionOfService, ServicePrice) VALUES('Видеосъемка', 'Видеосъемка конкретного объекта или цели зказа','120');    

INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('9', '1','Причастен');
INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('7', '1','Не причастен');  
INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('4', '1','Не виновен');  
INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('1', '4','Причастен');  
INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('3', '4','Причастен');  
INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('5', '4','Причастен');  
INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('6', '5','Не виновен');  
INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('2', '5','Не причастен');  
INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('8', '5','Не причастен');  
INSERT INTO ListOfSuspects( SuspectId, CaseId, SuspectStatus) VALUES('10', '5','Виновен');  

INSERT INTO ListOfEvidence(EvidenceId, CaseId, DateOfAdd) VALUES('1', '1','14.08.2018');  
INSERT INTO ListOfEvidence(EvidenceId, CaseId, DateOfAdd) VALUES('2', '2','09.11.2018');  
INSERT INTO ListOfEvidence(EvidenceId, CaseId, DateOfAdd) VALUES('3', '4','01.11.2019');  
INSERT INTO ListOfEvidence(EvidenceId, CaseId, DateOfAdd) VALUES('4', '5','11.12.2019');  
INSERT INTO ListOfEvidence(EvidenceId, CaseId, DateOfAdd) VALUES('5', '5','11.12.2019');  
INSERT INTO ListOfEvidence(EvidenceId, CaseId, DateOfAdd) VALUES('6', '5','25.12.2019');  
INSERT INTO ListOfEvidence(EvidenceId, CaseId, DateOfAdd) VALUES('7', '2','11.11.2018');

INSERT INTO ListOfNotes(CaseId, DateOfLastChange, DescriptionOfNote) VALUES('1','14.08.2018','Клиент говорит, что в полседнир раз видел свое животное в месте на фото. Этого странного символа, по завялени клиента, тут не было.');  
INSERT INTO ListOfNotes(CaseId, DateOfLastChange, DescriptionOfNote) VALUES('2','07.11.2018','Клиент завряет, что его жена сумашедшая. Однако у меня на этот счет другие мылси. Кажеться я ее уже где то видел...');  
INSERT INTO ListOfNotes(CaseId, DateOfLastChange, DescriptionOfNote) VALUES('2','11.11.2018','Тепрь это доказано, жена клиента и вправду работает. Причем водителем такси. Дело закрыто');  
INSERT INTO ListOfNotes(CaseId, DateOfLastChange, DescriptionOfNote) VALUES('3','2019-10-01','Клиент не отвечает на звонки. Не могу уточнить детали.');  
INSERT INTO ListOfNotes(CaseId, DateOfLastChange, DescriptionOfNote) VALUES('4','01.11.2019','Очень сложное дело. Из улик у меня имееться только левый носок. Отдам его в лабораторию.');  
INSERT INTO ListOfNotes(CaseId, DateOfLastChange, DescriptionOfNote) VALUES('5','11.12.2019','Очень не хороший поступок. У меня есть видозапись, на которой видно грабителя. Однако, лицо его скрыто. Продолжаю искать');  
INSERT INTO ListOfNotes(CaseId, DateOfLastChange, DescriptionOfNote) VALUES('5','24.12.2019','Нашел объявлени о продаже колес подозреваемым. Полиция уже задрежала его. Дело закрыто');  
      
INSERT INTO ListOfService(ServiceId, CaseId, StatusId) VALUES('4', '1', 1);
INSERT INTO ListOfService(ServiceId, CaseId, StatusId) VALUES('1', '2', 2);
INSERT INTO ListOfService(ServiceId, CaseId, StatusId) VALUES('2', '2', 1);
INSERT INTO ListOfService(ServiceId, CaseId, StatusId) VALUES('3', '2', 5);
INSERT INTO ListOfService(ServiceId, CaseId, StatusId) VALUES('4', '4', 3);
INSERT INTO ListOfService(ServiceId, CaseId, StatusId) VALUES('7', '4', 4);
INSERT INTO ListOfService(ServiceId, CaseId, StatusId) VALUES('4', '5', 2);


INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES(1, 2, 2, 2, '2021-01-25');
INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES(2, 5, 2, 3, '2021-01-26');
INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES(3, 1, 2, 5, '2021-01-25');
INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES(5, 3, 2, 3, '2021-01-25');
INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES(1, 4, 2, 2, '2021-01-04');
INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES(2, 7, 2, 3, '2021-01-22');
INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES(3, 6, 2, 5, '2021-01-24');
INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES(1, 3, 2, 4, '2021-01-18');


drop view if EXISTS user_id;
create or replace VIEW user_id as 
    select  clientid id_client, FirstName || ' ' || LastName || ' '||  SurName as client_fio from client;

drop function if EXISTS create_order;
create or replace function create_order(login_ varchar,
									   service_id int,
                                        DetectiveId int,
                                        date_meet date
									   ) RETURNS VOID AS $$
	INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES
		(
		    (select clientid from client where login_=login_),
			service_id,
            1,
            DetectiveId,
            date_meet
		);
$$ LANGUAGE SQL;



create or replace function create_user(
    FirstName VARCHAR,
	LastName VARCHAR,
    SurName VARCHAR,
	Email VARCHAR,
	Phone CHAR(13),
	DateOfBirthday DATE,
    login_ text,
    pass_ text
) RETURNS VOID AS $$

    INSERT INTO Client (FirstName, LastName,SurName,Email,Phone,DateOfBirthday,login_,pass_) 
        values (FirstName, LastName,SurName,Email,Phone,DateOfBirthday,login_,pass_);
    $$ LANGUAGE SQL;

create or replace function create_case(id_detective int,
									   service_id int,
									   meet_date date,
									   user_phone_number varchar(255),
									   user_email varchar(255),
									   description varchar(255)
									   ) RETURNS VOID AS $$
	INSERT INTO "cases"(clientid, detectiveid, caseregistrationdate, casedescription, StatusId) VALUES
		(
		 (select clientid from client 
			where email=user_email
				and phone=user_phone_number),
			id_detective, meet_date, description, 1
		);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_status(id_case int) RETURNS  TABLE
    (last_note_date date, nasme_of_service varchar(255), casedescription varchar(255), statusDescription text)
    AS $$
         select dateoflastchange, nameofservice, casedescription,  statusDescription from cases as c
            JOIN listofnotes using(caseid)
            JOIN listofservice USING(caseid)
            join service USING(serviceid)
            join CaseStatus as cs on c.StatusId = cs.StatusId
            where c.caseid =  id_case; 
    $$ LANGUAGE SQL;

create or replace function create_suspect(id_case int,
									   firstname varchar(255),
									   lastname varchar(255),
									   surname varchar(255),
									   birthday_date date,
									   description varchar(255),
									   profession varchar(255),
                                       height int,
                                       weight int,
                                       status varchar(255)
									   ) RETURNS VOID AS $$
	INSERT INTO "suspect"(firstname, lastname, surname, dateofbirthday, description, profession, hight, weight) VALUES
		(
		 firstname, lastname, surname,  birthday_date, description, profession, height, weight
		);
    INSERT INTO "listofsuspects"(suspectid, caseid, suspectstatus) VALUES (
        (SELECT max(suspectid) from "suspect"), id_case, status
    );
$$ LANGUAGE SQL;


 CREATE OR REPLACE FUNCTION remove_suspect(id_case int ,id_suspect int, new_status varchar(255)) RETURNS  VOID
    AS $$
        update listofsuspects
            set suspectstatus=new_status
                where
                    suspectid=id_suspect and caseid=id_case;
    $$ LANGUAGE SQL;

 CREATE OR REPLACE function create_note(id_case int,
									   note_date date,
									   description varchar(255)
									   ) RETURNS VOID AS $$
	INSERT INTO "listofnotes"(caseid, dateoflastchange, descriptionofnote) VALUES
		(
            id_case, note_date, description
		);
$$ LANGUAGE SQL;



drop view if EXISTS  suspect_cases;
create or replace view suspect_cases as 
    select caseid, casedescription, suspectstatus, firstname || ' ' || lastname || ' ' || surname as fio, dateofbirthday, suspectid from suspect
        JOIN listofsuspects USING(suspectid)
        JOIN cases USING(caseid);
select * from suspect_cases where suspectid = 1;


create or replace function create_evidence(id_case int,
									   evidencedate date,
									   type_evidence varchar(255),
									   url_evidence varchar(255),
                                       descrtiption varchar(255)
									   ) RETURNS VOID AS $$
	INSERT INTO "evidence"(dateofevidenceappearance, evidencetype, evidanceurl, descropyionofevidence) VALUES
		(
		 evidencedate, type_evidence, url_evidence, descrtiption
		);
    INSERT INTO "listofevidence"(evidenceid, caseid, dateofadd) VALUES (
        (SELECT max(evidenceid) from "evidence"), id_case, NOW()::date
    );
$$ LANGUAGE SQL;


drop view if EXISTS  detecitves_info;
create or replace view detecitves_info as 
    select
        detectiveid,
        firstname || ' ' || lastname || ' ' || surname as fio,
        employmentdate,
        count(*),
        passport,
        hight,
        weight,
        address,
        dateofbirthday
        FROM detective
        full join cases using(detectiveid)
    GROUP BY 1,2,3,5,6,7,8,9;
select * from detecitves_info where detectiveid = 1;

drop function if exists  owned_money;
CREATE OR REPLACE FUNCTION owned_money(begin_date date, end_date date) returns 
    table (fio varchar, tasks_amount bigint, solved_tasks bigint, moeny_amount bigint) as $$
        select firstname || ' ' || lastname || ' ' || surname, 
			(
			select count(*) from cases c where c.detectiveid= c_.detectiveid
			) as all_tasks, 
			(
			select count(*) from cases c where c.detectiveid= c_.detectiveid and dateofcseclose is not Null
			) as solved_tasks, 
			 sum(serviceprice) as owned_money
        FROM "cases" as c_
        full join  detective as d on d.detectiveid = c_.detectiveid
		full join listofservice using(caseid)
		full join service using(serviceid)
        WHERE c_.caseregistrationdate BETWEEN '2018-05-10' and now()::Date
        group by 1,c_.detectiveid;
    $$ LANGUAGE sql;


create or replace function create_detective(
									   firstname varchar(255),
									   lastname varchar(255),
									   surname varchar(255),
									   birthday_date date,
                                       detective_address varchar(255),
                                       num_passport varchar(255),
                                       height int,
                                       weight int,
                                       _login text,
                                       _pass text
									   ) RETURNS VOID AS $$
	INSERT INTO "detective"(firstname, lastname, surname, passport, address, dateofbirthday, employmentdate, hight, weight, role_, login_, pass_) VALUES
		(
		 firstname, lastname, surname, num_passport, detective_address, birthday_date, NOW()::date, height, weight, 'detective', _login, _pass
		);
    
$$ LANGUAGE SQL;





SELECT count(*) as all_tasks, count(*) OVER (
        PARTITION BY ( 
            SELECT count(*) FROM "cases" WHERE detectiveid = 3 and dateofcseclose !=NULL
            )
    )
FROM "cases" WHERE detectiveid = 3;

drop function if EXISTS dismissalDetective;
CREATE OR REPLACE FUNCTION dismissalDetective (detective_id int)
							RETURNS int
AS $$
	DECLARE newDetective int;
			
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
	
	
	
	UPDATE CASES
		SET detectiveid = newDetective
	WHERE detectiveid = detective_id;
	
	DELETE FROM Detective
	WHERE detectiveid = detective_id;
	
	RETURN newDetective;
	
END;
$$ LANGUAGE plpgSQL;

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

create or replace view suspect_info as 
    select firstname || ' ' || lastname || ' ' || surname as fio, 
		dateofbirthday,
		profession, 
		hight,
		weight
		from suspect 