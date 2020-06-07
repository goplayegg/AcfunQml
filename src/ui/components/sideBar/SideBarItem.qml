import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

Item {
    id: root
    property bool checked: false
    property bool leftChecked: false
    property var barJs: ({})
    property int idx: 0
    property bool isBtn: !barJs.spliter
    property var button: null
    property bool shrinked: false
    height: 45
    width: parent.width
    visible: !barJs.hide

    Component {
        id: barComp
        Button {
            id: btn
            property int idx: root.idx
            property bool leftChecked: false
            flat:true
            checkable: true
            checked: root.checked
            text: barJs.text
            icon.source: checked? barJs.iconChecked:barJs.icon
            //display:root.shrinked?AbstractButton.IconOnly:AbstractButton.TextBesideIcon
            onCheckedChanged: root.checked = checked
            onLeftCheckedChanged: root.leftChecked = leftChecked
            Component.onCompleted: {
                root.button = btn
                //console.log("btn:"+btn.text+" y:"+btn.y+" x:"+btn.x+" width:"+btn.width)
            }
            contentItem: Row{
                anchors.left: parent.left
                anchors.leftMargin: root.shrinked? (root.width-imgIcon.width)/2 : 25
                spacing: 15
                Image {
                    id: imgIcon
                    height: parent.height
                    width: height
                    source: btn.icon.source
                    ToolTip.visible: root.shrinked && hovered
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    ToolTip.text: btn.text
                }
                Text {
                    visible: !root.shrinked
                    height: parent.height
                    text: btn.text
                    font.family: AppStyle.fontNameMain
                    font.pointSize: 10
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
            }
            background: Rectangle{
                color: "transparent"
            }
        }
    }

    Component {
        id: splitComp
        Item {
            id: name
            anchors.fill: parent
            anchors.topMargin: 22
            anchors.bottomMargin: anchors.topMargin
            anchors.rightMargin: Global.sliderBarWidth*2
            anchors.leftMargin: Global.sliderBarWidth*2
            Rectangle {
                color: AppStyle.primaryColor
                anchors.fill: parent
            }
        }
    }

    Loader {
        id: barLoader
        anchors.fill: parent
        sourceComponent:barJs.spliter?splitComp:barComp
    }

    Rectangle {
        color: AppStyle.primaryColor
        //anchors.verticalCenter: parent.verticalCenter
        width: Global.sliderBarWidth
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 8
        anchors.bottomMargin: anchors.topMargin
        radius: 2
        visible: root.leftChecked
    }

    onCheckedChanged: {
        if(!root.checked){
            button.leftChecked = false
        }
    }
}
