# frozen_string_literal: true

class Layouts::FlashMessageComponent < ViewComponent::Base
  def initialize(flash:)
    @flash = flash
  end

  private

  attr_reader :flash

  def value
    # マップ用のフラッシュメッセージを拾わないようにする
    flash.to_h.reject { |k, _v| k == 'map' }.values.first
  end
end
