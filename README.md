# Letterboxd Watchlist to SQLite (with Upflix)

A simple Python tool that fetches your Letterboxd watchlist, checks where those movies are available to stream in Poland via Upflix, and saves everything into an SQLite database.

## Features

- Scrapes your public Letterboxd watchlist.
- Searches Upflix API & pages to find VOD providers (Netflix, HBO Max, Prime Video, etc.).
- Saves data into a clean `movies.db` SQLite database with boolan flags for each platform.
- Terminal CLI with a progress bar.

## Requirements

Make sure you have Python installed, then install the required packages:

```bash
pip install requests beautifulsoup4 tqdm