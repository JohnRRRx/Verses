class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    if @user = login_from(provider)
      redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました。"
    else
      begin
        @user = create_from(provider)

        reset_session
        auto_login(@user)
        redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました。"
      rescue StandardError
        redirect_to root_path, alert: "#{provider.titleize}アカウントでのログインに失敗しました。"
      end
    end
  end
end
