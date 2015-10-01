module WIP
  module Checklist
    module Commands
      class Help < Base
        DESCRIPTION = "Prints context-relevant help"

        def execute(args, options)
          command_parser(args).help
        end

        private

        def command_parser(args)
          if args.empty?
            Runner::Parser.new(io, 'wip-checklist')
          else
            Runner.command(args.first).const_get(:Parser).new(io)
          end
        end

        class Parser < Base::Parser
          def initialize(io)
            super(io, 'wip-checklist help', Help.description)
          end
        end
      end
    end

    Runner.register(Commands::Help)
  end
end
