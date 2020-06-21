import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    id: root
    property bool customChecked: false
    property string img
    property string imgChecked

    flat: true
    width: 40
    height: width
    hoverEnabled: true
//    background: Rectangle{
//        radius: width/2
//        border.width: 1
//        border.color: "#66333333"
//    }

    Image {
        id: imgIcon
        x: 2
        y: 2
        width: 36
        height: width
        source: (customChecked || root.hovered)?imgChecked:img
        sourceSize: Qt.size(width, height)
    }

    onClicked: customChecked = !customChecked
}
