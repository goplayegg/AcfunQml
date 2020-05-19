import QtQuick 2.12
import QtQuick.Controls 2.12
import AcfunQml 1.0

import "qrc:///ui/components/" as COM
import "qrc:///ui/global/styles/"
import "qrc:///ui/global/"
Popup {
    id:root
    closePolicy:Popup.NoAutoClose | Popup.CloseOnEscape
    background: Rectangle{
        color: "#F1F6FA"
    }

    anchors.centerIn: parent
    width:450
    height:520

    signal loginFinish(var js);
    signal getRankFinish(var js);
    function setLoginData(js){
        g_preference.setValue("acPassToken",js.acPassToken)
        g_preference.setValue("acSecurity",js.acSecurity)
        g_preference.setValue("auth_key",js.auth_key)
        g_preference.setValue("token",js.token)
        g_preference.setValue("userid",js.userid)
        loginFinish(js)
        AcService.getRank(function(res){
            getRankFinish(res)
        })
    }

    function initLogin(){
        var acPass = g_preference.value("acPassToken")
        if(!acPass)
            return

        var auth = {
            acPassToken:acPass,
            acSecurity:g_preference.value("acSecurity"),
            auth_key:parseInt(g_preference.value("auth_key")),
            token:g_preference.value("token"),
            userid:parseInt(g_preference.value("userid"))
        }
        AcService.makeCookie(auth)
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
            COM.RoundButton{
                anchors.right: parent.right
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
            anchors.topMargin: 80
            text: qsTr("User name")
            color: "#999AA1"
            font.pointSize: 12
        }
        TextField{
            id: texUser
            height: 60
            width: parent.width
            placeholderText: qsTr("User name / phone number")
            text: ""//TODO del
        }
        Label{
            text: qsTr("Password")
            color: "#999AA1"
            font.pointSize: 12
        }
        TextField{
            id: texPsw
            height: 60
            width: parent.width
            placeholderText: qsTr("password")
            echoMode:TextInput.Password
            text: ""//TODO del
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
