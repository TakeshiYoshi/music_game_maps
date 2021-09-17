require './lib/scraping/scraping_konami'
require './lib/scraping/scraping_sega'
require './lib/scraping/scraping_namco'
require './lib/scraping/scraping_taito'

namespace :scraping do
  desc "スクレイピング処理"

  task konami: :environment do
    scraping_konami 'SDVX_VM'
    scraping_konami 'SDVX'
    scraping_konami 'PMSP'
    scraping_konami 'IIDX_LN'
    scraping_konami 'IIDX'
    scraping_konami 'NOSTALGIA'
    scraping_konami 'GITADORAGF'
    scraping_konami 'GITADORADM'
    scraping_konami 'DDR'
    scraping_konami 'DDR20TH'
    scraping_konami 'JUBEAT'
    scraping_konami 'DAN'
    scraping_konami 'REFLECC'
    scraping_konami 'MUSECA'
    scraping_konami 'DANEVOAC'
  end

  task sega: :environment do
    scraping_sega 'CHUNITHM'
    scraping_sega 'maimai'
    scraping_sega 'WACCA'
    scraping_sega 'オンゲキ'
  end

  task namco: :environment do
    scraping_namco '太鼓の達人'
  end

  task taito: :environment do
    scraping_taito 'GROOVE COASTER'
  end

  task all: :environment do
    scraping_konami 'SDVX_VM'
    scraping_konami 'SDVX'
    scraping_konami 'PMSP'
    scraping_konami 'IIDX_LN'
    scraping_konami 'IIDX'
    scraping_konami 'NOSTALGIA'
    scraping_konami 'GITADORAGF'
    scraping_konami 'GITADORADM'
    scraping_konami 'DDR'
    scraping_konami 'DDR20TH'
    scraping_konami 'JUBEAT'
    scraping_konami 'DAN'
    scraping_konami 'REFLECC'
    scraping_konami 'MUSECA'
    scraping_konami 'DANEVOAC'
    scraping_sega 'CHUNITHM'
    scraping_sega 'maimai'
    scraping_sega 'WACCA'
    scraping_sega 'オンゲキ'
    scraping_namco '太鼓の達人'
    scraping_taito 'GROOVE COASTER'
  end
end
