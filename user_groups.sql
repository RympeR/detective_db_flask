CREATE USER detective_developer WITH LOGIN CREATEROLE PASSWORD 'developer';
CREATE USER detective_director WITH LOGIN CREATEROLE PASSWORD 'director';
CREATE USER detective_staff WITH LOGIN  PASSWORD 'staff';
CREATE USER detective_client WITH LOGIN  PASSWORD 'client';
CREATE USER detective_guest WITH LOGIN  PASSWORD 'guest';


REVOKE ALL on DATABASE detective_db FROM detective_developer;
REVOKE ALL ON SCHEMA public FROM detective_developer;

REVOKE CREATE ON SCHEMA public FROM public;
REVOKE ALL ON DATABASE detective_db FROM public;

grant all PRIVILEGES on schema public to detective_developer;
grant all PRIVILEGES on schema public to detective_director;


GRANT CREATE ON SCHEMA public to detective_developer;

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public
TO detective_developer;
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public
TO detective_director;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO detective_developer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO detective_director;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO detective_staff;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO detective_guest;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO detective_client;

GRANT CONNECT ON DATABASE detective_db to detective_developer;
GRANT CONNECT ON DATABASE detective_db to detective_director;
GRANT CONNECT ON DATABASE detective_db to detective_staff;
GRANT CONNECT ON DATABASE detective_db to detective_client;
GRANT CONNECT ON DATABASE detective_db to detective_guest;

grant SELECT(role_, login_, pass_) ON TABLE Detective
to detective_guest;

grant select on Client to detective_staff;

grant SELECT(ClientId, login_, pass_) , INSERT ON TABLE client
to detective_guest;


GRANT SELECT ON TABLE 
    public.service,
	public.cleint,
    public.cases
    TO detective_client;

GRANT SELECT, INSERT, REFERENCES ON TABLE
	public.ServiceOrder, 
	public.client
	TO detective_client;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE 
	public.client,
	public.service,
	public.suspect,
	public.listofsuspects,
	public.evidence,
    public.ListOfEvidence,
    public.cases,
    public.listofnotes,
    public.CaseStatus,
    public.listofservice
	TO detective_staff;

GRANT SELECT ON TABLE
	public.detective
	TO detective_staff; 

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO detective_staff;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO detective_client;



grant SELECT, INSERT, UPDATE, DELETE ON TABLE client
to detective_guest;

GRANT select on TABLE
	public.user_id,
	public.suspect_cases,
	public.suspect_info,
	public.detecitves_info 
	to detective_staff;