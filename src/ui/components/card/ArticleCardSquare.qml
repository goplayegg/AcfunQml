import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item {
    property var articleJson: undefined
    id: control
    width: 190
    height: 190

    Avatar {
        id: imgAvatar
        size: 100
        avatarUrl: articleJson.userImg
        userId: articleJson.userId
    }

    Label {
        id: labViewed
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.left: imgAvatar.right
        text: qsTr("%1 viewed").arg(articleJson.viewCountInfo)
        font.pixelSize: AppStyle.font_large
    }

    Label {
        id: labCnt
        anchors.left: imgAvatar.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.top: labViewed.bottom
        text: qsTr("%1 comments").arg(articleJson.commentCountInfo)
        font.pixelSize: AppStyle.font_large
    }

    Label {
        anchors.left: imgAvatar.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.top: labCnt.bottom
        text: articleJson.channelName
        font.pixelSize: AppStyle.font_large
    }

    TextArea {
        id: labTitle
        text: articleJson.title
        wrapMode: Text.WordWrap
        padding: 0
        anchors.top: imgAvatar.bottom
        anchors.topMargin: 5
        width: parent.width
        selectByMouse: true
        readOnly: true
        font.weight: Font.Bold
        font.pixelSize: AppStyle.font_large
        font.family: AppStyle.fontNameMain
    }

    Label {
        anchors.top: labTitle.bottom
        anchors.topMargin: 5
        width: parent.width
        wrapMode: Text.WordWrap
        text: {
            var time = ""
            if(0 !== articleJson.ctime)
                time = "  " + qsTr("Posted") + "  "+ FUN.fmtMs2TimeStr(articleJson.ctime)
            return articleJson.userName + time
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            Global.openArticle(articleJson.contentId)
        }
    }
}
