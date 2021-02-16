//TODO: 上滑看评论时把把标题收起来到顶部
import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/components/card/"
import "qrc:///ui/components/comment/"
import "qrc:///ui/global/"
import "qrc:///ui/global/styles/"

Item{
    id:root

    function empty(){
        return artModel.count === 0
    }

    function back(){

    }

    function refresh(){
        artModel.clear()
        newVideoPageNo = 1
        append()
    }

    property int newVideoPageNo: 0
    function append(){
        if(newVideoPageNo === 0)
            return
        busyBox.running = true
        if(empty()){
            AcService.getChannelVideo(63, 10, updateInfo)
        }else{
            newVideoPageNo++
            AcService.getNewVideoInRegion(63, newVideoPageNo,updateInfo)
        }
    }

    function updateInfo(js){
        if(0 !== js.errorid){
            busyBox.running = false
            PopMsg.showError(js, mainwindowRoot)
            return
        }

        for(var idx in js.vdata){
            if(js.vdata[idx].schema === undefined){
                artModel.append({info: js.vdata[idx]})
            }else{
                if(js.vdata[idx].schema === "carousels")
                    continue
                for(var id in js.vdata[idx].bodyContents){
                    artModel.append({info: js.vdata[idx].bodyContents[id]})
                }
            }
        }
        busyBox.running = false
    }

    property bool cmtLoaded: false
    property var acID: 0
    property var user: ({})
    function open(aid){
        acID = aid
        cmtLoaded = false
        btnChange.checked = false
        AcService.getArticle(aid, function(js){
            if(0 !== js.result){
                acID = 0
                PopMsg.showError(js, mainwindowRoot)
                return
            }
            article.visible = true
            txContent.text = js.content
            textTitle.text = js.title
            btnLike.text = js.likeCount
            btnLike.customChecked = js.isLike
            btnBanana.text = js.formatBananaCount
            btnBanana.customChecked = js.isThrowBanana
            btnStar.text = js.stowCount
            btnStar.customChecked = js.isFavorite
            labPostTime.text = qsTr("Posted") +"  "+ js.createTime
            textPlayCnt.text = js.formatViewCount
            textCmtCount.text = js.formatCommentCount
            textAC.text = "AC"+acID
            user = js.user
            imgAvatar.avatarUrl = user.headUrl
            imgAvatar.userId = user.id
            labUpName.text = user.name
            btnFollow.customChecked = user.isFollowing
            if(btnFollow.customChecked && !btnBanana.customChecked && Global.getBoolPref("autoBanana")){
                btnBanana.clicked()
            }
        })
    }

    ListView {
        id: cardList
        width: 350
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        clip: true
        spacing: 8
        ScrollBar.vertical: ScrollBar {
            id: scrBar
            onPositionChanged: {
                if(1.0 === position+size){
                    append()
                }
            }
            onSizeChanged: {
                if(1.0 === size){
                    append()
                }
            }
        }
        model: ListModel {
            id: artModel
        }
        delegate: ArticleCard {
            infoJs: model.info
            width: 350
        }
    }
    Item {
        id: article
        visible: false
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: cardList.right
        anchors.right: parent.right
        anchors.margins: 5

        Column {
            id: rightCol
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
                    font.pixelSize: AppStyle.font_xxxlarge
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
                            AcServiceEx.banana(acID, 3, 5)
                        }
                    }
                    RoundBtnWithText {//关注
                        id: btnStar
                        icon: "qrc:/assets/img/common/star0.png"
                        iconChecked: "qrc:/assets/img/common/star1.png"
                        onClicked: {
                            console.log(customChecked?"favorite":"unFavorite")
                            if(customChecked){
                                AcServiceEx.favorite(acID, 3)
                            }else{
                                AcServiceEx.unFavorite(acID, 3)
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
                    id: textCmtCount
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

            Item {//up主信息
                id: rowUp
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
        }
        ScrollView {
            id: scroll
            clip: true
            visible: !btnChange.checked
            anchors.top: rightCol.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            TextArea {
                id: txContent
                textFormat: Qt.RichText
                persistentSelection: true
                selectByMouse: true
                readOnly: true
                focus: true
                wrapMode: TextArea.Wrap
                font.pixelSize: AppStyle.font_large
                font.family: AppStyle.fontNameArticle
                font.weight: Font.Medium
                onLinkActivated:{
                    Global.openUrl(link)
                }
            }
        }
        ScrollView {
            id: scrollCmt
            clip: true
            visible: btnChange.checked
            anchors.top: rightCol.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            CommentList {
                id: comment
                anchors.left: parent.left
                anchors.right: parent.right
            }
        }

        RoundButton {
            id: btnGoTop
            property var curScrBar: btnChange.checked? scrollCmt.ScrollBar.vertical: scroll.ScrollBar.vertical
            icon.name: AppIcons.mdi_arrow_up_thick
            size: 40
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            visible: curScrBar.position>0.2
            onClicked: {
                curScrBar.position = 0
            }
        }
        RoundButton {
            id: btnChange
            anchors.bottom: btnGoTop.top
            anchors.bottomMargin: 5
            anchors.horizontalCenter: btnGoTop.horizontalCenter
            icon.name: checked? AppIcons.mdi_book_open_outline: AppIcons.mdi_comment_processing_outline
            size: 40
            checkable: true
            tooltip: checked?qsTr("show article"):qsTr("show comment")
            onClicked: {
                if(!cmtLoaded){
                    console.log("loading article:"+acID)
                    comment.open({contentId: acID, cmtType: 1})
                    cmtLoaded = true
                }
            }
        }
    }
}
