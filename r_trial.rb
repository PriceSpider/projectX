require 'rubygems'
require 'nokogiri'
require 'open-uri'

TARGET_URL = 'http://www.skyscanner.de/transport/fluge/fran/mela/141227/150110/flugpreise-von-frankfurt-am-main-nach-melbourne-im-dezember-2014-und-januar-2015.html?rtn=1'

#generally works, but gives <li class='disabled'>
CSS_IDS1 = 'div#pagewrap div#content-main div#filters-stops' # day-filters-label-price'

#does not work even though at same hierarchical level
CSS_IDS2 = 'div#pagewrap div#content-main div#day-compare-by-price'

#nokogirir parser
page = Nokogiri::HTML(open(TARGET_URL)) 

#prints all html/css elements in subbranch as specified thru its argument
puts page.css(CSS_IDS2)#.each do |el|


#  puts el.text

#puts page.search('.mainquote-wrapper')

#puts page.xpath('//label//span')
   
#end
t

