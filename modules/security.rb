class FishSocket
  module Listener
    # Module for checks
    module Security
      def message_is_new(start_time, message)
        message_time = (defined? message.date) ? message.date : message.message.date
        message_time.to_i > start_time
      end
      def is_subscribe(message,bot)
        if message.from==nil#chat.id =="-1001390791704"
          return true
        elsif Listener.bot.api.getChatMember(chat_id:"@fulling_house",user_id:message.from.id)['result']['status'].to_s=="left"
          #Listener::Response.std_message("#{Listener.bot.api.getChatMember(chat_id:"@fulling_house",user_id:message.from.id)}")
          Listener.bot.api.send_message(chat_id:message.from.id, text:"Для работы бота сначала подпишитесь на канал @fulling_house")
          return false
        end
        return true
      end
      def message_too_far
        message_date = (defined? Listener.message.date) ? Listener.message.date : Listener.message.message.date
        message_delay = Time.now.to_i - message_date.to_i
        # if message delay less then 5 min then processing message, else ignore
        message_delay > (5 * 60)
      end
      module_function :message_is_new, :message_too_far, :is_subscribe
    end
  end
end
