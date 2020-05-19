INCLUDEPATH += base
include(HttpRequest/httprequest.pri)

HEADERS += \
    $$PWD/global.h \
    $$PWD/utils/Incubator.h \
    $$PWD/utils/Lazy.h \
    $$PWD/utils/TimeTick.h \

SOURCES +=

message(INCLUDEPATH is $$INCLUDEPATH)
