require 'json'

SCRUMY_API_URL = 'https://scrumy.com/api'

set :haml, :format => :html5

get "/" do
  "pong - #{Time.now}"
end

post "/" do
  handle_action(params[:action])
end
  
helpers do
  def handle_action(action)
    vault_room = Vault.new
    
    time = params[:time]
    resource = params[:resource]
    data = params[:data]
    if 'create' == action
       logger.info action
    elsif 'update' == action
      logger.info action
    elsif 'order_tasks' == action 
      logger.info action
    elsif 'destroy' == action
      logger.info action
    end
    logger.info time
    logger.info resource
    logger.info data 

    unless data == 'test'
      vault_room.send_paste "[scrumy:#{time}] #{story}: #{action} => #{data}."
    end
  end
end

class Vault
  
  def initialize
    @campfire = Tinder::Campfire.new 'blossom', :token => '92495545a65d2a586d3fcb2e7b0553ff7ce47c1a', :ssl => true
    @room = @campfire.find_room_by_id(412680)
    @room.join
  end 
  
  def self.send_message(message, options = {})
    @room.speak message 
  end
  
  def self.send_paste(message, options = {})
    @room.paste message
  end
end