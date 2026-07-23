import argparse
from db import build_database

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Create sqlite db from Letterboxd watchlist and check it on Upflix."
    )

    parser.add_argument(
        "username", 
        type=str, 
        help="Valid Letterboxd username"
    )

    parser.add_argument(
        "-d", "--dir",
        type=str,
        default=None,
        help="Optional path to local movies directory"
    )

    args = parser.parse_args()
    build_database(args.username, movies_dir=args.dir)