#!/usr/bin/python

# Make sure you first get the python-twitter library: https://github.com/bear/python-twitter
# But in order to get needed functionality, get the master branch of the package: pip install git+git://github.com/bear/python-twitter.git
# Open tweet-video.py and enter all the appropriate variables: consumer_key, consumer_secret, access_token, access_token_secret, video_filename, srt_filename

import twitter
import json
import time

# TWITTER KEYS
# https://developer.twitter.com/en/portal/dashboard
consumer_key = ''
consumer_secret = ''
access_token = ''
access_token_secret = ''

def get_status(media_id, api):

  url = '%s/media/upload.json' % api.upload_url

  parameters = {
      'command': 'STATUS',
      'media_id': media_id
  }

  resp = api._RequestUrl(url, 'GET', data=parameters)
  data = resp.content.decode('utf-8')
  json_data = json.loads(data)
  print (json_data)
  return json_data['processing_info']['state']

api = twitter.Api(consumer_key, consumer_secret, access_token, access_token_secret)

video_filename = 'path/to/video.mp4'
srt_filename = '/path/to/transcript.srt'

# start uploading video
video_media_id = api.UploadMediaChunked(video_filename, media_category='TweetVideo')

# check status every 3 seconds until success
while True:
  video_status = get_status(video_media_id, api)
  print(video_status)
  if video_status == 'succeeded':
    break
  time.sleep(3)
  
# upload subtitle file
subtitle_media_id = api.UploadMediaChunked(srt_filename, media_category='Subtitles')

# attach subtitles to video
api.PostMediaSubtitlesCreate(video_media_id, subtitle_media_id, 'en', 'English')

# Tweet text with video attached
api.PostUpdate("Here's where you put the actual tweet text", media=video_media_id)