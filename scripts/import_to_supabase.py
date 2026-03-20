"""
car_wash_kakao.json을 읽어서 Supabase infowash.car_wash 테이블에 upsert
Usage: python import_to_supabase.py
"""

import json
import os

import requests
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY")

if not SUPABASE_URL or not SUPABASE_SERVICE_KEY:
    raise EnvironmentError(
        "SUPABASE_URL 또는 SUPABASE_SERVICE_KEY가 설정되지 않았습니다. "
        "scripts/.env 파일을 확인하세요."
    )

INPUT_FILE = "car_wash_kakao.json"
BATCH_SIZE = 100
ENDPOINT = f"{SUPABASE_URL}/rest/v1/car_wash"

HEADERS = {
    "apikey": SUPABASE_SERVICE_KEY,
    "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
    "Content-Type": "application/json",
    "Prefer": "resolution=merge-duplicates",
    "Accept-Profile": "infowash",
    "Content-Profile": "infowash",
}


def build_row(item: dict) -> dict:
    """JSON 항목을 DB 행으로 변환"""
    return {
        "kakao_id": item.get("kakao_id"),
        "name": item["name"],
        "address": item["address"],
        "road_address": item.get("road_address"),
        "lat": item["lat"],
        "lng": item["lng"],
        "phone": item.get("phone"),
        "place_url": item.get("place_url"),
        "source": "KAKAO",
        "status": "ACTIVE",
    }


def upsert_batch(rows: list[dict]) -> int:
    """배치 upsert 후 삽입된 행 수 반환"""
    resp = requests.post(ENDPOINT, headers=HEADERS, json=rows, timeout=30)
    if not resp.ok:
        print(f"  ⚠ 오류 {resp.status_code}: {resp.text[:200]}")
        return 0
    # 201 Created: 삽입, 200 OK: merge(중복) — 응답 바디로 건수 확인
    try:
        result = resp.json()
        return len(result) if isinstance(result, list) else len(rows)
    except Exception:
        return len(rows)


def main():
    if not os.path.exists(INPUT_FILE):
        raise FileNotFoundError(
            f"{INPUT_FILE} 파일이 없습니다. collect_kakao.py를 먼저 실행하세요."
        )

    with open(INPUT_FILE, encoding="utf-8") as f:
        items: list[dict] = json.load(f)

    total = len(items)
    print(f"총 {total}건 upsert 시작 (배치 크기: {BATCH_SIZE})")

    rows = [build_row(item) for item in items]

    inserted = 0
    for start in range(0, total, BATCH_SIZE):
        batch = rows[start : start + BATCH_SIZE]
        end = min(start + BATCH_SIZE, total)
        print(f"  [{end:>4}/{total}] 업로드 중...", end=" ")
        count = upsert_batch(batch)
        inserted += count
        print(f"완료 ({count}건)")

    print(f"\nupsert 완료: 총 {inserted}건 처리")


if __name__ == "__main__":
    main()
