# Letterboxd Watchlist to SQLite (with Upflix)

A simple Python tool that fetches your Letterboxd watchlist, checks where those movies are available to stream in Poland via Upflix and optionaly checks if you already have them in your local directory, and saves everything into an SQLite database.

## Features

- Scrapes your public Letterboxd watchlist.
- Searches Upflix API & pages to find VOD providers (Netflix, HBO Max, Prime Video, etc.).
- Checks your local movie directory for existing files formatted as `TITLE (YEAR)`.
- Saves data into a clean `movies.db` SQLite database with boolean flags for each platform and local status (`1`, `0`, or `NULL`).
- Terminal CLI with a progress bar (`tqdm`).

## Requirements

Make sure you have Python installed, then install the required packages:

```bash
pip install requests beautifulsoup4 tqdm