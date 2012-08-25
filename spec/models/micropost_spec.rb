require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
  
  subject { @micropost }
  
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }  
  it { should respond_to(:user) }
  its(:user) { should == user }
  
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid}
  end
  
  describe "with more than 140 charecters" do
    before { @micropost.content = "A" * 141 }
    it { should_not be_valid }
  end
  
  describe "accesible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id:user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
end
