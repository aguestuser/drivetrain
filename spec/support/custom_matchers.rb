module CustomMatchers

  Capybara.add_selector(:link_by_href) do
    xpath {|href| ".//a[@href='#{href}']"}
  end

  RSpec::Matchers.define :have_an_error_message do
    match do |page|
      expect(page).to have_selector('div.alert.alert-error')
    end
  end

  RSpec::Matchers.define :is_selected? do |select_id, option|
    match do |page|
      expect(page).to have_select(select_id, selected: option)
    end    
  end

  RSpec::Matchers.define :have_error_message do |message|
    match do |page|
      expect(page).to have_selector('div.alert.alert-error', text: message)
    end
  end


  RSpec::Matchers.define :have_h1 do |heading|
    match do |page|
      expect(page).to have_selector('h1', text: heading)
    end
  end

  RSpec::Matchers.define :have_h2 do |heading|
    match do |page|
      expect(page).to have_selector('h2', text: heading)
    end
  end  

  RSpec::Matchers.define :have_h3 do |heading|
    match do |page|
      expect(page).to have_selector('h3', text: heading)
    end
  end

  RSpec::Matchers.define :have_label do |text|
    match do |page|
      expect(page).to have_selector('label', text: text)
    end
  end

  RSpec::Matchers.define :have_row_header do |text|
    match do |page|
      expect(page).to have_selector('div.header', text: text)
    end
  end


  RSpec::Matchers.define :have_success_message do |heading|
    match do |page|
      expect(page).to have_selector('h1', text: heading)
    end
  end

  RSpec::Matchers.define :have_a_success_message do
    match do |page|
      expect(page).to have_selector('div.alert.alert-success')
    end
  end


  RSpec::Matchers.define :have_success_message do |message|
    match do |page|
      expect(page).to have_selector('div.alert.alert-success', text: message)
    end
  end

  #authorization matchers

  RSpec::Matchers.define :have_sign_out_link do
    match do |page|
      expect(page).to have_link('Sign out', href: signout_path)
    end
  end

  RSpec::Matchers.define :have_a_delete_link do
    match do |page|
      expect(page).to have_link('delete')
    end
  end

  RSpec::Matchers.define :have_delete_link_for_user do |user|
    match do |page|
      expect(page).to have_link('delete', href: user_path(user))
    end
  end

  RSpec::Matchers.define :have_signed_in_nav_links_for_user do |user|
    match do |page|
      expect(page).to have_link('Users', href: users_path)
      expect(page).to have_link('Profile', href: user_path(user))
      expect(page).to have_link('Sign out', href: signout_path) 
      expect(page).to have_link('Settings', href: edit_user_path(user))
    end
  end

  RSpec::Matchers.define :have_sign_in_link do
    match do |page|
      expect(page).to have_link('Sign in', href: signin_path)
    end
  end


end

