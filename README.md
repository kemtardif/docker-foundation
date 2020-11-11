# Rocket_Elevators_API

Implementation of seven APIs on Rocket Elevator's RAILS application

https://cindyokino.com/

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

To test this API, you will need to create one or more leads using the 'Contact Us' form and load a file, then you will have to go to the admin panel and create or edit a customer with the same email used to create the leads. Then you will be able to find your folder with the company name and files at dropbox!

Link to the dropbox folder: 
https://www.dropbox.com/sh/vmjyuwllrcsz79s/AAC2b_FrGy4Sm93C5C16DnG1a?dl=0

Login as an admin to acces the admin panel and create or edit a customer:
* admin@tonted.xyz
* password

### Gems used:

```ruby 
gem 'dropbox_api' # https://github.com/Jesus/dropbox_api
```

### Explanations:
Incorporating the code below at `customer.rb` file for call the API and use de gem `'dropbox_api'`, creating the function `migrate_attachments_to_dropbox` and calling it with `after_create :migrate_attachments_to_dropbox` and `after_update :migrate_attachments_to_dropbox` when a customer is created or updated.

```ruby
    after_create :migrate_attachments_to_dropbox
    after_update :migrate_attachments_to_dropbox  # This line calls the function below after create or update a customer


  # Logic to connect to the dropbox account, create a diretory for the client, export the binary files to dropbox client's directory, delete the binary file from MySQL database 
    def migrate_attachments_to_dropbox
      puts self.id
      dropbox_client = DropboxApi::Client.new
      
      puts self.cpy_contact_email    
      Lead.where(email: self.cpy_contact_email).each do |lead|  # for each lead that has this email       
        unless lead.attached_file.nil?  # check if the attached_file is NOT null
          puts "This model has blob"       
          dir_path = "/" + self.company_name   
          begin           
              dropbox_client.create_folder dir_path    # create a folder named (use the company_name) if there is no folder for this customer yet
          rescue DropboxApi::Errors::FolderConflictError => err
            puts "Folder already exists in path, ignoring folder creation. Continue to upload files."
          end  
          begin
            dropbox_client.upload(dir_path + "/" + lead.name_attached_file, lead.attached_file)    # send file to user's folder at dropbox
          rescue DropboxApi::Errors::FileConflictError => err
            puts "File already exists in folder, ignoring file upload. Continue to delete file from database."
          end  

          lead.attached_file = nil;
          lead.save!
        end
    end 
  end
  ```
  
## Slack API
### Requirements

    when a controller changes the status of an elevator, this status is reflected in the information system and persists in the operational database. 
    When these status changes occur, a message is sent to the slack “elevator_operations” channel to leave a written record.
    
    
## Gems used
   ```ruby
   gem 'slack-notifier'
   ```
   
### Explanations:
   
   incorporating the code below in the elevator model will send a message in this format "The Elevator [Elevator’s ID] with Serial Number [Serial Number] changed status from 	 [Old Status] to [New Status]" to the "elevator_operations" slack channel when an elevator status is changed. Here's the code in the model:
   
   ```ruby
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
   ```
    
    
 ##    𝓣𝓦𝓘𝓛𝓘𝓞 
 
 ### 𝓡𝓔𝓠𝓤𝓘𝓡𝓔𝓜𝓔𝓝𝓣𝓢 :
 
```
 If the status of an Elevator in the database changes to "Intervention" status, the building's technical contact must be identified and an SMS must be sent to the telephone number associated with this contact.
In this case, the designated contact must be the coach assigned to each team, and he must receive the alerts on his mobile phone.
```

### 𝓖𝓔𝓜 𝓤𝓢𝓔𝓓 : 

```
gem 'twilio-ruby'
```

### 𝓔𝓧𝓟𝓛𝓐𝓝𝓐𝓣𝓘𝓞𝓝𝓢 :

The speak method in the Twilio model make a call from a Twilio-generated number to a given number with a specified message : 

