from flask import Flask, render_template, url_for, redirect, request, session, flash, get_flashed_messages, abort
from model import *


app = Flask(__name__)
app.secret_key = 'somesecretkeythatonlyishouldknow'
session_variables = []
role = 'detective_guest:guest'

def where_add(query):
    if 'where' not in query:
        query+='\nwhere'
    return query

def add_and_case(request, query, param_name, field_name, empty=False, str_=True):
    if empty:
        if request.form[param_name] != 'empty':
            query = where_add(query)
            param=request.form[param_name]
            if query.split('\n')[-1].strip()!='where':
                if str_:
                    query +=f"\nand {field_name}= '{param}'"
                else:
                    query +=f"\nand {field_name}= {param}"
            else:
                if str_:
                    query +=f"\n{field_name}= '{param}'"
                else:
                    query +=f"\n{field_name}= {param}"
    else:
        if request.form[param_name] != '':
            query = where_add(query)
            param=request.form[param_name]
            if query.split('\n')[-1].strip()!='where':
                if str_:
                    query +=f"\nand {field_name}= '{param}'"
                else:
                    query +=f"\nand {field_name}= {param}"
            else:
                if str_:
                    query +=f"\n{field_name}= '{param}'"
                else:
                    query +=f"\n{field_name}= {param}"
    return query
                
def get_suspects(request, login, password):
    try:
        query = '''select fio, 
		dateofbirthday,
		profession, 
		hight,
		weight
		from suspect_info'''
        query = add_and_case(request, query, 'fio', 'fio')
        query = add_and_case(request, query, 'dateofbirthday', 'dateofbirthday')
        query = add_and_case(request, query, 'profession', 'profession')
        query = add_and_case(request, query, 'hight', 'hight', str_=False)
        query = add_and_case(request, query, 'weight', 'weight', str_=False)
        query+=';'
        print(query)
        result = execute_select_query(login, password, query)
        
    except Exception as e:
        print(e)
        query = '''select fio, 
                    dateofbirthday,
                    profession, 
                    hight,
                    weight
                    from suspect_info;    
                '''
        result = execute_select_query(login, password, query)
    return result

def loadSession(role):
    engine = create_engine(
        f'postgres+psycopg2://{role}@localhost:5432/detective_db', convert_unicode=True)
    # metadata = MetaData()
    db_session = scoped_session(sessionmaker(
        autocommit=False,  autoflush=False, bind=engine))
    metadata = db.metadata
    session_variables.append(engine)
    session_variables.append(db_session)
    session_variables.append(metadata)
    Session = sessionmaker(bind=engine)
    session_ = Session()
    return session_


def shutdown_session(exception=None):
    global session_variables
    session_variables[1].remove()

# --------------404 PAGE------------------
@app.errorhandler(404)
def pageNotFound(error):
    return "<h1>You got 404 mistake please get on correct url adres</h1>"
# ---------------------------------------

# ------------------------LOGIN----------------------------
@app.route('/login', methods=['POST', 'GET'])
def login():
    global role

    print('############')
    print(session)
    print('############')
    if 'login' and 'username' in session:
        if session['login'] == 'detective':
            try:
                shutdown_session()
            except Exception as e:
                pass
            role = 'detective_staff:staff'
            return redirect(url_for('staff', username=session['username']))
        elif session['login'] == 'director':
            try:
                shutdown_session()
            except Exception as e:
                pass
            role = 'detective_director:director'
            return redirect(url_for('director', username=session['username']))
        elif session['login']:
            try:
                shutdown_session()
            except Exception as e:
                pass
            role = 'detective_client:client'
            return redirect(url_for('client', username=session['username']))

    if request.method == 'POST':
        username = request.form["username"]
        password = request.form['password']
        session_ = loadSession('detective_guest:guest')
        query = f"SELECT role_ FROM detective WHERE login_ = '{username}' AND pass_ = '{password}' ;"
        print(query)
        try:
            session['login'] = execute_select_query('detective_guest', 'guest', query,f_all=False)[0].replace('\n','')
            print(session['login'])
        except Exception as e:
            print(e)
            try:
                query = f"SELECT clientid FROM client WHERE login_ = '{username}' AND pass_ = '{password}' ;"
                print(query)
                session['login'] = session_.execute(query).fetchone()[0]
                print(session['login'])
                if session['login'] > 0:
                    session['username'] = username
                    role = 'detective_client:client'
                    return redirect(url_for('client', username=session['username']))
            except Exception as e:
                print(e)
                shutdown_session()
                flash("Неверный логин или пароль")
                return render_template('Registration.html')
            # return f"{e}"

        if session['login'] == 'detective':
            try:
                shutdown_session()
            except Exception as e:
                pass
            session['username'] = username
            role = 'detective_staff:staff'
            return redirect(url_for('staff', username=session['username']))
        elif session['login'] == 'director':
            try:
                shutdown_session()
            except Exception as e:
                pass
            session['username'] = username
            role = 'detective_director:director'
            return redirect(url_for('director', username=session['username']))
        elif session['login'] == 'client':
            try:
                shutdown_session()
            except Exception as e:
                pass
            session['username'] = username
            role = 'detective_client:client'
            return redirect(url_for('client', username=session['username']))
        else:
            flash("Неверный логин или пароль")
            return render_template('Registration.html')

    return render_template('Registration.html')

