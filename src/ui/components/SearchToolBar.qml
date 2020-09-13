import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/btn/"

Item {
    id:root

    property alias backEnable: btnBack.enabled
    signal back();
    signal refresh();
    height: 40
    RoundButton {
        id: btnBack
        icon.name: AppIcons.mdi_chevron_left
        tooltip: qsTr("back")
        size: parent.height
        textColor: AppStyle.accentColor
        anchors.left: parent.left
        onClicked: back()
    }

    TextField {
        id: search
        height: parent.height
        width: 300
        placeholderText: qsTr("Search")
        selectByMouse: true
        anchors.left: btnBack.right
        anchors.leftMargin: 20
        onAccepted: {
            AcService.getSearchRecommend(function(res){
                if(0 !== res.result){
                    return
                }
                for(var idx in res.searchKeywords){
                    console.log("key search word:"+res.searchKeywords[idx].keyword)
                }
            })
            AcService.search(search.text, 0, function(res){

            })
        }
    }

    RoundButton {
        id: btnRefresh
        icon.name: AppIcons.mdi_refresh
        tooltip: qsTr("refresh")
        size: root.height
        textColor: AppStyle.accentColor
        anchors.right: parent.right
        onClicked: refresh()
    }
}
