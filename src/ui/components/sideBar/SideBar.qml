import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/btn/"
//import "qrc:///ui/components" as Comp

Rectangle{
    id:root
    color: AppStyle.secondBkgroundColor
    width: shrinked?shrinkWidth:norWidth
    Behavior on width {
        NumberAnimation{ duration: 100; easing.type: Easing.OutQuad}
    }

    property alias shrinked: btnShrink.checked
    property int count: 0
    property int defaultSelIdx: 0
    property int curIdx: 0
    property int norWidth: 312
    property int shrinkWidth: 80

    function setVisible(idx, visib){
        barModel.setProperty(idx, "hide", !visib)
        var barItem = bars.itemAt(idx)
        if(!visib && barItem.checked){
            var btn = btnGroup.buttons[0]
            btn.checked = true
        }
        defaultSelIdx = btnGroup.checkedButton.idx
        timer.start()
    }

    function addItem(js){
        count++
        barModel.append(js)
        console.log(JSON.stringify(js))
    }

    function changeSelect(idx){
        console.log("SideBar selected idx:"+idx)
        var lastY = slider.y//nextY()
        curIdx = idx
        slider.newY = nextY()
        slider.newH = nextH()
        var sliderHMax = lastY - slider.newY
        if(sliderHMax<0){
            slider.maxH = -sliderHMax + slider.newH
            slider.goDown()
        }else if(0 === sliderHMax){
        }
        else{
            slider.maxH = sliderHMax + slider.newH
            slider.goUp()
        }
    }

    function nextY(){
        var curBar = bars.itemAt(curIdx)
        var pt = colBars.mapToItem(slider.parent, curBar.x, curBar.y)
        console.log("sild y:"+pt.y)
        return pt.y
    }
    function nextH(){
        var curBar = bars.itemAt(curIdx)
        return curBar.height
    }

    ButtonGroup {
        id: btnGroup
        onClicked:{
            changeSelect(button.idx)
        }
    }

    ScrollView {
        id: scroll
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: btnShrink.top
        anchors.bottomMargin: anchors.topMargin
        anchors.left: parent.left
        anchors.right: parent.right
        clip: true

        Column{
            id:colBars
            anchors.top: parent.top
            width: root.width

            ListModel{
                id:barModel
            }

            Repeater{
                id:bars
                model: barModel
                delegate: SideBarItem{
                        barJs:model
                        idx:index
                        shrinked: root.shrinked
                    }
                Component.onCompleted: {
                    var lsBtns = []
                    for(var i=0;i<count;++i){
                        var btn = itemAt(i)
                        if(btn.isBtn){
                            lsBtns.push(btn.button)
                        }
                    }
                    btnGroup.buttons = lsBtns

                    itemAt(defaultSelIdx).checked = true
                    timer.start()
                    console.log("bars onCompleted")
                }
            }
        }
    }
    Timer{
        id:timer;
        interval: 10
        onTriggered: {
            changeSelect(defaultSelIdx)
        }
    }

    SideBarSlider{
        id: slider
        onVisibleChanged: {
            if(!visible){
                btnGroup.checkedButton.leftChecked = true
            }
        }
    }

    RoundButton {
        id: btnShrink
        checkable: true
        icon.name: checked?AppIcons.mdi_chevron_double_right: AppIcons.mdi_chevron_double_left
        size: 40
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
    }
}
