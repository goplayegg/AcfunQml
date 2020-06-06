import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Item{
    id:root

    function refresh(){
    }

    function back(){

    }

    ScrollView {
        id: scroll
        anchors.fill: parent

        Column{
            id:colBars
            width: parent.width
            spacing: 20

            Label {
                text: qsTr("Help & About")
                font.pixelSize: AppStyle.xlg
                font.family: AppStyle.fontNameMain
            }

            Label {
                text: qsTr("Disclaimer")
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
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
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
            }

            Label {
                text: "<a href=\"https://www.acfun.cn/u/923834\">乐音乐的乐 敌军还有30秒到达葬场</a>"
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                text: qsTr("Thanks")
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
            }

            Label {
                text: "<a href=\"https://github.com/yuriyoung/mcplayer\">麻菜 mcplayer</a>"
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                text: "<a href=\"https://github.com/jaredtao/TaoQuick\">涛哥 TaoQuick</a>"
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                text: "<a href=\"https://github.com/RSATom/QmlVlc\">RSATom QmlVlc</a>"
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                text: "<a href=\"https://github.com/qyvlik/HttpRequest\">qyvlik HttpRequest</a>"
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                text: "<a href=\"https://www.azimiao.com/5882.html\">梓喵出没</a>"
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                text: "<a href=\"https://github.com/Richasy\">云之幻</a>"
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameMain
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/assets/img/bk/umbrella.png"
            }
        }
    }
}
