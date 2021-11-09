# oci-stats

[![GitHub Actions status](https://github.com/bloodorangeio/oci-stats/workflows/build/badge.svg)](https://github.com/bloodorangeio/oci-stats/actions?query=workflow%3Abuild)

This repo contains some scripts to generate a simple HTML
report summarizing repositories in the
[`opencontainers`](https://github.com/opencontainers)
GitHub organization.

For an example of the report, please see
[`stats-exammple.html`](./stats-example.html).

## How to use

Run the following:

```
make gen-stats
```

This will produce the file `stats.html` which can then
be viewed in your web browser.
