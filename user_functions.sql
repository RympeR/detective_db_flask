create or replace function create_order(id_detective int,
									   service_id int,
									   meet_date date,
									   user_phone_number varchar(255),
									   user_email varchar(255),
									   description varchar(255)
									   ) RETURNS VOID AS $$
	INSERT INTO "cases"(clientid, detectiveid, caseregistrationdate, casedescription) VALUES
		(
		 (select clientid from client 
			where email=user_email
				and phone=user_phone_number),
			id_detective, meet_date, description
		);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_status(id_case int) RETURNS  TABLE
    (last_note_date date, nasme_of_service varchar(255), casedescription varchar(255))
    AS $$
         select dateoflastchange, nameofservice, casedescription from cases
            JOIN listofnotes using(caseid)
            JOIN listofservice USING(caseid)
            join service USING(serviceid)
            where cases.caseid =  id_case; 
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
        firstname || ' ' || lastname || ' ' || surname as fio,
        employmentdate,
        count(*),
        passport,
        hight,
        weight,
        address,
        dateofbirthday,
        detectiveid
        FROM detective
        join cases using(detectiveid)
    GROUP BY 1,2,4,5,6,7,8,9;
select * from detecitves_info where detectiveid = 1;

UPDATE cases
    set case_status = status
    WHERE caseid = id_case;

create or replace function create_detective(
									   firstname varchar(255),
									   lastname varchar(255),
									   surname varchar(255),
									   birthday_date date,
                                       detective_address varchar(255),
                                       num_passport varchar(255),
                                       height int,
                                       weight int
									   ) RETURNS VOID AS $$
	INSERT INTO "detective"(firstname, lastname, surname, passport, address, dateofbirthday, employmentdate, hight, weight) VALUES
		(
		 firstname, lastname, surname, num_passport, detective_address, birthday_date, NOW()::date, height, weight
		);
    
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION owned_money(begin_date date, end_date date) returns 
    table (fio varchar, tasks_amount bigint, solved_tasks bigint) as $$
        select firstname || ' ' || lastname || ' ' || surname, count(*) as all_tasks, count(*) OVER (
                        PARTITION BY ( 
                            SELECT count(*) FROM "cases" as c  WHERE dateofcseclose !=NULL
                            )
                    )
        FROM "cases" as c_
        join  detective as d on d.detectiveid = c_.detectiveid
        WHERE c_.caseregistrationdate BETWEEN begin_date and end_date
        group by 1;
    $$ LANGUAGE sql;

    