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
            # Runner::Parser.new(io, metadata)
          else
            command = Runner.command(args.first).new(io)
            command.parser
          end
        end

        class Parser < Base::Parser
          def initialize(io, metadata)
            super

            @opts.on("--example", "An example option") do
              options.example = true
            end
          end
        end
      end
    end

    Runner.register(Commands::Help)
  end
end
