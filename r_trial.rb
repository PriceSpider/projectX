require 'rubygems'
require 'nokogiri'
require 'open-uri'

TARGET_URL = 'http://www.skyscanner.de/transport/fluge/fran/mela/141227/150110/flugpreise-von-frankfurt-am-main-nach-melbourne-im-dezember-2014-und-januar-2015.html?rtn=1'

#generally works, but gives <li class='disabled'>
CSS_IDS1 = 'div#pagewrap div#content-main div#filters-stops li' # day-filters-label-price'

#does not work even though at same hierarchical level
CSS_IDS2 = 'div.pagewrap div.content-main div.filters-stops'# div.day-filters-content-wrapper div.clearfix span'

#nokogirir parser
page = Nokogiri::HTML(open(TARGET_URL)) 

#prints all html/css elements in subbranch as specified thru its argument

#puts page.css('div.filters-stops li span[day-filters-label-price]')[1].name
#puts page.css('li')[0].text

puts page.css("span[class='day-filters-label-price']")[1].text
#puts page.css(CSS_IDS1).each {|el| el.text}

#puts page.search('.mainquote-wrapper')

#puts page.xpath('//label//span')
   
#end


