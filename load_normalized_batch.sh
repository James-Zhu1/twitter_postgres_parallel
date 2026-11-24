#!/bin/sh

# load a single data file (passed as $1) into the pg_normalized_batch database
python3 -u load_tweets_batch.py --db=postgresql+psycopg2://postgres:pass@localhost:11693/ --inputs "$1"
