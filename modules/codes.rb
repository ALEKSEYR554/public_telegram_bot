class FishSocket
  module Listener
    # This module assigned to processing all promo-codes
    module Codes
      def is_admin?(a)
        admin_list=File.readlines("admin_list.txt")
        Listener::Response.std_message("#{admin_list}  #{a.to_s}")
        return true if admin_list.include? a
        return false
      end
      def file_id_get(file)
        #begin
        if file.video
            return [file.video.file_id, "video"]
        elsif file.text
            return [file.text, "text"]
        elsif file.animation
          return [file.animation.file_id, "animation"]
        elsif file.document
            return [file.document.file_id, "document"]
        elsif file.photo
            file_id= Listener.bot.api.get_updates.dig('result',0,'message','photo',-1,'file_id')
            return [file_id,"photo"]
            #Listener.bot.api.send_message(chat_id:"-1001712660305", text:("#{file_id}"))
             #file.photo.file_id
        else Listener::Response.std_message(chat_id: Listener.message.chat.id, message:"попробуй что-то еще" )
        end
        #rescue Exception => e
        #  Listener.bot.api.send_message(chat_id:"-1001712660305", text:"#{Time.now} \n #{e}")
        #  Listener::Response.std_message("Произошла непредвиденная ошибка, сообщите @ALEKSEYR554 число ниже и что привело к ней \n #{Time.now}")
        #  return false
      #  ensure
      #end
      end
      def check_and_send_full(code)
        File.readlines("code_to_full.txt").each { |x|
          x=x.split(' ')
          if code==x[0]
            case x[2]
            when "text"
              Listener::Response.std_message("#{x[1]}")
            when "photo"
              Listener::Response.send_photo(x[1])
            when "video"
              Listener::Response.send_video(x[1])
            when "document"
              Listener::Response.send_document(x[1])
            when "animation"
              Listener::Response.send_animation(x[1])
            end
            return false
          end
        }
        return true
      end
      module_function(
          :is_admin?,
          :file_id_get,
          :check_and_send_full
      )
    end
  end
end
