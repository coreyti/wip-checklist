module WIP
  module Checklist
    module Commands
      class Console < Base
        DESCRIPTION = "Starts a REPL console session"

        attr_reader :runner

        def initialize(*)
          super
          @runner = WIP::Checklist::Runner.new(io)

          Runner.deregister(Commands::Console)
          Runner.register(Commands::Console::Quit)
        end

        def execute(args, options)
          start
        end

        private

        def start
          io.indent_size = 4

          loop do
            begin
              entry = read("→   ")
              io.indent_level += 1
              result = process(entry)
              io.indent_level -= 1
            end
          end
        end

        def process(entry)
          args = entry.split(/\s+/)
          runner.run(args)
        end

        def read(prompt)
          command = io.ask(prompt) do |line|
            line.whitespace = :strip_and_collapse
            line.validate   = nil
            line.readline   = true
            # line.completion = ...
          end
        end
      end
    end

    Runner.register(Commands::Console)
  end
end
