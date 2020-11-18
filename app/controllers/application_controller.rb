class ApplicationController < ActionController::Base
    helper :all
    skip_before_filter :verify_authenticity_token
    protect_from_forgery prepend: true, with: :exception

    protected
    #Jorge - redirecto to home after signin or signup
    def after_sign_in_path_for(resource)
        '/home'
    end

    def after_sign_up_path_for(resource)
        '/home' 
    end
end
