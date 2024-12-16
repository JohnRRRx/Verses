require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    context 'フォームの入力値正常' do
      it 'ログイン成功' do
        visit login_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect_text('ログインしました')
        expect(current_path).to eq root_path
      end
    end

    context 'フォーム未入力' do
      it 'ログイン失敗' do
        visit login_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect_text('ログインに失敗しました')
        expect(current_path).to eq login_path
      end
    end

    context '間違ったメールアドレスでログイン' do
      it 'ログイン失敗' do
        visit login_path
        fill_in 'メールアドレス', with: 'wrong@example.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect_text('ログインに失敗しました')
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト成功' do
        login_as(user)
        navibar_click
        click_link 'ログアウト'
        expect_text('ログアウトしました')
        expect(current_path).to eq root_path
      end
    end
  end
end
