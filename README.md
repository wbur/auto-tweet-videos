# Sample scripts for turning audio into Twitter-friendly videos

## Requirements

- These will only work in a *nix-like environment (yes, that includes the OSX terminal).
- Make sure you have the following installed: aws, mp3info, wget, jq
- /tmp should be writable by the user executing the script
- Properly setting up the AWS CLI is well beyond the scope of these docs. If you are not comfortable with this tool, please stop now, set it up, create your credentials, and familiarize yourself with it. Otherwise, these scripts will forever frustrate you.
- Assuming you're making srt/transcripts, you also should be familiar with AWS Transcript as well as AWS S3.
- To actually tweet these out, you'll need Twitter API access. This too is well beyond the scope of these docs.
- For tweeting, there are further, achingly specific Python requirements. Please note them in the comments at the top of `tweet-video.py`

## Installation

- Place all the scripts in the same directory, make the relevant files executable.
- Read through all files, paying special attention to comments at the top. Make any needed tweaks.

## Implementation

- TEST LOCALLY FIRST!
- `./start_transcript_job.sh` should be run first (assuming you want a transcript).
- After a few minutes have passed, and the transcript is done (check in the AWS Transcribe GUI), you can run `./create_srt_transcript.sh` which will turn your AWS Transcribe JSON file into a srt file using `amazon-transcribe-JSON-to-SRT.py`.
- `./create_microcast_videos.sh` will convert an mp3 and a jpeg into a Twitter suitable mp4 video
- `tweet-video.py` will tweet out the video via the Twitter API
