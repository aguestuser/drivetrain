
##
# DOMAIN MODEL FOR BKS SHIFT ON RAILS

# AUTHOR:
# Austin Guest, 2014

# LICENSE:
# 	This is free software licensed under the GNU General Public License v3. 
# 	See http://www.gnu.org/licenses/gpl-3.0.txt for terms of the license.
##

require 'date'

class Main #is there any way to reflect the cateogry groupings I have accomplished through commenting below in a way that is reflected in the structure of the code? Is that necessary?
  #users/entities
  @staffers # arr of Staffers
  @restaurants # arr of Restaurants
  @owners # arr of Owners
  @managers # arr of Managers
  @riders # arr of Riders
  @edits # arr of Edits
  #scheduling
  @requests # arr of Requests
  @shifts # arr of Assignments
  @conflicts # arr of Conflicts
  @assignments # arr of Assignments
  @assignment_actions # arr of Assignment_Actions
  @assignment_responses # arr of Assignment_Responses
  #calendar
  @weeks # arr of Weeks
  @time_windows # arr of Time_Windows
  @calendars # arr of Calendars
  @events # arr of Events
  #mapping 
  @locations # arr of Locations (necessary???)
  #communication
  @schedule_emails # arr of Schedule_Emails (would it make more sense to group this with other scheduling attributes?)
  @invoice_emails # arr of Invoice_Emails (would it make more sense to group this with other billing attributes?)
  #billing
  @payments # arr of Payments
  @invoices # arr of Invoices

end

class User
  @username # str
  @password # str
  @name #str
  @contact_info # Contact_Info
  @created # Date
end

class Contact_Info
  @phone_numbers # arr of Phone_Numbers
  @email_addresses # arr of Email_Addresses
  @address # Location
end

class Phone_Number
  @type # Phone_Number_Types::ENUM
  @primary # bool
  @number # str
end

class Phone_Number_Types
  include Ruby::Enum
  define :WORK, 'Work'
  define :CELL, 'Cell'
  define :HOME, 'Home'
  define :PARENT, 'Parent'
  define :PARTNER, 'Partner'
end

class Email_Address
  @type # Email_Address_Types::ENUM
  @primary # bool
  @address # str
end

class Email_Address_Types
  include Rubby::Enum
  define :WORK, 'Work'
  define :PERSONAL, 'Personal'
end

class Location
  @address # str
  @lat # num
  @lng # str
  @borough # Boroughs::ENUM
  @neighborhood # Neighborhoods::ENUM
end

class Boroughs 
  include Ruby::Enum
  define :MANHATTAN, 'Manhattan'
  define :BROOKLYN, 'Brooklyn'
  define :QUEENS, 'Queens'
end

class Neighborhoods # note: will need to dynamically update this set of enums as we add more neighborhoods
  include Ruby::Enum
  define :PARK_SLOPE, 'Park Slope'
  define :FORT_GREENE, 'Fort Greene'
  define :PROSPECT_HEIGHTS, 'Prospect Heights'
  define :GOWANUS, 'Gowanus'
  define :BOERUM_HILL, 'Boerum Hill'
  define :FINANCIAL_DISTRICT, 'Financial District'
  define :LOWER_EAST_SIDE, 'Lower East Side'
  define :TRIBECA, 'Tribeca'
  define :CHELSEA, 'Chelsea'
  define :EAST_VILLAGE, 'East Village'
  define :WEST_VILLAGE, 'West Village'
  define :MIDTOWN_EAST, 'Midtown East'
  define :MIDTOWN_WEST, 'Midtown West'
  define :EAST_HARLEM, 'East Harlem'
  define :LONG_ISLAND_CITY, 'Long Island City'
end 

class Staffer < User
  @hire_date # Date
  @start_date # Date (if nil, same as @hire_date)
  @termination_date # Date
  @contact_info # Contact_Info
end

