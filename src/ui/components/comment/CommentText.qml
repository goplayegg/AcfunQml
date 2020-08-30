import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import AcfunQml 1.0

Column {
    id: control
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 10
    leftPadding: 10
    property alias replyTo: cmtPaser.replyToId
    property alias replyToName: cmtPaser.replyToName
    property alias contentText: cmtPaser.acFormatTxt

    TextArea {
        id: cmtText
        width: parent.width
        textFormat: Qt.RichText
        persistentSelection: true
        selectByMouse: true
        readOnly: true
        focus: true
        wrapMode: TextArea.Wrap
        font.pixelSize: AppStyle.font_xlarge
        font.family: AppStyle.fontNameMain
        font.weight: Font.Medium
        onLinkActivated:{
            console.log("open link:"+link)
            if(link.substr(link.length-4)===".gif"){
                PopImage.open(link, "gif")
            }else{
                Qt.openUrlExternally(link)
            }
        }

        AcCmtPaseAndShow {
            id: cmtPaser
            document: cmtText.textDocument
            onAddImg: {
                modelCmt.append({url:url, type:type})
            }
        }
    }

    ListModel {
        id: modelCmt
    }
    Repeater {
        id: repCmt
        model: modelCmt
        delegate: ImageWithTag {
            source: model.url
            tag: model.type === "gif"? "Gif": ""
            fillMode: Image.PreserveAspectFit
            onStatusChanged: {
                if (status === Image.Ready) {
                    if(width>control.width-control.leftPadding){
                        width = control.width-control.leftPadding
                        sourceSize.width = width
                        sourceSize.height = height
                    }
                }
            }
            onClicked: {
                console.log("open img:"+source)
                PopImage.open(source, model.type)
            }
        }
    }

    Component.onCompleted: {
        cmtPaser.parseAndShow()
    }
}
