#!/usr/bin/env bash
# Geocode member addresses via Nominatim and write data/member_coords.json.
# Run from the repository root: bash scripts/geocode-members.sh
# The output file is read by the Hugo template to place map markers without
# any client-side geocoding.

set -euo pipefail

YAML="data/members.yaml"
OUT="data/member_coords.json"

mapfile -t addresses < <(
  grep -E "^  address:" "$YAML" | awk '{
    # strip leading "  address: "
    sub(/^[[:space:]]+address:[[:space:]]+/, "")
    # strip surrounding double-quotes if present
    gsub(/^"|"$/, "")
    print
  }'
)

total=${#addresses[@]}
echo "Geocoding $total addresses → $OUT"
echo "["  > "$OUT"

for i in "${!addresses[@]}"; do
  addr="${addresses[$i]}"
  printf "  (%d/%d) %s\n" "$((i+1))" "$total" "$addr"

  nominatim_query() {
    local q="$1"
    local enc
    enc=$(printf '%s' "$q" | jq -Rr @uri)
    curl -sf --max-time 10 \
      -H "User-Agent: ofenbau-innung.info/build-script" \
      "https://nominatim.openstreetmap.org/search?q=${enc}&format=json&limit=1" || echo "[]"
  }

  result=$(nominatim_query "$addr, Deutschland")
  lat=$(printf '%s' "$result" | jq -r '.[0].lat // empty')
  lon=$(printf '%s' "$result" | jq -r '.[0].lon // empty')

  # Retry without "OT" (Ortsteil) qualifiers that confuse Nominatim
  if [[ -z "$lat" && "$addr" == *" OT "* ]]; then
    simplified=$(printf '%s' "$addr" | awk '{gsub(/ OT [^ ,]+/, ""); print}')
    sleep 1.2
    result=$(nominatim_query "$simplified, Deutschland")
    lat=$(printf '%s' "$result" | jq -r '.[0].lat // empty')
    lon=$(printf '%s' "$result" | jq -r '.[0].lon // empty')
  fi

  if [[ -n "$lat" && -n "$lon" ]]; then
    printf "         → %s, %s\n" "$lat" "$lon"
    entry="{\"lat\": $lat, \"lon\": $lon}"
  else
    echo "         → not found"
    entry="null"
  fi

  if [[ $i -lt $((total - 1)) ]]; then
    printf '  %s,\n' "$entry" >> "$OUT"
  else
    printf '  %s\n'  "$entry" >> "$OUT"
  fi

  sleep 1.2
done

echo "]" >> "$OUT"
echo "Done. Written to $OUT"
