import joblib
from urllib.parse import urlparse
from tld import get_tld
import hashlib
import re
import numpy as np
import os

import pandas as pd
import numpy as np
#from autoviz.classify_method import data_cleaning_suggestions ,data_suggestions
#from pycaret import regression

# 모델 파일 경로 (모델이 있는 경로에 맞게 수정)
MODEL_PATH = os.path.join(os.path.dirname(__file__), "final_model_xgb4.pkl")
# 모델 로딩
# 모델 로딩
try:
    xgb_model = joblib.load(MODEL_PATH)
    print(f"✅ 모델 로딩 완료: {MODEL_PATH}")
    
    # # 디버깅: imputer 내부 옵션 확인
    # if isinstance(xgb_model, Pipeline):
    #     imputer = xgb_model.named_steps['imputer']
    #     print(f"🔍 SimpleImputer 파라미터: {imputer.get_params()}")
    # else:
    #     print("⚠️ 모델은 Pipeline이 아님")
except Exception as e:
    print(f"🚨 모델 로딩 실패: {e}")
    xgb_model = None


import pandas as pd
import re
import hashlib
import string
from urllib.parse import urlparse
from tldextract import extract as tldextract_extract
from tld import get_tld

# ----------------------------------------------
# 특징 추출 함수 정의
# ----------------------------------------------

# 1. URL 길이 계산
def get_url_length(url):
    prefixes = ['http://', 'https://']
    for prefix in prefixes:
        if url.startswith(prefix):
            url = url[len(prefix):]
    url = url.replace('www.', '')
    return len(url)

# 2. 주 도메인 추출
def extract_pri_domain(url):
    try:
        res = get_tld(url, as_object=True, fail_silently=False, fix_protocol=True)
        return res.parsed_url.netloc
    except Exception:
        return None

# 3. 알파벳 개수 계산
def count_letters(url):
    return sum(char.isalpha() for char in str(url))

# 4. 숫자 개수 계산
def count_digits(url):
    return sum(char.isdigit() for char in str(url))

# 5. 특수문자 개수 계산
def count_special_chars(url):
    special_chars = set(string.punctuation)
    return sum(char in special_chars for char in str(url))

# 6. 단축 URL 사용 여부
def has_shortening_service(url):
    pattern = re.compile(
        r'bit\.ly|goo\.gl|shorte\.st|go2l\.ink|x\.co|ow\.ly|t\.co|tinyurl|tr\.im|'
        r'is\.gd|cli\.gs|yfrog\.com|migre\.me|ff\.im|tiny\.cc|url4\.eu|twit\.ac|'
        r'su\.pr|twurl\.nl|snipurl\.com|short\.to|BudURL\.com|ping\.fm|post\.ly|'
        r'Just\.as|bkite\.com|snipr\.com|fic\.kr|loopt\.us|doiop\.com|short\.ie|'
        r'kl\.am|wp\.me|rubyurl\.com|om\.ly|to\.ly|bit\.do|t\.co|lnkd\.in|db\.tt|'
        r'qr\.ae|adf\.ly|bitly\.com|cur\.lv|tinyurl\.com|ow\.ly|bit\.ly|ity\.im|'
        r'q\.gs|is\.gd|po\.st|bc\.vc|twitthis\.com|u\.to|j\.mp|buzurl\.com|cutt\.us|'
        r'u\.bb|yourls\.org|x\.co|prettylinkpro\.com|scrnch\.me|filoops\.info|'
        r'vzturl\.com|qr\.net|1url\.com|tweez\.me|v\.gd|tr\.im|link\.zip\.net',
        re.IGNORECASE
    )
    return 1 if pattern.search(url) else 0

# 7. abnormal URL 여부
def abnormal_url(url):
    try:
        parsed = urlparse(url)
        hostname = parsed.hostname
        if hostname:
            return 1 if re.search(re.escape(hostname), url) else 0
        return 0
    except Exception:
        return 0

# 9. IP 주소 포함 여부
def have_ip_address(url):
    try:
        hostname = urlparse(url).hostname
        if hostname:
            import ipaddress
            ipaddress.ip_address(hostname)
            return 1
    except Exception:
        return 0

