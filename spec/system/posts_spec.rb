require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context '新規投稿ページにアクセス' do
        it '新規投稿ページへのアクセス失敗' do
          visit new_post_path
          expect(current_path).to eq login_path
        end
      end

      context '投稿編集ページにアクセス' do
        it '投稿編集ページへのアクセス失敗' do
          visit edit_post_path(post)
          expect(current_path).to eq login_path
        end
      end

      context '投稿詳細ページにアクセス' do
        it '投稿の詳細情報表示' do
          visit post_path(post)
          expect_text(post.title)
          expect(current_path).to eq post_path(post)
        end
      end

      context '投稿一覧ページにアクセス' do
        it '全投稿表示' do
          post_list = create_list(:post, 3)
          visit posts_path
          expect(Post.count).to eq 3
          expect(current_path).to eq posts_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      login_as(user)
      expect_text("新規投稿")
    end

    describe '新規投稿' do
      context 'フォームの入力値正常' do
        it '新規投稿成功' do
          visit new_post_path
          fill_in 'タイトル', with: 'Test Post Title'
          fill_in '曲を検索', with: 'イチブトゼンブ'
          song_search_botton_click
          first('button.search-result-item', text: 'イチブトゼンブ').click
          attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
          click_button 'シェア'
          expect_text("投稿を作成しました")
          expect(page).to have_selector('img[src*="test.jpg"]')
          expect(current_path).to eq posts_path
        end
      end

      context 'タイトル未入力' do
        it '投稿作成失敗' do
          visit new_post_path
          expect(current_path).to eq new_post_path
          fill_in 'タイトル', with: ''
          fill_in '曲を検索', with: 'ギリギリchop'
          song_search_botton_click
          first('button.search-result-item', text: 'ギリギリchop').click
          attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
          click_button 'シェア'
          expect_text("タイトルを入力してください")
          expect(current_path).to eq posts_path
        end
      end

      context '写真未選択' do
        it '投稿作成失敗' do
          visit new_post_path
          expect(current_path).to eq new_post_path
          fill_in 'タイトル', with: 'Test Post Title'
          fill_in '曲を検索', with: 'ultra soul'
          song_search_botton_click
          first('button.search-result-item', text: 'ultra soul').click
          click_button 'シェア'
          expect_text("写真を選択してください")
          expect(current_path).to eq posts_path
        end
      end

      context '曲未選択' do
        it '投稿作成失敗' do
          visit new_post_path
          expect(current_path).to eq new_post_path
          fill_in 'タイトル', with: 'Test Post Title'
          attach_file '写真', Rails.root.join('spec/support/assets/test.jpg')
          click_button 'シェア'
          expect_text("曲を選択してください")
          expect(current_path).to eq posts_path
        end
      end
    end

    describe '投稿編集' do
      let!(:post) { create(:post, user: user) }
      let(:other_post) { create(:post, user: user) }
      before { visit edit_post_path(post) }
      
      context 'フォームの入力値正常' do
        it '投稿編集成功' do
          fill_in 'タイトル', with: 'updated_title'
          fill_in '曲を検索', with: 'いつかのメリークリスマス'
          song_search_botton_click
          first('button.search-result-item', text: 'いつかのメリークリスマス').click
          attach_file '写真', Rails.root.join('spec/support/assets/test2.png')
          click_button 'シェア'
          expect_text("投稿を更新しました")
          expect_text("updated_title")
          expect(page).to have_selector('img[src*="test2.png"]')
          expect(page).to have_selector('iframe.w-full.rounded-lg[src="https://open.spotify.com/embed/track/3Ro8jrbsWu0VSk1odLLYuo"]')
          expect(current_path).to eq post_path(post)
        end
      end

      context 'タイトル空白' do
        it '投稿編集失敗' do
          fill_in 'タイトル', with: ''
          click_button 'シェア'
          expect_text("投稿を更新できませんでした")
          expect_text("タイトルを入力してください")
          expect(current_path).to eq post_path(post)
        end
      end

      describe '投稿削除' do
        let!(:post) { create(:post, user: user) }

        it '投稿削除成功' do
          visit posts_path
          find('i.fa-solid.fa-skull').click
          expect(page.accept_confirm).to eq '削除しますか'
          expect_text("投稿を削除しました")
        end
      end
    end
  end
end