require 'octokit'

module WIP
  module Checklist
    module Commands::Issues
      class Create < Commands::Base
        DESCRIPTION = "Creates issues"

        # Oktokit.auto_paginate = true
        # issues = client.issues 'coreyti/checklist'
        def execute(args, options)
          @args = args
          issue = Models::Issue.new(wiki, title)
          issue.create
        end

        private

        def wiki
          @args[0]
        end

        def title
          @args[1..-1].join(' ')
        end

        # class Parser < Base::Parser ; end
      end
    end

    Runner.register(Commands::Issues::Create)
  end
end