# 10. TLD 길이
def tld_length(url):
    try:
        tld_val = get_tld(url, fail_silently=True)
        return len(tld_val) if tld_val is not None else -1
    except Exception:
        return -1

# 11. Root domain 추출
def extract_root_domain(url):
    extracted = tldextract_extract(url)
    return extracted.domain

# 12. 문자열 해시화
def hash_encode(category):
    hash_object = hashlib.md5(category.encode())
    return int(hash_object.hexdigest(), 16) % (10 ** 8)

# 13. URL 지역 정보 추출
def get_url_region(primary_domain):
    ccTLD_to_region = {
    ".ac": "Ascension Island",
    ".ad": "Andorra",
    ".ae": "United Arab Emirates",
    ".af": "Afghanistan",
    ".ag": "Antigua and Barbuda",
    ".ai": "Anguilla",
    ".al": "Albania",
    ".am": "Armenia",
    ".an": "Netherlands Antilles",
    ".ao": "Angola",
    ".aq": "Antarctica",
    ".ar": "Argentina",
    ".as": "American Samoa",
    ".at": "Austria",
    ".au": "Australia",
    ".aw": "Aruba",
    ".ax": "Åland Islands",
    ".az": "Azerbaijan",
    ".ba": "Bosnia and Herzegovina",
    ".bb": "Barbados",
    ".bd": "Bangladesh",
    ".be": "Belgium",
    ".bf": "Burkina Faso",
    ".bg": "Bulgaria",
    ".bh": "Bahrain",
    ".bi": "Burundi",
    ".bj": "Benin",
    ".bm": "Bermuda",
    ".bn": "Brunei Darussalam",
    ".bo": "Bolivia",
    ".br": "Brazil",
    ".bs": "Bahamas",
    ".bt": "Bhutan",
    ".bv": "Bouvet Island",
    ".bw": "Botswana",
    ".by": "Belarus",
    ".bz": "Belize",
    ".ca": "Canada",
    ".cc": "Cocos Islands",
    ".cd": "Democratic Republic of the Congo",
    ".cf": "Central African Republic",
    ".cg": "Republic of the Congo",
    ".ch": "Switzerland",
    ".ci": "Côte d'Ivoire",
    ".ck": "Cook Islands",
    ".cl": "Chile",
    ".cm": "Cameroon",
    ".cn": "China",
    ".co": "Colombia",
    ".cr": "Costa Rica",
    ".cu": "Cuba",
    ".cv": "Cape Verde",
    ".cw": "Curaçao",
    ".cx": "Christmas Island",
    ".cy": "Cyprus",
    ".cz": "Czech Republic",
    ".de": "Germany",
    ".dj": "Djibouti",
    ".dk": "Denmark",
    ".dm": "Dominica",
    ".do": "Dominican Republic",
    ".dz": "Algeria",
    ".ec": "Ecuador",
    ".ee": "Estonia",
    ".eg": "Egypt",
    ".er": "Eritrea",
    ".es": "Spain",
    ".et": "Ethiopia",
    ".eu": "European Union",
    ".fi": "Finland",
    ".fj": "Fiji",
    ".fk": "Falkland Islands",
    ".fm": "Federated States of Micronesia",
    ".fo": "Faroe Islands",
    ".fr": "France",
    ".ga": "Gabon",
    ".gb": "United Kingdom",
    ".gd": "Grenada",
    ".ge": "Georgia",
    ".gf": "French Guiana",
    ".gg": "Guernsey",
    ".gh": "Ghana",
    ".gi": "Gibraltar",
    ".gl": "Greenland",
    ".gm": "Gambia",
    ".gn": "Guinea",
    ".gp": "Guadeloupe",
    ".gq": "Equatorial Guinea",
    ".gr": "Greece",
    ".gs": "South Georgia and the South Sandwich Islands",
    ".gt": "Guatemala",
    ".gu": "Guam",
    ".gw": "Guinea-Bissau",
    ".gy": "Guyana",
    ".hk": "Hong Kong",
    ".hm": "Heard Island and McDonald Islands",
    ".hn": "Honduras",
    ".hr": "Croatia",
    ".ht": "Haiti",
    ".hu": "Hungary",
    ".id": "Indonesia",
    ".ie": "Ireland",
    ".il": "Israel",
    ".im": "Isle of Man",
    ".in": "India",
    ".io": "British Indian Ocean Territory",
    ".iq": "Iraq",
    ".ir": "Iran",
    ".is": "Iceland",
    ".it": "Italy",
    ".je": "Jersey",
    ".jm": "Jamaica",
    ".jo": "Jordan",
    ".jp": "Japan",
    ".ke": "Kenya",
    ".kg": "Kyrgyzstan",
    ".kh": "Cambodia",
    ".ki": "Kiribati",
    ".km": "Comoros",
    ".kn": "Saint Kitts and Nevis",
    ".kp": "Democratic People's Republic of Korea (North Korea)",
    ".kr": "Republic of Korea (South Korea)",
    ".kw": "Kuwait",
    ".ky": "Cayman Islands",
    ".kz": "Kazakhstan",
    ".la": "Laos",
    ".lb": "Lebanon",
    ".lc": "Saint Lucia",
    ".li": "Liechtenstein",
    ".lk": "Sri Lanka",
    ".lr": "Liberia",
    ".ls": "Lesotho",
    ".lt": "Lithuania",
    ".lu": "Luxembourg",
    ".lv": "Latvia",
    ".ly": "Libya",
    ".ma": "Morocco",
    ".mc": "Monaco",
    ".md": "Moldova",
    ".me": "Montenegro",
    ".mf": "Saint Martin (French part)",
    ".mg": "Madagascar",
    ".mh": "Marshall Islands",
    ".mk": "North Macedonia",
    ".ml": "Mali",
    ".mm": "Myanmar",
    ".mn": "Mongolia",
    ".mo": "Macao",
    ".mp": "Northern Mariana Islands",
    ".mq": "Martinique",
    ".mr": "Mauritania",
    ".ms": "Montserrat",
    ".mt": "Malta",
    ".mu": "Mauritius",
    ".mv": "Maldives",
    ".mw": "Malawi",
    ".mx": "Mexico",
    ".my": "Malaysia",
    ".mz": "Mozambique",
    ".na": "Namibia",
    ".nc": "New Caledonia",
    ".ne": "Niger",
    ".nf": "Norfolk Island",
    ".ng": "Nigeria",
    ".ni": "Nicaragua",
    ".nl": "Netherlands",
    ".no": "Norway",
    ".np": "Nepal",
    ".nr": "Nauru",
    ".nu": "Niue",
    ".nz": "New Zealand",
    ".om": "Oman",
    ".pa": "Panama",
    ".pe": "Peru",
    ".pf": "French Polynesia",
    ".pg": "Papua New Guinea",
    ".ph": "Philippines",
    ".pk": "Pakistan",
    ".pl": "Poland",
    ".pm": "Saint Pierre and Miquelon",
    ".pn": "Pitcairn",
    ".pr": "Puerto Rico",
    ".ps": "Palestinian Territory",
    ".pt": "Portugal",
    ".pw": "Palau",
    ".py": "Paraguay",
    ".qa": "Qatar",
    ".re": "Réunion",
    ".ro": "Romania",
    ".rs": "Serbia",
    ".ru": "Russia",
    ".rw": "Rwanda",
    ".sa": "Saudi Arabia",
    ".sb": "Solomon Islands",
    ".sc": "Seychelles",
    ".sd": "Sudan",
    ".se": "Sweden",
    ".sg": "Singapore",
    ".sh": "Saint Helena",
    ".si": "Slovenia",
    ".sj": "Svalbard and Jan Mayen",
    ".sk": "Slovakia",
    ".sl": "Sierra Leone",
    ".sm": "San Marino",
    ".sn": "Senegal",
    ".so": "Somalia",
    ".sr": "Suriname",
    ".ss": "South Sudan",
    ".st": "São Tomé and Príncipe",
    ".sv": "El Salvador",
    ".sx": "Sint Maarten (Dutch part)",
    ".sy": "Syria",
    ".sz": "Eswatini",
    ".tc": "Turks and Caicos Islands",
    ".td": "Chad",
    ".tf": "French Southern Territories",
    ".tg": "Togo",
    ".th": "Thailand",
    ".tj": "Tajikistan",
    ".tk": "Tokelau",
    ".tl": "Timor-Leste",
    ".tm": "Turkmenistan",
    ".tn": "Tunisia",
    ".to": "Tonga",
    ".tr": "Turkey",
    ".tt": "Trinidad and Tobago",
    ".tv": "Tuvalu",
    ".tw": "Taiwan",
    ".tz": "Tanzania",
    ".ua": "Ukraine",
    ".ug": "Uganda",
    ".uk": "United Kingdom",
    ".us": "United States",
    ".uy": "Uruguay",
    ".uz": "Uzbekistan",
    ".va": "Vatican City",
    ".vc": "Saint Vincent and the Grenadines",
    ".ve": "Venezuela",
    ".vg": "British Virgin Islands",
    ".vi": "U.S. Virgin Islands",
    ".vn": "Vietnam",
    ".vu": "Vanuatu",
    ".wf": "Wallis and Futuna",
    ".ws": "Samoa",
    ".ye": "Yemen",
    ".yt": "Mayotte",
    ".za": "South Africa",
    ".zm": "Zambia",
    ".zw": "Zimbabwe"
        # 추가 ccTLD는 필요에 따라 확장
    }
    for ccTLD in ccTLD_to_region:
        if primary_domain.endswith(ccTLD):
            return ccTLD_to_region[ccTLD]
    return "Global"

