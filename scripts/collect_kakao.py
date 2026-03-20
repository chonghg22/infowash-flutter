"""
카카오 로컬 키워드 검색 API로 셀프세차장 데이터 수집
Usage: python collect_kakao.py
"""

import json
import os
import time

import requests
from dotenv import load_dotenv

load_dotenv()

KAKAO_REST_API_KEY = os.getenv("KAKAO_REST_API_KEY")
if not KAKAO_REST_API_KEY:
    raise EnvironmentError("KAKAO_REST_API_KEY가 설정되지 않았습니다. scripts/.env 파일을 확인하세요.")

KAKAO_KEYWORD_URL = "https://dapi.kakao.com/v2/local/search/keyword.json"
HEADERS = {"Authorization": f"KakaoAK {KAKAO_REST_API_KEY}"}

OUTPUT_FILE = "car_wash_kakao.json"
KEYWORD = "셀프세차"
MAX_PAGE = 3
SIZE = 15

REGIONS = [
    # 서울
    "서울 강남구", "서울 강서구", "서울 노원구", "서울 송파구", "서울 마포구",
    # 부산
    "부산 해운대구", "부산 부산진구", "부산 남구",
    # 대구
    "대구 수성구", "대구 달서구",
    # 인천
    "인천 남동구", "인천 부평구",
    # 광주
    "광주 북구", "광주 서구",
    # 대전
    "대전 유성구", "대전 서구",
    # 울산
    "울산 남구", "울산 북구",
    # 경기/기타 주요 도시
    "수원시", "창원시", "고양시", "성남시", "청주시",
    "전주시", "천안시", "안산시", "안양시",
    "남양주시", "화성시", "부천시", "용인시",
    "포항시", "김해시", "평택시", "시흥시",
]


def search_region(region: str) -> list[dict]:
    """한 지역에 대해 최대 MAX_PAGE 페이지까지 검색 후 결과 반환"""
    results = []
    for page in range(1, MAX_PAGE + 1):
        params = {
            "query": f"{region} {KEYWORD}",
            "size": SIZE,
            "page": page,
        }
        resp = requests.get(KAKAO_KEYWORD_URL, headers=HEADERS, params=params, timeout=10)
        resp.raise_for_status()
        data = resp.json()

        documents = data.get("documents", [])
        results.extend(documents)

        meta = data.get("meta", {})
        is_end = meta.get("is_end", True)
        if is_end:
            break

        time.sleep(0.3)  # API 속도 제한 방지

    return results


def map_fields(doc: dict) -> dict:
    """카카오 응답 필드를 인포워시 스키마로 변환"""
    return {
        "kakao_id": doc.get("id", ""),
        "name": doc.get("place_name", ""),
        "address": doc.get("address_name", ""),
        "road_address": doc.get("road_address_name", "") or None,
        "lng": float(doc.get("x", 0)),
        "lat": float(doc.get("y", 0)),
        "phone": doc.get("phone", "") or None,
        "place_url": doc.get("place_url", "") or None,
    }


def main():
    all_raw: list[dict] = []
    seen_ids: set[str] = set()

    total_regions = len(REGIONS)
    for idx, region in enumerate(REGIONS, 1):
        print(f"[{idx:>2}/{total_regions}] 수집 중: {region}", end=" ... ", flush=True)
        try:
            docs = search_region(region)
        except requests.RequestException as e:
            print(f"실패 ({e})")
            continue

        new_count = 0
        for doc in docs:
            kakao_id = doc.get("id", "")
            if kakao_id and kakao_id not in seen_ids:
                seen_ids.add(kakao_id)
                all_raw.append(doc)
                new_count += 1

        print(f"{new_count}건 추가 (누적 {len(all_raw)}건)")
        time.sleep(0.2)

    mapped = [map_fields(doc) for doc in all_raw]

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(mapped, f, ensure_ascii=False, indent=2)

    print(f"\n수집 완료: 총 {len(mapped)}건 → {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
