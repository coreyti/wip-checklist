module Support
  class ExampleCommand < WIP::Checklist::Commands::Base
    DESCRIPTION = 'Example command'

    attr_reader :calls

    def initialize(*)
      super
      @calls = 0
    end

    protected

    def execute(args)
      @calls += 1
    end
  end
end
