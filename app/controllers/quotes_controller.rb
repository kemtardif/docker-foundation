class QuotesController < ApplicationController
    #skip_before_action :verify_authenticity_token 
    def new  
      @quote = Quote.new     
    end

    def create        
      @quote = Quote.new(quote_params)
      
      if verify_recaptcha(model: @quote) && @quote.save
        respond_to do |format|
        helpers.ticket_quote(quote_params)
        format.html { redirect_to '/home', notice: 'Message Sent!' }
        end
      else
        # render :js => "alert('Hello Rails');"    
      end
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
