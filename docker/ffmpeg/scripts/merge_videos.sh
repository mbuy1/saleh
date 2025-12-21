#!/bin/bash
# merge_videos.sh - دمج فيديوهات
# Usage: ./merge_videos.sh <output> <video1> <video2> [video3...]

OUTPUT=$1
shift
VIDEOS=("$@")

if [ ${#VIDEOS[@]} -lt 2 ]; then
    echo "Usage: ./merge_videos.sh <output> <video1> <video2> [video3...]"
    exit 1
fi

# Create concat file
CONCAT_FILE=$(mktemp /tmp/concat_XXXXXX.txt)

for video in "${VIDEOS[@]}"; do
    echo "file '$video'" >> "$CONCAT_FILE"
done

# Merge videos
ffmpeg -f concat -safe 0 -i "$CONCAT_FILE" -c copy "$OUTPUT" -y

# Cleanup
rm -f "$CONCAT_FILE"

echo "Merged video saved to: $OUTPUT"
