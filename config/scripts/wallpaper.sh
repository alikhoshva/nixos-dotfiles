#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Media/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="250"
THUMBNAIL_HEIGHT="141"

mkdir -p "$CACHE_DIR"

generate_thumbnail() {
    local input="$1"
    local output="$2"
    magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
}

SHUFFLE_ICON="$CACHE_DIR/shuffle_thumbnail.png"
if [[ ! -f "$SHUFFLE_ICON" ]]; then
    magick -size "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" xc:#1e1e2e \
        \( "$HOME/nixos-dotfiles/config/assets/shuffle.png" -resize "80x80" \) \
        -gravity center -composite "$SHUFFLE_ICON"
fi

generate_menu() {
    echo -en "img:$SHUFFLE_ICON\x00info:!Random Wallpaper\x1fRANDOM\n"
    
    for file in "$WALLPAPER_DIR"/*.{jpg,jpeg,png}; do
        [[ -f "$file" ]] || continue
        
        thumbnail="$CACHE_DIR/$(basename "${file%.*}").png"
        
        if [[ ! -f "$thumbnail" ]] || [[ "$file" -nt "$thumbnail" ]]; then
            generate_thumbnail "$file" "$thumbnail"
        fi
        
        echo -en "img:$thumbnail\x00info:$(basename "$file")\x1f$file\n"
    done
}

selected=$(generate_menu | wofi --show dmenu \
    --cache-file /dev/null \
    --define "image-size=${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" \
    --columns 3 \
    --allow-images \
    --insensitive \
    --sort-order=default \
    --prompt "Select Wallpaper" \
    --conf ~/.config/wofi/wallpaper.conf \
    --style ~/.config/wofi/wallpaper.css \
)

if [ -n "$selected" ]; then
    if [[ "$selected" == *"RANDOM"* ]]; then
        original_path=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)
    else
        thumbnail_filename=$(basename "$selected")
        base_filename="${thumbnail_filename%.*}"
        original_path=$(find "$WALLPAPER_DIR" -type f -name "${base_filename}.*" | head -n 1)
    fi

    if [ -n "$original_path" ] && [ -f "$original_path" ]; then
        awww query || awww-daemon &
        awww img "$original_path" --transition-type center --transition-fps 60
        
        wal -i "$original_path" -n -q --saturate 1.0
    else
        notify-send "Wallpaper Script Error" "Could not find original file for: '$selected'"
    fi
fi
