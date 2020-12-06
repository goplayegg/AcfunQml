import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"
import "qrc:///ui/components/btn/"

Popup {
    id: control
    //anchors.centerIn: parent
    background: Rectangle{
        color: AppStyle.backgroundColor
        border.color: AppStyle.thirdBkgroundColor
        border.width: 1
    }
    width: 310
    height: 120
    leftPadding: 10
    bottomPadding: 0

    Grid {
        anchors.fill: parent
        columns: 3
        columnSpacing: 10

        IconTextUpDownBtn {
            id: btnFavorite
            width: 90
            height:width
            icon.name: AppIcons.mdi_heart
            text: qsTr("Favorite")
            iconColor: "#fd4c5c"
            onClicked:{
                console.log("btnFavorite")
            }
        }
        IconTextUpDownBtn {
            id: btnPocket
            width: 90
            height:width
            icon.name: AppIcons.mdi_pocket
            text: qsTr("Pocket")
            iconColor: "#58a9f3"
            onClicked:{
                console.log("mdi_pocket")
            }
        }
        IconTextUpDownBtn {
            id: btnHistoty
            width: 90
            height:width
            icon.name: AppIcons.mdi_history
            text: qsTr("Histoty")
            iconColor: "#7e57c2"
            onClicked:{
                console.log("btnHistoty")
            }
        }
    }
}
