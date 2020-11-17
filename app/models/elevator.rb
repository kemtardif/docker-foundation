
class Elevator < ApplicationRecord
    belongs_to :column

    after_update :call_tech
    has_many :interventions
    

    private
        def call_tech 
            if self.status == "Intervention" or self.status == "intervention" then 
                message = "The Elevator with id '#{self.id}', in building with id '#{self.column.battery.building.id}' needs to be repaired by '#{self.column.battery.building.tect_contact_name}'. His phone number is '#{self.column.battery.building.tect_contact_phone}'"
                TwilioTextMessenger.new(message).call
            end
        end
        
    around_update :notify_system_if_name_is_changed
    
    private

    def notify_system_if_name_is_changed
            notify = self.status_changed? 
            puts ENV["SLACK_API"]
            if notify
                notifier = Slack::Notifier.new ENV["SLACK_API"] 
                notifier.ping "The Elevator with id '#{self.id}' With serial number '#{self.serial_number}' change status from '#{self.status_was}' to '#{self.status}'"
            end
            yield
            
        
    end

    


end

