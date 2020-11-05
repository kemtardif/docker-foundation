# frozen_string_literal: false

require "ibm_watson/authenticators"
require "ibm_watson/text_to_speech_v1"
include IBMWatson

class WatsonController < ActionController::Base
  
    def speak
  
        authenticator = Authenticators::IamAuthenticator.new(
            apikey: ENV["TEXT_TO_SPEECH_IAM_APIKEY"]
        )
        text_to_speech = TextToSpeechV1.new(
            authenticator: authenticator
        )
        text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]
            
        ##message = "There is #{Elevator::count} elevators in #{Building::count} buildings of your #{Customer::count} customers. You currently have #{Quote::count} quotes awaiting processing. You currently have #{Lead::count} leads in your contact requests. #{Battery::count} Batteries are deployed across cities"
        message = "Hello people"
        response = text_to_speech.synthesize(
            text: message,
            accept: "audio/mp3",
            voice: "en-GB_KateV3Voice"
        ).result

        File.open("app/assets/audios/outputs.mp3", "wb") do |audio_file|
                        audio_file.write(response)
                    end
        

        soundFile = File.open("app/assets/audios/outputs.mp3", "r")
        binary = soundFile.read

        send_data binary, filename: 'outputs.mp3', type: 'audio/mp3', disposition: 'inline'


        
    end
  
end