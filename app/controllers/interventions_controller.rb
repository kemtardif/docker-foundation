class InterventionsController < ApplicationController
    before_action :authenticate_user!

    def new  
    end

    def create     
        @intervention = Intervention.new(params
        .permit(:name, 
                :customer_id, 
                :building_id, 
                :battery_id, 
                :column_id, :elevator_id, 
                :employee_id, 
                :report))

        @intervention.author_id = current_user.id
        @intervention.save

        if @intervention.save
        redirect_to root_path, notice: "Your Intervention Request was succesfully sent!"
        helpers.ticket_intervention(params
                                .permit(:name, 
                                        :customer_id, 
                                        :building_id, 
                                        :battery_id, 
                                        :column_id, 
                                        :elevator_id, 
                                        :employee_id, 
                                        :report))
        else
        redirect_to new_intervention_path, alert: "There was an error sending your Intervention Request!"
        end   

    end
    
    def search
            if params["type"] == "building"
                @elements = Customer.find(params[:itemId]).buildings
            elsif params["type"] == "battery"
                @elements = Building.find(params[:itemId]).batteries
            elsif params["type"] == "column"
                @elements = Battery.find(params[:itemId]).columns
            elsif params["type"] == "elevator"
                @elements = Column.find(params[:itemId]).elevators
            end
        if request.xhr?
            respond_to do |format|
                format.json {
                    render json: {elements: @elements}
                }
            end
        end
    end    
end
