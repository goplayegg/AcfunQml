#include "FileSaver.h"
#include <QImage>
#include <QFile>
#include <qDebug>

namespace Util {

FileSaver::FileSaver(QObject *parent)
    :QObject(parent)
{

}

bool FileSaver::saveImg(QString source, QString path)
{
    bool bRet = false;
    QImage img;
    if(source.startsWith("http")){
        img = QImage(source);
        bRet = false;
        qDebug()<<"src:"<<source<<" null img?"<<img.isNull()<<" saved?"<<bRet<<" path:"<<path;
    }else{
        QString strFile("file:///");
        if(path.startsWith(strFile)){
            path = path.mid(strFile.length());
        }
        if(source.startsWith("qrc")){
            source = source.mid(3);
        }
        bRet = QFile::copy(source, path);
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

}
