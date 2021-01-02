#include "SharedMsgSender.h"
#include <QSharedMemory>
#include <QTimer>
#include <QBuffer>
#include <QDataStream>
#include <QDebug>

namespace Util {

SharedMsgSender::SharedMsgSender(QObject *parent)
    :QObject(parent)
{
    m_pSharedMem = new QSharedMemory(this);
    m_pTimer = new QTimer(this);
    m_pTimer->setInterval(1500);
    m_pTimer->setSingleShot(true);
    connect(m_pTimer, &QTimer::timeout, this, &SharedMsgSender::timeout);
}

void SharedMsgSender::setKey(const QString &key)
{
    m_pSharedMem->setKey(key);
}

void SharedMsgSender::setTimeout(int milliseconds)
{
    m_pTimer->setInterval(milliseconds);
}

void SharedMsgSender::sendMsg(const QString &msg)
{
    if (m_pSharedMem->isAttached()){
        if (!m_pSharedMem->detach())
            qDebug()<<"GPE: SharedMsgSender Unable to detach from shared memory.";
    }

    // load into shared memory
    QBuffer buffer;
    buffer.open(QBuffer::ReadWrite);
    QDataStream out(&buffer);
    out << msg;
    int size = buffer.size();
    qDebug()<<"GPE: SharedMsgSender size:"<<size;

    if (!m_pSharedMem->create(size)) {
        qDebug()<<"GPE: SharedMsgSender Unable to create shared memory segment.";
        return;
    }
    m_pSharedMem->lock();
    char *to = (char*)m_pSharedMem->data();
    const char *from = buffer.data().data();
    memcpy(to, from, qMin(m_pSharedMem->size(), size));
    m_pSharedMem->unlock();

    m_pTimer->start();
}

}
