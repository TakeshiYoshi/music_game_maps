module ApplicationHelper
  def filtered?
    session[:prefecture_id] || games_filtered?
  end

  def games_filtered?
    Game.all.each do |game|
      return true if game_filtered?(game.id)
    end
    false
  end

  def game_filtered?(game_id)
    session.dig(:games, game_id.to_s)
  end

  def default_meta_tags
    {
      site: t('defaults.meta.site'),
      separator: t('defaults.meta.separator'),
      title: t('defaults.meta.title'),
      charset: t('defaults.meta.charset'),
      description: t('defaults.meta.description'),
      keywords: t('defaults.meta.keywords'),
      reverse: true,
      icon: [
        { href: asset_pack_path('media/images/favicon.ico') }
      ],
      og: {
        site_name: t('defaults.meta.site'),
        title: t('defaults.meta.site'),
        description: t('defaults.meta.description'),
        type: 'website',
        url: request.original_url,
        image: asset_pack_url('media/images/ogp.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@otomap_net'
      }
    }
  end

  def admin_meta_tags
    {
      site: t('defaults.meta.admin_site'),
      separator: t('defaults.meta.separator'),
      reverse: true
    }
  end
end
