class PostsController < ApplicationController
require 'itunes_search_api'

  def index
    @posts = Post.includes(:user)
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: t('defaults.flash_message.created')
    else
      flash.now[:error] = t('defaults.flash_message.not_created')
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: t('defaults.flash_message.updated')
    else
      flash.now[:error] = t('defaults.flash_message.not_updated')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to posts_path, notice: t('defaults.flash_message.deleted'), status: :see_other
  end

  def search
    @searchs = ITunesSearchAPI.search(
      :term => params[:term],
      :country => 'jp',
      :media => 'music',
      :lang => 'ja_jp',
      :limit => '4'
      ).each do |item|
        p item
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :photo, :photo_cache)
  end
end

