require 'rails_helper'

RSpec.describe 'Reaction', type: :system do
  let(:user) { create(:user) }
  let!(:post) { create(:post) }
  let!(:reaction) { create(:reaction, post: post, user: user, emoji: '🍔') }

  describe '絵文字スタンプ' do
    it '絵文字ピッカーからスタンプが押せる' do
      login_as(user)
      open_post_and_select_emoji(post, '🫨')
      count_span_id = "post_#{post.id}_emoji_🫨_count"
      expect_emoji_count(count_span_id, 1)
    end

    it '投稿に既存の絵文字を押すとスタンプが押せる' do
      # 既存投稿と違うユーザーでログイン
      other_user = create(:user, name: 'other_user', email: 'other@example.com')
      login_as(other_user)
      Capybara.assert_current_path("/")
      click_on '投稿一覧'
      # 投稿を選択
      all("img.h-72.w-72.object-contain.rounded-t-xl[alt='Post Image']").first.click
      # 🍔がついてる投稿を予め作ったので、🍔1の表示を確認
      count_span_id = "post_#{post.id}_emoji_🍔_count"
      expect_emoji_count(count_span_id, 1)
      # 投稿に既存の🍔1を押したら、自分も🍔スタンプ押したと見なされてカウント1増加
      find("##{count_span_id}").click
      expect_emoji_count(count_span_id, 2)
    end

    it 'スタンプ集計可能' do
      login_as(user)
      open_post_and_select_emoji(post, '🍟')
      count_span_id = "post_#{post.id}_emoji_🍟_count"
      expect_emoji_count(count_span_id, 1)
      logout
      # 他のユーザーを作成
      other_user = create(:user, name: 'other_user', email: 'other@example.com')
      Capybara.assert_current_path("/")
      login_as(other_user)
      navibar_click
      click_on "プロフィール"
      open_post_and_select_emoji(post, '🍟')
      # 🍟クリックした後、🍟のcountは前より増加したことを確認
      expect_emoji_count(count_span_id, 2)
    end

  it '同じユーザーは同じ投稿に同じスタンプを1回しか押せない' do
      login_as(user)
      open_post_and_select_emoji(post, '🦖')
      count_span_id = "post_#{post.id}_emoji_🦖_count"
      expect_emoji_count(count_span_id, 1)
      # 🦖を再度クリックしてもカウントは変わらない
      find('input.emoji-button[value="🦖"]').click
      expect_emoji_count(count_span_id, 1)
    end

    it 'スタンプ取消可能' do
      login_as(user)
      open_post_and_select_emoji(post, '🐱')
      count_span_id = "post_#{post.id}_emoji_🐱_count"
      expect_emoji_count(count_span_id, 1)
      # # 絵文字ピッカーを閉じる
      find('body').click
      # # スタンプを取り消す
      find("##{count_span_id}").click
      # # スタンプのカウントが削除されたことを確認
      expect(page).to have_no_css("##{count_span_id}")
    end
  end
end