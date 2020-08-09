import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles"

Button {
    property string tip: ""
    property color color: "#fff"
    id: control
    height: 40
    width: 46
    focusPolicy: Qt.NoFocus
    ToolTip.text: tip
    ToolTip.visible: hovered
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
    hoverEnabled: true

    contentItem:
        Text {
            text: control.text
            font.family: AppIcons.family
            font.pixelSize: 20
            color: control.color
            font.weight: Font.Light
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    background: Rectangle {
        color: "transparent"
        radius: 5
        border.color: AppStyle.secondForeColor
        border.width: control.hovered?2:0
    }
}
