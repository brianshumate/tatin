# Using mise in Tatin

`mise` (mise-en-place) is a versatile version manager for programming languages and
tools. mise helps consistently install and manage multiple versions of
programming languages and tools, and features other conveniences for development environments.

`mise` is already installed and ready to use.

## These languages and tools are already installed with mise

- Go
- Node.js
- Python
- Rust

## Installing languages and tools

### Ruby

```bash
mise install ruby@latest
mise use --global ruby@latest
```

## Managing multiple versions

List installed versions:

```bash
mise ls
```

List all available versions of a tool:

```bash
mise ls-remote python
mise ls-remote go
```

Set a version for the current directory:

```bash
cd /path/to/project
mise use python@3.11
```

## Activation

mise is automatically activated in your shell.

```bash
eval "$(~/.local/bin/mise activate bash)"
```

## Configuration mise on a per-project basis

Create a `mise.toml` file in your project to declare tool requirements:

```toml
[tools]
python = "3.12"
go = "1.23.5"
node = "22"
```

When you enter the directory, `mise` automatically installs the specified tools.

## Global configuration

Set global defaults:

```bash
mise use --global python@3.12
mise use --global go@1.23.5
```

This creates `~/.config/mise/config.toml`.

## More Information

- [mise](https://mise.jdx.dev/)
- [mise configuration](https://mise.jdx.dev/configuration.html)
