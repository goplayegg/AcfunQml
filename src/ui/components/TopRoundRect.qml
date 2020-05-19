import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Shapes 1.11
Shape {
    id:root
    antialiasing: true
    smooth: true
    property int radius:15

    ShapePath {
        strokeWidth: 1
        strokeColor: "black"
        fillColor: "red"
        fillRule: ShapePath.WindingFill
        startX: 1; startY: radius
        PathArc {
            x: radius; y: 0
            radiusX: radius; radiusY: radius
        }
        PathLine{
            x: root.width-radius; y:0
        }
        PathArc {
            x: root.width; y: radius
            radiusX: radius; radiusY: radius
        }
        PathLine{
            x: root.width; y:root.height
        }
        PathLine{
            x: 1; y:root.height
        }
        PathLine{
            x: 1; y:radius
        }
    }
}

