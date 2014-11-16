#require 'rubygems'
require 'nokogiri'
#require 'open-uri'
require 'watir-webdriver'
require 'headless'
require 'csv'

TARGET_URL = 'http://www.skyscanner.de/transport/fluge/fran/mela/141227/150110/flugpreise-von-frankfurt-am-main-nach-melbourne-im-dezember-2014-und-januar-2015.html?rtn=1'
 

#page might use AJAX to load content -> use browser itself to load content thru watir gem
#--> TODO check Nokogiris mechanize method

#headless requires xvfb (apt-get install xvfb ;)) -> aw yeah virtual server shit and such jazz!
headless = Headless.new
headless.start

browser = Watir::Browser.start TARGET_URL
page = Nokogiri::HTML.parse(browser.html)

browser.close
headless.destroy

#prints cheapest 1-Stop price that appears in left column of website
price_oneStop = page.css("span[class='day-filters-label-price']")[1].text

dt = Time.new
dateTime = dt.inspect

new_row = [[dateTime, price_oneStop]]

#append to row within existing csv file
CSV.open('FRA_MEL.csv', 'ab') do |csv|
    new_row.each do |row|
        csv << row
    end
end