class Restaurant
  has_many :owners #Owner
  has_many :managers #Manager
  has_many :shifts # Shift
  has_many :assignments, through :shifts 
  has_one :balance
  has_one :rating


  @name #Str
  @location # Location
  @neighborhood # Neighborhood:ENUM
  @description # text


end

class Owner < User
  @restaurant # Restaurant
  TITLE #constant (title of any owner will always be "Owner" -- how do I specify that in Ruby syntax?)
end

class Manager < User
  @restaurant # Restaurant
  TITLE # CONSTANT 'Manager'
end

class Rider < User
  @nick_name #str
  @hire_date # Date
  @start_date # Date
  @termination_date # Date
  @skills # arr of Skills::ENUM
  @equipment # arr of Equipment::ENUM
  @experience # Experience
  @rating # Rating
  @active # bool
end

class Skills 
  include Ruby::Enum
  define :BIKE_REPAIR, 'bike repair'
  define :FIX_FLATS, 'fix flats'
  define :EARLY_MORNING, 'early morning'
  define :PIZZA, 'pizza'
end

class Equipment < Rider_Assets
  include Ruby::Enum
  define :BIKE, 'bike'
  define :BIKE_LOCK, 'bike lock'
  define :SMART_PHONE, 'smart phone'
  define :BAG, 'bag'
  define :HEATED_BAGE, 'heated bag'
  define :PUMP, 'pump'
  define :TUBES, 'tubes'
end

class Rating < Rider_Assets
  @hiring_assessment # str
  @likeability # num
  @reliability # num
  @punctuality # num
  @initial_points # num
  @points # num
end

class Experience < Rider_Assets
  @work # str 
  @geography # arr of Neighborhoods::ENUM
end


class Shift 
  belongs_to :restaurant # Restaurant
  @start # Date
  @end # Date
  @period # Periods::ENUM
  @time_windows # arr of Time_Windows
  @event # Event 
  @urgency #Urgencies::ENUM
  @billing_rate #Billing_Rates::ENUM
  @assignment # Assignment
  @notes # str
  @current # bool
  @modifies # arr of Shifts
end

class Periods
  include Ruby::Enum
  define :AM, 'am'
  define :PM, 'pm'
  define :DOUBLE, 'double'  
  # somewhat trivial question: instead of giving shifts and time_windows a @period
  # (with enums :AM, :PM, or :DOUBLE), i could instead give them an array of @periods
  # (with only enums :AM and :PM) and identify double shifts as having @periods.size > 1
  # as opposed to @period == :DOUBLE. not sure it matters in this instance, but is there 
  # a best practice i would observe by doing one or the other?
end

class Urgencies
  include Ruby::Enum
  define :WEEKLY, 'weekly'
  define :EXTRA, 'extra'
  define :EMERGENCY, 'emergency'
end

class Billing_Rates
  include Ruby::Enum
  define :NORMAL, 'normal'
  define :EXTRA, 'extra rider'
  define :EMERGENCY_EXTRA, 'emergency extra rider'
  define :LAST_MINUTE, 'last minute'
  define :FREE, 'free'
end

class Assignment
  belongs_to :shift # Shift
  belongs_to :rider # Rider
  belongs_to :time_window # TimeWindow
  
  @staffer # Staffer who made the assignment 
  @date # Date 
  @status # Assignment_Statuses::ENUM
  @current # bool
  @modifies # arr of Assignments that this assignment is an iteration of
            # ie: if the rider, status, or staffer handling the assignment changes, 
            # the assignment with "@current == true" will show the current status
            # and the @modifies attr of that Assignment will show the trail of prior Assignments it has taken the place of

end

class Assignment_Statuses
  include Ruby::Enum
  define :UNASSIGNED, 'unassigned'
  define :PROPOSED, 'proposed'
  define :DELEGATED, 'delegated'
  define :CONFIRMED, 'confirmed'
  define :REJECTED, 'rejected'
  define :CANCELLED_WITH_NOTICE, 'cancelled with notice'
  define :CANCELLED_LATE_NOTICE, 'cancelled late notice'
  define :NO_SHOW, 'no show'
