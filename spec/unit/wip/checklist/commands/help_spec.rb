require 'spec_helper'

module WIP::Checklist::Commands
  describe Help do
    subject(:command) { Help.new(io) }

    describe '#run' do
      it 'executes' do
        expect { command.run(['argument']) }
          .to show('HELP: ["argument"]')
      end

      context 'given arguments as "--help"' do
        it 'shows help' do
          expect { command.run(['--help']) }.to show <<-HELP
            Usage: wip-checklist help [options]

            Description:
                Prints context-relevant help

            Options:
                -h, --help                       Prints help messages
          HELP
        end
      end
    end
  end
end
