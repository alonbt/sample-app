require 'spec_helper'

describe "Static pages" do 
  
  let(:base_title) { "Alon Bartur test app"}
  
  subject { page }
  
  describe "Home page" do   
    before { visit root_path }
       
    it { should have_selector 'h1', text: "Sample App" }
    it { should have_selector 'title', text: full_title('') } 
    it { should_not have_selector 'title', text: '| Home' }
  end
  
  describe "Help page" do
    before { visit help_path }
    
    it {should have_selector 'title', text: full_title('Help') }
    it {should have_content 'Help' }
  end
  
  describe "About page" do
    
    before { visit about_path }
    
    it {should have_selector 'title', text: full_title('About us') }
    it {should have_content 'About us'}  
  end
  
  describe "Contact page" do
    
    before { visit contact_path }
    
    it {should have_selector 'title', text: full_title('Contact us') }
    it {should have_content 'Contact us' }
    
  end
  
end