!isEmpty(ACFUNQML_PRI_INCLUDED):error("acfunqml.pri already included")
ACFUNQML_PRI_INCLUDED = 1

ACFUNQML_VERSION = 0.2.1
ACFUNQML_COMPAT_VERSION = 0.2.1
ACFUNQML_DISPLAY_VERSION = 0.2.1
ACFUNQML_COPYRIGHT_YEAR = 2020
ACFUNQML_COMPANY_NAME = ""
VERSION = $$ACFUNQML_VERSION

isEmpty(APP_DISPLAY_NAME): APP_DISPLAY_NAME = AcfunQml
isEmpty(APP_ID):           APP_ID = acfunqml
isEmpty(APP_CASE_ID):      APP_CASE_ID = AcfunQml

defineReplace(qtLibraryTargetName) {
   unset(LIBRARY_NAME)
   LIBRARY_NAME = $$1
   CONFIG(debug, debug|release) {
      !debug_and_release|build_pass {
          mac:RET = $$member(LIBRARY_NAME, 0)_debug
              else:win32:RET = $$member(LIBRARY_NAME, 0)d
      }
   }
   isEmpty(RET):RET = $$LIBRARY_NAME
   return($$RET)
}

defineReplace(qtLibraryName) {
   RET = $$qtLibraryTargetName($$1)
   win32 {
      VERSION_LIST = $$split(ACFUNQML_VERSION, .)
      RET = $$RET$$first(VERSION_LIST)
   }
   return($$RET)
}

# 只用于自定义编译器的文件拷贝
defineReplace(stripSrcDir) {
    return($$relative_path($$absolute_path($$1, $$OUT_PWD), $$_PRO_FILE_PWD_))
}

isEmpty(ACFUNQML_LIBRARY_BASENAME) {
    ACFUNQML_LIBRARY_BASENAME = lib
}

DEFINES += ACFUNQML_LIBRARY_BASENAME=\\\"$$ACFUNQML_LIBRARY_BASENAME\\\"

ACFUNQML_SOURCE_TREE = $$PWD
isEmpty(ACFUNQML_BUILD_TREE) {
    sub_dir = $$_PRO_FILE_PWD_
    sub_dir ~= s,^$$re_escape($$PWD),,
    ACFUNQML_BUILD_TREE = $$clean_path($$OUT_PWD)
    ACFUNQML_BUILD_TREE ~= s,$$re_escape($$sub_dir)$,,
}
message(acfunqml $$ACFUNQML_SOURCE_TREE $$ACFUNQML_BUILD_TREE)

APP_PATH = $$ACFUNQML_SOURCE_TREE/bin

osx {
    APP_TARGET = "$$APP_DISPLAY_NAME"

    # check if BUILD_TREE is actually an existing AcfunQml.app,
    # for building against a binary package
    exists($$ACFUNQML_BUILD_TREE/Contents/MacOS/$$APP_TARGET): APP_BUNDLE = $$ACFUNQML_BUILD_TREE
    else: APP_BUNDLE = $$APP_PATH/$${APP_TARGET}.app

    # set output path if not set manually
    isEmpty(APP_OUTPUT_PATH): APP_OUTPUT_PATH = $$APP_BUNDLE/Contents

    ACFUNQML_LIBRARY_PATH = $$APP_OUTPUT_PATH/Frameworks
    ACFUNQML_PLUGIN_PATH  = $$APP_OUTPUT_PATH/PlugIns
    ACFUNQML_LIBEXEC_PATH = $$APP_OUTPUT_PATH/Resources
    ACFUNQML_DATA_PATH    = $$APP_OUTPUT_PATH/Resources
    ACFUNQML_DOC_PATH     = $$APP_DATA_PATH/doc
    ACFUNQML_BIN_PATH     = $$APP_OUTPUT_PATH/MacOS

    contains(QT_CONFIG, ppc):CONFIG += ppc x86
    copydata = 1

    INSTALL_LIBRARY_PATH = $$APP_PREFIX/$${APP_TARGET}.app/Contents/Frameworks
    INSTALL_PLUGIN_PATH  = $$APP_PREFIX/$${APP_TARGET}.app/Contents/PlugIns
    INSTALL_LIBEXEC_PATH = $$APP_PREFIX/$${APP_TARGET}.app/Contents/Resources
    INSTALL_DATA_PATH    = $$APP_PREFIX/$${APP_TARGET}.app/Contents/Resources
    INSTALL_DOC_PATH     = $$INSTALL_DATA_PATH/doc
    INSTALL_BIN_PATH     = $$APP_PREFIX/$${APP_TARGET}.app/Contents/MacOS
    INSTALL_APP_PATH     = $$APP_PREFIX/
} else {
    APP_TARGET = $$APP_ID
    
    # 如果没有手动设置目标输出路径
    isEmpty(APP_OUTPUT_PATH): APP_OUTPUT_PATH = $$ACFUNQML_BUILD_TREE

    ACFUNQML_LIBRARY_PATH = $$APP_OUTPUT_PATH/$$ACFUNQML_LIBRARY_BASENAME/acfunqml
    ACFUNQML_PLUGIN_PATH  = $$ACFUNQML_LIBRARY_PATH/plugins
    ACFUNQML_DATA_PATH    = $$APP_OUTPUT_PATH/share/acfunqml
    ACFUNQML_DOC_PATH     = $$APP_OUTPUT_PATH/share/doc/acfunqml
    ACFUNQML_BIN_PATH     = $$APP_OUTPUT_PATH/bin

    win32: \
        APP_LIBEXEC_PATH = $$APP_OUTPUT_PATH/bin
    else: \
        APP_LIBEXEC_PATH = $$APP_OUTPUT_PATH/libexec/acfunqml

    INSTALL_LIBRARY_PATH = $$APP_PREFIX/$$ACFUNQML_LIBRARY_BASENAME/acfunqml
    INSTALL_PLUGIN_PATH  = $$INSTALL_LIBRARY_PATH/plugins
    win32: \
        INSTALL_LIBEXEC_PATH = $$APP_PREFIX/bin
    else: \
        INSTALL_LIBEXEC_PATH = $$APP_PREFIX/libexec/acfunqml
    INSTALL_DATA_PATH    = $$APP_PREFIX/share/acfunqml
    INSTALL_DOC_PATH     = $$APP_PREFIX/share/doc/acfunqml
    INSTALL_BIN_PATH     = $$APP_PREFIX/bin
    INSTALL_APP_PATH     = $$APP_PREFIX/bin
}

win32:exists($$ACFUNQML_SOURCE_TREE/lib/acfunqml) {
    # for .lib in case of binary package with dev package
    LIBS *= -L$$ACFUNQML_SOURCE_TREE/lib/acfunqml
    LIBS *= -L$$ACFUNQML_SOURCE_TREE/lib/acfunqml/plugins
}

INCLUDEPATH += $$ACFUNQML_SOURCE_TREE/src
LIBS *= -L$$ACFUNQML_LIBRARY_PATH

message(LIBS $$LIBS)
