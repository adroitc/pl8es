class LoginController < ApplicationController
  
#  def index
#    text = "
#Lasagne / Lasagne
#20€
#
#Überbackene Fusilli / Scalopped fusilli
#15€
#
#Penne mit Fleischbällchen / Penne with meatballs
#18€
#
#Spaghetti mit Meeresfrüchten / Spaghetti with seafood
#23€
#
#Paella / Paella
#25€
#
#Jakobsmuscheln an Tomaten und grünem Spargel / Scallops with tomatoes and asparagus
#24€
#
#Kalbsgeschnetzeltes auf mediterranem Salat / Veal strips on mediterranean salad
#19€
#
#Hähnchen-Paprika-Spieße vom offenen Feuer / Chicken-pepper-skewers from the open fire
#21€"
#    #
#    t = ""
#    text.split("€
#").each do |o|
#    a = o.gsub("
#","______").gsub(" / ","______").split("______")
#if a.count > 2
#t = t+"
#							<dict>
#								<key>item_id</key>
#								<string>2</string>
#								<key>item_imghash</key>
#								<string>6</string>
#								<key>item_imgurl</key>
#								<string>http://www.serles.at/upload/bilder/129_hotel_serles_salat_160812.jpg</string>
#								<key>item_lang</key>
#								<array>
#									<dict>
#										<key>item_desc</key>
#										<string>Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. </string>
#										<key>item_title</key>
#										<string>#{a[2]}</string>
#										<key>lang_tag</key>
#										<string>en</string>
#									</dict>
#								</array>
#								<key>item_price</key>
#								<string>#{a[3]}</string>
#							</dict>".gsub("€","")
#    end
#  end
#    render :text => t
#  end
#  
end
