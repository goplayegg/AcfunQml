import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Popup {
    id: control
    width: 250
    height: 100
    background: Rectangle {
        color: AppStyle.secondBkgroundColor
        radius: 5
    }
    property alias danmOpacity: opacitySlider.value

    Column {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 5
        Label {
            width: parent.width
            text: qsTr("Danmaku opacity")
            verticalAlignment:   Text.AlignVCenter
        }
        Slider {
            id: opacitySlider
            height: parent.height
            width: parent.width
            from: 0.0
            to: 1.0
            value: 1.0
            stepSize: 0.1
        }
    }
}
