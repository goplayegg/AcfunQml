pragma Singleton
import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components" as Comp

Rectangle {
    id: control
    anchors.centerIn: parent
    width: 180
    height: 180
    z: AppStyle.msgZ
    radius: 5
    visible: false
    color: AppStyle.secondBkgroundColor
    border.color: AppStyle.thirdBkgroundColor
    border.width: 1
    property string text: qsTr("error")

    function showError(result, parent){
        control.parent = parent
        if(result.error_msg){
            control.text = result.error_msg
        }else if(result.message){
            control.text = result.message
        }else{
            control.text = qsTr("error")
        }
        control.visible = true
    }

    Label {
        id: laIcon
        anchors.top: btnClose.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        text: AppIcons.mdi_alert_circle
        color: AppStyle.primaryColor
        font.weight: Font.Bold
        font.pixelSize: AppStyle.font_xxxxlarge
        font.family: AppIcons.family
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Label {
        anchors.top: laIcon.bottom
        anchors.topMargin: 20
        width: parent.width
        text: control.text
        font.pixelSize: AppStyle.font_large
        font.family: AppStyle.fontNameMain
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Comp.RoundButton {
        id: btnClose
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8
        icon.name: AppIcons.mdi_close
        onClicked: {
            control.visible = false
        }
    }
}
