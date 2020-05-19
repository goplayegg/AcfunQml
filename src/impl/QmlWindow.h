#ifndef QMLWINDOW_H
#define QMLWINDOW_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QPointer>

class QmlWindowPrivate;

class QmlWindow : public QObject
{
    Q_OBJECT
public:
    explicit QmlWindow(QObject *parent = nullptr);

    QQmlApplicationEngine *qmlEgine();

    void qmlRegisterType();

signals:

public slots:
    void show();

private:
    QUrl m_indexUrl;
    QPointer<QQmlApplicationEngine> m_qmlEgnine;

    // for testing ...
    QScopedPointer<QmlWindowPrivate> d;
};

#endif // QMLWINDOW_H
