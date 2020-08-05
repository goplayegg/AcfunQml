pragma Singleton
import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"

Popup {
    property var callBk//function (emotID)
    id: control
    anchors.centerIn: parent
    background: Rectangle{
        color: AppStyle.backgroundColor
        border.color: AppStyle.thirdBkgroundColor
        border.width: 1
    }
    width: 500
    height: 400
    bottomPadding: 0

    function changePack(idx){
        emotModel.clear();
        var packs = Global.emotPacks();
        var pack = packs.packs[idx];
        labTitle.text = pack.name;
        console.log("change pack idx:"+idx +pack.name)
        var emots = pack.emots;
        for(var i in emots){
            //console.log("emots[i].id:"+emots[i].id)
            emotModel.append({
                                 eid: emots[i].id,
                                 name: emots[i].name,
                                 type: emots[i].type
                             });
        }
    }
    contentItem: Item {
        id: content

        Label {
            id: labTitle
            y: 20
            text: "ac娘"
        }

        Component.onCompleted: {
            var packsObj = Global.emotPacks();
            var packs = packsObj.packs;
            console.log("packs.len"+packs.length)
            for(var i in packs){
                packModel.append({
                                     id: packs[i].id,
                                     name: packs[i].name
                                 });
            }
        }
        ListModel {
            id: packModel
        }

        TabBar {
            id: tabBar//表情类别tab按钮组
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            width: parent.width
            Repeater {
                model: packModel
                TabButton {
                    property string pid: model.id
                    id: tabBtn
                    ToolTip.visible: hovered
                    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                    ToolTip.text: model.name
                    hoverEnabled: true
                    background: Rectangle {
                        implicitHeight: 50
                        implicitWidth: 70
                        color: tabBtn.hovered?AppStyle.thirdBkgroundColor:
                                               tabBtn.checked?AppStyle.backgroundColor:
                                                               AppStyle.secondBkgroundColor
                    }
                    contentItem: Item {
                        id: mouseArea
                        Image {
                            source: "qrc:/assets/img/emot/"+tabBtn.pid +".png"
                            anchors.centerIn: parent
                            height: 35
                            width: height
                        }
                    }
                }
            }
            onCurrentIndexChanged: {
                if(currentIndex >= 0)
                    changePack(currentIndex)
            }
        }


        ListModel {
            id: emotModel
        }

        GridView {
            id: cardView//表情列表
            anchors {
                margins: 0
                topMargin: 10
                top: labTitle.bottom
                left: parent.left
                right: parent.right
                bottom: tabBar.top
            }
            clip: true
            cellWidth: 75
            cellHeight: cellWidth
            ScrollBar.vertical : ScrollBar{
                id: scrollbar
                anchors.right: cardView.right
                y: cardView.visibleArea.yPosition * cardView.height
                width: 10
                height: cardView.visibleArea.heightRatio * cardView.height
            }

            model:  emotModel
            delegate: Rectangle {
                id: rect
                width: 75
                height: width
                property string eid: model.eid
                property int type:model.type
                color: mouse.containsMouse?AppStyle.thirdBkgroundColor:
                                            AppStyle.backgroundColor

                Image {
                    id: img
                    anchors.centerIn: parent
                    source: "qrc:/assets/img/emot/"+rect.eid + ((2===rect.type)?".png":".gif")
                    width: 65
                    height: width
                }
                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        control.close()
                        if(callBk){
                            callBk(rect.eid)
                        }
                    }
                }
            }
        }
    }
}
