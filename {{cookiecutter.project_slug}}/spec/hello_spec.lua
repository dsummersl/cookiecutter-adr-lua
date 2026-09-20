local hello = require("{{ cookiecutter.package_name }}.hello")

describe("hello", function()
  it("greets the world", function()
    assert.are.equal("hello world", hello.world())
  end)
end)
