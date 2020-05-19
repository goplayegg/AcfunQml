#include "networkcookiejar.h"

#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QtDebug>
#include <QTextStream>
#include <QNetworkCookie>

NetworkCookieJar::NetworkCookieJar(QObject *parent):
    QNetworkCookieJar(parent)
{
    QString cookiePath = QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QDir::separator() + "cookies";
    QDir().mkpath(cookiePath);
    QString cookieFile =cookiePath + QDir::separator() +"cookies.txt";

    qDebug() << "cookieFile" << cookieFile;

    QList<QNetworkCookie> cookies;
    if(QFile::exists(cookieFile)) {
        QFile file(cookieFile);
        if(file.open(QFile::ReadOnly)) {
            QTextStream textStream(&file);

            while(!textStream.atEnd()) {
                auto cookie = QNetworkCookie::parseCookies(textStream.readLine().toUtf8());
                cookies.push_back(cookie.at(0));
            }

#ifdef QT_DEBUG
            qDebug() << "cookies.length()" << cookies.length();
#endif
            this->setAllCookies(cookies);
            file.close();
        }
    } else {
#ifdef QT_DEBUG
        qDebug() << "file not exists";
#endif
    }
}

NetworkCookieJar::~NetworkCookieJar()
{
    this->save();
}

QList<QNetworkCookie> NetworkCookieJar::getAllCookies() const
{
    return this->allCookies();
}

void NetworkCookieJar::save()
{
    QString cookiePath = QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QDir::separator() + "cookies";
    QDir().mkpath(cookiePath);
    QString cookieFile = cookiePath + QDir::separator() +"cookies.txt";

    QList<QNetworkCookie> cookies = this->allCookies();

    QFile file(cookieFile);
    if(file.open(QFile::WriteOnly)) {
        QTextStream writer(&file);
        foreach(auto cookie, cookies) {
            QString cookieString = cookie.toRawForm();
            writer << cookieString << endl;
#ifdef QT_DEBUG
            qDebug() <<"cookieString" << cookieString;
#endif
        }
        file.close();
    } else {
#ifdef QT_DEBUG
        qDebug() << file.fileName();
        qDebug() << file.errorString();
#endif
    }
}
