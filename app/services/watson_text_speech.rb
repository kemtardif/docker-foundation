require "ibm_watson/authenticators"
require "ibm_watson/text_to_speech_v1"
include IBMWatson

class WatsonTextSpeech
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def speak

    authenticator = Authenticators::IamAuthenticator.new(
        apikey: ENV["TEXT_TO_SPEECH_IAM_APIKEY"]
    )
    text_to_speech = TextToSpeechV1.new(
        authenticator: authenticator
    )
    text_to_speech.service_url = ENV["TEXT_TO_SPEECH_URL"]

    #text_to_speech.configure_http_client(disable_ssl_verification: true)

    response = text_to_speech.synthesize(
        text: message,
        accept: "audio/mp3",
        voice: "en-US_AllisonVoice"
    ).result

    File.open("app/assets/audios/output.mp3", "wb") do |audio_file|
      audio_file.write(response)
    end
  end

end
