#ifndef QMLWINDOW_H
#define QMLWINDOW_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QPointer>

class QmlWindowPrivate;
namespace Util {
    class CommonTools;
}
class QmlWindow : public QObject
{
    Q_OBJECT
public:
    explicit QmlWindow(QObject *parent = nullptr);

    QQmlApplicationEngine *qmlEgine();

    void qmlRegisterType();

    void reTrans(const QString &lang);

    void inputCmd(const QString &cmd);
signals:

public slots:
    void show();

private:
    QUrl m_indexUrl;
    QPointer<QQmlApplicationEngine> m_qmlEgnine;

    QScopedPointer<QmlWindowPrivate> d;
    Util::CommonTools *m_pTools{ nullptr };
};

#endif // QMLWINDOW_H
