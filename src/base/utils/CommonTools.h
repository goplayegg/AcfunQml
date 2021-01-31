#pragma once
#include <QObject>
#include <QQmlParserStatus>
#include <QVariant>

class QTextDocument;
namespace Util {

class CommonTools: public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
public:
    explicit CommonTools(QObject *parent = 0);
    Q_PROPERTY(QString osType READ osType NOTIFY osTypeChanged FINAL)//操作系统: win mac linux
    Q_INVOKABLE QString cvtToHtml(const QString &source);
    Q_INVOKABLE QString cvtArticleTitle(const QString &title, const QString &body);
    Q_INVOKABLE QString token(const QString &unixTime);//wrong methed
    Q_INVOKABLE QString mainFontFamily();
    Q_INVOKABLE QString articleFontFamily();
    Q_INVOKABLE void disableScreenSaver(bool bDis);
    Q_INVOKABLE void setMainWnd(QVariant wnd);

    QString osType() const;
signals:
    void externalCmd(const QString &json);
    void osTypeChanged(const QString &type);
    // QQmlParserStatus interface
public:
    void classBegin() override;
    void componentComplete() override;
private:
    QTextDocument* m_pDoc{nullptr};
};

}
