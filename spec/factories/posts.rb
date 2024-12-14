FactoryBot.define do
  factory :post do
    sequence(:title, "test_title")
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'assets', 'test.jpg'), 'image/jpeg') }  # 仮の画像ファイル
    song_id { '70YEIxamMR2PW4dnNqkAxu' }  # 仮の曲ID（任意）
    association :user  # ユーザーとの関連を設定
  end
end