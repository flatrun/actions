# Changelog

All notable changes to the FlatRun GitHub Actions are documented in this file.

## [1.0.0] - 2026-08-11

First tagged release. The actions were usable from `main` before this, but nothing resolved
`@v1`, which is what the README tells people to pin, so every documented example was broken.

### Added

- `setup-flatrun` installs a pinned FlatRun CLI release on the runner and puts it on `PATH`,
  taking the binary from the release assets and caching it in the runner tool cache. The source
  repository can be overridden to install from a fork.
- A `v1` tag that moves with each 1.x release, so `@v1` tracks the latest without a workflow edit,
  alongside the exact `v1.0.0` tag for anyone pinning strictly.

### Changed

- The examples install CLI 0.3.0, the first version whose command surface covers the whole agent
  API.
