#pragma once
#include <QObject>

class QTimer;
class QSharedMemory;
namespace Util {

class SharedMsgSender : public QObject
{
    Q_OBJECT

public:
    explicit SharedMsgSender(QObject *parent = nullptr);
    void setKey(const QString&key);
    void setTimeout(int milliseconds);
    void sendMsg(const QString&msg);
signals:
    void timeout();
private:
    QSharedMemory *m_pSharedMem{nullptr};
    QTimer *m_pTimer{nullptr};
};

}
