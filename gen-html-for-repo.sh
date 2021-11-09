#!/usr/bin/env bash

set -e

REPO="${1}"
if [[ "${REPO}" == "" ]]; then
    echo "Usage: ./gen-html-for-repo.sh <repo>"
    exit 1
fi

echo "<h2><pre>${REPO}</pre></h2>"
