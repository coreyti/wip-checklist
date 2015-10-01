require 'spec_helper'

module WIP::Checklist
  describe Runner do
    subject(:runner) { Runner.new }

    describe '.command' do
      context 'when a registered Command is found' do
        around do |example|
          Runner.register(:example, Commands::Base)
          example.run
          Runner.deregister(:example)
        end

        it 'returns the Command implementation' do
          expect(Runner.command(:example)).to be_a(Class)
        end
      end

      context 'when a registered Command is not found' do
        it 'raises an error' do
          expect { Runner.command(:bogus) }
            .to raise_error(UnknownCommandError)
        end
      end
    end

    describe '.commands' do
      it 'returns the list of registered Commands' do
        registered      = Runner.commands.map(&:last)
        implementations = Commands.constants(false).reject { |const| const == :Base }

        expect(registered.length).to eq(implementations.length)
        implementations.each do |implementation|
          expect(registered).to include(Commands.const_get(implementation))
        end
      end
    end

    describe '.deregister' do
      before do
        Runner.register(:example, Commands::Base)
      end

      it 'adds to the list of registered Commands' do
        expect { Runner.deregister(:example) }
          .to change { Runner.commands.count }
          .by(-1)
      end
    end

    describe '.register' do
      after do
        Runner.deregister(:example)
      end

      it 'adds to the list of registered Commands' do
        expect { Runner.register(:example, Commands::Base) }
          .to change { Runner.commands.count }
          .by(1)
      end
    end

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

      context 'given arguments with a Command name' do
        context 'when the value matches a Command' do
          it 'executes the Command' do
            expect { runner.run(['version']) }
              .to show("wip-checklist version #{WIP::Checklist::VERSION}")
          end
        end

        context 'when the value does not match a Command' do
          it 'shows help' do
            expect { runner.run(['bogus']) }
              .to show("Usage: wip-checklist COMMAND [options]")
          end
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
                help                             Prints context-relevant help
                version                          Prints version information

            Options:
                -h, --help                       Prints help messages
          HELP
        end
      end
    end
  end
end
