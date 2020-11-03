class Address < ApplicationRecord
    has_one :customer
    has_one :building
    geocoded_by :full_street_address    # can also be an IP address
    after_validation :geocode           # auto-fetch coordinates
end
