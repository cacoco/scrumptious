require 'json'
require 'sinatra/base'

class Scrumptious < Sinatra::Base
  SCRUMY_API_URL = 'https://scrumy.com/api'

  set :haml, :format => :html5

  get "/" do
    haml :index
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
      id = params[:id]
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
      logger.info id
      logger.info data

      unless data == 'test'
        #happening = ""
        #JSON.parse(data).each do |key|
        #  happening.concat("#{key}")
        #end
        #logger.info happening
        puts "[#{Time.now.strftime("%B %d, %Y %H:%M:%S+%Z")}] #{resource}(#{id}) => #{action} []."
        #vault_room.send_message "[#{Time.now.strftime("%B %d, %Y %H:%M:%S+%Z")}] #{resource}(#{id}) => #{action} []."
      end
    end
  end
end


# 2011-10-13T01:28:42+00:00 heroku[router]: GET radiant-stone-9315.herokuapp.com/favicon.ico dyno=web.1 queue=0 wait=0ms service=6ms status=404 bytes=465
# 2011-10-13T01:28:42+00:00 app[web.1]: 204.14.152.118 - - [13/Oct/2011 01:28:42] "GET /favicon.ico HTTP/1.1" 404 465 0.0022
# 2011-10-13T01:28:49+00:00 app[web.1]: I, [2011-10-13T01:28:49.823027 #1]  INFO -- : update
# 2011-10-13T01:28:49+00:00 app[web.1]: I, [2011-10-13T01:28:49.823171 #1]  INFO -- : 1318469329
# 2011-10-13T01:28:49+00:00 app[web.1]: I, [2011-10-13T01:28:49.823202 #1]  INFO -- : task
# 2011-10-13T01:28:49+00:00 app[web.1]: I, [2011-10-13T01:28:49.823224 #1]  INFO -- : {"state":["inprogress","todo"]}
# 2011-10-13T01:28:49+00:00 app[web.1]: I, [2011-10-13T01:28:49.823288 #1]  INFO -- : ["state", ["inprogress", "todo"]]
# 2011-10-13T01:28:50+00:00 heroku[router]: POST radiant-stone-9315.herokuapp.com/ dyno=web.1 queue=0 wait=0ms service=928ms status=200 bytes=189
# 2011-10-13T01:28:50+00:00 app[web.1]: 173.45.231.183 - - [13/Oct/2011 01:28:50] "POST / HTTP/1.1" 200 - 0.9068
# 2011-10-13T01:28:56+00:00 app[web.1]: I, [2011-10-13T01:28:56.441042 #1]  INFO -- : update
# 2011-10-13T01:28:56+00:00 app[web.1]: I, [2011-10-13T01:28:56.441165 #1]  INFO -- : 1318469181
# 2011-10-13T01:28:56+00:00 app[web.1]: I, [2011-10-13T01:28:56.441195 #1]  INFO -- : task
# 2011-10-13T01:28:56+00:00 app[web.1]: I, [2011-10-13T01:28:56.441218 #1]  INFO -- : {"state":["inprogress","todo"]}
# 2011-10-13T01:28:56+00:00 app[web.1]: I, [2011-10-13T01:28:56.441276 #1]  INFO -- : ["state", ["inprogress", "todo"]]
# 2011-10-13T01:28:56+00:00 heroku[router]: POST radiant-stone-9315.herokuapp.com/ dyno=web.1 queue=0 wait=0ms service=1499ms status=200 bytes=189
# 2011-10-13T01:28:56+00:00 app[web.1]: 173.45.231.183 - - [13/Oct/2011 01:28:56] "POST / HTTP/1.1" 200 - 1.4954
# 2011-10-13T01:28:58+00:00 app[web.1]: I, [2011-10-13T01:28:58.417793 #1]  INFO -- : update
# 2011-10-13T01:28:58+00:00 app[web.1]: I, [2011-10-13T01:28:58.417931 #1]  INFO -- : 1318469262
# 2011-10-13T01:28:58+00:00 app[web.1]: I, [2011-10-13T01:28:58.417986 #1]  INFO -- : task
# 2011-10-13T01:28:58+00:00 app[web.1]: I, [2011-10-13T01:28:58.418075 #1]  INFO -- : {"state":["todo","inprogress"]}
# 2011-10-13T01:28:58+00:00 app[web.1]: I, [2011-10-13T01:28:58.418171 #1]  INFO -- : ["state", ["todo", "inprogress"]]
# 2011-10-13T01:28:58+00:00 heroku[router]: POST radiant-stone-9315.herokuapp.com/ dyno=web.1 queue=0 wait=0ms service=987ms status=200 bytes=189
# 2011-10-13T01:28:58+00:00 app[web.1]: 173.45.231.183 - - [13/Oct/2011 01:28:58] "POST / HTTP/1.1" 200 - 0.9826

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