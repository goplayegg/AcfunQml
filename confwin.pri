APP_TARGET = $$APP_ID

# 如果没有手动设置目标输出路径
isEmpty(APP_OUTPUT_PATH): APP_OUTPUT_PATH = $$ACFUNQML_BUILD_TREE

ACFUNQML_LIBRARY_PATH = $$APP_OUTPUT_PATH/$$ACFUNQML_LIBRARY_BASENAME/acfunQml
ACFUNQML_PLUGIN_PATH  = $$ACFUNQML_LIBRARY_PATH/plugins
ACFUNQML_DATA_PATH    = $$APP_OUTPUT_PATH/share/acfunQml
ACFUNQML_DOC_PATH     = $$APP_OUTPUT_PATH/share/doc/acfunQml
ACFUNQML_BIN_PATH     = $$APP_OUTPUT_PATH/bin

APP_LIBEXEC_PATH = $$APP_OUTPUT_PATH/bin

INSTALL_LIBRARY_PATH = $$APP_PREFIX/$$ACFUNQML_LIBRARY_BASENAME/acfunQml
INSTALL_PLUGIN_PATH  = $$INSTALL_LIBRARY_PATH/plugins
INSTALL_LIBEXEC_PATH = $$APP_PREFIX/bin
INSTALL_DATA_PATH    = $$APP_PREFIX/share/acfunQml
INSTALL_DOC_PATH     = $$APP_PREFIX/share/doc/acfunQml
INSTALL_BIN_PATH     = $$APP_PREFIX/bin
INSTALL_APP_PATH     = $$APP_PREFIX/bin

exists($$ACFUNQML_SOURCE_TREE/lib/acfunQml) {
    # for .lib in case of binary package with dev package
    LIBS *= -L$$ACFUNQML_SOURCE_TREE/lib/acfunQml
    LIBS *= -L$$ACFUNQML_SOURCE_TREE/lib/acfunQml/plugins
}

COPYRIGHT = "$${ACFUNQML_COPYRIGHT} By goplayegg"
DESCRIPTION  = "$${APP_CASE_ID}"
DEFINES += RC_VERSION=$$replace(ACFUNQML_VERSION, "\\.", ","),0 \
        RC_VERSION_STRING=\"$${ACFUNQML_COMPAT_VERSION}\" \
        RC_DESCRIPTION_STRING=\"$$replace(DESCRIPTION, " ", "\\x20")\" \
        RC_COPYRIGHT=\"$$replace(COPYRIGHT, " ", "\\x20")\"
RC_FILE = acfunQml.rc

DEFINES += OS_WIN
