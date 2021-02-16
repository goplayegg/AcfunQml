import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Image {
    id: control
    property string tag: ""
    signal clicked()

    RectBackLabelBlink {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: anchors.topMargin
        visible: tag !== ""
        text: tag
        blink: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            control.clicked()
        }
    }
}
