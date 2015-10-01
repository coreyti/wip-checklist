module WIP
  module Checklist
    module Commands
      class Version < Base
        DESCRIPTION = "Prints version information"

        def execute(args, options)
          io.say("wip-checklist version #{WIP::Checklist::VERSION}")
        end

        private

        class Parser < Base::Parser
          def initialize(io)
            super(io, 'wip-checklist version', Version.description)
            # super(io, Version.metadata)
          end
        end
      end
    end

    Runner.register(Commands::Version)
  end
end
