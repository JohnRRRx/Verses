require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  # describe 'ログイン前' do
  #   describe 'ページ遷移確認' do
  #     context '新規投稿ページにアクセス' do
  #       it '新規投稿ページへのアクセス失敗' do
  #         visit new_post_path
  #         expect(current_path).to eq login_path
  #       end
  #     end

  #     context '投稿編集ページにアクセス' do
  #       it '投稿編集ページへのアクセス失敗' do
  #         visit edit_post_path(post)
  #         expect(current_path).to eq login_path
  #       end
  #     end

  #     context '投稿詳細ページにアクセス' do
  #       it '投稿の詳細情報表示' do
  #         visit post_path(post)
  #         expect(page).to have_content post.title
  #         expect(current_path).to eq post_path(post)
  #       end
  #     end

  #     context '投稿一覧ページにアクセス' do
  #       it '全投稿表示' do
  #         # 投稿を3つ作成し、created_atを現在時刻に固定
  #         post_list = create_list(:post, 3, created_at: Time.now)
  #         visit posts_path
  #         # 各投稿に「0秒」が表示されていることを確認
            expect(page).to have_selector('.post', count: 3)
  #         # ページのパスが正しいことを確認
  #         expect(current_path).to eq posts_path
  #       end
  #     end
  #   end
  # end

  describe 'ログイン後' do
    before do
      login_as(user)
      expect(page).to have_content '新規投稿'  # ログイン後、新規投稿が表示されることを確認
    end

    # describe '新規投稿' do
    #   context 'フォームの入力値正常' do
    #     it '新規投稿成功' do
    #       visit new_post_path
    #       expect(current_path).to eq new_post_path
    #       # タイトル入力
    #       fill_in 'タイトル', with: 'Test Post Title'
    #       # 曲検索
    #       fill_in '曲を検索', with: 'イチブトゼンブ'
    #       find('i.fa-solid.fa-magnifying-glass').click
    #       # 検索結果の曲を選択
    #       expect(page).to have_content 'イチブトゼンブ' # 実際の曲タイトルに置き換え
    #       first('button.search-result-item', text: 'イチブトゼンブ').click
    #       expect(page).to have_content '選択された曲'
    #       # 画像選択
    #       attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
    #       click_button 'シェア'
    #       # 確認
    #       expect(page).to have_content '投稿を作成しました'
    #       expect(current_path).to eq posts_path
    #       find("img.h-72.w-72.object-contain.rounded-t-xl[alt='Post Image']").click
    #       expect(page).to have_current_path(/posts\/\d+/, wait: 1) # 動的なshow pathを待機
    #       expect(page).to have_content 'test_user'
    #       expect(page).to have_selector('img[src*="test.jpg"]')
    #       expect(page).to have_selector('iframe.w-full.rounded-lg[src="https://open.spotify.com/embed/track/2X0pcKFdtkbjKxtZlyZCkZ"]')
    #     end
    #   end

    #   context 'タイトル未入力' do
    #     it '投稿作成失敗' do
    #       visit new_post_path
    #       expect(current_path).to eq new_post_path
    #       # タイトルnil
    #       fill_in 'タイトル', with: ''
    #       # 曲検索
    #       fill_in '曲を検索', with: 'ギリギリchop'
    #       # 画像選択
    #       find('i.fa-solid.fa-magnifying-glass').click
    #       # 検索結果の曲を選択
    #       expect(page).to have_content 'ギリギリchop' # 実際の曲タイトルに置き換え
    #       first('button.search-result-item', text: 'ギリギリchop').click
    #       expect(page).to have_content '選択された曲'
    #       # 画像選択
    #       attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
    #       click_button 'シェア'
    #       expect(page).to have_content "タイトルを入力してください"
    #       expect(current_path).to eq posts_path
    #     end
    #   end

    #   context '写真未選択' do
    #     it '投稿作成失敗' do
    #       visit new_post_path
    #       expect(current_path).to eq new_post_path
    #       # タイトル入力
    #       fill_in 'タイトル', with: 'Test Post Title'
    #       # 曲検索
    #       fill_in '曲を検索', with: 'ultra soul'
    #       find('i.fa-solid.fa-magnifying-glass').click
    #       # 検索結果の曲を選択
    #       expect(page).to have_content 'ultra soul' # 実際の曲タイトルに置き換え
    #       first('button.search-result-item', text: 'ultra soul').click
    #       expect(page).to have_content '選択された曲'
    #       #写真選択せず
    #       click_button 'シェア'
    #       expect(page).to have_content "写真を選択してください"
    #       expect(current_path).to eq posts_path
    #     end
    #   end

    #   context '曲未選択' do
    #     it '投稿作成失敗' do
    #       visit new_post_path
    #       expect(current_path).to eq new_post_path
    #       # タイトル入力
    #       fill_in 'タイトル', with: 'Test Post Title'
    #       # 曲検索・選択しない
    #       # 画像選択
    #       attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
    #       click_button 'シェア'
    #       expect(page).to have_content "曲を選択してください"
    #       expect(current_path).to eq posts_path
    #     end
    #   end
    # end

    # describe '投稿編集' do
    #   let!(:post) { create(:post, user: user) }
    #   let(:other_post) { create(:post, user: user) }
    #   before { visit edit_post_path(post) }
      
    #   context 'フォームの入力値正常' do
    #     it '投稿編集成功' do
    #       # タイトル変更
    #       fill_in 'タイトル', with: 'updated_title'
    #       # 曲検索
    #       fill_in '曲を検索', with: 'いつかのメリークリスマス'
    #       find('i.fa-solid.fa-magnifying-glass').click
    #       # 検索結果の曲を選択
    #       expect(page).to have_content 'いつかのメリークリスマス' # 実際の曲タイトルに置き換え
    #       first('button.search-result-item', text: 'いつかのメリークリスマス').click
    #       expect(page).to have_content '選択された曲'
    #       # 画像選択
    #       attach_file '写真', Rails.root.join('spec/support/assets/test2.png')
    #       click_button 'シェア'
    #       expect(page).to have_content '投稿を更新しました'
    #       expect(page).to have_content 'updated_title'
    #       expect(page).to have_selector('img[src*="test2.png"]')
    #       expect(page).to have_selector('iframe.w-full.rounded-lg[src="https://open.spotify.com/embed/track/3Ro8jrbsWu0VSk1odLLYuo"]')
    #       expect(current_path).to eq post_path(post)
    #     end
    #   end

    #   context 'タイトル空白' do
    #     it '投稿編集失敗' do
    #       # タイトル変更
    #       fill_in 'タイトル', with: ''
    #       click_button 'シェア'
    #       expect(page).to have_content '投稿を更新できませんでした'
    #       expect(page).to have_content "タイトルを入力してください"
    #       expect(current_path).to eq post_path(post)
    #     end
    #   end

    #   describe '投稿削除' do
    #     let!(:post) { create(:post, user: user) }

    #     it '投稿削除成功' do
    #       visit posts_path
    #       find('i.fa-solid.fa-skull').click
    #       expect(page.accept_confirm).to eq '削除しますか'
    #       expect(page).to have_content '投稿を削除しました'
    #     end
    #   end
    # end
  end
end