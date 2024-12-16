require 'rails_helper'

RSpec.describe 'Tags', type: :system do
  let(:user) { create(:user) }

  describe '新規作成' do
    before do
      login_as(user)
    end

    it 'タグ追加可能' do
      click_link '新規投稿'
      fill_in 'タイトル', with: 'Tag_test'
      fill_in '曲を検索', with: 'イチブトゼンブ'
      fill_in 'タグ', with: '2009年,8月5日,発売'
      song_search_botton_click
      first('button.search-result-item', text: 'イチブトゼンブ').click
      attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
      click_button 'シェア'
      expect_text('投稿を作成しました')
      expect(current_path).to eq posts_path
      find("img.h-72.w-72.object-contain.rounded-t-xl[alt='Post Image']").click
      expect_text('2009年')
      expect_text('8月5日')
      expect_text('発売')
    end

    it '同じタグを入力しても重複してレコードが生成されない' do
      click_link '新規投稿'
      fill_in 'タイトル', with: 'Tag_test'
      fill_in '曲を検索', with: 'イチブトゼンブ'
      fill_in 'タグ', with: 'YES,YES,YES'
      song_search_botton_click
      first('button.search-result-item', text: 'イチブトゼンブ').click
      attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
      click_button 'シェア'
      expect_text('投稿を作成しました')
      expect(current_path).to eq posts_path
      find("img.h-72.w-72.object-contain.rounded-t-xl[alt='Post Image']").click
      expect(page).to have_css('#tag-YES', count: 1)
    end
  end

  describe 'タグ編集' do
    before do
      login_as(user)
    end

    it 'タグ編集可能' do
      click_link '新規投稿'
      fill_in 'タイトル', with: 'Tag_edit'
      fill_in '曲を検索', with: 'イチブトゼンブ'
      fill_in 'タグ', with: '4:12'
      song_search_botton_click
      first('button.search-result-item', text: 'イチブトゼンブ').click
      attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
      click_button 'シェア'
      expect_text('投稿を作成しました')
      expect(current_path).to eq posts_path
      find("img.h-72.w-72.object-contain.rounded-t-xl[alt='Post Image']").click
      expect(page).to have_css('#tag-4\:12')
      edit_botton_click
      fill_in 'タグ', with: '3:22'
      click_button 'シェア'
      expect(page).to have_css('#tag-3\:22')
    end
  end

  describe '同一タグの投稿一覧' do
    let!(:post1) { create(:post, user: user, tag_list: 'DINOSAUR, EPIC DAY') }
    let!(:post2) { create(:post, user: user, tag_list: 'STARS, EPIC NIGHT') }
    let!(:post3) { create(:post, user: user, tag_list: 'UNITE #01, EPIC NIGHT') }
    let!(:post4) { create(:post, user: user, tag_list: 'EPIC DAY, EPIC NIGHT') }
    let!(:post5) { create(:post, user: user, tag_list: 'STARS, EPIC NIGHT') }
    before do
      login_as(user)
    end

    it 'タグを押したら、同じタグがついてる投稿一覧が表示される' do
      click_link '投稿一覧'
      all("img.h-72.w-72.object-contain.rounded-t-xl[alt='Post Image']").first.click
      find('#tag-STARS').click
      # STARSタグを押して2つの投稿が表示される
      expect(page).to have_css('div[id^="post-"]', count: 2)
      # 投稿詳細に戻る
      page.go_back
      # EPIC NIGHTタグを押して4つの投稿が表示される
      find('#tag-EPIC\ NIGHT').click
      expect(page).to have_css('div[id^="post-"]', count: 4)
    end
  end

  describe 'タグ検索' do
    before do
      login_as(user)
    end

    it 'タグで検索可能' do
      click_link '新規投稿'
      fill_in 'タイトル', with: 'Tag_test'
      fill_in '曲を検索', with: 'イチブトゼンブ'
      fill_in 'タグ', with: '2009年'
      song_search_botton_click
      first('button.search-result-item', text: 'イチブトゼンブ').click
      attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
      click_button 'シェア'
      expect_text('投稿を作成しました')
      expect(current_path).to eq posts_path
      find("img.h-72.w-72.object-contain.rounded-t-xl[alt='Post Image']").click
      expect_text('2009年')
      fill_in 'search_form', with: '2009年'
      find('#search_form').send_keys(:enter)
      expect(page).to have_selector('img[src*="test.jpg"]')
    end
  end
end
