# !/bin/bash
# 使用inotifywait监控文件变化，并触发rclone同步

inotifywait -m -e close_write /home/xu/.local/share/fcitx5/rime/sync/lab_cachyos/user.yaml |
while read -r filename event ; do
    rclone sync /home/xu/.local/share/fcitx5/rime/sync onedrive:/Apps/Rime -v
    echo "$(date): Synced due to $event on $filename"
    sleep 1
done
