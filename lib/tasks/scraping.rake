require 'open-uri'
require './scraping_konami'

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
end
