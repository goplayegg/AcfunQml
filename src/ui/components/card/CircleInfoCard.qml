import QtQuick 2.0
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"

Rectangle {
    property var feedInfoJson
    property real cardMargin: 5
    id: control
    width: 300
    implicitHeight: col.implicitHeight+2*cardMargin
    color: AppStyle.secondBkgroundColor

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        //anchors.bottom: parent.bottom
        anchors.margins: cardMargin
        anchors.topMargin: cardMargin+4
        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            height: 38

            Loader {
                id: imgAvatar
                width: 32
                height: 32
            }

            Column {
                spacing: 2
                anchors.verticalCenter: imgAvatar.verticalCenter
                anchors.left: imgAvatar.right
                anchors.leftMargin: 10
                TextArea {
                    text: feedInfoJson.user.userName
                    padding: 0
                    selectByMouse: true
                    readOnly: true
                    font.weight: Font.Bold
                    font.pixelSize: AppStyle.font_large
                    font.family: AppStyle.fontNameMain
                }
                Label {
                    text: feedInfoJson.time + " " + qsTr("%1 viewed").arg(feedInfoJson.viewCount)
                    leftPadding: 3
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                }
            }
        }

        TextArea {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            selectByMouse: true
            readOnly: true
            wrapMode: Text.WordWrap
            font.weight: Font.Normal
            font.pixelSize: AppStyle.font_normal
            font.family: AppStyle.fontNameMain
            text: feedInfoJson.moment?feedInfoJson.moment.text:
                                       feedInfoJson.articleBody?feedInfoJson.articleBody:
                                                                 feedInfoJson.caption?feedInfoJson.caption:
                                                                                       feedInfoJson.articleTitle
        }

        Row {
            id: rowBtns
            spacing: 8
            anchors.left: parent.left
            anchors.right: parent.right
            RoundBtnWithText {//评论
                id: btnComment
                text: feedInfoJson.commentCount
                icon: "qrc:/assets/img/common/cmt0.png"
                iconChecked: "qrc:/assets/img/common/cmt1.png"
                onClicked: {
                    console.log(customChecked?"btnComment":"btnComment")
                }
            }
            RoundBtnWithText {//投蕉
                id: btnBanana
                text: feedInfoJson.bananaCount
                customChecked: feedInfoJson.isThrowBanana
                enabled: !customChecked
                icon: "qrc:/assets/img/common/banana0.png"
                iconChecked: "qrc:/assets/img/common/banana1.png"
                property var componentBanana: null
                onClicked: {
                    customChecked = true
                    AcService.banana(acID, contentType, 1, function(res){
                    })
                }
            }
            RoundBtnWithText {
                id: btnLike
                customChecked: feedInfoJson.isLike
                enabled: !customChecked
                icon: "qrc:/assets/img/common/like0.png"
                iconChecked: "qrc:/assets/img/common/like1.png"
            }
        }
    }

    Component {
        id: cmpGif
        AnimatedImage {
            id: gif
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    openUserPage()
                }
            }
        }
    }

    Component {
        id: cmpImg
        RoundImage {
            size: imgAvatar.width
            onClicked: {
                openUserPage()
            }
        }
    }

    Component.onCompleted: {
        loadAvatarCover()
    }

    function loadAvatarCover(){
        var gifIdx = feedInfoJson.user.userHead.indexOf(".gif")
        if(gifIdx !== -1){
            imgAvatar.sourceComponent = cmpGif
            imgAvatar.item.source = feedInfoJson.user.userHead.substring(0, gifIdx+4)
        }else{
            imgAvatar.sourceComponent = cmpImg
            imgAvatar.item.source = feedInfoJson.user.userHead
        }
    }

}
