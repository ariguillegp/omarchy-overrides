# omarchy-overrides

Personal config overrides for [Omarchy](https://omarchy.org/) that persist across system updates.

## Why?

Omarchy updates can overwrite files in `~/.config/`. This repo stores custom configurations so they can be easily restored after an update.

## Usage

```bash
# After editing configs in ~/.config/ - save them to this repo
./overrides sync

# Preview what would be synced (no changes made)
./overrides sync --dry-run

# After an omarchy update overwrites your configs - restore them
./overrides restore

# Restore without confirmation prompt
./overrides restore --force

# Preview what would be restored (no changes made)
./overrides restore --dry-run

# Show help
./overrides help
```

**Safety features:**
- Restore creates automatic backups in `~/.config/.overrides-backup/`
- Restore requires confirmation (use `--force` to skip)
- Refuses to run as root
- Validates config entries to prevent path traversal

## Adding New Configs

Edit the `CONFIGS` array in the `overrides` script. The format supports both directories and individual files:

```bash
CONFIGS=(
    "waybar"    # ~/.config/waybar/ <-> .config/waybar/
    "AGENTS.md" # ~/.config/AGENTS.md <-> .config/AGENTS.md
)
```

Path is relative to `~/.config/` (source) and `.config/` in the repo (destination). Works for both files and directories.

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
