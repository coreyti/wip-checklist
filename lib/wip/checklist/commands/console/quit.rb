module WIP
  module Checklist
    module Commands
      class Console::Quit < Base
        DESCRIPTION = "Quits this console session"

        def execute(args, options)
          io.say('Ciao!')
          exit 0
        end

        private

        # class Parser < Base::Parser ; end
      end
    end
  end
end
