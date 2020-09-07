import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Rectangle {
    id: root
    color: "#88999999"
    width: 500
    implicitHeight: progress.implicitHeight + timeLine.implicitHeight + btnContainer.implicitHeight

    property int btnHeight: 40
    property int btnWidth : 46

    property int volume: 100
    property bool mute: false
    property var speed: cmbSpeed.model.get(cmbSpeed.currentIndex).value
    property alias paused: btnPause.checked
    property alias position: progress.value
    property alias smallWindow: btnSmall.checked
    property alias fullApp: btnFullApp.checked
    property alias fullScreen: btnFullScreen.checked
    property alias duration: labEndTm.text
    property alias timeCurrent: labCurrentTm.text

    signal changePosition(var pos)
    signal changeQuality(var type)
    property var funcQuality
    function initQuality(streams){
        var favoriteQuality = g_preference.value("favoriteVideoQuality")
        if(undefined === favoriteQuality){
            favoriteQuality = "720p"
        }

        funcQuality = undefined
        var idxToBe = 0
        cmbQuality.noFavoriteQuality = true
        modelQuality.clear()
        for(var idx in streams){
            if(favoriteQuality === streams[idx].qualityType){
                idxToBe = idx
                cmbQuality.noFavoriteQuality = false
            }
            modelQuality.append({key: streams[idx].qualityLabel, value: streams[idx].qualityType})
        }
        funcQuality = slotQualityChanged
        console.log("quality idxToBe:"+idxToBe)
        if(idxToBe !== cmbQuality.currentIndex)
            cmbQuality.currentIndex = idxToBe
        else
            slotQualityChanged(favoriteQuality)
    }
    function slotQualityChanged(currentValue){
        console.log("quality changed:"+currentValue)
        changeQuality(currentValue)
    }

    ProgressControl {
        id: progress
        anchors.top: parent.top
        width: parent.width
        implicitHeight: 33
        onPressedChanged: {
            if(!pressed)
                changePosition(value)
        }
    }

    Item {
        id: timeLine
        anchors.top: progress.bottom
        width: parent.width
        implicitHeight: labCurrentTm.height

        Label{
            id: labCurrentTm
            anchors.left: parent.left
            anchors.leftMargin: 8
            text: "00:00:00"
        }
        Label{
            id: labEndTm
            anchors.right: parent.right
            anchors.rightMargin: 8
            text: "00:00:00"
        }
    }

    Item {
        id: btnContainer
        anchors.top: timeLine.bottom
        implicitHeight: btnHeight
        width: parent.width

        Loader {
            id: voiceBar
            asynchronous: true
            source: "VolumeControl.qml"
            Connections {
                target: voiceBar.item
                function onPlayVolumeChanged(){
                    root.volume = voiceBar.item.playVolume
                }
                function onMuteChanged(){
                    root.mute = voiceBar.item.mute
                }
            }
        }

        Row {
            id: rowLeft
            anchors.left: parent.left
            height: btnHeight
            spacing: 2
            VideoCtrlBtn {
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_volume_high
                tip: qsTr("Voice")
                onClicked: {
                    voiceBar.item.open()
                }
            }
            VideoCtrlBtn {
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_vector_arrange_below
                tip: qsTr("Window")
                visible: false//TODO
            }
            ComboBox {
                property bool noFavoriteQuality: false
                id: cmbQuality
                width: 60
                textRole: "key"
                indicator: null
                model: ListModel {
                    id: modelQuality
                }
                onCurrentIndexChanged: {
                    console.log("onCurrentIndexChanged:"+currentIndex)
                    if(funcQuality){
                        var type = modelQuality.get(currentIndex).value
                        funcQuality(type)
                        if(!noFavoriteQuality)
                            g_preference.setValue("favoriteVideoQuality", type)
                    }
                }
            }
        }
        Row {
            id: rowCenter
            height: btnHeight
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2
            VideoCtrlBtn {
                id: btnPause
                height: btnHeight
                width: btnWidth
                text: checked ? AppIcons.mdi_play : AppIcons.mdi_pause
                tip: qsTr("Pause")
                checkable: true
            }
            ComboBox {
                id: cmbSpeed
                width: 50
                textRole: "key"
                currentIndex: 1
                indicator: null
                model: ListModel {
                  ListElement { key: "0.5X"; value: 0.5 }
                  ListElement { key: "1.0X"; value: 1.0 }
                  ListElement { key: "1.5X"; value: 1.5 }
                  ListElement { key: "2.0X"; value: 2.0 }
                }
            }
        }
        Row {
            id: rowRight
            height: btnHeight
            anchors.right: parent.right
            spacing: 2
            VideoCtrlBtn {
                id: btnSmall
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_image_size_select_small
                tip: qsTr("Small")
                checkable: true
                onCheckedChanged: {
                    if(checked){
                        btnFullApp.checked = false
                        btnFullScreen.checked = false
                    }
                }
            }
            VideoCtrlBtn {
                id: btnFullApp
                height: btnHeight
                width: btnWidth
                text: checked?AppIcons.mdi_fullscreen_exit:AppIcons.mdi_crop_free//mdi_fullscreen
                tip: qsTr("Full App")
                checkable: true
                onCheckedChanged: {
                    if(checked){
                        btnSmall.checked = false
                        btnFullScreen.checked = false
                    }
                }
            }
            VideoCtrlBtn {
                id: btnFullScreen
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_arrow_expand
                tip: qsTr("Full Screen")
                checkable: true
                onCheckedChanged: {
                    if(checked){
                        btnSmall.checked = false
                        btnFullApp.checked = false
                    }
                }
            }
        }
    }
}
