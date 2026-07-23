WITH moje_uslugi AS (
    SELECT value AS name 
    -- All streaming platforms you have access to
    FROM json_each('["Netflix", "HBO Max", "Amazon Prime Video", "Disney+"]')
)
SELECT 
    m.title,
    m.year,
    NULLIF(
        TRIM(
            CASE WHEN m.local = 1 THEN 'Available locally, ' ELSE '' END ||
            COALESCE((
                SELECT GROUP_CONCAT(u.name, ', ')
                FROM moje_uslugi u
                WHERE (
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
                    END = 1
                )
            ), '')
        , ', '),
        ''
    ) AS available_services
FROM movies m;