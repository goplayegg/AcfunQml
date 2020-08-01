// 弃用 app的api没按这种交互分页适配 如果改用pc的api再用这个

import QtQuick 2.0
import QtQuick.Controls 2.12

import "qrc:///ui/global/styles/"

Row {
    property var curIdx:1
    property var totalCount:0
    property var cntPerPage:10
    property var totalPage: 1
    id: control
    spacing: 6

    Button {
        height: 40
        text: qsTr("last page")
        enabled: curIdx>1
        onClicked: {
            curIdx--
        }
    }

    ListModel {
        id: pageModel
    }

    Repeater {
        id: repPageBtn
        model: pageModel
        delegate: Button{
            height: 40
            text: model.tex
            onClicked: {
                console.log("click page idx:"+model.idx)
            }
        }
    }

    Button {
        height: 40
        text: qsTr("next page")
        enabled: totalPage>curIdx
        onClicked: {
            curIdx++
        }
    }

    Label {
        height: 40
        verticalAlignment: Text.AlignVCenter
        text: qsTr("jump to")
    }

    TextField {
        height: 40
        width: 80
        id: editJumpTo
    }

    onTotalCountChanged: {
        totalPage = Math.ceil(totalCount/cntPerPage)//向上取整
        pageModel.clear()
        var pageInfo
        for(var i =0; i<totalPage; i++){
            pageInfo = {
                text: i,
                idx: i
            }

            pageModel.append(pageInfo)
        }
    }
}
