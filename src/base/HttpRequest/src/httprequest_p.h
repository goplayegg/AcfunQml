#ifndef HTTPREQUEST_P_H
#define HTTPREQUEST_P_H

#include <QObject>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>

#include "httprequest.h"

class HttpRequestPrivate : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QByteArray responseText READ getResponseText WRITE setResponseText NOTIFY responseTextChanged)
    Q_PROPERTY(HttpRequest::State readyState READ getReadyState WRITE setReadyState NOTIFY readyStateChanged)
    Q_PROPERTY(HttpRequest::NetworkStatus status READ getStatus WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(QString statusText READ getStatusText WRITE setStatusText NOTIFY statusTextChanged)

public:

    HttpRequestPrivate(QObject* parent = Q_NULLPTR):
        HttpRequestPrivate(Q_NULLPTR, parent)
    {}

    HttpRequestPrivate(QNetworkAccessManager* networkManager, QObject* parent = Q_NULLPTR):
        QObject(parent),
        timeout(5 * 1000),                            // 30 s
        reply(Q_NULLPTR),
        readyState(HttpRequest::UnStart),
        status(HttpRequest::NoError),
        manager(networkManager),
        usageCount(0)
    { }

    ~HttpRequestPrivate()
    { }

    QString getMethodName() const {
        return methodName;
    }

    void setMethodName(const QString &value) {
        methodName = value;
    }

    HttpRequest::State getReadyState() const {
        return readyState;
    }

    void setReadyState(const HttpRequest::State &value) {
        if(readyState != value) {
            readyState = value;
            Q_EMIT readyStateChanged();
        }
    }

    HttpRequest::NetworkStatus getStatus() const {
        return status;
    }

    void setStatus(const HttpRequest::NetworkStatus &value)  {
        if(status != value ) {
            status = value;
            Q_EMIT statusChanged();
        }
    }

    QNetworkRequest getRequest() const {
        return request;
    }

    void setRequest(const QNetworkRequest &value) {
        request = value;
    }

    QNetworkReply *getReply() const {
        return reply;
    }

    void setReply(QNetworkReply *value) {
        if(reply != value) {
            if(reply) {
                reply->disconnect();
            }
            reply = value;
            if(reply) {
                connect(reply, &QNetworkReply::finished,
                        this, &HttpRequestPrivate::onFinished);
            }
        }
    }

    QString getStatusText() const {
        return statusText;
    }

    void setStatusText(const QString &value) {
        if(statusText != value) {
            statusText = value;
            Q_EMIT statusTextChanged();
        }
    }

    QByteArray getResponseText() const {
        return responseText;
    }

    void setResponseText(const QByteArray &value) {
        if(responseText != value) {
            responseText = value;
            Q_EMIT responseTextChanged();
        }
    }

    QList<QNetworkReply::RawHeaderPair> getRawHeaderPairs() const {
        return rawHeaderPairs;
    }

    void clear() {
        rawHeaderPairs.clear();
        this->setRequest(QNetworkRequest());
        this->setReadyState(HttpRequest::UnStart);
        this->setMethodName("");
        this->setReply(Q_NULLPTR);
        this->usageCount = 0;
    }

    int getTimeout() const {
        return timeout;
    }

    void setTimeout(int value) {
        timeout = value;
    }

    QNetworkAccessManager *getManager() const {
        return manager;
    }

    void setManager(QNetworkAccessManager *value) {
        manager = value;
    }

    int getUsageCount() const {
        return usageCount;
    }

    int increaseUsageCount() {
       return ++usageCount;
    }

Q_SIGNALS:
    void responseTextChanged();
    void readyStateChanged();
    void statusChanged();
    void statusTextChanged();
    void finished();
    void error();

private Q_SLOTS:
    void onFinished() {
        if(reply) {
            this->setResponseText(reply->readAll());
            QNetworkReply::NetworkError e = reply->error();
            this->setStatus((HttpRequest::NetworkStatus)e);
            rawHeaderPairs = reply->rawHeaderPairs();

            if(e != QNetworkReply::NoError) {
                this->setReadyState(HttpRequest::Error);
                this->setStatusText(reply->errorString());
                Q_EMIT error();
                // error Not finished
                return ;
            } else {
                this->setReadyState(HttpRequest::Finished);
                this->setStatusText("");
            }

            Q_EMIT finished();
        }
    }

private:
    int timeout;

    QNetworkRequest request;
    QNetworkReply* reply;

    QString methodName;

    HttpRequest::State readyState;
    HttpRequest::NetworkStatus status;
    QString statusText;

    QList<QNetworkReply::RawHeaderPair> rawHeaderPairs;
    QByteArray responseText;

    QNetworkAccessManager* manager;

    // for time out
    int usageCount;
};

#endif // HTTPREQUEST_P_H

