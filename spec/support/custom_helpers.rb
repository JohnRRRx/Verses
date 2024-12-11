module CustomHelpers
  def login_as(user)
    visit root_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end

  def expect_message(message)
    expect(page).to have_content(message)
  end

  def navibar_click
    find('i.fa-solid.fa-bars').click
  end
  
end