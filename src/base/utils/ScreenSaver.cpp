#include "ScreenSaver.h"
#include <QApplication>
#include <QDebug>
#include <QWindow>

#ifdef OS_WIN
    #include <windows.h>

    HANDLE _powerRequest = INVALID_HANDLE_VALUE;
#endif	//OS_WIN

#ifdef OS_X11
    #include <QProcess>

    QProcess * _xdgScreenSaverProcess = NULL;
    WId _XWindowID = 0;
#endif	//OS_X11

#ifdef OS_MAC
    #include <Availability.h>
    #include <IOKit/pwr_mgt/IOPMLib.h>
    quint32 _osxIOPMAssertionId = 0U;
#endif //OS_MAC

namespace Util {

ScreenSaver::~ScreenSaver()
{
#ifdef OS_MAC
    if (_osxIOPMAssertionId) {
        IOPMAssertionRelease((IOPMAssertionID)_osxIOPMAssertionId);
        _osxIOPMAssertionId = 0U;
    }
#endif //OS_MAC

#ifdef OS_WIN
    if (m_stayingAwake)
        restore();
#endif //OS_WIN
}

void ScreenSaver::disable() {
    qDebug() << "Disable screensaver";

#ifdef OS_WIN
    if (m_stayingAwake)
        return;

    REASON_CONTEXT rc;
    std::wstring wreason(L"AcfunQmlScreenSaver");
    rc.Version = POWER_REQUEST_CONTEXT_VERSION;
    rc.Flags = POWER_REQUEST_CONTEXT_SIMPLE_STRING;
    rc.Reason.SimpleReasonString = (wchar_t *) wreason.c_str();
    _powerRequest = PowerCreateRequest(&rc);
    if (_powerRequest == INVALID_HANDLE_VALUE)
    {
        qDebug() << "Error creating power request:" << GetLastError();
        return;
    }
    qDebug() << "Disable screensaver PowerCreateRequest succeed";
    m_stayingAwake = PowerSetRequest(_powerRequest, PowerRequestDisplayRequired);
    if (!m_stayingAwake)
    {
        qDebug() << "Error running PowerSetRequest():" << GetLastError();
    }
    else
    {
        qDebug() << "Disable screensaver succeed";
    }
#endif	//OS_WIN

#ifdef OS_X11
    QApplication * app = qobject_cast<QApplication *>(QApplication::instance());
    Q_ASSERT(app);
	if (!_xdgScreenSaverProcess) {
        //Lazy initialization
        _xdgScreenSaverProcess = new QProcess(app);
	}
    if(!m_pWnd)
        return;
    _XWindowID = m_pWnd->winId();
	QStringList args;
	args << "suspend";
    args << QString::number(_XWindowID);
	int errorCode = _xdgScreenSaverProcess->execute("xdg-screensaver", args);
    qDebug() << args << errorCode;
    qDebug() << _xdgScreenSaverProcess->readAll();
#endif	//OS_X11

#ifdef OS_MAC
    IOPMAssertionID assertionId = _osxIOPMAssertionId;
    IOReturn r = IOPMAssertionCreateWithDescription(kIOPMAssertionTypePreventUserIdleDisplaySleep,
                                                    CFSTR("AcfunQmlScreenSaver"),
                                                    NULL, NULL, NULL, 0, NULL, &assertionId);
    if (r == kIOReturnSuccess) {
        _osxIOPMAssertionId = assertionId;
    }
    qDebug() << "IOPMAssertionDeclareUserActivity return:"<<r<<"  _osxIOPMAssertionId:"<<_osxIOPMAssertionId;
#endif //OS_MAC
}

void ScreenSaver::restore() {
    qDebug() << "Restore screensaver";

#ifdef OS_WIN
    if (!m_stayingAwake)
        return;
    bool bCleared = PowerClearRequest(_powerRequest, PowerRequestDisplayRequired);
    if (!bCleared)
    {
        qDebug() << "Error running PowerClearRequest():" << GetLastError();
    }
    else
    {
        qDebug() << "Restore screensaver succeed";
    }
    CloseHandle(_powerRequest);
    _powerRequest = INVALID_HANDLE_VALUE;
    m_stayingAwake = false;
#endif	//OS_WIN

#ifdef OS_X11
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
#endif	//OS_X11

#ifdef OS_MAC
    if (_osxIOPMAssertionId) {
        auto r = IOPMAssertionRelease((IOPMAssertionID)_osxIOPMAssertionId);
        qDebug() << "IOPMAssertionRelease return:"<<r<<"  _osxIOPMAssertionId:"<<_osxIOPMAssertionId;
        _osxIOPMAssertionId = 0U;
    }
#endif //OS_MAC
}

std::atomic<bool> ScreenSaver::m_stayingAwake;
QWindow* ScreenSaver::m_pWnd = nullptr;
void ScreenSaver::init()
{
#ifdef OS_WIN
    m_stayingAwake = false;
#endif //OS_WIN
}

}
