#!/bin/bash


RED="31"
GREEN="32"
BOLDGREEN="\e[1;${GREEN}m"
ITALICRED="\e[3;${RED}m"
ENDCOLOR="\e[0m"



if [ "$1" = "gui" ]; then
  # Script is running with a GUI argument (icon)
  if zenity --question --width=400 --height=100 --text="该脚本将在您的系统上安装 Samba 服务器。 你是通过passwd修改密码的吗？"; then
    # User answered "yes" or "Y" or "y"
    password=$(zenity --password --title="输入您的密码")
    echo "$password" | sudo -S echo "Samba 服务器安装中..."
  else
    # User answered "no" or "N" or "n"
    zenity --error --width=400 --height=100 --text="该脚本需要您的密码才能正常工作。 请通过 passwd 更改您的密码，然后重试。"
    exit 1
  fi
else
  # Script is running without a GUI argument (console)
  echo "警告：此脚本将在您的 Steam Dek 系统上安装 Samba 服务器。"
  read -p "你是通过passwd修改密码的吗？ [Y/N] " password_choice

  case "$password_choice" in
    y|Y ) # User answered "yes" or "Y" or "y"
          read -s -p "请输入您的密码（密码不会显示）：" password
          echo "$password" | sudo -S echo "Samba 服务器安装中..." ;;
    n|N ) # User answered "no" or "N" or "n"
          echo "该脚本需要您的密码才能正常工作。 请通过 passwd 更改您的密码，然后重试。"
          exit 1 ;;
    * )   # User provided an invalid choice
          echo "选择无效，正在中止脚本。" && exit 1 ;;
  esac
fi



# Check if "deck" user's password has been changed
if [ "$(sudo grep '^deck:' /etc/shadow | cut -d':' -f2)" = "*" ] || [ "$(sudo grep '^deck:' /etc/shadow | cut -d':' -f2)" = "!" ]; then
    # Prompt user to change "deck" user's password
    echo "您似乎尚未更改 “deck” 用户的密码。"
    read -p "您现在想更改吗？ (y/n) " choice
    if [ "$choice" = "y" ]; then
        sudo passwd deck
    fi
fi

# Disable steamos-readonly
echo "禁用 steamos-readonly 只读模式中..."
sudo steamos-readonly disable

# Edit pacman.conf file
echo "编辑 pacman.conf 文件..."
sudo sed -i '/^SigLevel[[:space:]]*=[[:space:]]*Required DatabaseOptional/s/^/#/' /etc/pacman.conf
sudo sed -i '/^#SigLevel[[:space:]]*=[[:space:]]*Required DatabaseOptional/a\
SigLevel = TrustAll\
' /etc/pacman.conf

# Initialize pacman keys
echo "安装 pacman 密钥..."
sudo pacman-key --init

# Populate pacman keys
echo "填充 pacman keys..."
sudo pacman-key --populate archlinux



# Install samba
echo "安装 samba..."
sudo pacman -Sy --noconfirm samba

# Write new smb.conf file
echo "写入 smb.conf 配置..."
sudo tee /etc/samba/smb.conf > /dev/null <<EOF
[global]
netbios name = steamdeck

[steamapps]
comment = Steam apps directory
path = /home/deck/.local/share/Steam/steamapps/
browseable = yes
read only = no
create mask = 0777
directory mask = 0777
force user = deck
force group = deck

[documents]
comment = Documents directory
path = /home/deck/Documents/
browseable = yes
read only = no
create mask = 0777
directory mask = 0777
force user = deck
force group = deck

[pictures]
comment = Pictures directory
path = /home/deck/Pictures/
browseable = yes
read only = no
create mask = 0777
directory mask = 0777
force user = deck
force group = deck

[downloads]
comment = Downloads directory
path = /home/deck/Downloads/
browseable = yes
read only = no
create mask = 0777
directory mask = 0777
force user = deck
force group = deck

[mmcblk0p1]
comment = Steam apps directory on SD card
path = /run/media/mmcblk0p1/
browseable = yes
read only = no
create mask = 0777
directory mask = 0777
force user = deck
force group = deck
EOF


echo "添加 'deck' 用户至 samba 用户数据库中..."
if [ "$1" = "gui" ]; then
    password=$(zenity --password --title "Set Samba Password" --width=400)
    (echo "$password"; echo "$password") | sudo smbpasswd -s -a deck
else
    sudo smbpasswd -a deck
fi

# Enable and start smb service
echo "启用并启动 smb 服务中..."
sudo systemctl enable smb.service
sudo systemctl start smb.service

firewall-cmd --permanent --zone=public --add-service=samba
firewall-cmd --reload


# Restart smb service
echo "重启 smb 服务..."
sudo systemctl restart smb.service

# re-enable the readonly filesystem
sudo steamos-readonly enable
echo "文件系统现已恢复为只读模式"


if [ "$1" = "gui" ]; then
  zenity --info --width=400 --height=100 --text="Samba server 已成功安装！现在你可以从本地网络上的任何设备中访问您 Steam Deck 上的 steamapps、downloads、pictures、documents 以及 mmcblk0p1 文件夹。"
  else 
    echo -e "${BOLDGREEN}Samba server 已成功安装！${ENDCOLOR}现在你可以从本地网络上的任何设备中访问您 Steam Deck 上的 steamapps、downloads、pictures、documents 以及 mmcblk0p1 文件夹。"
    read -p "按任意键继续..." 
fi

      
