class QuotesController < ApplicationController
    #skip_before_action :verify_authenticity_token 
    def new  
      @quote = Quote.new     
    end

    def create        
      @quote = Quote.new(quote_params)   
      @quote.save!  
      
      helpers.ticket_quote(quote_params)
    end

    def quote_params        
      params.permit(    :company_name,
                        :email,
                        :building_type,
                        :apps_qty,
                        :floors_qty,
                        :basements_qty,
                        :parkings_qty,
                        :elevators_qty,
                        :business_qty,
                        :occupants_floors_qty,
                        :hours_activity,
                        :game,
                        :elevator_needed,
                        :total_price
                    )     
    end

end
