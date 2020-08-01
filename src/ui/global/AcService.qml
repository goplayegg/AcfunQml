pragma Singleton
import QtQuick 2.12
import Network 1.0
import "libraries/functions.js" as FUN

Item {

    property string cookie: ""
    property string token: ""
    property string acSecurity: ""
    readonly property string c_appVersion: "6.26.0.966"//"6.24.1.958"
    readonly property string c_userAgent: "acvideo core/6.24.1.958(OPPO;OPPO A83;7.1.1)"
    property string c_mkey: "AAHewK3eIAAyMjA2MDMyMjQAAhAAMEP1uwSG3TvhYAAAAO5fOOpIdKsH2h4IGsF6BlVwnGQA6_eLEvGiajzUp4_YthxOPC-hxcOpTk0SPSrxyhbdkmIwsXnF9PgS5ly8eQyjuXlcS7VpWG0QlK0HakVDamteMHNHIui0A8V4tmELqQ%3D%3D"

    signal httpError(var errMsg);

    function login(user, psw, cb) {
        var body = "username="+user +"&password="+psw;
        var callBack = function(res){
            makeCookie(res);
            cb(res);
        }

        request('POST', "id.app.acfun.cn/rest/app/login/signin",
                null, body, callBack);
    }

    function hasSignedIn(cb) {
        var url = "api-new.acfunchina.com/rest/app/user/hasSignedIn";
        var body = "access_token="+token;
        request('POST', url, null, body, cb);
    }

    function getUserInfo(cb) {
        var url = "api-new.acfunchina.com/rest/app/user/personalInfo";
        request('GET', url, null, null, cb);
    }

    function getRank(cb) {
        var url = "api-new.app.acfun.cn/rest/app/rank/channel";
        var qParam = [  {"rankPeriod":"DAY"},
                        {"channelId":"0"},
                        {"appMode":"0"}];
        request('GET', url, qParam, null, cb);
    }

    function getChannelList(cb) {
        var url = "api-new.app.acfun.cn/rest/app/channel/allChannels";
        request('POST', url, null, null, cb);
    }

    function getChannelVideo(channel, size, cb) {
        var url = "apipc.app.acfun.cn/v3/regions";
        var qParam = [  {"channelId": channel},
                        {"size": size},
                        {"appMode":"0"}];
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

    function getComment(sourceId, pcursor, cb){
        var url = "api-new.acfunchina.com/rest/app/comment/list";
        var qParam = [{"sourceId": sourceId},
                {"sourceType": 3},
                {"pcursor": pcursor},
                {"count": 20},
                {"showHotComments": 1}];

        request('GET', url, qParam, null, cb);
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

    function favorite(resourceId, cb) {
        var url = "api-new.app.acfun.cn/rest/app/favorite";
        var body = "resourceId=" +resourceId+ "&resourceType="+9;
        request('POST', url, null, body, cb);
    }

    function unFavorite(resourceId, cb) {
        var url = "api-new.app.acfun.cn/rest/app/unFavorite";
        var body = "resourceIds=" +resourceId+ "&resourceType="+9;
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

    //private
    function addHeader(hreq, endpoint){
        hreq.setRequestHeader("User-agent", c_userAgent);
        hreq.setRequestHeader("acPlatform","ANDROID_PHONE");
        hreq.setRequestHeader("deviceType","1");
        hreq.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        hreq.setRequestHeader("net","WIFI");
        hreq.setRequestHeader("productId","2000");
        hreq.setRequestHeader("udid","be0088b8-1ae1-341d-b31e-bed8e78e2325");
        hreq.setRequestHeader("resolution","1080x1920");
        hreq.setRequestHeader("market","tencent");
        if("apipc.app.acfun.cn/v3/regions" === endpoint ||
           "api-new.acfunchina.com/rest/app/comment/list" === endpoint)
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
        cookie +="did=be0088b8-1ae1-341d-b31e-bed8e78e2325;safety_id=AAFAsQ04RM6Acm0WUcbfyJ5Q";
        cookie +=";acPasstoken="+ res.acPassToken;
        cookie +=";acSecurity="+ res.acSecurity;
        cookie +=";auth_key="+ res.auth_key;
        cookie +=";old_token="+ res.token;
        cookie +=";userId="+ res.userid;
        //console.log("cookie:"+cookie)
        token = res.token;
        acSecurity = res.acSecurity;
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
        });

        hreq.timeout.connect(function(){
            hreq.timeout.disconnect(arguments.callee);
            console.log("hreq time out");
            httpError("http time out")
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
