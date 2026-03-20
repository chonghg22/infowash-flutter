"""
행정안전부 세차장정보 공공API 수집 (셀프세차장만)
Usage: python collect_public_api.py
결과: scripts/car_wash_public.json
"""

import json
import math
import os
import time

import requests
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("PUBLIC_API_KEY")
if not API_KEY:
    raise EnvironmentError(
        "PUBLIC_API_KEY가 설정되지 않았습니다. scripts/.env 파일을 확인하세요."
    )

BASE_URL = "https://apis.data.go.kr/1741000/car_wash_info/info"
NUM_OF_ROWS = 100
OUTPUT_FILE = "car_wash_public.json"

SELF_WASH_KEYWORDS = ["셀프세차", "셀프", "셀프세차장"]
EXCLUDE_KEYWORDS = ["손세차", "자동세차", "기계세차"]


def is_self_wash(item: dict) -> bool:
    """셀프세차장 해당 여부 판별"""
    cws_type = item.get("CWS_TYPE", "") or ""
    name = item.get("BPLC_NM", "") or ""
    biz_type = item.get("BPLC_TPBIZ_NM", "") or ""
    combined = cws_type + name + biz_type

    # 업체명에 '셀프'가 명확히 있으면 무조건 포함
    if "셀프" in name:
        return True

    # 제외 키워드가 CWS_TYPE에 있고, 업체명에 셀프 없으면 스킵
    if any(kw in cws_type for kw in EXCLUDE_KEYWORDS):
        return False

    # 포함 키워드가 하나라도 있으면 포함
    return any(kw in combined for kw in SELF_WASH_KEYWORDS)


def fetch_page(page: int):
    """지정 페이지 fetch. (items, totalCount) 반환"""
    params = {
        "serviceKey": API_KEY,
        "pageNo": page,
        "numOfRows": NUM_OF_ROWS,
        "returnType": "json",
    }
    resp = requests.get(BASE_URL, params=params, timeout=30)
    resp.raise_for_status()
    body = resp.json()["response"]["body"]
    total_count = int(body.get("totalCount", 0))
    raw_items = body.get("items", {})
    if not raw_items:
        return [], total_count
    items = raw_items.get("item", [])
    if isinstance(items, dict):
        items = [items]
    return items, total_count


def main():
    print("행정안전부 세차장정보 공공API 수집 시작 (셀프세차장 필터)")

    first_items, total_count = fetch_page(1)
    total_pages = math.ceil(total_count / NUM_OF_ROWS)
    print(f"전체 {total_count}건 / {total_pages}페이지")

    all_items = []
    skipped_no_coord = 0
    skipped_not_self = 0

    for page in range(1, total_pages + 1):
        try:
            items, _ = fetch_page(page)
        except Exception as e:
            print(f"  [페이지 {page}] 오류: {e} — 재시도")
            time.sleep(2)
            try:
                items, _ = fetch_page(page)
            except Exception as e2:
                print(f"  [페이지 {page}] 재시도 실패: {e2} — 건너뜀")
                continue

        valid = []
        for item in items:
            # 좌표 검증
            lat = (item.get("WGS84_LAT") or "").strip()
            lng = (item.get("WGS84_LOT") or "").strip()
            if not lat or not lng:
                skipped_no_coord += 1
                continue
            try:
                float(lat)
                float(lng)
            except ValueError:
                skipped_no_coord += 1
                continue

            # 셀프세차 필터
            if not is_self_wash(item):
                skipped_not_self += 1
                continue

            valid.append(item)

        all_items.extend(valid)
        print(
            f"  [{page:>3}/{total_pages}] {len(valid)}건 수집 "
            f"(누적 {len(all_items)}건 | 좌표없음 {skipped_no_coord} / 셀프아님 {skipped_not_self} 스킵)"
        )

        if page % 10 == 0:
            time.sleep(0.5)

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(all_items, f, ensure_ascii=False, indent=2)

    print(f"\n{'='*50}")
    print(f"전체 API 건수 : {total_count}건")
    print(f"셀프세차 수집 : {len(all_items)}건  →  {OUTPUT_FILE}")
    print(f"좌표 없어 제외: {skipped_no_coord}건")
    print(f"셀프아님  제외: {skipped_not_self}건")


if __name__ == "__main__":
    main()
