Given /^a user visits the signin page$/ do
  visit signin_path
end

When /^he submits invalid signin information$/ do
  click_button "Sign in"
end

Then /^he should see an error message$/ do
  page.should have_selector('div.alert.alert-error')
end

And /^the user has an account$/ do
  @user = User.create(name: "Alon Bartur", email: "alonbt@gmail.com", password: "Blabla", password_confirmation: "Blabla")
end

And /^the user submits valid siginin information$/ do
  fill_in "Email",    with: @user.email
  fill_in "Password", with: @user.password
  click_button "Sign in"
end

Then /^he should see his profile page$/ do
  page.should have_selector('title', text: @user.name)
end

And /^he should see a signout link$/ do
  page.should have_link("Sign out", href: signout_path)
end