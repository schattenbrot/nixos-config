#!/usr/bin/env bash

# Detect sound card indices
xonar_index=""
intel_index=""

# Parse aplay output
while IFS= read -r line; do
    if [[ $line =~ card\ ([0-9]+):\ ([^ ]+).*\[(.*)\] ]]; then
        index="${BASH_REMATCH[1]}"
        card_name="${BASH_REMATCH[2]}"
        card_desc="${BASH_REMATCH[3]}"

        # Match card names or descriptions
        if [[ "$card_name" == *DGX* || "$card_desc" == *DGX* || "$card_desc" == *Xonar* ]]; then
            xonar_index="$index"
        elif [[ "$card_name" == *PCH* || "$card_desc" == *Intel* || "$card_desc" == *PCH* ]]; then
            intel_index="$index"
        fi
    fi
done < <(aplay -l)

# Check if both cards were found
if [[ -z "$xonar_index" || -z "$intel_index" ]]; then
    echo "Could not detect both sound cards."
    echo "Xonar DGX index: $xonar_index"
    echo "Intel PCH index: $intel_index"
    exit 1
fi

echo "Xonar DGX card index: $xonar_index"
echo "HDA Intel PCH card index: $intel_index"

# Apply ALSA mixer settings
amixer -c "$xonar_index" sset 'Analog Output' Multichannel
amixer -c "$intel_index" set Headphone 100% unmute

