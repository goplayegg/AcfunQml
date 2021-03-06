﻿//视频标题 分P 标签 up信息
import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/global/libraries/functions.js" as FUN

Item {
    id: root
    height: rootCol.implicitHeight

    property var acID
    property var contentType
    property var user: ({})
    property var tagList: ({})
    signal changeVideoPart(var vInfo)//切换分P
    function open(js){
        acID = js.contentId
        contentType = js.contentType
        textTitle.text = js.title
        btnLike.text = js.likeCountShow
        btnLike.customChecked = js.isLike
        btnBanana.text = js.bananaCountShow
        btnBanana.customChecked = js.isThrowBanana
        btnStar.text = js.stowCount
        btnStar.customChecked = js.isFavorite
        labPostTime.text = qsTr("Posted") +"  "+ js.createTime
        textPlayCnt.text = js.viewCountShow
        textDanmCount.text = js.danmakuCountShow
        textAC.text = "AC"+js.contentId
        textDesc.text = js.description
        if(undefined === js.userJson){
            user = js.user
        }else{
            user = JSON.parse(js.userJson)
        }
        imgAvatar.avatarUrl = user.headUrl
        imgAvatar.userId = user.id
        labUpName.text = user.name
        btnFollow.customChecked = user.isFollowing
        tagList = []
        if(undefined === js.tagListJson){
            if(undefined !== js.tagList)
                tagList = js.tagList
        }else{
            tagList = JSON.parse(js.tagListJson)
        }
        var tagLenShow = repTags.count
        var tagLen = tagList.length
        for(var idx=0; idx<tagLenShow; ++idx){
            if(idx<tagLen){
                repTags.itemAt(idx).text = tagList[idx].name
            }else{
                repTags.itemAt(idx).text = ""
            }
        }
        var videoList = []
        if(undefined === js.videoListJson){
            if(undefined !== js.videoList){
                videoList = js.videoList
            }
        }else {
            videoList = JSON.parse(js.videoListJson)
        }
        modelVideos.clear()
        if(videoList.length>1){
            for(var idxV in videoList){
                modelVideos.append({info:videoList[idxV]})
            }
        }
        if(btnFollow.customChecked && !btnBanana.customChecked && Global.getBoolPref("autoBanana")){
            btnBanana.clicked()
        }
    }

    function openBangumi(js){
        AcService.bangumiItemList(js.id, function(res){
            if(0 !== res.result){
                PopMsg.showError(res, mainwindowRoot)
                return
            }
            modelVideos.clear()
            if(res.items.length>1){
                for(var idxV in res.items){
                    modelVideos.append({info:res.items[idxV]})
                }
            }
        })
        acID = js.id
        contentType = 1
        textTitle.text = js.title
        btnLike.text = js.likeCount
        btnLike.customChecked = js.isLike
        btnStar.text = js.stowCountShow
        btnStar.customChecked = js.isFavorite
        textPlayCnt.text = js.playCountShow
        textDanmCount.text = js.commentCountShow
        textAC.text = "AC"+js.contentId
        textDesc.text = js.intro
        tagList = []
        if(undefined !== js.bangumiStyleList){
            tagList = js.bangumiStyleList
        }
        var tagLenShow = repTags.count
        var tagLen = tagList.length
        for(var idx=0; idx<tagLenShow; ++idx){
            if(idx<tagLen){
                repTags.itemAt(idx).text = tagList[idx].name
            }else{
                repTags.itemAt(idx).text = ""
            }
        }
        var bangumList = []
        if(undefined !== js.related_bangumis){
            bangumList = js.related_bangumis
        }
        modelRelatBangumis.clear()
        if(bangumList.length>1){
            for(var idxB in bangumList){
                modelRelatBangumis.append(bangumList[idxB])
            }
        }
    }

    function nextPart(){
        if(null === btnsVideo.checkedButton)
            return
        var jumpTo = btnsVideo.checkedButton.idx+1
        if(jumpTo < modelVideos.count){
            console.log("auto jump to part "+jumpTo+", video part total count:"+modelVideos.count)
            repBtnPart.itemAt(jumpTo).checked = true
        }
    }

    Column {
        id: rootCol
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10
        topPadding: 10
        bottomPadding: 10

        Item {//标题 + 按钮
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.max(textTitle.height, rowBtns.height)
            TextArea {
                id: textTitle
                leftPadding: 0
                anchors.left: parent.left
                anchors.right: rowBtns.left
                height: Math.max(rowBtns.height, implicitHeight)
                text: "-"
                selectByMouse: true
                readOnly: true
                wrapMode: Text.WordWrap
                font.pixelSize: AppStyle.font_xxlarge
                font.family: AppStyle.fontNameMain
                font.weight: Font.Bold
                verticalAlignment: Text.AlignVCenter
            }

            Row {
                id: rowBtns
                spacing: 8
                anchors.right: parent.right
                RoundBtnWithText {
                    id: btnLike
                    icon: "qrc:/assets/img/common/like0.png"
                    iconChecked: "qrc:/assets/img/common/like1.png"
                    onClicked: toastMsg.showTip("T.T 目前只支持对评论点赞")
                }
                RoundBtnWithText {//投蕉
                    id: btnBanana
                    visible: contentType !== 1
                    enabled: !customChecked
                    icon: "qrc:/assets/img/common/banana0.png"
                    iconChecked: "qrc:/assets/img/common/banana1.png"
                    property var componentBanana: null
                    onClicked: {
                        customChecked = true
                        if(null == componentBanana){
                            componentBanana = Qt.createComponent("qrc:/ui/components/Banana.qml")
                        }
                        if(componentBanana.status === Component.Ready){
                            console.log("throw Banana")
                            var from = mapToItem(root, 0, height)
                            var to = itemAvatar.mapToItem(root, 0, 0)
                            var pos = {"fromPos":from, "toPos":to, "duration": 1000}
                            var tmp = componentBanana.createObject(root, pos)
                            tmp.start();
                            imgAvatar.start()
                        }
                        AcServiceEx.banana(acID, contentType, 5)
                    }
                }
                RoundBtnWithText {//收藏/追番
                    id: btnStar
                    icon: "qrc:/assets/img/common/star0.png"
                    iconChecked: "qrc:/assets/img/common/star1.png"
                    onClicked: {
                        console.log(customChecked?"favorite":"unFavorite")
                        let resType = contentType === 1 ? 1 : 9//追番1 收藏视频9
                        if(customChecked){
                            AcServiceEx.favorite(acID, resType)
                        }else{
                            AcServiceEx.unFavorite(acID, resType)
                        }
                    }
                }
            }
        }

        Row {//播放量 ac号
            spacing: 5
            Text {
                height: textPlayCnt.height
                width: height
                text: AppIcons.mdi_play_box_outline
                font.family: AppIcons.family
                font.pixelSize: height / 1.5
                font.weight: Font.Light
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: AppStyle.secondForeColor
            }
            Text {
                id: textPlayCnt
                font.pixelSize: AppStyle.font_smal
                font.family: AppStyle.fontNameMain
            }
            Text {
                height: textPlayCnt.height
                width: height
                text: AppIcons.mdi_card_bulleted_outline
                font.family: AppIcons.family
                font.pixelSize: height / 1.5
                font.weight: Font.Light
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: AppStyle.secondForeColor
            }
            Text {
                id: textDanmCount
                font.pixelSize: AppStyle.font_smal
                font.family: AppStyle.fontNameMain
            }
            TextArea {
                id: textAC
                padding: 0
                selectByMouse: true
                readOnly: true
                font.pixelSize: AppStyle.font_smal
                font.family: AppStyle.fontNameMain
            }
        }

        Flow {//相关番剧 一般是第一季 第二季 第三季
            visible: contentType === 1 && modelRelatBangumis.count>1
            spacing: 10
            anchors.left: parent.left
            anchors.right: parent.right
            ButtonGroup {
                id: btnsBangumi
                onCheckedButtonChanged: {
                    console.log("change bangumi to:"+checkedButton.vInfo.id+"  current acID:"+acID)
                    if(checkedButton.vInfo.id == acID)
                        return
                    Global.openVideo({
                                         vid          : 0,
                                         contentId    : checkedButton.vInfo.id,
                                         contentType  : 1
                                     })
                }
            }
            Repeater {
                model: ListModel {
                    id: modelRelatBangumis
                }
                Button {
                    property var vInfo: model
                    property var idx: model.index
                    width: implicitWidth<80?80:implicitWidth
                    height: 26
                    checkable: true
                    checked: model.id == acID
                    ButtonGroup.group: btnsBangumi
                    background: Rectangle {
                        color: checked?AppStyle.accentColor:AppStyle.secondBkgroundColor
                        radius: 5
                    }
                    contentItem: Text {
                        anchors.centerIn: parent
                        text: model.name
                        font.family:  AppStyle.fontNameMain
                        font.weight: Font.Light
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: checked?AppStyle.backgroundColor:AppStyle.foregroundColor
                    }
                }
            }
        }
        Flow {//分P
            spacing: 10
            anchors.left: parent.left
            anchors.right: parent.right
            ButtonGroup {
                id: btnsVideo
                onCheckedButtonChanged: {
                    if(undefined === checkedButton.vInfo.episodeName){
                        console.log("Video part changed to: "+checkedButton.vInfo.title)
                        textDanmCount.text = checkedButton.vInfo.danmakuCountShow
                        changeVideoPart(checkedButton.vInfo)
                    }else{
                        console.log("bangumi part changed to: "+checkedButton.vInfo.episodeName)
                        changeVideoPart({id:checkedButton.vInfo.videoId})
                    }
                }
            }
            Repeater {
                id: repBtnPart
                model: ListModel {
                    id: modelVideos
                }
                Button {
                    property var vInfo: model.info
                    property var idx: model.index
                    width: implicitWidth<180?180:implicitWidth
                    height: 36
                    checkable: true
                    checked: index === 0
                    ButtonGroup.group: btnsVideo
                    background: Rectangle {
                        color: checked?AppStyle.accentColor:AppStyle.secondBkgroundColor
                        radius: 5
                    }
                    contentItem: Text {
                        anchors.centerIn: parent
                        text: vInfo.episodeName?vInfo.episodeName:vInfo.title
                        font.family:  AppStyle.fontNameMain
                        font.weight: Font.Light
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: checked?AppStyle.backgroundColor:AppStyle.foregroundColor
                    }
                }
            }
        }

        Item {//up主信息
            id: rowUp
            visible: contentType !== 1
            height: itemAvatar.height
            anchors.left: parent.left
            anchors.right: parent.right

            Item {
                width: 50
                height: width
                id: itemAvatar
                z: 2

                Avatar {//头像
                    id: imgAvatar
                    size: 50
                    avatarUrl: ""
                    userId: 0
                    property int animDuration: 1000
                    function start(){
                        imgAvatar.state = "eatBanana"
                        timerAnim.start()
                    }
                    Timer {
                        id: timerAnim
                        interval: imgAvatar.animDuration
                        onTriggered: {
                            imgAvatar.state = ""
                        }
                    }
                    Behavior on x {
                             NumberAnimation { duration: imgAvatar.animDuration }
                         }
                    Behavior on y {
                             NumberAnimation { duration: imgAvatar.animDuration }
                         }
                    Behavior on rotation {
                             NumberAnimation { duration: imgAvatar.animDuration }
                         }
                    states: [
                        State {
                            name: "eatBanana"
                            PropertyChanges { target: imgAvatar; x: 40 }
                            PropertyChanges { target: imgAvatar; y: -10 }
                            PropertyChanges { target: imgAvatar; rotation: 75 }
                        }
                    ]
                }
            }
            Column {
                spacing: 8
                anchors.verticalCenter: itemAvatar.verticalCenter
                anchors.left: itemAvatar.right
                anchors.leftMargin: 15
                TextArea {
                    id: labUpName
                    padding: 0
                    selectByMouse: true
                    readOnly: true
                    font.weight: Font.Bold
                    font.pixelSize: AppStyle.font_large
                    font.family: AppStyle.fontNameMain
                }
                Label {
                    id: labPostTime
                    leftPadding: 3
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                }
            }

            IconTextButton {
                id: btnFollow
                property bool customChecked: false
                anchors.right: parent.right
                anchors.top: rowUp.top
                color: AppStyle.accentColor
                textColor: AppStyle.backgroundColor
                icon.name: AppIcons.mdi_heart
                iconColor: customChecked? AppStyle.primaryColor :AppStyle.backgroundColor
                text: customChecked? qsTr("Followed"): qsTr("Follow")
                onClicked: {
                    customChecked = !customChecked
                    AcServiceEx.follow(user.id, customChecked)
                }
            }
        }

        TextArea {
            id: textDesc
            leftPadding: 0
            anchors.left: parent.left
            anchors.right: parent.right
            selectByMouse: true
            readOnly: true
            wrapMode: Text.WordWrap
            textFormat: TextEdit.RichText
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
        }

        Row {//标签
            id: rowTags
            spacing: 10
            width: parent.width
            height: 25
            Repeater {
                id: repTags
                model: 4

                Button {
                    height: 25
                    visible: text.length>0
                    background: Rectangle {
                        color: FUN.makeTransparent(AppStyle.accentColor, "55")
                        radius: 5
                    }
                    contentItem: Text {
                        anchors.centerIn: parent
                        text: parent.text
                        font.family:  AppStyle.fontNameMain
                        font.weight: Font.Light
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: Qt.darker(AppStyle.accentColor)
                    }
                }
            }
        }

        Component.onCompleted: {
            console.log("Video detail completed")
        }
    }
}
