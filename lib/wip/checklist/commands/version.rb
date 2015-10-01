module WIP
  module Checklist
    module Commands
      class Version < Base
        DESCRIPTION = "Prints version information"

        def execute(args, options)
          io.say("wip-checklist version #{WIP::Checklist::VERSION}")
        end
      end
    end

    Runner.register(Commands::Version)
  end
end
