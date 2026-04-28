# 인포워시 (InfoWash)

전국 셀프세차장 위치 정보 검색 앱

현재 위치 주변의 셀프세차장을 지도에서 빠르게 찾고, 상세 정보 확인 및 리뷰를 작성할 수 있습니다.

## 주요 기능

- **지도 기반 검색** — 네이버 지도에서 주변 셀프세차장을 마커로 표시, 줌 레벨에 따라 검색 반경 자동 조정 (1~10km)
- **목록 검색** — 이름/주소 기반 세차장 검색 및 페이지네이션
- **상세 정보** — 주소, 연락처, 운영시간, 베이 수, 가격, 편의시설(청소기·에어건·매트세척기·화장실·대기공간) 등
- **리뷰 시스템** — 청결도/시설/가격 3가지 항목 별점 + 텍스트 리뷰 + 사진 첨부(최대 2장)
- **즐겨찾기** — 로컬 저장 기반 오프라인 즐겨찾기
- **카카오 로그인** — OAuth PKCE 플로우 기반 소셜 로그인
- **정보 수정 제안/신고** — 사용자가 잘못된 정보를 신고하거나 수정 제안 가능

## 기술 스택

| 영역 | 기술 |
|------|------|
| Framework | Flutter 3.11+ / Dart 3.11+ |
| 상태 관리 | Riverpod + riverpod_generator |
| 라우팅 | GoRouter (딥링크 지원) |
| 백엔드 | Supabase (PostgreSQL + PostGIS + Auth + Storage + Edge Functions) |
| 지도 | Naver Map SDK (flutter_naver_map) |
| 인증 | Kakao OAuth via Supabase Auth (PKCE) |
| 모델 | Freezed + json_serializable |
| 로컬 저장 | SharedPreferences |

## 프로젝트 구조

```
lib/
├── main.dart
├── core/
│   ├── constants/          # 앱 상수 (API 키는 환경변수로 주입)
│   ├── router/             # GoRouter 라우팅 설정
│   ├── theme/              # Material Design 3 테마
│   └── utils/              # 유틸리티 (닉네임 생성기 등)
├── data/
│   ├── models/             # Freezed 데이터 모델 (CarWash, Review, Favorite)
│   └── repositories/       # Supabase 데이터 접근 계층
├── providers/              # Riverpod 프로바이더 (인증, 위치, 세차장, 리뷰 등)
└── presentation/
    ├── screens/            # 화면 (홈, 목록, 상세, 리뷰, 즐겨찾기, 로그인, 신고)
    └── widgets/            # 공통 위젯 (네비게이션 쉘, 별점 바)

scripts/                    # 데이터 수집 스크립트 (Python)
supabase/
├── functions/              # Edge Functions (PostGIS 기반 거리 검색)
└── migrations/             # DB 마이그레이션
```

## 데이터 수집

세차장 데이터는 두 가지 소스에서 수집됩니다:

- **행정안전부 공공API** — 전국 셀프세차장 공식 데이터
- **카카오 로컬 API** — 키워드 기반 세차장 검색 (47개 주요 지역)

수집된 데이터는 Python 스크립트(`scripts/`)를 통해 Supabase에 임포트됩니다.

## 환경 설정

### 1. 환경변수

`scripts/.env.example`을 참고하여 `scripts/.env` 파일을 생성합니다:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_KEY=your-service-key
KAKAO_REST_API_KEY=your-kakao-key
PUBLIC_API_KEY=your-public-api-key
```

### 2. Flutter 빌드

API 키는 `--dart-define`으로 주입합니다:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key \
  --dart-define=NAVER_MAP_CLIENT_ID=your-naver-client-id
```

### 3. 코드 생성

Freezed/json_serializable 모델 변경 시:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 라우팅

| 경로 | 화면 | 비고 |
|------|------|------|
| `/` | 스플래시 | 앱 시작 |
| `/home` | 지도 (메인) | 하단 탭 |
| `/list` | 세차장 목록 | 하단 탭 |
| `/favorite` | 즐겨찾기 | 하단 탭 |
| `/detail/:id` | 세차장 상세 | |
| `/review/:id` | 리뷰 작성 | 로그인 필수 |
| `/report` | 정보 수정 제안 | |
| `/login` | 로그인 | |

## 라이선스

이 프로젝트는 개인 프로젝트로 별도의 라이선스가 지정되어 있지 않습니다.
