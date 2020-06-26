# Acfun API

## 请求通用Header

| key    | value     | 备注     |
| -------| -------- | -------- |
| User-agent| acvideo core/6.24.1.958(OPPO;OPPO A83;7.1.1) |  |
| acPlatform| ANDROID_PHONE |  |
| deviceType| 1|  |
|Content-Type | application/x-www-form-urlencoded |  |
| net| WIFI |  |
| productId| 2000 |  |
| udid| be0088b8-1ae1-341d-b31e-bed8e78e2325 |  |
|resolution | 1080x1920 |  |
|market | tencent |  |
|appVersion | 6.24.1.958 | 弹幕请求不能带 |

## 请求通用Query

| key    | value     | 备注     |
| -------| -------- | -------- |
| product| ACFUN_APP |  |
| app_version| 6.24.1.958 |  |


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


## 发弹幕（需要token 参考签到状态）
> https://api-new.acfunchina.com/rest/app/new-danmaku/add

*方式:POST*

**请求body：**
格式： key=value&key2=value2

| key    | 类型 | value     | 备注     |
| ------- | ---- | -------- | -------- |
|body   |      |   弹幕内容   |  需要encodeURIComponent|
|videoId   |      |  11626279  |分P的视频videoList-id|
|position   |      |  10294  |  视频进度毫秒  |
|mode   |      |  1   |  1:滚动  4:底部  5:顶部 |
|size   |      |  18   |  25/18  |
|color   |  RGB十进制  |  16777215  |    |
|type   |      |  douga  |    |
|id   |      |  视频Ac号contentId|    |
|subChannelId   |      |  190  |    |
|subChannelName   |      |    |  留空  |

**json回复：**
```json
{
	"result": 0,
	"danmakuId": 177859644,
	"host-name": "hb2-acfun-kcs308.aliyun"
}
```

## 投稿列表（需要token）
POST api-new.acfunchina.com/rest/app/user/resource/query

url参数
count=20&authorId=923834&resourceType=2&sortType=3&status=0&pcursor=0

**返回示例：**
[已投稿件json](已投稿件.json)

## 收藏视频（需要token）
POST https://api-new.app.acfun.cn/rest/app/favorite

**请求body：**
resourceId=16381485&resourceType=9

**返回示例：**
{"result":0,"host-name":"hb2-acfun-kcs030.aliyun"}

## 取消收藏视频（需要token）
POST https://api-new.app.acfun.cn/rest/app/unFavorite

**请求body：**
resourceIds=16381485&resourceType=9

**返回示例：**
{"result":0,"host-name":"hb2-acfun-kcs030.aliyun"}

## 投香蕉（需要token）
POST https://api-new.app.acfun.cn/rest/app/banana/throwBanana

**请求body：**
resourceId=16381485&resourceType=2&count=5

**返回示例：**

```json
{
	"result": 0,
	"extData": {
		"bananaRealCount": 5,
		"criticalHitInfo": null
	},
	"host-name": "hb2-acfun-kcs030.aliyun"
}
```

## 关注/取关用户（需要token）
POST https://api-new.app.acfun.cn/rest/app/relation/follow

**请求body：**

关注
action=1&groupId=0&toUserId=923834

取关
action=2&groupId=0&toUserId=923834

**返回示例：**
{"result":0,"host-name":"hb2-acfun-kcs030.aliyun"}

## 分区列表
POST https://api-new.app.acfun.cn/rest/app/channel/allChannels

**返回示例：**
[分区列表.json](分区列表.json)

## 分区视频
GET https://apipc.app.acfun.cn/v3/regions

**请求param：**
channelId=60&size=10

**返回示例：**
[娱乐分区视频.json](娱乐分区视频.json)


## AC号获取视频详情
GET https://api-new.app.acfun.cn/rest/app/douga/info

**请求param：**
dougaId=16310505&mkey=AAHewK3eIAAyMjAxNTc5ODYAAhAAMEP1uwQwBOwDYAAAAH76xZVviL8Tcpx8HscLNFRwnGQA6_eLEvGiajzUp4_YthxOPC-hxcOpTk0SPSrxyhbdkmIwsXnF9PgS5ly8eQyjuXlcS7VpWG0QlK0HakVDamteMHNHIui0A8V4tmELqQ%3D%3D
