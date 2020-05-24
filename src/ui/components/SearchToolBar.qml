import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id:root

    property alias backEnable: btnBack.enabled
    signal back();
    signal refresh();
    height: 40
    RoundButton {
        id: btnBack
        text: "<"
        width: parent.height
        height: width
        anchors.left: parent.left
        onClicked: back()
    }

    TextField {
        id: search
        height: parent.height
        width: 300
        placeholderText: qsTr("Search")
        text: ""//TODO del
        anchors.left: btnBack.right
        anchors.leftMargin: 20
    }

    RoundButton {
        id: btnRefresh
        text: "R"
        width: root.height
        height: width
        anchors.right: parent.right
        onClicked: refresh()
    }
}
