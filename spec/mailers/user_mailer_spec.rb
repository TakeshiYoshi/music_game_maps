require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'アカウント有効化メール' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.activation_needed_email(user) }

    it 'ユーザのemailにメールが送信されること' do
      expect(mail.to).to eq [user.email]
    end

    it '件名が「アカウントの有効化をして下さい」であること' do
      expect(mail.subject).to eq 'アカウントの有効化をして下さい'
    end

    it '本文にアクティベーション用のURLが含まれていること' do
      expect(mail.body).to have_content(activate_user_url(user.activation_token))
    end
  end

  describe 'アカウント有効化完了メール' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.activation_success_email(user) }

    it 'ユーザのemailにメールが送信されること' do
      expect(mail.to).to eq [user.email]
    end

    it '件名が「あなたのアカウントが有効化されました！」であること' do
      expect(mail.subject).to eq 'あなたのアカウントが有効化されました！'
    end

    it '本文にログインページのURLが含まれていること' do
      expect(mail.body).to have_content(login_url)
    end
  end

  describe 'パスワードリセットメール' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.reset_password_email(user) }

    before { user.generate_reset_password_token! }

    it 'ユーザのemailにメールが送信されること' do
      expect(mail.to).to eq [user.email]
    end

    it '件名が「パスワード再発行」であること' do
      expect(mail.subject).to eq 'パスワード再発行'
    end

    it '本文にログインページのURLが含まれていること' do
      expect(mail.body).to have_content(edit_password_reset_url(user.reset_password_token))
    end
  end
end
