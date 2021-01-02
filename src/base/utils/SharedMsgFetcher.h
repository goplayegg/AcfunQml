#pragma once
#include <QObject>

class QTimer;
class QSharedMemory;
namespace Util {

class SharedMsgFetcher : public QObject
{
    Q_OBJECT

public:
    explicit SharedMsgFetcher(QObject *parent = nullptr);
    void setKey(const QString&key);
signals:
    void msgComing(const QString&msg);
private:
    void onTimer();
    QSharedMemory *m_pSharedMem{nullptr};
    QTimer *m_pTimer{nullptr};
};

}
