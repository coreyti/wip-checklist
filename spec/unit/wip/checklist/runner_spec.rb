require 'spec_helper'

module WIP::Checklist
  describe Runner do
    subject(:runner) { WIP::Checklist::Runner.new }

    describe '#run' do
      context 'given no arguments' do
        it 'shows help' do
          expect { runner.run }
            .to show("Usage: wip-checklist COMMAND [options]")
        end
      end

      context 'given empty arguments' do
        it 'shows help' do
          expect { runner.run([]) }
            .to show("Usage: wip-checklist COMMAND [options]")
        end
      end

      context 'given arguments as "--help"' do
        it 'shows help' do
          expect { runner.run(['--help']) }
            .to show("Usage: wip-checklist COMMAND [options]")
        end
      end
    end

    describe Runner::Parser do
      subject(:parser) { runner.parser }

      describe '#help' do
        it 'shows general usage, including a list of commands' do
          expect { parser.help }.to show <<-HELP
            Usage: wip-checklist COMMAND [options]

            Commands:
                help                             help description
                version                          version description

            Options:
                -h, --help                       Prints help messages
          HELP
        end
      end
    end
  end
end
