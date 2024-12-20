class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user, :tags).order(created_at: :desc)

    return if params[:tag].blank?

    @posts = @posts.tagged_with(params[:tag])
  end

  def show
    @post = Post.find(params[:id])
    @emoji_categories = EMOJIS
  end

  def new
    @post = Post.new
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: t('message.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: t('message.updated')
    else
      flash.now[:error] = t('message.update_failure')
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

  def autocomplete
    query = params[:q]
  
    # 各フィールドごとに検索を実行し、結果を収集
    suggestions = []

    # title フィールドを検索
    Post.ransack(title_cont: query.presence).result.limit(5).each do |post|
      suggestions << { value: post.title, label: post.title }
    end

    # song_name フィールドを検索
    Post.ransack(song_name_cont: query.presence).result.limit(5).each do |post|
      suggestions << { value: post.song_name, label: post.song_name }
    end

    # artist_name フィールドを検索
    Post.ransack(artist_name_cont: query.presence).result.limit(5).each do |post|
      suggestions << { value: post.artist_name, label: post.artist_name }
    end

  # user_name フィールドを検索（関連付け）
  Post.ransack(user_name_cont: query.presence).result.limit(5).each do |post|
    suggestions << { value: post.user.name, label: post.user.name }
  end

  # tags_name フィールドを検索（acts-as-taggable-on のタグ）
  Post.ransack(tags_name_cont: query.presence).result.limit(5).each do |post|
    post.tags.each do |tag|
      suggestions << { value: tag.name, label: tag.name }
    end
  end

    # 重複を除外しつつ JSON 形式で返す
    render json: suggestions.uniq
  end

  private

  def post_params
    params.require(:post).permit(:title, :photo, :photo_cache, :song_id, :song_name, :artist_name, :album_name, :audio,
                                 :tag_list)
  end
end
