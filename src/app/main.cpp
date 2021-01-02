#include "Application.h"
#include <QSharedMemory>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    Application app(argc, argv);

    QStringList sl;
    auto appname = app.applicationName()+" by GoPlayEgg";
    QSharedMemory singleton(appname);
    if(!singleton.create(1)){
        qDebug()<<appname<<" already running";
        sl<<"app exists";
    }

    return app.exec(sl);
}
