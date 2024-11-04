class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]
  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, notice: t('profiles.updated')
    else
      flash.now['error'] = t('profiles.update_failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name, :icon, :icon_cache)
  end
end
