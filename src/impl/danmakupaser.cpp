#include "danmakupaser.h"
#include <QJsonDocument>
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QJsonArray>
#include <QTimer>
#include <QDateTime>
#include <thread>
#define CUT_TIME_S QDateTime::currentSecsSinceEpoch()
#define CUT_TIME_MS QDateTime::currentMSecsSinceEpoch()

static const int g_DanmPopInterval = 100;//ms
DanmakuPaser::DanmakuPaser(QObject *parent)
    :QObject(parent)
{
    m_pTimer = new QTimer(parent);
    m_pTimer->setInterval(g_DanmPopInterval);
    connect(m_pTimer, &QTimer::timeout, this, &DanmakuPaser::onTimerPop);
    connect(this, &DanmakuPaser::sigStart, this, [this](){
        if(m_bWorking){
            m_bWorking = false;
            m_pTimer->start();
        }
    }, Qt::QueuedConnection);
}

//for local danm test
void DanmakuPaser::getDanm()
{
    m_jsDanm = QJsonObject();
    QString str;
    QFile fi("danmakuTest.json");
    if(fi.open(QIODevice::ReadOnly))
    {
        QTextStream ts(&fi);
        str = ts.readAll();
    }
    QJsonDocument jsonDocument = QJsonDocument::fromJson(str.toStdString().c_str());
    if(!jsonDocument.isNull() ){
        m_jsDanm = jsonDocument.object();
    }
    qDebug()<<"json loaded:"<<m_jsDanm;
}

void DanmakuPaser::start()
{
    if(m_bWorking)
        return;
    m_pTimer->start();
}

void DanmakuPaser::stop()
{
    if(m_bWorking){
        m_bWorking = false;
        return;
    }
    m_pTimer->stop();
    m_mapDanm.clear();
}

void DanmakuPaser::pause()
{
    if(m_bWorking)
        return;
    m_pTimer->stop();
}

void DanmakuPaser::resume()
{
    if(m_bWorking)
        return;
    m_pTimer->start();
}

void DanmakuPaser::updateDanm(const QJsonObject &jsObj)
{
    if(m_bWorking)
        return;
    m_pTimer->stop();
    if(0){
        getDanm();
        getDanmMap();
    }else{
        m_jsDanm = jsObj;
        getDanmMap();
    }
}

void DanmakuPaser::onTimerPop()
{
    m_timeStamp+=g_DanmPopInterval*m_speed;
    auto iTimeStamp = m_timeStamp;
    QJsonArray arrPop;
    auto funcCmpTs = [iTimeStamp, this](std::pair<qint64,QJsonObject> const&pr){
        return (iTimeStamp >= pr.first &&
                iTimeStamp < pr.first +g_DanmPopInterval*m_speed);
    };
    auto itNeedPop = std::find_if(m_mapDanm.begin(),m_mapDanm.end(),funcCmpTs);
    while (itNeedPop!=m_mapDanm.end())
    {
        arrPop<<itNeedPop->second;
        itNeedPop = m_mapDanm.erase(itNeedPop);
        itNeedPop = std::find_if(itNeedPop,m_mapDanm.end(),funcCmpTs);
    }
    if(arrPop.empty())
        return;
    QJsonObject objPop;
    objPop.insert("list", arrPop);
    popDanm(objPop);
    //qDebug()<<"json pop:"<<objPop;
}

void DanmakuPaser::getDanmMap()
{
    qDebug()<<"getDanmMap";
    m_bWorking = true;
    std::thread thDealMap([this](){
        auto iStart = CUT_TIME_MS;
        auto danms = m_jsDanm["added"];
        {
            std::map<qint64, QJsonObject> tmp;
            m_mapDanm.swap(tmp);
        }
        if(danms.isArray())
        {
            auto danmArr = danms.toArray();
            for (auto it = danmArr.constBegin();it!=danmArr.constEnd(); ++ it)
            {
                m_mapDanm[(*it)["position"].toInt()] = it->toObject();
            }
        }
        //qDebug()<<"map merged:"<<m_mapDanm;
        auto elapse = CUT_TIME_MS - iStart;
        emit sigStart();
        qDebug()<<"updateDanm elapse: " << elapse << " ms";
    });
    thDealMap.detach();
}
