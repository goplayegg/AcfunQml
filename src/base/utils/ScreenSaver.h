#pragma once
#include <QAbstractNativeEventFilter>

/**
 * Enables/disables the screensaver.
 *
 * Under Windows, this class catches Windows events SC_SCREENSAVE and SC_MONITORPOWER.
 * This class does not use Windows function SystemParametersInfo() with parameter SPI_SETSCREENSAVEACTIVE
 * because in case the application crashes it won't restore the screensaver and power parameters from Windows.
 * Instead by catching events SC_SCREENSAVE and SC_MONITORPOWER we don't modify Windows parameters
 * and thus no problem if the application crashes.
 *
 * @author Tanguy Krotoff
 */
class QWindow;
namespace Util {

class ScreenSavFilter: public QAbstractNativeEventFilter{
public:
    bool nativeEventFilter(const QByteArray &eventType, void *message, long *) override;
};

class ScreenSaver {
public:

	static void disable();

	static void restore();

    static void init();//call in QApplication thread

    static QWindow* m_pWnd;
private:

	ScreenSaver();
    static ScreenSavFilter* m_pFilter;
};
}
