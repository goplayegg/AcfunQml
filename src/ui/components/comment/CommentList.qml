import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"

Item {
    id: root
    implicitHeight: rootCol.implicitHeight
    property var pcursor: "no_more"
    property var contentId
    property int cmtType: 3

    function clear(){
        modelCmt.clear();
        editor.parent = cmtEditer
    }

    function open(js){
        btnEditerTip.checked = false
        if(editor.parent !== cmtEditer)
            editor.parent.visible = false//隐藏子串的评论占位Rectangle
        editor.parent = cmtEditer
        editor.reset()
        editor.clear()
        modelCmt.clear();
        contentId = js.contentId
        cmtType = js.cmtType?js.cmtType:3
        AcService.getComment(js.contentId, cmtType, 0, showComment)
    }

    function showComment(res){
        //console.log("showComment"+JSON.stringify(res))
        if(0 !== res.result){
            PopMsg.showError(res, mainwindowRoot)
            return
        }
        pcursor = res.pcursor
        commentCnt.text = res.commentCount
        for(var idx in res.hotComments){
            addCmt(res.hotComments[idx], res)
        }
        for(var idxR in res.rootComments){
            addCmt(res.rootComments[idxR], res)
        }
    }
    function addCmt(cmt, res){
        cmt.headImgUrl = cmt.headUrl[0].url
        var curCID = cmt.commentId
        if(undefined !== res.subCommentsMap[String(curCID)]){
            cmt.subCommentsJson = JSON.stringify(res.subCommentsMap[String(curCID)])
        }else{
            cmt.subCommentsJson = ""
        }
        modelCmt.append(cmt)
    }

    Column {
        id: rootCol
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10
        topPadding: 10
        bottomPadding: 10

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10
            Text {
                text: qsTr("Comment")
            }
            Text {
                id: commentCnt
            }
        }
        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10
            AvatarWithCover {
                id: avatarSelf
                size: 90
                avatarUrl: Global.userInfo.avatar
            }
            Rectangle {
                id: cmtEditer
                height: btnEditerTip.visible?btnEditerTip.height:editor.height
                width: parent.width-avatarSelf.width-parent.spacing
                color: "transparent"
                Button {
                    id: btnEditerTip
                    width: parent.width
                    height: avatarSelf.height
                    checkable: true
                    checked: false
                    visible: checked
                    text: qsTr("编辑器正处于引用发言状态，点击恢复正常状态。")
                    font.pixelSize: AppStyle.font_large
                    font.family: AppStyle.fontNameMain
                    font.weight: Font.Normal
                    onClicked: {
                        editor.parent.visible = false//隐藏子串的评论占位Rectangle
                        editor.parent = cmtEditer
                        editor.reset()
                    }
                }
            }
        }

        CommentEditor {
            id: editor
            parent: cmtEditer
            anchors.left: parent.left
            anchors.right: parent.right
            acId: contentId
            resourceType: cmtType
            //TODO 将发成功的评论插入到评论
        }

        ListModel {
            id: modelCmt
        }
        Repeater {
            id: repCmt
            model: modelCmt
            delegate: CommentItem {
                editorItemHeight: editor.height
                js: model
                onReplyTo: {
                    btnEditerTip.checked = true
                    if(editor.parent !== cmtEditer)
                        editor.parent.visible = false//隐藏其他子串的评论占位Rectangle
                    editor.replySubCmt = true
                    editor.replyToId = cmtId
                    editor.replyToName = userName
                    editor.parent = editerParent
                }
                onLikeComment: {
                    AcServiceEx.likeComment(contentId, cmtType, cmtId, like)
                }
            }
        }

        Button {
            width: parent.width
            text: qsTr("show more")
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            font.weight: Font.Normal
            visible: "no_more" !== pcursor
            onClicked: {
                AcService.getComment(contentId, cmtType, pcursor, showComment)
            }
        }

        Component.onCompleted: {
            console.log("CommentList completed")
        }
    }
}
