# omarchy-overrides

Personal config overrides for [Omarchy](https://omarchy.org/) that persist across system updates, stored under `configs/` with mirrored absolute paths.

## Why?

Omarchy updates can overwrite files in `~/.config/`. This repo stores custom configurations by mirroring absolute paths under `configs/` so they can be easily restored after an update.

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
- Restore creates automatic backups in `~/.config/.overrides-backup/` (mirrored absolute paths)
- Restore requires confirmation (use `--force` to skip)
- Refuses to run as root
- Validates config entries to prevent path traversal
- Preserves symlinks instead of copying targets

## Adding New Configs

Edit the `CONFIGS` array in the `overrides` script. The format supports directories, files, and symlinks using absolute paths:

```bash
CONFIGS=(
    "$HOME/.config/waybar"    # configs/home/user/.config/waybar/
    "$HOME/.config/AGENTS.md" # configs/home/user/.config/AGENTS.md (symlink preserved)
)
```

Each absolute path is mirrored under `configs/` in the repo. Restore writes back to the original absolute path.

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
