pragma Singleton
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/comment/"
import "qrc:///ui/components/"
import "qrc:///ui/global/styles/"

Window {
    id: control
    width: 800
    height: 600

    function open(){
        control.show()
        control.raise()
        var js ={
            contentId: "16184205"
        }

        comment.open(js)
    }

    Item {
        anchors.fill: parent

        ScrollView {
            id: scroll
            anchors.fill: parent
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
            contentHeight: comment.implicitHeight

            CommentList {
                id: comment
                width: parent.width-30
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }

        RoundButton {
            id: btnGoTop
            icon.name: AppIcons.mdi_arrow_up_thick
            size: 40
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            onClicked: {
                scroll.ScrollBar.vertical.position = 0
            }
        }
    }
}
