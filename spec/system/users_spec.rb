require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }
  let!(:post) { create(:post) } # 通常の投稿を作成
  let!(:reaction) { create(:reaction, post: post, user: user, emoji: '👀') } # 絵文字付きのリアクションを作成

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値正常' do
        it 'ユーザーの新規作成成功' do
          visit new_user_path
          fill_in 'ニックネーム', with: 'test_name'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect_text('登録完了しました')
          expect(current_path).to eq login_path
        end
      end

      context 'ニックネーム未入力' do
        it 'ユーザー新規作成失敗' do
          visit new_user_path
          fill_in 'ニックネーム', with: ''
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect_text('登録に失敗しました')
          expect_text('ニックネームを入力してください')
          expect(current_path).to eq new_user_path
        end
      end

      context 'メールアドレス未入力' do
        it 'ユーザー新規作成失敗' do
          visit new_user_path
          fill_in 'ニックネーム', with: 'test_name'
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect_text('登録に失敗しました')
          expect_text('メールアドレスを入力してください')
          expect(current_path).to eq new_user_path
        end
      end

      context '登録済メールアドレス使用' do
        it 'ユーザー新規作成失敗' do
          existed_user = create(:user)
          visit new_user_path
          fill_in 'ニックネーム', with: 'test_name'
          fill_in 'メールアドレス', with: existed_user.email
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(current_path).to eq new_user_path
          expect_text('登録に失敗しました')
          expect_text('メールアドレスはすでに存在します')
          expect(page).to have_field 'メールアドレス', with: existed_user.email
        end
      end

      context 'パスワード確認未入力' do
        it 'ユーザー新規作成失敗' do
          visit new_user_path
          fill_in 'ニックネーム', with: 'test_name'
          fill_in 'メールアドレス', with: 'test@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: ''
          click_button '登録'
          expect_text('登録に失敗しました')
          expect_text('パスワード確認とパスワードの入力が一致しません')
          expect_text('パスワード確認を入力してください')
          expect(current_path).to eq new_user_path
        end
      end
    end

    describe '新規投稿' do
      context 'ログイン前' do
        it '新規投稿ページへのアクセス失敗' do
          visit new_post_path(user)
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'いいね' do
      context 'ログイン前' do
        it 'いいねページへのアクセス失敗' do
          visit likes_posts_path(user)
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'マイポスト' do
      context 'ログイン前' do
        it 'マイポストページへのアクセス失敗' do
          visit mine_posts_path(user)
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'プロフィール' do
      context 'ログイン前' do
        it 'プロフィールページへのアクセス失敗' do
          visit profile_path(user)
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'プロフィール編集' do
      context 'ログイン前' do
        it 'プロフィール編集ページへのアクセス失敗' do
          visit edit_profile_path(user)
          expect(current_path).to eq login_path
        end
      end
    end

    describe '検索欄' do
      context 'ログイン前' do
        it '検索欄は表示されない' do
          visit root_path
          expect(page).to have_no_css('input#search_form')
        end
      end
    end

    describe '投稿一覧' do
      context 'ログイン前' do
        it '投稿一覧ページへのアクセス可能' do
          visit posts_path
          # 予め作った投稿1件を確認
          expect(page).to have_selector('.post', count: 1)
          expect(current_path).to eq posts_path
        end

        it '投稿一覧ページのいいねボタンは表示されない' do
          visit posts_path
          check_no_like_buttons
          visit post_path(post)
        end
      end
    end

    describe '投稿詳細' do
      context 'ログイン前' do
        it '投稿詳細ページへのアクセス可能' do
          visit posts_path
          visit post_path(post)
          expect(current_path).to eq post_path(post)
        end

        it '投稿詳細ページのいいねボタンは表示されない' do
          visit posts_path
          visit post_path(post)
          check_no_like_buttons
          expect(current_path).to eq post_path(post)
        end

        it '既存絵文字と集計は表示されるが、スタンプは押せない' do
          visit posts_path
          visit post_path(post)
          # 👀がついてる投稿を予め作ったので、👀1の表示を確認
          count_span_id = "post_#{post.id}_emoji_👀_count"
          expect_emoji_count(count_span_id, 1)
          # 👀1をクリックしてもカウントされない
          find("##{count_span_id}").click
          expect_emoji_count(count_span_id, 1)
          expect(current_path).to eq post_path(post)
        end

        it '絵文字ピッカーは表示されない' do
          visit posts_path
          visit post_path(post)
          expect(page).to have_no_css('label[for="emoji-toggle"]')
          expect(current_path).to eq post_path(post)
        end

        it 'プロフィール編集ページへのアクセス失敗' do
          visit edit_profile_path(user)
          expect(current_path).to eq login_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      login_as(user)
      expect_text('新規投稿') # ログイン後、新規投稿が表示されることを確認
    end

    describe 'マイポスト' do
      context '投稿作成' do
        it '新規作成した投稿が表示される' do
          create(:post, title: 'test_title_1', user: user)
          create(:post, title: 'test_title_2', user: user)
          navibar_click
          click_link 'マイポスト'
          expect_text(user.name)
          expect(page).to have_selector('.post', count: 2)
          expect(current_path).to eq mine_posts_path
        end
      end
    end

    describe '検索欄' do
      context 'ログイン後' do
        it '検索欄は表示される' do
          visit root_path
          expect(page).to have_css('input#search_form')
        end
      end
    end
  end
end
