class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @posts = Post.includes(:user, :tags).order(created_at: :desc)
    return unless params[:tag]
    @posts = @posts.tagged_with(params[:tag])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: t('message.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @emojis = ReactionsController.new.index
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: t('message.updated')
    else
      flash.now[:error] = t('message.not_updated')
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    query = params[:query]
    tracks = RSpotify::Track.search(query)
    render json: tracks.map { |track|
      {
        id: track.id,
        name: track.name,
        artist: track.artists.first.name,
        album: track.album.name,
        image_url: track.album.images.first['url']
      }
    }
  end

  def likes
    @like_posts = Post.joins(:likes)
    .where(likes: { user_id: current_user.id })
    .order(created_at: :desc)
  end

  def mine
    @mine = current_user.posts.order(created_at: :desc)
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
  
    if params[:tag] && request.referer&.include?("tag=#{params[:tag]}")
      redirect_to posts_path(tag: params[:tag]), notice: t('message.deleted'), status: :see_other
    elsif request.referer&.include?(likes_path)
      redirect_to likes_path, notice: t('message.deleted'), status: :see_other
    elsif request.referer&.include?(mine_posts_path)
      redirect_to mine_posts_path, notice: t('message.deleted'), status: :see_other
    else
      redirect_to posts_path, notice: t('message.deleted'), status: :see_other
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :photo, :photo_cache, :song_id, :song_name, :artist_name, :album_name, :audio,
                                 :tag_list)
  end
end
