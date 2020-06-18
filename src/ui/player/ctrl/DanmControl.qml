import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Rectangle {
    id: root
    color: AppStyle.backgroundColor
    implicitHeight: btnHeight

    readonly property int btnHeight: 40
    readonly property int btnWidth : 55

    property alias danmakuClosed: btnSwitch.checked
    signal clickBanana()
    signal sendDanm(var danmJson)

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
            }
        }
        VideoCtrlBtn {
            height: btnHeight
            width: btnWidth
            hoverEnabled: false
            color: AppStyle.secondForeColor
            text: AppIcons.mdi_format_color_text
            tip: qsTr("Danmaku send option")
            onClicked: {
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
                    mode:1,
                    color:16777215,
                    size:25,
                    type:"douga",
                    subChannelId:190,
                    subChannelName:""
                }
                root.sendDanm(danmJson)
            }
        }
    }
}
