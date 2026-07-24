import requests
import os
import urllib.parse
from bs4 import BeautifulSoup
from time import sleep


HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}


def get_letterboxd_watchlist(username):
    print(f"Downloading watchlist for {username}...")
    titles = []
    page = 1
    while True:
        response = requests.get(f"https://letterboxd.com/{username}/watchlist/page/" + str(page) + "/", headers=HEADERS)

        if response.status_code == 200:
            soup = BeautifulSoup(response.text, "html.parser")

            components = soup.select("div.react-component[data-item-name]")

            if len(components) == 0:
                break

            for i, comp in enumerate(components, 1):
                title = comp.get("data-item-name")
                titles.append({"title": title[:-7], "year": int(title[-5:-1])})

            page += 1
        else:
            print(f"Error while downloading webpage. Code: {response.status_code}")

    print(f"Found {len(titles)} movies")
    return titles


def query_upflix_api(title, year=None):
    params = {"search": title}
    if year:
        params["rok"] = f"{year}-{year}"

    api_url = f"https://upflix.pl/api/video/index?{urllib.parse.urlencode(params)}"
    
    try:
        response = requests.get(api_url, headers=HEADERS, timeout=10)
        if response.status_code != 200:
            return (None, [])

        data = response.json()
        if not data:
            print(f"\nEmpty response for {title}. Sleeping for 1 sec...")
            sleep(1)
            query_upflix_api(title, year)

        if isinstance(data, dict):
            models = data.get("models", [])
        elif isinstance(data, list):
            models = data
        else:
            models = []

        if models and isinstance(models[0], dict):
            rel_url = models[0].get("url", "")
            sources = models[0].get("sources", "")
            platforms = [item['title'].replace('Zobacz w ', '').strip() for item in sources]
            return (
                f"https://upflix.pl{rel_url}" if rel_url else None,
                platforms if platforms else []
            )

    except Exception as e:
        print(f"Upflix API error: {e}")
        return (None, [])

    return (None, [])


def get_movie_local(title, year, movies_dir):
    if not movies_dir:
        return None

    if not os.path.exists(movies_dir):
        return 0

    expected_folder_name = f"{title} ({year})" if year else title
    expected_path = os.path.join(movies_dir, expected_folder_name)

    try:
        existing_folders = os.listdir(movies_dir)
        for folder in existing_folders:
            if folder.lower() == expected_folder_name.lower():
                return 1
    except OSError:
        pass

    return 0