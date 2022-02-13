# frozen_string_literal: true

class Shop::TwitterComponent < ViewComponent::Base
  def initialize(twitter_id:)
    @twitter_id = twitter_id
  end

  private

  attr_reader :twitter_id
end
