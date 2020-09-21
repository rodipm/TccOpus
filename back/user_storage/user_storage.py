from dotenv import load_dotenv
import os
import psycopg2
import json
import hashlib

load_dotenv()

DATABASE_URL = os.environ['DATABASE_URL']

def createTables():
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE client (
        id SERIAL PRIMARY KEY,
        email CHAR(100) UNIQUE,
        pass VARCHAR NOT NULL,
        salt VARCHAR NOT NULL
    );
    """)

    cur.execute("""
    CREATE TABLE project (
        id  SERIAL PRIMARY KEY,
        client_id INT NOT NULL,
        name VARCHAR NOT NULL,
        canvas_state VARCHAR,
        type VARCHAR,
        FOREIGN KEY (client_id) REFERENCES client(id)
    );
    """)


    conn.commit()

    cur.close()
    conn.close()
    print("Tables create")


def clientLogin(email, password):
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    cur.execute("SELECT * FROM client WHERE email=%s;", (email, ))
    res = cur.fetchone()

    if res == None:
        return False

    clientHashedPass = bytes.fromhex(res[2])
    clientSalt = bytes.fromhex(res[3])

    print(clientHashedPass)
    print(clientSalt)
    verifyHash = hashlib.pbkdf2_hmac(
        'sha256',
        password.encode('utf-8'),
        clientSalt,
        100000
    )

    print(verifyHash)

    if verifyHash == clientHashedPass:
        return True
    else:
        return False


def addClient(email, password):
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    cur = conn.cursor()

    salt = os.urandom(32)

    hashed_pass = hashlib.pbkdf2_hmac(
        'sha256',
        password.encode('utf-8'),
        salt,
        100000
    )

    hex_str_salt = salt.hex()
    hex_str_hashed_pass = hashed_pass.hex()

    try:
        cur.execute(
            "INSERT INTO client (email, pass, salt) VALUES (%s, %s, %s);", (email, hex_str_hashed_pass, hex_str_salt))
        conn.commit()
        cur.close()
        conn.close()
        return True

    except psycopg2.errors.UniqueViolation:
        cur.close()
        conn.close()
        return False
