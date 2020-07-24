import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"

Item {
    id: root
    implicitHeight: rootCol.implicitHeight
    height: implicitHeight
    property var rootCmtId: 0
    property string pcursor: ""

    onHeightChanged: {
        console.log("SubCommentList height:"+height + "rootCmtId:"+rootCmtId)
    }

    function open(jsonStr, cmtId){
        rootCmtId = cmtId
        //console.log("showComment"+JSON.stringify(res))
        modelCmt.clear();
        var subCmt = JSON.parse(jsonStr)
        pcursor = subCmt.pcursor
        var subCmts = subCmt.subComments
        for(var idx in subCmts){
            subCmts[idx].headImgUrl = subCmts[idx].headUrl[0].url
            modelCmt.append(subCmts[idx])
        }
        if("no_more" === pcursor)
            textMore.visible = false
        else{
            textMore.iTotal = subCmts.length
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
                js: model
            }
        }
        Label {
            property int iTotal:0
            id: textMore
            leftPadding: 0
            textFormat: Qt.RichText
            text: qsTr("total:%1").arg(iTotal)+"  " + "<a href=\"more\">"+qsTr("show more")+"</a>"
            onLinkActivated: {
                console.log("clicked:"+link)
            }
        }
    }
}
