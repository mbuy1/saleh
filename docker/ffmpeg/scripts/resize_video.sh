#!/bin/bash
# resize_video.sh - تغيير حجم الفيديو
# Usage: ./resize_video.sh <input> <output> <width> <height>

INPUT=$1
OUTPUT=$2
WIDTH=$3
HEIGHT=$4

if [ -z "$INPUT" ] || [ -z "$OUTPUT" ] || [ -z "$WIDTH" ] || [ -z "$HEIGHT" ]; then
    echo "Usage: ./resize_video.sh <input> <output> <width> <height>"
    exit 1
fi

ffmpeg -i "$INPUT" \
    -vf "scale=$WIDTH:$HEIGHT:force_original_aspect_ratio=decrease,pad=$WIDTH:$HEIGHT:(ow-iw)/2:(oh-ih)/2" \
    -c:a copy \
    "$OUTPUT" -y

echo "Resized video saved to: $OUTPUT"
