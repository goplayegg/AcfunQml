import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"

Item{
    id:root

    function refresh(){
    }

    function back(){

    }

    function empty(){
        return false
    }

    ScrollView {
        id: scroll
        clip: true
        anchors.fill: parent

        Column {
            id:colBars
            width: parent.width
            spacing: 20

            Label {
                text: qsTr("Help & About")
                font.pixelSize: AppStyle.font_xxxxlarge
                font.family: AppStyle.fontNameMain
                font.weight: Font.Black
            }

            Label {
                text: qsTr("Disclaimer")
                font.pixelSize: AppStyle.font_xxlarge
                font.family: AppStyle.fontNameMain
                font.weight: Font.DemiBold
            }

            Label {
                width: parent.width
                text: qsTr("本软件为Acfun第三方客户端，不代表任何官方立场，仅用作学习交流使用，无法承担重度使用。
软件保证在您使用软件的过程中，您的数据仅在您与Acfun之间流通，开发者不会窃取任何数据。但即便如此，也请您妥善保管自己的账户数据，注意使用环境的安全。")
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                wrapMode: Text.WordWrap
            }

            Label {
                text: qsTr("Developer")
                font.pixelSize: AppStyle.font_xxlarge
                font.family: AppStyle.fontNameMain
                font.weight: Font.DemiBold
            }

            Row {
                width: parent.width
                height: btnGitHub.height
                leftPadding: 10
                spacing: 20
                IconTextButton {
                    id: btnGitHub
                    color: AppStyle.accentColor
                    icon.name: AppIcons.mdi_github_circle
                    text: "蚂蚁会飞乐"
                    tip: "https://github.com/baoyuanle/AcfunQml"
                    onClicked: Qt.openUrlExternally(tip)
                }
                ImgTextButton {
                    img: "qrc:/assets/img/leftNav/d.png"
                    text: "敌军还有30秒到达葬场"
                    tip: "https://www.acfun.cn/u/923834"
                    onClicked: Qt.openUrlExternally(tip)
                }
            }

            Label {
                text: qsTr("Thanks")
                font.pixelSize: AppStyle.font_xxlarge
                font.family: AppStyle.fontNameMain
                font.weight: Font.DemiBold
            }

            LinkLabel {
                url: "https://github.com/yuriyoung/mcplayer"
                text: "麻菜 mcplayer"
            }

            LinkLabel {
                url: "https://github.com/jaredtao/TaoQuick"
                text: "涛哥 TaoQuick"
            }

            LinkLabel {
                url: "https://github.com/RSATom/QmlVlc"
                text: "RSATom QmlVlc"
            }

            LinkLabel {
                url: "https://github.com/qyvlik/HttpRequest"
                text: "qyvlik HttpRequest"
            }

            LinkLabel {
                url: "https://www.azimiao.com/5882.html"
                text: "梓喵出没"
            }

            LinkLabel {
                url: "https://github.com/Richasy"
                text: "云之幻"
            }

            IconTextButton {
                id: btnLicense
                color: AppStyle.backgroundColor
                textColor: AppStyle.foregroundColor
                icon.name: AppIcons.mdi_scale_balance
                text: qsTr("Open Lisence Folder")
                onClicked: Qt.openUrlExternally("file:///"+tip)
                Component.onCompleted: {
                    tip = g_preference.value("appPath")+"/License"
                }
            }

            IconTextButton {
                color: AppStyle.backgroundColor
                textColor: AppStyle.foregroundColor
                icon.name: AppIcons.mdi_sword
                text: qsTr("Acfun 社区管理条例")
                tip: "https://www.acfun.cn/a/ac16012740"
                onClicked: Qt.openUrlExternally(tip)
            }

            IconTextButton {
                color: AppStyle.backgroundColor
                textColor: AppStyle.foregroundColor
                icon.name: AppIcons.mdi_venmo
                text: "0.1.1 " + Global.appVer()
                tip: qsTr("App version")
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/assets/img/bk/umbrella.png"
            }
        }
    }
}
