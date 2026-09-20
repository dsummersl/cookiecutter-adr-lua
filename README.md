# Overview

A [cookiecutter](https://github.com/cookiecutter/cookiecutter) template that creates a basic Lua project.
- Includes [adr-tools](https://github.com/npryce/adr-tools) to record architectural decisions

Lua sibling of [cookiecutter-adr-python](https://github.com/dsummersl/cookiecutter-adr-python).

## Usage

```bash
uvx cookiecutter gh:dsummersl/cookiecutter-adr-lua
```

## Tooling required on the host

`make setup` installs Lua rocks into a local `lua_modules/` tree, but these binaries must already be on `PATH`:

- [lua](https://www.lua.org/) and [luarocks](https://luarocks.org/)
- [stylua](https://github.com/JohnnyMorganz/StyLua)
- [selene](https://github.com/Kampfkarren/selene)
- [ast-grep](https://ast-grep.github.io/)
- [lua-language-server](https://luals.github.io/)
- [jq](https://jqlang.github.io/jq/)
