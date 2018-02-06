require 'twilio-ruby'

class CallsController < ApplicationController
  def index
    render plain: "Call Rodrigo @ +1 (346) 214-5383."
  end

  # POST ivr/welcome
  def ivr_welcome
    response = Twilio::TwiML::VoiceResponse.new
    response.gather(input: 'dtmf', num_digits: '1', action: menu_path, method: 'get') do |gather|
      gather.say('Please press 1 to call Rodrigo or 2 to leave a voicemail.')
    end

    render xml: response.to_s
  end

  # GET ivr/selection
  def menu_selection
    user_selection = params[:Digits]

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
end
