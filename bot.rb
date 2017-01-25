# ruby-telegram-bot v1.0 2017 (inline mode)
# Author Dmitri Korchemkin
# license that can be found in the LICENSE file.

require 'net/http'
require 'json'

module TelegramBot
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

    def get_updates
      uri = URI("#{@api_url + @token}/getUpdates")
      params = {
        timeout: @timeout,
        offset: @offset,
        limit: @limit
      }
      uri.query = URI.encode_www_form(params)

      req = Net::HTTP::Get.new(uri)
      resp = Net::HTTP.start(uri.host, uri.port,
                             use_ssl: uri.scheme == 'https') do |http|
        http.request req
      end

      updates = JSON.parse resp.body
      message_handler updates
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

      puts JSON.parse resp.body
    end

    def message_handler(updates)
      if updates['ok']
        updates['result'].each do |item|
          if item.has_key? 'update_id'
          # WARNING !!!
          # long polling will not work if the offset does not increase
            @offset = item['update_id'].to_i + 1
          end

          if item.has_key? 'message'
            curr_item = item['message']['text'].downcase if item['message']['text']

            if @responses.has_key? curr_item
              data = {
                'chat_id' => item['message']['chat']['id'],
                'text' => @responses[curr_item]
              }
              send_message('sendMessage', data)
            else
              data = {
                'chat_id' => item['message']['chat']['id'],
                'text' => "I don't know, what is it"
              }
              send_message('sendMessage', data)
            end
          elsif item.has_key? 'inline_query'
            curr_item = item['inline_query']['query'].downcase if item['inline_query']['query']

            if @responses.has_key? curr_item
              data = {
                'inline_query_id' => item['inline_query']['id'],
                'results' => [
                  {
                    'type' => 'photo',
                    'id' => 'not unique id',
                    'title' => "It is #{item['inline_query']['query']}",
                    'photo_url' => @responses[curr_item],
                    'thumb_url' => @responses[curr_item]
                  }
                ]
              }
              send_message('answerInlineQuery', data)
            end
          end
        end

        # long polling
        if @offset > 0
          get_updates
        else
          sleep 3
          get_updates
        end
      end
    end

    public

    def start
      begin
        get_updates
      rescue Interrupt => e
        puts 'Bye'
      end
    end

  end
end
