import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:///ui/global/styles/"

TabBar {
    property alias model: tabModel
    id: tabBar
    width: parent.width

    ListModel {
        id: tabModel
    }
    Repeater {
        id: repChannel
        model: tabModel
        TabButton {
            id: tabBtn
            text: model.name
            width: 20+tabText.implicitWidth
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40
                color: "transparent"
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    visible: tabBtn.checked
                    width: tabText.width
                    height: 10
                    radius: height/2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop {position: 0.0; color: "#ffff0000"}
                        GradientStop {position: 1.0; color: "#05ff0000"}
                    }
                }
            }
            contentItem: Text {
                id: tabText
                text: tabBtn.text
                font.family: AppStyle.fontNameMain
                font.pixelSize: tabBtn.checked ? AppStyle.font_xxxlarge: AppStyle.font_xlarge
                font.weight: tabBar.checked ? Font.ExtraBold :Font.Normal
                color: tabBtn.checked ? AppStyle.foregroundColor : AppStyle.secondForeColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
            }
        }
    }
}


