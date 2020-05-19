#include "Application.h"

#ifndef DISABLE_GUI
#include "QmlWindow.h"
#endif

#include <QTextCodec>
#include <QTranslator>
#include <QPointer>
#include <QTimer>
#include <qDebug>

class ApplicationPrivate
{
    Q_PTR(Application)
public:
    ApplicationPrivate(Application *app);

#ifndef DISABLE_GUI
    QPointer<QmlWindow> qmlWindow;
#endif

    QTranslator translator;
};

ApplicationPrivate::ApplicationPrivate(Application *app)
    : q_ptr(app)
{

}

Application::Application(int &argc, char **argv)
    : BaseApplication(argc, argv)
    , d(new ApplicationPrivate(this))
{
    // TODO:
    // 1.setup application information: verison/window icon/attibute ...
    setApplicationName("acfunQml");
    setOrganizationDomain("acfunQml.org");

#if !defined (DISABLE_GUI)
    setDesktopFileName("org.acfunQml.acfunQml");
#endif

    // enable logger
	// ...

    // 2.install translations

    // 3.load fonts

    // 4.set string codec to UTF-8 for Qt4 ?
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
#if QT_VERSION < QT_VERSION_CHECK(5,0,0)
    QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
    QTextCodec::setCodecForTr(QTextCodec::codecForName("UTF-8"));
#endif

    // 5. command line parser

    // 6. initialize settings

    // 7.load plugins if have

    // 8. ...

}

Application::~Application()
{
    // TODO: free

    qDebug() << "Application::~Application()";
}

int Application::exec(const QStringList &params)
{
    Q_UNUSED(params)

#ifndef DISABLE_GUI
    d->qmlWindow = new QmlWindow(this);
    d->qmlWindow->qmlRegisterType();
    d->qmlWindow->show();
#endif


    return BaseApplication::exec();
}
