#!/bin/bash

files=$(find data/*)

echo '================================================================================'
echo 'load denormalized'
echo '================================================================================'
time for file in $files; do
    echo
    # use SQL's COPY command to load the raw json into pg_denormalized;
    # the sed command removes escaped null characters (\u0000), which JSONB does not support
    unzip -p "$file" \
        | sed 's/\\u0000//g' \
        | psql postgresql://postgres:pass@localhost:11691/ -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
done

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
time for file in $files; do
    echo
    python3 -u load_tweets.py --db=postgresql+psycopg2://postgres:pass@localhost:11692/ --inputs "$file"
done

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
time for file in $files; do
    python3 -u load_tweets_batch.py --db=postgresql+psycopg2://postgres:pass@localhost:11693/ --inputs $file
done
