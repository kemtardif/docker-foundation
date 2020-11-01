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

## SendGrid

### Requirements:

The SendGrid API is a historic and essential service provider in the field of email communication.


- The website's “Contact Us” form will send a transactional thank-you email with an dynamic template using the full name, company name and email from the inputs.


### Gems used:

```ruby 
gem 'sendgrid-ruby' # Ruby wrapper for the REST API at https://www.sendgrid.com

gem 'figaro' #Simple, Heroku-friendly Rails app configuration using ENV and a single YAML file
```

### Explanations:
Incorporating the code below to the existing `create` function at `leads_controller.rb` for call the API and use de gem `'sendgrid-ruby'`, it will get the params from the contact us form and get the dynamic template from sendgrid in order to send the email.
```ruby
  require 'sendgrid-ruby'
  include SendGrid
  def SendGrid_compute
    full_name = params[:full_name]
    email = params[:email]
    project_name = params[:project_name]
      
    mail = Mail.new
    mail.from = Email.new(email: 'cindy-okino@hotmail.com')
    personalization = Personalization.new
    personalization.add_to(Email.new(email: email))
    personalization.add_dynamic_template_data({
      "fullName" => full_name,
      "projectName" => project_name
    })
    mail.add_personalization(personalization)
    mail.template_id = 'd-c6ab731e2c5249cf8f7405d6cf96fbfe'
    
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    begin
        response = sg.client.mail._("send").post(request_body: mail.to_json)
    rescue Exception => e
        puts e.message
    end 
  end
  ```
  
## Dropbox

### Requirements:

The dropbox API will make possible to archive the Rocket Elevators attached files in the cloud.


- The website's “Contact Us” form can receive files that will be stored at the database as a binary file.
- When a contact becomes a customer it will trigger an
archiving procedure following these steps:
  1. Connect to the Rocket Elevators DropBox account
  2. Create a directory in DropBox on behalf of the client if the client does not already
exist
  3. Extract the file stored in the binary field of the MySQL database
  4. Copy this file to the client DropBox directory
  5. If the document is successfully downloaded to Dropbox, the controller deletes the
content of the binary field from the database to avoid duplication


### Gems used:

```ruby 
gem 'dropbox_api' # https://github.com/Jesus/dropbox_api
```

### Explanations:
Incorporating the code below at `customer.rb` file for call the API and use de gem `'sendgrid-ruby'`, creating the function `migrate_attachments_to_dropbox` and calling it with `after_update :migrate_attachments_to_dropbox` when a customer is created or updated.
```ruby
 after_update :migrate_attachments_to_dropbox  # This line calls the function below after create or update a customer


  # Function to connect to the dropbox account, create a diretory for the client, export the binary files to dropbox client's directory, delete the binary file from MySQL database 
    def migrate_attachments_to_dropbox
      puts self.id
      dropbox_client = DropboxApi::Client.new

      begin           
          dropbox_client.create_folder "/customer_id_" + self.id.to_s   # create a folder named (use the customer_id) if there is no folder for this customer yet
      rescue DropboxApi::Errors::FolderConflictError => err
        puts "Folder already exists in path, ignoring folder creation. Continue to upload files."
      end  

      puts self.sta_mail    
      Lead.where(email: sta_mail).each do |lead|  # for each lead that has this email       
      unless lead.attached_file.nil?  # check if the attached_file is NOT null
        puts "This model has blob"
        begin
          dropbox_client.upload("/customer_id_" + self.id.to_s + "/attachment_" + lead.id.to_s, lead.attached_file)    # send file to user's folder at dropbox
        rescue DropboxApi::Errors::FileConflictError => err
          puts "File already exists in folder, ignoring file upload. Continue to delete file from database."
        end  

        lead.attached_file = nil;
        lead.save!
      end
    end

    # The puts below should not be printed if the blob was correctly deleted from the db after the file was sent to dropbox (see code above)
    Lead.where(email: sta_mail).each do |lead|
      unless lead.attached_file.nil?
        puts "===================The BLOB was not deleted!======================"        
      end
    end  
    end
  ```

## Developpers
- Cindy Okino (Team Leader)
- Kem Tardif
- Kiefer Rivard
- Teddy Blanco