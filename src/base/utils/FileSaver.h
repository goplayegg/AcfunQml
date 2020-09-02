#pragma once
#include <QObject>
#include <QQmlParserStatus>

namespace Util {

class FileSaver: public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)
public:
    explicit FileSaver(QObject *parent = 0);
    Q_INVOKABLE bool saveImg(QString source, QString path);

    // QQmlParserStatus interface
public:
    void classBegin() override;
    void componentComplete() override;
};
}
