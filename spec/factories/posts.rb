FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Title #{n}" }  # ユニークなタイトル
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'assets', 'test.jpg'), 'image/jpeg') }  # 仮の画像ファイル
    song_id { '12345' }  # 仮の曲ID（任意の文字列や数値）
    association :user  # ユーザーとの関連を設定
  end
end