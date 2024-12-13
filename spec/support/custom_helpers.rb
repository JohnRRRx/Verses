module CustomHelpers
  def login_as(user)
    visit root_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
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
end