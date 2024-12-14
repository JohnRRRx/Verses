FactoryBot.define do
  factory :reaction do
    association :user
    association :post
    emoji { '👀' }  # デフォルトで絵文字を設定
  end
end