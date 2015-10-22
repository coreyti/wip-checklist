require 'spec_helper'

module WIP::Checklist::Commands
  describe Version do
    subject(:command) { Version.new(io) }

    describe '#run' do
      it 'executes' do
        expect { command.run }
          .to show('wip-checklist version 0.1.0')
      end

      context 'given arguments as "--help"' do
        it 'shows help' do
          expect { command.run(['--help']) }.to show <<-HELP
            Usage: wip-checklist version [options]

            Description:
                Prints version information

            Options:
                -h, --help                       Prints help messages
          HELP
        end
      end
    end
  end
end
