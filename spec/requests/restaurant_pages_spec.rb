require 'spec_helper'
include CustomMatchers, RestaurantPageMacros, RequestSpecMacros # /spec/support/

describe "Restaurant Pages" do

  let!(:restaurant) { FactoryGirl.build(:restaurant_partial) }
  let(:contact) { restaurant.mini_contact }
  let(:location) { restaurant.location }
  let(:manager) { restaurant.managers.first }
  let(:rider_payment) { restaurant.rider_payment_info }

  let!(:full_restaurant) { FactoryGirl.create(:restaurant) }
  let(:work_spec) { full_restaurant.work_specification }
  let(:agency_payment) { full_restaurant.agency_payment_info }
  let(:equipment_set) { full_restaurant.equipment_set }

  let(:staffer) { FactoryGirl.create(:staffer) }

  before { mock_sign_in staffer }

  subject { page }

  describe "display pages" do
  
    describe "Restaurants#show" do

      describe "with fully built model" do
        before { visit restaurant_path(full_restaurant) }

        it { should have_h1("#{full_restaurant.mini_contact.name}") }
        it { should have_h3("Shifts") }
        it { should have_h3("Contact Info") }
        it { should have_content('Address:') }
        it { should have_h3("Managers") }
        it { should have_h3("Rider Compensation") }
        it { should have_h3("Working Conditions") }
        it { should have_h3("Equipment") }
        it { should have_h3("Agency Compensation") }
      end

      describe "with partially built model" do
        before do 
          restaurant.save
          visit restaurant_path(restaurant)
        end

        it { should_not have_h3("Working Conditions") }
        it { should_not have_h3("Equipment") }
        it { should_not have_h3("Agency Compensation") }
      end
    end

    describe "Restaurants#index" do
      before(:all) { 3.times { FactoryGirl.create(:restaurant) } }
      after(:all) { Restaurant.last(3).each { |s| s.destroy } }
      before(:each) { visit restaurants_path }
      let(:names) { Restaurant.last(3).map { |s| s.mini_contact.name } }
      
      it "should contain names of last 3 staffers" do
        check_name_subheads names
      end 
      it { should have_h1('Restaurants') }
      it { should have_link('Create new restaurant', href: new_restaurant_path) }   
    end
  end

  describe "form pages" do

    describe "Restaurants#new" do
      
      before { visit new_restaurant_path }
      let(:new_form) { get_restaurant_form_hash 'new' }
      let(:submit) { 'Create Restaurant' }
      let(:models) { [ Restaurant, MiniContact, Location, Manager, Contact, RiderPaymentInfo ] }
      let!(:old_counts) { count_models models  }

      describe "page contents" do
        it { should_not have_h3('Status') }
        it { should have_h3('Contact Info') }
        it { should have_selector('label', text: 'Street address') }
        it { should have_h3('Managers') }
        it { should have_h3('Rider Compensation') }
        it { should_not have_h3('Working Conditions') }
        it { should_not have_h3('Equipment') }
        it { should_not have_h3('Agency Compensation') }
      end

      describe "form submission" do

        describe "with invalid input" do
          before { click_button submit }
          it { should have_an_error_message }
        end

        describe "with valid input" do

          before do 
            fill_in_form new_form
            click_button submit 
          end

          let(:new_counts) { count_models models }
          
          it "should create new instances of associated models" do
            check_model_counts_incremented old_counts, new_counts
          end        

          describe "after successful submission" do
            it { should have_success_message("Profile created for #{contact.name}") }
            it { should have_h1(contact.name) } 

            it { should_not have_h3("Working Conditions") }
            it { should_not have_h3("Equipment") }
            it { should_not have_h3("Agency Compensation") }            
          end      
        end
      end  
    end

    describe "Restaurants#edit" do
      before do
        restaurant.save
        visit edit_restaurant_path(restaurant)
      end
      let(:save) { "Save Changes" }
      let(:edit_form) { get_restaurant_form_hash 'edit' }
      let(:models) { [ WorkSpecification, AgencyPaymentInfo, EquipmentNeed ] }
      let!(:old_counts) { count_models models }

      describe "page contents" do
        it { should have_h3('Status') }
        it { should have_h3('Contact Info') }
        it { should have_selector('label', text: 'Street address') }
        it { should have_h3('Managers') }
        it { should have_h3('Rider Compensation') }
        it { should have_h3('Working Conditions') }
        it { should have_h3('Equipment') }
        it { should have_h3('Agency Compensation') }
      end

      describe "with invalid input" do
        before do 
          fill_in_form fields: { 'Restaurant name' => '' }, selects: {}, checkboxes: []
          click_button save
        end

        it { should have_an_error_message }
      end

      describe "with valid input" do
        before do 
          fill_in_form edit_form
          click_button save
        end

        let(:new_counts) { count_models models }

        it "should increment associated models" do
          check_model_counts_incremented old_counts, new_counts
        end

        it { should have_h1('Restaurants') }
        it { should have_success_message("Poop Palace's profile has been updated") }
        specify { expect(restaurant.mini_contact.reload.name).to eq 'Poop Palace' }
        specify { expect(restaurant.reload.location.reload.borough.text).to eq 'Staten Island' }
        specify { expect(restaurant.reload.equipment_need.reload.bike_provided).to eq true  }
      end
    end
  end
end