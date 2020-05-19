import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:///ui/components/"

Item{
    id:root

    property alias videoUrl :player.videoUrl
    property alias title :player.title
    function stop(){
        player.stop()
    }

    function setDanm(js){
        player.setDanm(js)
    }

    VideoLayer{
        id: player
        anchors.fill: parent
    }

}
