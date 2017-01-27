# ruby-telegram-bot v1.0 2017
# Author Dmitri Korchemkin
# license that can be found in the LICENSE file.
require 'net/http'
require 'json'

module TelegramBot
  # Telegram api bot class
  class Bot
    def initialize(token, responses)
      @token = token
      @responses = responses
      @api_url = 'https://api.telegram.org/bot'
      @timeout = 25
      @offset = 0
      @limit = 1
    end

    private

    def new_messages
      uri = URI("#{@api_url + @token}/getUpdates")
      uri.query = URI.encode_www_form(timeout: @timeout,
                                      offset: @offset,
                                      limit: @limit)
      req = Net::HTTP::Get.new(uri)
      resp = Net::HTTP.start(uri.host, uri.port,
                             use_ssl: uri.scheme == 'https') do |http|
        http.request req
      end
      JSON.parse(resp.body, symbolize_names: true)
    end

    # Takes Telegram API method and json hash
    def send_message(api_method, message_data)
      uri = URI("#{@api_url + @token}/#{api_method}")
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/json'
      req.body = message_data.to_json
      resp = Net::HTTP.start(uri.host, uri.port,
                             use_ssl: uri.scheme == 'https') do |http|
        http.request req
      end
      JSON.parse(resp.body, symbolize_names: true)
    end

    def chat_message(message)
      curr_key = message[:text].to_s.downcase
      data = { chat_id: message[:chat][:id] }
      data[:text] = if @responses.key? curr_key
                      @responses[curr_key]
                    else
                      "Sorry, I don't know, what is it"
                    end
      data
    end

    def inline_query(inline_query)
      curr_key = inline_query[:query].to_s.downcase
      data = if @responses.key? curr_key
               {
                 inline_query_id: inline_query[:id],
                 results: [{
                   type: 'article',
                   id: rand(1...500).to_s,
                   title: "It is #{inline_query[:query]}",
                   input_message_content: {
                     message_text: @responses[curr_key]
                   }
                 }]
               }
             else
               {
                 inline_query_id: inline_query[:id],
                 results: []
               }
             end
      data
    end

    def message_handler
      updates = new_messages
      updates[:result].each do |item|
        if item.key? :update_id
          # WARNING !!!
          # long polling will not work
          # if the offset does not increase
          @offset = item[:update_id].to_i + 1
        end
        if item.key? :message
          data = chat_message(item[:message])
          send_message('sendMessage', data)
        end
        if item.key? :inline_query
          data = inline_query(item[:inline_query])
          send_message('answerInlineQuery', data)
        end
      end
      updates
    end

    def run
      message_handler
      # telegram servers DDOS protection =)
      sleep 3 unless @offset.zero?
      run
    end

    public

    def start
      puts 'Bot is running, press CTRL-C for exit'
      run
    rescue Interrupt
      puts "\nBye\n"
    end
  end
end
