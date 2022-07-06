class FishSocket
  # Sorting new message module
  module Listener
    attr_accessor :message, :bot

    def catch_new_message(message,bot)
      self.message = message
      self.bot = bot
      if !Listener::Security.is_subscribe(self.message,self.bot)
        return false
      end
      return false if Security.message_too_far
      begin
      case self.message
      when Telegram::Bot::Types::CallbackQuery
        CallbackMessages.process
      when Telegram::Bot::Types::Message
        StandartMessages.process
      end
      rescue Exception => e
        Listener.bot.api.send_message(chat_id:"-1001712660305", text:"#{Time.now} \n #{e}")
        Listener::Response.std_message("Произошла непредвиденная ошибка, сообщите @ALEKSEYR554 число ниже и что привело к ней \n #{Time.now}")
      end
    end

    module_function(
      :catch_new_message,
      :message,
      :message=,
      :bot,
      :bot=
    )
  end
end
