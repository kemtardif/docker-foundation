# frozen_string_literal: false
require 'json'
require "ibm_watson/authenticators"
require "ibm_watson/text_to_speech_v1"
include IBMWatson



class WatsonController < ActionController::Base
    skip_before_action :verify_authenticity_token

  
    def speak
  
        authenticator = Authenticators::IamAuthenticator.new(
            apikey: ENV["TEXT_TO_SPEECH_IAM_APIKEY"]
        )
        text_to_speech = TextToSpeechV1.new(
            authenticator: authenticator
        )
        text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]
            
        message = "Greeting user #{current_user.id}. There is #{Elevator::count} elevators in #{Building::count} buildings of your 
                    #{Customer::count} customers. Currently, #{Elevator.where(status: 'Intervention').count} elevators are not in 
                    Running Status and are being serviced. You currently have #{Quote::count} quotes awaiting processing.
                    You currently have #{Lead::count} leads in your contact requests. 
                    #{Battery::count} Batteries are deployed across 
                    #{Address.where(id: Building.select(:address_id).distinct).select(:city).distinct.count} cities"

        response = text_to_speech.synthesize(
            text: message,
            accept: "audio/mp3",
            voice: "en-GB_KateV3Voice"
        ).result

        File.open("#{Rails.root}/public/outputs.mp3", "wb") do |audio_file|
                        audio_file.write(response)
        end    
    end

    def starwars
        
        starWars = JSON.parse(request.body.read)
        
        authenticator = Authenticators::IamAuthenticator.new(
            apikey: ENV["TEXT_TO_SPEECH_IAM_APIKEY"]
        )
        text_to_speech = TextToSpeechV1.new(
            authenticator: authenticator
        )
        text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]
            
        message = "#{starWars["starWarsQuote"]}"

        response = text_to_speech.synthesize(
            text: message,
            accept: "audio/mp3",
            voice: "en-GB_KateV3Voice"
        ).result

        send_data response, :disposition => 'inline'
    end 
  
end