class FishSocket
  module Listener
    # This module assigned to processing all callback messages
    module CallbackMessages
      attr_accessor :callback_message

      def process
        self.callback_message = Listener.message.message
        case Listener.message.data
        when 'get_account'
          Listener::Response.std_message('Нету аккаунтов на данный момент')
        when 'force_promo'
          Listener::Response.force_reply_message('Отправьте промокод')
        when 'rule34_img'
          if Image_handler.generate()
            #File.write('1.txt',"dfvfb")
            Image_handler.generate()
          end
        when 'replace_db_file'
          Listener::Response.std_message("Отправьте admin_list.txt или date.txt")
          Listener::Response.force_reply_message("Введите имя файла строго в формате\n название_файла_без_.txt новое содержимое")
        when "add_full"
          #return Listener::Response.std_message 'Вы не админ' if Listener::Codes.is_admin?(Listener.message.from.id)
          Listener::Response.force_reply_message("Отправьте фулл, для отмены введите 0")
        when 'full_code_check'
          Listener::Response.force_reply_message('Введите код, для отмены введите 0')
        when 'add_admin'
          #return Listener::Response.std_message 'Вы не админ' if Listener::Codes.is_admin?(Listener.message.from.id)
          Listener::Response.force_reply_message("Перешлите сообщение человека для добавления его в админы, для отмены введите 0")
        when 'send_files'
          ["admin_list","date","code_to_full"].each {|x|
          Listener.bot.api.send_document(chat_id: Listener.message.message.chat.id, document: Faraday::UploadIO.new("#{x}.txt","txt"))
        }
          #Listener::Response.send_document(document: Faraday::UploadIO.new('admin_list.txt'))
          #Listener::Response.send_document(document: Faraday::UploadIO.new('code_to_full.txt'))
          #Listener::Response.send_document(document: Faraday::UploadIO.new('date.txt'))
        when 'admin_buttons'
          return Listener::Response.std_message 'Вы не админ' if Listener::Codes.is_admin?(Listener.message.from.id.to_s)
          Listener::Response.inline_message("Дополнительное меню:", Listener::Response.generate_inline_markup([
            Inline_Button::ADD_ADMIN,
            Inline_Button::ADD_FULL,
            Inline_Button::SEND_FILES,
            Inline_Button::REPLACE_DB_FILE
        ]), false)
        when 'next_photo'
          if Image_handler.generate()
            File.write('1.txt',"dfvfb")
            Image_handler.generate()
          end
        when 'post_image'
          Image_handler.post_image()
        when 'advanced_menu'
          Listener::Response.inline_message('Дополнительное меню:', Telegram::Bot::Types::InlineKeyboardMarkup.new(
            inline_keyboard: RANDOM_IMAGE
          ))
        end
      end

      module_function(
          :process,
          :callback_message,
          :callback_message=
      )
    end
  end
end
