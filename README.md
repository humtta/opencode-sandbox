# Hugo Marotta's OpenCode Sandbox

A Docker sandbox environment for [OpenCode], tailored for personal use.

## Requirements

- [Docker].

## Installation

First, clone the repository where you intend to keep it:

```sh
git clone https://github.com/humtta/opencode-sandbox
```

Then, `cd` into the cloned directory and install the launcher by creating a
symbolic link in `~/.local/bin`:

```
ln -fs "$(pwd)/opencode.sh" ~/.local/bin/ocs
```

## License

This project is licensed under the [MIT License].

[opencode]: https://opencode.ai
[docker]: https://www.docker.com
[mit license]: LICENSE.md
