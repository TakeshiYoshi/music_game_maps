module ApplicationHelper
  def page_title(page_title = '')
    base_title = t('defaults.base_title')
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def filtered?
    session[:prefecture_id].present? || session[:city_id].present?
  end
end
