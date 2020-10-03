import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"

Item {
    id:root
    width: 190
    height: 110*width/190

    property var infoJs: ({})

    AutoImage {
        id: imgCover
        height: 110*width/190
        width: parent.width
        source: infoJs.coverUrl
    }

    RoundButton {
        id: btnShrink
        checkable: true
        icon.name: AppIcons.mdi_play
        size: 40
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {}
        onEntered: {}
        onExited: {}
    }
}
