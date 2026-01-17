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

## Adding New Configs

Edit the `CONFIGS` array in the `overrides` script. The format supports both directories and individual files:

```bash
CONFIGS=(
    "waybar:waybar:waybar"                 # directory: ~/.config/waybar/ <-> ./waybar/
    "AGENTS.md:AGENTS.md:AGENTS.md:file"   # file: ~/.config/AGENTS.md <-> ./AGENTS.md
)
```

Format: `"display_name:repo_path:config_path[:type]"`

- `type` is optional and defaults to `dir`. Use `file` for individual files.

Then sync to pull in the new config files:

```bash
./overrides sync
```

## Removing Configs

When you remove an entry from the `CONFIGS` array, the corresponding files in this repo are **not automatically deleted**. You must manually remove them with `git rm` if you no longer want to track them.

## Setup on a New Machine

```bash
cd ~/.config
git clone git@github.com:ariguillegp/omarchy-overrides.git
cd omarchy-overrides
./overrides restore
```
