require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do

    it "name, email, password, password_confirmationが揃った場合、登録可能" do
      user = build(:user)  # FactoryBotを使ってUserインスタンスを作成
      expect(user).to be_valid  # バリデーションが通るか確認
      expect(user.errors).to be_empty  # エラーメッセージが空であることを確認
    end

    it "ニックネームがない場合、登録不可" do
      user = build(:user, name: nil)  # nameをnilにして作成
      expect(user).not_to be_valid  # バリデーションエラーが出ることを確認
      expect(user.errors.full_messages).to include("ニックネームを入力してください")  # エラーメッセージが正しいことを確認
    end

    it "メールアドレスがない場合、登録不可" do
      user = build(:user, email: nil)  # emailをnilにして作成
      expect(user).not_to be_valid  # バリデーションエラーが出ることを確認
      expect(user.errors.full_messages).to include("メールアドレスを入力してください")  # エラーメッセージが正しいことを確認
    end

    it "パスワードが3文字以下の場合、登録不可" do
      user = build(:user, password: nil)  # passwordをnilにして作成
      expect(user).not_to be_valid  # バリデーションエラーが出ることを確認
      expect(user.errors.full_messages).to include("パスワードは3文字以上で入力してください")  # エラーメッセージが正しいことを確認
    end

    it "パスワード確認がない場合、登録不可" do
      user = build(:user, password_confirmation: nil)  # password_confirmationをnilにして作成
      expect(user).not_to be_valid  # バリデーションエラーが出ることを確認
      expect(user.errors.full_messages).to include("パスワード確認を入力してください")  # エラーメッセージが正しいことを確認
    end


    it "パスワードと確認パスワードが一致しない場合、登録不可" do
      user = build(:user, password: "honto", password_confirmation: "honma")  # パスワードが一致しない場合
      expect(user).not_to be_valid  # バリデーションエラーが出ることを確認
      expect(user.errors.full_messages).to include("パスワード確認とパスワードの入力が一致しません")  # エラーメッセージが正しいことを確認
    end

    it "emailがユニークでない場合、登録不可" do
      create(:user, email: "test@example.com")  # 同じemailを持つユーザーを作成
      user = build(:user, email: "test@example.com")  # 同じemailで作成
      expect(user).not_to be_valid  # バリデーションエラーが出ることを確認
      expect(user.errors.full_messages).to include("メールアドレスはすでに存在します")  # エラーメッセージが正しいことを確認
    end

    it "reset_password_tokenがユニークでない場合、登録不可" do
      create(:user, reset_password_token: "duplicate_token")  # 同じreset_password_tokenを持つユーザーを作成
      user = build(:user, reset_password_token: "duplicate_token")  # 同じreset_password_tokenで作成
      expect(user).not_to be_valid  # バリデーションエラーが出ることを確認
      expect(user.errors.full_messages).to include("Reset password tokenはすでに存在します")  # エラーメッセージが正しいことを確認
    end
  end
end
