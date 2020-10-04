import QtQuick 2.0
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"

Item {
    property var userJson: undefined
    id: itemAvatar
    width: 190
    height: 190

    Avatar {
        id: imgAvatar
        size: 100
        avatarUrl: userJson.userImg
        userId: userJson.userId
    }

    Label {
        id: labId
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.left: imgAvatar.right
        text: "id:" + userJson.userId
        font.pixelSize: AppStyle.font_large
    }

    Label {
        id: labContentCnt
        anchors.left: imgAvatar.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.top: labId.bottom
        text: qsTr("%1 contents").arg(userJson.contentCount)
        font.pixelSize: AppStyle.font_large
    }

    Label {
        anchors.left: imgAvatar.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.top: labContentCnt.bottom
        text: qsTr("%1 fans").arg(userJson.fansCount)
        font.pixelSize: AppStyle.font_large
    }

    IconTextButton {
        id: btnFollow
        property bool customChecked: userJson.isFollowing
        anchors.left: imgAvatar.right
        anchors.bottom: imgAvatar.bottom
        color: AppStyle.accentColor
        textColor: AppStyle.backgroundColor
        icon.name: AppIcons.mdi_heart
        iconColor: customChecked? AppStyle.primaryColor :AppStyle.backgroundColor
        text: customChecked? qsTr("Followed"): qsTr("Follow")
        font.pixelSize: AppStyle.font_normal
        onClicked: {
            customChecked = !customChecked
            AcService.follow(userJson.userId, customChecked, function(res){
                if(0 !== res.result)
                    PopMsg.showError(res, mainwindowRoot)
                })
        }
    }

    TextArea {
        id: labUpName
        text: userJson.userName
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
        anchors.top: labUpName.bottom
        anchors.topMargin: 5
        width: parent.width
        text: userJson.signature
        wrapMode: Text.WordWrap
    }
}
