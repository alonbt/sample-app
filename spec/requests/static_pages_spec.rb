require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the right title" do
      visit '/static_pages/home'
      page.should have_selector('title', 
                                :text => " | Home")
    end

    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_content('Sample App')
    end
  end
  
  describe "Help page" do
  
    it "should have the right title" do
      visit '/static_pages/help'
      page.should have_selector('title', 
                                :text => " | Help")
    end
    
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
  end
  
  describe "About page" do
  
    it "should have the right title" do
      visit '/static_pages/about'
      page.should have_selector('title', 
                                :text => " | About us")
    end
  
    it "should have the content 'About us'" do
      visit '/static_pages/about'
      page.should have_content('About us')
    end
  end
end