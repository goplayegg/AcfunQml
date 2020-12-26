pragma Singleton
import QtQuick 2.12
import AcfunQml 1.0
import QtKeychain 1.0

Item {
    property int sliderBarWidth: 6
    property var userInfo

    ConstPreferences {
        id: constPref
    }

    function appVer(){
        return constPref.get("appVer")
    }

    function emotPacks(){
        return constPref.get("emotPacks")
    }

    Component {
        id: cmpWritePsw
        WritePasswordJob {
            id: job
            service: "acfunQml"
            onFinished: {
                console.debug("Store complete")
            }
        }
    }
    Component {
        id: cmpReadPsw
        ReadPasswordJob {
            id: job
            service: "acfunQml"
            onFinished: {
                console.debug("Read complete")
            }
        }
    }

    function storeEncrypt(key, val){
        var storeJobObject = cmpWritePsw.createObject(null,{})
        storeJobObject.key = key;
        storeJobObject.setTextData(val);
        storeJobObject.start();
    }

    function readEncrypt(key, cb){
        var readJobObject = cmpReadPsw.createObject(null,{})
        readJobObject.key = key
        readJobObject.finished.connect(function (returnedPassword){
            var curVal = returnedPassword.textData()
            //console.log("value is: "+curVal+" key is:"+key)
            cb(curVal)
        })
        readJobObject.start();
    }

    function resourceType2sourceType(type){
        switch(type){
        case 10://动态
            return 4;
        case 2://视频
            return 3;
        case 3://文章
            return 1;
        }
    }

    signal openVideo(var js)
    signal openCircleDetail(var info, var byId)
    signal openUser(var js)
    signal openArticle(var js)
    signal logout()
    signal openOther(var idx)//0 收藏 1 稍后再看 2 历史 3 搜索
}
