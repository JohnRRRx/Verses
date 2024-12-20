require 'rails_helper'

RSpec.describe 'Search', type: :system do
  describe '投稿に対する検索機能' do
    let(:user_a) { create(:user, name: '雪だるまつくろう') }
    let(:user_b) { create(:user, name: '自転車に乗ろう') }
    let(:user_c) { create(:user, name: '頑張れジャンヌ') }
    let!(:post_a) { create(:post, user: user_a, song_id: '3IUXXiSbJSUVcnKS6dmjxc', artist_name: 'Aimer', title: '黙って引っ張ったりしないでよ') }
    let!(:post_b) { create(:post, user: user_a, song_id: '2HovXsvcdJur52BOcYGydz', artist_name: 'Aimer', title: 'それでもうなずきながら一緒に歌ってくれるかな') }
    let!(:post_c) { create(:post, user: user_a, song_id: '6DYV1GqwCTrvfPcjeFwjLt', title: '息が詰まるような', tag_list: '聖☆おにいさん〜') }
    let!(:post_d) { create(:post, user: user_b, song_id: '7hfkRfHyg2M9QoKgTGJpqv', song_name: '決意の朝に', title: '辛い時 辛いと言えたらいいのになぁ') }
    let!(:post_e) { create(:post, user: user_c, song_id: '7hCrZjwlauy8LMU9z1XcO7', song_name: '決意の朝に', title: '辛い時 辛いと言えたらいいのになぁ') }

    before do
      login_as(user_a)
    end

    describe '検索機能' do
      describe 'title' do
        it 'タイトルで検索可能' do
          click_search_icon_and_input('辛い時 辛いと言えたらいいのになぁ')
          count_search_results(2)
        end
      end

      describe 'user' do
        it 'ニックネームで検索可能' do
          click_search_icon_and_input('雪だるまつくろう')
          count_search_results(3)
        end
      end

      describe 'tag' do
        it 'タグ名で検索可能' do
          click_search_icon_and_input('聖☆おにいさん')
          count_search_results(1)
        end
      end

      describe 'song_name' do
        it '曲名で検索可能' do
          click_search_icon_and_input('決意の朝に')
          count_search_results(2)
        end
      end

      describe 'artist_name' do
        it 'アーティスト名で検索可能' do
          click_search_icon_and_input('Aimer')
          count_search_results(2)
        end
      end
    end
  end
end
