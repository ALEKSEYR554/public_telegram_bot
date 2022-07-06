class FishSocket
  module Listener
    # This module assigned to processing all standart messages
    module StandartMessages
      def process
        case Listener.message.text
        when '/start', 'команды','/commands'
          Listener::Response.std_message("Используйте меню комманд слева от поля ввода сообщения")
        when '/admin_commands'

          Response.inline_message 'Кнопки', Response::generate_inline_markup(
            [
                Inline_Button::ADMIN_BUTTONS
            ],true
          )
        when "/code_check"
          Listener::Response.force_reply_message('Введите код, для отмены введите 0')
        when "/post_suggest"
          Listener::Response.force_reply_message("Отправьте предложенную запись")
        when "/pls_find_full"
          day,current_left,max_left=File.read("date.txt").split
          day,current_left,max_left=day.to_i,current_left.to_i,max_left.to_i
          if Time.now.day.to_i != day
            current_left=max_left
            day=Time.now.day
          end
          if current_left.<=0
            Listener::Response.std_message("Бесплатные запросы сегодня больше не принимаются, попробуйте завтра")
          else
            Listener::Response.force_reply_message("Отправьте фото для поиска фулла")
            File.open("date.txt", "w+") do |f|
              f.puts([day,current_left,max_left]) end
          end
        when "122"
          Listener::Response.std_message("#{Listener.bot.api.send_message(chat_id:'-1001732598335', text:Time.new.day.to_s)}")
        when "133"
          #Listener.api.bot.edit_message_text(chat_id: "-1001732598335", message_id:"13",text:)
        when "123456"
          Listener::Response.std_message("#{Listener.message.from.id}")
        when "код"
          Listener.bot.api.send_message(chat_id:"-1001390791704", text:"bot test") #-1001390791704  @fulling_house - группа      -1001712660305   -  для ошибок #  -1001732598335 - предложка
          #Listener::Response.std_message("12  #{Listener.message.forward_from_chat.id}" )
        when "fuck"
          #Listener::Response.force_reply_message('reply')
        #when '/id_check'
          #Listener::Response.force_reply_message('Отправьте файл')
        when '12345'
          File.write('file_test.txt', (Listener.bot.api.send_document(chat_id: Listener.message.chat.id, document: Faraday::UploadIO.new('test.gif','gif/gif'))).to_s)
        else
          unless Listener.message.reply_to_message.nil?
            case Listener.message.reply_to_message.text
            when /Отправьте предложенную запись/
              Listener::Response.forward_message(-1001732598335, Listener.message, "post_suggest")
              Listener::Response.std_message("Отправленно на проверку")
            when /Отправьте фото для поиска фулла/
              Listener::Response.forward_message(-1001732598335, Listener.message, "pls_find_full")
              cont=File.read("date.txt").split
              current_left=cont[1].to_i-1
              cont[1]=current_left
              File.open("date.txt", "w+") do |f|
                f.puts(cont) end
              Listener::Response.forward_message(-1001732598335, Listener.message, "pls_find_full","#{current_left}")
              Listener::Response.std_message("Отправленно на проверку и поиск")
            when /Введите имя файла строго в формате\n название_файла_без_.txt новое содержимое/
              a=Listener.message.text.split(" ")
              case a[0]
              when "admin_list"
                a.delete("admin_list")
                File.open("admin_list.txt", "w+") do |f|
                  f.puts(a)
                end
              when "date"
                #a=Listener.message.text.split(" ")
                a.delete("date")
                File.open("date.txt", "w+") do |f|
                  f.puts(a)
                end
              end
            when /reply/
              Listener::Response.std_message("#{Listener.message.forward_from_chat.id}")
            when /Введите код, для отмены введите 0/
              return Listener::Response.std_message 'Неверный код' if Codes.check_and_send_full(Listener.message.text)
            when /Перешлите сообщение человека для добавления его в админы, для отмены введите 0/
              return Listener::Response.std_message 'ЭТО БЛЯТЬ НЕ РАБОАЕТ НЕ ТРОГАТЬ АДМИНА В РУЧНУЮ ДОБАВЛЯЕМ МНЕ ПОСРАТЬ'
              return Listener::Response.std_message 'Отмена' if Listener.message.text =="0"
              Listener::Response.std_message("#{Listener.message.forward_from.id.to_s}")
              Database.db.execute("insert into admin_list values ( ? )", Listener.message.forward_from.id.to_s)
            when /Отправьте файл/
              Listener::Response.std_message("#{file_id_get(Listener.message)}") if file_id_get(Listener.message)
            when /Отправьте фулл, для отмены введите 0/
              return Listener::Response.std_message 'Вы не админ' if Listener::Codes.is_admin?(Listener.message.from.id.to_s)
              return Listener::Response.std_message 'Отмена1234' if Listener.message.text.to_s=="0"
              #Listener::Response.std_message("#{Listener.message}")
              @a=Listener::Codes.file_id_get(Listener.message) if Listener::Codes.file_id_get(Listener.message)
              Listener::Response.force_reply_message('Теперь отправьте код, для отмены введите 0') if @a
            when /Теперь отправьте код, для отмены введите 0/
              return Listener::Response.std_message 'Отмена' if Listener.message.text.to_s=="0"
              return Listener::Response.std_message 'Вы не админ' if Listener::Codes.is_admin?(Listener.message.from.id)
              File.write('code_to_full.txt', "#{Listener.message.text} #{@a[0]} #{@a[1]}\n", mode: 'a')
              Listener::Response.std_message("#{Listener.message.text} #{@a[0]} #{@a[1]}\n")
              #Database.db.execute("INSERT INTO codes_to_full_message_list VALUES (?, ?)", ["#{Listener.message.text}", "#{@a}"])
            end
          end
                  #Response.std_message "#{Listener.message.forward_from_chat.id}"
        end
      end
      module_function(
        :process
      )

    end
  end
end
