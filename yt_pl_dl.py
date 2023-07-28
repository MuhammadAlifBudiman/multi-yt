########################################################################
            ########### yt-dlp parallel download ###########
########################################################################
## Pre-requisites:
##     Google colab
## put multiYT.sh in "/content" folder
## copy contents of this python file to colab code cell.

## how many parallel downloads?
BATCH_SIZE = 5 
PLAYLIST_URL = "https://www.youtube.com/playlist?"
#########################################################################


## Step 1: Command to Flat URL to playlist
!yt-dlp --flat-playlist -i --print-to-file url playlist.txt "$PLAYLIST_URL"

## Step 2: Convert large list into smaller list of BATCH_SIZE items
with open("playlist.txt") as pl:
    links = [l.strip() for l in pl]

total = len(links)
groups = int(total / BATCH_SIZE)
extra = total % BATCH_SIZE

b = 0
for j in range(groups):
    with open(f"queue{j+1}.txt", 'a') as f:
        for k in links[b:b+BATCH_SIZE]:
            f.write(f"{k}\n")
        b = b + BATCH_SIZE

if extra:
    with open(f"queue{j+1+1}.txt", 'a') as f:
        for r in links[b:]:
            f.write(f"{r}\n")

print("total items:", total,"groups:", groups ,"extra:", extra)
## Step 3: Execute yt-dlp (*-*)+--
!for i in $(ls | grep "queue"); do bash multiYT.sh $i;done