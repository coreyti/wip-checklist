require 'git'

module WIP
  module Checklist
    module Commands::Wiki
      class Save < Commands::Base
        DESCRIPTION = "Saves checklists"

        def execute(args, options)
          @args = args

          target = '/tmp/checklists/checklist.wiki'
          wiki   = Git.open(target)
          wiki.config('user.name',  'Corey Innis')
          wiki.config('user.email', 'corey@coolerator.net')
          path   = filepath
          file   = wiki.chdir {
            wiki.add(path)
            wiki.commit(message)
            wiki.push
          }
        end

        private

        def filepath
          path = @args[0]

          if path.is_a?(Fixnum) || path.match(/^\d+$/)
            list = Commands::Wiki::List.new(io).list
            path = list[path.to_i - 1]
          end

          path
        end

        def message
          @args[1..-1].join(' ')
        end

        # class Parser < Base::Parser ; end
      end
    end

    Runner.register(Commands::Wiki::Save)
  end
end
