
# frozen_string_literal: false

require "json"

require "ibm_watson/authenticators"
require "ibm_watson/text_to_speech_v1"
include IBMWatson

class Elevator < ApplicationRecord
    belongs_to :column

    ##after_update :call_tech
    after_update :speak_for_me
    

    private
        def call_tech 
            if self.status == "Intervention" or self.status == "intervention" then 
                message = "The Elevator with id '#{self.id}', in building with id '#{self.column.battery.building.id}' needs to be repaired by '#{self.column.battery.building.tect_contact_name}'. His phone number is '#{self.column.battery.building.tect_contact_phone}'"
                TwilioTextMessenger.new(message).call
            end
        end

        def speak_for_me
            
            authenticator = Authenticators::IamAuthenticator.new(
            apikey: ENV["TEXT_TO_SPEECH_IAM_APIKEY"]
            )              

            text_to_speech = TextToSpeechV1.new(
                authenticator: authenticator,
                )   
            

            text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]

            File.delete("output.wav") if File.exist?("output.wav")

            response = text_to_speech.synthesize(
                text: "Helloooo boys and girls",
                accept:  "audio/wav",
                voice:  "en-US_AllisonV3Voice"
            )


            File.open("output.wav", "wb") do |audio_file|
    
            audio_file.write(response.result)
            end
        end
end
