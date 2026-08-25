# ofenbau-innung.de

## Development

Enter the dev shell to get Hugo on your path and run the development server:

```sh
nix develop
hugo server
```

## Test production build

To test the site with production settings locally:

```sh
hugo server --environment production
```

## Format

Format all source files (Nix, HTML templates, CSS, JS, YAML, JSON, TOML, shell):

```sh
nix fmt
```

## Build

Build the static site using nix:

```sh
nix build
```

## Subset fonts

Font files in `themes/ofenbau-innung-theme/static/fonts/` are subsetted to the
Latin Unicode ranges needed for German text. Run this after replacing or updating
any font file:

```sh
nix run .#subset-fonts
```

Run this from the repository root. The script rewrites each `.woff2` file in place,
stripping glyphs outside of the Latin character ranges.

## Geocode members

`data/member_coords.json` maps each entry in `data/members.yaml` to GPS coordinates
used by the interactive map. Regenerate it after adding or changing member addresses:

```sh
nix run .#geocode-members
```

Run this from the repository root. The script queries Nominatim (OpenStreetMap) for
each address and writes the result to `data/member_coords.json`.
