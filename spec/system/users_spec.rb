require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

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

          expect_message("登録完了しました")
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
          expect_message("登録に失敗しました")
          expect_message("ニックネームを入力してください")
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
          expect_message("登録に失敗しました")
          expect_message("メールアドレスを入力してください")
          expect(current_path).to eq new_user_path
        end
      end

      context '登録済メールアドレスを使用' do
        it 'ユーザー新規作成失敗' do
          existed_user = create(:user)
          visit new_user_path
          fill_in 'ニックネーム', with: 'test_name'
          fill_in 'メールアドレス', with: existed_user.email
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(current_path).to eq new_user_path
          expect_message("登録に失敗しました")
          expect_message("メールアドレスはすでに存在します")
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
          expect_message("登録に失敗しました")
          expect_message("パスワード確認とパスワードの入力が一致しません")
          expect_message("パスワード確認を入力してください" )       
          expect(current_path).to eq new_user_path
        end
      end
    end

    describe '新規投稿' do
      context 'ログインしていない状態' do
        it '新規投稿ページへのアクセス失敗' do
          visit new_post_path(user)
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'いいね' do
      context 'ログインしていない状態' do
        it 'いいねページへのアクセス失敗' do
          visit likes_posts_path(user)
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'マイポスト' do
      context 'ログインしていない状態' do
        it 'マイポストページへのアクセス失敗' do
          visit mine_posts_path	(user)
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'プロフィール' do
      context 'ログインしていない状態' do
        it 'プロフィールページへのアクセス失敗' do
          visit profile_path(user)
          expect(current_path).to eq login_path
        end
      end
    end

    describe 'プロフィール編集' do
      context 'ログインしていない状態' do
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
      expect_message('新規投稿')  # ログイン後、新規投稿が表示されることを確認
    end

    describe 'プロフィール編集' do
      context 'フォームの入力値正常' do
        it 'ユーザーの編集成功' do
          navibar_click
          click_link 'プロフィール'
          click_link '編集'
          attach_file 'user_icon', Rails.root.join('spec/support/assets/test.jpg')
          fill_in 'ニックネーム', with: 'update_name'
          fill_in 'メールアドレス', with: 'update@example.com'
          click_button '更新'
          expect(page).to have_content('プロフィールを更新しました')
          expect_message("update_name")
          expect_message("update@example.com")
          expect(current_path).to eq profile_path
        end
      end

      context 'ニックネーム未入力' do
        it 'ユーザーの編集失敗' do
          navibar_click
          click_link 'プロフィール'
          click_link '編集'
          fill_in 'ニックネーム', with: ''
          fill_in 'メールアドレス', with: 'update@example.com'
          click_button '更新'
          expect_message("プロフィールを更新できませんでした")
          expect(page).to have_content("ニックネームを入力してください")
          expect(current_path).to eq edit_profile_path
        end
      end

      context 'メールアドレス未入力' do
        it 'ユーザーの編集失敗' do
          navibar_click
          click_link 'プロフィール'
          click_link '編集'
          fill_in 'ニックネーム', with: 'update_name'
          fill_in 'メールアドレス', with: ''
          click_button '更新'
          expect_message("プロフィールを更新できませんでした")
          expect(page).to have_content("メールアドレスを入力してください")
          expect(current_path).to eq edit_profile_path
        end
      end

      context '登録済のメールアドレス使用' do
        it 'ユーザーの編集失敗' do
          existed_user = create(:user)
          navibar_click
          click_link 'プロフィール'
          click_link '編集'
          fill_in 'ニックネーム', with: 'update_name'
          fill_in 'メールアドレス', with: existed_user.email
          click_button '更新'
          expect_message("プロフィールを更新できませんでした")
          expect_message("メールアドレスはすでに存在します")
          expect(current_path).to eq edit_profile_path
        end
      end
    end

    describe 'マイポスト' do
      context '投稿作成' do
        it '新規作成した投稿が表示される' do
          create(:post, title: 'test_title_1', user: user)
          create(:post, title: 'test_title_2', user: user)
          navibar_click
          click_link 'マイポスト'
          expect(page).to have_content(user.name)
          expect(page).to have_selector('.post', count: 2)
          expect(current_path).to eq mine_posts_path
        end
      end
    end
  end
end
