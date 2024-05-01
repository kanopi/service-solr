#!/usr/bin/env sh

[[ "$(netstat -ant | grep LISTEN | grep -E '*:8983.*LISTEN')" == "" ]] && exit 1

exit 0
