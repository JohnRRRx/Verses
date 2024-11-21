class ReactionsController < ApplicationController

  def index
    @emojis = []
  end

  def create
    @post = Post.find(params[:post_id])
    @reaction = @post.reactions.create(reaction_params.merge(user: current_user))
  end

  def destroy
    @post = Post.find(params[:post_id])
    @reaction = @post.reactions.find_by(id: params[:id])
    @reaction&.destroy
  end

  private

  def reaction_params
    params.require(:emoji).permit(:emoji)
  end
end