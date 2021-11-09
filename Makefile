GITHUB_ORG = opencontainers

SHELL = /usr/bin/env bash

.PHONY: clone-all
clone-all:
	[[ -f repos.json ]] || curl -sL -o repos.json https://api.github.com/orgs/$(GITHUB_ORG)/repos
	mkdir -p repos/
	for repo in `cat repos.json | jq -r '.[] | [.name,.clone_url] | join("|")'`; do \
		name=`echo $$repo | cut -d "|" -f1`; \
		clone_url=`echo $$repo | cut -d "|" -f2`; \
		[[ -d repos/$$name ]] || git clone $$clone_url repos/$$name; \
	done

.PHONY: gen-stats
gen-stats: clone-all
gen-stats:
	rm -f stats.html
	echo "<!DOCTYPE html><html><head><title>Stats for repos in $(GITHUB_ORG)</title>" > stats.html
	echo "<style>pre{display:inline;background:#fdf0dd;padding:0px 3px 0px 3px;border:1px dotted #a99797;border-radius:3px}</style></head>" >> stats.html
	echo "<body><h1>Stats for repos in <pre style='display:inline'>$(GITHUB_ORG)</pre></h1>" >> stats.html
	echo "Generated: <b>`date +"%Y-%m-%dT%H:%M:%S%z"`</b><br/><br/>" >> stats.html
	num_repos=`find repos -type d -maxdepth 1 -mindepth 1 | wc -l | xargs`
	echo "Total repos: <b>`find repos -type d -maxdepth 1 -mindepth 1 | wc -l | xargs`</b>" >> stats.html
	for repo in `cd repos && find . -type d -maxdepth 1 -mindepth 1 | sed "s|^\./||" | sort`; do \
		./gen-html-for-repo.sh $$repo >> stats.html; \
	done
	echo "<br/><br/><br/></body></html>" >> stats.html
