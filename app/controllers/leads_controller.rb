class LeadsController < ApplicationController

  def new  
    @lead = Lead.new     
  end

  require 'sendgrid-ruby'
  include SendGrid
  def create        
    @lead = Lead.new(lead_params)
    file_received = params[:attached_file]

    if file_received
      @lead.attached_file = file_received.read
      @lead.name_attached_file = file_received.original_filename
    end
    if verify_recaptcha(model: @lead) && @lead.save
      respond_to do |format|
          # helpers.ticket_lead(lead_params)
          # SendGrid_compute()
          format.html { redirect_to '/home', notice: 'Message Sent!' }
        end
    end
  end

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