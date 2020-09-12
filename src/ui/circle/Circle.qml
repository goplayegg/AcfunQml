import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/global/"

Item{
    id:root

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
}
