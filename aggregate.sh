#!/usr/bin/env bash

uniq -f1 result | awk '{sum[$1]+=1} END {for (key in sum) {print key, sum[key]}}' > aggregated.result