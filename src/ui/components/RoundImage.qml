import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Item {
    id: control
    property alias size: control.width
    property alias source: image.source
    signal clicked();

    height: width
    implicitWidth: 48
    implicitHeight: 48
    Image {
        id: image

        sourceSize: Qt.size(parent.width, parent.height)
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: false
    }

    Rectangle {
        id: maskRect

        anchors.fill: parent
        radius: Math.max(width / 2, height / 2)
        smooth: true
        visible: false
    }

    OpacityMask {
        anchors.fill: maskRect
        maskSource: maskRect
        source: image
    }

    RoundMouseArea {
        propagateComposedEvents: true
        anchors.fill: parent
        onClicked: {
            control.clicked()
        }
    }
}
