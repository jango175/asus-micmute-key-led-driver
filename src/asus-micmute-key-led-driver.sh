#!/bin/bash

MICMUTE_PATH="/sys/devices/platform/asus-nb-wmi/leds/platform::micmute/brightness"
CARD="-c 1"
CONTROL="Capture"

# Check if the sound card is actually ready
if ! amixer $CARD get $CONTROL > /dev/null 2>&1; then
  echo "Error: Audio device '$CONTROL' not found. It might be initializing or named differently."
  exit 1
fi

while true; do
  # Check for [off] flag. In ALSA, [off] means Muted. [on] means Active.
  if amixer $CARD get $CONTROL | grep -q "\[off\]"; then
    CURRENT_STATE="1"
  else
    CURRENT_STATE="0"
  fi

  if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
    echo "$CURRENT_STATE" > "$MICMUTE_PATH"
    LAST_STATE="$CURRENT_STATE"
  fi

  # wait before checking again
  sleep 0.2
done
