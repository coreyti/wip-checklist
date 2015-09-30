module WIP
  module Checklist
    module Commands
      class Base
        class << self
          def title
            name.split('::').last
              .gsub(/([A-Z])/, "-\\1").sub(/^-/, '')
              .downcase
          end

          def description
            self::DESCRIPTION
          end
        end
      end
    end
  end
end
