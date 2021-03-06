﻿pragma Singleton
import QtQuick 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import AcfunQml 1.0
import QtKeychain 1.0
import QmlVlc 0.1

Item {
    property int sliderBarWidth: 6
    property var userInfo

    signal openVideo(var js)
    signal openCircleDetail(var info, var byId)
    signal openUser(var js)
    signal openArticle(var js)
    signal logout()
    signal openOther(var idx)//0 收藏 1 稍后再看 2 历史 3 搜索
    signal spacePressed()
    signal enterPressed()

    function appVer(){
        return constPref.get("appVer")
    }

    function emotPacks(){
        return constPref.get("emotPacks")
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
            if(null === returnedPassword){
                console.log("readEncrypt key \""+key+"\"failed")
                return
            }
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
        console.log("error unsupport res type:"+type)
        return type
    }

    function saveSize(id, name){
        g_preference.setValue(name+"Width", id.width)
        g_preference.setValue(name+"Height", id.height)
    }

    function resotreSize(id, name){
        let width = 990
        let height = 710
        var w = g_preference.value(name+"Width")
        if(undefined !== w) {
            width = w
        }
        var h = g_preference.value(name+"Height")
        if(undefined !== h) {
            height = h
        }
        id.width = width
        id.height = height
    }

    function getBoolPref(name, defaultVal = false){
        let prefValue = g_preference.value(name)
        if(undefined !== prefValue)
            return prefValue === "true"
        return defaultVal
    }

    function getValPref(name, defaultVal = undefined){
        let prefValue = g_preference.value(name)
        if(undefined !== prefValue)
            return prefValue
        return defaultVal
    }

    function openUrl(link){
        console.log("open link:"+link)
        if(link.substr(link.length-4)===".gif"){
            PopImage.open(link, "gif")
        }else if(link.substr(0, 3)==="ac/"){
            let acid = link.substr(3)
            AcService.resourceType("ac"+acid, function(res){
                if(res.result === 0){
                    if(res.resourceType==="ARTICLE")
                        openArticle(acid)
                    else
                        openVideo({contentId: acid})
                }
            })
        }else if(link.substr(0, 4)==="uid/"){
            let uid = link.substr(4)
            openUser(uid)
        }else{
            Qt.openUrlExternally(link)
        }
    }

    Component.onCompleted: {
        let enable = getBoolPref("hardDec", true)
        console.log("VlcConfig enable hard decode:"+enable)
        vlcConfig.enableHardDecode(enable)

        var theme = g_preference.value("theme")
        if(undefined !== theme) {
            AppStyle.currentTheme = parseInt(theme)
        }

        console.log("Singleton Global init finished")
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

    ConstPreferences {
        id: constPref
    }

    VlcConfig {
        id: vlcConfig
    }
}
