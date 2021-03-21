import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import "qrc:///ui/global/styles/"

Button {
    id: control

    property color color: AppStyle.primaryColor
    property color textColor: AppStyle.backgroundColor
    property color iconColor: textColor
    property string tip: ""
    property alias radius: backgroundRect.radius
    height: AppStyle.md
    width: AppStyle.xxxlg
    font.family : AppStyle.fontNameMain
    font.pixelSize: AppStyle.font_xlarge

    padding: 0
    spacing: 0
    topInset: 0
    leftInset: 0
    rightInset: 0
    bottomInset: 0
    hoverEnabled:true
    ToolTip.visible: hovered
    ToolTip.text: tip!==""?tip:control.text
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval

    contentItem: Item {
        Row {
            spacing: 4
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: txIcon
                height: parent.height
                text: control.icon.name
                font.family: AppIcons.family
                font.pixelSize: control.height / 1.5
                font.weight: Font.Light
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: !control.enabled ? control.Material.hintTextColor : control.iconColor
            }
            Text {
                id: txText
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
