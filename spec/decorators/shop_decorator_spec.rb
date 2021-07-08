# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShopDecorator do
  let(:shop) { Shop.new.extend ShopDecorator }
  subject { shop }
  it { should be_a Shop }
end
