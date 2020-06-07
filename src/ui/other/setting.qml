import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/styles"

Item{
    id:root
    property bool loaded:false

    function refresh(){
    }

    function back(){

    }

    AnimatedImage {
        anchors.centerIn: parent
        source: "qrc:/assets/img/bk/pee.gif"
    }

    ScrollView {
        id: scroll
        clip: true
        anchors.fill: parent

        Column {
            id:colBars
            width: parent.width
            spacing: 20

            Label {
                text: qsTr("App setting")
                font.pixelSize: AppStyle.font_xxxxlarge
                font.family: AppStyle.fontNameMain
                font.weight: Font.Black
            }

            Label {
                text: qsTr("Language")
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
            }

            ComboBox {
                id: cmbTrans
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
                model: g_languageList
                onCurrentTextChanged: {
                    if(loaded)
                        g_preference.setValue("translation", currentText)
                }
            }

            Label {
                text: qsTr("Use hard decoder")
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
            }

            Switch {
                id: swHardDec
                onCheckedChanged: {
                    if(loaded)
                        g_preference.setValue("hardDec", checked)
                }
            }
        }
    }

    Component.onCompleted: {
        var lan = g_preference.value("translation")
        if(lan.length>0)
            cmbTrans.currentIndex = cmbTrans.find(lan)
        var hardDec = g_preference.value("hardDec")
        if(undefined !== hardDec)
            swHardDec.checked = hardDec === "true"

        loaded = true
    }
}
