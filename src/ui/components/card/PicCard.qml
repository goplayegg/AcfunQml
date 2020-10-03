//图片自动布局 最多9宫格
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15
import "qrc:///ui/components/"

GridLayout {
    id: control
    width: 300
    columnSpacing: 2
    rowSpacing: 2

    property var imgs: []
    Repeater {
        model: ListModel {
            id: modelImg
        }
        AutoImage {
            id: img
            source: model.info.url
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                console.log("clicked:"+model.index)
                var idx = model.info.originUrl.lastIndexOf(".")
                PopImage.open(model.info.originUrl, model.info.originUrl.substring(idx+1))
            }
        }
    }

    Component.onCompleted: {
        var sz = imgs.length
        console.log("picCard img num:"+sz)
        var col = 0
        var row = 1
        if(sz <= 3)
            col = sz
        else if(4 === sz){
            col = 2
            row = 2
        }else if(sz >= 5){
            col = 3
            row = 2
            if(sz >= 7)
                row = 3
        }
        control.columns = col
        control.rows = row
        control.height = col>0 ? control.width*row/col : 0
        for(var idx in imgs){
            modelImg.append({"info": imgs[idx]})
        }
    }
}
