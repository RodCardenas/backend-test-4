class CallsController < ApplicationController
  def index
    v = 'Hello World! Currently running version ' + Twilio::VERSION + ' of the twilio-ruby library.'
    render plain: v
  end
end
