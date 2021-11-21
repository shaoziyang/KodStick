# KodStick

小巧方便的个人随身网盘系统，在 U盘、移动硬盘上运行的 [KodExplorer](https://github.com/kalcaddle/KODExplorer) / [KodBox](https://github.com/kalcaddle/kodbox)，甚至可以作为便携版软件使用。

Run [KodExplorer](https://github.com/kalcaddle/KODExplorer) / [KodBox](https://github.com/kalcaddle/kodbox) in USB stick, mobile disk, net drive, Compact and convenient personal portable network disk system, even as a portable app.


[English](#English) | [中文](#中文)



# 中文  

随身（便携）网盘系统

## 特点：

- 无需安装即可运行
- 可以在 U 盘、移动硬盘、PSSD中使用
- 支持服务器模式和便携软件模式（portable apps）
- 支持 KodExplorer 和 kodbox
- 精简系统，文件少，体积小巧，配置简单
- 64 位服务器软件，支持大文件
- 服务器软件可以升级


## 服务器软件版本

- Apache: 2.4.51, x64
- PHP: 7.4.25, x64 Thread Safe

## 服务器配置

服务器使用了标准的 apache2 和 php 软件，因此配置方法是一样的。因为是精简系统，所以需要配置的参数比较少。下面是主要参数配置说明：

### apache2

配置文件： server\conf\httpd.conf

- `Listen 8800`，Listen 后的数字是端口号，在与其它软件冲突时修改它

### php
  
配置文件： server\php\php.ini

- `opcache.cache_id=8800`，当系统中运行了多个 php 系统时，设置 opcache.cache_id 为合适数值防止互相冲突

### config.ini

KodStick 的配置参数

- max_logfile  
apache 服务器日志文件最大大小

- apache_filename  
apache服务器执行文件名，为了避免和其它apache程序混淆，可以修改为其它名称

- style  
系统区图标样式，范围是 1-5

- PortableBrowser  
指定便携模式浏览器，推荐使用 [Firefox 便携版](https://portableapps.com/apps/internet/firefox_portable) 或 [waterfox portable 便携版](https://github.com/portapps/waterfox-portable)。

- PortableBrowserparam  
便携模式浏览器的参数

- browser  
指定服务器模式下的浏览器

- param  
服务器模式浏览器的参数


## 常见问题：

- 怎样安装 KodExplorer / KodBox  
从 github 或 gitee 上下载 [KodExplorer](https://github.com/kalcaddle/KODExplorer) / [KodBox](https://github.com/kalcaddle/kodbox) 的源码，复制到 home 文件夹中

- 怎样升级 KodExplorer / KodBox  
运行服务器后，以管理员方式登录，在系统管理中进行升级。

- 是否可以使用 php8  
如果只使用KodExplorer，可以更新到 php8。如果需要使用 kodbox，暂时只能使用 php7，因为目前 kodbox 不兼容 php8（可能以后某个版本的 kodbox 会解决这个问题）。

- 是否可以在 kodbox 中使用 mysql 数据库  
KodStick 的主要目标是简单小巧、容易使用的个人随身系统，而不是高性能大数据量的专业服务器系统，因此 sqlite 已经足够了。

- 怎样升级服务器  
从 [Apache](http://httpd.apache.org/) 和 [PHP](https://www.php.net/) 官方下载软件，然后提取需要的文件，替换旧文件，并进行必要的设置。


## 使用技巧：

- 使用固定驱动器名访问软件所在的磁盘（驱动器名称可以在windows的“磁盘管理”中修改）。
- 可以使用 mklink / junction / doublecmd 等软件创建目录符号链接到 KodExplorer 的用户目录（如 **公共目录**: `data\Group\public\home\`，**用户目录**: `data\User\xxxx\home\`），方便文件访问和管理。


## 其它

- 服务器软件参考了 dokuwiki 的 [MicroApache](https://download.dokuwiki.org/)。


---
  
# English  

## Feather

- Without installation
- It can be used in USB flash disk, mobile hard disk and PSSD
- Support server mode and portable apps mode
- Supports kodexplorer and kodbox both
- Compact system, less files, small volume and simple configuration
- 64 bit server software, support large files
- The server software can be upgraded


## Server software version

- Apache: 2.4.51, x64
- PHP: 7.4.25, x64 Thread Safe

## Config

The server uses standard Apache 2 and php software, so the configuration method is the same. Because it is a thin system, few parameters need to be configured. 

### apache

configuration file: server\conf\httpd.conf

- `Listen 8800`, The number after `Listen` is the port number. Modify it in case of conflict with other software.  

### php

configuration file: server\php\php.ini

`opcache.cache_id=8800`, When multiple PHP are running in the system, set opcache.cache_id to an appropriate value to avoid conflicts.  

### config.ini

Configuration for KodStick

- max_logfile  
Maximum server log file size for apache.

- apache_filename  
The name of the Apache server execution file. It can be rename to avoid confusion with other Apache program.

- style  
Tray icon style, range is 1-5.

- PortableBrowser  
Specify the browser in portable mode, [Firefox portable](https://portableapps.com/apps/internet/firefox_portable) or [waterfox portable](https://github.com/portapps/waterfox-portable) version is recommended.

- PortableBrowserparam  
Parameters of the browser in portable mode.

- browser  
Specifies the browser in server mode.

- param  
Parameters of the browser in server mode.


## FAQ

- How to install KodExplorer / KodBox  
Download [KodExplorer](https://github.com/kalcaddle/KODExplorer) / [KodBox](https://github.com/kalcaddle/kodbox) source file github, then copy to `home` folder.

- How to upgrade KodExplorer / KodBox  
Run KodStick, login as administrator to upgrade in system management.

- Can I use php8  
If you only use kodexplorer, you can upgrade to php8. If you need to use kodbox, you can only use php7, because kodbox is not compatible with php8 (it may be work for a later version of kodbox).

- Can I use MySQL database in kodbox  
The main goal of KodStick is a simple, compact and easy-to-use personal portable system, rather than a professional high-performance server system with a large amount of data, so SQLite is enough.

- How to upgrade the server  
Download the software from [Apache](http://httpd.apache.org/) and [PHP](https://www.php.net/), then extract and replace the required files.

## Tips

- Use a fixed drive name to access the disk where the software resides (The drive name can be modified in "disk management" in Windows).
- You can use mklink / junction / doublecmd and similar software to create symbolic link to the user directories of kodexplorer (such as **public directory**: `data\group\public\home\`, **user directory**: `data\User\xxxx\home\` ), so as to facilitate file access and management.

## Other

- The server software refers to dokuwiki's [MicroApache](https://download.dokuwiki.org/)。