import os
import sqlite3
from tqdm import tqdm

from parsing import (
    get_letterboxd_watchlist,
    query_upflix_api,
    get_movie_local
)

PLATFORMS_LIST = [
    "Netflix", "Disney+", "HBO Max", "SkyShowtime", "Amazon Prime Video", 
    "Polsat Box Go", "Rakuten", "Player", "TVP VOD", "Apple TV", "PLAY NOW", 
    "Canal+", "CDA Premium", "Ninateka", "E-Kino Pod Baranami", "MOJEeKINO", 
    "Nowe Horyzonty", "FilmBox+", "Pięć Smaków", "VOD.MDAG.PL", "Katoflix", 
    "Outfilm", "35mm.online", "FlixClassic", "CHILI", "RED GO", "Megogo", 
    "ARTE po polsku", "TVSmart", "RafaelKino", "Pilot WP", "Sweet.tv", 
    "Mubi", "Crunchyroll", "Animation Digital Network", "Youtube", "Dokufilm"
]

DB_NAME = "movies.db"

def build_database(username, movies_dir, db_path=DB_NAME):
    if os.path.exists(db_path):
        os.remove(db_path)

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    platform_columns = ", ".join([f'"{p}" TEXT DEFAULT NULL' for p in PLATFORMS_LIST])
    create_table_sql = f'''
        CREATE TABLE movies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            year INTEGER,
            upflix_url TEXT,
            local INTEGER DEFAULT 0,
            {platform_columns}
        )
    '''
    cursor.execute(create_table_sql)

    movies = get_letterboxd_watchlist(username)
    allowed_platforms_set = set(PLATFORMS_LIST)

    pbar = tqdm(movies, desc="Initialisation...", unit="movie")

    for movie in pbar:
        title = movie["title"]
        year = movie["year"]
        
        pbar.set_description(f"Movie: {title[:23]:<23}")

        is_local = get_movie_local(title, year, movies_dir)
        
        upflix_url, found_platforms = query_upflix_api(title, year)

        platform_flags = {p: None for p in PLATFORMS_LIST}
        if found_platforms:
            for p, status in found_platforms.items():
                if p not in allowed_platforms_set:
                    conn.close()
                    raise ValueError(f"\nUnrecognized platform: '{p}' for '{title}'!")
                platform_flags[p] = status

        cols = ["title", "year", "upflix_url", "local"] + [f'"{p}"' for p in PLATFORMS_LIST]
        placeholders = ", ".join(["?"] * len(cols))
        sql = f'INSERT INTO movies ({", ".join(cols)}) VALUES ({placeholders})'
        values = [title, year, upflix_url, is_local] + [platform_flags[p] for p in PLATFORMS_LIST]
        
        cursor.execute(sql, values)

    conn.commit()
    conn.close()
    print(f"Succesfully created db")