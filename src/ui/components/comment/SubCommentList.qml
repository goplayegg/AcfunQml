import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"

Item {
    id: root
    implicitHeight: rootCol.implicitHeight
    height: implicitHeight
    property var sourceId: 0
    property var rootCmtId: 0
    property string pcursor: ""

    signal replyTo(var cmtId, var userName, var editerParent)

    Rectangle {
        id: rectBk
        color: AppStyle.secondBkgroundColor
        anchors.fill: parent
    }

//    onHeightChanged: {
//        console.log("SubCommentList height:"+height + "rootCmtId:"+rootCmtId)
//    }

    function open(jsonStr, cmtId){
        rootCmtId = cmtId
        //console.log("showComment"+JSON.stringify(res))
        modelCmt.clear()
        var subCmt = JSON.parse(jsonStr)
        pcursor = subCmt.pcursor
        var subCmts = subCmt.subComments
        for(var idx in subCmts){
            subCmts[idx].headImgUrl = subCmts[idx].headUrl[0].url
            modelCmt.append(subCmts[idx])
            if(0 === sourceId)
                sourceId = subCmts[idx].sourceId
        }
        if("no_more" === pcursor)
            textMore.visible = false
        else{
            textMore.iTotal = subCmts.length
        }
    }
    function loadSubCmt(res){
        if(0 !== res.result){
            PopMsg.showError(res, mainwindowRoot)
            return
        }
        pcursor = res.pcursor
        if("no_more" === pcursor)
            textMore.visible = false
        var subCmts = res.subComments
        for(var idx in subCmts){
            subCmts[idx].headImgUrl = subCmts[idx].headUrl[0].url
            modelCmt.append(subCmts[idx])
        }
    }

    Column {
        id: rootCol
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10
        topPadding: 10
        bottomPadding: 10

        ListModel {
            id: modelCmt
        }
        Repeater {
            id: repCmt
            model: modelCmt
            delegate: SubCommentItem {
                editorItemHeight: editor.height
                js: model
                onReplyTo: {
                    root.replyTo(cmtId, userName, editerParent)
                }
            }
        }
        Label {
            property int iTotal:0
            id: textMore
            leftPadding: 0
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            font.weight: Font.Normal
            textFormat: Qt.RichText
            text: qsTr("total:%1").arg(iTotal)+"  " + "<a href=\"more\">"+qsTr("show more")+"</a>"
            onLinkActivated: {
                console.log("clicked:"+link)
                AcService.getSubComment(sourceId, rootCmtId, pcursor, loadSubCmt)
            }
        }
    }
}
