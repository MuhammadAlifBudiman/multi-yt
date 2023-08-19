#!/usr/bin/env bash
#
# Google Colab usage:
#    bash multiYT.sh queue.txt
# queue.txt contains 10 links DL'ed at ~23 seconds.
#
cust_func(){
  echo "[+] DOWNLOADING..."
  echo "$1"
  yt-dlp -x --restrict-filenames "$1"
  echo "[+] Completed"
}

# Here is $1 is queue.txt

while IFS= read -r url
do    
  cust_func "$url" &
done < $1
wait

echo "EXIT"