# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameMachineDecorator do
  let(:game_machine) { GameMachine.new.extend GameMachineDecorator }
  subject { game_machine }
  it { should be_a GameMachine }
end
