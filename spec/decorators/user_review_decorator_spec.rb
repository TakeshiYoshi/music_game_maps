# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserReviewDecorator do
  let(:user_review) { UserReview.new.extend UserReviewDecorator }
  subject { user_review }
  it { should be_a UserReview }
end
