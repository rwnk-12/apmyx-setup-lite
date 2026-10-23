#!/bin/sh
set -eu
IFS= read -r username
IFS= read -r password
exec /app/wrapper-lite --login "$username:$password" --code-from-file --base-dir /data
