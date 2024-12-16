module CustomHelpers
  def login_as(user)
    visit root_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  def login_2nd(other_user)
    click_link 'ログイン'
    fill_in 'メールアドレス', with: other_user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  def logout
    navibar_click
    click_on 'ログアウト'
  end

  def expect_text(text)
    expect(page).to have_content(text)
  end

  def navibar_click
    find('i.fa-solid.fa-bars').click
  end

  def song_search_botton_click
    find('i.fa-solid.fa-magnifying-glass').click
  end

  def edit_botton_click
    find('i.fa-solid.fa-hammer').click
  end

  def check_no_like_buttons
    expect(page).to have_no_css("#unlike-button-for-post-#{post.id}")
    expect(page).to have_no_css("#like-button-for-post-#{post.id}")
  end

  def open_post_and_select_emoji(post, emoji)
    visit posts_path
    visit post_path(post)
    find('label[for="emoji-toggle"]').click
    find('input.emoji-button[value="' + emoji + '"]').click
  end

  def expect_emoji_count(count_span_id, expected_count)
    expect(page).to have_css("##{count_span_id}", text: expected_count.to_s)
  end
end