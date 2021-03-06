    #Written by Mike Worth, http://www.mike-worth.com/2012/06/24/updating-youtube-music-player/  
    require 'rubygems'
    require 'hpricot'  
    require 'open-uri'  
      
    #You`ll have to look this up manually by using the hcitool command  
    #leave it blank to disable the autopause feature  
    #BLUETOOTH_ADDRESS='54:9B:12:96:0D:63'  
    BLUETOOTH_ADDRESS=''  

    running=''
    msquest=true
      
    #returns whether or not the bluetooth device can be seen as a boolean  
    def isPresent(address)  
      #do it twice to double check that we didn`t just momentarily loose contact  
      if (IO.popen('hcitool name '+address).read=='' && IO.popen('hcitool name '+address).read=='')  
        return false  
      else  
        return true  
      end  
    end  
      
    #picks a random mp3 from cwd and plays it  
    def shuffle  
      tracks=Dir['*.mp3']  
      if tracks.length==0  
        sleep 1  
      else  
        track=tracks[rand(tracks.length)]  
        play(track)  
      end  
    end  
     
    def message
	pics=Dir['ASCIIpicture*.rb']
	if pics.length!=0
		pic=pics[rand(pics.length)]
		load pic
	end
    end  

 
    #plays the track with mpg321 and tries to look up artist/title details form youtube to print  
    def play(track)  
      #begin  
      #  page=Hpricot(open('http://www.youtube.com/watch?v='+track))  
      #  begin  
      #    artist=page.search('span.metadata-info')[0].inner_text.gsub('Artist:','').strip  
      #    title=page.search('span.metadata-info')[1].inner_text.split('"')[1].strip  
      #    track_title=artist+': '+title+'('+track+')'  
      #  rescue  
      #    track_title=page.search('[@id=eow-title]').inner_text.strip.gsub("\n",'')+'('+track+')'  
      #  end  
      #rescue OpenURI::HTTPError  
      #  track_title=track  
      #end  
      puts 'Playing '+track  
      trackASCII = track.gsub(/(?<foo>[ $&@(){}"'])/, '\\\\\k<foo>')
      $player_pid=IO.popen('mpg321 -q '+ trackASCII).pid  
      Process.wait($player_pid)  
    end  
      
    #assuming that pid is an instance of mpg321 this will check if it has already been paused and return a boolean  
    def playing(pid)  
      return File.open('/proc/'+$player_pid.to_s+'/stat','r').gets.split(' ')[2]!='T'  
    end  
      
    playlist=Array.new  
    #This thread actually plays the tracks in the playlist then removes them.  
    Thread.new{  
      while true  
        #If the playlist is empty, play random mp3s until someone adds something  
        if playlist.length==0 then  
          running='Shuffling... Sorry Dude, you gotta look by yourself'  
          shuffle  
        else  
          running=playlist[0] 
          play(playlist.shift)  
        end  
      end  
    }  
      
    #If the bluetooth device leaves range, this thread pauses the music until it returns  
    autopause=Thread.new {  
    if BLUETOOTH_ADDRESS!=''  
        $autopaused=false  
        previous_state=true  
        if isPresent(BLUETOOTH_ADDRESS)  
	   puts 'BLUETOOTHDEVICE PRESENT'
	end
        while true  
          if isPresent(BLUETOOTH_ADDRESS)  
            #if the phone wasn't here before but is now, it's just arrived back. If we autopaused the music, resume it  
            if !previous_state and $autopaused  
              Process.kill('CONT',$player_pid)  
              $autopaused=false  
            end  
            previous_state=true  
          else  
            #if the phone was here before but isn't now, it's just left. If music is playing, pause it.  
            if previous_state and playing($player_pid)  
	      puts 'PAUSED DUE TO BLUETOOTH'
              Process.kill('STOP',$player_pid)  
              $autopaused=true  
            end  
            previous_state=false  
          end  
        end  
      end  
    }  
      
    #While the main thread handles the user interface:  
    while true  
      if msquest==true
	message  
      end
      puts 'Songs in Playlist:' 
      puts playlist 
      puts 'What would you like to listen to?'  
      search_string= gets.chomp  
      
      #allow the use of a few basic commands  
      if search_string=='/pause'  
        Process.kill('STOP',$player_pid)  
      elsif search_string=='/skip'  
        Process.kill('KILL',$player_pid)  
      elsif search_string=='/play'  
        Process.kill('CONT',$player_pid)  
      elsif search_string=='/list'  
        puts 'Songs in Playlist:'
	puts playlist
      elsif search_string=='/playing'  
        puts 'Current Song: ' + running
      elsif search_string=='/clear'  
	playlist.clear
      elsif search_string=='/help'  
	load 'ZZhelp.rb'
      elsif search_string=='/pics on'  
	msquest=true
      elsif search_string=='/pics off'  
	msquest=false
      elsif search_string=='/jf'  
	playlist.clear
	playlist<<'The 1975 - Chocolate-FfBKqaVk2Co.mp3'
      elsif search_string=='/jfnow'  
	playlist.clear
	playlist<<'The 1975 - Chocolate-FfBKqaVk2Co.mp3'
        Process.kill('KILL',$player_pid)  
	load 'ZZpicjf.rb'
      
      else  
        puts'Searching for '+search_string+'...'  
        #Use Hpricot to load the youtube search page and scrape the titles and ids of the top 5 results  
        begin  
          doc = Hpricot(open('http://www.youtube.com/results?search_type=search_videos&search_query='+search_string.gsub(' ','+')))  
          result_divs=doc.search("div.yt-lockup-content")  
          results=Array.new  
      
          #Ask the user which one they want  
          for i in 0..7 do  
            #keep the a object as it has both bits of data  
            results[i]=result_divs[i].search("h3.yt-lockup-title") 
            puts (i+1).to_s + ') ' + results[i].inner_text  
          end  
          choice=gets.chomp.to_i    
          if (1..8).include?(choice) then  
            choice-=1  
	    href=results[choice].search('a').first[:href]
            youtube_id = 'https://www.youtube.com' +href
          
            #Download/extract the audio in parallel so that more tracks can be added in the meantime  
            Thread.new(youtube_id,results[choice].inner_text) {|id,title|  
	      shortid = id[32..-1]
	      fileID = title + '-' + shortid
              if ! File.exist?(fileID+'.mp3')  
                puts 'Downloading ' + title  
                system('youtube-dl --extract-audio -w -q -f 5 --no-part '+id)  
              end  
              playlist<<fileID+'.mp3'  
              puts title+' added to playlist'  
            }  
          end  
        rescue  
          puts 'Error fetching search page'  
        end  
      end  
    end  
