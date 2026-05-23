# setup-flatrun

Downloads a pinned release of the [FlatRun CLI](https://github.com/flatrun/cli), places the binary on `PATH`, and returns its install path.

## Usage

```yaml
- uses: flatrun/actions/setup-flatrun@v1
  with:
    version: 0.1.0

- run: flatrun version
```

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `version` | Yes | | CLI release to install. With or without `v` prefix. |
| `install-dir` | No | `$RUNNER_TOOL_CACHE/flatrun/<version>/<arch>` | Directory the binary is placed in. |
| `repository` | No | `flatrun/cli` | Source repo for release assets. |

## Outputs

| Output | Description |
|--------|-------------|
| `version` | The CLI version that was installed. |
| `path` | Absolute path to the installed `flatrun` binary. |

## Authentication

This action does not handle credentials. Configure the CLI in the same step that runs it:

```yaml
- run: flatrun deployment deploy api
  env:
    FLATRUN_URL: ${{ vars.FLATRUN_URL }}
    FLATRUN_TOKEN: ${{ secrets.FLATRUN_TOKEN }}
```

Keep `FLATRUN_TOKEN` in `secrets`. `FLATRUN_URL` is non-sensitive and belongs in `vars` (or hard-coded per environment).

## Requirements

The runner needs `bash`, `gh`, `tar` (for `.tar.gz` assets), and `unzip` (for `.zip` assets). GitHub-hosted runners include all four. The action authenticates `gh` with `github.token`, which is sufficient for downloading public release assets.

## Supported platforms

- Linux x86_64 / arm64
- macOS x86_64 / arm64

Windows is not yet supported.
