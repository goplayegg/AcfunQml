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

    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void resume();
    Q_INVOKABLE void updateDanm(const QJsonObject &jsObj);

signals:
    void popDanm(const QJsonObject &jsObj);
private slots:
    void onTimerPop();
private:
    void getDanm();
    void getDanmMap();
    QTimer *m_pTimer{nullptr};
    QJsonObject m_jsDanm;
    std::map<int, QJsonObject> m_mapDanm;
};
QML_DECLARE_TYPE(DanmakuPaser)

#endif // DANMAKUPASER_H
