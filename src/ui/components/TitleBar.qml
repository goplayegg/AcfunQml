import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle {
    property var parentWindow
    property alias hoverEnabled: content.hoverEnabled
    property alias hovered: content.containsMouse
    id: control
    height: 25
    width: parent.width

    MouseArea {
        id: content
        property point pressedPos: "1,1"
        anchors.fill: parent
        onPressed: {
            pressedPos = Qt.point(mouse.x, mouse.y);
        }
        onPositionChanged: {
            if(!parentWindow || !pressed){
                return
            }

            var delta = Qt.point(mouse.x - pressedPos.x, mouse.y - pressedPos.y);
            parentWindow.x += delta.x;
            parentWindow.y += delta.y;
        }
    }
}

