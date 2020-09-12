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

    function empty(){
        return false
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
                text: qsTr("Theme")
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
            }

            ComboBox {
                id: cmbTheme
                font.pixelSize: AppStyle.font_xlarge
                font.family: AppStyle.fontNameMain
                textRole: "name"
                model: AppStyle.themes
                onCurrentIndexChanged: {
                    if(loaded) {
                        AppStyle.currentTheme = currentIndex
                        g_preference.setValue("theme", currentIndex)
                    }
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
        if(undefined !== lan)
            cmbTrans.currentIndex = cmbTrans.find(lan)

        cmbTheme.currentIndex = AppStyle.currentTheme

        var hardDec = g_preference.value("hardDec")
        if(undefined !== hardDec)
            swHardDec.checked = hardDec === "true"

        loaded = true
    }
}
