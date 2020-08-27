from dotenv import load_dotenv
import os
import psycopg2
import json

load_dotenv()

DATABASE_URL = os.environ['DATABASE_URL']


def createTables():
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE users (
        user_id SERIAL PRIMARY KEY,
        user_name CHAR(100) NOT NULL,
        user_pass CHAR(100) NOT NULL
    );
    """)

    cur.execute("""
    CREATE TABLE projects (
        project_id  SERIAL PRIMARY KEY,
        user_id INT NOT NULL,
        project_name CHAR(100) NOT NULL UNIQUE,
        project_data VARCHAR,
        FOREIGN KEY (user_id) REFERENCES users(user_id)
    );
    """)

    conn.commit()

    cur.close()
    conn.close()


def getUserId(cur, user_name):
    cur.execute(f"SELECT user_id FROM users WHERE user_name='{user_name}';")
    res = cur.fetchone()
    return res[0]


def saveProject(project_data):
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    user_name = project_data["user"]
    user_id = getUserId(cur, user_name)

    project_name = project_data["project_name"]

    text_project_data = json.dumps(project_data["canvas_state"])

    cur.execute("INSERT INTO projects (user_id, project_name, project_data) VALUES (%s,%s,%s);",
                (user_id, project_name, text_project_data))


    conn.commit()
    cur.close()
    conn.close()


def getAllProjectsFromUser(user_name):
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    user_id = getUserId(cur, user_name)

    cur.execute("SELECT * FROM projects WHERE user_id=%s", (user_id,))
    res = cur.fetchall()

    projects = []

    for proj in res:
        project = {
            "user": user_name,
            "project_name": proj[2].strip(),
            "canvas_state": json.loads(proj[3])
        }
        projects.append(project)

    cur.close()
    conn.close()

    return projects

def loadProject(user_name, project_name):
    projects = getAllProjectsFromUser(user_name)

    for proj in projects:
        if proj["project_name"] == project_name:
            return proj
    
    return None

def testAddUser():
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    try:
        cur.execute("INSERT INTO users (user_name, user_pass) VALUES ('Rodrigo', '123455');")
    except psycopg2.errors.UniqueViolation:
        print("Usuário já existe")

    conn.commit()
    cur.close()
    conn.close()

project_data = {
    "user": "Rodrigo",
    "project_name": "Outro Projeto",
    "canvas_state": {
        "items": {0: "a", 1: "b"},
        "itemsPositions": {},
    },
}