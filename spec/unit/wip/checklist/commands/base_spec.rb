require 'spec_helper'

module WIP::Checklist::Commands
  describe Base do
    subject(:command) { Base.new(io) }

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
  end
end
