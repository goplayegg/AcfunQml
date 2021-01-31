#include "ScreenSaver.h"
#include <QApplication>
#include <QDebug>

#ifdef OS_WIN
    #include <windows.h>
#endif	//OS_WIN

#ifdef OS_MAC
    #include <QWidget>
    #include <QProcess>

    QProcess * _xdgScreenSaverProcess = NULL;
    WId _XWindowID = 0;
#endif	//OS_MAC

namespace Util {

void ScreenSaver::disable() {
    qDebug() << "Disable screensaver";

	QApplication * app = qobject_cast<QApplication *>(QApplication::instance());
	Q_ASSERT(app);

#ifdef OS_WIN
	//restore() will set the event filter to NULL
    app->installNativeEventFilter(m_pFilter);
#endif	//OS_WIN

#ifdef OS_MAC
	if (!_xdgScreenSaverProcess) {
		//Lazy initialization
		_xdgScreenSaverProcess = new QProcess(app);
	}
	_XWindowID = app->activeWindow()->winId();
	QStringList args;
	args << "suspend";
	args << QString::number(_XWindowID);
	int errorCode = _xdgScreenSaverProcess->execute("xdg-screensaver", args);
    qDebug() << args << errorCode;
    qDebug() << _xdgScreenSaverProcess->readAll();
#endif	//OS_MAC
}

void ScreenSaver::restore() {
    qDebug() << "Restore screensaver";

	QApplication * app = qobject_cast<QApplication *>(QApplication::instance());
	Q_ASSERT(app);

#ifdef OS_WIN
    app->removeNativeEventFilter(m_pFilter);
#endif	//OS_WIN

#ifdef OS_MAC
	if (_XWindowID > 0) {
		QStringList args;
		args << "resume";
		args << QString::number(_XWindowID);
		if (_xdgScreenSaverProcess) {
			int errorCode = _xdgScreenSaverProcess->execute("xdg-screensaver", args);
            qDebug() << args << errorCode;
            qDebug() << _xdgScreenSaverProcess->readAll();
		} else {
            qDebug() << "No xdg-screensaver process";
		}
	} else {
        qDebug() << "_XWindowID cannot be 0";
	}
#endif	//OS_MAC
}

ScreenSavFilter* ScreenSaver::m_pFilter = nullptr;
void ScreenSaver::init()
{
    if(nullptr == m_pFilter){
        m_pFilter = new ScreenSavFilter();
    }
}

bool ScreenSavFilter::nativeEventFilter(const QByteArray &eventType, void *message, long *result)
{
#ifdef OS_WIN
    MSG * msg = static_cast<MSG *>(message);

    if (msg && msg->message == WM_SYSCOMMAND) {
        if (msg->wParam == SC_SCREENSAVE || msg->wParam == SC_MONITORPOWER) {
            //Intercept ScreenSaver and Monitor Power Messages
            //Prior to activating the screen saver, Windows send this message with the wParam
            //set to SC_SCREENSAVE to all top-level windows. If you set the return value of the
            //message to a non-zero value the screen saver will not start.

            //In fact, because of Qt, we don't care about the result value
            //It works with values 0 & 1
            //*result = 1; this may crash in win10

            qDebug() << "Intercept Windows screensaver event";

            //bool QCoreApplication::winEventFilter(MSG * msg, long * result)
            //If you don't want the event to be processed by Qt, then return true and
            //set result to the value that the window procedure should return.
            //Otherwise return false.
            return true;
        }
    }
#endif	//OS_WIN
    return false;
}

}
