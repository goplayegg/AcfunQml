pragma Singleton
import QtQuick 2.12
import "qrc:///ui/components"

QtObject {
    property var toastMsg

    function banana(resourceId, resourceType, count){
        AcService.banana(resourceId, resourceType, count, function(res){
            if(0 !== res.result)
                PopMsg.showError(res, toastMsg.parent)
            else{
                toastMsg.showTip("蕉易成功")
            }
        })
    }

    function favorite(resourceId, type){
        AcService.favorite(resourceId, type, function(res){
            if(0 !== res.result)
                PopMsg.showError(res, toastMsg.parent)
            else{
                toastMsg.showTip(1===type?"追番成功":"收藏成功")
            }
        })
    }

    function unFavorite(resourceId, type){
        AcService.unFavorite(resourceId, type, function(res){
            if(0 !== res.result)
                PopMsg.showError(res, toastMsg.parent)
            else{
                toastMsg.showTip("Bye")
            }
        })
    }

    function follow(userid, customChecked){
        AcService.follow(userid, customChecked, function(res){
            if(0 !== res.result){
                PopMsg.showError(res, toastMsg.parent)
                customChecked = !customChecked
            }else{
                toastMsg.showTip(customChecked?"和up主脑电波对接成功":"缘分已尽，祝安好")
            }
        })
    }

    function likeComment(contentId, cmtType, cmtId, like){
        AcService.likeComment(contentId, cmtType, cmtId, like, function(res){
            if(0 !== res.result){
                PopMsg.showError(res, toastMsg.parent)
            }else{
                toastMsg.showTip(like?"点赞成功":"取消点赞成功")
            }
        })
    }
}
