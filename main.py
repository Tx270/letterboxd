import argparse


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Create sqlite db from Letterboxd watchlist and check it on Upflix."
    )

    parser.add_argument(
        "username", 
        type=str, 
        help="Valid Letterboxd username"
    )

    args = parser.parse_args()
    build_database(args.username)