end

class Assignment_Response
  @assignment # Assignment
  @rider # Rider
  @date # Date
  @response # Assignment_Responses::ENUM
end

class Assignment_Responses
  include Ruby::Enum
  define :CONFIRM, 'confirm'
  define :REJECT, 'reject'
  define :CANCEL, 'cancel'
  define :NO_SHOW, 'no show'
end

class AssignmentAction
  @assignment # Assignment
  @date # Date
  @staffer # Staffer
  @action # Assignment_Actions::ENUM
end

class Assignment_Actions < Assignment_Responses
  define :CREATE, 'create'
  define :PROPOSE, 'propose'
  define :DELEGATE, 'delegate'
end

class Request
  @shift # Shift
  @restaurant # Restaurant
  @staffer # Staffer
  @status # Request_Statuses::ENUM
end

class Request_Statuses
  include Ruby::Enum
  define :REQUESTED, 'requested'
  define :CANCELLED_WITH_NOTICE, 'cancelled with notice'
end

class Request_Actions
  include Ruby::Enum
  define :CREATE, 'create'
  define :CANCEL, 'cancel'
end

class Conflict
  @rider # Rider
  @start # Date
  @end # Date
  @time_windows # arr of Time_Windows
end

class Calendar
  @id # Google Calendar id
  @restaurant # Restaurant
end

class Event
  @id # Google Calendar Event id
  @calendar # Calendar
  @time_windows # arr of Time_Windows
end

class Week
  @start # Date
  @end # Date
  @time_windows # arr of Time_Windows
  has_many :invoices
  has_many :rider_schedules
  has_many :restaurant_schedules
  has_many :shifts, through :restaurant_schedules
end

class Time_Window
  @year # Date.year
  @month # Date.month
  @day # Date.mday
  @period # Periods.ENUM
  belongs_to :week
  has_many :assignments
  has_many :conflicts
  has_many :shifts
end

class Schedule
  belongs_to :week
  has_many :assignments
end



class Email
  @sender # Staffer
  @params # Email_Params
end

class Email_Params
  @to # str
  @subject # str
  @body # body
end

class Schedule_Email < Email
  @rider # Rider
  @shifts # arr of Shifts belonging to @rider
  @type # Email_Type
end

class Email_Type
  include Ruby::Enum
  define :WEEKLY, 'weekly'
  define :EXTRA_DELEGATION, 'extra delegation'
  define :EXTRA_CONFIRMATION, 'extra confirmation'
  define :EMERGENCY_DELEGATION, 'emergency delegation'
  define :EMERGENCY_CONFIRMATION, 'emergency confirmation'
end

class Invoice_Email < Email
  @restaurant # Restaurant
  @shifts # arr of Shifts belonging to @restaurant
end

class Invoice
  @restaurant # Restaurant
  @week # Week
  @date_issued # Date
  @shifts # arr of Shifts belonging to @restaurant during @week
  @fees # num
  @discount # num
  @revenue # num
  @tax # num
  @charge #num
  @balance # num
  @total_owed # num
  @paid_in_full? # bool
  @partial_payment_amount # num
end

class Payment
  @restaurant # Restaurant
  @amount_paid # num
  @payment_method # Payment_Methods::ENUM
  @check_num # num
  @date_paid # Date
  @invoices_paid # arr of Invoices
end

class Payment_Methods
  include Ruby::Enum
  define :CASH, 'cach'
  define :CHECK, 'check'
  define :CREDIT, 'credit'
  define :VENMO, 'Venmo'
  define :SQUARE_APP 'Square App'
end

class Balance
  @restaurant # Restaurant
  @amount # num
  @updated # date
  @current # bool
  @modifies # arr of Balances
end

class Edit
  @date # Date
  @user # User
  @obj_modified # str
  @old_state # obj 
  @new_state # obj
end
