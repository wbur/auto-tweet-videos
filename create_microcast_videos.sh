#!/bin/bash

# script will look for a file named
# SHOW_YYYY_MM_DD.mp3
# that sits in BUCKET_NAME on S3
# if it's under 2:20
# it will create a Twitter-friendly video named
# SHOW_YYYY_MM_DD.mp4

year=$(date +'%Y')
month=$(date +'%m')
day=$(date +'%d')

base="SHOW_${year}_${month}_${day}"

mp3_file_name="${base}.mp3"

mp4_file_name="${base}.mp4"

url="http://s3.amazonaws.com/BUCKET_NAME/${mp3_file_name}"

# get file
wget $url && mv $mp3_file_name /tmp/$mp3_file_name

# duration much simpler to get with mp3info
duration=$(mp3info -p "%S\n" /tmp/$mp3_file_name)

# if duration longer than 2:20, just create a file with warning in name
# 2:20 is max video duration for Twitter
if [ "$duration" -gt 140 ];
then
	touch "videos/"$mp4_file_name"_NO_FILE_AUDIO_OVER_140s"
else
	ffmpeg -loop 1 -y -i SHOW.jpg -i /tmp/$mp3_file_name  -c:v libx264 -c:a aac -b:a 192k -pix_fmt yuv420p -shortest $mp4_file_name
fi

# remove temp file, regardless of whether video was made
rm /tmp/$mp3_file_name