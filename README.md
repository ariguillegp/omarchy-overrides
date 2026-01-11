# omarchy-overrides

Personal config overrides for [Omarchy](https://omarchy.org/) that persist across system updates.

## Why?

Omarchy updates can overwrite files in `~/.config/`. This repo stores custom configurations so they can be easily restored after an update.

## Usage

```bash
# After editing configs in ~/.config/ - save them to this repo
./overrides sync

# After an omarchy update overwrites your configs - restore them
./overrides restore

# Show help
./overrides help
```

After syncing, commit and push your changes:
```bash
git add -A && git commit -m "Update configs" && git push
```

## Tracked Configs

| Name | Repo Directory | Config Location |
|------|----------------|-----------------|
| hypr | `./hypr/` | `~/.config/hypr/` |
| ghostty | `./ghostty/` | `~/.config/ghostty/` |

## Adding New Configs

Edit the `CONFIGS` array in the `overrides` script:

```bash
CONFIGS=(
    "hypr:hypr:hypr"
    "ghostty:ghostty:ghostty"
    "waybar:waybar:waybar"  # <- add new entries like this
)
```

Format: `"display_name:repo_subdir:config_subdir"`

Then sync to pull in the new config files:
```bash
./overrides sync
git add -A && git commit -m "Add waybar config" && git push
```

## Setup on a New Machine

```bash
cd ~/.config
git clone git@github.com:ariguillegp/omarchy-overrides.git
cd omarchy-overrides
./overrides restore
```
