#pragma once
#include <QObject>
#include <QQmlParserStatus>
#include <QNetworkAccessManager>

class QFile;
namespace Util {

class FileSaver: public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
public:
    explicit FileSaver(QObject *parent = 0);
    Q_INVOKABLE bool saveImg(QString source, QString path);

signals:
    void finished(bool succ);
    // QQmlParserStatus interface
public:
    void classBegin() override;
    void componentComplete() override;
};

class HttpDownloader: public QObject
{
    Q_OBJECT
public:
    explicit HttpDownloader(QObject *parent = 0);
    ~HttpDownloader();
    void download(const QString &source, const QString &path);
signals:
    void sigFinished(bool);
private slots:
    void httpFinished();
    void httpReadyRead();
    void httpProgress(qint64 bytesRead, qint64 totalBytes);
private:
    QFile *m_pFile{nullptr};
    QNetworkAccessManager m_qnam;
    QNetworkReply *m_reply{nullptr};
};

}
