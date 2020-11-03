# Rocket_Elevators_API

Implementation of seven APIs on Rocket Elevator's RAILS application

## Zendesk

### Requirements:

The ZenDesk platform can be powered by a call to the API and the software can then process requests depending on the type.


- The website's “Contact Us” form creates a new “Question” type ticket in ZenDesk
- The website's “Get a Quote” form creates a new “Task” type ticket in ZenDesk
- The tickets created are visible in the ZenDesk Console and it is possible to respond to them or even manage a workflow for these contacts.
- The content of each ticket created must include the contact information which has been stored in the database:

Subject: [Full Name] *from* [Company Name]
Comment: *The contact* [Full Name] *from company* [Company Name] *can be reached at email*  [E-Mail Address] *and at phone number* [Phone]. [Department] *has a project named* [Project Name] *which would require contribution from Rocket Elevators. *
[Project Description]

*Attached Message:* [Message]

*The Contact uploaded an attachment*


### Gems used:

```ruby 
gem 'zendesk_api' # Ruby wrapper for the REST API at https://www.zendesk.com.

gem 'figaro' #Simple, Heroku-friendly Rails app configuration using ENV and a single YAML file
```

### Explanations:

https://tonted.zendesk.com/

Creating a helper `ticket_helper.rb` for call the API and use de gem `'zendesk_api'`, it will get the params of leads or quotes, format the ticket, and post them.
```ruby
require 'zendesk_api'

module TicketHelper
	def ticket(params)
		client = ZendeskAPI::Client.new do |config|
			
				config.url = "https://tonted.zendesk.com/api/v2"
				config.username = ENV["ZENDESK_USERNAME"]
				config.token = ENV["ZENDESK_TOKEN"]
				config.retry = true
				config.raise_error_when_rate_limited = false
				
				require 'logger'
				config.logger = Logger.new(STDOUT)				
		end

			subject = "#{params['full_name']} from #{params['company_name']}"
			comment = "The contact #{params['full_name']} from company #{params['company_name']} can be reached at email  #{params['email']} and at phone number #{params['phone_number']}. #{params['department']} has a project named #{params['project_name']} which would require contribution from Rocket Elevators.\n Project description: #{params['project_description']}\nAttached Message: #{params['message']}"

			ticket = ZendeskAPI::Ticket.new(client, :subject => subject, :comment => { :body => comment })
			ticket.save!
	end
end
```
In the controllers of leads and quotes we call a helpers called `ticket` with the parameters. *(exemple leads controller)*
```ruby
class LeadsController < ApplicationController
  def new  
    @lead = Lead.new     
  end

  def create        
    @lead = Lead.new(lead_params)   
    @lead.save!  
    helpers.ticket(lead_params)
  end
  
  def lead_params        
    params.permit(  :full_name,
      :company_name,
      :email,
      :phone_number,
      :project_name,
      :project_description,
      :department,
      :message,
      :attached_file )     
  end
end
```

## Developpers
- Cindy Okino (Team Leader)
- Kem Tardif
- Kiefer Rivard
- Teddy Blanco