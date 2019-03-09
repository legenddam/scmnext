namespace :dlt do
  desc '30分データダウンロード'
  task download: :environment do |_task, _args|
    Dlt::File.download do |filename|
      Date.new(2019, 2, 20) < DateTime.strptime(filename[6, 8], '%Y%m%d')
    end
  end

  #
  # XMLからテーブルへのインポート処理
  #
  namespace :import do
    desc '当日データを速報値テーブルへ取込む'
    task today: :environment do |_task, _args|
      target_date = determine_target_date(Date.today)
      logger.debug("処理日:#{target_date}")
      (1..48).each do |i|
        PowerUsagePreliminary.import_today_data(1, 1, target_date, i)
      end
    end

    desc '過去データを速報値テーブルへ取込む'
    task past: :environment do |_task, _args|
      target_date = determine_target_date(Date.yesterday)
      logger.debug("処理日:#{target_date}")
      Dlt::Setting.find_each do |setting|
        PowerUsagePreliminary.import_past_data(setting.company_id, setting.district_id, target_date)
      end
    end

    desc '確定使用量データを確定使用量テーブルに取り込む'
    task fixed: :environment do |_task, _args|
      start_date = Date.new(2018, 11, 1)
      (start_date..start_date.next_month.end_of_month).each do |date|
        Dlt::Setting.find_each do |setting|
          Dlt::UsageFixedHeader.import_data(setting.company_id, setting.district_id, date)
        end
      end
    end
  end

  #
  # 確定使用量の集計処理
  #
  namespace :summary do
    desc '確定使用量テーブルのデータを確定値テーブルへ取込む'
    task fixed: :environment do |_task, _args|
      start_date = Date.new(2018, 11, 1)
      Dlt::Setting.find_each do |setting|
        PowerUsageFixed.import_data(setting.company_id, setting.district_id, start_date, start_date.end_of_month)
      end
    end
  end
end
