#!/bin/sh

# load a single data file (passed as $1) into the pg_normalized database
python3 -u load_tweets.py --db=postgresql+psycopg2://postgres:pass@localhost:11692/ --inputs "$1"
