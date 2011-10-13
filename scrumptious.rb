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
      happening = ""
      JSON.parse(data).each do |key| 
        happening.concat("#{key}")
      end
      logger.info happening
      vault_room.send_message "[scrumy: #{Time.now.strftime("%B %d, %Y %H:%M:%S+%Z")}] #{action}#{resource}."
    end
  end
end

class Vault
  # scrumy user
  def initialize
    @campfire = Tinder::Campfire.new 'blossom', :token => '1cc307903657e740fab0492f26d4468dd7fb9d64', :ssl => true
    @room = @campfire.find_room_by_id(412680)
    @room.join
  end 
  
  def send_message(message, options = {})
    @room.speak message 
  end
  
  def send_paste(message, options = {})
    @room.paste message
  end
end