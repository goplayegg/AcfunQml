import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Material.impl 2.12

import "qrc:///ui/global/styles/"

RoundButton {
    id: control

    property color color: AppStyle.primaryColor
    property color textColor: outline || flat ? color : AppStyle.foregroundColor
    property bool ripple: true
    property string tooltip
    property bool outline: false
    property bool loading: false
    property bool rotate: false
    property int duration: 1200
    property real size: AppStyle.md


    padding: 0
    spacing: 0
    topInset: 0
    leftInset: 2
    rightInset: 2
    bottomInset: 0
    ToolTip.visible: hovered && tooltip.length > 0
    ToolTip.text: tooltip
    Material.background: (flat || outline) && enabled ? AppStyle.transparent : color
    Material.elevation: flat || outline ? down || hovered ? 2 : 0 : down ? 12 : 6

    signal wheel(var wheel)

    RoundMouseArea {
        id: roundMouse

        propagateComposedEvents: true
        anchors.fill: parent
        padding: control.padding
        onClicked: mouse.accepted = !containsMouse
        onDoubleClicked: mouse.accepted = !containsMouse
        onPressed: mouse.accepted = !containsMouse
        onReleased: mouse.accepted = !containsMouse
        onPressAndHold: mouse.accepted = !containsMouse
        onWheel: { control.wheel(wheel); wheel.accepted = !containsMouse }
    }

    contentItem: Text {
        id: buttonContent
        anchors.centerIn: parent
        text: loading ? AppIcons.mdi_loading : (control.text.length > 0 ? control.text.substring(0,1) : control.icon.name)
        font.family:  control.text.length > 0 ? control.font.family : AppIcons.family
        font.pixelSize: size / 1.5
        font.weight: Font.Light
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: !control.enabled ? control.Material.hintTextColor : control.textColor

        RotationAnimation on rotation {
            running: control.rotate
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: control.duration
            onStopped: buttonContent.rotation = 0
        }
    }

    background: Rectangle {
        id: backgroundRect

        implicitWidth: control.size
        implicitHeight: control.size
        radius: control.radius
        color: !control.enabled ? control.Material.buttonDisabledColor
                               : control.checked || control.highlighted
                                ? control.Material.highlightedButtonColor
                                : control.Material.buttonColor
        layer.enabled: control.enabled && control.Material.buttonColor.a > 0
        layer.effect: ElevationEffect {
            elevation: control.Material.elevation
        }

        Rectangle {
            id: outlineRect
            visible: outline
            width: parent.width
            height: parent.height
            radius: control.radius
            color: "transparent"
            border.width: 1
            border.color: !control.enabled ? control.Material.buttonDisabledColor
                                          : control.color
        }

        Ripple {
            id: ripple

            readonly property color _rippleColor: control.flat || control.outline ? control.textColor : "white"
            readonly property real _opacity: control.flat || control.outline ? 0.18 : 0.3
            readonly property real _distance: Math.sqrt(2) * (parent.height / 2)

            visible: control.ripple
            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
            clip: false
            clipRadius: 0
            width: _distance
            height: _distance
            pressed: control.pressed
            anchor: control
            active: (control.hovered || control.visualFocus || control.down)  && roundMouse.containsMouse
            color: Qt.rgba(_rippleColor.r, _rippleColor.g,
                           _rippleColor.b, _opacity)
        }
    } // background
} // RoundButton
