#!/usr/bin/env bash

# ✅ Update yt-dlp before starting
yt-dlp -U

# ✅ Prepare failed log
FAILED_LOG="failed.txt"
> "$FAILED_LOG"  # Clear file before use

# ✅ Function to download a single video with safe fallback
cust_func(){
  echo "[+] DOWNLOADING: $1"

  yt-dlp \
    -f 'bv*[ext=mp4][height<=720]+ba[ext=m4a]/best[ext=mp4]/best' \
    --restrict-filenames \
    --download-archive downloaded.txt \
    --no-warnings \
    --no-call-home \
    "$1"

  # ✅ Check exit code for success/failure
  if [[ $? -ne 0 ]]; then
    echo "[-] FAILED: $1"
    echo "$1" >> "$FAILED_LOG"
  else
    echo "[+] COMPLETED: $1"
  fi
}

# ✅ Main loop to read queue and download in parallel
while IFS= read -r url
do    
  cust_func "$url" &
done < "$1"
wait

echo
echo "✅ ALL DONE"
if [[ -s "$FAILED_LOG" ]]; then
  echo "⚠️ Some videos failed to download. See: $FAILED_LOG"
else
  echo "🎉 All videos downloaded successfully!"
fi
