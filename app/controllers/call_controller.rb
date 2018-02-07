require 'twilio-ruby'

class CallController < ApplicationController
  def index
    @calls = Call.all()
  end

  def show
    @call = Call.find(params[:id])
  end

  # POST ivr/welcome
  def ivr_welcome
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(input: 'dtmf', num_digits: '1', action: menu_path, method: 'get') do |gather|
      gather.say('Please press 1 to call Rodrigo or 2 to leave him voicemail.')
    end

    render xml: response.to_s
  end

  # GET ivr/selection
  def menu_selection
    user_selection = call_params[:Digits]

    case user_selection
    when "1"
      twiml_dial('+12818985445')
    when "2"
      twiml_say('Recording voicemails not implemented yet.', true)
    else
      @output = "Returning to the main menu."
      twiml_say(@output)
    end

  end

  def save_call_details
    details = call_params
    if details[:CallStatus] == "completed"
      @call = Call.new(to: details[:To], from: details[:From])
      @call.save
      response = Twilio::TwiML::VoiceResponse.new
      response.hangup
      render xml: response.to_s
    end
  end

  private
  def twiml_say(message, exit = false)
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message, voice: 'woman', language: 'en')
      if exit
        r.say("Have a good day!")
        r.hangup
      else
        r.redirect(welcome_path)
      end
    end

    render xml: response.to_s
  end

  def twiml_dial(phone_number)
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.dial(number: phone_number)
    end

    render xml: response.to_s
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def call_params
    params.permit(:To, :From, :CallStatus, :Duration, :CallDuration, :Digits)
  end

end
