import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"

Item{
    id:root

    function refresh(){
    }

    function back(){

    }

    Image {
        anchors.fill: parent
        source: "qrc:/assets/img/bk/bog.jpg"
        fillMode: Image.PreserveAspectCrop
    }
}
