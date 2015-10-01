require 'spec_helper'

module WIP::Checklist::Commands
  describe Base do
    subject(:command) { Base.new(io) }

    describe '.command' do
      it 'returns the name/label for the Command' do
        expect(Base.command).to eq(:base)
      end
    end

    describe '.description' do
      it 'returns nil' do
        expect(Base.description).to be_nil
      end
    end

    describe '#run' do
      it 'raises an error' do
        expect { command.run(nil) }
          .to raise_error(NotImplementedError)
      end
    end

    describe 'an example implementation' do
      subject(:command) { Support::ExampleCommand.new(io) }

      describe '.description' do
        it 'returns the Command description' do
          expect(Support::ExampleCommand.description)
            .to eq('Example command')
        end
      end

      describe '#run' do
        it 'executes the command' do
          expect { command.run(['argument']) }
            .to change { command.calls }
            .by(1)
        end
      end
    end

    describe Base::Parser do
      subject(:parser) { command.parser }

      describe '#help' do
        it 'shows help content' do
          expect { parser.help }.to show <<-HELP
            Usage: wip-checklist base [options]

            Options:
                -h, --help                       Prints help messages
          HELP
        end
      end

      describe '#run' do
        it 'returns parsed Options' do
          expect(parser.run(['argument'])).to be_a(WIP::Checklist::Options)
        end

        context 'given empty arguments' do
          it 'shows help' do
            expect { parser.run }
              .to show("Usage: wip-checklist base [options]")
          end
        end

        context 'given arguments as "--help"' do
          it 'shows help' do
            expect { parser.run(['--help']) }
              .to show("Usage: wip-checklist base [options]")
          end
        end
      end
    end
  end
end
