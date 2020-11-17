class InterventionsController < ApplicationController
    before_action :authenticate_user!

    def new  
    end

    def create     
        @intervention = Intervention.new(params
        .permit(:name, 
                :customerId, 
                :buildingId, 
                :batteryId, 
                :columnId, :elevatorId, 
                :employeeId, 
                :reportrake))

        @intervention.author = current_user.id
        @intervention.save

        if @intervention.save
        redirect_to root_path, notice: "Your Intervention Request was succesfully sent!"
        else
        redirect_to new_intervention_path, alert: "There was an error sending your Intervention Request!"
        end   

    end


    def building
        if params[:itemId].present?
            @elements = Customer.find(params[:itemId]).buildings
        else
            @elements = Building.all
        end

        if request.xhr?
            respond_to do |format|
                format.json {
                    render json: {elements: @elements}
                }
            end
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
