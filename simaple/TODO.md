# TODO

## 我的目标

- 实现“显示器连接状态监控”。
- 每 1 秒检测一次。
- 日志写入桌面文件 `monitor-status.log`。
- 首次运行必须写入初始记录。
- 仅在显示器状态/数量变化时写入新日志。

- [ ] 每 1 秒检测一次显示器总数（`SysGet, MonitorCount, MonitorCount`）。
- [ ] 日志文件固定写到桌面：`monitor-status.log`。
- [ ] 第一次运行时，必须写入一条初始日志（`INITIAL`）。
- [ ] 之后只有显示器状态/数量变化时才写日志（`CHANGED`）。
- [ ] 日志格式：
      `yyyy-MM-dd HH:mm:ss | EVENT | monitors=<n> | external=<connected|disconnected>`
