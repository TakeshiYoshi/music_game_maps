module ApplicationHelper
  def page_title(page_title = '')
    base_title = t('defaults.base_title')
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def filtered?
    session[:prefecture_id] || games_filtered? || session[:lat]
  end

  def games_filtered?
    Game.all.each do |game|
      return true if game_filtered?(game.id)
    end
    false
  end

  def game_filtered?(game_id)
    session.dig(:games, game_id.to_s) == '1'
  end
end
