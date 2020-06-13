# Introduction
AcfunQml  is a thirdparty desktop App of Acfun Video & Danmaku wibsite,  build on Qt 5 & Qt Quick 2.x (Qml) & QmlVlc (based on libvlc)

# Features
- Login Acfun and show basic user infomation
- Load Acfun Top Rank
- Video
  - pause
  - speed 1.0/1.5/2.0
  - jump position (not work somtimes)
  - fullScreen
- Danmaku
  - fly
  - top
  - bottom
  - pause
  - send danmaku (with problems)
- Comment
  - show comment (TODO)
  - send comment (with problems)
- Index Page Video List (TODO)
- Video Search (TODO)
- Setting
  - Hard decode (with problems)
  - Language change
  - Skin change (TODO)

# 遇到的问题
- 登陆后获取到一些认证信息 acPassToken acSecurity等， 但使用这些作为Cookies 无法成功请求用户详情，发送弹幕等需要用户认证的api， 可能是因为请求少了一个时刻在变的token字段。（从Ac手机客户端抓包发现token一直变化，应该是跟请求时间戳有关的一个加密令牌，目前不知道规则，很多功能无法实现）

- 硬解码不生效
- 启动慢 appIcon 字符串几千个太多没用到

# ScreenShots

![shot](./screenshots/mainpage.jpg)

# Requirements
- Qt 5.12.0 or later
- Qt Quick 2.0 or later
- Libvlc 3.0 or later

# Build
- Download libvlc library (http://ftp.gnome.org/mirror/videolan.org/vlc/last/)
- Build QmlVlc (https://github.com/baoyuanle/QmlVlc)

- Windows:
  - unzip if you download zip package, install if you download the execute package.
  
  - copy `lib` and `include` folder to `3rdparty/vlc/`.
    - declare `typedef __int64 ssize_t;` in `vlc.h` file if you compile on x64.
    - ~~change `#include <vlc/xxx.h>` to `#include <xxx.h>`(remove `vlc/`) if could not find header files.~~
  - copy dynamic link library (dll) files and `plugins` to `{project}/bin` path (the build path)
  
  	Folder tree like:
    ```
      AcfunQml
    	|
    	+--bin
    	|  |
    	|   +--plugins
    	|   +--QmlVlc
    	|  |
		|  |   +--qmldir
		|  |   +--QmlVlcPlugin.dll
		|  |
    	|   +--libvlc.dll
    	|   +--libvlccore.dll
    	|   +--ssleay32.dll
    	|   +--libeay32.dll
    	|   +--acfunqml.exe
    	|
    	+--src
    	+--AcfunQml.pro
    ```
  - make ts / qm (translation files)
    - goto \src\trans
	- fix your lupdatePath in trans_update.bat and run
	- run Trans.bat(可选，很慢，自行决定，免费翻译API限制每秒1次翻译请求)(https://github.com/jaredtao/Transer)
	- fix your lreleasePath in trans_release.bat and run
	
  - open the `AcfunQml.pro` with Qt Creator
  
  - build and run

- Mac:
  > TODO

- Linux:
  > TODO


## 
> Copyright &copy;  baoyuanle Under the [DBAD LICENSE](LICENSE.md)
##
> The project dependent on some other opensource project , see [LICENSES_third](LICENSE_third.md)

<img src="https://github.com/baoyuanle/blog/blob/master/res/like.jpg" width="200">