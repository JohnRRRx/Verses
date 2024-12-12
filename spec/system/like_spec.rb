require 'rails_helper'

RSpec.describe 'Like', type: :system do
  let(:user) { create(:user) }
  let!(:post) { create(:post) }
  let!(:like) { create(:like, user: user) }

  it 'いいね可能' do
    login_as(user)
    Capybara.assert_current_path("/", ignore_query: true)
    expect(current_path).to eq "/"
    expect_text('ログインしました')
    visit '/posts'
    find("#like-button-for-post-#{post.id}").click
    expect(current_path).to eq('/posts')
    expect(page).to have_css("#unlike-button-for-post-#{post.id}")
    # 投稿詳細ページ内も確認
    find("a[href='/posts/#{post.id}'] img.h-72.w-72.object-contain.rounded-t-xl").click
    expect(page).to have_css("#unlike-button-for-post-#{post.id}")
  end

  it 'いいね取消可能' do
    login_as(user)
    Capybara.assert_current_path("/", ignore_query: true)
    expect(current_path).to eq "/"
    expect_text('ログインしました')
    visit '/posts'
    find("#unlike-button-for-post-#{like.post.id}").click
    expect(current_path).to eq('/posts')
    expect(page).to have_css("#like-button-for-post-#{post.id}")
    # 投稿詳細ページ内も確認
    find("a[href='/posts/#{post.id}'] img.h-72.w-72.object-contain.rounded-t-xl").click
    expect(page).to have_css("#like-button-for-post-#{post.id}")
  end
end