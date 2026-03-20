import postgres from 'https://deno.land/x/postgresjs/mod.js';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

Deno.serve(async (req: Request) => {
  // ── CORS preflight ──────────────────────────────────────────────────────────
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    // ── 파라미터 파싱 ─────────────────────────────────────────────────────────
    const body = await req.json();
    const lat: unknown = body.lat;
    const lng: unknown = body.lng;
    const radius_km: number = typeof body.radius_km === 'number' ? body.radius_km : 5;
    const limit: number = typeof body.limit === 'number' ? body.limit : 20;

    if (typeof lat !== 'number' || typeof lng !== 'number') {
      return new Response(
        JSON.stringify({ error: 'lat, lng는 필수 숫자 파라미터입니다.' }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        },
      );
    }

    const radius_m = radius_km * 1000;

    // ── DB 직접 연결 (service_role 권한) ──────────────────────────────────────
    const dbUrl = Deno.env.get('SUPABASE_DB_URL')!;
    const sql = postgres(dbUrl, { prepare: false });

    // ── PostGIS 반경 검색 쿼리 ─────────────────────────────────────────────────
    // infowash.car_wash 테이블에서 ST_DWithin으로 반경 필터 후 거리순 정렬
    const rows = await sql`
      SELECT
        id,
        name,
        address,
        road_address,
        lat,
        lng,
        phone,
        open_hours,
        bay_count,
        price_info,
        has_vacuum,
        has_air_gun,
        has_mat_wash,
        has_toilet,
        has_waiting,
        images,
        source,
        status,
        reported_count,
        created_at,
        updated_at,
        ROUND(
          ST_Distance(
            location,
            ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326)::geography
          )::numeric,
          1
        ) AS distance_m
      FROM infowash.car_wash
      WHERE
        ST_DWithin(
          location,
          ST_SetSRID(ST_MakePoint(${lng}, ${lat}), 4326)::geography,
          ${radius_m}
        )
        AND status = 'ACTIVE'
      ORDER BY distance_m ASC
      LIMIT ${limit}
    `;

    await sql.end();

    return new Response(JSON.stringify(rows), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err);
    console.error('[nearby-carwash] error:', message);
    return new Response(
      JSON.stringify({ error: message }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      },
    );
  }
});
