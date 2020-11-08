import QtQuick 2.0

Item {
    id: control
    property int cardWidth : 200
    property alias model: rep.model//call control.clear(), dont call model.clear() outside
    property alias delegate: rep.delegate
    property int rowSpacing: 8
    property int colSpacing: 8
    property bool reLayouting: false
    property bool manuallyReLayout: false
    property int layoutedMaxIdx: 0
    implicitHeight: rep.maxHeight

    function clear(){
        rep.maxHeight = 0
        rep.colsHeightArr = []
        rep.itemsInRep = []
        model.clear()
        layoutedMaxIdx = -1
    }
    function reLayout(idx = 0){
        rep.reLayoutWF(idx)
    }

    Repeater {
        id: rep
        property int cellWidth : cardWidth+rowSpacing
        property int colCount: {
            var cols = parseInt(control.width/cellWidth)
            return cols>0?cols:1
        }
        property var colsHeightArr: []//每列当前的高度
        property int maxHeight: 0
        property var itemsInRep: []
        onItemAdded:  {//(int index, Item item)
            if(!manuallyReLayout)
                addToFall(index, item)
            itemsInRep.push(item)
        }
        onItemRemoved: { //(int index, Item item)
            //TODO
        }

        onColCountChanged: {
            reLayoutWF(0)
        }
        function reLayoutWF(idx){
            reLayouting = true
            console.log("waterfall width:"+control.width + "\r\ncolCount:"+ colCount)
            if(0 === idx)
                rep.colsHeightArr = []
            var count = itemsInRep.length//rep.count
            for(var i=idx; i<count; ++i){
                //addToFall(i, rep.itemAt(i))
                addToFall(i, itemsInRep[i])
            }
            reLayouting = false
        }

        function addToFall(index, item){
            //console.log("addToFall item hei:"+item.height)
            var top = 0,left = 0
            if(index<colCount){//还不到2行
                colsHeightArr.push(item.height)
                left = index * cellWidth
            }else{
                var minHeight = Math.min.apply(null, colsHeightArr)//最低高低
                var minIndex = colsHeightArr.indexOf(minHeight)//最低高度的索引
                top = minHeight + control.colSpacing
                left = minIndex * cellWidth
                colsHeightArr[minIndex] = top + item.height
            }
            item.x = left
            item.y = top
            item.width = control.cardWidth
            maxHeight = Math.max.apply(null, colsHeightArr)
            console.log("addToFall success:"+index)
            layoutedMaxIdx = index
        }
    }
}
