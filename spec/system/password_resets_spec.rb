require 'rails_helper'

RSpec.describe 'パスワードリセット', type: :system do
  let(:user) { create(:user) }

  describe '表示確認' do
    describe 'パスワードリセット申請ページ' do
      it '正しいタイトルが表示されている' do
        visit new_password_reset_path
        expect(page).to have_selector('.title', text: 'パスワードリセット申請')
      end
    end

    describe 'パスワードリセットページ' do
      it '正しい要素が表示されていること' do
        user.generate_reset_password_token!
        visit edit_password_reset_path(user.reset_password_token)
        puts page.body
        expect(page).to have_selector('.title', text: 'パスワードリセット')
        expect(page).to have_selector('label[for="user_email"]', text: 'メールアドレス')
      end
    end
  end

  it 'パスワード変更可能' do
    visit new_password_reset_path
    fill_in 'メールアドレス', with: user.email
    click_button '送信'
    expect_text('パスワードリセットメールを送信しました')
    visit edit_password_reset_path(user.reload.reset_password_token)
    fill_in 'パスワード', with: '123456789'
    fill_in 'パスワード確認', with: '123456789'
    click_button '送信'
    Capybara.assert_current_path("/login", ignore_query: true)
    expect(current_path).to eq(login_path)
    expect_text('パスワードを変更しました')
  end
end