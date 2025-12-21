#!/bin/bash
# add_music.sh - إضافة موسيقى للفيديو
# Usage: ./add_music.sh <video> <audio> <output> [volume]

VIDEO=$1
AUDIO=$2
OUTPUT=$3
VOLUME=${4:-0.3}

if [ -z "$VIDEO" ] || [ -z "$AUDIO" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: ./add_music.sh <video> <audio> <output> [volume]"
    exit 1
fi

ffmpeg -i "$VIDEO" -i "$AUDIO" \
    -filter_complex "[1:a]volume=$VOLUME[a1];[0:a][a1]amix=inputs=2:duration=first" \
    -c:v copy \
    "$OUTPUT" -y

echo "Video with music saved to: $OUTPUT"
