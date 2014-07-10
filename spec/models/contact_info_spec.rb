# == Schema Information
#
# Table name: contact_infos
#
#  id           :integer          not null, primary key
#  phone        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  contact_id   :integer
#  contact_type :string(255)
#  name         :string(255)
#

require 'spec_helper'
include ContactInfoMacros

describe ContactInfo do

  let(:contact_info) { FactoryGirl.build(:contact_info) }
  subject { contact_info }

  describe "attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:title) }
    it { should respond_to(:phone) }
    it { should respond_to(:email) }
    it { should respond_to(:street_address) }
    it { should respond_to(:borough) }
    it { should respond_to(:neighborhood) }
  end

  describe "validation" do
    # before { contact_info.save }
    it { should be_valid }
    let!(:staffer) { FactoryGirl.build(:staffer) }
    let!(:restaurant) { FactoryGirl.build(:restaurant) }
    # let!(:rider) { FactoryGirl.build(:rider) }

    describe "of phone number" do
      
      describe "with blank value" do
        before { contact_info.phone = '' }
        it { should_not be_valid }
      end
      describe "with non-numeric characters" do
        before { contact_info.phone =  'A11-111-1111' }
        it { should_not be_valid }
      end
      describe "with the wrong number of characters" do
        before { contact_info.phone =  '11-111-1111' }
        it { should_not be_valid }
      end      
    end

    describe "of email address" do
      
      describe "with blank value" do
        before { contact_info.email = '' }
        it { should_not be_valid }
      end
      describe "with improperly formatted address" do
        it 'should be invalid' do
          addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
          addresses.each do |invalid_address|
            contact_info.email = invalid_address
            expect(contact_info).not_to be_valid
          end      
        end
      end
      describe "with pre-existing address" do
        before { contact_info.save }
        let(:new_contact_info) { contact_info.dup }
        specify { expect(new_contact_info).not_to be_valid }
       end 
    end

    describe "of location attributes" do
      
      subject { restaurant.contact_info }

      describe "of street address" do
        
        describe "with no value" do

          describe "for Staffers" do
            before { staffer.contact_info.street_address = nil }
            subject { staffer.contact_info }
            it { should be_valid }
          end

          describe "for Restaurants" do
            before { restaurant.contact_info.street_address = nil }
            subject { staffer.contact_info }
            it { should be_valid }
          end

          # describe "for Riders" do
          #   before { contact_info.contactable_type = "Riders" }
          #   it { should be_valid }            
          # end
        end

        describe "with borough in address" do
          
          before { restaurant.contact_info.street_address = '111 Brooklyn' }  

          it "should not be valid" do
            check_borough_in_address(restaurant.contact_info)
          end
        end
        describe "with 'NY' in address" do
          before { restaurant.contact_info.street_address = "333 NY" }
          it { should_not be_valid }
        end
      end

      describe "of borough" do
        
        describe "with no value" do
          before { restaurant.contact_info.borough = nil }
          it { should_not be_valid }
        end
        describe "with incorrect value" do
          before { restaurant.contact_info.borough = 'long island' }
          it { should_not be_valid }
        end
      end

      describe "of neighborhood" do
        
        describe "with no value" do
          before { restaurant.contact_info.neighborhood = nil }
          it { should_not be_valid }
        end
        describe "with incorrect value" do
          before { restaurant.contact_info.neighborhood = 'hoboken' }
          it { should_not be_valid }
        end
      end      
    end
  end
end