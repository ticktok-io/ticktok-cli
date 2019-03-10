require 'rest-client'
require 'bunny'
require 'json'
require 'random-word'

module TicktokCli

  class Clock

    def initialize(name)
      @name = name
    end

    def self.named(name)
      Clock.new(name)
    end

    def on(schedule)
      @schedule = schedule
      self
    end

    def invoke(action)
      channel = create_clock
      consume(channel, action)
    end

    def create_clock
      resp = RestClient.post("https://ticktok-io-dev.herokuapp.com/api/v1/clocks?access_token=#{ENV["ACCESS_TOKEN"]}",
                             {name: @name, schedule: @schedule}.to_json,
                             {content_type: :json})
      raise "Failed to create a clock" unless resp.code == 201
      JSON.parse(resp.body)['channel']
    end

    def consume(tick_channel, action)
      connection = Bunny.new(tick_channel['details']['uri'])
      connection.start

      ch = connection.create_channel

      queue = ch.queue(tick_channel['details']['queue'], :passive => true)
      begin
        queue.subscribe(block: true) do |delivery_info, _properties, body|
          action.call(body)
        end
      rescue Interrupt => _
        ch.close
        connection.close
      end
    end
  end


  class CLI < Command
    class_option :verbose, type: :boolean

    desc "schedule", "Create and listen to a new clock"
    long_desc Help.text(:schedule)
    option :name
    def schedule(expr)
      name = options.fetch(:name, RandomWord.adjs.next)
      Clock.named(name).on(expr).invoke(lambda {
          |m| puts "#{name}\t#{expr}\t\t#{Time.new.inspect}"}
      )
    end

    desc "version", "prints version"
    def version
      puts TicktokCli::VERSION
    end
  end
end
