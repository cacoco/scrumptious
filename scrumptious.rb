require 'json'
require 'rest_client'
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
        json = JSON.parse(data)
        message = "[#{Time.now.strftime("%B %d, %Y %H:%M:%S")}] #{resource.capitalize} [#{id}] was #{Inflectionist.past_tensed(action)}. "
        json.each do |key, value|
          if value.kind_of?(Array)
            message << "#{key.capitalize} changed: [#{value[0]} => #{value[1]}]"
          else
            message << "#{key.capitalize} changed: [#{value}]"
          end
        end
        puts message
        #vault_room.send_message "The following is a test."
        vault_room.send_message message
      end
    end
  end
end

class Vault
  # Scrumy campfire user, TODO: move config outside of application
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

class Scrumy
  def initialize(project, password)
    @project, @password = project, password
  end

  protected
      # `#get` provides the nuts and bolts for retrieving resources.  Give it a
      # resource URL and a root key and it will return either an array of hashes
      # at that root key or a single hash with values found at that key.
      #
      # For example if the resource returns `{"foo"=>{"id"=>1, "bar"=>"baz"}}`
      # then `#get(some_url, "foo")` will return the value of `"foo"` from the hash:
      # `{"id"=>1, "bar"=>"baz"}`.  This is important because later on in the models
      # we assign all the values in the latter hash as instance variables on the
      # model objects.
      def get(url, root)
        begin
          # Start by creating a new `RestClient::Resource` authenticated with
          # the `@project` name and `@password`.
          resource = RestClient::Resource.new(url, @project, @password)

          # `GET` the resource
          resource.get {|response, request, result, &block|
            case response.code
            when 200
              # and on success parse the response
              json = JSON.parse(response.body)
              # If it's `Array` then collect the hashes and flatten them on the `root` key.
              if json.kind_of?(Array) && root
                json.collect{|item|
                  item[root]
                }
              else
                # Otherwise just return the `Hash` at the root or the JSON itself directly.
                root ? json[root] : json
              end
            else
              response.return!(request, result, &block)
            end
          }
        rescue => e
          # Rescue and reraise with the current `@url` for debugging purposes
          raise "Problem fetching #{@url} because #{e.message}"
        end
      end
end