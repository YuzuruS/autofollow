# config/schedule.rb

# 出力先のログファイルの指定
set :output, 'log/crontab.log'
# ジョブの実行環境の指定
set :environment, :production

# 毎日 am4:30のスケジューリング
every 1.day, at: '4:30 am' do
  runner 'Tasks::Twitter.execute'
end