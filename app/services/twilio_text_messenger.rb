class TwilioTextMessenger
    attr_reader :message
  
    def initialize(message)
      @message = message
    end
  
    def call
      client = Twilio::REST::Client.new
      client.messages.create({
        from: Figaro.env.twilio_phone_number,
        to: '+14388633515',
        body: message
      })
    end
  end