require 'spec_helper'

describe "Authentication" do
  subject { page }
  
  describe "signin page" do
    before {visit signin_path }
    
    it {should have_selector("h1",    text: "Sign in") }
    it {should have_title("Sign in")}
  
    describe "with invalid information" do
      before {click_button "Sign in" }
      
      it {should have_selector("title", text: "Sign in")}
      it {should have_error_message('Invalid')}
      
      describe "after visitin another page" do
        before {visit root_path}
        it {should_not have_error_message('Invalid')}
      end
    end
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user}
      
      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      
      describe "following sign out" do
        before { click_link "Sign out" }
        it { should_not have_link("Sign out") }
        it { should have_link("Sign in") }
      end    
    end
  end    
  
  describe "authorisation" do
    describe "for non signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "when attempting to visit a connected page" do
        before do
          visit edit_user_path user
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        
        describe "after sign in" do
          it { should have_selector("title", text: "Edit user" )}
        end
        
      end
      
      describe "in the Users control" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector("title", text: "Sign in") }
        end
        
        describe "visiting the user index" do
          before { visit users_path }
          it {should have_selector("h1", text: "Sign in") }
        end
        
        describe "submitting to the User update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end
    
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@email.com") }
      before { sign_in user}
      
      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector("title", text: full_title("Edit user"))}
      end
      
      describe "submitting a PUT request to Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
