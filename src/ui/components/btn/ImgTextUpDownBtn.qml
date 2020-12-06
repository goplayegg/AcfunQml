import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import "qrc:///ui/global/styles/"

Button {
    id: control

    property color color: AppStyle.thirdBkgroundColor
    property color textColor: AppStyle.foregroundColor
    property string img: ""
    property string tip: ""
    height: AppStyle.md
    font.family : AppStyle.fontNameMain
    font.pixelSize: AppStyle.font_xlarge

    padding: 0
    spacing: 0
    topInset: 0
    leftInset: 2
    rightInset: 2
    bottomInset: 0
    hoverEnabled:true
    ToolTip.visible: hovered
    ToolTip.text: tip!==""?tip:control.text
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval

    contentItem: Item {
        Item {
            anchors.fill: parent
            anchors.margins: 8
            Image {
                id: imgIcon
                height: parent.height*2/3
                width: height
                source: img
                sourceSize: Qt.size(width, height)
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                anchors.top: imgIcon.bottom
                height: parent.height/3
                width: parent.width
                text: control.text
                font.family: control.font.family
                font.pixelSize: control.font.pixelSize
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: !control.enabled ? control.Material.hintTextColor : control.textColor
            }
        }
    }

    background: Rectangle {
        id: backgroundRect
        implicitHeight: control.height
        radius: 4
        color: !control.enabled ? control.Material.buttonDisabledColor
                               : /*control.checked ||*/ control.highlighted
                                ? control.Material.highlightedButtonColor
                                : control.hovered
                                ? Qt.darker(control.color, 1.2)
                                : control.color

    }
}
