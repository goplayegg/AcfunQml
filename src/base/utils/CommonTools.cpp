﻿#include "CommonTools.h"
#include <QDebug>
#include <QRegularExpression>
#include <vector>
#include <tuple>
#include <QTextDocument>
#include <QTextCursor>
#include "ScreenSaver.h"

namespace Util {

CommonTools::CommonTools(QObject *parent)
    :QObject(parent)
{
    osTypeChanged(osType());
}

QString CommonTools::cvtToHtml(const QString &source)
{
    //匹配[at uid=]@用户ID[/at]  [img=图片]https://imgs.png[/img]
    //将匹配的和不匹配的分割开，按顺序添加到html
    std::vector<std::tuple<QString, int, QString>> vsInfo;//字，uid，图片url
    QString strRet = source;
    QRegularExpression reg("\\[at\\suid=(?<id>[0-9]+)\\](?<name>.*?)\\[/at\\]|\\[img=(?<pic>.*?)\\](?<picUrl>.*?)\\[/img\\]");
    QRegularExpressionMatch match= reg.match(strRet);
    int iCurStart = match.capturedStart();
    int iCurEnd = match.capturedEnd();
    while (iCurStart>=0) {
        if(iCurStart>0){//不匹配的字符直接丢进去
            vsInfo.emplace_back(std::make_tuple(strRet.left(iCurStart), 0, ""));
        }
        auto strId = match.captured("id");
        if(!strId.isEmpty()){//匹配到了@用户
            auto strName = match.captured("name");
            qDebug()<<"at:"<<strId<<" name:"<<strName;
            vsInfo.emplace_back(std::make_tuple(strName, strId.toInt(), ""));
        }else{
            auto strPic = match.captured("pic");
            auto strPicUrl = match.captured("picUrl");
            vsInfo.emplace_back(std::make_tuple(strPic, 0, strPicUrl));
        }
        //尝试匹配下一个
        strRet = strRet.mid(iCurEnd);
        match= reg.match(strRet);
        iCurStart = match.capturedStart();
        iCurEnd = match.capturedEnd();
    }
    if(!strRet.isEmpty()){
        vsInfo.emplace_back(std::make_tuple(strRet, 0, ""));
    }
    if(m_pDoc == nullptr){
        m_pDoc = new QTextDocument(this);
        m_pDoc->setDefaultFont(QFont(mainFontFamily()));
    }
    m_pDoc->clear();
    QTextCursor cursor = QTextCursor(m_pDoc);
    for(auto &info: vsInfo){
        QTextCharFormat format;
        format.setFontPointSize(9);
        format.setFontWeight(QFont::Bold);
        if(0 != std::get<1>(info)){
            QColor clr(0x0000ff);
            format.setForeground(QBrush(clr));
            format.setAnchor(true);
            format.setAnchorHref(QString("%1").arg(std::get<1>(info)));
        }else if(!std::get<2>(info).isEmpty()){
            QColor clr(0x0000ff);
            format.setForeground(QBrush(clr));
            format.setAnchor(true);
            format.setAnchorHref(std::get<2>(info));
        }else{
            std::get<0>(info).replace("&quot;","\"");
            std::get<0>(info).replace("&#39;","\'");
            std::get<0>(info).replace("&lt;","<");
            std::get<0>(info).replace("&gt;",">");
            std::get<0>(info).replace("&amp;","&");
        }
        cursor.insertText(std::get<0>(info), format);
    }
    return m_pDoc->toHtml();
}

QString CommonTools::cvtArticleTitle(const QString &title, const QString &body)
{
    QString str;
    if(title.isEmpty()){
        return body;
    }
    str = QString("<a href=\"article\">%1</a>").arg(title) + "<br/>" + body;
    return str;
}

QString CommonTools::token(const QString &unixTime)
{
    auto strTime = unixTime;//+"123";
    qDebug()<<"test strTime:"<<strTime;
    QByteArray ba;
    ba.append((char)8);
    ba.append((char)1);
    ba.append((char)18);
    ba.append((char)13);
    ba.append(strTime);
    qDebug()<<"test QByteArray:"<<ba.toStdString().c_str();
    auto base64 = ba.toBase64();
    return base64;
}

QString CommonTools::mainFontFamily()
{
    return QString("mac"==osType()?"Hiragino Sans GB":"Microsoft YaHei");
}

QString CommonTools::articleFontFamily()
{
    return mainFontFamily()+",Helvetica Neue For Number,Segoe UI,Hiragino Sans GB,sans-serif";
}

void CommonTools::disableScreenSaver(bool bDis)
{
    if(bDis){
        ScreenSaver::disable();
    }else{
        ScreenSaver::restore();
    }
}

void CommonTools::setMainWnd(QVariant wnd)
{
    qDebug()<<"setMainWnd QVariant:"<<wnd;
    auto pObj = wnd.value<QObject*>();
    ScreenSaver::m_pWnd = (QWindow*)pObj;
    qDebug()<<"setMainWnd QWindow*:"<<ScreenSaver::m_pWnd;
}

QString CommonTools::osType() const
{
    QString os;
#ifdef OS_WIN
    os = "win";
#endif
#ifdef OS_MAC
    os = "mac";
#endif

    return os;
}

void CommonTools::classBegin()
{

}

void CommonTools::componentComplete()
{

}

}
