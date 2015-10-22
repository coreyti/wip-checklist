require "highline"
require "optparse"

require "wip/checklist/version"
require "wip/checklist/runner"
require "wip/checklist/editor"
require "wip/checklist/commands"
require "wip/checklist/options"
require "wip/checklist/collections"
require "wip/checklist/models"

module WIP
  module Checklist
    class Error < ::StandardError ; end
    class UnknownCommandError < Error ; end
  end
end
