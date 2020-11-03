class Elevator < ApplicationRecord
    belongs_to :column
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

