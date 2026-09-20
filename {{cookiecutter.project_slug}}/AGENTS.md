# Agent Guidelines

This file provides guidance when working with code in this repository.

## Project Overview

See this projects README.md for an overview of the project, and ADR documents in docs/adr/ for architectural decisions.

## Development Commands

**IMPORTANT**: Always use the Makefile commands for development tasks.

### Setup
```bash
make setup  # Install rocks into the local lua_modules/ tree
```

### Testing
```bash
make test                                              # Run all tests with busted and coverage
eval $(luarocks --tree lua_modules path --bin) && busted spec/hello_spec.lua   # Run specific test file
eval $(luarocks --tree lua_modules path --bin) && busted --filter "greets"    # Run tests matching a name
```

### Code Quality
```bash
make lint        # Check code with selene, stylua, and ast-grep
make fix         # Strip comments (ast-grep) and format (stylua)
make type        # Type check with lua-language-server (strict diagnostics)
make complexity  # Check cyclomatic complexity and function length
make ci          # Run all CI checks (test + lint + type + complexity)
```

**Before completing any feature**, run `make ci` to ensure all checks pass.

## Code Quality Requirements

Writing guidance:

- No comments. Use `---@param`/`---@return`/`---@class` annotations on every public function; no `---` prose lines.
- Modules return a local table `M`; no globals.
- `require` calls at the top of the file only.

## Project Structure

```
lua/{{cookiecutter.package_name}}/   # Main package source code
spec/                # busted tests (mirror lua/{{cookiecutter.package_name}}/ structure, named *_spec.lua)
types/               # ---@meta stubs for lua-language-server
docs/adr/            # Architecture Decision Records
```
