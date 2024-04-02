# Steam Deck Samba Server

在 Steam Deck 上一键安装并设置 Samba 服务器，以便通过其他设备访问或传输文件至 Steam Deck 中。


## 安装

在你的 Steam Deck 终端上运行该脚本：

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/mikusaa/steamdeck-samba-server/main/script.sh)"
```

或者，你想直接共享 `deck` 用户主文件夹，换用以下脚本：

> 这样将直接暴露整个用户文件夹，因此请设置稍微复杂一些的密码！

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/mikusaa/steamdeck-samba-server/main/script-home.sh)"
```

之后会自动下载并运行脚本文件，根据提示操作。

## 使用

安装 Samba 服务器后，您可以从同一网络上的任何设备连接到它。只需在计算机上打开文件资源管理器窗口，然后在地址栏中键入以下内容：

```
\\steamdeck
```

系统会提示输入 Steam Deck 用户名和密码。用户名即为 `deck`，密码为执行脚本过程中设置的密码。

完成此操作后，即可在电脑上访问 Steam Deck 上的文件。

## 贡献

该脚本基于 [malordin](https://github.com/malordin/steamdeck-samba-server) 项目进行修改。

## 许可

该脚本已根据 [MIT 许可证](https://github.com/mikusaa/steamdeck-samba-server/blob/main/LICENSE) 获得许可。您可以根据需要随意使用、修改和分发它。