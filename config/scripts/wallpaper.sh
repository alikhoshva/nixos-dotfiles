#!/usr/bin/env bash
shopt -s nullglob nocaseglob

DIR="$HOME/Media/Wallpapers"
CACHE="$HOME/.cache/wallpaper-selector"
DIM="250x141"

mkdir -p "$CACHE"

SHUFFLE="$CACHE/shuffle.png"
[[ -f "$SHUFFLE" ]] || magick -size "$DIM" xc:#1e1e2e \
    \( "$HOME/nixos-dotfiles/config/assets/shuffle.png" -resize "80x80" \) \
    -gravity center -composite "$SHUFFLE"

menu() {
    echo -en "img:$SHUFFLE\x00info:!Random\x1fRANDOM\n"
    for f in "$DIR"/*.{jpg,jpeg,png}; do
        t="$CACHE/$(basename "${f%.*}").png"
        [[ -f "$t" && "$t" -nt "$f" ]] || magick "$f" -thumbnail "$DIM^" -gravity center -extent "$DIM" "$t"
        echo -en "img:$t\x00info:$(basename "$f")\x1f$f\n"
    done
}

sel=$(menu | wofi --show dmenu \
    -c ~/.config/wofi/wallpaper.conf \
    -s ~/.config/wofi/wallpaper.css \
    --define "image-size=$DIM" \
    --cache-file /dev/null \
    --sort-order=default \
    --columns 3 --allow-images --insensitive \
    --prompt "Select Wallpaper")

[[ -z "$sel" ]] && exit 0

if [[ "${sel^^}" == *"RANDOM"* ]] || [[ "$sel" == *"shuffle"* ]]; then
    files=("$DIR"/*.{jpg,jpeg,png})
    bg="${files[RANDOM % ${#files[@]}]}"
else
    base=$(basename "$sel")
    files=("$DIR"/${base%.*}.*)
    bg="${files[0]}"
fi

if [[ -f "$bg" ]]; then
    awww query || awww-daemon &
    awww img "$bg" --transition-type center --transition-fps 60
    wal -i "$bg" -n -q --saturate 1.0
else
    notify-send "Error" "Wallpaper missing: $sel"
fi
