# 1. Lua project

Date: 2026-09-20

## Status

Accepted

## Context

A new project is being started that will be implemented in Lua.

The project targets Lua 5.1 / LuaJIT (the Neovim runtime). This is also a tooling constraint: [selene](https://github.com/Kampfkarren/selene) release binaries cannot parse Lua 5.2+ syntax (`//`, `<const>`, `goto`, bitwise operators) as of 0.31 ([selene#645](https://github.com/Kampfkarren/selene/issues/645)), so 5.1 syntax is enforced at lint time.

## Decision

Use a standard layout for the project with the following details:
- Use [LuaRocks](https://luarocks.org/) as the package manager, installing into a project-local `lua_modules/` tree (`luarocks --tree lua_modules`). Dependencies are declared in the rockspec.
- Use [busted](https://lunarmodules.github.io/busted/) as the test framework, with [LuaCov](https://lunarmodules.github.io/luacov/) for coverage.
- Use [adr-tools](https://github.com/npryce/adr-tools) to document architectural decisions.
- Use [ast-grep](https://ast-grep.github.io/) rules (in `.ast-grep/rules/`) to disallow comments and misplaced `require` calls.

Use the following layout for the Lua project:

```plaintext
project-root/
├── lua/{{cookiecutter.package_name}}/
├── spec/
├── types/
└── docs/
```

`lua/` is the LuaRocks convention so `require("{{cookiecutter.package_name}}.module")` resolves without path hacks; `spec/` is the busted convention. `types/` holds `---@meta` stubs (currently busted's globals) for lua-language-server.

### Working with coding agents (and humans)

Much of the code in this project is configured to make working with LLM coding agents easier (and humans too!).
Agents often produce common problems (stray comments, dead code, near-duplicate code, requires buried inside functions, sprawling functions), so tooling is chosen to catch them at CI time:

- **No comments** ([ast-grep](https://ast-grep.github.io/) rules in `.ast-grep/rules/`).
  Code is expected to be self-documenting. `make lint` flags them and `make fix` strips them. Motivated by
  [Inside Out: Uncovering How Comment Internalization Steers LLMs for Better or Worse](https://arxiv.org/pdf/2512.16790),
  which shows LLMs lean heavily on comments and that this steers their output in
  unpredictable, model- and task-dependent ways. A small allowlist for exceptional cases:
  `---@` type annotations, `-- selene:`, `-- stylua:`, `-- luacov:`, and `-- WHY:` prefixed comments.
  Plain `---` doc comments are Lua's docstrings and are banned; only the `---@param`/`---@return` lines are kept.
- **Dead code is rejected immediately** ([selene](https://kampfkarren.github.io/selene/) `unused_variable`/`unreachable_code` and lua-language-server `unused-*` diagnostics, both at error level).
  Agents tend to leave behind unused functions, arguments, and variables; CI fails on them so they are removed in the same change that created them.
  Limitation: neither tool sees across files, so an exported `M.fn` that nothing calls is not caught (Python's vulture has no Lua analog).
- **Duplicate code**: [treepeat](https://github.com/dsummersl/treepeat) does not parse Lua yet. When it does, add an advisory `make treepeat` target as in the Python template.
- **Keep `require` at the top of the file** (ast-grep rule `no-require-in-function-lua`).
  Agents often add a `require` inside the function that needs it; prevent it.
- **Size and complexity limits** (`.github/scripts/check_complexity.sh`, built on ast-grep + jq).
  Cyclomatic complexity per function must stay at or below 5 (radon's grade A) and functions must be under 80 lines, to prevent overly long/complex functions. There is no maintainability-index tool for Lua; complexity plus length cover the intent.
- **Strict typing** ([lua-language-server](https://luals.github.io/) `--check` with the `strict` and `type-check` diagnostic groups at error level, configured in `.luarc.json`).
  Annotate with `---@param`/`---@return`/`---@class` [LuaCATS](https://luals.github.io/wiki/annotations/) annotations to enforce code boundaries. This is best-effort inference rather than a sound type system; [Teal](https://github.com/teal-language/tl) was rejected because it replaces the language rather than annotating it.
- **Formatting** ([StyLua](https://github.com/JohnnyMorganz/StyLua)). `make lint` checks, `make fix` applies.

## Consequences

- Five host binaries are needed beyond Lua itself (`stylua`, `selene`, `ast-grep`, `lua-language-server`, `jq`); LuaRocks only manages the pure-Lua test dependencies. CI installs them via `cargo binstall` and a GitHub release download.
- Lua has no single project config file; settings are spread across the rockspec, `.busted`, `.luacov`, `selene.toml`, `stylua.toml`, and `.luarc.json`.
- Cross-file dead-code detection and duplicate detection are gaps to revisit as tooling matures.
- Lua 5.2+ syntax is unavailable until selene ships builds with the `lua52`/`lua53`/`lua54` features (or the linter is swapped for luacheck).
