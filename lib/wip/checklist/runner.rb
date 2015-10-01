module WIP
  module Checklist
    class Runner
      class << self
        @@commands = []

        def command(name)
          match = @@commands.find do |implementation|
            implementation.command == name.intern
          end

          if match.nil?
            raise UnknownCommandError.new("Command '#{name}' was not found")
          end

          match
        end

        def commands
          @@commands
        end

        def deregister(implementation)
          @@commands.reject! do |registered|
            registered == implementation
          end
        end

        def register(implementation)
          @@commands << implementation
        end
      end

      attr_reader :io, :parser

      def initialize(io = HighLine.new)
        @io     = io
        @parser = Parser.new(io, 'wip-checklist')
      end

      def run(args = [])
        handler = (command(args) || parser)
        handler.run(args)
      rescue UnknownCommandError
        Parser.new(io, 'wip-checklist').help
      end

      private

      def command(args)
        args.first.tap do |candidate|
          return nil if candidate.nil? || candidate.match(/^-/)
        end

        self.class.command(args.shift).new(io)
      end

      class Parser
        attr_reader :io

        def initialize(io, prefix = nil)
          @io   = io
          @opts = OptionParser.new do |opts|
            opts.banner  = "Usage: #{prefix} COMMAND [options]"

            opts.separator ""
            opts.separator "Commands:"

            Runner.commands.each do |implementation|
              name    = implementation.command
              term    = "    #{name}"
              padding = " " * (opts.summary_width - name.length + 1)
              opts.separator [term, padding, implementation.description].join('')
            end

            opts.separator ""
            opts.separator "Options:"

            opts.on_tail   "-h", "--help", "Prints help messages" do
              io.say(opts)
            end
          end
        end

        def help
          io.say(@opts.help)
        end

        def run(args)
          return help if args.empty?
          @opts.parse!(args)
        end
      end
    end
  end
end
