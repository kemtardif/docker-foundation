require 'zendesk_api'

module TicketHelper
	def client_con
		client = ZendeskAPI::Client.new do |config|
			
			config.url = "https://tonted.zendesk.com/api/v2"
			config.username = ENV["ZENDESK_USERNAME"]
			config.token = ENV["ZENDESK_TOKEN"]
			config.retry = true
			config.raise_error_when_rate_limited = false
			
			require 'logger'
			config.logger = Logger.new(STDOUT)				
		end
		return client
	end

	def ticket_save(client, subject, comment)
		ticket = ZendeskAPI::Ticket.new(client, :subject => subject, :comment => { :body => comment })
		ticket.save!
	end

	def ticket_lead(params)
		client = client_con()

		subject = "#{params['full_name']} from #{params['company_name']}"
		comment = "The contact #{params['full_name']} from company #{params['company_name']} can be reached at email  #{params['email']} and at phone number #{params['phone_number']}. #{params['department']} has a project named #{params['project_name']} which would require contribution from Rocket Elevators.\n Project description: #{params['project_description']}\nAttached Message: #{params['message']}"

		ticket_save(client, subject, comment)
	end

	def ticket_quote(params)
		client = client_con()

		subject = "Quote for #{params['company_name']}"
		comment = "The company #{params['company_name']} has made an estimate for #{params['elevator_needed']} elevator(s) of the #{params['game']} game in a #{params['building_type']} building with #{params['floors_qty']} floors for a total amount of #{params['total_price']}.
		The contact email is #{params['email']}."

		ticket_save(client, subject, comment)
	end

end
