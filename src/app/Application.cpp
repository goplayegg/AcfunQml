#include "Application.h"
#include "QmlWindow.h"
#include "utils/SharedMsgSender.h"
#include "utils/SharedMsgFetcher.h"

#include <QTextCodec>
#include <QTranslator>
#include <QPointer>
#include <QTimer>
#include <qDebug>
#include <QIcon>

class ApplicationPrivate
{
    Q_PTR(Application)
public:
    ApplicationPrivate(Application *app);

    QPointer<QmlWindow> qmlWindow;
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
    setDesktopFileName("org.acfunQml.acfunQml");

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
    if(argc >1 )
    {
        m_strCmd = QString(argv[1]);
        qDebug()<<"acfunQml command line start with:"<<m_strCmd;
    }

    // 6. initialize settings

    // 7.load plugins if have

    setWindowIcon(QIcon(":/assets/img/appIcon.png"));

}

Application::~Application()
{
    // TODO: free

    qDebug() << "Application::~Application()";
}

int Application::exec(const QStringList &params)
{
    auto key = applicationName()+organizationDomain()+" by GoPlayEgg";
    Util::SharedMsgSender *pMsgSender = nullptr;
    Util::SharedMsgFetcher *pMsgFetcher = nullptr;
    if(params.size()){
        pMsgSender = new Util::SharedMsgSender(this);
        connect(pMsgSender, &Util::SharedMsgSender::timeout, this, &QCoreApplication::quit);
        pMsgSender->setKey(key);
        pMsgSender->sendMsg(m_strCmd);
    }else{
        pMsgFetcher = new Util::SharedMsgFetcher(this);
        connect(pMsgFetcher, &Util::SharedMsgFetcher::msgComing, [this](const QString &msg){
            d->qmlWindow->inputCmd(msg);});
        pMsgFetcher->setKey(key);
        d->qmlWindow = new QmlWindow(this);
        d->qmlWindow->qmlRegisterType();
        d->qmlWindow->show();
        d->qmlWindow->inputCmd(m_strCmd);
    }

    auto ret = BaseApplication::exec();
    delete pMsgSender;
    delete pMsgFetcher;
    delete d->qmlWindow;
    return ret;
}
