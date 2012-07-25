require 'spec_helper'

describe "Static pages" do
  
  let(:base_title) { "Alon Bartur test app"}
  
  describe "Home page" do

    it "should have the right title" do 
      visit root_path
      page.should have_selector('title', 
                                :text => "#{base_title}")
    end

    it "should have the content 'Sample App'" do
      visit root_path
      page.should have_content('Sample App')
    end
    
    it "should not have a custom page title" do
      visit root_path
      page.should_not have_selector('title', :text => '| Home')
    end

  end
  
  describe "Help page" do
  
    it "should have the right title" do
      visit help_path
      page.should have_selector('title', 
                                :text => "#{base_title} | Help")
    end
    
    it "should have the content 'Help'" do
      visit help_path
      page.should have_content('Help')
    end
  end
  
  describe "About page" do
  
    it "should have the right title" do
      visit about_path
      page.should have_selector('title', 
                                :text => "#{base_title} | About us")
    end
  
    it "should have the content 'About us'" do
      visit about_path
      page.should have_content('About us')
    end
  end
  
  describe "Contact page" do
    it "should have the right title" do
      visit contact_path
      page.should have_selector('title',
                                 :text => "#{base_title} | Contact us")
    end
    it "should have the content 'Contact us'" do
      visit contact_path
      page.should have_content('Contact us') 
    end
  end
  
end