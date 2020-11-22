//目前废弃这个实现方式
import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import AcfunQml 1.0

Flow {
    id: control
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: 20
    leftPadding: 10
    property alias replyTo: docHandler.replyToId
    property alias replyToName: docHandler.replyToName
    property alias contentText: docHandler.acFormatTxt

    onContentTextChanged: {
        console.log(contentText)
    }

    AcCommentPaser {
        id: docHandler
        onError: {
            console.log("doc err:"+message)
        }
        onAddSegment: {
//            if("txt"===type)
//                return
//            if("gif"===type)
//                return
            modelCmtSegment.append({type:type, source:source});
        }
    }
    ListModel {
        id: modelCmtSegment
    }
    Repeater {
        id: repCmtSegment
        model: modelCmtSegment

        delegate: Item {
            id: deleCmt
            property var segInfo: model
            Component{
                id: cmpTxt
                TextArea {
                    id: textArea
                    leftPadding: 0
                    textFormat: Qt.RichText
                    persistentSelection: true
                    selectByMouse: true
                    readOnly: true
                    focus: true
                    wrapMode: TextArea.Wrap
                    font.pixelSize: AppStyle.font_xlarge
                    font.family: AppStyle.fontNameMain
                    font.weight: Font.Medium
                    Component.onCompleted: {
                        txtHand.document = textArea.textDocument
                        txtHand.txtJson = segInfo.source
                        //console.log("TextArea document 55555555")
                    }
                    TextDocHandler{
                        id: txtHand
                    }
                    onLinkActivated:{
                        console.log("open link:"+link)
                        Qt.openUrlExternally(link)
                    }
                }
            }
            Component{
                id: cmpGif
                AnimatedImage {
                    source: segInfo.source
                    onWidthChanged: deleCmt.implicitWidth = width
                    onHeightChanged: deleCmt.implicitHeight = height
                }
            }
            Component{
                id: cmpImg
                Image {
                    source: segInfo.source
                    fillMode: Image.PreserveAspectFit
                    onStatusChanged: {
                        if (status === Image.Ready) {
                            if(width>control.width-control.leftPadding)
                                width = control.width-control.leftPadding
                            deleCmt.implicitWidth = width
                            deleCmt.implicitHeight = height
                        }
                    }
                }
            }
            Loader {
                id: barLoader
                sourceComponent: {
                    if(segInfo.type === "txt")
                        return cmpTxt;
                    if(segInfo.type === "gif")
                        return cmpGif;
                    if(segInfo.type === "img")
                        return cmpImg;
                    return cmpTxt;
                }
                onLoaded: {
                    if(segInfo.type === "txt"){
                        deleCmt.implicitWidth = barLoader.width
                        deleCmt.implicitHeight = barLoader.height
                    }
                }
            }
        }
    }
}
