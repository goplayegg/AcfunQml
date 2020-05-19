#include "QmlWindow.h"
#include "utils/Lazy.h"
#include "QmlPreferences.h"
#include "danmakupaser.h"
#include <QCoreApplication>

#ifdef QT_DEBUG
    static const QString QMLPrefix = QStringLiteral("../src/");
#else
    static const QString QMLPrefix = QStringLiteral("qrc:///");
#endif

#include <QQmlNetworkAccessManagerFactory>

#include <HttpRequest>
#include <NetworkCookieJar>

class MyNetworkAccessManagerFactory : public QQmlNetworkAccessManagerFactory
{
public:
    virtual QNetworkAccessManager *create(QObject *parent);
};

QNetworkAccessManager *MyNetworkAccessManagerFactory::create(QObject *parent)
{
    QNetworkAccessManager *nam = new QNetworkAccessManager(parent);

    nam->setCookieJar(new NetworkCookieJar(nam));

    return nam;
}

class QmlWindowPrivate
{
public:
    QmlWindowPrivate(QmlWindow *window)
        : lazyPref([=]{ return new QmlPreferences(window); })
    {

    }

    Util::Lazy<QmlPreferences> lazyPref;
};

QmlWindow::QmlWindow(QObject *parent)
    : QObject(parent)
    , d(new QmlWindowPrivate(this))
    , m_qmlEgnine(new QQmlApplicationEngine(this))
{
}

QQmlApplicationEngine *QmlWindow::qmlEgine()
{
    return m_qmlEgnine;
}

void QmlWindow::qmlRegisterType()
{
    ::qmlRegisterType<QmlPreferences>("AcfunQml", 1, 0, "QmlPreferences");
    ::qmlRegisterType<DanmakuPaser>("AcfunQml", 1, 0, "DanmakuPaser");
    ::qmlRegisterType<HttpRequest>("Network",1, 0, "HttpRequest");

    qmlRegisterSingletonType<HttpRequestFactory>("Network",
                                                 1, 0,
                                                 "HttpRequestFactory",
                                                 &HttpRequestFactory::singleton);

    // Register qml global properties
    m_qmlEgnine->rootContext()->setContextProperty("g_preference", d->lazyPref.get());

    m_qmlEgnine->setNetworkAccessManagerFactory(new MyNetworkAccessManagerFactory());

}

void QmlWindow::show()
{
    m_indexUrl = QUrl(QMLPrefix + QStringLiteral("ui/main.qml"));
    QObject::connect(m_qmlEgnine, &QQmlApplicationEngine::objectCreated,
                     this, [this](QObject *obj, const QUrl &objUrl)
    {
        if (!obj && m_indexUrl == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    m_qmlEgnine->load(m_indexUrl);
}
