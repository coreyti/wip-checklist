module WIP
  module Checklist
    module Commands
      class Help < Base
        DESCRIPTION = "Prints context-relevant help"

        def execute(args, options)
          io.say("HELP: #{args.inspect}")
        end
      end
    end

    Runner.register(Commands::Help)
  end
end
