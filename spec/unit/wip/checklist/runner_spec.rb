require 'spec_helper'

module WIP::Checklist
  describe Runner do
    subject(:runner) { Runner.new }

    describe '.command' do
      context 'when a registered Command is found' do
        around do |example|
          Runner.register(Support::ExampleCommand)
          example.run
          Runner.deregister(Support::ExampleCommand)
        end

        it 'returns the Command implementation' do
          expect(Runner.command('example-command')).to be_a(Class)
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
        registered      = Runner.commands
        implementations = Commands.constants(false).reject { |const| const == :Base }

        expect(registered.length).to eq(implementations.length)
        implementations.each do |implementation|
          expect(registered).to include(Commands.const_get(implementation))
        end
      end
    end

    describe '.deregister' do
      before do
        Runner.register(Support::ExampleCommand)
      end

      it 'removes from the list of registered Commands' do
        expect { Runner.deregister(Support::ExampleCommand) }
          .to change { Runner.commands.count }
          .by(-1)
      end
    end

    describe '.register' do
      after do
        Runner.deregister(Support::ExampleCommand)
      end

      it 'adds to the list of registered Commands (once)' do
        expect {
          Runner.register(Support::ExampleCommand)
          Runner.register(Support::ExampleCommand)
        }
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

      context 'given command arguments' do
        context 'as "version"' do
          it 'executes the Command' do
            expect { runner.run(['version']) }
              .to show("wip-checklist version #{WIP::Checklist::VERSION}")
          end
        end

        context 'as "help"' do
          it 'executes the Command' do
            expect { runner.run(['help']) }
              .to show("Usage: wip-checklist COMMAND [options]")
          end
        end

        context 'as "help version"' do
          it 'executes the Command' do
            expect { runner.run(['help', 'version']) }
              .to show("Usage: wip-checklist version [options]")
          end
        end

        context 'as "bogus"' do
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
                console                          Starts a REPL console session
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
