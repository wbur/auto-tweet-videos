#!/bin/bash

# finds the status of AWS Transcribe job with name
# SHOW_YYYY_MM_DD

# if status is COMPLETED
# it downloads the transcript JSON,
# then converts it into an srt file named
# SHOW_YYYY_MM_DD.srt

year=$(date +'%Y')
month=$(date +'%m')
day=$(date +'%d')

job="SHOW_${year}_${month}_${day}"
temp_job_file=/tmp/$job.json

base="SHOW_${year}_${month}_${day}"
transcript_file=$base.mp4.transcript

response=$(aws transcribe get-transcription-job --transcription-job-name $job | jq . > $temp_job_file)

status=$(jq -r .TranscriptionJob.TranscriptionJobStatus $temp_job_file)

if [ $status = "COMPLETED" ];
then
    uri=$(jq -r .TranscriptionJob.Transcript.TranscriptFileUri $temp_job_file)

    cat $temp_job_file

    # create dir, if needed
    mkdir -p transcripts/$year

    # get file
    wget -O $transcript_file.json $uri && mv $transcript_file.json /tmp/$transcript_file.json
    python amazon-transcribe-JSON-to-SRT.py /tmp/$transcript_file.json > $base.srt
    rm /tmp/$transcript_file.json
fi

rm $temp_job_file