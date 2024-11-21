class ReactionsController < ApplicationController

  EMOJI_CATEGORIES = {
    "Smileys & Emotion" => "1F600..1F64F",
    "People & Body" => "1F466..1F487",
    "Animals & Nature" => "1F400..1F4D3",
    "Food & Drink" => "1F32D..1F37F",
    "Travel & Places" => "1F30D..1F6D5",
    "Activities" => "1F383..1F6FF",
    "Objects" => "1F4A1..1F6D2",
    "Symbols" => "1F300..1F5FF",
    "Flags" => "1F1E6..1F1FF"
  }.freeze

  def index
    @emojis = generate_emojis
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

  def generate_emojis
    EMOJI_CATEGORIES.values.flat_map { |range| range_to_emojis(range) }
  end

  def range_to_emojis(range)
    start, finish = range.split('..').map { |code| code.to_i(16) }
    (start..finish).map { |cp| [cp].pack('U') }
  end
end