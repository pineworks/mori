module Helpers
  def log_in(email, pass)
    visit '/login'
    within '#new_session' do
      fill_in 'Email', :with => email
      fill_in 'Password', :with => pass
      click_button 'Log In'
    end
  end
end

