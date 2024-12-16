require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'パスワードリセットメール' do
    let(:user) { create :user }
    let(:mail) { UserMailer.reset_password_email(user) }

    before { user.generate_reset_password_token! }

    it 'メール内容が正しいこと' do
      expect do
        mail.deliver_now
      end.to change { ActionMailer::Base.deliveries.size }.by(1)

      expect(mail.subject).to eq('【Verses】パスワード再発行のご案内')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end
  end
end
