#!/usr/bin/env bash
# Link apod-wallpaper into place and enable the daily systemd user timer.
# Run again after pulling changes; it is safe to re-run.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
bin="$HOME/.local/bin"
units="$HOME/.config/systemd/user"

for dep in curl jq python3 file; do
  command -v "$dep" >/dev/null || { echo "missing dependency: $dep" >&2; exit 1; }
done

mkdir -p "$bin" "$units"
chmod +x "$here/apod-wallpaper"
ln -sfn "$here/apod-wallpaper" "$bin/apod-wallpaper"
ln -sfn "$here/apod-wallpaper.service" "$units/apod-wallpaper.service"
ln -sfn "$here/apod-wallpaper.timer" "$units/apod-wallpaper.timer"

systemctl --user daemon-reload
systemctl --user enable --now apod-wallpaper.timer
echo "Installed. Run 'apod-wallpaper' to update now, or wait for the timer:"
systemctl --user list-timers apod-wallpaper.timer --no-pager | head -2
