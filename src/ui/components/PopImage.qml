pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import Qt.labs.platform 1.0
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"

Window {
    id: control
    width: 500
    height: 300
    title: qsTr("Image")

    property string type: ""
    function open(url, type){
        control.show()
        control.raise()
        img.source = url
        control.type = type
        img.playing = true
    }

    Item {
        anchors.fill: parent

        AnimatedImage {
            id: img
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: btnSave.height/-2
            fillMode: Image.PreserveAspectFit
            onWidthChanged: {
                if(width>Screen.desktopAvailableWidth){
                    control.width = Screen.desktopAvailableWidth
                    return//bug 图片大小不合适 直接改图片width会导致下次打开无法自适应宽高
                }
                control.width = width>200?width:200
            }
            onHeightChanged: {
                if(height>Screen.desktopAvailableHeight-btnSave.height-35){
                    control.height = Screen.desktopAvailableHeight
                    return
                }
                control.height = height+btnSave.height
            }
        }

        IconTextButton {
            id: btnSave
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: AppStyle.accentColor
            textColor: AppStyle.backgroundColor
            icon.name: AppIcons.mdi_content_save
            text: qsTr("Save")
            onClicked: {
                saveDialog.open()
            }
        }
    }

    FileDialog {
        id: saveDialog
        fileMode: FileDialog.SaveFile
        defaultSuffix: control.type
        nameFilters: ["Image files (*.*)"]
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
        onAccepted: {
            console.log("save image to:"+file)
        }
    }
}
