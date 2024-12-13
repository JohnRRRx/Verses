require 'rails_helper'

RSpec.describe Reaction, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  context '絵文字が有効な場合' do
    it '有効である' do
      reaction = build(:reaction, user: user, post: post, emoji: '👍')
      expect(reaction).to be_valid
    end
  end

  context '絵文字が未設定の場合' do
    it '無効である' do
      reaction = build(:reaction, user: user, post: post, emoji: nil)
      reaction.valid?
      expect(reaction.errors[:emoji]).to include('を入力してください')
    end
  end

  context '同じ投稿に同じ絵文字を複数回つけられない場合' do
    it '無効であること' do
      create(:reaction, user: user, post: post, emoji: '👍') # すでに絵文字がついている
      reaction = build(:reaction, user: user, post: post, emoji: '👍') # 同じ投稿に同じ絵文字をつけようとする
      reaction.valid?
      expect(reaction.errors[:user_id]).to include('はすでに存在します')
    end
  end
end