pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import Qt.labs.platform 1.0
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"
import "qrc:///ui/components/btn/"

Window {
    id: control
    width: 500
    height: 300
    title: qsTr("Image")

    onClosing: {
        img.source = ""
        imgBig.source = ""
    }

    property string type: ""
    function open(url, type){
        imgBig.visible = false
        imgBig.source = ""
        showNormal()
        control.show()
        control.raise()
        img.source = url
        control.type = type
        img.playing = true
    }

    Item {
        id: imgParent
        anchors.fill: parent
        AnimatedImage {
            id: img
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: btnSave.height/-2
            fillMode: Image.PreserveAspectFit
            onWidthChanged: {
                if(0 === width)
                    return
                if(width>Screen.desktopAvailableWidth){
                    imgBig.widthFixed = false
                    imgBig.source = source
                    imgBig.visible = true
                    return
                }
                control.width = width>200?width:200
            }
            onHeightChanged: {
                if(0 === height)
                    return
                if(height>Screen.desktopAvailableHeight-btnSave.height-35){
                    imgBig.widthFixed = false
                    imgBig.source = source
                    imgBig.visible = true
                    return
                }
                control.height = height+btnSave.height
            }
        }
        AnimatedImage {
            id: imgBig
            property bool widthFixed: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: btnSave.height/-2
            fillMode: Image.PreserveAspectFit
            onSourceChanged: img.source = ""
            onWidthChanged: {
                if(widthFixed)
                    return
                widthFixed = true
                console.log("wid:"+width+" hei:"+height)
                control.showMaximized()
                var hwRadio = height*1.0/width
                var shwRadio = Screen.desktopAvailableHeight*1.0/Screen.desktopAvailableWidth
                if(hwRadio>shwRadio){//图片很高啊
                    height = Screen.desktopAvailableHeight
                }else{//图片很胖哎
                    width = Screen.desktopAvailableWidth
                }
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
        nameFilters: ["Image files (*."+control.type+")"]
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
        onAccepted: {
            g_fileSaver.saveImg(img.source==""?imgBig.source:img.source, file)
        }
    }
    Connections {
        target: g_fileSaver
        function onFinished(succ) {
            toastMsg.showTip(succ?qsTr("Saved."):qsTr("Save failed."))
        }
    }
    Loader {
        asynchronous: true
        ToastMsg {
            parent: imgParent
            id: toastMsg
        }
    }
}
