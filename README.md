# Steam Deck Samba Server

这是一个简单的脚本，可在您的 Steam Deck 上设置 Samba 服务器，使您可以轻松地将文件传输到设备或从设备传输文件。


## 安装

在你的 Steam Deck 终端上运行该脚本，自动在你的 Steam Deck 上安装并配置 Samba 服务：

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/mikusaa/steamdeck-samba-server/main/script.sh)"
```

或者，你想直接挂载 `deck` 用户主文件夹，换用以下脚本：

> 这样直接暴露整个用户文件夹，因此请设置稍微复杂一些的密码！

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/mikusaa/steamdeck-samba-server/main/script-home.sh)"
```

之后会自动下载并运行脚本文件，根据提示操作。

## 使用

安装 Samba 服务器后，您可以从同一网络上的任何设备连接到它。 只需在计算机上打开文件资源管理器窗口，然后在地址栏中键入以下内容：

```
\\steamdeck
```

然后系统会提示输入 Steam Deck 用户名和密码。完成此操作后，您将能够像访问任何其他共享文件夹一样访问 Steam Deck 上的文件。

## 贡献

该脚本基于 [malordin](https://github.com/malordin/steamdeck-samba-server) 项目进行修改。

## 许可

该脚本已根据 [MIT 许可证](https://github.com/malordin/steamdeck-samba-server/blob/main/LICENSE) 获得许可。您可以根据需要随意使用、修改和分发它。