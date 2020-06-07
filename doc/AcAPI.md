# Acfun API

## 登陆
> https://id.app.acfun.cn/rest/app/login/signin

*方式:POST*

**参数：**

| 参数名		  | 类型 | 内容        | 必要性 | 备注 |
| -------------- | ---- | ----------- | ------ | ---- |
| app_version|       | 6.19.1.907 |   		 |      |
| appMode|       | 0 |   		 |      |
| product   |       | ACFUN_APP |   		 |      |

**请求body：**
username=&password=

**回复：=拼接 非json**

| 字段    | 类型 | 内容     | 备注                        |
| ------- | ---- | -------- | --------------------------- |
| acPassToken    |   |   |  |
| acSecurity  |   |   |  |
| auth_key    |   |   |  |
| avatar        |   |   |  |
| token        |   |   |  |
| userid        |   |   |  |
| username  |   |   |  |


## 获取排行榜

> https://api-new.app.acfun.cn/rest/app/rank/channel

*方式:GET*

**参数：**

| 参数名 | 类型 | 内容        | 必要性 | 备注 |
| ------ | ---- | ----------- | ------ | ---- |
| rankPeriod    | str  | DAY | 必要   |      |
| channelId    | str  | 0 | 必要   |      |

**json回复：**

root.rankList.videoList：

| 字段    | 类型 | 内容     | 备注                        |
| ------- | ---- | -------- | --------------------------- |
| duration    | int  |    | 时长|
| videoCover    | str  |    | 封面url|
| userName    | str  |    | up主|
| createTime    | str  |    | 发布时间|
| title    | str  |    | 标题|


**示例：**
[排行榜视频json](排行榜视频.json)


