class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :failure

  private

  def not_authenticated
    redirect_to login_path, error: t('message.require_login')
  end
end
