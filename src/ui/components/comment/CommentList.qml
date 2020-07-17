import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"

Item {
    id: root
    implicitHeight: rootCol.implicitHeight

    function open(js){
        AcService.getComment(js.contentId, showComment)
    }

    function showComment(res){
        //console.log("showComment"+JSON.stringify(res))
        modelCmt.clear();
        if(0 !== res.result){
            return
        }
        commentCnt.text = res.commentCount
        for(var idx in res.rootComments){
            res.rootComments[idx].headImgUrl = res.rootComments[idx].headUrl[0].url
            modelCmt.append(res.rootComments[idx])
            //if(idx>2)
                //break;
        }
    }
    Column {
        id: rootCol
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10
        topPadding: 10
        bottomPadding: 10

        Row {
            spacing: 10
            Text {
                text: qsTr("Comment")
            }
            Text {
                id: commentCnt
            }
        }

        ListModel {
            id: modelCmt
        }
        Repeater {
            id: repCmt
            model: modelCmt
            delegate: CommentItem {
                js: model
            }
        }

        Component.onCompleted: {
            console.log("CommentList completed")
        }
    }
}
