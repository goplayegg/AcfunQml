#include "Application.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    Application app(argc, argv);
	
	//TODO: initialize configure or something

    return app.exec();
}