# 14. 도메인 길이
def domain_length(domain):
    return len(domain) if pd.notnull(domain) else 0

# 15. 도메인 내 점 개수
def dot_count_in_domain(domain):
    return domain.count('.') if pd.notnull(domain) else 0

# ----------------------------------------------
# DataFrame에서 특징 추출 함수
# ----------------------------------------------
def extract_features(df):
    df = df.copy()
    df['url_len'] = df['url'].apply(get_url_length)
    df['domain'] = df['url'].apply(extract_pri_domain)

    # 도메인 길이 및 도메인 내 점 개수
    df['domain_len'] = df['domain'].apply(domain_length)
    df['dot_count_in_domain'] = df['domain'].apply(dot_count_in_domain)

    df['letters_count'] = df['url'].apply(count_letters)
    df['digits_count'] = df['url'].apply(count_digits)
    df['special_chars_count'] = df['url'].apply(count_special_chars)
    df['shortened'] = df['url'].apply(has_shortening_service)
    df['abnormal'] = df['url'].apply(abnormal_url)
    df['have_ip'] = df['url'].apply(have_ip_address)
    df['tld_len'] = df['url'].apply(tld_length)
    df['root_domain'] = df['domain'].apply(lambda x: hash_encode(extract_root_domain(str(x))) if pd.notnull(x) else 0)
    df['url_region'] = df['domain'].apply(lambda x: hash_encode(get_url_region(str(x))) if pd.notnull(x) else 0)
    return df

def XGB_model_predict(url):
    print(url)
    df_url = pd.DataFrame({'url': [url]})
    df_features = extract_features(df_url)

    features = ['url_len', 'domain_len', 'dot_count_in_domain', 'letters_count', 'digits_count', 'special_chars_count',
                'shortened', 'abnormal', 'have_ip', 'tld_len', 'url_region', 'root_domain']
    X = df_features[features]


    # 모델 예측
    try:
        prediction = xgb_model.predict(X)[0]
        prediction_probs = xgb_model.predict_proba(X)[0] if hasattr(xgb_model, "predict_proba") else None
    except Exception as e:
        print(f"🚨 예측 중 오류 발생: {e}")
        return ("error", 0.0)

    class_mapping = {0: 'benign', 1: 'defacement', 2: 'phishing', 3: 'malware'}
    result_label = class_mapping.get(prediction, 'unknown')

    if prediction_probs is not None:
        max_prob = max(prediction_probs)
    else:
        print("⚠️ `predict_proba()`를 지원하지 않는 모델입니다.")
        max_prob = 1.0

    return (result_label, float(max_prob))
