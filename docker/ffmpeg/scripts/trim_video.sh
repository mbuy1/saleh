#!/bin/bash
# trim_video.sh - قص الفيديو
# Usage: ./trim_video.sh <input> <output> <start_time> <duration>

INPUT=$1
OUTPUT=$2
START_TIME=$3
DURATION=$4

if [ -z "$INPUT" ] || [ -z "$OUTPUT" ] || [ -z "$START_TIME" ]; then
    echo "Usage: ./trim_video.sh <input> <output> <start_time> [duration]"
    exit 1
fi

if [ -n "$DURATION" ]; then
    ffmpeg -i "$INPUT" -ss "$START_TIME" -t "$DURATION" -c copy "$OUTPUT" -y
else
    ffmpeg -i "$INPUT" -ss "$START_TIME" -c copy "$OUTPUT" -y
fi

echo "Trimmed video saved to: $OUTPUT"
