.PHONY: setup test lint type dead fix complexity ci

ROCKSPEC := {{ cookiecutter.project_slug }}-dev-1.rockspec
LUAROCKS := luarocks --tree lua_modules
ROCKS := eval $$($(LUAROCKS) path --bin) &&

setup:
	$(LUAROCKS) install --only-deps $(ROCKSPEC)
	$(LUAROCKS) install busted
	$(LUAROCKS) install luacov

test:
	$(ROCKS) busted
	@sed -n '/^Summary/,$$p' luacov.report.out

lint:
	selene lua spec
	stylua --check lua spec
	ast-grep scan lua spec

fix:
	-ast-grep scan --update-all lua spec
	stylua lua spec

type:
	lua-language-server --check . --checklevel=Warning --logpath=.luals --configpath=.luarc.json

complexity:
	.github/scripts/check_complexity.sh

ci: test lint type complexity
