#pragma once
#include <QObject>
#include <QQmlParserStatus>

class QTextDocument;
namespace Util {

class CommonTools: public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
public:
    explicit CommonTools(QObject *parent = 0);
    Q_INVOKABLE QString cvtToHtml(const QString &source);
    Q_INVOKABLE QString cvtArticleTitle(const QString &title, const QString &body);

signals:
    // QQmlParserStatus interface
public:
    void classBegin() override;
    void componentComplete() override;
private:
    QTextDocument* m_pDoc{nullptr};
};

}
