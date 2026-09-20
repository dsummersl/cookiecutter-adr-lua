rockspec_format = "3.0"
package = "{{ cookiecutter.project_slug }}"
version = "dev-1"

source = {
  url = "git+https://example.com/{{ cookiecutter.project_slug }}.git",
}

description = {
  summary = "{{ cookiecutter.project_desc }}",
  license = "{{ cookiecutter.license }}",
  maintainer = "{{ cookiecutter.author_name }} <{{ cookiecutter.author_email }}>",
}

dependencies = {
  "lua >= 5.1",
}

test_dependencies = {
  "busted >= 2.2.0",
  "luacov >= 0.15.0",
}

test = {
  type = "busted",
}

build = {
  type = "builtin",
  modules = {
    ["{{ cookiecutter.package_name }}"] = "lua/{{ cookiecutter.package_name }}/init.lua",
    ["{{ cookiecutter.package_name }}.hello"] = "lua/{{ cookiecutter.package_name }}/hello.lua",
  },
}
