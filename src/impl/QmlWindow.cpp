﻿#include "QmlWindow.h"
#include "utils/FileSaver.h"
#include "utils/CommonTools.h"
#include "danmakupaser.h"
#include "documenthandler.h"
#include "acCommentPaser.h"
#include "textDocHandler.h"
#include "acCmtPaseAndShow.h"
#include "base/qtkeychain/keychain.h"

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


QmlWindowPrivate::QmlWindowPrivate(QmlWindow *window)
    : lazyPref([=]{ return new QmlPreferences(window); }),
      m_parent(window)
{

    m_languageList << u8"中文简体";
//                       << u8"English"
//                       << u8"日本語"
//                       << u8"한국어"
//                       << u8"Français"
//                       << u8"Español"
//                       << u8"Portugués"
//                       << u8"In Italiano"
//                       << u8"русский язык"
//                       << u8"Tiếng Việt"
//                       << u8"Deutsch"
//                       << u8" عربي ، ";
    QStringList fileList;
    fileList << "trans_zh.qm";
//                << "trans_en.qm"
//                << "trans_ja.qm"
//                << "trans_ko.qm"
//                << "trans_fr.qm"
//                << "trans_es.qm"
//                << "trans_pt.qm"
//                << "trans_it.qm"
//                << "trans_ru.qm"
//                << "trans_vi.qm"
//                << "trans_de.qm"
//                << "trans_ar.qm";

    for (auto i = 0; i < m_languageList.length(); ++i)
    {
        auto trans = std::make_shared<QTranslator>();
        auto trPath = QCoreApplication::applicationDirPath()+"/trans/"+fileList.at(i);
        bool ok = trans->load(trPath);
        qDebug() << m_languageList.at(i) << fileList.at(i) << ok<<" current path:"<<trPath;
        m_transMap[m_languageList.at(i)] = trans;
    }
    if(lazyPref.get()){
        m_lang = lazyPref->value("translation").toString();
    }
    if(m_lang.isEmpty()){
        m_lang = m_languageList.at(0);
    }
    qDebug()<<"language:"<<m_lang;
    m_pLastLang = m_transMap[m_lang].get();
    QCoreApplication::installTranslator(m_pLastLang);
    lazyPref->setValue("appPath",QCoreApplication::applicationDirPath());
}

void QmlWindowPrivate::reTrans(const QString &lang)
{
    if (m_lang == lang)
    {
        return;
    }
    QCoreApplication::removeTranslator(m_pLastLang);
    m_pLastLang = m_transMap[lang].get();
    QCoreApplication::installTranslator(m_pLastLang);
    m_lang = lang;
    m_parent->qmlEgine()->retranslate();
}

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
    QKeychain::seQMLReadJob();
    QKeychain::seQMLWriteJob();
    QKeychain::seQMLDeleteJob();
    ::qmlRegisterType<QmlPreferences>("AcfunQml", 1, 0, "QmlPreferences");
    ::qmlRegisterType<constPreferences>("AcfunQml", 1, 0, "ConstPreferences");
    ::qmlRegisterType<DanmakuPaser>("AcfunQml", 1, 0, "DanmakuPaser");
    ::qmlRegisterType<DocumentHandler>("AcfunQml", 1, 0, "DocumentHandler");
    //::qmlRegisterType<AcCommentPaser>("AcfunQml", 1, 0, "AcCommentPaser");
    ::qmlRegisterType<TextDocHandler>("AcfunQml", 1, 0, "TextDocHandler");
    ::qmlRegisterType<AcCmtPaseAndShow>("AcfunQml", 1, 0, "AcCmtPaseAndShow");
    ::qmlRegisterType<HttpRequest>("Network",1, 0, "HttpRequest");

    qmlRegisterSingletonType<HttpRequestFactory>("Network",
                                                 1, 0,
                                                 "HttpRequestFactory",
                                                 &HttpRequestFactory::singleton);

    // Register qml global properties
    m_qmlEgnine->rootContext()->setContextProperty("g_preference", d->lazyPref.get());
    m_qmlEgnine->rootContext()->setContextProperty("g_languageList", d->m_languageList);
    m_qmlEgnine->setNetworkAccessManagerFactory(new MyNetworkAccessManagerFactory());
    Util::FileSaver *pFileSaver = new Util::FileSaver(this);
    m_qmlEgnine->rootContext()->setContextProperty("g_fileSaver", pFileSaver);
    m_pTools = new Util::CommonTools(this);
    m_qmlEgnine->rootContext()->setContextProperty("g_commonTools", m_pTools);
}

void QmlWindow::reTrans(const QString &lang)
{
    d->reTrans(lang);
}

void QmlWindow::inputCmd(const QString &cmd)
{
    qDebug() << "acfunqml QmlWindow::inputCmd"<<cmd;
    const QString strExeUrl ="AcfunQml://";
    if(!cmd.startsWith(strExeUrl, Qt::CaseInsensitive)){
        qDebug() << "only support cmd started width AcfunQml://";
        return;
    }
    auto strEncode = cmd.mid(strExeUrl.length());
    if(strEncode.endsWith('/')){
        strEncode = strEncode.left(strEncode.length()-1);
    }
    QByteArray ba;
    ba.append(strEncode);
    auto strDecode = QUrl::fromPercentEncoding(ba);
    qDebug() <<strDecode;
    if(m_pTools){
        m_pTools->externalCmd(strDecode);
    }
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
