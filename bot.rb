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
      updates = JSON.parse(resp.body)
      message_handler(updates) if updates['ok']
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
    end

    def chat_message(item)
      curr_item = (item['message']['text'].downcase if item['message']['text'])
      data = {
        'chat_id' => item['message']['chat']['id']
      }
      data['text'] = if @responses.key? curr_item
                       @responses[curr_item]
                     else
                       "I don't know, what is it"
                     end
      send_message('sendMessage', data)
    end

    def inline_query(item)
      curr_item = if item['inline_query']['query']
                    item['inline_query']['query'].downcase
                  end
      data = if @responses.key? curr_item
               {
                 'inline_query_id' => item['inline_query']['id'],
                 'results' => [{
                   'type' => 'photo',
                   'id' => '#{ rand(1...500) }',
                   'title' => "It is #{item['inline_query']['query']}",
                   'photo_url' => @responses[curr_item],
                   'thumb_url' => @responses[curr_item]
                 }]
               }
             end
      send_message('answerInlineQuery', data)
    end

    def message_handler(updates)
      updates['result'].each do |item|
        if item.key? 'update_id'
          # WARNING !!!
          # long polling will not work
          # if the offset does not increase
          @offset = item['update_id'].to_i + 1
        end
        if item.key? 'message'
          chat_message(item)
        elsif item.key? 'inline_query'
          inline_query(item)
        end
      end
      # telegram servers DDOS protection =)
      sleep 3 unless @offset <= 0
      new_messages
    end

    public

    def start
      puts 'Bot is running, press CTRL-C for exit'
      new_messages
    rescue Interrupt
      puts "\nBye\n"
    end
  end
end
