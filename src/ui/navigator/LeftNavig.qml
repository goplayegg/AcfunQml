﻿import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:///ui/components/"
import "qrc:///ui/components/btn"
import "qrc:///ui/components/sideBar"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/other/"

Rectangle{
    id:root
    color: AppStyle.secondBkgroundColor
    width: shrinked?shrinkWidth:norWidth
    Behavior on width {
        NumberAnimation{ duration: 100; easing.type: Easing.OutQuad}
    }

    readonly property string prefBase : "qrc:/assets/img/"
    readonly property string pref : "qrc:/assets/img/leftNav/"
    signal popupOpened(var open);
    signal loginFinish(var js);

    property bool logined :false
    property var jsLogin : ({avatar:"",username:"",userid:"",followed:0,following:0,contentCount:0})
    property alias shrinked: tabBar.shrinked
    property alias curIdx: tabBar.curIdx
    property alias norWidth: tabBar.norWidth
    property alias shrinkWidth: tabBar.shrinkWidth

    function setLoginInfo(js){
        jsLogin = js
        if(jsLogin.username){
            logined = true
            tabBar.setVisible(3, true)
            tabBar.setVisible(5, true)
        }
        console.log("jsLogin", JSON.stringify(jsLogin))
        loginFinish(js)
    }
    function logout (){
        logined = false
        tabBar.setVisible(3, false)
        tabBar.setVisible(5, false)
    }

    Item{
        id:topArea
        height: logined?(shrinked?160:237):(shrinked?160:112)
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 30
        anchors.leftMargin: shrinked?20:35
        anchors.rightMargin: anchors.leftMargin

        Image{
            id:logo
            anchors.top: parent.top
            height: shrinked?40:45
            width: shrinked?40:150
            source: shrinked?pref+"d.png":pref+"a_z.png"
        }
        Button{
            id:btnCategory
            anchors.right: parent.right
            height: 40
            width: height
            y:shrinked?logo.height+10:0
            icon.source: pref+"z0.png"
            hoverEnabled: true
            background: Rectangle{
                color: btnCategory.hovered?"white":"#DEE5EB"
                radius: height/2
            }
            onClicked: {
                var pt = btnCategory.parent.mapToItem(mainwindowRoot, btnCategory.x+btnCategory.width, btnCategory.y)
                popupOther.x = pt.x
                popupOther.y = pt.y
                popupOther.open()
            }
        }
        OtherPagePopup {
            id: popupOther
            parent: mainwindowRoot
        }

        IconTextHCenterBtn{
            id:btnLogin
            visible: !logined
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            height: shrinked?40:38
            text: shrinked?"": tip
            tip: qsTr("登陆账户")
            textColor: shrinked?AppStyle.foregroundColor:AppStyle.backgroundColor
            color: shrinked?AppStyle.backgroundColor:AppStyle.accentColor
            icon.name: shrinked?AppIcons.mdi_face_profile:AppIcons.mdi_face
            radius: shrinked?height/2:4
            onClicked: {
                popupOpened(true)
                popLogin.open()
            }
        }

        Avatar{
            id:imgAvatar
            visible: logined
            avatarUrl: jsLogin.avatar
            userId: jsLogin.userid
            y: btnCategory.y+btnCategory.height+20
            anchors.horizontalCenter: parent.horizontalCenter
            size: shrinked?40:60
        }
        Text{
            id:txUserName
            visible: logined&&(!shrinked)
            text: jsLogin.username
            font.pointSize: 12
            font.family: AppStyle.fontNameMain
            font.weight: Font.Bold
            anchors.top: imgAvatar.bottom
            anchors.topMargin: 22
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text{
            id:txUserId
            visible: txUserName.visible
            text: "lv:" + jsLogin.level
            font.family: AppStyle.fontNameMain
            anchors.top: txUserName.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Grid{
            columns: 3
            rowSpacing: 5
            visible: txUserName.visible
            anchors.top: txUserId.bottom
            anchors.topMargin: 15
            width: parent.width
            Repeater {
                model: [jsLogin.contentCount,jsLogin.following, jsLogin.followed, "动态", "关注", "粉丝"]
                Text {
                    text: modelData;
                    width: parent.width/3;
                    font.family: AppStyle.fontNameMain
                    horizontalAlignment: Text.AlignHCenter;
                }
            }
        }
    }

    SideBar{
        id:tabBar
        defaultSelIdx:1

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: topArea.bottom
        anchors.bottom: parent.bottom

        Component.onCompleted: {
            tabBar.addItem({"spliter":true,"text":"","icon":"","iconChecked":"","hide":false})
            tabBar.addItem({"text":qsTr("视频"),"icon":pref+"u9.png","iconChecked":pref+"u9Red.png"})
            tabBar.addItem({"text":qsTr("文章"),"icon":pref+"a3a.png","iconChecked":pref+"a3c.png"})
            tabBar.addItem({"text":qsTr("动态"),"icon":pref+"a3d.png","iconChecked":pref+"a3f.png","hide":true})
            tabBar.addItem({"text":qsTr("排行榜"),"icon":pref+"a7p2.png","iconChecked":pref+"a7p.png"})
            tabBar.addItem({"text":qsTr("消息"),"icon":pref+"ub.png","iconChecked":pref+"uc.png","hide":true})
            tabBar.addItem({"text":qsTr("活动"),"icon":prefBase+"common/banana0.png","iconChecked":prefBase+"common/banana1.png"})
            tabBar.addItem({"spliter":true})
            tabBar.addItem({"text":"设置","icon":pref+"a4g.png","iconChecked":pref+"a4g2.png","hide":false})
            tabBar.addItem({"text":"关于","icon":pref+"ug.png","iconChecked":pref+"uh.png"})
        }
    }

    Login{
        id: popLogin
        parent: root.parent
        onClosed: {
            popupOpened(false)
        }
        onLoginFinish: {
            root.setLoginInfo(js)
            popLogin.close()
        }
    }

    Component.onCompleted: {
        popLogin.initLogin()
    }
}
