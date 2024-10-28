class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @posts = Post.includes(:user, :tags)
    if params[:tag]
      @posts = @posts.tagged_with(params[:tag])
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: t('defaults.flash_message.created')
    else
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
    @like_posts = current_user.likes.map(&:post)
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to posts_path, notice: t('defaults.flash_message.deleted'), status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:title, :photo, :photo_cache, :song_id, :song_name, :artist_name, :album_name, :audio, :tag_list)
  end
end
