# apod-wallpaper

Sets the [COSMIC](https://system76.com/cosmic) desktop wallpaper to NASA's
[Astronomy Picture of the Day](https://science.nasa.gov/apod/) once a day.
Recreates the [NASA APOD Wallpaper Changer gnome extension by Elinvention](https://extensions.gnome.org/extension/1202/nasa-apod/)
for COSMIC in the form of a small script plus a systemd user timer instead 
of a desktop applet.

## How it works

1. Reads today's entry from NASA's APOD RSS feed
   (`https://science.nasa.gov/feed/apod-basic/`). If the feed fails, it falls
   back to the [APOD API](https://api.nasa.gov).
2. Downloads the full-resolution image to `~/Pictures/APOD/YYYY-MM-DD.jpg`,
   with the title, credit and explanation in a matching `.txt` file.
3. Updates the `source:` line in COSMIC's dark- and light-mode background
   configs (`~/.config/cosmic/com.system76.CosmicBackground.{Dark,Light}/v1/all`).
   All other wallpaper settings are left alone. cosmic-bg notices the change
   and switches the wallpaper without a logout.

If no image is available, the current wallpaper is kept. On video days the
feed still provides a still image.

The timer runs daily at 07:00, one minute after login, and catches up on
missed runs if the machine was off.

## Install

Requires `curl`, `jq`, `python3` and `file` (all present on Pop!_OS).

```sh
git clone git@github.com:nwgiebink/apod-wallpaper.git
cd apod-wallpaper
./install.sh
```

`install.sh` symlinks the script into `~/.local/bin` and the units into
`~/.config/systemd/user`, so edits in the repo take effect immediately.

## Usage

```sh
apod-wallpaper                                   # update now
journalctl --user -u apod-wallpaper -n 20        # recent runs
systemctl --user list-timers apod-wallpaper.timer
systemctl --user disable --now apod-wallpaper.timer   # turn off
```

### Configuration

| Setting | How |
|---|---|
| Image folder | `APOD_DIR` env var (default `~/Pictures/APOD`) |
| NASA API key | `~/.config/apod-wallpaper/api_key` or `APOD_API_KEY` env var. Optional; only the fallback uses it, and it defaults to the rate-limited `DEMO_KEY`. Get a free key at https://api.nasa.gov. |
| Schedule | `OnCalendar=` in `apod-wallpaper.timer` |

Old images are never deleted.

## Tested on

Pop!_OS 24.04 with COSMIC (cosmic-bg 1.11).
