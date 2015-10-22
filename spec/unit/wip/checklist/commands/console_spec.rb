require 'spec_helper'

module WIP::Checklist::Commands
  describe Console do
    subject(:command) { Console.new(io) }

    after do
      WIP::Checklist::Runner.register(Console)
      WIP::Checklist::Runner.deregister(Console::Quit)
    end

    describe '#initialize' do
      it 'deregisters the "console" Command' do
        Console.new(io)
        expect(WIP::Checklist::Runner.commands)
          .to_not include(Console)
      end

      it 'registers the "quit" Command (once)' do
        Console.new(io)
        expect(WIP::Checklist::Runner.commands)
          .to include(Console::Quit)
      end
    end

    describe '#run' do
      it 'starts the REPL' do
        expect(command).to receive(:start)
        command.run
      end
    end

    describe '(private method) #process' do
      let(:args) {  }

      it 'delegates to the Runner' do
        expect(command.runner).to receive(:run)
          .with(['command', '--option'])
        command.send(:process, 'command --option')
      end

      context 'given arguments as "help"' do
        it 'shows help' do
          expect { command.send(:process, 'help') }.to show <<-HELP
            Usage: wip-checklist COMMAND [options]

            Commands:
                quit                             Quits this console session
                help                             Prints context-relevant help
                create                           Creates issues
                version                          Prints version information
                edit                             Edits checklists
                list                             Prints an index of checklists
                save                             Saves checklists
                show                             Edits checklists

            Options:
                -h, --help                       Prints help messages
          HELP
        end
      end
    end


    describe '(private method) #read' do
      let(:answer) { 'command --option' }
      let(:prompt) { '-->' }

      it 'prompts for input and returns the answer' do
        expect(io).to receive(:ask)
          .with(prompt)
          .and_return(answer)
        expect(command.send(:read, prompt)).to eq(answer)
      end
    end
  end
end
