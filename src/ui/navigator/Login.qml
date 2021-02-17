import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/btn/"
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"
Popup {
    id:root
    closePolicy:Popup.NoAutoClose | Popup.CloseOnEscape
    background: Rectangle{
        color: AppStyle.secondBkgroundColor
    }

    anchors.centerIn: parent
    width:450
    height:520

    property string strError: ""
    signal loginFinish(var js);
    function setLoginData(js){
        if(0 !== js.result){
            strError = js.error_msg
            console.log("login error:"+js.error_msg)
            return
        }
        strError = ""
        var loginParam = {
            acPassToken: js.acPassToken,
            acSecurity: js.acSecurity,
            auth_key: js.auth_key,
            token: js.token
        }

        Global.storeEncrypt("AcfunQmlKeys", JSON.stringify(loginParam))
        g_preference.setValue("userid",js.userid)
        AcService.getUserInfo(gotUserInfo)
    }
    function gotUserInfo(res){
        if(res.result === 0){
            var userInfo = {
                "avatar": res.info.headUrl,
                "username": res.info.userName,
                "userid": res.info.userId,
                "level": res.info.level,
                "followed": res.info.followed,
                "following": res.info.following,
                "banana": res.info.banana,
                "contentCount": res.info.contentCount
            }
            Global.userInfo = userInfo
            loginFinish(userInfo)
        }
    }

    function initLogin(){
        var userid = g_preference.value("userid")
        if(undefined === userid || userid === "")
            return

        Global.readEncrypt("AcfunQmlKeys", function(value){
            if(value !== ""){
                var loginParam = JSON.parse(value)
                initLoginImpl(loginParam)
            }
        });
    }

    function initLoginImpl(loginParam){
        var auth = {
            acPassToken: loginParam.acPassToken,
            acSecurity: loginParam.acSecurity,
            auth_key: loginParam.auth_key,
            token: loginParam.token,
            userid: parseInt(g_preference.value("userid")),
            result: 0
        }
        AcService.makeCookie(auth)
        AcService.getUserInfo(gotUserInfo)
    }

    Column{
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10
        Rectangle{
            id:logo
            color: "transparent"
            height: 50
            width: parent.width
            RoundButton{
                anchors.right: parent.right
                icon.name: AppIcons.mdi_close
                onClicked: {
                    root.close()
                }
            }
        }

        Label{
            text: qsTr("Login")
            font.bold: true
            font.pointSize: 24
        }

        Label{
            anchors.topMargin: 30
            width: parent.width
            height: 40
            text: strError
            visible: text.length>0
            leftPadding: 10
            color: AppStyle.backgroundColor
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            verticalAlignment: Text.AlignVCenter
            background:Rectangle{
                color: AppStyle.errorColor
                radius: 5
            }
        }

        Label{
            anchors.topMargin: 80
            text: qsTr("User name")
            color: AppStyle.thirdBkgroundColor
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            verticalAlignment: Text.AlignVCenter
        }
        TextField{
            id: texUser
            height: 60
            width: parent.width
            placeholderText: qsTr("User name / phone number")
        }
        Label{
            text: qsTr("Password")
            color: AppStyle.thirdBkgroundColor
            font.pixelSize: AppStyle.font_large
            font.family: AppStyle.fontNameMain
            verticalAlignment: Text.AlignVCenter
        }
        TextField{
            id: texPsw
            height: 60
            width: parent.width
            placeholderText: qsTr("Password")
            echoMode:TextInput.Password
        }

        Button{
            anchors.topMargin: 50
            id:btnLogin
            height: 60
            width: parent.width
            text:qsTr("Login")
            //textColor: "white"
            //color: AppStyle.accentColor
            onClicked: {
                AcService.login(texUser.text, texPsw.text, setLoginData)
            }
        }
    }
}
