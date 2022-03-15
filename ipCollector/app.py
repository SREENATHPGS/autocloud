from flask import Flask, request, jsonify
import os, multiprocessing, string, random, time, argparse, json
import logging as logger
import sqlite3

RUN_IN_DEBUG_MODE = os.environ.get('RUN_IN_DEBUG_MODE', False)
PORT = os.environ.get("PORT", 8000)
LOG_DIR = os.environ.get("LOG_DIR", "./logs")

if not os.path.isdir("./logs"):
    logger.info(f"Creating {LOG_DIR} dir")
    os.mkdir("./logs")

logger.basicConfig(level="INFO")


app=Flask(__name__)

app.secret_key="veryV#3rySc67eTkey"

global taskQueue

def getDBConnector():
    return sqlite3.connect('ipAddresses.db')

def intIPDatabase():
    DB_CONNECTION = getDBConnector()

    try:
        logger.info("DB Connection opened successfully.")
    except Exception as e:
        logger.info("Error in opening DB Connection.")
        logger.error(e)


    try:    
        DB_CONNECTION.execute('''
            CREATE TABLE IF NOT EXISTS ip_address(
                ID INT PRIMARY KEY NOT NULL,
                DEVICE_NAME TEXT NOT NULL UNIQUE,
                DEVICE_IP TEXT NOT NULL
                );
            ''')
        logger.info("Ran create table query successfully")
    except Exception as e:
        logger.info("Error in running create table query successfully")
        logger.error(e)

    DB_CONNECTION.close()

def addIPToTable(IP, device_name):
    status = False
    conn = getDBConnector()

    try:
        conn.execute(f"INSERT INTO ip_address (ID,DEVICE_NAME,DEVICE_IP) VALUES ('{getUid()}', '{device_name}', '{IP}');")
        conn.commit()
        logger.info("Records created successfully")
        status = True
    except Exception as e:
        logger.info("Adding record failed.")
        logger.error(e)

    conn.close()
    return status

def updateIPAddress(IP, device_name):
    status = False
    conn = getDBConnector()

    try:
        conn.execute(f"UPDATE ip_address set DEVICE_IP = '{IP}' where DEVICE_NAME = '{device_name}'")
        conn.commit()
        logger.info("Records created successfully")
        status = True
    except Exception as e:
        logger.info("Adding record failed.")
        logger.error(e)

    conn.close()
    return status

def getIPdata():
    conn = getDBConnector()
    cursor = None
    out = {}

    try:
        cursor = conn.execute("SELECT ID, DEVICE_NAME, DEVICE_IP from ip_address")
    except Exception as e:
        logger.info("Fetching records failed.")
        logger.error(e)
        return "Error in fetching data from database."

    for row in cursor:
        out["id"] = row[0]
        out["device_id"] = row[1]
        out["device_ip"] = row[2]

    conn.close()

    return out


def getUid(noOfCharecters=6):
    chars = string.ascii_letters + string.digits
    uid = ''.join(random.choice(chars) for n in range(noOfCharecters))
    return uid

def isValid(IP):
    def isIPv4(s):
        try: return str(int(s)) == s and 0 <= int(s) <= 255
        except: return False
        
    def isIPv6(s):
        if len(s) > 4:
           return False
        try : return int(s, 16) >= 0 and s[0] != '-'
        except:
           return False

    if IP.count(".") == 3 and all(isIPv4(i) for i in IP.split(".")):
       return True

    if IP.count(":") == 7 and all(isIPv6(i) for i in IP.split(":")):
       return True
    return False

@app.route('/', methods = ['GET'])
def stats():
    return jsonify(getIPdata())

@app.route('/health', methods = ['GET'])
def health():
    return "ok"

@app.route('/myipis', methods = ['GET'])
def addmyip():
    IP = None
    if "ip" not in request.args:
        return "IP address not given", 422
    
    if "device_id" not in request.args:
        return "device name not given", 422

    IP = request.args.get("ip")
    device_id = request.args.get("device_id")


    if isValid(IP):
        if addIPToTable(IP, device_id):
            return "IP address Saved."
        else:
            return "Failed", 500
    else:
        return "Invalid IP.", 422

@app.route('/myipis', methods = ['PATCH'])
def updatemyip():
    IP = None
    if "ip" not in request.args:
        return "IP address not given", 422

    if "device_id" not in request.args:
        return "device name not given", 422

    IP = request.args.get("ip")
    device_id = request.args.get("device_id")

    if isValid(IP):
        if updateIPAddress(IP, device_id):
            return "IP address Updated."
        else:
            return "Failed", 500

    else:
        return "Invalid IP.", 422

def queueMonitor():

    while True:
        if not taskQueue.empty():
            print("Found a task.")
            try:
                task = taskQueue.get()
            except Exception as e:
                pass
        else:
            time.sleep(0.1)


if __name__ == '__main__':

    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--PORT', help = "port to run", default = PORT)
    args = parser.parse_args()

    manager = multiprocessing.Manager()
    taskQueue = manager.Queue()

    queueMonitor = multiprocessing.Process(name = "queueMonitor", target = queueMonitor)

    print("Starting queue monitor.")
    # queueMonitor.start()

    intIPDatabase()
    app.run(debug=True, host='0.0.0.0', port=args.PORT)
    
