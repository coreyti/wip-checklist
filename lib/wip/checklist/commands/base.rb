module WIP
  module Checklist
    module Commands
      class Base
        class << self
          def command
            @command ||= self.name
              .split('::').last
              .gsub(/([A-Z])/, "-\\1")
              .sub(/^-/, '')
              .downcase.intern
          end

          def description
            self::DESCRIPTION
          rescue NameError
            nil
          end
        end

        attr_reader :io, :parser

        def initialize(io)
          @io     = io
          @parser = Parser.new(io, prefix)
        end

        def run(args)
          execute(args)
        end

        protected

        def execute(args)
          raise NotImplementedError
        end

        private

        def name
          @name ||= self.class.command
        end

        def prefix
          @prefix ||= ['wip-checklist', name].join(' ')
        end

        class Parser
          attr_reader :io

          def initialize(io, prefix = nil)
            @io   = io
            @opts = OptionParser.new do |opts|
              opts.banner  = "Usage: #{prefix} [options]"

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

          def run(args = [])
            return help if args.empty?

            @opts.parse!(args)
            options
          end

          private

          def options
            @options ||= WIP::Checklist::Options.new
          end
        end
      end
    end
  end
end
