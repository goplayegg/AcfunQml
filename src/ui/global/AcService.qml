pragma Singleton
import QtQuick 2.12
import Network 1.0
import "libraries/functions.js" as FUN

Item {

    property string cookie: ""
    property string token: ""
    property string acSecurity: ""
    property string midground_st: ""
    property string udid: ""
    readonly property string c_appVersion: "6.31.1.1026"//"6.26.0.966"//"6.24.1.958"
    readonly property string c_userAgent: "acvideo core/6.31.1.1026(OPPO;OPPO A83;7.1.1)"
    property string c_mkey: "AAHewK3eIAAyMjA2MDMyMjQAAhAAMEP1uwSG3TvhYAAAAO5fOOpIdKsH2h4IGsF6BlVwnGQA6_eLEvGiajzUp4_YthxOPC-hxcOpTk0SPSrxyhbdkmIwsXnF9PgS5ly8eQyjuXlcS7VpWG0QlK0HakVDamteMHNHIui0A8V4tmELqQ%3D%3D"
    property string c_mkeyMainPage: "AAHewK3eIAAyMTkwNTExNzYAAhAAMEP1uwSZbohCYAAAAJlXIdNAMQR5fM2F-KEOYN5wnGQA6_eLEvGiajzUp4_YnU8EjTm7gzNYhBv59oCCDhbdkmIwsXnF9PgS5ly8eQyjuXlcS7VpWG0QlK0HakVDamteMHNHIui0A8V4tmELqQ%3D%3D"
    signal httpError(var errMsg);

    Component.onCompleted: {
        udid = FUN.guid();//TODO按设备固定一下
    }

    function login(user, psw, cb) {
        var body = "username="+user +"&password="+psw;
        var callBack = function(res){
            makeCookie(res);
            cb(res);
        }

        request('POST', "id.app.acfun.cn/rest/app/login/signin",
                null, body, callBack);
    }

    function getToken(cb) {
        var url = "id.app.acfun.cn/rest/app/token/get";
        var body = "sid=acfun.midground.api";
        request('POST', url, null, body, cb);
    }

    function hasSignedIn(cb) {
        var url = "api-new.acfunchina.com/rest/app/user/hasSignedIn";
        var body = "access_token="+token;
        request('POST', url, null, body, cb);
    }

    function signeIn(cb) {//签到
        var url = "api-new.acfunchina.com/rest/app/user/signIn";
        var body = "access_token="+token;
        request('POST', url, null, body, cb);
    }

    function getUserInfo(cb) {
        var url = "api-new.acfunchina.com/rest/app/user/personalInfo";
        request('GET', url, null, null, cb);
    }

    function getUserInfoId(id, cb) {
        var url = "api-new.app.acfun.cn/rest/app/user/userInfo";
        var qParam = [{"userId":id}];
        request('GET', url, qParam, null, cb);
    }

    function isFollowingUid(id, cb) {
        var url = "api-new.app.acfun.cn/rest/app/relation/isFollowing";
        var qParam = [{"toUserIds":id}];
        request('GET', url, qParam, null, cb);
    }

    function getUserProfile(id, pcursor, cb) {//动态
        var url = "api-new.app.acfun.cn/rest/app/feed/profile";
        var qParam = [  {"pcursor":pcursor},
                        {"userId":id},
                        {"count": 10}]
        request('GET', url, qParam, null, cb);
    }

    function getUserResource(id, resourceType, pcursor, cb) {
        var url = "api-new.app.acfun.cn/rest/app/user/resource/query";
        var qParam = [  {"pcursor":pcursor},
                        {"authorId":id},
                        {"count": 10},
                        {"resourceType":resourceType},//2-视频 3-文章
                        {"sortType":3},//3-最新 2-香蕉最多 1-播放最多
                        {"status":1}];
        request('POST', url, qParam, null, cb);
    }

    function getRankChannelList(cb) {
        var url = "api-new.app.acfun.cn/rest/app/rank/getChannelList";
        request('GET', url, null, null, cb);
    }

    //DAY/THREE_DAYS/WEEK
    function getRank(cid, period, cb) {
        var url = "api-new.app.acfun.cn/rest/app/rank/channel";
        var qParam = [  {"rankPeriod":period},
                        {"channelId":cid},
                        {"appMode":"0"}];
        request('GET', url, qParam, null, cb);
    }

    function getYoungStar(period, cb) {
        var url = "api-new.acfunchina.com/rest/app/rank/youngStar";
        var qParam = [{"appMode":"0"}];
        var body = "rankPeriod=" + period
        request('POST', url, qParam, body, cb);
    }

    function getFastRise(cb) {
        var url = "api-new.acfunchina.com/rest/app/rank/fastRise";
        var qParam = [{"appMode":"0"}];
        request('POST', url, qParam, null, cb);
    }

    function getBananaRank(period, cb) {
        var url = "api-new.acfunchina.com/rest/app/rank/banana";
        var qParam = [  {"rankPeriod":period},
                        {"appMode":"0"}];
        request('GET', url, qParam, null, cb);
    }

    function getChannelList(cb) {
        var url = "api-new.app.acfun.cn/rest/app/channel/allChannels";
        request('POST', url, null, null, cb);
    }

    function getMainPage(pcursor, count, cb) {
        var url = "api-new.acfunchina.com/rest/app/selection/feed";
        var qParam = [{"appMode":"0"}];
        var json = {"mkey": c_mkeyMainPage,
                    "pcursor": pcursor,
                    "count": count};
        var body = FUN.fmtQueryBody(json)
        request('POST', url, qParam, body, cb);
    }

    //动态+投稿动态
    function getFollowFeed(pcursor, count, cb) {
        var url = "api-new.acfunchina.com/rest/app/feed/followFeedV2";
        var qParam = [{"resourceType":"0"},
                      {"pcursor": pcursor},
                      {"count": count} ];
        request('GET', url, qParam, null, cb);
    }

    //仅投稿动态
    function getFollowFeedPc(pcursor, count, cb) {
        var url = "www.acfun.cn/rest/pc-direct/feed/followFeed";
        var qParam = [{"isGroup":"0"},
                      {"gid":"-1"},
                      {"pcursor": pcursor},
                      {"count": count} ];
        request('GET', url, qParam, null, cb);
    }

    //动态详情
    function getMomentDetail(mid, cb) {
        var url = "api-new.app.acfun.cn/rest/app/moment/detail";
        var qParam = [{"momentId": mid}];
        request('GET', url, qParam, null, cb);
    }

    function getChannelVideo(channel, size, cb) {
        var url = "apipc.app.acfun.cn/v3/regions";
        var qParam = [  {"channelId": channel},
                        {"size": size},
                        {"appMode":"0"}];
        request('GET', url, qParam, null, cb);
    }

    function getNewVideoInRegion(channel, pageNo, cb){
        var url = "apipc.app.acfun.cn/v3/regions/new/"+channel;
        var qParam = [  {"pageSize": 10},
                        {"pageNo": pageNo}];
        request('GET', url, qParam, null, cb);
    }

    function getDanm(videoId, lastFetchTime, resourceTypeId, cb) {
        var url = "api-new.acfunchina.com/rest/app/new-danmaku/poll";
        var qParam = [  {"appMode":"0"} ];
        var body = "videoId=" + videoId + "&lastFetchTime="+ lastFetchTime
                    + "&resourceTypeId=" + resourceTypeId;
        request('POST', url, qParam, body, cb);
    }

    //body, videoId, position, mode, color, size, type, id, subChannelId
    function sendDanm(dmJson, cb) {
        var url = "api-new.acfunchina.com/rest/app/new-danmaku/add";
        var body = FUN.fmtQueryBody(dmJson);
        request('POST', url, null, body, cb);
    }

    function getVideoByAc(acId, cb) {
        var url = "api-new.app.acfun.cn/rest/app/douga/info";
        var qParam = [
                {"dougaId": acId},
                {"mkey": c_mkey}];

        request('GET', url, qParam, null, cb);
    }

    function getVideo(vid, sourceId, contentType, cb) {
        var url = "api-new.app.acfun.cn/rest/app/play/playInfo/cast";
        var qParam = [  {"videoId": vid},
                {"resourceId": sourceId},
                {"resourceType": contentType},
                {"mkey": c_mkey}];

        request('GET', url, qParam, null, cb);
    }

    function getArticle(aid, cb) {
        var url = "api-new.app.acfun.cn/rest/app/article/info";
        var qParam = [{"articleId": aid}];

        request('GET', url, qParam, null, cb);
    }

    function getComment(sourceId, sourceType, pcursor, cb){
        var url = "api-new.acfunchina.com/rest/app/comment/list";
        var qParam = [{"sourceId": sourceId},
                {"sourceType": sourceType},
                {"pcursor": pcursor},
                {"count": 20},
                {"showHotComments": 1}];

        request('GET', url, qParam, null, cb);
    }

    // sourceType:  1-文章评论 3-视频评论  4-动态的评论
    function sendComment(sourceId, sourceType, cmt, replyToCommentId, cb) {
        var url = "api-new.app.acfun.cn/rest/app/comment/add";
        var cmtJson = {
            "sourceId": sourceId,
            "sourceType": sourceType,
            "content": encodeURIComponent(cmt),
            "syncToMoment": 0,
            "access_token": token
        }
        if(replyToCommentId){
            cmtJson.replyToCommentId = replyToCommentId
        }
        var body = FUN.fmtQueryBody(cmtJson);
        request('POST', url, null, body, cb);
    }

    function getSubComment(sourceId, rootCommentId, pcursor, cb){
        var url = "api-new.app.acfun.cn/rest/app/comment/sublist";
        var qParam = [{"sourceId": sourceId},
                {"sourceType": 3},
                {"pcursor": pcursor},
                {"count": 20},
                {"rootCommentId": rootCommentId}];

        request('GET', url, qParam, null, cb);
    }

    function getCommentPC(sourceId, cb){
        var url = "www.acfun.cn/rest/pc-direct/comment/list";
        var qParam = [{"sourceId": sourceId},
                {"sourceType": 3},
                {"page": 1},
                {"t": FUN.crtTimsMs()},
                {"showHotComments": 1},
                {"supportZtEmot": true}];

        request('GET', url, qParam, null, cb);
    }

    //count=20&authorId=923834&resourceType=2&sortType=3&status=0&pcursor=0
    function getUpVideoList(authorId, cb) {
        var url = "api-new.acfunchina.com/rest/app/user/resource/query";
        var qParam = [{"authorId": authorId},
                {"resourceType": 2},
                {"count": 20},
                {"sortType": 3},
                {"status": 0},
                {"pcursor": 0}];
        request('POST', url, qParam, null, cb);
    }

    function favorite(resourceId, type, cb) {
        var url = "api-new.app.acfun.cn/rest/app/favorite";
        var body = "resourceId=" +resourceId+ "&resourceType="+type;
        request('POST', url, null, body, cb);
    }

    function unFavorite(resourceId, type, cb) {
        var url = "api-new.app.acfun.cn/rest/app/unFavorite";
        var body = "resourceIds=" +resourceId+ "&resourceType="+type;
        request('POST', url, null, body, cb);
    }

    function banana(resourceId, resourceType, count, cb) {
        var url = "api-new.app.acfun.cn/rest/app/banana/throwBanana";
        var body = "resourceId=" +resourceId+ "&resourceType="+resourceType+"&count="+count;
        request('POST', url, null, body, cb);
    }

    function follow(userId, follow, cb) {
        var url = "api-new.app.acfun.cn/rest/app/relation/follow";
        var body = "action=" +(follow?"1":"2")+ "&groupId=0&toUserId=" + userId;
        request('POST', url, null, body, cb);
    }

    function getOperationList(cb) {
        var url = "api-new.app.acfun.cn/rest/app/operation/getOperations";
        var body = "pcursor=&limit=10"
        request('POST', url, null, body, cb);
    }

    function getSearchRecommend(cb){
        var url = "api-new.acfunchina.com/rest/app/search/recommend";
        request('GET', url, null, null, cb);
    }

    function search(keyword, pCursor, cb){
        var url = "api-new.acfunchina.com/rest/app/search/complex";
        var qParam = [  {"keyword": encodeURIComponent(keyword)},
                        {"requestId": ""},
                        {"pCursor": pCursor},
                        {"mkey": c_mkey} ];
        request('GET', url, qParam, null, cb);
    }

    //通知数量
    function clock(cb){
        var url = "api-new.app.acfun.cn/rest/app/clock/r";
        var qParam = [  {"access_token": token}];
        request('GET', url, qParam, null, cb);
    }

    //通知内容，type：  1-站内公告 2-回复 3-赞 4-艾特 5-收藏+投蕉 8-礼物 9-系统通知     pCursor首次为1
    function getNotify(type, pCursor, cb){
        var url = "api-new.app.acfun.cn/rest/app/notify/load";
        var qParam = [  {"type": type},
                        {"pCursor": pCursor},
                        {"appMode":"0"}];
        request('GET', url, qParam, null, cb);
    }

    //private
    function addHeader(hreq, endpoint){
        hreq.setRequestHeader("User-agent", c_userAgent);
        if("api-new.app.acfun.cn/rest/app/feed/profile"     !== endpoint){
            hreq.setRequestHeader("acPlatform","ANDROID_PHONE");
        }
        hreq.setRequestHeader("random", FUN.guid());//可以不加
        hreq.setRequestHeader("deviceType","1");
        hreq.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        hreq.setRequestHeader("net","WIFI");
        hreq.setRequestHeader("productId","2000");
        hreq.setRequestHeader("udid",udid);//"be0088b8-1ae1-341d-b31e-bed8e78e2325"
        hreq.setRequestHeader("resolution","1080x1920");
        hreq.setRequestHeader("market","tencent");
        var dateNow=new Date();
        var strNow = FUN.fmtTime(dateNow, "yyyy-MM-dd hh:mm:ss.000")
        hreq.setRequestHeader("requestTime", strNow);

        if(endpoint.indexOf("apipc.app.acfun.cn/v3/regions") !== -1 ||
                "api-new.acfunchina.com/rest/app/comment/list" === endpoint ||
                "api-new.acfunchina.com/rest/app/selection/feed" === endpoint ||
                "api-new.acfunchina.com/rest/app/feed/followFeedV2" === endpoint ||
                "api-new.app.acfun.cn/rest/app/notify/load" === endpoint)
            hreq.setRequestHeader("appVersion", c_appVersion);

        if("" !== cookie){
            hreq.setRequestHeader("Cookie", cookie);
        }
        if("" !== token)
        {
            hreq.setRequestHeader("access_token", token);
        }
        hreq.setRequestHeader("token", acSecurity)
        return hreq;
    }

    function addQuery(url, qParam){
        var outUrl = url+"?";
        outUrl +=       "product"     + "=" + "ACFUN_APP";
        outUrl += "&" + "app_version" + "=" + c_appVersion;
        if(qParam){
            var i = 0;
            var key;
            for(i in qParam){
                for(key in qParam[i]){
                    outUrl += "&" + key + "=" + qParam[i][key];
                }
            }
        }
        return outUrl;
    }

    function makeCookie(res){
        if(0 !== res.result)
            return
        cookie = "";
        cookie +="did="+udid;
        cookie +=";safety_id=AAFAsQ04RM6Acm0WUcbfyJ5Q";
        cookie +=";acPasstoken="+ res.acPassToken;
        cookie +=";acSecurity="+ res.acSecurity;//这个字段看抓包没有，以前为啥加这个？
        cookie +=";auth_key="+ res.auth_key;
        cookie +=";old_token="+ res.token;
        cookie +=";userId="+ res.userid;
        //console.log("cookie:"+cookie)
        token = res.token;
        acSecurity = res.acSecurity;
        getToken(function(res){
            if(res.result !== 0)
                return
            midground_st = res["acfun.midground.api_st"]
            cookie +=";acfun.midground.api_st="+ midground_st;
            hasSignedIn(function(res){
                if(!res.hasSignedIn){
                    signeIn(null)
                }
            })
        })
    }

    function request(verb, endpoint, qParam, body, cb) {
        var hreq = HttpRequestFactory.create();
        hreq.finished.connect(function() {
            hreq.finished.disconnect(arguments.callee);
            console.log('hreq: on finished res.len: ' + hreq.responseText.length + " hreq stat:" + hreq.status + hreq.statusText);
            console.log('hreq: on finished res: ' + hreq.responseText)
            if(hreq.status === HttpRequest.NoError) {
                if(cb) {
                    var res = JSON.parse(hreq.responseText)
                    cb(res);
                }
            }
        });

        hreq.error.connect(function(){
            hreq.error.disconnect(arguments.callee);
            console.log("hreq error:" + hreq.statusText);
            httpError(hreq.status + ":" + hreq.statusText);
            cb({result:hreq.status,error_msg:hreq.statusText});
        });

        hreq.timeout.connect(function(){
            hreq.timeout.disconnect(arguments.callee);
            console.log("hreq time out");
            httpError("http time out")
            cb({result:-1,error_msg:"http time out"});
        });

        var url = "https://" + endpoint;
        url = addQuery(url, qParam);
        hreq.open(verb, url);
        hreq = addHeader(hreq, endpoint);
        var data = body?body:'';
        console.log('request: ' + verb + ' ' + url +  " body:" + data);
        hreq.send(data);
    }
}
