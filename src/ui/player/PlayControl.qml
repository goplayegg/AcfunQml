import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:///ui/components/" as COM
import "qrc:///ui/global/styles/"

COM.RoundButton {
    id: control
    property var playing:false

    signal playChanged(var play);

    icon.name: playing ? AppIcons.mdi_play : AppIcons.mdi_pause
    textColor: "white"
    size: AppStyle.md
    color: AppStyle.accentColor
    onClicked: {
        playing = !playing
        console.log("paly changed:" + playing)
        playChanged(playing);
    }

    states: [
        State {
            name: "SMALL"
            when: mainwindow.width < AppStyle.bp_xs
            PropertyChanges {
                target: control
                anchors.leftMargin: 24
                anchors.topMargin: 24

            }
            AnchorChanges {
                target: control
                anchors.bottom: undefined
                anchors.top: playbackProgress.bottom
                anchors.left: playbackProgress.left
            }
        }
    ]

    Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }
}
