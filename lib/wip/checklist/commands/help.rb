module WIP
  module Checklist
    module Commands
      class Help < Base
        DESCRIPTION = "Prints context-relevant help"

        def execute(args)
          io.say("HELP: #{args.inspect}")
        end
      end
    end

    Runner.register(:help, Commands::Help)
  end
end
