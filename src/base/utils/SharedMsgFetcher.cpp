#include "SharedMsgFetcher.h"
#include <QSharedMemory>
#include <QTimer>
#include <QBuffer>
#include <QDataStream>
#include <QDebug>

namespace Util {

SharedMsgFetcher::SharedMsgFetcher(QObject *parent)
    :QObject(parent)
{
    m_pSharedMem = new QSharedMemory(this);
    m_pTimer = new QTimer(this);
    m_pTimer->setInterval(1000);
    connect(m_pTimer, &QTimer::timeout, this, &SharedMsgFetcher::onTimer);
}

void SharedMsgFetcher::setKey(const QString &key)
{
    m_pSharedMem->setKey(key);
    m_pTimer->start();
}

void SharedMsgFetcher::onTimer()
{
    if (!m_pSharedMem->attach()) {
        //qDebug()<<"Unable to attach to shared memory segment.";
        return;
    }

    QBuffer buffer;
    QDataStream in(&buffer);

    QString msg;
    m_pSharedMem->lock();
    buffer.setData((char*)m_pSharedMem->constData(), m_pSharedMem->size());
    buffer.open(QBuffer::ReadOnly);
    in >> msg;
    m_pSharedMem->unlock();

    m_pSharedMem->detach();
    qDebug()<<"GPE:SharedMsgFetcher "<<msg;
    emit msgComing(msg);
}

}
