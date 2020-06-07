import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import "qrc:///ui/global/styles/"

Button {
    id: control

    property color color: AppStyle.primaryColor
    property color textColor: AppStyle.backgroundColor
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

    contentItem: Row {
        id: rowContent
        leftPadding: 10
        rightPadding: 10
        spacing: 8
        Image {
            height: parent.height/1.2
            width: height
            source: img
            sourceSize: Qt.size(width, height)
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            height: parent.height
            text: control.text
            font.family: control.font.family
            font.pixelSize: control.font.pixelSize
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: !control.enabled ? control.Material.hintTextColor : control.textColor
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
