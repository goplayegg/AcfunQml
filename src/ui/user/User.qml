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
        console.log("xxxxxxxxxxxxxxxxxxxxxxxx: "+x)
    }
    Behavior on x {
        NumberAnimation{ duration: 200; easing.type: Easing.OutQuad; onFinished: control.visible = !shrinked }
    }

    property var userInfo : ({headUrl:"", name:"", userId:"", comeFrom:"",signature:"",registerTime:0,followed:0, following:0, contentCount:0, isFollowing: false})
    property bool isSelf: userInfo.userId === Global.userInfo.userid

    function open(uid){
        shrinked = false
        AcService.getUserInfoId(uid, function(res){
            if(0 !== res.result){
                busyBox.running = false
                PopMsg.showError(res, mainwindowRoot)
            }
            userInfo = res.profile
            })
        console.log("Global.userInfo.userId:"+Global.userInfo.userid)
        //AcService.getUserProfile(uid, 0, function(res){
        //    })
        //AcService.getUserResource(userJson.userId, 2, 0, function(res){
        //    })
        //AcService.getUserResource(userJson.userId, 3, 0, function(res){
        //    })
    }

    Column {
        id: col
        anchors.fill: parent
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
    }

}
