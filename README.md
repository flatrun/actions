# FlatRun GitHub Actions

Composite actions for running the [FlatRun CLI](https://github.com/flatrun/cli) in GitHub Actions workflows.

## Actions

| Action | Purpose |
|--------|---------|
| [`flatrun/actions/setup-flatrun`](./setup-flatrun) | Install the `flatrun` CLI on the runner and add it to `PATH`. |

Higher-level wrappers (`deploy`, `api`, ...) are intentionally not provided. Once `setup-flatrun` has put the binary on `PATH`, any FlatRun command is a single `run:` step away. Centralizing logic in the CLI keeps the action surface thin and avoids version skew between an action and the verb it wraps.

## Quick start

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: flatrun/actions/setup-flatrun@v1
        with:
          version: 0.3.0
      - run: flatrun deployment deploy api
        env:
          FLATRUN_URL: ${{ vars.FLATRUN_URL }}
          FLATRUN_TOKEN: ${{ secrets.FLATRUN_TOKEN }}
```

See [`examples/`](./examples) for fuller workflows.

## Releasing

The version lives in `VERSION`. Changing it on `main` releases it: the tag is created, `v1` moves
to it, and the release notes come from the matching `CHANGELOG.md` heading. A release run against
an unchanged `VERSION` fails rather than releasing the same thing twice.

## Versioning

Each action is consumed by Git ref. Recommended pinning, in order of strictness:

1. Commit SHA: `uses: flatrun/actions/setup-flatrun@<sha>` (auditable, immutable)
2. Release tag: `uses: flatrun/actions/setup-flatrun@v1.2.3`
3. Major tag: `uses: flatrun/actions/setup-flatrun@v1` (tracks the latest 1.x)

Major tags are moved on every release within the same major version. Use SHA pinning in security-sensitive workflows.

## Compatibility

| Runner | Supported |
|--------|-----------|
| GitHub-hosted (Ubuntu, macOS) | Yes |
| Self-hosted Linux/macOS x86_64/arm64 | Yes, if `gh`, `tar`, and `curl` are available |
| Windows | Not yet |

## Development

Lint:

```bash
docker run --rm -v "$(pwd):/repo" rhysd/actionlint:latest -color
```

Each action is a standalone directory with an `action.yml`. Keep them dependency-free at the action layer; push logic into the CLI.
