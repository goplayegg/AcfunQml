import QtQuick 2.12
import QtQuick.Controls 2.12

import "qrc:///ui/components/" as COM
import "qrc:///ui/global/styles/"

COM.RoundButton {
    id: volumeButton

    property var playVolume: 1.0

    icon.name: iconFromVolume(playVolume)
    color: AppStyle.primaryColor
    size: AppStyle.sm
    flat: true
    onClicked: volumePopup.open()
    onWheel: {
        var delta = (wheel.angleDelta.y / 30) / 100
        if (playVolume + delta > 1)
            return
        else if (playVolume + delta < 0)
            return
        var vol = playVolume += delta
        volumeButton.icon.name = iconFromVolume(vol)
        volumeSlider.value = vol
    }


    Popup {
        id: volumePopup

        parent: volumeButton.parent
        height: 100
        width: 36
        x: volumeButton.x - (width - volumeButton.width) / 2
        y: volumeButton.y - height

        Slider {
            id: volumeSlider

            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            background.implicitWidth: 24
            orientation: Qt.Vertical
            from: 0
            to: 1
            value: playVolume
            onMoved: {
                playVolume = value
                volumeButton.icon.name = iconFromVolume(value)
            }
        }
    }

    function iconFromVolume(vol) {
        var icon = AppIcons.mdi_volume_mute
        if (0 < vol && vol < 0.3)
            icon = AppIcons.mdi_volume_low
        else if (0.3 <= vol && vol < 0.6)
            icon = AppIcons.mdi_volume_medium
        else if (0.6 <= vol && vol <= 1)
            icon = AppIcons.mdi_volume_high

        return icon
    }
}
