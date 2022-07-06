class FishSocket
  module Image_handler

    def generate()#{}"<li>Source: <a href=\"https://www.pixiv.net/artworks/80710356\" rel=\"nofollow\">www.pixiv.net/artworks/80710356</a></li> <li>Rating: Questionable</li>\n"
      $info=Array.new
      $img=""
      $source=Array.new
      index=0#https://rule34.xxx/index.php?page=post&s=view&id=6148337
      copy_next_line=false#https://rule34.xxx/index.php?page=post&s=random
      no_source=true #fur #furry #gay #furaffinity.net
      img_not=true
      restart=false
      ban_tags=['fur','furry','furaffinity.net','gay']
      def remove_else(a)
        if a.downcase.include? "source"
          i=a.index('http')
          a=a[i..-6]
        elsif a.include? "rule34.xxx//images/"
          i=a.index('http')
          a=a[i..-6]
        else
          i=a.index('>')
          a=a[i+1..-6]
        end
        return a
      end
      URI.open("https://rule34.xxx/index.php?page=post&s=random") {|f|
        f.each_line {|line|
          if copy_next_line
            copy_next_line=false
            $info << line[line.index('>')+1..-6]
            #index+=1
          end
          if ban_tags.any? { |s| line.include? s }
            restart=true
            break
          end
          if line.include? "tag-type-character tag" or line.include? "tag-type-artist tag" or line.include? "tag-type-copyright tag" then
            copy_next_line=true
          end
          if line.include? "id=\"source\" value=" and no_source
            no_source=false
            #$info << line[line.index('http')..-6]
          end
          if line.include? "rule34.xxx//images/" and img_not
            $img=line[line.index('http')..-6]
            img_not =false
          end
          #p line
        }
      }
      if restart then

      else
        begin
        Listener::Response.inline_message("#{$img} #{$info}", Listener::Response.generate_inline_markup([
            Inline_Button::NEXT_PHOTO,
            Inline_Button::EDIT_TAGS,
            Inline_Button::POST_IMAGE,
        ]), false)
        ensure
          File.write('error.txt',"#{$img} /n #{$info}")
        end
      end
      return(restart)
  end
  def post_image()
    Listener.bot.api.send_message(chat_id: "633523289", text: "<a href=\"#{$img}\"></a>" +"testing ##{$info.join(' #')}", parse_mode: "HTML" )
    #Listener::Response.std_message("testing ##{$info.join(' #')}")
  end
  module_function(
      :generate,
      :post_image
  )
  end
end
