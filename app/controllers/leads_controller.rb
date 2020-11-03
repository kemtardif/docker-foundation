class LeadsController < ApplicationController
    # skip_before_action :verify_authenticity_token 
    def new  
      @lead = Lead.new     
    end
    def create        
      @lead = Lead.new(lead_params)   
      @lead.save!     
    end


    include SendGrid
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
                      
        
        full_name = params[:full_name]
        email = params[:email]
        project_name = params[:project_name]

        from = Email.new(email: 'cindy-okino@hotmail.com')
        to = Email.new(email: 'cindy.okino@gmail.com')

        template_id = "d-c6ab731e2c5249cf8f7405d6cf96fbfe"
        subject = 'Sending with SendGrid is Fun'
        content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')

        mail = Mail.new(from, subject, to, content)
        # mail = Mail.new(from, to, full_name, project_name)

        
        sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
        response = sg.client.mail._('send').post(request_body: mail.to_json)

        puts sg.inspect       

        puts response.status_code
        puts response.body
        puts response.headers
    
    end
end