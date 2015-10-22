require 'git'

module WIP
  module Checklist
    module Commands::Wiki
      class List < Commands::Base
        DESCRIPTION = "Prints an index of checklists"

        def execute(args, options)
          list(args, options).each_with_index do |entry, index|
            io.say("  #{index + 1}. #{entry}")
          end
        end

        def list(args = nil, options = Options.new)
          urls = {}
          proj = Git.open(Dir.pwd)
          # TODO: handle projects with no remote.
          urls[:proj] = proj.remote.url
          urls[:wiki] = urls[:proj].sub(/\.git$/, '.wiki.git')
          # TODO...
          target = '/tmp/checklists/checklist.wiki'

          if File.exist?(target)
            wiki = Git.open(target)
            wiki.pull if options.update
          else
            wiki = Git.clone(urls[:wiki], 'checklist.wiki', path: '/tmp/checklists')
          end

          wiki.chdir { Dir.glob('**/*.md')}
        end

        private

        # class Parser < Base::Parser ; end
      end
    end

    Runner.register(Commands::Wiki::List)
  end
end
