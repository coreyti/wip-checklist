module WIP
  module Checklist
    module Commands
      class Base
        class << self
          def description
            self::DESCRIPTION
          rescue NameError
            nil
          end
        end

        attr_reader :io

        def initialize(io)
          @io = io
        end

        def run(args)
          execute(args)
        end

        protected

        def execute(args)
          raise NotImplementedError
        end
      end
    end
  end
end
