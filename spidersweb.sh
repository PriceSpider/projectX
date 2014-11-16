#!/bin/sh -x

for j in {1..31} ; do
  k=$((141200+$j))
  
  for i in {1..31} ; do
    l=$((150100+$i))
    
    ruby /home/skohl/WS1415/projectX/price_spider_argv.rb $k $l
    
    echo "wrote" "$k" "$l"
    
    sleep 10
  done 
done