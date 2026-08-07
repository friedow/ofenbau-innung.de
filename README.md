# ofenbau-innung.info

## Geocode members

`data/member_coords.json` maps each entry in `data/members.yaml` to GPS coordinates
used by the interactive map. Regenerate it after adding or changing member addresses:

```sh
nix run .#geocode-members
```

Run this from the repository root. The script queries Nominatim (OpenStreetMap) for
each address and writes the result to `data/member_coords.json`.
