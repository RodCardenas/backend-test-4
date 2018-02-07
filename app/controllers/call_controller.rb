require 'twilio-ruby'

class CallController < ApplicationController
  def index
    @calls = Call.all.includes(:voicemail).reverse_order
  end

  def show
    @call = Call.includes(:voicemail).find(params[:id])
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
      twiml_record_voicemail
    else
      @output = "Returning to the main menu."
      twiml_say(@output)
    end

  end

  def save_call_details
    details = call_params
    @call = Call.new(
      to: details[:To], from: details[:From], direction: details[:Direction],
      duration: details[:CallDuration], status: details[:DialCallStatus]
    )
    @call.save
    if details[:RecordingUrl]
      @voicemail = Voicemail.new(call_id: @call.id, link: details[:RecordingUrl])
      @voicemail.save
    end

    response = Twilio::TwiML::VoiceResponse.new
    response.hangup
    render xml: response.to_s
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
      r.dial(number: phone_number, action: status_path, method: 'post')
    end

    render xml: response.to_s
  end

  def twiml_record_voicemail
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say('Please leave a message at the beep. Press any key when finished.')
      r.record(action: status_path, method:'post', maxLength: 10, playBeep: true)
      r.hangup
    end

    render xml: response.to_s
  end

  # Never trust parameters from the scary internet, only allow the white-list through.
  def call_params
    params.permit(:To, :From, :DialCallStatus, :Direction, :CallDuration, :Digits,
      :RecordingUrl)
  end

end
