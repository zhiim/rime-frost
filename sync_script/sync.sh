# !/bin/bash
# 使用inotifywait监控文件变化，并触发rclone同步

FILE_TO_WATCH="/home/xu/.local/share/fcitx5/rime/sync/lab_cachyos/user.yaml"

RCLONE_SOURCE="/home/xu/.local/share/fcitx5/rime/sync"
RCLONE_DEST="onedrive:/Apps/Rime"


if [ ! -f "$FILE_TO_WATCH" ]; then
    echo "error: file not found: $FILE_TO_WATCH"
    exit 1
fi

LAST_HASH=$(md5sum "$FILE_TO_WATCH" | awk '{print $1}')

echo "script start：start watching $FILE_TO_WATCH"
echo "init hash: $LAST_HASH"
echo "-----------------------------------------------------"

inotifywait -m -e close_write "$FILE_TO_WATCH" |
while read -r filename event; do
    CURRENT_HASH=$(md5sum "$FILE_TO_WATCH" | awk '{print $1}')

    if [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
        echo "$(date): file change detected!"
        echo "  old hash: $LAST_HASH"
        echo "  new hash: $CURRENT_HASH"
        echo "  >> syncing..."

        # must run `rclone bisync /home/xu/.local/share/fcitx5/rime/sync onedrive:/Apps/Rime --resync` first
        rclone bisync "$RCLONE_SOURCE" "$RCLONE_DEST" -v
        
        echo "  >> sync done."
        
        LAST_HASH=$CURRENT_HASH
        echo "-----------------------------------------------------"
    else
        echo "$(date): file change detected, but hash is the same. No sync needed."
        echo "-----------------------------------------------------"
    fi
done
