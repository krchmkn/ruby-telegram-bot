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

    def get_updates

      puts 'upd'

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

      if updates['ok']

        updates['result'].each do |item|
          # WARNING !!!
          # long polling will not work if the offset does not increase
          @offset= item['update_id'].to_i + 1

          if @responses.has_key? item['message']['text']
            data = {
              'chat_id' => item['message']['chat']['id'],
              'text' => @responses[item['message']['text']]
            }
            self.send_message('sendMessage', data)
          end
        end

        # long polling
        if @offset > 0
          self.get_updates
        else
          sleep 3
          self.get_updates
        end
      end

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

      puts resp.body
    end

    def message_handler
      # TODO handle messages here
    end

  end
end
