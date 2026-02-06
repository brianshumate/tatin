# Using mise in Tatin

mise (mise-en-place) is a versatile version manager for programming languages and
tools. Unlike the original setup, Tatin no longer pre-installs languages. You can
install them yourself using the instructions below.

## Installing mise

mise is already installed at `$HOME/.local/bin/mise`. If you need to reinstall:

```bash
curl --retry 3 --retry-delay 2 --retry-max-time 60 -fsSL https://mise.run/bash | sh
```

## Installing Languages and Tools

### Python

```bash
mise install python@3.12
mise use --global python@3.12
```

### Go

```bash
mise install go@1.23.5
mise use --global go@1.23.5
```

### Node.js

```bash
mise install node@lts
mise use --global node@lts
```

### Rust

```bash
mise install rust@latest
mise use --global rust@latest
```

### Ruby

```bash
mise install ruby@latest
mise use --global ruby@latest
```

## Managing Multiple Versions

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

Add mise to your shell for automatic tool activation:

```bash
eval "$(~/.local/bin/mise activate bash)"
```

Or add to ~/.bashrc permanently:

```bash
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
```

## Configuration File

Create a `mise.toml` file in your project to declare tool requirements:

```toml
[tools]
python = "3.12"
go = "1.23.5"
node = "22"
```

When you enter the directory, mise will automatically install the specified tools.

## Global Configuration

Set global defaults:

```bash
mise use --global python@3.12
mise use --global go@1.23.5
```

This creates `~/.config/mise/config.toml`.

## More Information

- https://mise.jdx.dev/
- https://mise.jdx.dev/configuration.html
