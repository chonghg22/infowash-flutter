-- 행정안전부 공공API 연동을 위한 컬럼 추가
ALTER TABLE infowash.car_wash
  ADD COLUMN IF NOT EXISTS external_id text,
  ADD COLUMN IF NOT EXISTS car_wash_type text;

CREATE UNIQUE INDEX IF NOT EXISTS car_wash_external_id_idx
  ON infowash.car_wash(external_id)
  WHERE external_id IS NOT NULL;
