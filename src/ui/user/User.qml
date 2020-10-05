import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "qrc:///ui/components/"
import "qrc:///ui/components/btn"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Rectangle{
    id: control
    color: AppStyle.secondBkgroundColor
    property bool shrinked: true
    onShrinkedChanged: {
        x = shrinked ? -width : 0
    }
    Behavior on x {
        NumberAnimation{ duration: 200; easing.type: Easing.OutQuad; onFinished: control.visible = !shrinked }
    }

    property var userInfo : ({headUrl:"", name:"", userId:0, comeFrom:"",signature:"",registerTime:0,followed:0, following:0, contentCount:0, isFollowing: false})
    property bool isSelf: userInfo.userId === Global.userInfo.userid

    function open(uid){
        shrinked = false
        if(userInfo.userId === uid)
            return
        userInfo.userId = uid
        AcService.getUserInfoId(uid, function(res){
            if(0 !== res.result){
                busyBox.running = false
                PopMsg.showError(res, mainwindowRoot)
                userInfo.userId = 0
                return
            }
            userInfo = res.profile
            })
        swip.load()
    }

    Column {
        id: col
        //anchors.fill: parent
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 5
        spacing: 8

        RowLayout {
            height: btnClose.height
            width: parent.width
            spacing: 10
            Text{
                text: qsTr("User Info")
                height: btnClose.height
                font.weight: Font.Bold
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                leftPadding: 8
            }
            RoundButton {
                id: btnClose
                icon.name: AppIcons.mdi_close
                size: 40
                onClicked: {
                    shrinked = true
                }
            }
        }

        RowLayout {
            width: parent.width
            height: colData.height
            spacing: 20

            Avatar {
                Layout.leftMargin: 10
                avatarUrl: userInfo.headUrl
                size: 60
                onClicked: {
                    var url = "https://www.acfun.cn/u/"+userInfo.userId
                    Qt.openUrlExternally(url)
                }
            }

            Column {
                id: colData
                spacing: 2
                Layout.rightMargin: 10
                Layout.fillWidth: true
                Grid{
                    columns: 3
                    rowSpacing: 5
                    width: parent.width
                    Repeater {
                        model: [userInfo.contentCount,userInfo.following, userInfo.followed, "动态", "关注", "粉丝"]
                        Text {
                            text: modelData;
                            width: parent.width/3;
                            font.family: AppStyle.fontNameMain
                            horizontalAlignment: Text.AlignHCenter;
                        }
                    }
                }
                Button{
                    id: btnLogout
                    width: parent.width
                    height: 30
                    text: isSelf?qsTr("Logout"):
                                  userInfo.isFollowing?"Followed":qsTr("Follow")
                    background: Rectangle{
                        color: (isSelf||userInfo.isFollowing)?AppStyle.backgroundColor:AppStyle.accentColor
                        radius: 4
                    }
                    onClicked: {
                        if(isSelf){
                            //todo logout
                            return
                        }else{
                            userInfo.isFollowing = !userInfo.isFollowing
                            AcService.follow(userInfo.userId, userInfo.isFollowing, function(res){
                                if(0 !== res.result)
                                    PopMsg.showError(res, mainwindowRoot)
                            })
                        }
                    }
                }
            }
        }

        TextArea {
            text: userInfo.name
            selectByMouse: true
            readOnly: true
            font.pointSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            font.weight: Font.Bold
        }
        Text {
            leftPadding: 8
            color: AppStyle.secondForeColor
            font.family: AppStyle.fontNameMain
            text: {
                var d = new Date()
                d.setTime(userInfo.registerTime)
                return userInfo.comeFrom + " " + qsTr("register time:") + FUN.fmtTime(d, "yyyy-MM-dd")
            }
        }
        TextArea {
            text: userInfo.signature
            color: AppStyle.thirdForeColor
            font.family: AppStyle.fontNameMain
            width: parent.width
            selectByMouse: true
            readOnly: true
            wrapMode: Text.WordWrap
        }

        TabBarAc {
            id: tab
            height: 30
            anchors.left: parent.left
            anchors.right: parent.right
            bottomRectHei: 6
            checkedFontSize: AppStyle.font_xlarge
            currentIndex: swip.currentIndex
            Component.onCompleted: {
                model.append({"name":qsTr("动态"), "value":0})
                model.append({"name":qsTr("视频"), "value":1})
                model.append({"name":qsTr("文章"), "value":2})
            }
            onCurrentIndexChanged: {
                console.log("user page change tab idx:"+currentIndex)
            }
            background: Rectangle {
                color: AppStyle.secondBkgroundColor
            }
        }
    }

    SwipeView {
        id: swip
        anchors.top: col.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5
        anchors.bottomMargin: 0
        clip: true
        currentIndex: tab.currentIndex
        function load() {
            lders.itemAt(currentIndex).active = true
            lders.itemAt(currentIndex).item.load(userInfo.userId)
        }
        onCurrentIndexChanged: load()
        Repeater {
            id: lders
            model: 3
            Loader {
                active: false
                sourceComponent: UserUploadList {
                    type: index+1
                    anchors.fill: parent
                }
            }
        }
    }
}
