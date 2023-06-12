import logging
import psycopg2
from datetime import date

#logging library is for the sake of testing

logging.basicConfig(format='%(name)s:[%(levelname)s] %(message)s',  level=logging.DEBUG)
log = logging.getLogger(__name__)
DATAPATH = "/home/thomas/Desktop/Sysad/Task1/SuperUser Mode/src/studentDetails.txt"

conn = psycopg2.connect(
    host="localhost",
    database="postgres",
    user="postgres",
    password="postgres",
    port=5432
)

cursor = conn.cursor()
log.info(f"Connected to database: {cursor}")

def initialize_tables():
    """
    Creates tables if they do not exist.
    Returns true if the tables were create from this call, 
    and false if they alreadt existed.
    """
    query = """
    CREATE TABLE IF NOT EXISTS studentdetails (
            rollno INTEGER PRIMARY KEY,
            name VARCHAR(50),
            hostel VARCHAR(15),
            room INTEGER,
            mess INTEGER,
            messpref CHAR(3),
            dept CHAR(3),
            year INTEGER
    );
    """
    cursor.execute(query)
    conn.commit()
    log.info("Created table studentdetails.")

def dept(rollno):
    first4 = rollno[:3]
    if first4 == "106":
        return "CSE"
    elif first4 == "103": 
        return "CIV"
    elif first4 == "102": 
        return "CHE"
    elif first4 == "107": 
        return "EEE"
    elif first4 == "108": 
        return "ECE"
    elif first4 == "110": 
        return "ICE"
    elif first4 == "111": 
        return "MEC"    
    elif first4 == "112": 
        return "MME"
    elif first4 == "114": 
        return "ARC"
    elif first4 == "101": 
        return "PRO"

def current_year(rollno):
    from datetime import date 
    year_ = date.today().year
    year_of_joining=int(rollno[4:6])
    output=year_-year_of_joining-2000
    return output

def insert_data():
    with open(DATAPATH) as f:
        # Skip the first line since it contains the column names
        _ = f.readline()

        for line in f:
            l = line.split()
            cursor.execute(
                "INSERT INTO studentdetails VALUES (%s, %s, %s, %s, %s, %s, %s, %s) ON CONFLICT DO NOTHING",
                (l[1], l[0], l[2], l[3], l[4], l[5], dept(str(l[1])), current_year((str(l[1]))))
            )
            conn.commit()
        
        log.info("Inserted data into table studentdetails.")
        
def view_data():
    cursor.execute("SELECT * FROM studentdetails")
    rows = cursor.fetchall()
    for row in rows:
        print(row)
    
        

initialize_tables()
insert_data()
view_data()

