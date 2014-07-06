module RestaurantEnums
  class Statuses
    include Enum
    define :NEW_ACCOUNT, 'New account'
    define :STABLE, 'Stable'
    define :AT_RISK, 'At risk'
    define :AT_HIGH_RISK, 'At high risk'
    define :EMERGENCY_ONLY, 'Emergency only'
    define :VARIABLE_NEEDS, 'Variable needs'
    define :INACTIVE, 'Inactive'
  end

  class RiderPaymentMethods
    include Enum
    define :CASH, 'Cash'
    define :CHECK, 'Check (on the books)'
  end

  class AgencyPaymentMethods
    include Enum
    define :CASH, 'Cash'
    define :CHECK, 'Check'
    define :SQUARE_APP, 'Square App'
    define :VENMO, 'Venmo'
  end
end