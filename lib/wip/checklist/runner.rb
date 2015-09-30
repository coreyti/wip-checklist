module WIP
  module Checklist
    class Runner
      attr_reader :io, :parser

      def initialize(io = HighLine.new)
        @io     = io
        @parser = Parser.new(io, 'wip-checklist')
      end

      def run(args = [])
        parser.run(args)
      end

      private

      class Parser
        attr_reader :io

        def initialize(io, prefix = nil)
          @io   = io
          @opts = OptionParser.new do |opts|
            opts.banner  = "Usage: #{prefix} COMMAND [options]"

            opts.separator ""
            opts.separator "Commands:"

            commands = [:help, :version]
            commands.each do |name|
              prefix  = "    #{name}"
              padding = " " * (opts.summary_width - name.length + 1)
              opts.separator [prefix, padding, "#{name} description"].join('')
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
