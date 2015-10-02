require 'spec_helper'

module WIP::Checklist::Commands
  describe Help do
    subject(:command) { Help.new(io) }

    describe '#run' do
      context 'given no arguments' do
        it 'executes' do
          expect { command.run }.to show <<-HELP
            Usage: wip-checklist COMMAND [options]

            Commands:
                console                          Starts a REPL console session
                help                             Prints context-relevant help
                version                          Prints version information

            Options:
                -h, --help                       Prints help messages
          HELP
        end
      end

      context 'given arguments as "--help"' do
        it 'shows help' do
          expect { command.run(['--help']) }.to show <<-HELP
            Usage: wip-checklist help [options]

            Description:
                Prints context-relevant help

            Options:
                    --example                    An example option
                -h, --help                       Prints help messages
          HELP
        end
      end

      context 'given arguments as "help"' do
        it 'shows help' do
          expect { command.run(['help']) }.to show <<-HELP
            Usage: wip-checklist help [options]

            Description:
                Prints context-relevant help

            Options:
                    --example                    An example option
                -h, --help                       Prints help messages
          HELP
        end
      end

      context 'given arguments as "version`"' do
        it 'shows help' do
          expect { command.run(['version']) }.to show <<-HELP
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
