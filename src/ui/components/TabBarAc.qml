import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:///ui/global/styles/"

TabBar {
    property alias model: tabModel
    property double checkedFontSize: AppStyle.font_xxxlarge
    property int checkedFontWeight: Font.ExtraBold
    property int bottomRectHei: 10
    id: tabBar
    width: parent.width
    currentIndex: 0

    ListModel {
        id: tabModel
    }
    Repeater {
        id: repChannel
        model: tabModel
        TabButton {
            id: tabBtn
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            checked: currentIndex === index
            text: model.name
            width: 20+tabText.implicitWidth
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: tabBar.height
                color: "transparent"
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    visible: tabBtn.checked
                    width: tabText.width
                    height: bottomRectHei
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
                font.pixelSize: tabBtn.checked ? checkedFontSize: AppStyle.font_xlarge
                font.weight: tabBar.checked ? checkedFontWeight :Font.Normal
                color: tabBtn.checked ? AppStyle.foregroundColor : AppStyle.secondForeColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
            }
        }
    }
}


