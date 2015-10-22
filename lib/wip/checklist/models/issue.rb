module WIP
  module Checklist
    module Models
      class Issue
        attr_reader :path, :title, :client

        def initialize(path, title)
          @path   = path
          @title  = title
          @client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
        end

        def create
          client.create_issue('coreyti/checklist', title, content)
        end

        private

        def content
          File.read(fullpath)
        end

        def fullpath
          # huh? why is it not working to use the attr_reader?
          if @path.is_a?(Fixnum) || @path.match(/^\d+$/)
            list = Commands::Wiki::List.new(io).list
            @path = list[@path.to_i - 1]
          end

          File.join('/tmp/checklists/checklist.wiki', @path)
        end
      end
    end
  end
end
