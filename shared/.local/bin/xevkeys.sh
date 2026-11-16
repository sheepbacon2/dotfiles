xev | awk '$0 ~ /key/ { gsub (/\)\,$/, "",$7); print $3,$4,$7}'
