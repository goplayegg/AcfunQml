import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"

Popup {
    id: control
    width: 250
    height: 280
    background: Rectangle {
        color: AppStyle.secondBkgroundColor
        radius: 5
    }
    property int fontSize: 18
    property int color: 0xffffff
    property alias mode: cmbMode.currentValue

    ButtonGroup {
        id: bgFontSize
        onCheckedButtonChanged: {
            control.fontSize = checkedButton.fontSize
        }
    }
    ButtonGroup {
        id: bgColor
        onCheckedButtonChanged: {
            control.color = parseInt(checkedButton.danmColor.replace("#","0x"))
        }
    }

    Column {
        anchors.fill: parent
        spacing: 10

        Label {
            text: qsTr("Font size")
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            color: AppStyle.secondForeColor
        }

        Row {
            spacing: 5
            width: parent.width
            Repeater {
                id: repFontSize
                model: [{t:qsTr("Normal"),v:25},{t:qsTr("Big"),v:37},{t:qsTr("Small"),v:18}]
                RadioButton {
                    readonly property int fontSize : modelData.v
                    id: btnNormal
                    text: modelData.t
                    checked: index === 0
                    ButtonGroup.group: bgFontSize
                }
            }
        }

        Label {
            text: qsTr("Mode")
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            color: AppStyle.secondForeColor
        }

        ComboBox {
            id: cmbMode
            width: parent.width
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            textRole: "t"
            valueRole: "v"
            model: [{t:qsTr("Fly danmaku"),v:1},{t:qsTr("Bottom danmaku"),v:4},{t:qsTr("Top danmaku"),v:5}]
        }

        Label {
            text: qsTr("Color")
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            color: AppStyle.secondForeColor
        }

        Grid {
            id: gridColor
            width: parent.width
            height: 90
            padding: 10
            topPadding: 0
            columns: 4
            rowSpacing: 12
            columnSpacing: (width-20-30)/3-30

            Repeater {
                model:  ["#ffffff","#000000","#ff0000","#00ff00","#00ffff","#ffff00","#ff00ff","#cccccc"]
                delegate: Button {
                    id: btnColor
                    width: 30
                    height: width
                    readonly property string danmColor: modelData
                    checkable: true
                    checked: index === 0
                    ButtonGroup.group: bgColor
                    background: Rectangle {
                            radius: width/2
                            color: btnColor.danmColor
                            border.width: btnColor.checked?3:0
                            border.color: (index === 1)?"#cccccc":Qt.darker(color)
                        }
                }
            }
        }
    }
}
