#!/bin/bash
# add_subtitles.sh - إضافة ترجمة للفيديو
# Usage: ./add_subtitles.sh <video> <srt_file> <output> [style]

VIDEO=$1
SRT_FILE=$2
OUTPUT=$3
STYLE=${4:-"FontSize=24,PrimaryColour=&HFFFFFF&,OutlineColour=&H000000&,Outline=2"}

if [ -z "$VIDEO" ] || [ -z "$SRT_FILE" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: ./add_subtitles.sh <video> <srt_file> <output> [style]"
    exit 1
fi

ffmpeg -i "$VIDEO" \
    -vf "subtitles=$SRT_FILE:force_style='$STYLE'" \
    -c:a copy \
    "$OUTPUT" -y

echo "Video with subtitles saved to: $OUTPUT"
