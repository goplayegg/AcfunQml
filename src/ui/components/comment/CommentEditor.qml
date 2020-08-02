import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/global/"
import AcfunQml 1.0

Rectangle {
    id: control
    property var acId
    property var replyToId: 0
    property int btnHeight: 30
    property int btnWidth : 30
    color: "transparent"
    radius: 4
    border.width: 1
    border.color: AppStyle.secondForeColor
    height: cmtText.height+btns.height

    TextArea {
        id: cmtText
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100
        textFormat: TextEdit.AutoText
        wrapMode: TextArea.Wrap
        font.pixelSize: AppStyle.font_xlarge
        font.family: AppStyle.fontNameMain
        font.weight: Font.Medium
        focus: true
        selectByMouse: true
        persistentSelection: true
        leftPadding: 6
        rightPadding: 6
        topPadding: 6
        bottomPadding: 6
        background: null
    }

    DocumentHandler {
        id: document
        document: cmtText.textDocument
        cursorPosition: cmtText.cursorPosition
        selectionStart: cmtText.selectionStart
        selectionEnd: cmtText.selectionEnd
        bold: btnBold.checked
        italic: btnItalic.checked
        underline: btnUnderLine.checked
        strike: btnStrike.checked
    }
    Item {
        id: btns
        height: 40
        anchors.top: cmtText.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        Row {
            id: rowBtns
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            height: btnHeight

            IconBtn {
                id: btnBold
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_format_bold
                checkable: true
                color: checked? AppStyle.primaryColor:AppStyle.foregroundColor
                tip: qsTr("Bold")
                onClicked: {
                }
            }
            IconBtn {
                id: btnItalic
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_format_italic
                checkable: true
                color: checked? AppStyle.primaryColor:AppStyle.foregroundColor
                tip: qsTr("Italic")
                onClicked: {
                }
            }
            IconBtn {
                id: btnUnderLine
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_format_underline
                checkable: true
                color: checked? AppStyle.primaryColor:AppStyle.foregroundColor
                tip: qsTr("Underline")
                onClicked: {
                }
            }
            IconBtn {
                id: btnStrike
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_format_strikethrough_variant
                checkable: true
                color: checked? AppStyle.primaryColor:AppStyle.foregroundColor
                tip: qsTr("Strikethrough")
                onClicked: {
                }
            }
        }
        Button {
            enabled: cmtText.text.length>0
            height: btnHeight
            text: qsTr("send comment")
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            onClicked: {
                console.log("send:"+cmtText.text)
                AcService.sendComment(acId, cmtText.text, replyToId, function(res){
                    if(res.result !== 0){
                        PopMsg.showError(res, mainwindowRoot)
                        return
                    }
                    cmtText.text = ""
                })
            }
        }
    }


    Component.onCompleted: {

    }
}
