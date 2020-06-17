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

| 返回字段    | 类型 | 对应填到Cookie里的字段     | 备注                        |
| ------- | ---- | -------- | --------------------------- |
| acPass**T**oken    |   | acPass**t**oken |  |
| acSecurity  |   | acSecurity |  |
| auth_key    |   | auth_key |  |
| avatar        |   |   |  |
| token        |   | old_token |  |
| userid        |   | user**I**d |  |
| username  |   |   |  |

## 签到状态（需要Cookie里带各种token）
> https://api-new.acfunchina.com/rest/app/user/hasSignedIn

*方式:POST*

**Cookie示例，特别注意大小写**

auth_key=000;user**I**d=000;acPass**t**oken=xxxx;acSecurity=yyyy;old_token=wwww

**请求body：**
access_token=登陆返回的token

**json回复：**
```json
{
	"result": 0,
	"msg": "已连续签到1天",
	"hasSignedIn": false,
	"cumulativeDays": 562,
	"continuousGuideMsg": "凭本事签到得香蕉，还有机会测运势！",
	"host-name": "hb2-acfun-kcs154.aliyun",
	"continuousDays": 1
}
```

## 获取个人信息

> https://api-new.acfunchina.com/rest/app/user/personalInfo

*方式:GET*

**返回示例：**
[个人信息json](个人信息.json)

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


**返回示例：**
[排行榜视频json](排行榜视频.json)


