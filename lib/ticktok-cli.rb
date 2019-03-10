$:.unshift(File.expand_path("../", __FILE__))
require "ticktok_cli/version"

module TicktokCli
  autoload :Help, "ticktok_cli/help"
  autoload :Command, "ticktok_cli/command"
  autoload :CLI, "ticktok_cli/cli"
end
