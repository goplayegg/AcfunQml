import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Rectangle {
    id: root
    color: AppStyle.backgroundColor
    implicitHeight: btnHeight

    readonly property int btnHeight: 40
    readonly property int btnWidth : 55

    property var danmOpacity: 1.0
    property alias danmakuClosed: btnSwitch.checked
    signal clickBanana()
    signal sendDanm(var danmJson)

    function clearInput(){
        msg.text = ""
    }

    Row {
        anchors.fill: parent
        spacing: 2
        VideoCtrlBtn {
            id: btnSwitch
            height: btnHeight
            width: btnWidth
            hoverEnabled: false
            color: AppStyle.secondForeColor
            text: checked?AppIcons.mdi_card_bulleted_off_outline:AppIcons.mdi_card_bulleted_outline
            tip: qsTr("Danmaku switch")
            checkable: true
        }
        VideoCtrlBtn {
            height: btnHeight
            width: btnWidth
            hoverEnabled: false
            color: AppStyle.secondForeColor
            text: AppIcons.mdi_tune_vertical
            tip: qsTr("Danmaku display")
            onClicked: {
                var pt = mapToItem(root, width/2, 0)
                danmShowOpt.item.x = pt.x-danmShowOpt.item.width/2
                danmShowOpt.item.y = pt.y-danmShowOpt.item.height
                danmShowOpt.item.open()
            }
        }
        VideoCtrlBtn {
            id: btnSendOpt
            height: btnHeight
            width: btnWidth
            hoverEnabled: false
            color: AppStyle.secondForeColor
            text: AppIcons.mdi_format_color_text
            tip: qsTr("Danmaku send option")
            onClicked: {
                var pt = btnSendOpt.mapToItem(root, btnSendOpt.width/2, 0)
                danmSendOpt.item.x = pt.x-danmSendOpt.item.width/2
                danmSendOpt.item.y = pt.y-danmSendOpt.item.height
                danmSendOpt.item.open()
            }
        }
        TextField {
            id: msg
            height: btnHeight
            width: parent.width-(btnWidth+parent.spacing)*6
            placeholderText: qsTr("Acfun 认真你就输了 (つд⊂)")
        }
        Image {
            height: 32
            y: (btnHeight-32)/2
            width: btnWidth*2
            source: "qrc:/assets/img/common/btnBanana.png"
            MouseArea {
                anchors.fill: parent
                onClicked: clickBanana()
            }
        }
        VideoCtrlBtn {
            height: btnHeight
            width: btnWidth
            hoverEnabled: false
            color: AppStyle.secondForeColor
            text: AppIcons.mdi_telegram
            tip: qsTr("Send")
            onClicked: {
                if(msg.text.length === 0){
                    return
                }
                var danmJson = {
                    body: msg.text,
                    videoId:0,
                    position:0,
                    id:0,
                    mode: danmSendOpt.item.mode,
                    color: danmSendOpt.item.color,
                    size: danmSendOpt.item.fontSize,
                    type:"douga",
                    subChannelId:190,
                    subChannelName:""
                }
                root.sendDanm(danmJson)
            }
        }
    }

    Loader {
        id: danmSendOpt
        asynchronous: true
        source: "DanmSendOption.qml"
    }

    Loader {
        id: danmShowOpt
        asynchronous: true
        source: "DanmShowOption.qml"
        Connections {
            target: danmShowOpt.item
            function  onDanmOpacityChanged() {
                root.danmOpacity = danmShowOpt.item.danmOpacity
            }
        }
    }
}
