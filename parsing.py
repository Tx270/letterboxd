import requests
import urllib.parse
from bs4 import BeautifulSoup


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


def get_upflix_platforms(url):
    if not url:
        return None
    response = requests.get(url, headers=HEADERS)
    if response.status_code != 200:
        print(f"Błąd HTTP: {response.status_code}")
        return []

    soup = BeautifulSoup(response.text, 'html.parser')
    
    platforms = set()
    for elem in soup.select('a[data-source-label]'):
        label = elem.get('data-source-label')
        if label:
            platforms.add(label.strip())

    return sorted(list(platforms))


def get_upflix_url(title, year=None):
    params = {"search": title}
    if year:
        params["rok"] = f"{year}-{year}"

    api_url = f"https://upflix.pl/api/video/index?{urllib.parse.urlencode(params)}"
    
    try:
        response = requests.get(api_url, headers=HEADERS, timeout=10)
        if response.status_code != 200:
            return None

        data = response.json()

        if isinstance(data, dict):
            models = data.get("models", [])
        elif isinstance(data, list):
            models = data
        else:
            models = []

        if models and isinstance(models[0], dict):
            rel_url = models[0].get("url", "")
            return f"https://upflix.pl{rel_url}" if rel_url else None

    except Exception as e:
        print(f"Upflix API error: {e}")
        return None

    return None