@app.route('/register', methods=['POST', 'GET'])
def register():
    if 'login' and 'username' in session:
        if session['login'] == 'staff':
            try:
                shutdown_session()
            except Exception as e:
                pass
            role = 'detective_staff:staff'
            return redirect(url_for('staff', username=session['username']))
        elif session['login'] == 'director':
            try:
                shutdown_session()
            except Exception as e:
                pass
            role = 'detective_director:director'
            return redirect(url_for('director', username=session['username']))
        elif session['login']:
            try:
                shutdown_session()
            except Exception as e:
                pass
            role = 'detective_client:client'
            return redirect(url_for('client', username=session['username']))
    if request.method == 'POST':
        firstname = request.form["firstname"]
        lastname = request.form["lastname"]
        surname = request.form["surname"]
        phonenumber = request.form["phonenumber"]
        email = request.form["email"]
        birthday = request.form["birthday"]
        username = request.form["username"]
        password = request.form['password']
        session_ = loadSession('detective_guest:guest')
        query = f"""
            select * FROM create_user('{firstname}','{lastname}','{surname}','{email}','{phonenumber}','{birthday}','{username}','{password}');
        """
        print(query)
        try:
            execute_query('detective_guest', 'guest', query)
            session['login'] = 'detective_client'
            session['username'] = username
            return redirect(url_for('client', username=session['username']))
        except Exception as e:
            print(e)
            flash('Такой логин уже есть')
    return render_template('register_page.html')

@app.route('/logout', methods=['POST', 'GET'])
def logout():
    try:
        shutdown_session()
    except Exception as e:
        pass
    try:
        del session['login']
    except Exception as e:
        pass
    try:
        del session['username']
    except Exception as e:
        pass
    print(session)
    return redirect(url_for('login'))

# -------------------------------------------------------------------

@app.route('/director/<username>', methods=['GET'])
def director(username):
    global role
    if 'username' not in session or session['username'] != username:
        abort(401)
    role = "detective_director:director"
    session_ = loadSession(role)
    data1 = session_.execute("SELECT * from detective WHERE role_='director';")
    data1 = data1.first()
    print(data1)
    return render_template('director.html', dirstaff=data1, username=session['username'])

