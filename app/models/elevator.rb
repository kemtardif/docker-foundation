class Elevator < ApplicationRecord
    belongs_to :column

    ##after_update :call_tech
    after_update :speak_for_me

    private
        def call_tech 
            if self.status == "Intervention" or self.status == "intervention" then 
                message = "The Elevator with id '#{self.id}', in building with id '#{self.column.battery.building.id}' needs to be repaired by '#{self.column.battery.building.tect_contact_name}'. His phone number is '#{self.column.battery.building.tect_contact_phone}'"
                TwilioTextMessenger.new(message).call
            end
        end

        def speak_for_me
            message = "Hello World"
            WatsonTextSpeech.new(message).speak
        end
end
