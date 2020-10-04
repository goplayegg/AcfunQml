# Acfun API

##抓包简单说明

可以直接网页抓包。不过我觉得实现桌面客户端的api使用场景可能跟手机app客户端的api接近点。所以基本是抓app的。
**Fiddler** 抓安卓移动端 AcFun APP 的包
下载安卓模拟器, **最好是安卓5.1.1**版本（安卓版本太高不支持信任三方证书），我是用的逍遥模拟器的逍遥多开器。按百度教程把Fiddle里的**证书导入到安卓**系统里就行了。安卓系统wifi里长按设置代理为fiddle



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
| rankPeriod    | str  | DAY/THREE_DAYS/WEEK | 必要   |      |
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


## 发评论
POST https://api-new.acfunchina.com/rest/app/comment/add

sourceId=16184205&sourceType=3&content=评论内容UrlEncode编码&replyToCommentId=259679422&syncToMoment=0&access_token=**************

**返回示例：**
[评论后的服务端返回.json](评论后的服务端返回.json)

## 获取分区最新投稿
GET  https://apipc.app.acfun.cn/v3/regions/new/60?pageSize=10&pageNo=2

**返回示例：**
[分区新投稿.json](分区新投稿.json)

## 新秀榜
POST https://api-new.acfunchina.com/rest/app/rank/youngStar

**请求body：**
rankPeriod=DAY

**返回示例：**
[上升榜 香蕉榜 新秀榜.json](上升榜 香蕉榜 新秀榜.json)

## 上升榜
POST https://api-new.acfunchina.com/rest/app/rank/fastRise

## 香蕉榜
GET https://api-new.acfunchina.com/rest/app/rank/banana?rankPeriod=DAY

## 精准选择
GET https://api-new.acfunchina.com/rest/app/feedback/getNegativeReasons

{"result":0,"reasons":[{"reasonMsg":"封面标题引起不适","reasonId":"1"},{"reasonMsg":"低俗","reasonId":"2"},{"reasonMsg":"已经看过","reasonId":"3"},{"reasonMsg":"不喜欢这个视频","reasonId":"4"},{"reasonMsg":"不喜欢同类内容","reasonId":"5"},{"reasonMsg":"不喜欢UP主","reasonId":"6"}],"host-name":"hb2-acfun-kcs327.aliyun"}

## 搜索建议
GET https://api-new.acfunchina.com/rest/app/search/recommend

{"result":0,"host-name":"hb2-acfun-kcs205.aliyun","searchKeywords":[{"groupId":"OTIzODM0XzE1OTk5ODEzMTk0NjBfOTQ0NQ_1","rank":1,"isHot":true,"keyword":"高级弹幕"},{"groupId":"OTIzODM0XzE1OTk5ODEzMTk0NjBfOTQ0NQ_2","rank":2,"isHot":true,"keyword":"租借女友"},{"groupId":"OTIzODM0XzE1OTk5ODEzMTk0NjBfOTQ0NQ_3","rank":3,"isHot":false,"keyword":"瑞克和莫蒂"},{"groupId":"OTIzODM0XzE1OTk5ODEzMTk0NjBfOTQ0NQ_4","rank":4,"isHot":false,"keyword":"教师节"},{"groupId":"OTIzODM0XzE1OTk5ODEzMTk0NjBfOTQ0NQ_5","rank":5,"isHot":false,"keyword":"奥特曼"}]}

## 搜索“高级弹幕”
GET  https://api-new.acfunchina.com/rest/app/search/complex?keyword=%E9%AB%98%E7%BA%A7%E5%BC%B9%E5%B9%95&requestId=&pCursor=0&mkey=AAHewK3eIAAyMTkwNTkwNzUAAhAAMEP1uwQALBDiYAAAAMdu1yURgB5jZd_QsBgnOk1wnGQA6_eLEvGiajzUp4_YnU8EjTm7gzNYhBv59oCCDhbdkmIwsXnF9PgS5ly8eQyjuXlcS7VpWG0QlK0HakVDamteMHNHIui0A8V4tmELqQ%3D%3D

**返回示例：**
[搜索无常猴.json](搜索无常猴.json)

## Token请求
POST https://id.app.acfun.cn/rest/app/token/get

body:
sid=acfun.midground.api

result:
{
	"result": 0,
	"ssecurity": "5l9fkG\*\*\*\*wBckN5vQ==",
	"userId": 923834,
	"acfun.midground.api_st": "\*\*\*\*\*",
	"acfun.midground.api.at": "\*\*\*\*\*"
}

## 首页轮播+日刊(这个接口请求会失败 原因未知)
POST https://api-new.acfunchina.com/rest/app/selection/feed

**请求body：**
mkey=AAHewK3eIAAyMTkwNTExNzYAAhAAMEP1uwSZbohCYAAAAJlXIdNAMQR5fM2F-KEOYN5wnGQA6_eLEvGiajzUp4_YnU8EjTm7gzNYhBv59oCCDhbdkmIwsXnF9PgS5ly8eQyjuXlcS7VpWG0QlK0HakVDamteMHNHIui0A8V4tmELqQ%3D%3D&pcursor=&count=20

**返回示例：**
[首页轮播日刊.json](首页轮播日刊.json)

## 用户信息
GET https://api-new.app.acfun.cn/rest/app/user/userInfo?userId=923834

**返回示例：**
[用户信息.json](用户信息.json)

## 是否关注用户
GET https://api-new.app.acfun.cn/rest/app/relation/isFollowing?toUserIds=923834

**返回示例：**
{"result":0,"followingStatus":{"10506739":2},"host-name":"hb2-acfun-kcs263.aliyun","isBlocking":{"10506739":false},"isFollowings":{"10506739":true}}

## 用户动态
GET https://api-new.app.acfun.cn/rest/app/feed/profile?pcursor=0&userId=10506739&count=10&mkey=

去掉Header里的acPlatform ANDROID_PHONE

**返回示例：**
[动态.json](动态.json)

## 用户投稿 resourceType: 2视频 3文章 10动态
POST https://api-new.app.acfun.cn/rest/app/user/resource/query?count=20&authorId=10506739&resourceType=2&sortType=3&status=1&pcursor=0

**返回示例：**
[用户视频.json](用户视频.json)
[用户文章.json](用户文章.json)

## 个人动态(关注的up的动态)
GET https://api-new.acfunchina.com/rest/app/feed/followFeedV2

**请求param：**
resourceType=0
pcursor 
count 

Header里需要appVersion

## 动态详情
GET https://api-new.acfunchina.com/rest/app/moment/detail?momentId=746044

**返回示例：**
[动态详情.json](动态详情.json)

## 评论列表
GET https://api-new.acfunchina.com/rest/app/comment/list?sourceId=746044&sourceType=4&pcursor=0&count=20&showHotComments=1&app_version=6.26.0.966

sourceType:  1-文章评论 3-视频评论  4-动态的评论

**返回示例：**
[评论列表.json](评论列表.json)