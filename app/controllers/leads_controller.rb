class LeadsController < ApplicationController

  def new  
    @lead = Lead.new     
  end

  require 'sendgrid-ruby'
  include SendGrid
  def create        
    @lead = Lead.new(lead_params)   
    @lead.save!
    helpers.ticket(lead_params)


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


  def dropbox
    client = DropboxApi::Client.new
# ========TEST VERSION============================================================================================
    # puts client.inspect
    # puts "============================"
    # result = client.create_folder "/50"

    # find lead by email instead id
    lead = Lead.where(email: 'fadel.filomena@champlin.com').first

    # make a FOR EACH here
    client.create_folder "/fadel.filomena@champlin.com"
    lead.attached_file
    client.upload("/fadel.filomena@champlin.com/test_mcdonald.png", lead.attached_file)
# ====================================================================================================

# ========FOR EACH - WORKING ON THIS ONE============================================================================================
    # make a FOR EACH here
    # find lead by email intead id
    Lead.where(email: 'cindy.okino@gmail.com') do |lead|
      
      client.upload("/test.png", lead.attached_file)
      # check if its NOT null 
      unless lead.attached_file.nil?
        # dropbox - create folder for the user (if there is no folder for the user yet)
        # dropbox - send file to user's folder
      end
    end
# ====================================================================================================


    # puts result.inspect
  end

end