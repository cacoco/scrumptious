require 'json'
require 'rest_client'
require 'sinatra/base'

class Scrumptious < Sinatra::Base
  set :haml, :format => :html5

  set :campfire_domain => ENV["CAMPFIRE_DOMAIN"]
  set :campfire_token => ENV["CAMPFIRE_TOKEN"]
  set :campfire_room => ENV["CAMPFIRE_ROOM"]

  set :scrumy_project => ENV["SCRUMY_PROJECT"]
  set :scrumy_password => ENV["SCRUMY_PASSWORD"]

  get "/" do
    haml :index
  end

  post "/" do

    handle
  end

  helpers do
    def handle
      room = Campfire::Room.new settings.campfire_domain, :id => settings.campfire_room, :token => settings.campfire_token, :ssl => true

      action = params[:action]
      resource = params[:resource]
      data = params[:data]
      id = params[:id]

      unless data == 'test'
        # for now only care about tasks
        if resource == 'task'
          json = JSON.parse data

          unless "order_tasks" == action  # don't care about this action
            key = json.keys.first
            value = json[key]

            if value.kind_of?(Array)
              change = "#{key.capitalize} changed: [#{value[0]} => #{value[1]}]"
            else
              change = "#{key.capitalize} changed: [#{value}]"
            end

            scrumy = Scrumy::Client.new(settings.scrumy_project, settings.scrumy_password)
            detail = scrumy.get_info(id, resource)
            message = "#{resource.capitalize} [#{detail["title"]}] assigned to: [#{detail["scrumer"]["name"]}] was #{Inflectionist.past_tensed(action)}. #{change}"

            logger.info message
            room.send_message message
          end
        end
      end
    end
  end
end

module Campfire
  class Room
    def initialize(domain, options = {})
      @campfire = Tinder::Campfire.new(domain, options)
      @room = @campfire.find_room_by_id(options[:id].to_i)
    end

    def send_message(message, options = {})
      @room.speak message
    end

    def send_paste(message, options = {})
      @room.paste message
    end
  end
end

module Scrumy
  class Client
    SCRUMY_API_URL = 'https://scrumy.com/api'
    FORMAT = 'json'

    attr_reader :url

    def initialize(project, password)
      @project, @password = project, password
    end

    def get_info(id, resource)
      self.get("#{SCRUMY_API_URL}/#{resource.pluralize}/#{id}.#{FORMAT}", resource)
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
        resource = RestClient::Resource.new url, {:user => @project, :password => @password}

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
end