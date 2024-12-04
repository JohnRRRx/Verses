class ApplicationController < ActionController::Base
  before_action :require_login, :set_search
  add_flash_types :success, :failure

  private

  def set_search
    @q = Post.ransack(params[:q])
  end

  def not_authenticated
    redirect_to login_path, error: t('message.require_login')
  end
end
