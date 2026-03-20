"""
car_wash_public.json을 읽어서 Supabase infowash.car_wash 테이블에 upsert
external_id(MNG_NO) 기준 중복 방지, 셀프세차장만 이중 검증 후 적재
Usage: python import_public_to_supabase.py
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

INPUT_FILE = "car_wash_public.json"
BATCH_SIZE = 100
ENDPOINT = f"{SUPABASE_URL}/rest/v1/car_wash"

# external_id / car_wash_type 컬럼이 DB에 추가된 후 True로 변경
# (supabase/migrations/20260320000000_add_external_id.sql 실행 필요)
INCLUDE_EXTENDED_COLUMNS = False

HEADERS = {
    "apikey": SUPABASE_SERVICE_KEY,
    "Authorization": f"Bearer {SUPABASE_SERVICE_KEY}",
    "Content-Type": "application/json",
    "Prefer": "resolution=merge-duplicates",
    "Accept-Profile": "infowash",
    "Content-Profile": "infowash",
}

SELF_WASH_KEYWORDS = ["셀프세차", "셀프", "셀프세차장"]
EXCLUDE_KEYWORDS = ["손세차", "자동세차", "기계세차"]


def is_self_wash(item: dict) -> bool:
    """셀프세차장 해당 여부 이중 검증"""
    cws_type = item.get("CWS_TYPE", "") or ""
    name = item.get("BPLC_NM", "") or ""
    biz_type = item.get("BPLC_TPBIZ_NM", "") or ""
    combined = cws_type + name + biz_type

    if "셀프" in name:
        return True
    if any(kw in cws_type for kw in EXCLUDE_KEYWORDS):
        return False
    return any(kw in combined for kw in SELF_WASH_KEYWORDS)


def _format_open_hours(item: dict):
    start = (item.get("WKDY_OPER_BGNG_TM") or "").strip()
    end = (item.get("WKDY_OPER_END_TM") or "").strip()
    if not start and not end:
        return None

    def _fmt(t):
        t = t.zfill(4)
        return f"{t[:2]}:{t[2:]}"

    return f"{_fmt(start)}~{_fmt(end)}" if start and end else (start or end)


def build_row(item: dict) -> dict:
    road_addr = (item.get("LCTN_ROAD_NM_ADDR") or "").strip() or None
    lot_addr = (item.get("LCTN_LOTNO_ADDR") or "").strip() or None
    sgg_nm = (item.get("SGG_NM") or "").strip()
    address = lot_addr or sgg_nm or road_addr or ""

    row = {
        "name": (item.get("BPLC_NM") or "").strip(),
        "road_address": road_addr,
        "address": address,
        "lat": float(item["WGS84_LAT"]),
        "lng": float(item["WGS84_LOT"]),
        "phone": (item.get("CRWSH_TELNO") or "").strip() or None,
        "open_hours": _format_open_hours(item),
        "source": "PUBLIC",
        "status": "ACTIVE",
    }
    # 마이그레이션 후 추가된 컬럼 — 존재할 때만 포함
    if INCLUDE_EXTENDED_COLUMNS:
        row["external_id"] = (item.get("MNG_NO") or "").strip() or None
        row["car_wash_type"] = (item.get("CWS_TYPE") or "").strip() or None
    return row


def upsert_batch(rows) -> int:
    resp = requests.post(ENDPOINT, headers=HEADERS, json=rows, timeout=30)
    if not resp.ok:
        print(f"  ⚠ 오류 {resp.status_code}: {resp.text[:300]}")
        return 0
    try:
        result = resp.json()
        return len(result) if isinstance(result, list) else len(rows)
    except Exception:
        return len(rows)


def main():
    if not os.path.exists(INPUT_FILE):
        raise FileNotFoundError(
            f"{INPUT_FILE} 파일이 없습니다. collect_public_api.py를 먼저 실행하세요."
        )

    with open(INPUT_FILE, encoding="utf-8") as f:
        raw_items = json.load(f)

    print(f"JSON 로드: {len(raw_items)}건")

    # 이중 검증 필터
    rows = []
    skipped_no_name = 0
    skipped_not_self = 0
    for item in raw_items:
        name = (item.get("BPLC_NM") or "").strip()
        if not name:
            skipped_no_name += 1
            continue
        if not is_self_wash(item):
            skipped_not_self += 1
            continue
        rows.append(build_row(item))

    print(f"이중 검증 후 적재 대상: {len(rows)}건")
    if skipped_no_name:
        print(f"  상호명 없어 제외: {skipped_no_name}건")
    if skipped_not_self:
        print(f"  셀프아님 제외   : {skipped_not_self}건")
    print(f"upsert 시작 (배치 크기: {BATCH_SIZE})\n")

    inserted = 0
    for start in range(0, len(rows), BATCH_SIZE):
        batch = rows[start : start + BATCH_SIZE]
        end = min(start + BATCH_SIZE, len(rows))
        print(f"  [{end:>5}/{len(rows)}] 업로드 중...", end=" ")
        count = upsert_batch(batch)
        inserted += count
        print(f"완료 ({count}건)")

    print(f"\nupsert 완료: 총 {inserted}건 처리")


if __name__ == "__main__":
    main()
