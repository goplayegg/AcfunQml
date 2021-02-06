import QtQuick 2.0
import QtQuick.Controls 2.12
import "qrc:///ui/components/"
import "qrc:///ui/components/btn/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"

Rectangle {
    property var feedInfo: ({resourceType:0,time:"",userInfo:{id:0,headUrl:"",name:""},moment:{text:""},commentCount:"",isThrowBanana:false,bananaCount:"",isLike:false,likeCount:""})
    property bool repost: false
    property bool inDetail: false
    property real cardMargin: 5
    id: control
    width: 300
    implicitHeight: col.implicitHeight+2*cardMargin
    color: AppStyle.secondBkgroundColor

    Column {
        id: col
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: cardMargin
        anchors.topMargin: cardMargin+4
        Item {//用户
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            height: 38

            Avatar {
                id: imgAvatar
                size: 32
                avatarUrl: feedInfo.userInfo.headUrl
                userId: feedInfo.userInfo.id
            }

            Column {
                spacing: 2
                anchors.verticalCenter: imgAvatar.verticalCenter
                anchors.left: imgAvatar.right
                anchors.leftMargin: 10
                TextArea {
                    text: feedInfo.userInfo.name
                    padding: 0
                    selectByMouse: true
                    readOnly: true
                    font.weight: Font.Bold
                    font.pixelSize: AppStyle.font_large
                    font.family: AppStyle.fontNameMain
                }
                Label {
                    text: feedInfo.time + " " + ((feedInfo.resourceType === 2) ? (qsTr("%1 viewed").arg(feedInfo.viewCount)) : "")
                    leftPadding: 3
                    font.pixelSize: AppStyle.font_smal
                    font.family: AppStyle.fontNameMain
                }
            }
        }

        TextArea {//动态正文
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 4
            selectByMouse: true
            readOnly: true
            wrapMode: Text.WordWrap
            font.weight: Font.Bold
            font.pixelSize: AppStyle.font_normal
            font.family: AppStyle.fontNameMain
            textFormat: TextEdit.AutoText
            hoverEnabled: !inDetail
            ToolTip.visible: height<60?false:hovered
            ToolTip.text: qsTr("右键打开")
            text: {
                feedInfo.moment?g_commonTools.cvtToHtml(feedInfo.moment.text):
                                feedInfo.articleTitle?g_commonTools.cvtArticleTitle(feedInfo.articleTitle,feedInfo.articleBody):
                                                     feedInfo.caption?feedInfo.caption:
                                                                      feedInfo.articleBody
            }
            onLinkActivated: {
                console.log("open circle link:"+link)
                if(-1 !== link.indexOf("http")){
                    var idx = link.lastIndexOf(".")
                    PopImage.open(link, link.substring(idx+1))
                }else if("article" === link){
                    Global.openArticle(feedInfo.resourceId)
                }
            }
            onPressed: {
                if(event.button === 2){//right click
                    console.log("onPressed:")
                    openDetail()
                }
            }
        }

        Loader {
            id: ldMedia
            x: 4
            width: parent.width-8
        }

        Row {
            id: rowBtns
            visible: !repost
            spacing: 8
            anchors.left: parent.left
            anchors.right: parent.right
            RoundBtnWithText {//评论
                id: btnComment
                visible: !inDetail
                text: feedInfo.commentCount
                icon: "qrc:/assets/img/common/cmt0.png"
                iconChecked: "qrc:/assets/img/common/cmt1.png"
                onClicked: {
                    openDetail()
                }
            }
            RoundBtnWithText {//投蕉
                id: btnBanana
                text: feedInfo.bananaCount
                customChecked: feedInfo.isThrowBanana
                enabled: !customChecked
                icon: "qrc:/assets/img/common/banana0.png"
                iconChecked: "qrc:/assets/img/common/banana1.png"
                property var componentBanana: null
                onClicked: {
                    customChecked = true
                    AcService.banana(feedInfo.resourceId, feedInfo.resourceType, feedInfo.resourceType === 10 ? 1 : 5, function(res){
                        if(0 !== res.result)
                            PopMsg.showError(res, mainwindowRoot)
                        else{
                            //TODO Toast(res.extData.bananaRealCount)
                        }
                    })
                }
            }
            RoundBtnWithText {
                id: btnLike
                text: feedInfo.likeCount
                customChecked: feedInfo.isLike
                enabled: !customChecked
                icon: "qrc:/assets/img/common/like0.png"
                iconChecked: "qrc:/assets/img/common/like1.png"
            }
        }
    }

    Component.onCompleted: {
        if(!inDetail)
            loadMedia()
    }

    function loadMedia() {
        ldMedia.visible = true
        if(feedInfo.resourceType === 2){
            if(undefined === feedInfo.detail){
                feedInfo.detail = {coverUrl: feedInfo.coverUrl, dougaId: feedInfo.resourceId, vid: feedInfo.videoId }
            }
            ldMedia.setSource("VideoCard.qml",
                              {"infoJs": feedInfo.detail})
        }else if(feedInfo.resourceType === 10 && feedInfo.moment.imgs){
            ldMedia.setSource("PicCard.qml",
                              {"imgs": feedInfo.moment.imgs,
                               "width": ldMedia.width})
        }else if(feedInfo.repostSource){
            ldMedia.setSource("CircleInfoCard.qml",
                              {"feedInfo": feedInfo.repostSource,
                               "width": ldMedia.width,
                               "repost": true})
        }else{
            ldMedia.visible = false
        }
    }

    function stop() {
        if(ldMedia.item)
            ldMedia.item.stop()
    }

    function openDetail(){
        console.log("openDetail, resourceType:"+feedInfo.resourceType)
        switch(feedInfo.resourceType){
        case 10:
        case 3:
            Global.openCircleDetail(feedInfo, false)
            break;
        case 2:
            if(undefined === feedInfo.detail.videoList){
                Global.openVideo({contentId: feedInfo.resourceId})
            }else{
                feedInfo.detail.contentId = feedInfo.detail.dougaId
                feedInfo.detail.contentType = 2
                feedInfo.detail.vid = feedInfo.detail.videoList[0].id
                Global.openVideo(feedInfo.detail)
            }
            break;
        }
    }
}
