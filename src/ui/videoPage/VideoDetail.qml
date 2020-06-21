import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"

Item {
    id: root
    height: rootCol.implicitHeight

    property var user: ({})
    function open(js){
        textTitle.text = js.title
        btnLike.text = js.likeCountShow
        btnBanana.text = js.bananaCountShow
        btnStar.text = js.stowCount
        labPostTime.text = qsTr("Posted") +"  "+ js.createTime
        textPlayCnt.text = js.viewCountShow
        textDanmCount.text = js.danmakuCountShow
        textAC.text = "AC"+js.contentId
        textDesc.text = js.description
        //refresh.visible = !refresh.visible
        user = JSON.parse(js.userJson)
        imgAvatar.source = user.headUrl
        labUpName.text = user.name
        btnFollow.customChecked = user.isFollowing
    }
    Column {
        id: rootCol
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10
        topPadding: 10
        bottomPadding: 10

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.max(textTitle.height, rowBtns.height)
            TextArea {
                id: textTitle
                leftPadding: 0
                anchors.left: parent.left
                anchors.right: rowBtns.left
                height: Math.max(rowBtns.height, implicitHeight)
                text: "-"
                selectByMouse: true
                readOnly: true
                wrapMode: Text.WordWrap
                font.pixelSize: AppStyle.font_xxlarge
                font.family: AppStyle.fontNameMain
                font.weight: Font.Black
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                id: rowBtns
                spacing: 8
                anchors.right: parent.right
                RoundBtnWithText {
                    id: btnLike
                    icon: "qrc:/assets/img/common/like0.png"
                    iconChecked: "qrc:/assets/img/common/like1.png"
                }
                RoundBtnWithText {
                    property var componentBanana: null
                    id: btnBanana
                    icon: "qrc:/assets/img/common/banana0.png"
                    iconChecked: "qrc:/assets/img/common/banana1.png"
                    onClicked: {
                        if(null == componentBanana){
                            componentBanana = Qt.createComponent("qrc:/ui/components/Banana.qml")
                        }
                        if(componentBanana.status === Component.Ready){
                            console.log("throw Banana")
                            var from = mapToItem(root, 0, height)
                            var to = itemAvatar.mapToItem(root, 0, 0)
                            var pos = {"fromPos":from, "toPos":to}
                            var tmp = componentBanana.createObject(root, pos)
                            tmp.start();
                            imgAvatar.start()
                        }
                    }
                }
                RoundBtnWithText {
                    id: btnStar
                    icon: "qrc:/assets/img/common/star0.png"
                    iconChecked: "qrc:/assets/img/common/star1.png"
                }
            }
        }

        Row {
            spacing: 5
            Text {
                height: textPlayCnt.height
                width: height
                text: AppIcons.mdi_play_box_outline
                font.family: AppIcons.family
                font.pixelSize: height / 1.5
                font.weight: Font.Light
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: AppStyle.secondForeColor
            }
            Text {
                id: textPlayCnt
                font.pixelSize: AppStyle.font_smal
                font.family: AppStyle.fontNameMain
            }
            Text {
                height: textPlayCnt.height
                width: height
                text: AppIcons.mdi_card_bulleted_outline
                font.family: AppIcons.family
                font.pixelSize: height / 1.5
                font.weight: Font.Light
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: AppStyle.secondForeColor
            }
            Text {
                id: textDanmCount
                font.pixelSize: AppStyle.font_smal
                font.family: AppStyle.fontNameMain
            }
            TextArea {
                id: textAC
                padding: 0
                selectByMouse: true
                readOnly: true
                font.pixelSize: AppStyle.font_smal
                font.family: AppStyle.fontNameMain
            }
        }

        Item {
            id: rowUp
            height: itemAvatar.height
            anchors.left: parent.left
            anchors.right: parent.right

            Item {
                width: 50
                height: width
                id: itemAvatar
                z: 2

                RoundImage {
                    id: imgAvatar
                    size: 50
                    function start(){
                        animAvatar.start()
                    }
                    ParallelAnimation {
                        property int dura: 2000
                        id: animAvatar
                        running: false
                        NumberAnimation {
                            target: imgAvatar
                            property: "x"
                            from: 0
                            to: 40
                            duration: animAvatar.dura
                            //easing.type: Easing.InQuad
                        }
                        NumberAnimation {
                            target: imgAvatar
                            property: "y"
                            from: 0
                            to: -10
                            duration: animAvatar.dura
                            //easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: imgAvatar
                            property: "rotation"
                            from: 0
                            to: 75
                            duration: animAvatar.dura
                            //easing.type: Easing.OutCubic
                        }
                    }
                }
            }
            Column {
                spacing: 8
                anchors.verticalCenter: itemAvatar.verticalCenter
                anchors.left: itemAvatar.right
                anchors.leftMargin: 15
                TextArea {
                    id: labUpName
                    padding: 0
                    selectByMouse: true
                    readOnly: true
                    font.weight: Font.Bold
                    font.pixelSize: AppStyle.font_large
                    font.family: AppStyle.fontNameMain
                }
                Label {
                    id: labPostTime
                    leftPadding: 3
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                }
            }

            IconTextButton {
                id: btnFollow
                property bool customChecked: false
                anchors.right: parent.right
                anchors.top: rowUp.top
                color: AppStyle.accentColor
                textColor: AppStyle.backgroundColor
                icon.name: AppIcons.mdi_heart
                iconColor: customChecked? AppStyle.primaryColor :AppStyle.backgroundColor
                text: customChecked? qsTr("Followed"): qsTr("Follow")
                onClicked: customChecked = !customChecked
            }
        }

        TextArea {
            id: textDesc
            leftPadding: 0
            anchors.left: parent.left
            anchors.right: parent.right
            selectByMouse: true
            readOnly: true
            wrapMode: Text.WordWrap
            textFormat: TextEdit.RichText
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            id: refresh
        }

        ParallelAnimation {
            id: animBanana
            NumberAnimation {
                target: imgAvatar

            }
        }

        Component.onCompleted: {
            console.log("Video detail completed")
        }
    }
}
