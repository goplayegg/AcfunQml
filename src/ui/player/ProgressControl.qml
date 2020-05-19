import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:///ui/global/styles/"

Slider {
    id: control

    property int offsetX: 0
    property var slidePos: 0.0
    background.implicitHeight: 26
    horizontalPadding: 0
    from: 0.0
    to: 1.0
    value: slidePos

    states: [
        State {
            name: "SMALL"
            when: mainwindow.width < AppStyle.bp_xs
            PropertyChanges {
                target: control
                width: parent.width * 0.67
                y: parent.height - 100
//                anchors.bottomMargin: 180
            }
            AnchorChanges {
                target: control
                anchors.bottom: undefined
                anchors.horizontalCenter: parent.horizontalCenter
            }
        },
        State {
            name: "MEDIUM"
            when: mainwindow.width > AppStyle.bp_xs
                  || mainwindow.width < AppStyle.bp_lg
            PropertyChanges {
                target: control
                width: parent.width / 3
                x: parent.width / 3 + control.offsetX
            }
        },
        State {
            name: "LARGE"
            when: mainwindow.width > AppStyle.bp_lg
            PropertyChanges {
                target: control
                width: parent.width / 2
                x: parent.width / 4
            }
        }
    ]

    Behavior on x {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutBack
        }
    }
    Behavior on width {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutBack
        }
    }
}
