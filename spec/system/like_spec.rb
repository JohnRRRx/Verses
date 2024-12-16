require 'rails_helper'

RSpec.describe 'Like', type: :system do
  let(:user) { create(:user) }
  let!(:post) { create(:post) }
  let!(:like) { create(:like, user: user) }

  describe 'いいねスタンプ' do
    it 'いいね可能' do
      login_as(user)
      Capybara.assert_current_path('/')
      visit posts_path
      find("#like-button-for-post-#{post.id}").click
      expect(current_path).to eq('/posts')
      expect(page).to have_css("#unlike-button-for-post-#{post.id}")
      # 投稿詳細ページ内も確認
      visit post_path(post)
      expect(page).to have_css("#unlike-button-for-post-#{post.id}")
    end

    it 'いいね取消可能' do
      login_as(user)
      Capybara.assert_current_path('/')
      visit posts_path
      find("#unlike-button-for-post-#{like.post.id}").click
      expect(current_path).to eq('/posts')
      expect(page).to have_css("#like-button-for-post-#{post.id}")
      # 投稿詳細ページ内も確認
      visit post_path(post)
      expect(page).to have_css("#like-button-for-post-#{post.id}")
    end
  end
end
