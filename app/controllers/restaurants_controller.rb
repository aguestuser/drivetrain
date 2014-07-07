class RestaurantsController < ApplicationController

  before_action :get_restaurant, only: [:show, :edit, :update, :destroy]
  # before_action :get_restaurant_and_children, only: [:update]

  def new
      @restaurant ||= Restaurant.new
      @restaurant.build_contact_info
      @restaurant.build_work_arrangement
      managers ||= @restaurant.managers.build
      managers.build_contact_info      
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      flash[:success] = "Profile created for #{@restaurant.name}"
      redirect_to @restaurant
    else
      render 'new'
    end
  end

  def show
    @contact_info = @restaurant.contact_info
    @work_arrangement = @restaurant.work_arrangement
    @managers = @restaurant.managers
  end

  def index
    @restaurants = Restaurant.all
  end

  def edit
  end

  def update
    @restaurant.update(restaurant_params)
    if @restaurant.save
      flash[:success] = "#{@restaurant.name}'s profile has been updated"
      redirect_to @restaurant
    else
      render 'edit'
    end
  end

  private
    def get_restaurant
      @restaurant ||= Restaurant.find(params[:id])
    end

    # def get_restaurant_and_children
    #   @restaurant =Restaurant.includes(:managers).find(params[:id])
    # end

    def restaurant_params
      params.require(:restaurant)
        .permit(
          :active, :status, :description, :agency_payment_method, :pickup_required,
          contact_info_attributes:[ 
            :id, :name, :phone, :street_address, :borough, :neighborhood 
          ],
          managers_attributes: [ 
            :id, contact_info_attributes:[ 
              :id, :name, :title, :phone, :email 
            ] 
          ],
          work_arrangement_attributes:[ 
            :id, :zone, :daytime_volume, :evening_volume, 
            :rider_payment_method, :pay_rate, :shift_meal, :cash_out_tips, :rider_on_premises,
            :extra_work, :extra_work_description,
            :bike, :lock, :rack, :bag, :heated_bag 
          ] 
        )
    end 

    def get_enums
      # @boroughs = Boroughs
      # @neighborhoods = Neighborhoods
      # @statuses = Statuses
      # @rider_payment_methods = RiderPaymentMethods
      # @agency_payment_methods = AgencyPaymentMethods
    end

end

