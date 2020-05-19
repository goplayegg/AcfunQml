import QtQuick 2.0

Item {
    id: control

    function __contains()
    {
        var x1 = (width - padding) / 2;
        var y1 = (height - padding) / 2;
        var x2 = mouseX;
        var y2 = mouseY;
        var distanceFromCenter = Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2);
        var radiusSquared = Math.pow(Math.min(width, height) / 2, 2);
        var isWithinRadius = distanceFromCenter < radiusSquared;
        return isWithinRadius;
    }

    property real padding: 0
    property alias acceptedButtons: mouseArea.acceptedButtons
    readonly property bool containsMouse: __contains()
    readonly property bool containsPress: pressed && containsMouse
    property alias cursorShape: mouseArea.cursorShape
    property alias drag: mouseArea.drag
    property alias enabled : mouseArea.enabled
    property alias hoverEnabled: mouseArea.hoverEnabled
    property alias mouseX: mouseArea.mouseX
    property alias mouseY: mouseArea.mouseY
    property int pressAndHoldInterval : mouseArea.pressAndHoldInterval
    property alias isPressed: mouseArea.pressed
    property alias pressedButtons: mouseArea.pressedButtons
    property alias preventStealing: mouseArea.preventStealing
    property alias propagateComposedEvents: mouseArea.propagateComposedEvents
    property bool scrollGestureEnabled: mouseArea.scrollGestureEnabled

    signal canceled()
    signal clicked(var mouse)
    signal doubleClicked(var mouse)
    signal entered()
    signal exited()
    signal positionChanged(var mouse)
    signal pressAndHold(var mouse)
    signal pressed(var mouse)
    signal released(var mouse)
    signal wheel(var wheel)

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onCanceled: if(control.containsMouse) control.canceled()
        onClicked: if(control.containsMouse) control.clicked(mouse)
        onDoubleClicked: if(control.containsMouse) control.doubleClicked(mouse)
        onEntered: if(control.containsMouse) control.entered()
        onExited: if(control.containsMouse) control.exited()
        onPositionChanged: if(control.containsMouse) control.positionChanged(mouse)
        onPressAndHold: if(control.containsMouse) control.pressAndHold(mouse)
        onPressed: if(control.containsMouse) control.pressed(mouse)
        onReleased: if(control.containsMouse) control.released(mouse)
        onWheel: if(control.containsMouse) control.wheel(wheel)
    }
}
