﻿import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/btn/"

Item {
    id:root

    property alias backEnable: btnBack.enabled
    signal back();
    signal refresh();
    signal search(var keyword);
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
        id: searchInput
        property var recommendKeywords:[]
        height: parent.height
        width: 300
        placeholderText: qsTr("Search")
        selectByMouse: true
        anchors.left: btnBack.right
        anchors.leftMargin: 20
        onAccepted: {
            search(searchInput.text)
        }
        RoundButton {
            id: btnSearch
            visible: parent.text !== ""
            icon.name: AppIcons.mdi_magnify
            size: parent.height*3/4
            textColor: AppStyle.foregroundColor
            anchors.right: btnClear.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            onClicked: search(searchInput.text)
        }
        RoundButton {
            id: btnClear
            visible: parent.text !== ""
            icon.name: AppIcons.mdi_close_circle_outline
            size: btnSearch.size
            textColor: AppStyle.foregroundColor
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
            onClicked: parent.text = ""
        }
    }

    BusyRoundBtn {
        id: btnRefresh
        size: root.height
        anchors.right: parent.right
        onClicked: refresh()
    }

    Component.onCompleted: {
        AcService.getSearchRecommend(function(res){
            if(0 !== res.result){
                return
            }
            var keys = ""
            for(var idx in res.searchKeywords){
                console.log("key search word:"+idx+res.searchKeywords[idx].keyword)
                searchInput.recommendKeywords.push(res.searchKeywords[idx].keyword)
                if(idx == 0){
                    keys = res.searchKeywords[idx].keyword
                }else if(idx<3){
                    keys += "," + res.searchKeywords[idx].keyword
                }
            }
            searchInput.placeholderText = keys
        })
    }
}
