-- review 테이블에 nickname 컬럼 추가
alter table infowash.review
  add column if not exists nickname text;

-- user_profile 테이블 (없으면 생성)
create table if not exists infowash.user_profile (
  id uuid primary key references auth.users(id) on delete cascade,
  nickname text not null,
  created_at timestamptz default now()
);