```ruby
def call
      client = Twilio::REST::Client.new
      client.messages.create({
        from: Figaro.env.twilio_phone_number,
        to: '+14388633515',
        body: message
      })
    end
```

The after_update helper in the elevator controller calls the call_tech method, which ensure that if the updated status is "Intervention" (or "intervention"), a new instance of 
the Twilio model is created, on which the call method is...called, with the appropriate message:

```ruby
    after_update :call_tech
    

    private
        def call_tech 
            if self.status == "Intervention" or self.status == "intervention" then 
                message = "The Elevator with id '#{self.id}', in building with id '#{self.column.battery.building.id}' needs to be repaired by '#{self.column.battery.building.tect_contact_name}'. His phone number is '#{self.column.battery.building.tect_contact_phone}'"
                TwilioTextMessenger.new(message).call
            end
        end
```

## 𝓦𝓐𝓣𝓢𝓞𝓝 𝓣𝓔𝓧𝓣-𝓣𝓞-𝓢𝓟𝓔𝓔𝓒𝓗

### 𝓡𝓔𝓠𝓤𝓘𝓡𝓔𝓜𝓔𝓝𝓣𝓢 :

```
Rocket Elevators wants to add text-to-speech functionality to their Home Dashboard (/ admin). We must have the option to start the every time the Admin Dashboard page appears.
The type of information that speech synthesis allows are the following:
Greetings to the logged users
There are currently XXX elevators deployed in the XXX buildings of your XXX customers
Currently, XXX elevators are not in Running Status and are being serviced
You currently have XXX quotes awaiting processing
You currently have XXX leads in your contact requests
XXX Batteries are deployed across XXX cities
To provide the type of voice summary described, it is necessary to execute the appropriate queries in the database to collect the relevant data. Then form sentences in English and combine them with the data collected.

```

### 𝓖𝓔𝓜 𝓤𝓢𝓔𝓓 : 

```
gem 'ibm_watson', git: 'https://github.com/watson-developer-cloud/ruby-sdk', branch: 'master'
```
### 𝓔𝓧𝓟𝓛𝓐𝓝𝓐𝓣𝓘𝓞𝓝𝓢 :

First, we make an xmlHTTP get request to the watson controller when the Tools tab is loaded:

```javascript
 $(document).ready(function(){
  			let xmlHttpRequest = new XMLHttpRequest(); 
             xmlHttpRequest.open("GET", "/watson"+ "?cb=" + new Date().getTime(), true);
             xmlHttpRequest.responseType = "blob"; 
             xmlHttpRequest.setRequestHeader("Accept", "application/json");
             xmlHttpRequest.setRequestHeader("Content-Type", "application/json"); 
             xmlHttpRequest.setRequestHeader("Cache-Control", "no-cache");
             xmlHttpRequest.onreadystatechange = function() {
               if (this.readyState == 4 && this.status == 200) {
                 var url = window.URL.createObjectURL(this.response);
                 var audio = $('#audio-player') || new Audio();
                 audio.src = url;

               }
             };
  
             xmlHttpRequest.send();   
  });
```
The end point will be the method call, which make make a call to the API with the approriate message. We then save the response as an mp3 file in the lib folder :

```ruby
 def speak
  
        authenticator = Authenticators::IamAuthenticator.new(
            apikey: ENV["TEXT_TO_SPEECH_IAM_APIKEY"]
        )
        text_to_speech = TextToSpeechV1.new(
            authenticator: authenticator
        )
        text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]
            
        message = "Greeting user #{current_user.id}. There is #{Elevator::count} elevators in #{Building::count} buildings of your 
                    #{Customer::count} customers. Currently, #{Elevator.where(status: 'Intervention').count} elevators are not in 
                    Running Status and are being serviced. You currently have #{Quote::count} quotes awaiting processing.
                    You currently have #{Lead::count} leads in your contact requests. 
                    #{Battery::count} Batteries are deployed across 
                    #{Address.where(id: Building.select(:address_id).distinct).select(:city).distinct.count} cities"

        response = text_to_speech.synthesize(
            text: message,
            accept: "audio/mp3",
            voice: "en-GB_KateV3Voice"
        ).result

        File.open("#{Rails.root}/public/outputs.mp3", "wb") do |audio_file|
                        audio_file.write(response)
        end    
    end
```

