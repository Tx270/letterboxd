-- Analyzes active subscriptions to identify potential redundancies by counting unique vs. overlapping movie availability (ABONAMENT only).
WITH moje_uslugi AS (
    SELECT value AS name
    -- All streaming platforms you have access to
    FROM json_each('["Netflix", "HBO Max", "SkyShowtime", "Amazon Prime Video", "Youtube"]')
),
unpacked_movies AS (
    SELECT 
        m.id,
        m.title,
        m.year,
        COALESCE(m.local, 0) AS is_local,
        u.name AS platform
    FROM movies m
    JOIN moje_uslugi u ON (
        CASE u.name
            WHEN 'Netflix' THEN m."Netflix"
            WHEN 'Disney+' THEN m."Disney+"
            WHEN 'HBO Max' THEN m."HBO Max"
            WHEN 'SkyShowtime' THEN m."SkyShowtime"
            WHEN 'Amazon Prime Video' THEN m."Amazon Prime Video"
            WHEN 'Polsat Box Go' THEN m."Polsat Box Go"
            WHEN 'Rakuten' THEN m."Rakuten"
            WHEN 'Player' THEN m."Player"
            WHEN 'TVP VOD' THEN m."TVP VOD"
            WHEN 'Apple TV' THEN m."Apple TV"
            WHEN 'PLAY NOW' THEN m."PLAY NOW"
            WHEN 'Canal+' THEN m."Canal+"
            WHEN 'CDA Premium' THEN m."CDA Premium"
            WHEN 'Ninateka' THEN m."Ninateka"
            WHEN 'E-Kino Pod Baranami' THEN m."E-Kino Pod Baranami"
            WHEN 'MOJEeKINO' THEN m."MOJEeKINO"
            WHEN 'Nowe Horyzonty' THEN m."Nowe Horyzonty"
            WHEN 'FilmBox+' THEN m."FilmBox+"
            WHEN 'Pięć Smaków' THEN m."Pięć Smaków"
            WHEN 'VOD.MDAG.PL' THEN m."VOD.MDAG.PL"
            WHEN 'Katoflix' THEN m."Katoflix"
            WHEN 'Outfilm' THEN m."Outfilm"
            WHEN '35mm.online' THEN m."35mm.online"
            WHEN 'FlixClassic' THEN m."FlixClassic"
            WHEN 'CHILI' THEN m."CHILI"
            WHEN 'RED GO' THEN m."RED GO"
            WHEN 'Megogo' THEN m."Megogo"
            WHEN 'ARTE po polsku' THEN m."ARTE po polsku"
            WHEN 'TVSmart' THEN m."TVSmart"
            WHEN 'RafaelKino' THEN m."RafaelKino"
            WHEN 'Pilot WP' THEN m."Pilot WP"
            WHEN 'Sweet.tv' THEN m."Sweet.tv"
            WHEN 'Mubi' THEN m."Mubi"
            WHEN 'Crunchyroll' THEN m."Crunchyroll"
            WHEN 'Animation Digital Network' THEN m."Animation Digital Network"
            WHEN 'Youtube' THEN m."Youtube"
            WHEN 'Dokufilm' THEN m."Dokufilm"
        END = 'ABONAMENT'
    )
),
movie_provider_counts AS (
    -- Counts across how many of your platforms (+ local) a movie is available in subscription
    SELECT 
        m.id,
        (COALESCE(m.local, 0) + COUNT(um.platform)) AS total_sources
    FROM movies m
    LEFT JOIN unpacked_movies um ON m.id = um.id
    GROUP BY m.id
)
SELECT 
    um.platform,
    COUNT(um.id) AS total_watchlist_movies,
    SUM(CASE WHEN mpc.total_sources = 1 AND um.is_local = 0 THEN 1 ELSE 0 END) AS exclusive_movies,
    SUM(CASE WHEN mpc.total_sources > 1 OR um.is_local = 1 THEN 1 ELSE 0 END) AS redundant_movies
FROM unpacked_movies um
JOIN movie_provider_counts mpc ON um.id = mpc.id
GROUP BY um.platform
ORDER BY exclusive_movies ASC, total_watchlist_movies ASC;