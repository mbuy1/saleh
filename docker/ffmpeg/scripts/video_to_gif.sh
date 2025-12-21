#!/bin/bash
# video_to_gif.sh - تحويل فيديو إلى GIF
# Usage: ./video_to_gif.sh <input> <output> [fps] [scale]

INPUT=$1
OUTPUT=$2
FPS=${3:-15}
SCALE=${4:-480}

if [ -z "$INPUT" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: ./video_to_gif.sh <input> <output> [fps] [scale]"
    exit 1
fi

# Generate palette for better quality
PALETTE=$(mktemp /tmp/palette_XXXXXX.png)

ffmpeg -i "$INPUT" \
    -vf "fps=$FPS,scale=$SCALE:-1:flags=lanczos,palettegen" \
    "$PALETTE" -y

ffmpeg -i "$INPUT" -i "$PALETTE" \
    -filter_complex "fps=$FPS,scale=$SCALE:-1:flags=lanczos[x];[x][1:v]paletteuse" \
    "$OUTPUT" -y

# Cleanup
rm -f "$PALETTE"

echo "GIF saved to: $OUTPUT"
