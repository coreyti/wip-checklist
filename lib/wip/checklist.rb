require "highline"
require "optparse"

require "wip/checklist/version"
require "wip/checklist/runner"
require "wip/checklist/commands"

module WIP
  module Checklist
    class Error < ::StandardError ; end
    class UnknownCommandError < Error ; end
  end
end
