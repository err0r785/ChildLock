from flask import Flask, request, jsonify
from model.ai_model import XGB_model_predict
import pymysql
import smtplib
import socket

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from datetime import datetime
import tldextract

app = Flask(__name__)

SERVER_IP = None

def get_base_domain(url):
    ext = tldextract.extract(url)
    return f"{ext.domain}.{ext.suffix}"

def get_server_ip():
    global SERVER_IP
    if SERVER_IP:
        return SERVER_IP

    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        SERVER_IP = s.getsockname()[0]
        s.close()
    except Exception:
        SERVER_IP = "127.0.0.1"

    return SERVER_IP

def send_email(to_email, subject, body):
    """SMTP를 사용하여 보호자에게 HTML 이메일 전송"""
    try:
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(SMTP_USER, SMTP_PASSWORD)

        msg = MIMEMultipart()
        msg["From"] = SMTP_USER
        msg["To"] = to_email
        msg["Subject"] = subject
        msg.attach(MIMEText(body, "html"))

        server.sendmail(SMTP_USER, to_email, msg.as_string())
        server.quit()
        print(f"📩 보호자({to_email})에게 경고 이메일 전송 완료")

    except Exception as e:
        print(f"❌ 이메일 전송 실패: {e}")

def get_db_connection():
    return pymysql.connect(
        host='project-db-cgi.smhrd.com',
        port=3307,
        user='KTEAM',
        password='1234',
        db='KTEAM',
        charset='utf8',
        cursorclass=pymysql.cursors.DictCursor
    )

# ✅ 보호자 이메일 조회
def get_parent_email(user_email):
    db = get_db_connection()
    cursor = db.cursor()
    sql = "SELECT parent_email FROM user_info WHERE user_email = %s"
    cursor.execute(sql, (user_email,))
    result = cursor.fetchone()
    cursor.close()
    db.close()
    return result['parent_email'] if result else None

# ✅ 클라이언트 IP 가져오기
def get_client_ip():
    client_ip = request.headers.get("X-Forwarded-For")
    if client_ip:
        return client_ip.split(",")[0].strip()
    return request.remote_addr

# ✅ 현재 시간 포맷 변경 (2025년 03월 20일 12시 33분)
def get_formatted_time():
    return datetime.now().strftime("%Y년 %m월 %d일 %H시 %M분")

# ✅ SMTP 이메일 발송 설정
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
SMTP_USER = "smhrd27@gmail.com"  # 📌 발신 이메일 (변경 필요)
SMTP_PASSWORD = "vudw knpc wmzo ebtm"  # 📌 Gmail 앱 비밀번호 (변경 필요)

def check_block(domain, email):
    # MySQL 데이터베이스 연결
    db = pymysql.connect(
        host='project-db-cgi.smhrd.com',
        port=3307,
        user='KTEAM',
        password='1234',
        db='KTEAM',
        charset='utf8'
    )

    cursor = db.cursor()

    # self_block_info에서 검색
    sql = "SELECT * FROM self_block_info WHERE user_email = %s AND sb_url = %s"
    cursor.execute(sql, (email, domain))
    result = cursor.fetchall()

    # 결과가 없으면 parent_block_info와 user_info 조인하여 검색
    if not result:
        sql = (
            "SELECT * FROM parent_block_info b "
            "JOIN user_info u ON b.user_email = u.parent_email "
            "WHERE u.user_email = %s AND b.pb_url = %s"
        )
        cursor.execute(sql, (email, domain))
        result = cursor.fetchall()

    cursor.close()
    db.close()

    return result  # 모든 행 반환

def check_db(domain):
    # MySQL 데이터베이스 연결
    db = pymysql.connect(
        host='project-db-cgi.smhrd.com',
        port=3307,
        user='KTEAM',
        password='1234',
        db='KTEAM',
        charset='utf8'
    )

    cursor = db.cursor()

    # self_block_info에서 검색
    sql = "SELECT url_type FROM urls_info WHERE url_link = %s"
    cursor.execute(sql, (domain,))
    result = cursor.fetchall()

    cursor.close()
    db.close()

    return result 


@app.route('/over/predict', methods=['GET', 'POST'])
def bert_predict_over():
    if request.method == 'GET':
        return jsonify({"message": "Use POST method with JSON data"}), 200

    data = request.json  # JSON 형식으로 데이터를 받음
    domain = data.get('domain')
    domain = get_base_domain(domain)
    print("domain:", domain)
    url = data.get('url')

    if not url:
        return jsonify({"error": "URL is required"}), 400

    check = check_db(domain)
    if not check:
        # AI 예측
        aaa, score = XGB_model_predict(url)

        # 예측 결과 반환
        result = {
            "url": url,
            "aaa": [aaa],
            "score": score
        }
        print("pred:", result)
    else:
        result = {
            "url": url,
            "aaa": [check[0][0]],
            "score": 1.0
        }
    print(result)


    return jsonify(result), 200

@app.route('/click/predict', methods=['POST'])
def bert_predict_click():
    data = request.json  # JSON 형식으로 데이터를 받음
    url = data.get('url')
    domain = data.get('domain')
    domain = get_base_domain(domain)
    email = data.get('userEmail')
    
    if not url:
        return jsonify({"error": "URL is required"}), 400

    block = check_block(domain, email)
    print(block)

    # 차단 유무 확인
    if not block:
        # DB확인
        check = check_db(domain)
        if not check:
            # AI 예측
            aaa, score = XGB_model_predict(url)

            # 예측 결과 반환
            result = {
                "url": url,
                "aaa": [aaa],
                "score": score
            }
            print("pred:", result)
        else:
            result = {
                "url": url,
                "aaa": [check[0][0]]
            }
            print(result)
    else:
        result = {
            "url": url,
            "aaa": ["block"]
        }

    # ✅ 보호자에게 경고 메일 전송
    if result["aaa"][0] in ["malware", "phishing", "defacement"]:
        print("------------------메일 발송-------------------")
        # Flask 내부 함수 활용
        parent_email = get_parent_email(email)
        access_time = get_formatted_time()
        client_ip = get_server_ip()
        print(email)
        print("parent-", parent_email)
        print("access", access_time)
        print("ip", client_ip)
        subject = "🚨 자녀의 위험한 웹사이트 접속 경고!"
        message = f"""
        <html>
        <body>
            <h2 style='color:red;'>🚨 자녀의 위험한 사이트 접속 경고!</h2>
            <p>안녕하세요, 보호자님.</p>
            <p>자녀 <b>{email}</b>이(가) 위험한 웹사이트에 접속하였습니다.</p>
            <p>📌 <b>접속한 URL:</b> <a href='{url}' target='_blank'>{url}</a></p>
            <p>⚠️ <b>위협 유형:</b> <span style='color:red;'>{result["aaa"][0]}</span></p>
            <p>🕒 <b>접속 시간:</b> {access_time}</p>
            <p>🌍 <b>접속 IP:</b> {client_ip}</p>
            <p style='color:red;'>❗ 즉시 조치가 필요합니다.</p>
            <p>감사합니다.</p>
        </body>
        </html>
        """

        if parent_email is not None:
            send_email(parent_email, subject, message)

    return jsonify(result), 200

# 오류 처리 (예: 잘못된 경로)
@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Not Found"}), 404

# 서버 실행
if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)


