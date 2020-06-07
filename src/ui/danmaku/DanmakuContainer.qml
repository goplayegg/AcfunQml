import QtQuick 2.0

Item {
    id: control

    function close(){
        var danms = control.children
        var cnt = danms.length
        for(var idx = 0; idx<cnt; ++idx){
             danms[idx].destroy()
        }
    }
    function togglePause(isPause){
        var danms = control.children
        var cnt = danms.length
        for(var idx = 0; idx<cnt; ++idx){
             danms[idx].togglePause(isPause)
        }
    }
}
