# tftidy

`tftidy` is a Terraform cleanup CLI that removes transient top-level blocks from `.tf` files:

- `moved`
- `removed`
- `import`

It is useful for post-migration cleanup when those blocks are no longer needed.

## Features

- Removes one or more block types (`moved`, `removed`, `import`)
- Supports selective cleanup with `--type`
- Supports dry-run mode (`--dry-run`)
- Preserves original file permissions when writing
- Skips writes when no target block exists
- Recursively discovers `.tf` files via `github.com/boyter/gocodewalker`
- Excludes cache directories:
  - `.terraform`
  - `.terragrunt-cache`

## Installation

### Build from source

```bash
go build -o tftidy ./cmd/tftidy
```

### Run with Go

```bash
go run ./cmd/tftidy --help
```

## Usage

```text
tftidy [options] [directory]
```

If `directory` is omitted, `.` is used.

### Options

- `-t, --type string`
  - Comma-separated block types to remove
  - Default: `moved,removed,import`
  - Valid values: `moved`, `removed`, `import`, `all`
- `-n, --dry-run`
  - Preview changes without modifying files
- `-v, --verbose`
  - Print each file being processed
- `--normalize-whitespace`
  - Normalize consecutive blank lines after removal
- `--version`
  - Print version
- `-h, --help`
  - Print help

### Examples

Remove all supported block types in current directory:

```bash
tftidy
```

Remove only `moved` blocks under `./infra`:

```bash
tftidy --type moved ./infra
```

Remove `moved` and `import` blocks with whitespace normalization:

```bash
tftidy --type moved,import --normalize-whitespace ./terraform
```

Preview only (no file writes):

```bash
tftidy --dry-run ./terraform
```

## Output

The command prints a processing summary including:

- files processed
- files modified
- files errored
- removed block counts per type and total

## Exit codes

- `0`: success
- `1`: runtime/file processing error(s)
- `2`: usage/argument error

When file processing errors occur, `tftidy` continues processing other files and exits with `1` at the end.

## Development

```bash
go test -v ./...
go test -race ./...
go build -v ./cmd/tftidy
```
