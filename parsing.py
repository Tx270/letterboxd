import requests
import os
import re
import urllib.parse
from bs4 import BeautifulSoup
from time import sleep


HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

IGNORE_SUFFIXES_PATTERN = re.compile(
    r'\s*-\s*(?:IMAX|Remastered|Director\'s Cut|Extended Edition|Theatrical Edition|Open Matte|Uncut|Collector\'s Edition|Special Edition|Ultimate Edition|Restored|4K|HDR)\b',
    re.IGNORECASE
)


def parse_movie_title_and_year(raw_title):
    match = re.search(r'^(.*?)\s*\((\d{4})\)$', raw_title.strip())
    if match:
        clean_title = match.group(1).strip()
        year = int(match.group(2))
        return clean_title, year
    
    return raw_title.strip(), None


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
                clean_title, year = parse_movie_title_and_year(title)
                titles.append({"title": clean_title, "year": year})

            page += 1
        else:
            print(f"Error while downloading webpage. Code: {response.status_code}")

    print(f"Found {len(titles)} movies")
    return titles


def get_upflix_platforms(url):
    if not url:
        return {}
        
    response = requests.get(url, headers=HEADERS)
    if response.status_code != 200:
        print(f"Błąd HTTP: {response.status_code}")
        return {}

    soup = BeautifulSoup(response.text, 'html.parser')
    
    services_status = {}
    
    for elem in soup.select('a[data-source-label]'):
        label = elem.get('data-source-label')
        span = elem.find('span')
        
        if label and span:
            platform_name = label.strip()
            status = span.get_text(strip=True).upper()
            
            # Jeśli usługa ma już wpisany ABONAMENT, nie nadpisujemy go słabszym statusem (np. WYPOŻYCZENIE)
            if services_status.get(platform_name) == "ABONAMENT":
                continue
                
            services_status[platform_name] = status

    return services_status
    

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

        if isinstance(data, dict):
            models = data.get("models", [])
        elif isinstance(data, list):
            models = data
        else:
            models = []

        if models and isinstance(models[0], dict):
            rel_url = models[0].get("url", "")
            full_url = f"https://upflix.pl{rel_url}" if rel_url else None
            platforms = get_upflix_platforms(full_url) if full_url else []
            
            return (full_url, platforms)

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

    try:
        existing_folders = os.listdir(movies_dir)
        for folder in existing_folders:
            cleaned_folder = IGNORE_SUFFIXES_PATTERN.sub('', folder)
            
            if cleaned_folder.lower() == expected_folder_name.lower():
                return 1
    except OSError:
        pass

    return 0