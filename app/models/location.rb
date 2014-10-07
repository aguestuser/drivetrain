# == Schema Information
#
# Table name: locations
#
#  id             :integer          not null, primary key
#  locatable_id   :integer
#  locatable_type :string(255)
#  address        :string(255)
#  borough        :string(255)
#  neighborhood   :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  lat            :decimal(, )
#  lng            :decimal(, )
#

class Location < ActiveRecord::Base
  include Importable
  #associations
  belongs_to :locatable, polymorphic: :true

  #enums
  classy_enum_attr :borough, allow_nil: true 
  classy_enum_attr :neighborhood, allow_nil: true  
  
  #before filters
  before_save { address.strip! }

  #validations
  # VALID_STREET_ADDRESS = /\A((?!brooklyn|manhattan|queens|bronx|staten island|nyc|NY).)*\z/i
  validates :address, :borough, :neighborhood, 
    presence: true

  EXPORT_COLUMNS = [ 'address' ]
  EXPORT_HEADERS = EXPORT_COLUMNS

  def full_address
    "#{self.address}, #{self.borough.text} [#{self.neighborhood.text}]"
  end  
end
