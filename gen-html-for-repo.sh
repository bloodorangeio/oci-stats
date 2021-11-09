#!/usr/bin/env bash

set -e

REPO="${1}"
if [[ "${REPO}" == "" ]]; then
    echo "Usage: ./gen-html-for-repo.sh <repo>"
    exit 1
fi

function extract_field {
    local field="${1}"
    cat repos.json | jq -r ".[] | select(.name == \"${REPO}\") | .${field}"
}

echo "<h2><pre>${REPO}</pre></h2>"

URL="$(extract_field html_url)"
STARS="$(extract_field stargazers_count)"
FORKS="$(extract_field forks)"
OPEN_ISSUES="$(extract_field open_issues_count)"
LANGUAGE="$(extract_field language)"
[[ "${LANGUAGE}" != "null" ]] || LANGUAGE="?"
DEFAULT_BRANCH="$(extract_field default_branch)"
IS_ARCHIVED="$(extract_field archived)"

HAS_CODEOWNERS="$([[ -f repos/${REPO}/CODEOWNERS ]] && echo ✅ || echo ❌)"
HAS_GITHUB_ACTIONS="$([[ -d repos/${REPO}/.github/workflows/ ]] && echo ✅ || echo ❌)"

NO_CIRCLE="$([[ -d repos/${REPO}/.circleci/ ]] && echo ❌ || echo ✅)"
NO_TRAVIS="$([[ -f repos/${REPO}/.travis.yml ]] && echo ❌ || echo ✅)"
NO_PULLAPPROVE="$([[ -f repos/${REPO}/.pullapprove.yml ]] && echo ❌ || echo ✅)"

TIME_CREATED="$(extract_field created_at)"

# This includes updates to PRs, so ignore it
#TIME_PUSHED="$(extract_field pushed_at)"
TIME_PUSHED="$(cd repos/${REPO}/ && git log -1 --format=%cd )"

TIME_UPDATED="$(extract_field updated_at)"

echo "<table>"
echo "<tr><td>URL:</td><td><a href=\"${URL}\" target=\"_blank\">${URL}</a></td></tr>"
echo "<tr><td>Stars:</td><td><b>${STARS}</b></td></tr>"
echo "<tr><td>Forks:</td><td><b>${FORKS}</b></td></tr>"

echo "<tr><td>Language:</td><td><b>${LANGUAGE}</b></td></tr>"
echo "<tr><td>Created:</td><td><b>${TIME_CREATED}</b></td></tr>"
echo "<tr><td>Last update:</td><td><b>${TIME_UPDATED}</b></td></tr>"
echo "<tr><td>Last commit:</td><td><b>${TIME_PUSHED}</b></td></tr>"
echo "<tr><td>Open issues (including PRs):</td><td><b>${OPEN_ISSUES}</b></td></tr>"

if [[ "${IS_ARCHIVED}" == "true" ]]; then
    echo "<tr><td>Is archived?</td><td><b style='color:#b16d06'>yes</b></td></tr>"
else
    echo "<tr><td>Is archived?</td><td><b>no</b></td></tr>"
fi

if [[ "${DEFAULT_BRANCH}" == "master" ]]; then
    echo "<tr><td>Default branch:</td><td><b><pre style='background:#ffbfbf'>${DEFAULT_BRANCH}</pre></b></td></tr>"
else
    echo "<tr><td>Default branch:</td><td><b><pre>${DEFAULT_BRANCH}</pre></b></td></tr>"
fi

echo "<tr><td>Has CODEOWNERS?</td><td>${HAS_CODEOWNERS}</b></td></tr>"
echo "<tr><td>Has GitHub Actions?</td><td>${HAS_GITHUB_ACTIONS}</b></td></tr>"
echo "<tr><td>CircleCI removed?</td><td>${NO_CIRCLE}</b></td></tr>"
echo "<tr><td>Travis CI removed?</td><td>${NO_TRAVIS}</b></td></tr>"
echo "<tr><td>PullApprove removed?</td><td>${NO_PULLAPPROVE}</b></td></tr>"


echo "</table><br/>"
