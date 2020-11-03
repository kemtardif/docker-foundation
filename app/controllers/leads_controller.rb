class LeadsController < ApplicationController
    # skip_before_action :verify_authenticity_token 
    def new  
      @lead = Lead.new     
    end
    def create        
      @lead = Lead.new(lead_params)   
      @lead.save!  
         
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