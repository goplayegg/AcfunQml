import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"
import "qrc:///ui/components/btn/"

Popup {
    id: control
    background: Rectangle{
        color: AppStyle.backgroundColor
        border.color: AppStyle.thirdBkgroundColor
        border.width: 1
    }
    width: 410
    height: 120
    leftPadding: 10
    bottomPadding: 0

    Grid {
        anchors.fill: parent
        columns: 4
        columnSpacing: 10

        Repeater {
            model: ListModel{
                ListElement{text:qsTr("Favorite");color:"#fd4c5c";icon:"\uF2D1"}//AppIcons.mdi_heart cannot use script for property value
                ListElement{text:qsTr("Pocket");color:"#58a9f3";icon:"\uF41C"}//AppIcons.mdi_pocket
                ListElement{text:qsTr("Histoty");color:"#7e57c2";icon:"\uF2DA"}//AppIcons.mdi_history
                ListElement{text:qsTr("Search");color:"#ffb835";icon:"\uF349"}//AppIcons.mdi_magnify
            }
            delegate: IconTextUpDownBtn {
                id: btnFavorite
                width: 90
                height:width
                icon.name: model.icon
                text: model.text
                iconColor: model.color
                onClicked:{
                    console.log(text+" btn clicked idx:"+model.index)
                    openOtherPage(model.index)
                }
            }
        }
    }
    function openOtherPage(idx){
        control.close()
        Global.openOther(idx)
    }
}
