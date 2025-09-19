# !/bin/bash
# 使用inotifywait监控文件变化，并出发rclone同步

inotifywait -m -e close_write /home/xu/.local/share/fcitx5/rime/sync/lab_cachyos/user.yaml |
while read -r filename event ; do
    # 2. 只在文件实际变化时同步
    rclone sync /home/xu/.local/share/fcitx5/rime/sync onedrive:/Apps/Rime -v
    # 3. 加日志
    echo "$(date): Synced due to $event on $filename"
    sleep 30
done
