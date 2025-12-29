#!/bin/bash

# detect the active user (usually UID 1000) for wpctl command
TARGET_USER=$(loginctl list-users | grep -v 'UID' | awk '{print $2}' | head -n 1)
TARGET_UID=$(id -u "$TARGET_USER")
export XDG_RUNTIME_DIR="/run/user/$TARGET_UID"

MICMUTE_PATH="/sys/devices/platform/asus-nb-wmi/leds/platform::micmute/brightness"
LAST_STATE="-1"


while true; do
  OUTPUT=$(sudo -u "$TARGET_USER" XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
  if echo "$OUTPUT" | grep -q "MUTED"; then
    CURRENT_STATE="1" # LED ON (muted)
  else
    CURRENT_STATE="0" # LED OFF (unmuted)
  fi

  if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
    echo "$CURRENT_STATE" > "$MICMUTE_PATH"
    LAST_STATE="$CURRENT_STATE"
  fi

  # wait before checking again
  sleep 0.2
done
