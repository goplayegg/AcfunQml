#ifndef DANMAKUPASER_H
#define DANMAKUPASER_H

#include <QObject>
#include <QJsonObject>
#include <QtQml>
#include <map>

class QTimer;
class DanmakuPaser :public QObject
{
    Q_OBJECT
public:
    explicit DanmakuPaser(QObject *parent = nullptr);

    Q_PROPERTY(qint64 timeStamp READ getTS WRITE setTs)
    Q_PROPERTY(float speed READ getSpeed WRITE setSpeed)
    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void resume();
    Q_INVOKABLE void updateDanm(const QJsonObject &jsObj);

    qint64 getTS() const
    {
        return m_timeStamp;
    }

    float getSpeed() const
    {
        return m_speed;
    }

public slots:
    void setTs(qint64 timeStamp)
    {
        m_timeStamp = timeStamp;
    }

    void setSpeed(float speed)
    {
        m_speed = speed;
    }

signals:
    void popDanm(const QJsonObject &jsObj);
private slots:
    void onTimerPop();
private:
    void getDanm();
    void getDanmMap();
    QTimer *m_pTimer{nullptr};
    QJsonObject m_jsDanm;
    std::map<qint64, QJsonObject> m_mapDanm;
    qint64 m_timeStamp{ 0 };
    float m_speed{ 1.0 };
};
QML_DECLARE_TYPE(DanmakuPaser)

#endif // DANMAKUPASER_H
