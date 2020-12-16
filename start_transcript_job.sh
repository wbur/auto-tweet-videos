#!/bin/bash

# script creates am AWS Transcribe job named
# SHOW_YYYY_MM_DD
# provided a file exists in S3 at url
# And file is not more than 2:20

# Format for url should be:
# http://s3.amazonaws.com/BUCKET_NAME/FILE_NAME
url=''

# Format for s3_url should be:
# s3://BUCKET_NAME/FILE_NAME
s3_uri=''

year=$(date +'%Y')
month=$(date +'%m')
day=$(date +'%d')

# create unique episode name
base="SHOW_${year}_${month}_${day}"

mp3_file_name="${base}.mp3"

# get file
wget $url && mv $mp3_file_name /tmp/$mp3_file_name

# duration much simpler to get with mp3info
duration=$(mp3info -p "%S\n" /tmp/$mp3_file_name)

# if duration longer than 2:20, just create a file with warning in name
# 2:20 is max video duration for Twitter
if [ "$duration" -gt 140 ];
then
	echo "Audio file too long."
else
	aws transcribe start-transcription-job --transcription-job-name $base --language-code en-US --media-format mp3 --media MediaFileUri=$s3_uri
fi

# remove temp file, regardless of whether video was made
rm /tmp/$mp3_file_name