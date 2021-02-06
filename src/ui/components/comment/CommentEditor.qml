import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.platform 1.0
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/components/emot"
import "qrc:///ui/global/"
import AcfunQml 1.0

Rectangle {
    id: control
    property var acId
    property int resourceType: 3
    property var replyToId: 0
    property var replyToName: ""
    property bool replySubCmt: false//回复子串编辑状态

    property int btnHeight: 30
    property int btnWidth : 30

    color: "transparent"
    radius: 4
    border.width: 1
    border.color: AppStyle.secondForeColor
    height: cmtItem.height+btns.height
    onParentChanged: {
        cmtText.focus = true
    }

    function reset(){
        replyToId = 0
        replyToName = ""
        replySubCmt = false
    }
    function clear(){
        cmtText.text = ""
    }
    function focusInEdit(){
        cmtText.focus = true//外侧的窗口(Popup)也必须设置focus true 否则不生效
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            cmtText.focus = true
        }
    }

    Item {
        id: cmtItem
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100>cmtText.height?100:cmtText.height
        TextArea {
            id: cmtText
            anchors.left: parent.left
            anchors.right: parent.right
            placeholderText: replySubCmt?(qsTr("Reply")+" @"+replyToName):(qsTr("评论一时爽，一直评论一直爽。")+"\r\n\r\n\r\n")
            textFormat: TextEdit.AutoText
            wrapMode: TextArea.Wrap
            font.pixelSize: AppStyle.font_xlarge
            font.family: AppStyle.fontNameMain
            font.weight: Font.Medium
            selectByMouse: true
            persistentSelection: true
            leftPadding: 6
            rightPadding: 6
            topPadding: 6
            bottomPadding: 6
            background: null
        }
    }

    ColorDialog {
        id: dlgColor
        currentColor: "black"
    }

    DocumentHandler {
        id: document
        textColor: dlgColor.color
        document: cmtText.textDocument
        cursorPosition: cmtText.cursorPosition
        selectionStart: cmtText.selectionStart
        selectionEnd: cmtText.selectionEnd
    }

    Item {
        id: btns
        height: 40
        anchors.top: cmtItem.bottom
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
                checked: document.bold
                onClicked: document.bold = !document.bold
                color: checked? AppStyle.primaryColor:AppStyle.foregroundColor
                tip: qsTr("Bold")
            }
            IconBtn {
                id: btnItalic
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_format_italic
                checkable: true
                checked: document.italic
                onClicked: document.italic = !document.italic
                color: checked? AppStyle.primaryColor:AppStyle.foregroundColor
                tip: qsTr("Italic")
            }
            IconBtn {
                id: btnUnderLine
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_format_underline
                checkable: true
                checked: document.underline
                onClicked: document.underline = !document.underline
                color: checked? AppStyle.primaryColor:AppStyle.foregroundColor
                tip: qsTr("Underline")
            }
            IconBtn {
                id: btnStrike
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_format_strikethrough_variant
                checkable: true
                checked: document.strike
                onClicked: document.strike = !document.strike
                color: checked? AppStyle.primaryColor:AppStyle.foregroundColor
                tip: qsTr("Strike")
            }
            IconBtn {
                id: btnTextColor
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_format_color_text
                color: AppStyle.foregroundColor
                onClicked: dlgColor.open()
                tip: qsTr("Color")

                Rectangle {
                    width: aFontMetrics.width + 3
                    height: 2
                    color: document.textColor
                    parent: btnTextColor.contentItem
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.baseline: parent.baseline
                    anchors.baselineOffset: 6
                    TextMetrics {
                        id: aFontMetrics
                        font: btnTextColor.font
                        text: btnTextColor.text
                    }
                }
            }
            IconBtn {
                id: btnEmot
                height: btnHeight
                width: btnWidth
                text: AppIcons.mdi_emoticon_outline
                color: AppStyle.foregroundColor
                tip: qsTr("Emotion")
                onClicked: {
                    PopEmot.parent = control
                    PopEmot.callBk = inputEmot
                    PopEmot.open()
                }
            }
        }
        Button {
            enabled: cmtText.text.length>0
            height: btnHeight
            text: qsTr("Send comment")
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            onClicked: {
                console.log("send:"+cmtText.text)
                var accmt = document.getAcCmt()
                //return;
                AcService.sendComment(acId, resourceType, accmt, replyToId, function(res){
                    if(res.result !== 0){
                        PopMsg.showError(res, mainwindowRoot)
                        return
                    }
                    cmtText.text = ""
                    toastMsg.showTip("评论成功")
                })
            }
        }
    }

    function inputEmot(eid){
        console.log("input emot:"+eid)
        document.addEmot(eid)
    }
}
