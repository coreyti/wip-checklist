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
          # indent = io.indent_level

          loop do
            begin
              entry = read("→  ")
              io.indent_level += 1
              result = process(entry)
              io.indent_level -= 1
              return 0 if (result && result.exit?)
            end
          end

          return -1
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
