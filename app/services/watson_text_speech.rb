# frozen_string_literal: false

require "json"

include IBMWatson
require "ibm_watson/authenticators"
require "ibm_watson/text_to_speech_v1"




class WatsonTextSpeech
    attr_reader :message
  
    def initialize(message)
      @message = message
    end

    def speak

        authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
            apikey: ENV["TEXT_TO_SPEECH_IAM_APIKEY"]
            )    
        text_to_speech = IBMWatson::TextToSpeechV1.new(
            authenticator: authenticator
            )   
        text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]

        text_to_speech.configure_http_client(disable_ssl_verification: true)

        File.delete("output.wav") if File.exist?("output.wav")

        response = text_to_speech.synthesize.dup(
            text: 'Hello darling I am a bot',
            accept: "audio/mp3",
            voice: "en-US_AllisonVoice"
          )


        File.open("output.wav", "wb") do |audio_file|
 
          audio_file.write(response.result)
        end
    end

end