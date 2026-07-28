-- Recommends the best new streaming service to subscribe to by finding which unowned platform offers the highest number of unavailable movies from your watchlist (ABONAMENT only).
WITH moje_uslugi AS (
    SELECT value AS name 
    FROM json_each('["Netflix", "HBO Max", "SkyShowtime", "Amazon Prime Video", "Youtube"]')
),
unseen_movies AS (
    SELECT m.*
    FROM movies m
    WHERE COALESCE(m.local, 0) = 0
      AND NOT EXISTS (
          SELECT 1 
          FROM moje_uslugi u
          WHERE CASE u.name
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
all_other_platforms AS (
    SELECT 'Disney+' AS platform, title, year FROM unseen_movies WHERE "Disney+" = 'ABONAMENT'
    UNION ALL SELECT 'Polsat Box Go', title, year FROM unseen_movies WHERE "Polsat Box Go" = 'ABONAMENT'
    UNION ALL SELECT 'Rakuten', title, year FROM unseen_movies WHERE "Rakuten" = 'ABONAMENT'
    UNION ALL SELECT 'Player', title, year FROM unseen_movies WHERE "Player" = 'ABONAMENT'
    UNION ALL SELECT 'TVP VOD', title, year FROM unseen_movies WHERE "TVP VOD" = 'ABONAMENT'
    UNION ALL SELECT 'Apple TV', title, year FROM unseen_movies WHERE "Apple TV" = 'ABONAMENT'
    UNION ALL SELECT 'PLAY NOW', title, year FROM unseen_movies WHERE "PLAY NOW" = 'ABONAMENT'
    UNION ALL SELECT 'Canal+', title, year FROM unseen_movies WHERE "Canal+" = 'ABONAMENT'
    UNION ALL SELECT 'CDA Premium', title, year FROM unseen_movies WHERE "CDA Premium" = 'ABONAMENT'
    UNION ALL SELECT 'Ninateka', title, year FROM unseen_movies WHERE "Ninateka" = 'ABONAMENT'
    UNION ALL SELECT 'E-Kino Pod Baranami', title, year FROM unseen_movies WHERE "E-Kino Pod Baranami" = 'ABONAMENT'
    UNION ALL SELECT 'MOJEeKINO', title, year FROM unseen_movies WHERE "MOJEeKINO" = 'ABONAMENT'
    UNION ALL SELECT 'Nowe Horyzonty', title, year FROM unseen_movies WHERE "Nowe Horyzonty" = 'ABONAMENT'
    UNION ALL SELECT 'FilmBox+', title, year FROM unseen_movies WHERE "FilmBox+" = 'ABONAMENT'
    UNION ALL SELECT 'Pięć Smaków', title, year FROM unseen_movies WHERE "Pięć Smaków" = 'ABONAMENT'
    UNION ALL SELECT 'VOD.MDAG.PL', title, year FROM unseen_movies WHERE "VOD.MDAG.PL" = 'ABONAMENT'
    UNION ALL SELECT 'Katoflix', title, year FROM unseen_movies WHERE "Katoflix" = 'ABONAMENT'
    UNION ALL SELECT 'Outfilm', title, year FROM unseen_movies WHERE "Outfilm" = 'ABONAMENT'
    UNION ALL SELECT '35mm.online', title, year FROM unseen_movies WHERE "35mm.online" = 'ABONAMENT'
    UNION ALL SELECT 'FlixClassic', title, year FROM unseen_movies WHERE "FlixClassic" = 'ABONAMENT'
    UNION ALL SELECT 'CHILI', title, year FROM unseen_movies WHERE "CHILI" = 'ABONAMENT'
    UNION ALL SELECT 'RED GO', title, year FROM unseen_movies WHERE "RED GO" = 'ABONAMENT'
    UNION ALL SELECT 'Megogo', title, year FROM unseen_movies WHERE "Megogo" = 'ABONAMENT'
    UNION ALL SELECT 'ARTE po polsku', title, year FROM unseen_movies WHERE "ARTE po polsku" = 'ABONAMENT'
    UNION ALL SELECT 'TVSmart', title, year FROM unseen_movies WHERE "TVSmart" = 'ABONAMENT'
    UNION ALL SELECT 'RafaelKino', title, year FROM unseen_movies WHERE "RafaelKino" = 'ABONAMENT'
    UNION ALL SELECT 'Pilot WP', title, year FROM unseen_movies WHERE "Pilot WP" = 'ABONAMENT'
    UNION ALL SELECT 'Sweet.tv', title, year FROM unseen_movies WHERE "Sweet.tv" = 'ABONAMENT'
    UNION ALL SELECT 'Mubi', title, year FROM unseen_movies WHERE "Mubi" = 'ABONAMENT'
    UNION ALL SELECT 'Crunchyroll', title, year FROM unseen_movies WHERE "Crunchyroll" = 'ABONAMENT'
    UNION ALL SELECT 'Animation Digital Network', title, year FROM unseen_movies WHERE "Animation Digital Network" = 'ABONAMENT'
    UNION ALL SELECT 'Dokufilm', title, year FROM unseen_movies WHERE "Dokufilm" = 'ABONAMENT'
)
SELECT 
    platform AS recommend_platform,
    COUNT(*) AS new_movies_count,
    GROUP_CONCAT(title || ' (' || year || ')', '; ') AS movies_list
FROM all_other_platforms
GROUP BY platform
ORDER BY new_movies_count DESC
LIMIT 1;