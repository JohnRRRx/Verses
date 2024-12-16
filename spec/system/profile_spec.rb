require 'rails_helper'

RSpec.describe 'Profile', type: :system do
  let(:user) { create(:user) }

  before { login_as(user) }

  describe 'プロフィール' do
    it 'プロフィール詳細が見られる' do
      navibar_click
      click_link 'プロフィール'
      Capybara.assert_current_path('/profile', ignore_query: true)
      expect(current_path).to eq(profile_path)
      expect_text(user.name)
      expect_text(user.email)
    end
  end

  describe 'プロフィール編集' do
    context 'フォームの入力値正常' do
      it 'ユーザー編集成功' do
        navibar_click
        click_link 'プロフィール'
        click_link '編集'
        attach_file 'user_icon', Rails.root.join('spec/support/assets/test.jpg')
        fill_in 'ニックネーム', with: 'update_name'
        fill_in 'メールアドレス', with: 'update@example.com'
        click_button '更新'
        expect(page).to have_content('プロフィールを更新しました')
        expect_text('update_name')
        expect_text('update@example.com')
        expect(current_path).to eq profile_path
      end
    end

    context 'ニックネーム未入力' do
      it 'ユーザー編集失敗' do
        navibar_click
        click_link 'プロフィール'
        click_link '編集'
        fill_in 'ニックネーム', with: ''
        fill_in 'メールアドレス', with: 'update@example.com'
        click_button '更新'
        expect_text('プロフィールを更新できませんでした')
        expect(page).to have_content('ニックネームを入力してください')
        expect(current_path).to eq edit_profile_path
      end
    end

    context 'メールアドレス未入力' do
      it 'メールアドレス編集失敗' do
        navibar_click
        click_link 'プロフィール'
        click_link '編集'
        fill_in 'ニックネーム', with: 'update_name'
        fill_in 'メールアドレス', with: ''
        click_button '更新'
        expect_text('プロフィールを更新できませんでした')
        expect(page).to have_content('メールアドレスを入力してください')
        expect(current_path).to eq edit_profile_path
      end
    end

    context '登録済のメールアドレス使用' do
      it 'メールアドレス編集失敗' do
        existed_user = create(:user)
        navibar_click
        click_link 'プロフィール'
        click_link '編集'
        fill_in 'ニックネーム', with: 'update_name'
        fill_in 'メールアドレス', with: existed_user.email
        click_button '更新'
        expect_text('プロフィールを更新できませんでした')
        expect_text('メールアドレスはすでに存在します')
        expect(current_path).to eq edit_profile_path
      end
    end
  end
end
