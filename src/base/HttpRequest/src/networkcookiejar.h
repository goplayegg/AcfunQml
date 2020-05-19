#ifndef NETWORKCOOKIEJAR_H
#define NETWORKCOOKIEJAR_H

#include <QNetworkCookieJar>

class QNetworkCookie;
class NetworkCookieJar : public QNetworkCookieJar
{
    Q_OBJECT
public:
    explicit NetworkCookieJar(QObject *parent = 0);
    ~NetworkCookieJar();
    QList<QNetworkCookie> getAllCookies()const;

public slots:
    void save();
};

#endif // NETWORKCOOKIEJAR_H
