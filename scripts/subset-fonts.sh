# Latin, Latin-1 Supplement, Latin Extended-A/B, General Punctuation, Typographic Quotes, Euro Sign
UNICODE_RANGE="U+0020-007F,U+00A0-024F,U+2000-206F,U+20AC"

find ./themes -name "*.woff2" ! -name "*.tmp.woff2" | while read -r font; do
  echo "Subsetting $font..."
  tmp="${font%.woff2}.tmp.woff2"
  pyftsubset "$font" \
    --output-file="$tmp" \
    --flavor=woff2 \
    --layout-features="*" \
    --unicodes="$UNICODE_RANGE"
  mv "$tmp" "$font"
done
