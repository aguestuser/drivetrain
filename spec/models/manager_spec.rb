# == Schema Information
#
# Table name: managers
#
#  id            :integer          not null, primary key
#  restaurant_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'

describe Manager do
  
  let(:manager) { FactoryGirl.create(:manager, :without_restaurant) }
  subject { manager }

  describe "validation" do
    it { should be_valid }
  end

  describe "associations" do

    describe "with Restaurant model" do
      it { should respond_to :restaurant_id }
    end

    describe "with UserInfo model" do
      it { should respond_to(:user_info)}
      its(:email) { should eq manager.user_info.email }
      its(:title) { should eq manager.user_info.title }
    end
  end
end
