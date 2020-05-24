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

**示例：**



## 获取视频评论

> http://api.bilibili.com/x/space/upstat

*方式:GET*

**参数：**

| 参数名 | 类型 | 内容        | 必要性 | 备注 |
| ------ | ---- | ----------- | ------ | ---- |
| mid    | url  | 目标用户UID | 必要   |      |

**json回复：**

根对象：

| 字段    | 类型 | 内容     | 备注                        |
| ------- | ---- | -------- | --------------------------- |
| code    | num  | 返回值   | 0：成功<br />-400：请求错误 |
| message | str  | 错误信息 | 默认为0                     |
| ttl     | num  | 1        | 作用尚不明确                |
| data    | obj  | 信息本体 |                             |

`data`对象：

| 字段    | 类型  | 内容       | 备注  |
| ------- | ----- | ---------- | ----- |
| archive | obj   | 视频播放量 |       |
| article | obj   | 专栏阅读量 |       |
| likes   | num   | 获赞次数   |       |

`data`中的`archive`对象：

| 字段 | 类型  | 内容       | 备注  |
| ---- | ----- | ---------- | ----- |
| view | num   | 视频播放量 |       |

**示例：**

查询用户`UID=456664753`的UP主状态数

http://api.bilibili.com/x/space/upstat?mid=456664753
```json
{
	"code": 0,
	"message": "0",
	"ttl": 1,
	"data": {
		"archive": {
			"view": 213567370
		},
		"article": {
			"view": 3230808
		},
		"likes": 20295095
	}
}
```


