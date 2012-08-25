require 'spec_helper'

describe "User Pages" do
  
  subject { page }
  
  describe "signup page" do    
    before { visit signup_path }
    
    it {should have_selector('h1',     text: 'Sign up')}
    it {should have_selector('title',  text: full_title('Sign up'))}
  end
  
  describe "profile page" do   
    let(:user) { FactoryGirl.create(:user)}
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Barbara") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    
    before { visit user_path(user) }
      
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name)}
    
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end
  
  describe "signup" do
    before { visit signup_path }
    
     it { should have_button("Create my account") }
    
    let(:submit) { "Create my account"}
        
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submission" do
        before { click_button submit }
        
        it { should have_selector('title', text: "Sign up")}
        it { should have_content('error') }
        
      end
      
    end
    
    describe "with valid information" do
      before do
        fill_in "Name",                   with: "Alon Bartur"
        fill_in "Email",                  with: "alonbt@gmail.com"
        fill_in "Password",               with: "Blabla"
        fill_in "Confirmation",  with: "Blabla"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('alonbt@gmail.com') }
        
        it {should have_selector("title", text: user.name) }
        it {should have_selector("div.alert.alert-success", text:"Welcome #{user.name}") }
        it {should have_link('Sign out') }
      end 
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user)}
    
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    it { should have_button("Save changes") }

    describe "page" do
      it { should have_selector("h1", text: "Update your profile") }
      it { should have_selector("title", text: "Edit user") }
      it { should have_link("Change", href: 'http://gravatar.com/emails') }  
    end
    
    describe "with invalid information" do
      before {click_button "Save changes"}
      it { should have_selector('div.alert.alert-error') }
      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_name) {"New name"}
      let(:new_email) { "new_email@mail.com" }
      before do
        fill_in "Name",                   with: new_name
        fill_in "Email",                  with: new_email
        fill_in "Password",               with: user.password
        fill_in "Confirmation",  with: user.password_confirmation
        click_button "Save changes"
      end
      
      it { should have_selector('title', text: new_name) }
      it { should have_selector('h1', text: new_name) }
      it { should_not have_selector('div.alert.alert-error')}
      it { should have_link('Sign out', href: signout_path) }
      it { should have_link('Users', href: users_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
      
    end
        
  end
  
  describe "index" do
    
    let(:user) { FactoryGirl.create(:user) }
    before(:all) { 30.times {FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }
    
    before(:each) do
      sign_in user
      visit users_path
    end
    
    it { should have_selector("title", text: "All users") }
    it { should have_selector("h1", text: "All users") }
    
    describe "pagination" do
      it { should have_selector("div.pagination") }
      
        it "should list each user do" do
        User.paginate(page: 1).each do |user|
          page.should have_selector("li", text: user.name)
        end
      end
    end
    
    describe "delete links" do
      it { should_not have_link("Delete") }
      
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        
        
        it "can not delete his own link" do
          expect { delete user_path(admin) }.to_not change(User, :count).by(-1)
        end
        
        it { should have_link("Delete", href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click_link("Delete") }.to change(User, :count).by(-1)
        end
        it { should_not have_link("Delete", href: user_path(admin))}
              
      end
      
      describe "as non-admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }
        before { sign_in non_admin }
        
        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(root_path) }
        end      
      end
    end
  end 
  describe "signed in users" do
    let(:user) { FactoryGirl.create(:user)}   
    before do
      sign_in user
    end
    
    describe "submitting a POST request to the Users#new action" do
      before { redirect_to(signup_path) }
      it { should have_selector('title', text: 'Alon Bartur test app') }
    end
  end    
end
