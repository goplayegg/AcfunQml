INCLUDEPATH += base
include(HttpRequest/httprequest.pri)
include(qtkeychain/qt5keychain.pri)

HEADERS += \
    $$PWD/global.h \
    $$PWD/utils/CommonTools.h \
    $$PWD/utils/FileSaver.h \
    $$PWD/utils/Incubator.h \
    $$PWD/utils/Lazy.h \
    $$PWD/utils/TimeTick.h \

SOURCES += \
    $$PWD/utils/CommonTools.cpp \
    $$PWD/utils/FileSaver.cpp

message(INCLUDEPATH is $$INCLUDEPATH)
