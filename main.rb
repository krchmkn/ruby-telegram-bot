# ruby-telegram-bot v1.0 2017 (inline mode)
# Author Dmitri Korchemkin
# license that can be found in the LICENSE file.

require "./bot.rb"

token = ""
responses = {
    "/start" => "let's start",
    "/help" => "you need help",
    "hi" => "hello"
}

bot = TelegramBot::Bot.new(token, responses)
bot.get_updates

