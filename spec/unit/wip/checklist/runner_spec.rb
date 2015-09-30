require 'spec_helper'

describe WIP::Checklist::Runner do
  subject(:runner) { WIP::Checklist::Runner.new }

  describe '#run' do
    context 'given no arguments' do
      it 'prints help' do
        expect { runner.run }
          .to show("Usage: wip-checklist COMMAND [options]")
      end
    end

    context 'given empty arguments' do
      it 'prints help' do
        expect { runner.run([]) }
          .to show("Usage: wip-checklist COMMAND [options]")
      end
    end

    context 'given arguments as "--help"' do
      it 'prints help' do
        expect { runner.run(['--help']) }
          .to show("Usage: wip-checklist COMMAND [options]")
      end
    end
  end
end
