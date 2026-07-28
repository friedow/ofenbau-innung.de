#!/usr/bin/env bash
# Downloads all gallery images from ofenbau-innung.info into static/images/.
# Run from the project root: bash scripts/download-images.sh
# Skips files that already exist. Reports missing images but continues.
set -euo pipefail

BASE="https://ofenbau-innung.info/wordpress/wp-content"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/static/images"

mkdir -p "$OUT"

download_gallery() {
  local src_path="$1"
  local src_name="$2"
  local out_dir="$3"
  local count="$4"
  mkdir -p "$OUT/$out_dir"
  echo "→ $out_dir ($count images)"
  for i in $(seq 1 "$count"); do
    local dest="$OUT/$out_dir/$i.jpg"
    [ -f "$dest" ] && continue
    wget -q --tries=3 \
      "${BASE}/Gallery/${src_path}/${src_name}%20(${i}).jpg" \
      -O "$dest" \
      || { echo "  missing: $i"; rm -f "$dest"; }
  done
}

download_gallery "Heizkamine/Stilkamine"            "Stilkamine"           "heizkamine/stilkamine"             27
download_gallery "Heizkamine/ModerneKamine"          "ModerneKamine"        "heizkamine/moderne-kamine"        114
download_gallery "Heizkamine/RustikaleKamine"        "RustikaleKamine"      "heizkamine/rustikale-kamine"       27
download_gallery "Kacheloefen/ModerneKacheloefen"    "ModerneKacheloefen"   "kacheloefen/moderne-kacheloefen"   27
download_gallery "Kacheloefen/ZeitloseKacheloefen"   "ZeitloseKacheloefen"  "kacheloefen/zeitlose-kacheloefen"  24
download_gallery "Kacheloefen/RustikaleKacheloefen"  "RustikaleKacheloefen" "kacheloefen/rustikale-kacheloefen" 27
download_gallery "Kaminoefen"                        "Kaminoefen"           "kaminoefen"                       116
download_gallery "Herde"                             "Herde"                "herde"                             27

echo "→ logo"
wget -q --tries=3 \
  "${BASE}/uploads/2015/07/Logo-Ofenbau-Innung-512.png" \
  -O "$OUT/logo.png" \
  || echo "  logo not found — place logo manually at static/images/logo.png"

echo "Done. Images saved to static/images/"
