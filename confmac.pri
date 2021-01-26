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

DEFINES += OS_MAC