@app.route('/director/get_detective_list/<username>/', methods=['POST', 'GET'])
def directorGetDetectiveList(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    data=execute_select_query(
        'detective_director',
        'director',
        'SELECT * FROM detecitves_info;'
    )
    return render_template(
        'get_detective_list.html',
        data=data,
        username=session['username']
    )
@app.route('/director/accept_detective/<username>/', methods=['POST', 'GET'])
def directorAcceptDetective(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    if request.method == 'POST':
        firstname = request.form["firstname"]
        lastname = request.form["lastname"]
        surname = request.form["surname"]
        birthday_date = request.form["birthday_date"]
        detective_address = request.form["detective_address"]
        num_passport = request.form["num_passport"]
        height = request.form["height"]
        weight = request.form["weight"]
        _login = request.form["_login"]
        passw = request.form["passw"]
        data=execute_query(
            'detective_director',
            'director',
            f'''SELECT * FROM create_detective(
                '{firstname}',
                '{lastname}',
                '{surname}',
                '{birthday_date}',
                '{detective_address}',
                '{num_passport}',
                {height},
                {weight},
                '{_login}',
                '{passw}'
            );'''
        )
    return render_template(
        'accept_detective.html',
        username=session['username']
    )
@app.route('/director/remove_staff/<username>/', methods=['POST', 'GET'])
def directorRemoveStaff(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    staff = execute_select_query(
        'detective_staff',
        'staff',
        'SELECT * FROM detecitves_info;'
    )
    if request.method == 'POST':
        detective_id = request.form["detective_id"]
        data=execute_query(
            'detective_director',
            'director',
            f'SELECT * FROM dismissalDetective({detective_id});'
        )
    return render_template(
        'remove_staff.html',
        staff=staff,
        username=session['username']
    )
@app.route('/director/change_service_price/<username>/', methods=['POST', 'GET'])
def directorChangeServicePrice(username):
    if 'username' not in session or session['username'] != username:
        abort(401)

    service = execute_select_query(
        'detective_staff',
        'staff',
        'SELECT * FROM service;'
    )
    if request.method == 'POST':
        service_id = request.form["service_id"]
        new_price = request.form["new_price"]
        data=execute_query(
            'detective_director',
            'director',
            f'''UPDATE "service"
                    set
                        serviceprice = {new_price}
                    where
                        service_id = {service_id};'''
        )
    return render_template(
        'change_service_price.html',
        services=service,
        username=session['username']
    )
@app.route('/director/add_service/<username>/', methods=['POST', 'GET'])
def directorAddService(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    if request.method == 'POST':
        nameofservice = request.form["nameofservice"]
        descropyionofservice = request.form["descropyionofservice"]
        serviceprice = request.form["serviceprice"]
        data=execute_query(
            'detective_director',
            'director',
            f'''
                INSERT INTO "service"(nameofservice, descropyionofservice, serviceprice) VALUES
                    ('{nameofservice}', '{descropyionofservice}', {serviceprice});
                '''
        )
    return render_template(
        'add_service.html',
        username=session['username']
    )
@app.route('/director/regular_clients/<username>/', methods=['POST', 'GET'])
def directorRegularClients(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    data=''
    if request.method == 'POST':
        begindate = request.form["begin_date"]
        enddate = request.form["end_date"]
        data=execute_select_query(
            'detective_director',
            'director',
            f'''	
                select    cl.firstname || ' ' || cl.lastname || ' ' || cl.surname as fio, c.caseregistrationdate, count(*)
                from client as cl
                join cases c using(clientid)
                left join listofservice using(caseid)
                left join service using(serviceid)
                where c.caseregistrationdate between '{begindate}' and '{enddate}'
                group by 1, 2
				order by 3 desc 
		'''
        )
    return render_template(
        'regular_clients.html',
        data=data,
        username=session['username']
    )
@app.route('/director/detective_tasks/<username>/', methods=['POST', 'GET'])
def directorDetectiveTasks(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    data=''
    staff = execute_select_query(
        'detective_staff',
        'staff',
        'SELECT * FROM detecitves_info;'
    )
    if request.method == 'POST':
        detectiveid = request.form["detectiveid"]
        data=execute_select_query(
            'detective_director',
            'director',
            f'''SELECT count(*) as all_tasks, count(*) OVER (
                        PARTITION BY ( 
                            SELECT count(*) FROM "cases" WHERE detectiveid = {detectiveid} and dateofcseclose !=NULL
                            )
                    )
                FROM "cases" WHERE detectiveid = {detectiveid};'''
        )
    return render_template(
        'detective_tasks.html',
        data=data,
        staff=staff,
        username=session['username']
    )
@app.route('/director/payment_statistics/<username>/', methods=['POST', 'GET'])
def directorStatistics(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    data=''
    if request.method == 'POST':
        begindate = request.form["begindate"]
        enddate = request.form["enddate"]
        print(begindate)
        data=execute_select_query(
            'detective_director',
            'director',
            f'''select * from owned_money('{begindate}', '{enddate}');'''
        )
    return render_template(
        'payment_statistics.html',
        data=data,
        username=session['username']
    )


#------------------------CLIENT-------------------------------
@app.route('/client/<username>')
def client(username):
    if 'username' not in session or session['username'] != username:
        abort(401)

    session_ = loadSession('detective_client:client')
    data1 = session_.execute(f"SELECT * from client WHERE login_='{username}';")
    data1 = data1.first()
    print(data1)
    return render_template('client.html', dirstaff=data1, username=session['username'])

@app.route('/client/make_order/<username>/', methods=['POST', 'GET'])
def clientMakeOrder(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    staff = execute_select_query(
        'detective_staff',
        'staff',
        'SELECT * FROM detecitves_info;'
    )
    service = execute_select_query(
        'detective_staff',
        'staff',
        'SELECT * FROM service;'
    )
    if request.method == 'POST':
        service_id = request.form["service_id"]
        detective_id = request.form["detective_id"]
        date_meet = request.form["date_meet"]
        query = f"""INSERT INTO ServiceOrder(ClientId, ServiceId, StatusId, DetectiveId, meet_date) VALUES(
                                    (select clientid from client where login_='{session["username"]}'),
                                            {service_id},
                                            1,
                                            {detective_id},
                                            '{date_meet}');"""
        data = execute_query(
            'detective_client',
            'client',
            query
            )
    return render_template(
        'client_make_order.html',
        services=service,
        staff=staff,
        username=session['username']
    )

@app.route('/client/get_case_status/<username>/', methods=['POST', 'GET'])
def clientGetCaseStatus(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    data=''
    orders = execute_select_query(
        'detective_client',
        'client',
        f'''
            select caseid, casedescription from cases
            join client using(clientid)
            where login_='{username}';
        ''')
    print(orders)
    if request.method == 'POST':
        order_id = request.form["order_id"]
        data = execute_select_query(
            'detective_staff',
            'staff',
            f"""SELECT * FROM get_status({order_id});"""
        )
    return render_template(
        'client_status_check.html',
        data=data,
        orders=orders,
        username=session['username']
    )
#-------------------------------------------------------------

#------------------------DETECTIVE------------------------------
@app.route('/detective/<username>')
def staff(username):
    if 'username' not in session or session['username'] != username:
        abort(401)

    session_ = loadSession('detective_staff:staff')
    data1 = session_.execute(f"SELECT * from detective WHERE login_='{username}';")
    data1 = data1.first()
    print(data1)
    return render_template('detective.html', dirstaff=data1, username=session['username'])

@app.route('/detective/add-suspect/<username>/', methods=['POST', 'GET'])
def detectiveGetListSuspects(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    cases = execute_select_query(
            'detective_staff',
            'staff',
            f"""SELECT caseid, casedescription FROM cases;"""
    )
    if request.method == 'POST':
        id_case = request.form["id_case"]
        firstname = request.form["firstname"]
        lastname = request.form["lastname"]
        surname = request.form["surname"]
        birthday_date = request.form["birthday_date"]
        description = request.form["description"]
        profession = request.form["profession"]
        height = request.form["height"]
        weight = request.form["weight"]
        status = request.form["status"]
        data = execute_query(
            'detective_staff',
            'staff',
            f"""SELECT * FROM create_suspect(
                {id_case},
                '{firstname}',
                '{lastname}',
                '{surname}',
                '{birthday_date}',
                '{description}',
                '{profession}',
                {height},
                {weight},
                '{status}',
            );"""
        )
    return render_template(
        'addSuspect.html',
        cases=cases,
        username=session['username']
    )
@app.route('/detective/remove-suspect/<username>/', methods=['POST', 'GET'])
def detectiveRemoveSuspect(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    suspect = execute_select_query(
            'detective_staff',
            'staff',
            f"""SELECT distinct suspectid, fio FROM suspect_cases;"""
    )
    cases = execute_select_query(
            'detective_staff',
            'staff',
            f"""SELECT caseid, casedescription FROM cases;"""
    )
    if request.method == 'POST':
        new_status = request.form["new_status"]
        id_case = request.form["id_case"]
        id_suspect = request.form["id_suspect"]
        data = execute_query(
            'detective_staff',
            'staff',
            f"""SELECT * FROM remove_suspect({id_case}, {id_suspect},{new_status});"""
        )
    return render_template(
        'removeSuspect.html',
        suspects=suspect,
        cases=cases,
        username=session['username']
    )
@app.route('/detective/create-case/<username>/', methods=['POST', 'GET'])
def detectiveCreateCase(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    service = execute_select_query(
        'detective_staff',
        'staff',
        'SELECT * FROM service;'
    )
    staff = execute_select_query(
        'detective_staff',
        'staff',
        'SELECT * FROM detecitves_info;'
    )
    if request.method == 'POST':
        id_detective = request.form["id_detective"]
        service_id = request.form["service_id"]
        meet_date = request.form["meet_date"]
        user_phone_number = request.form["user_phone_number"]
        user_email = request.form["user_email"]
        description = request.form["description"]
        data = execute_query(
            'detective_staff',
            'staff',
            f"""SELECT * FROM create_case(
                {id_detective},
                {service_id},
                '{meet_date},'
                '{user_phone_number},'
                '{user_email},'
                '{description}'
            );"""
        )
    return render_template(
        'createCase.html',
        services=service,
        staff=staff,
        username=session['username']
    )

@app.route('/detective/add-note/<username>/', methods=['POST', 'GET'])
def detectiveAddNote(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    cases = execute_select_query(
            'detective_staff',
            'staff',
            f"""SELECT caseid, casedescription FROM cases;"""
    )
    if request.method == 'POST':
        id_case = request.form["id_case"]
        note_date = request.form["note_date"]
        description = request.form["description"]
        data = execute_query(
            'detective_staff',
            'staff',
            f"""SELECT * FROM create_note(
                {id_case},
                '{note_date}',
                '{description}'
                );"""
        )
    return render_template(
        'addNote.html',
        cases=cases,
        username=session['username']
    )

@app.route('/detective/close-case/<username>/', methods=['POST', 'GET'])
def detectiveCloseCase(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    cases = execute_select_query(
            'detective_staff',
            'staff',
            """SELECT caseid, casedescription FROM cases;"""
    )
    status = execute_select_query(
            'detective_staff',
            'staff',
            """SELECT caseid, casedescription FROM casestatus;"""
    )
    if request.method == 'POST':
        idstatus = request.form["id_status"]
        id_case = request.form["id_case"]
        data = execute_query(
            'detective_staff',
            'staff',
            f"""UPDATE cases
                    set
                        StatusId = {idstatus}
                        WHERE
                            caseid={id_case};
                        """
        )
    return render_template(
        'close-case.html',
        cases=cases,
        statuses=status,
        username=session['username']
    )
@app.route('/detective/add-evidence/<username>/', methods=['POST', 'GET'])
def detectiveAddEvidence(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    cases = execute_select_query(
            'detective_staff',
            'staff',
            f"""SELECT caseid, casedescription FROM cases;"""
    )
    if request.method == 'POST':
        id_case = request.form["id_case"]
        evidencedate = request.form["evidencedate"]
        type_evidence = request.form["type_evidence"]
        url_evidence = request.form["url_evidence"]
        description = request.form["description"]
        data = execute_query(
            'detective_staff',
            'staff',
            f"""SELECT * FROM create_evidence(
                {id_case},
                '{evidencedate}',
                '{type_evidence}',
                '{url_evidence}',
                '{description}'
                );"""
        )
    return render_template(
        'addEvidence.html',
        cases=cases,
        username=session['username']
    )
@app.route('/detective/search-suspects/<username>/', methods=['POST', 'GET'])
def detectiveearchSuspects(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    data = get_suspects(request, 'detective_staff', 'staff')
    if request.method == 'POST':
        data = get_suspects(request, 'detective_staff', 'staff')

    return render_template(
        'suspects.html',
        data=data,
        username=session['username']
    )
@app.route('/detective/check-suspect/<username>/', methods=['POST', 'GET'])
def detectiveCheckSuspect(username):
    if 'username' not in session or session['username'] != username:
        abort(401)
    data=''
    suspect = execute_select_query(
            'detective_staff',
            'staff',
            f"""SELECT * FROM suspect_cases;"""
        )
    if request.method == 'POST':
        suspect_id = request.form["suspect_id"]
        if suspect_id == 'empty':
            data = execute_select_query(
                'detective_staff',
                'staff',
                f"""select * from suspect_cases;"""
            )
        else:
            data = execute_select_query(
                'detective_staff',
                'staff',
                f"""select * from suspect_cases where suspectid={suspect_id};"""
            )
    return render_template(
        'check-suspect.html',
        suspects=suspect,
        data=data,
        username=session['username'])

#-------------------------------------------------------------


# --------------------------BASE PAGES-------------------------------
@app.route('/home')
@app.route('/')
def home():
    return render_template('detective_main.html')


if __name__ == "__main__":
    app.run(debug=True)
