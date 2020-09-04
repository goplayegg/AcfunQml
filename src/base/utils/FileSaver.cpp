#include "FileSaver.h"
#include <QtNetwork>
#include <QUrl>
#include <QFile>
#include <qDebug>

namespace Util {

FileSaver::FileSaver(QObject *parent)
    :QObject(parent)
{

}

bool FileSaver::saveImg(QString source, QString path)
{
    QString strFile("file:///");
    if(path.startsWith(strFile)){
        path = path.mid(strFile.length());
    }
    bool bRet = false;
    if(source.startsWith("http")){
        auto *pDown = new HttpDownloader(this);
        connect(pDown, &HttpDownloader::sigFinished, this, &FileSaver::finished);
        connect(pDown, &HttpDownloader::sigFinished, pDown, &HttpDownloader::deleteLater);
        pDown->download(source, path);
        bRet = true;
        qDebug()<<"src:"<<source<<" start download to path:"<<path;
    }else{
        if(source.startsWith("qrc")){
            source = source.mid(3);
        }
        bRet = QFile::copy(source, path);
        emit finished(bRet);
        qDebug()<<"src:"<<source<<" saved?"<<bRet<<" path:"<<path;
    }
    return bRet;
}

void FileSaver::classBegin()
{

}

void FileSaver::componentComplete()
{

}

HttpDownloader::HttpDownloader(QObject *parent)
    :QObject(parent)
{

    connect(&m_qnam, &QNetworkAccessManager::authenticationRequired,
            [this](){
        qDebug()<<"authenticationRequired";
        emit sigFinished(false);
    });
    connect(&m_qnam, &QNetworkAccessManager::sslErrors,
            [this](){
        qDebug()<<"sslErrors";
        emit sigFinished(false);
    });
}

HttpDownloader::~HttpDownloader()
{
    if(m_pFile){
        m_pFile->close();
        delete m_pFile;
        m_pFile = nullptr;
    }
}

void HttpDownloader::download(const QString &source, const QString &path)
{
    if(!m_pFile){
        m_pFile = new QFile(path);
        if (!m_pFile->open(QIODevice::WriteOnly)) {
            qDebug()<<"file open failed:"<<m_pFile->errorString()<<" path:"<<path;
            emit sigFinished(false);
            return;
        }
    }else{
        assert(0);
        qDebug()<<"m_pFile not null,wrong call";
        return;
    }
    m_reply = m_qnam.get(QNetworkRequest(QUrl(source)));
    connect(m_reply, &QIODevice::readyRead, this, &HttpDownloader::httpReadyRead);
    connect(m_reply, &QNetworkReply::finished, this, &HttpDownloader::httpFinished);
    //connect(m_reply, &QNetworkReply::downloadProgress, this, &HttpDownloader::httpProgress);
}

void HttpDownloader::httpFinished()
{
    bool bSucc = true;
    QFileInfo fi;
    if (m_pFile) {
        fi.setFile(m_pFile->fileName());
        m_pFile->close();
        delete m_pFile;
        m_pFile = nullptr;
    }
    if (m_reply->error()) {
        bSucc = false;
        QFile::remove(fi.absoluteFilePath());
    }
    const QVariant redirectionTarget = m_reply->attribute(QNetworkRequest::RedirectionTargetAttribute);
    m_reply->deleteLater();
    m_reply = nullptr;

    if (!redirectionTarget.isNull()) {//not tested
        QFile::remove(fi.absoluteFilePath());
        auto strUrl = redirectionTarget.toUrl().toString();
        qDebug()<<"redirect to:"<<strUrl;
        download(strUrl, fi.absoluteFilePath());
    }else{
        emit sigFinished(bSucc);
    }
}

void HttpDownloader::httpReadyRead()
{
    if (m_pFile)
        m_pFile->write(m_reply->readAll());
}

void HttpDownloader::httpProgress(qint64 bytesRead, qint64 totalBytes)
{

}

}
