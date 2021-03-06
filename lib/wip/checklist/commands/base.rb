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
          @parser = self.class.const_get(:Parser).new(io, metadata)
        end

        def run(args = [])
          parser.run(args) do |options|
            execute(args, options)
          end
        end

        protected

        def execute(args, options)
          raise NotImplementedError
        end

        def metadata
          {
            prelude:     prefix,
            description: self.class.description
          }
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

          def initialize(io, metadata)
            @io   = io
            @opts = OptionParser.new do |opts|
              opts.banner = "Usage: #{metadata[:prelude]} [options]"

              if description = metadata[:description]
                opts.separator ""
                opts.separator "Description:"
                opts.separator "    #{description}"
              end

              opts.separator ""
              opts.separator "Options:"

              opts.on_tail "-h", "--help", "Prints help messages" do
                options.help = true
              end
            end
          end

          def help
            io.say(@opts.help)
          end

          def run(args)
            @opts.parse!(args)
            options.help ? help : (yield options)
          rescue OptionParser::InvalidOption
            help
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
