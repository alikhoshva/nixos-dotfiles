#!/usr/bin/env bash

# MODIFIED: Configuration
WALLPAPER_DIR="$HOME/Documents/wallpapers"  # Change this to your wallpaper directory
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="250"
THUMBNAIL_HEIGHT="141"
# NEW: Set your primary display output name here (find it with `wlr-randr`)
OUTPUT_DISPLAY="DP-2" 

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# MODIFIED: Thumbnail generation function to handle videos
generate_thumbnail() {
    local input="$1"
    local output="$2"
    local extension="${input##*.}"

    case "$extension" in
        # Image case
        jpg|jpeg|png)
            magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
            ;;
        # NEW: Video case
        mp4|webm|gif|mov)
            ffmpeg -i "$input" -ss 00:00:01.000 -vframes 1 -vf "scale=${THUMBNAIL_WIDTH}:-1,crop=${THUMBNAIL_WIDTH}:${THUMBNAIL_HEIGHT}" "$output" -y &> /dev/null
            ;;
    esac
}

# Create shuffle icon thumbnail on the fly (no changes here)
SHUFFLE_ICON="$CACHE_DIR/shuffle_thumbnail.png"
magick -size "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" xc:#1e1e2e \
    \( "$HOME/Documents/assets/shuffle.png" -resize "80x80" \) \
    -gravity center -composite "$SHUFFLE_ICON"

# Generate thumbnails and create menu items
generate_menu() {
    # Add random/shuffle option
    echo -en "img:$SHUFFLE_ICON\x00info:!Random Wallpaper\x1fRANDOM\n"
    
    # MODIFIED: Loop over both images and videos
    for file in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,mp4,webm,gif,mov}; do
        # Skip if no matches found
        [[ -f "$file" ]] || continue
        
        # Generate thumbnail filename (change extension to png for consistency)
        thumbnail="$CACHE_DIR/$(basename "${file%.*}").png"
        
        # Generate thumbnail if it doesn't exist or is older than source
        if [[ ! -f "$thumbnail" ]] || [[ "$file" -nt "$thumbnail" ]]; then
            generate_thumbnail "$file" "$thumbnail"
        fi
        
        # Output menu item (filename and path)
        echo -en "img:$thumbnail\x00info:$(basename "$file")\x1f$file\n"
    done
}

# Use wofi to display grid (no changes here)
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

# Set wallpaper if one was selected
if [ -n "$selected" ]; then
    
    # This logic handles the two different outputs from the generate_menu function.
    if [[ "$selected" == *"RANDOM"* ]]; then
        # If RANDOM was chosen, pick a random wallpaper from the directory
        original_path=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.mp4" -o -iname "*.webm" -o -iname "*.gif" \) | shuf -n 1)
    else
        # CORRECTED LOGIC (from your script):
        # The 'selected' variable is the full path to the thumbnail in the cache.
        # 1. Get just the filename from the cache path (e.g., "changli.png")
        thumbnail_filename=$(basename "$selected")
        
        # 2. Strip the extension to get the base name (e.g., "changli")
        base_filename="${thumbnail_filename%.*}"

        # 3. Find the original file in your wallpapers directory that matches the base name
        original_path=$(find "$WALLPAPER_DIR" -type f -name "${base_filename}.*" | head -n 1)
    fi

    # Ensure a valid wallpaper was found before proceeding
    if [ -n "$original_path" ] && [ -f "$original_path" ]; then
        
        # --- Logic to handle Image vs Video ---
        extension="${original_path##*.}"

        case "$extension" in
            # Image Types
            jpg|jpeg|png)
                # Kill any running video wallpaper
                pkill mpvpaper || true
                
                swww query || swww-daemon &
                swww img "$original_path" --transition-type center --transition-fps 60
                ;;
            # Video Types
            mp4|webm|gif|mov)
                # Kill other wallpaper daemons if needed
                pkill swww-daemon || true
                pkill mpvpaper || true
                
                # Run mpvpaper
                mpvpaper -auto-pause -o "no-audio --loop-playlist shuffle --keepaspect=no" ALL "$original_path" &
                ;;
        esac
        
        # Run pywal for both types
        wal -i "$original_path" -n -q --saturate 1.0

        # Use the thumbnail for the notification icon
        #notify-send "Wallpaper Updated" "Theme set to $(basename "$original_path")" -i "$CACHE_DIR/$(basename "${original_path%.*}").png"
    else
        notify-send "Wallpaper Script Error" "Could not find original file for: '$selected'"
    fi
fi
