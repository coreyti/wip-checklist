require 'git'

module WIP
  module Checklist
    module Commands::Wiki
      class Edit < Commands::Base
        class Editor
          include WIP::Checklist::Editor::Editors
        end

        DESCRIPTION = "Edits checklists"

        def initialize(*)
          super
          @editor = Editor.new
        end

        def execute(args, options)
          target = '/tmp/checklists/checklist.wiki'
          wiki   = Git.open(target)
          path   = filepath(args)

          @editor.edit(path)
        end

        private

        def filepath(args)
          path = args[0]

          if path.is_a?(Fixnum) || path.match(/^\d+$/)
            list = Commands::Wiki::List.new(io).list
            path = list[path.to_i - 1]
          end

          File.join('/tmp/checklists/checklist.wiki', path)
        end

        # class Parser < Base::Parser ; end
      end
    end

    Runner.register(Commands::Wiki::Edit)
  end
end
