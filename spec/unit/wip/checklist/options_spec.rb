require 'spec_helper'

module WIP::Checklist
  describe Options do
    subject(:options) { Options.new }

    it 'has accessors' do
      options.field = :value
      expect(options.field).to eq(:value)
    end
  end
end
