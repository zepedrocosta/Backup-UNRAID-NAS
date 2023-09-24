#!/bin/bash
#
# Use User Scripts (available at the plugins tab in unraid) to
# automatically run the script. It is possible to schedule the
# action.
#
# Basic usage:
#   ./rclone.sh
#
# Every five days this script should run at 04:00 AM
# Custom schedule format (standard cron entry): "0 4 1/5 * *"
#
# Script requires valid credentials - set up with `rclone config`.
#
# Based on https://github.com/geerlingguy/my-backup-plan

# Variables.
# Variables for the first bucket (Knox)
rclone_remoteKnox=personal
rclone_s3_bucketKnox=bucket_name

# Variables for the second bucket (ClipKiller)
rclone_remoteClipKiller=personal
rclone_s3_bucketClipKiller=bucket_name

bandwidth_limit=23M # 192,937984 Mbps

# Verify the location of rclone using 'whereis' in the terminal
RCLONE=/usr/local/bin/rclone

# Rclone password input
export RCLONE_CONFIG_PASS=secret.password

# Check if rclone is installed.
if ! [ -x "$(command -v $RCLONE)" ]; then
  echo 'Error: rclone is not installed.' >&2
  exit 1
fi

# List of directories to clone.
# Place here all the directories that you want to be synced to AWS S3
# For each remote there is a specific list

declare -a dirsClipKiller=(
  "/Volumes/Media/Movies"
)

declare -a dirsKnox=(
  "/Volumes/Media/Movies"
)

# Sync each directory.
for i in "${dirsClipKiller[@]}"; do
  echo "Syncing Directory: $i"
  despaced="${i// /_}"
  $RCLONE sync "$i" $rclone_remoteClipKiller:$rclone_s3_bucketClipKiller"$despaced" --skip-links --progress --bwlimit $bandwidth_limit
done

for i in "${dirsKnox[@]}"; do
  echo "Syncing Directory: $i"
  despaced="${i// /_}"
  $RCLONE sync "$i" $rclone_remoteKnox:$rclone_s3_bucketKnox"$despaced" --skip-links --progress --bwlimit $bandwidth_limit
done
