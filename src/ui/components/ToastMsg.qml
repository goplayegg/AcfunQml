import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Rectangle {
    id: control
    visible: false
    width: tipLabel.width+tipLabel.x*2
    height: tipLabel.height+tipLabel.y*2
    color: AppStyle.accentColor
    z: AppStyle.msgZ
    radius: 5
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: marginHiding

    property int marginHiding: 3
    property int marginTiping: 50
    property int animDuration: 600
    property int freezeDuration: 2000
    property int marginEasType: Easing.OutCubic
    property string text: ""

    Behavior on anchors.bottomMargin {
        NumberAnimation {duration: animDuration; easing.type: marginEasType;}
    }
    Behavior on opacity {
        NumberAnimation {duration: animDuration}
    }
    SequentialAnimation {
        id: tipAnima
        ScriptAction{script: {marginEasType = Easing.OutCubic; control.anchors.bottomMargin = marginTiping; control.opacity = 1}}
        NumberAnimation {duration: freezeDuration}
        ScriptAction{script: {marginEasType = Easing.InQuad; control.anchors.bottomMargin = marginHiding; control.opacity = 0}}
        NumberAnimation {duration: animDuration}
        onFinished: control.visible = false
    }

    function showTip(tip){
        control.text = tip
        control.visible = true
        control.anchors.bottomMargin = marginHiding
        control.opacity = 0
        tipAnima.restart()
        console.log("showTip:"+tip)
    }

    Label {
        id: tipLabel
        x: 10
        y: 5
        text: control.text
        color: "#fff"
        font.pixelSize: AppStyle.font_xlarge
        font.family: AppStyle.fontNameMain
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
