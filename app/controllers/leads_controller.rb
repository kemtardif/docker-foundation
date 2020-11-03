class LeadsController < ApplicationController

  def new  
    @lead = Lead.new     
  end

  require 'sendgrid-ruby'
  include SendGrid
  def create        
    # @lead = Lead.new(lead_params)   
    # @lead.save!  
    # helpers.ticket(lead_params)


      full_name = params[:full_name]
      puts full_name
      email = params[:email]
      puts email
      project_name = params[:project_name]
      puts project_name

      
    mail = Mail.new
    mail.from = Email.new(email: 'cindy-okino@hotmail.com')
    personalization = Personalization.new
    personalization.add_to(Email.new(email: email))
    personalization.add_dynamic_template_data({
        "subject" => "Testing Templates",
        "fullName" => full_name,
        "projectName" => project_name
      })
    mail.add_personalization(personalization)
    mail.template_id = 'd-c6ab731e2c5249cf8f7405d6cf96fbfe'

    puts mail.inspect

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    begin
        response = sg.client.mail._("send").post(request_body: mail.to_json)
    rescue Exception => e
        puts e.message
    end
    puts response.status_code
    puts response.body
    # puts response.parsed_body
    puts response.headers

    
    # data = JSON.parse('{
    #   "personalizations": [
    #     {
    #       "to": [
    #         {
    #           "email": #{email}
    #         }
    #       ],
    #       "dynamic_template_data": {
    #         "subject": "Testing Templates 2",
    #         "name": "Example UserAAA",
    #         "city": "Montreal"
    #       }
    #     }
    #   ],
    #   "from": {
    #     "email": "cindy-okino@hotmail.com"
    #   },
    #   "template_id": "d-c6ab731e2c5249cf8f7405d6cf96fbfe"
    # }')
    # sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    # begin
    #     response = sg.client.mail._("send").post(request_body: data)
    # rescue Exception => e
    #     puts e.message
    # end
    # puts response.status_code
    # puts response.body
    # # puts response.parsed_body
    # puts response.headers
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