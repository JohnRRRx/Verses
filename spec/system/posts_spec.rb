require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context '新規投稿ページにアクセス' do
        it '新規投稿ページへのアクセスが失敗する' do
          visit new_post_path
          expect(current_path).to eq login_path
        end
      end

      context '投稿編集ページにアクセス' do
        it '投稿編集ページへのアクセスが失敗する' do
          visit edit_post_path(post)
          expect(current_path).to eq login_path
        end
      end

      context '投稿詳細ページにアクセス' do
        it '投稿の詳細情報が表示される' do
          visit post_path(post)
          expect(page).to have_content post.title
          expect(current_path).to eq post_path(post)
        end
      end

      context '投稿一覧ページにアクセス' do
        it '全投稿が表示される' do
          post_list = create_list(:post, 3)
          visit posts_path
          expect(page).to have_content post_list[0].title
          expect(page).to have_content post_list[1].title
          expect(page).to have_content post_list[2].title
          expect(current_path).to eq posts_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe '新規投稿' do
      context 'フォームの入力値が正常' do
        it '新規投稿成功' do
          visit new_post_path
          fill_in 'Title', with: 'test_title'
          fill_in 'Content', with: 'test_content'
          select 'doing', from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 6, 1, 10, 30)
          click_button 'Create post'
          expect(page).to have_content 'Title: test_title'
          expect(page).to have_content 'Photo: test_content'
          expect(page).to have_content 'Song_id: doing'
          expect(page).to have_content 'Tag: 2020/6/1 10:30'
          expect(current_path).to eq '/posts/1'
        end
      end

      context 'タイトル未入力' do
        it '投稿作成失敗' do
          visit new_post_path
          fill_in 'Title', with: ''
          fill_in 'Photo', with: 'test.jpg'
          fill_in 'Song_id', with: '2X0pcKFdtkbjKxtZlyZCkZ'
          click_button 'Create post'
          expect(page).to have_content '1 error prohibited this post from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq posts_path
        end
      end

      context '写真未選択' do
        it '投稿作成失敗' do
          visit new_post_path
          fill_in 'Title', with: 'test_title'
          fill_in 'Photo', with: ''
          fill_in 'Song_id', with: '2X0pcKFdtkbjKxtZlyZCkZ'
          click_button 'Create post'
          expect(page).to have_content '1 error prohibited this post from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq posts_path
        end
      end

      context '曲未選択' do
        it '投稿作成失敗' do
          visit new_post_path
          fill_in 'Title', with: 'test_title'
          fill_in 'Photo', with: 'test.jpg'
          fill_in 'Song_id', with: ''
          click_button 'Create post'
          expect(page).to have_content '1 error prohibited this post from being saved:'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq posts_path
        end
      end
    end
    describe '投稿編集' do
      let!(:post) { create(:post, user: user) }
      let(:other_post) { create(:post, user: user) }
      before { visit edit_post_path(post) }

      context 'フォームの入力値が正常' do
        it '投稿編集成功' do
          fill_in 'Title', with: 'updated_title'

          click_button 'Update post'
          expect(page).to have_content 'Title: updated_title'
          expect(page).to have_content 'Status: done'
          expect(page).to have_content 'post was successfully updated.'
          expect(current_path).to eq post_path(post)
        end
      end

      context 'タイトル未入力' do
        it '投稿編集失敗' do
          fill_in 'Title', with: nil
          select :todo, from: 'Status'
          click_button 'Update post'
          expect(page).to have_content '1 error prohibited this post from being saved'
          expect(page).to have_content "Title can't be blank"
          expect(current_path).to eq post_path(post)
        end
      end

      context '登録済のタイトルを入力' do
        it '投稿編集失敗' do
          fill_in 'Title', with: other_post.title
          select :todo, from: 'Status'
          click_button 'Update post'
          expect(page).to have_content '1 error prohibited this post from being saved'
          expect(page).to have_content "Title has already been taken"
          expect(current_path).to eq post_path(post)
        end
      end
    end
    describe '投稿削除' do
      let!(:post) { create(:post, user: user) }

      it '投稿削除成功' do
        visit posts_path
        click_link 'Destroy'
        expect(page.accept_confirm).to eq 'Are you sure?'
        expect(page).to have_content 'post was successfully destroyed'
        expect(current_path).to eq posts_path
        expect(page).not_to have_content post.title
      end
    end
  end
end