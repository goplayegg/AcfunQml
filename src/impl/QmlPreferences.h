#ifndef QMLPREFERENCES_H
#define QMLPREFERENCES_H

#include <QObject>
#include <QSettings>
#include <QQmlParserStatus>
#include <QtQml>

class QmlPreferencesPrivate;
class QmlPreferences : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    Q_DISABLE_COPY(QmlPreferences)
    Q_DECLARE_PRIVATE_D(d, QmlPreferences)
    Q_PROPERTY(QSettings* settings READ settings WRITE setSettings FINAL)
    Q_PROPERTY(QString category READ category WRITE setCategory FINAL)
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName FINAL)
public:
    explicit QmlPreferences(QObject *parent = nullptr);
    explicit QmlPreferences(QSettings *settings, QObject *parent = nullptr);
    ~QmlPreferences() override;

    void setSettings(QSettings *settings);
    QSettings *settings();

    QString category() const;
    void setCategory(const QString &category);

    QString fileName() const;
    void setFileName(const QString &fileName);

    Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);

signals:

private slots:
    void propertyChanged();

protected:
    void timerEvent(QTimerEvent *event) override;
    void classBegin() override;
    void componentComplete() override;

private:
    QScopedPointer<QmlPreferencesPrivate> d;
};

class constPreferences :public QObject
{
    Q_OBJECT
public:
    explicit constPreferences(QObject *parent = nullptr);

    Q_INVOKABLE QVariant get(const QString &key);
};

QML_DECLARE_TYPE(constPreferences)
QML_DECLARE_TYPE(QmlPreferences)
QML_DECLARE_TYPE(QSettings)

#endif // QMLPREFERENCES_H
