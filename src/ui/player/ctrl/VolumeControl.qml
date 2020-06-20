import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Popup {
    id: control
    width: 300
    height: 50
    background: Rectangle {
        color: AppStyle.secondBkgroundColor
        radius: 5
    }
    property var playVolume: volumeSlider.value
    property alias mute: btnMute.checked

    Component.onCompleted: {
        console.log("xx Volume created")
    }

    MouseArea {
        anchors.fill: parent
        onWheel: {
            var tmp = volumeSlider.value
            var delta = (wheel.angleDelta.y / 24)
            if (tmp + delta > 100){
                tmp = 100
            } else if (tmp + delta < 0){
                tmp = 0
            } else{
                tmp = tmp + delta
            }
            volumeSlider.value = tmp
            btnMute.text = iconFromVolume(tmp)
        }
    }

    Row {
        anchors.fill: parent

        VideoCtrlBtn {
            id: btnMute
            y: (parent.height-height)/2
            tip: qsTr("Mute")
            text: AppIcons.mdi_volume_high
            color: "gray"
            checkable: true
            onCheckedChanged: {
                text = checked? AppIcons.mdi_volume_mute : iconFromVolume(control.playVolume)
            }
        }

        Slider {
            id: volumeSlider
            height: parent.height
            width: 188
            from: 0
            to: 100
            stepSize: 5
            value: 100
            onMoved: {
                btnMute.text = iconFromVolume(value)
            }
        }

        Label {
            text: volumeSlider.value
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment:   Text.AlignVCenter
        }
    }


    function iconFromVolume(vol) {
        var icon = AppIcons.mdi_volume_mute
        if (0 < vol && vol < 30)
            icon = AppIcons.mdi_volume_low
        else if (30 <= vol && vol < 60)
            icon = AppIcons.mdi_volume_medium
        else if (60 <= vol && vol <= 100)
            icon = AppIcons.mdi_volume_high
        if(vol !== 0){
            btnMute.checked = false
        }
        return icon
    }
}
