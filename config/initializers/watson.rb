# frozen_string_literal: true

require "json"
require "ibm_watson"
require "ibm_watson/authenticators"
require "ibm_watson/text_to_speech_v1"

authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
    apikey: ENV["TEXT_TO_SPEECH_IAM_APIKEY"]
)

text_to_speech = IBMWatson::TextToSpeechV1.new(
    authenticator: authenticator
)
    
text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]
    
