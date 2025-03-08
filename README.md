# nixos-img
nixos image for low ram vps

---

## 使用

1. 生成镜像，例如：

> nix build .#natvps

2. 将镜像存放在可以直链访问的地方，例如：https://file.example.com/main.raw

3. 下载DD脚本

> wget https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh

4. 运行脚本

> # bash reinstall.sh dd --password 123@@@ --web-port 8888 --img=https://file.example.com/main.raw

---

## 感激 

 - [lantian](https://lantian.pub/article/modify-computer/nixos-low-ram-vps.lantian/)
 - [qbisi](https://github.com/qbisi/nixos-images)

## 问题

`E20C`使用最新的test内核，可以启动，但在stage1无法正确挂载（waiting for device /dev/disk/by-partlabel/xxx to appear），继续挠头
