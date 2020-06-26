pragma Singleton
import QtQuick 2.12
import AcfunQml 1.0

Item {
    property int sliderBarWidth: 6
    property var userInfo

    ConstPreferences {
        id: constPref
    }

    function appVer(){
        return constPref.get("appVer")
    }
}
