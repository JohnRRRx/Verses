require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーションチェック' do

    it "title, photo, song_idが揃った場合、投稿可能" do
      post = build(:post)  # FactoryBotを使ってPostインスタンスを作成
      expect(post).to be_valid  # バリデーションが通るか確認
      expect(post.errors).to be_empty  # エラーメッセージが空であることを確認
    end

    it "titleがない場合、投稿不可" do
      post = build(:post, title: nil)  # titleをnilにして作成
      expect(post).not_to be_valid  # バリデーションエラーが出ることを確認
      expect(post.errors.full_messages).to include("タイトルを入力してください")  # エラーメッセージが正しいことを確認
    end

    it "photoがない場合、投稿不可" do
      post = build(:post, photo: nil)
      expect(post).not_to be_valid
      expect(post.errors.full_messages).to include("写真を選択してください")
    end

    it "song_idがない場合、投稿不可" do
      post = build(:post, song_id: nil)
      expect(post).not_to be_valid
      expect(post.errors.full_messages).to include("曲を選択してください")
    end
  end

  describe '機能チェック' do
    it "タグの追加、保存可能" do
      post = build(:post, tag_list: ["tag1", "tag2", "tag3"])
      post.save
      expect(post.tags.count).to eq(3)  # 3つのタグが保存されていることを確認
      expect(post.tag_list).to include("tag1", "tag2", "tag3")  # タグのリストにすべてのタグが含まれていることを確認
    end

    it "同じタグを重複追加不可" do
      post = build(:post, tag_list: ["tag1", "tag1"])
      expect(post.save).to be_truthy  # 保存できることを確認
      expect(post.tag_list).to eq(["tag1"])  # タグが重複しないことを確認
    end

    it "タグを使って投稿を検索可能" do
      post1 = create(:post, tag_list: ["tag1"])
      post2 = create(:post, tag_list: ["tag2"])
      post3 = create(:post, tag_list: ["tag1", "tag2"])
    
      tagged_posts = Post.tagged_with("tag1")  # "tag1"のタグを持つ投稿を検索
    
      expect(tagged_posts).to include(post1, post3)  # "tag1"を持つ投稿が含まれていることを確認
      expect(tagged_posts).not_to include(post2)    # "tag2"だけの投稿は含まれないことを確認
    end

    it "タグ削除可能" do
      post = build(:post, tag_list: ["tag1", "tag2"])
      post.save
      post.tag_list = post.tag_list - ["tag1"]  # "tag1"を削除
      post.save
      expect(post.tag_list).not_to include("tag1")  # "tag1"が削除されたことを確認
    end

    it "投稿編集後、更新可能" do
      post = create(:post)  # 投稿作成
      post.update(title: "新しいタイトル")  # タイトルを更新
      expect(post).to be_valid  # 更新後、バリデーションが通ることを確認
      expect(post.title).to eq("新しいタイトル")  # 更新されたタイトルが反映されていることを確認
    end

    it "投稿削除可能" do
      post = create(:post)
      expect { post.destroy }.to change { Post.count }.by(-1)  # 投稿が1件減少することを確認
    end
  end
end
