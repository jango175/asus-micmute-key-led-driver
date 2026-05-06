#!/bin/bash

MICMUTE_PATH="/sys/devices/platform/asus-nb-wmi/leds/platform::micmute/brightness"
CARD="1"
CONTROL="Capture"

# Check if the sound card is actually ready
if ! amixer -c "$CARD" get "$CONTROL" > /dev/null 2>&1; then
  echo "Error: Audio device '$CONTROL' not found. It might be initializing or named differently."
  exit 1
fi

# Function to check current state and update the LED
update_led() {
  # In ALSA, [off] means Muted. You want the LED ON (1) when disabled/muted.
  if amixer -c "$CARD" get "$CONTROL" | grep -q "\[off\]"; then
    CURRENT_STATE="1"
  else
    CURRENT_STATE="0"
  fi

  # Only write to the file if the state actually needs to change
  if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
    echo "$CURRENT_STATE" > "$MICMUTE_PATH"
    LAST_STATE="$CURRENT_STATE"
  fi
}

# Set the initial LED state immediately on startup
update_led

# Filter the noise and force immediate line-buffering
alsactl monitor "$CARD" | grep --line-buffered -i "$CONTROL" | while read -r event; do
  update_led
done
