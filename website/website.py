from flask import Flask, render_template, request, redirect, url_for, session
import logging
import psycopg2

logging.basicConfig(format='%(name)s:[%(levelname)s] %(message)s',  level=logging.DEBUG)
log = logging.getLogger(__name__)

conn = psycopg2.connect(
    host="db",
    database="postgres",
    user="postgres",
    password="postgres",
    port=5432
)

cursor = conn.cursor()
log.info(f"Connected to database: {cursor}")

def get_all_rows():
    cursor.execute("SELECT * FROM studentdetails")
    rows = cursor.fetchall()
    return rows

def get_hostel_rows(hostel):
    cursor.execute("SELECT * FROM studentdetails WHERE hostel = %s", (hostel,))
    rows = cursor.fetchall()
    return rows

def get_student_row(rollno):
    cursor.execute("SELECT * FROM studentdetails WHERE rollno = %s", (rollno,))
    row = cursor.fetchall()
    return row

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'GET':
        return render_template('loggin.html')
    elif request.method == 'POST':
        u = request.form['username']
        if u == "HAD":
            return render_template('details.html', username=u, rows=get_all_rows())
        elif u in ("Agate", "Opal", "GarnetA", "GarnetB"):
            return render_template('details.html', username=u, rows=get_hostel_rows(u))
        else:
            return render_template('details.html', username=u, rows=get_student_row(u))
        