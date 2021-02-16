#pragma once
#include <atomic>

class QWindow;
namespace Util {

class ScreenSaver {
public:
    ~ScreenSaver();
	static void disable();

	static void restore();

    static void init();

    static QWindow* m_pWnd;
private:

    ScreenSaver();
    static std::atomic<bool> m_stayingAwake;
};
}
