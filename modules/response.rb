class FishSocket
  module Listener
    # This module assigned to responses from bot
    module Response
      def std_message(message, chat_id = false )
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_message(
          parse_mode: 'html',
          chat_id: chat,
          text: message
        )
      end
      def forward_message(chat_id, message, type, add="")
        case type
        when "pls_find_full"
          Listener.bot.api.send_message(chat_id:chat_id,text:"НАЙТИ ФУЛЛ Осталось на сегодня #{add}")
        when "post_suggest"
          Listener.bot.api.send_message(chat_id:chat_id,text:"ПЖ ВЫЛОЖИТЕ")
        end
        message_id=message.message_id
        from_chat_id=message.chat.id
        Listener.bot.api.forward_message(
          chat_id:chat_id,
          from_chat_id:from_chat_id,
          message_id: message_id,
          disable_notification:true
        )
      end
      def send_animation(file_id, chat_id = false )
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_animation(
          parse_mode: 'html',
          chat_id: chat,
          animation: file_id.to_s
        )
      end
      def send_photo(file_id, chat_id = false )
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_photo(
          parse_mode: 'html',
          chat_id: chat,
          photo: file_id.to_s
        )
      end
      def send_document(file_id, chat_id = false )
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_document(
          parse_mode: 'html',
          chat_id: chat,
          document: file_id
        )
      end
      def send_video(file_id, chat_id = false )
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_video(
          parse_mode: 'html',
          chat_id: chat,
          video: file_id.to_s
        )
      end
      def inline_message(message, inline_markup, editless = false, chat_id = false)
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        #puts chat
        chat = chat_id if chat_id
        if editless
          return Listener.bot.api.edit_message_text(
            chat_id: chat,
            parse_mode: 'html',
            message_id: Listener.message.message.message_id,
            text: message,
            reply_markup: inline_markup
          )
        end
        Listener.bot.api.send_message(
          chat_id: chat,
          parse_mode: 'html',
          text: message,
          reply_markup: inline_markup
        )
      end

      def generate_inline_markup(kb, force = false)
        Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: kb
        )
      end
      def show_reply_keyboard(keyboard, one_time=true, chat_id = false)
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        answers=Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard:keyboard,
          one_time_keyboard:one_time,
          resize_keyboard:true
        )
        Listener.bot.api.send_message(chat_id: chat, text: "FUCK", reply_markup: answers)
      end

      def force_reply_message(text, chat_id = false)
        chat = (defined?Listener.message.chat.id) ? Listener.message.chat.id : Listener.message.message.chat.id
        chat = chat_id if chat_id
        Listener.bot.api.send_message(
          parse_mode: 'html',
          chat_id: chat,
          text: text,
          reply_markup: Telegram::Bot::Types::ForceReply.new(
            force_reply: true,
            selective: true
          )
        )
      end

      module_function(
        :std_message,
        :generate_inline_markup,
        :inline_message,
        :force_reply_message,
        :show_reply_keyboard,
        :send_document,
        :send_photo,
        :send_video,
        :send_animation,
        :forward_message
      )
    end
  end
end
