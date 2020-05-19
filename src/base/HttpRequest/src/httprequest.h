#ifndef HTTPREQUEST_H
#define HTTPREQUEST_H

#include <QObject>

#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QQmlParserStatus>


class QQmlEngine;
class QJSEngine;

class HttpRequestPrivate;
class HttpRequestFactory;

/**
 * Only For Small Size Http Request
 * Don't Use In Big Size Http Request
*/
class HttpRequest : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
    Q_PROPERTY(QString responseText READ getResponseText NOTIFY responseTextChanged)
    Q_PROPERTY(HttpRequest::State readyState READ getReadyState NOTIFY readyStateChanged)
    Q_PROPERTY(HttpRequest::NetworkStatus status READ getStatus  NOTIFY statusChanged)
    Q_PROPERTY(QString statusText READ getStatusText NOTIFY statusTextChanged)

public:
    enum State {
        UnStart,
        Loading,
        Error,
        Finished,
        TimeOut,
    };
    Q_ENUM(State)

    enum NetworkStatus {
        NoError = QNetworkReply::NoError,

        // network layer errors [relating to the destination server] (1-99):
        ConnectionRefusedError = QNetworkReply::ConnectionRefusedError,
        RemoteHostClosedError = QNetworkReply::RemoteHostClosedError,
        HostNotFoundError = QNetworkReply::HostNotFoundError,
        TimeoutError = QNetworkReply::TimeoutError,
        OperationCanceledError = QNetworkReply::OperationCanceledError,
        SslHandshakeFailedError = QNetworkReply::SslHandshakeFailedError,
        TemporaryNetworkFailureError = QNetworkReply::TemporaryNetworkFailureError,
        NetworkSessionFailedError = QNetworkReply::NetworkSessionFailedError,
        BackgroundRequestNotAllowedError = QNetworkReply::BackgroundRequestNotAllowedError,
        UnknownNetworkError = QNetworkReply::UnknownNetworkError,

        // proxy errors (101-199):
        ProxyConnectionRefusedError = QNetworkReply::ProxyConnectionRefusedError,
        ProxyConnectionClosedError = QNetworkReply::ProxyConnectionClosedError,
        ProxyNotFoundError = QNetworkReply::ProxyNotFoundError,
        ProxyTimeoutError = QNetworkReply::ProxyTimeoutError,
        ProxyAuthenticationRequiredError = QNetworkReply::ProxyAuthenticationRequiredError,
        UnknownProxyError = QNetworkReply::UnknownProxyError,

        // content errors (201-299):
        ContentAccessDenied = QNetworkReply::ContentAccessDenied,
        ContentOperationNotPermittedError = QNetworkReply::ContentOperationNotPermittedError,
        ContentNotFoundError = QNetworkReply::ContentNotFoundError,
        AuthenticationRequiredError = QNetworkReply::AuthenticationRequiredError,
        ContentReSendError = QNetworkReply::ContentReSendError,
        ContentConflictError = QNetworkReply::ContentConflictError,
        ContentGoneError = QNetworkReply::ContentGoneError,
        UnknownContentError = QNetworkReply::UnknownContentError,

        // protocol errors
        ProtocolUnknownError = QNetworkReply::ProtocolUnknownError,
        ProtocolInvalidOperationError = QNetworkReply::ProtocolInvalidOperationError,
        ProtocolFailure = QNetworkReply::ProtocolFailure,

        // Server side errors (401-499)
        InternalServerError = QNetworkReply::InternalServerError,
        OperationNotImplementedError = QNetworkReply::OperationNotImplementedError,
        ServiceUnavailableError = QNetworkReply::ServiceUnavailableError,
        UnknownServerError = QNetworkReply::UnknownServerError
    };
    Q_ENUM(NetworkStatus)

    explicit HttpRequest(QObject *parent = 0);

    explicit HttpRequest(QNetworkAccessManager* networkManager, QObject *parent);

    ~HttpRequest();

    Q_INVOKABLE void clear();

    Q_INVOKABLE void setTimeout(qint32 time);

    Q_INVOKABLE int getTimeout() const;

    Q_INVOKABLE void setRequestCookies(const QJsonObject& cookies);

    Q_INVOKABLE void setRequestHeader(const QJsonObject& headers);

    Q_INVOKABLE void setRequestHeader(const QByteArray &headerName, const QByteArray &value);

    Q_INVOKABLE QString getRequestHeader(const QString& headerName) const ;

    Q_INVOKABLE void open(const QString& method, const QUrl& url, bool async = true); // 默认异步

    Q_INVOKABLE void send(const QString& data = QString(""));

    QString getResponseText() const;

    QString getStatusText() const;

    NetworkStatus getStatus() const;

    State getReadyState() const;

    Q_INVOKABLE QJsonArray getAllResponseHeader() const;

    QNetworkAccessManager* manager() const;
    void setManager(QNetworkAccessManager* manager);

    // QQmlParserStatus interface
public:
    void classBegin() override;
    void componentComplete() override;

Q_SIGNALS:
    void started();

    void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void uploadProgress(qint64 bytesSent, qint64 bytesTotal);

    void finished();
    void error();
    void timeout();

    void abort();

    void responseTextChanged();
    void readyStateChanged();
    void statusChanged();
    void statusTextChanged();

public Q_SLOTS:

protected:
    friend class HttpRequestFactory;

private:
    HttpRequestPrivate* d_ptr;


};


class HttpRequestFactory :  public QObject
{
    Q_OBJECT
public:
    explicit HttpRequestFactory(QObject* parent = Q_NULLPTR);

    Q_INVOKABLE HttpRequest* create();

    static QObject* singleton(QQmlEngine* engine, QJSEngine* jsEngine);
};



#endif // HTTPREQUEST_H
