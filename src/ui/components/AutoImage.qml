import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: control
    property var source: undefined

    signal clicked()
    Loader {
        id: ldImg
        width: parent.width
        height: parent.height
    }

    Component {
        id: cmpGif
        AnimatedImage {
            id: gif
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    control.clicked()
                }
            }
        }
    }

    Component {
        id: cmpImg
        Image {
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(ldImg.width, ldImg.height)
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    control.clicked()
                }
            }
        }
    }

    Component.onCompleted: {
        loadAvatarCover()
    }

    function loadAvatarCover(){
        var gifIdx = source.indexOf(".gif")
        if(gifIdx !== -1){
            ldImg.sourceComponent = cmpGif
            ldImg.item.source = source.substring(0, gifIdx+4)
        }else{
            ldImg.sourceComponent = cmpImg
            ldImg.item.source = source
        }
    }
}
