require './bot.rb'

RSpec.describe TelegramBot::Bot do
  before(:each) do
    # token should be valid
    token = 'BOT_TOKEN'
    responses = {
      'ametrine' => 'https://en.wikipedia.org/wiki/Ametrine'
    }
    @bot = TelegramBot::Bot.new(token, responses)
  end

  it 'new_messages' do
    updates = @bot.send(:new_messages)
    expect(updates).to include(:result)
  end

  it 'send_message(api_method, message_data)' do
    server_resp = @bot.send(:send_message, 'sendMessage', 'text')
    expect(server_resp).to be_truthy
  end

  it 'chat_message(message)' do
    item_message = '{"chat":{"id":111111},"text":"hello"}'
    chat_msg = @bot.send(:chat_message, JSON.parse(item_message,
                                                   symbolize_names: true))
    msg = chat_msg[:text].to_s.downcase

    if @bot.instance_variable_get(:@responses).key? msg
      expect(chat_msg).to include(:chat_id)
    else
      expect(chat_msg).to include(:chat_id, :text)
    end
  end

  it 'inline_query(inline_query)' do
    item_inline_query = '{"inline_query": {"id": 111111,"query": "hello"}}'
    inline_query = @bot.send(:inline_query, JSON.parse(item_inline_query,
                                                       symbolize_names: true))
    query = inline_query[:query].to_s.downcase

    if @bot.instance_variable_get(:@responses).key? query
      expect(inline_query).to include(:inline_query_id)
      expect(inline_query[:results].first).to include(:type, :id, :title,
                                                      :photo_url, :thumb_url)
    else
      expect(inline_query).to be_truthy
    end
  end

  it 'message_handler' do
    @bot.send(:message_handler)
    updates = @bot.send(:message_handler)

    if updates[:result].empty?
      expect(@bot.instance_variable_get(:@offset)).to eq(0)
    elsif updates[:result][0].key? :update_id
      expect(@bot.instance_variable_get(:@offset)).to be > 0
    end
  end
end
