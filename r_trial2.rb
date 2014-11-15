require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'watir'


TARGET_URL = 'http://www.skyscanner.de/transport/fluge/fran/mela/141227/150110/flugpreise-von-frankfurt-am-main-nach-melbourne-im-dezember-2014-und-januar-2015.html?rtn=1'

#page might use AJAX to load content -> use browser itself to load content thru watir gem
#--> TODO check Nokogiris mechanize method

browser = Watir::Browser.new
browser.goto TARGET_URL

page = Nokogiri::HTML.parse(browser.html)

#prints cheapest 1-Stop price that appears in left column of website
puts page.css("span[class='day-filters-label-price']")[1].text