The source of the audio player will be this file, which is why we make the http request before the page loads. Note since we have to make to calls, one to the back-end and
one to the API, if there's any change in the values related to the message, the updated audio will take some time to load. For example, if you delete a customer,
it should take a minute before the message update with the new value. 


## ＷΞΛＴＨΞＲ░ΛＰＩ

### 𝓡𝓮𝓺𝓾𝓲𝓻𝓮𝓶𝓮𝓷𝓽𝓼

Have the weather be dispalyed along the building informations on the map

### Gₑₘ ᵤₛₑd

```
gem 'open-weather'
```

### SNOI⊥∀N∀˥ԀXƎ

When creating the map markers in map.rb, the following two lines fetch the temperature in JSON-format, from which the current temp and "Feels like" temp are extracted :

```ruby
 options = { units: "metric", APPID: ENV["WEATHER_APIKEY"] }
 weather = OpenWeather::Current.geocode(data[:lat], data[:lng] , options)
```


## (っ◔◡◔)っ ♥ STAR WARS QUOTES ♥

### 𝓡𝓮𝓺𝓾𝓲𝓻𝓮𝓶𝓮𝓷𝓽𝓼

We want to hear some stuff about Star Wars! So we made a button saying random Star Wars Quotes whoo!


### Gₑₘ ᵤₛₑd
none

### SNOI⊥∀N∀˥ԀXƎ

On the Dashboard, below the audio player, a button make a get ajax request to the swquote API url, which gives us back a JSON-format file. In the succes part, the response is
used to make an xmlhttp post request to the watson controller, which allow to render the text to speech. It then plays the resulting audio. Note that since there's two
call being made, you have to wait ~20 seconds before you get a second quote.

```javascript
$("#stapi").on("click", function(){

    $.ajax({
      url: "http://swquotesapi.digitaljedi.dk/api/SWQuote/RandomStarWarsQuote",
      type: "GET",
      success: function(data) {
    
        let xmlHttpRequest = new XMLHttpRequest(); 
             xmlHttpRequest.open("POST", "/watson/st", true);
             xmlHttpRequest.responseType = "blob"; 
             xmlHttpRequest.setRequestHeader("Accept", "application/json");
             xmlHttpRequest.setRequestHeader("Content-Type", "application/json"); 
             xmlHttpRequest.setRequestHeader("Cache-Control", "no-cache");
             xmlHttpRequest.onreadystatechange = function() {
               if (this.readyState == 4 && this.status == 200) {
                 console.log("FINISHED");
                 var url = window.URL.createObjectURL(this.response);
                 var audio = new Audio();
                 audio.src = url;
                 audio.play();

               }
             };
  
             xmlHttpRequest.send(JSON.stringify(data)); 

      }
    });
            
    });
```

## Rake Task

file lib/tasks/importdata.rake

## Run Task individually :
```rb
rake dwh:fact_contact
rake dwh:fact_elevator
rake dwh:fact_quote
rake dwh:dimcustomers
rake dwh:fact_intervention
```

## Run Tasks together :
```rb
rake dwh:doall
```

#### Task doall:
```rb
desc "do all task"
task doall: :environment do
    conn = PG.connect( host: host_, dbname: dbname_, user: user_, password: password_ )
    Rake::Task["dwh:fact_contact"].invoke 
    Rake::Task["dwh:fact_elevator"].invoke 
    Rake::Task["dwh:fact_quote"].invoke 
    Rake::Task["dwh:dimcustomers"].invoke 
    Rake::Task["fact_intervention"].invoke 
end
```


## Developpers
- Cindy Okino (Team Leader)
- Kem Tardif
- Kiefer Rivard
- Teddy Blanco
