#include "acCommentPaser.h"
#include <QFile>
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>
#include <QRegularExpression>


AcCommentPaser::AcCommentPaser(QObject *parent)
    : QObject(parent)
{

}

QString AcCommentPaser::acFormatTxt() const
{
    return m_acFormatTxt;
}

void AcCommentPaser::setAcFormatTxt(const QString &txt)
{
    m_acFormatTxt = txt;
    cvtToSegment(txt);
}

void AcCommentPaser::cvtToSegment(const QString &str)
{
    qDebug()<<"cvtToHtml:";

    //匹配带格式bius的字符
    //将匹配的和不匹配的分割开，按顺序添加到doc里面
    QString strRet = str;
    QRegularExpression reg("(\\[[bius]\\])+(?<txt>.*?)(\\[/([bius]|color)\\])+");
    QRegularExpressionMatch match= reg.match(strRet);
    int iCurStart = match.capturedStart();
    int iCurEnd = match.capturedEnd();
    while (iCurStart>=0) {
        if(iCurStart>0){
            FormatText ft;
            ft.txt = strRet.left(iCurStart);
            qDebug()<<"strText:"<<ft.txt;
            addToDoc(ft);
        }
        auto strFormated = strRet.mid(iCurStart, iCurEnd-iCurStart);
        auto strText = match.captured("txt");
        qDebug()<<"strText:"<<strText;
        auto ft = getFormatText(strFormated, strText);
        addToDoc(ft);
        strRet = strRet.mid(iCurEnd);
        match= reg.match(strRet);
        iCurStart = match.capturedStart();
        iCurEnd = match.capturedEnd();
    }
    if(!strRet.isEmpty()){
        FormatText ft;
        ft.txt=strRet;
        qDebug()<<"strText:"<<ft.txt;
        addToDoc(ft);
    }
    emitTxtComment();
}

void AcCommentPaser::addToDoc(FormatText &ft)
{
    //解析所有表情或图片
    QRegularExpression reg("\\[emot=[a-zA-Z]*,(?<emot>[0-9a-zA-Z]+)/\\]|\\[img=?(?<txt>[^\\]]*)\\](?<url>[^\\]]+)\\[/img\\]");
    QRegularExpressionMatch match= reg.match(ft.txt);
    int iCurStart = match.capturedStart();
    int iCurEnd = match.capturedEnd();
    while (iCurStart>=0) {
        if(iCurStart>0){
            FormatText ftStart = ft;
            ftStart.txt = ft.txt.left(iCurStart);
            qDebug()<<"strLeft:"<<ftStart.txt;
            addTextToDoc(ftStart);
        }
        auto emot = match.captured("emot");
        if(!emot.isEmpty()){
            qDebug()<<"emot:"<<emot;
            addEmotToDoc(emot);
        }else{
            auto url = match.captured("url");
            qDebug()<<"url:"<<url;
            addImgToDoc(url);
        }
        ft.txt = ft.txt.mid(iCurEnd);
        match= reg.match(ft.txt);
        iCurStart = match.capturedStart();
        iCurEnd = match.capturedEnd();
    }
    if(!ft.txt.isEmpty()){
        qDebug()<<"last  Text:"<<ft.txt;
        addTextToDoc(ft);
    }
}

void AcCommentPaser::addTextToDoc(FormatText &ft)
{
    m_lsTxt.push_back(ft);
}

void AcCommentPaser::addEmotToDoc(QString &emot)
{
    emitTxtComment();
    auto url = QString(":/assets/img/emot/%1.").arg(emot);
    qDebug()<<url;
    QString type = "png";
    if(!QFile::exists(url+type)){
        type="gif";
    }
    url+=type;
    url = "qrc"+url;
    emit addSegment(type=="png"?"img":type, url);
}

void AcCommentPaser::addImgToDoc(QString &url)
{
    emitTxtComment();
    QString type = "img";
    if(url.endsWith(".gif")){
        type="gif";
    }
    emit addSegment(type, url);
}

void AcCommentPaser::emitTxtComment()
{
    if(!m_lsTxt.empty()){
        emit addSegment("txt", txtListToJson());
        m_lsTxt.clear();
    }
}

QString AcCommentPaser::txtListToJson()
{
    QString ret;
    QJsonArray arr;
    for(auto &txt: m_lsTxt){
        QJsonObject objTxt;
        objTxt.insert("b", txt.bold);
        objTxt.insert("u", txt.underline);
        objTxt.insert("i", txt.italic);
        objTxt.insert("s", txt.strikethrough);
        objTxt.insert("t", txt.txt);
        objTxt.insert("c", txt.color);
        arr<<objTxt;
    }
    QJsonDocument jsonDocument(arr);
    ret = QString(jsonDocument.toJson());
    qDebug()<<ret;
    return ret;
}

FormatText AcCommentPaser::getFormatText(const QString &captured,const QString &txt)
{
    FormatText ft;
    ft.bold=captured.contains("[b]")&&captured.contains("[/b]");
    ft.italic=captured.contains("[i]")&&captured.contains("[/i]");
    ft.underline=captured.contains("[u]")&&captured.contains("[/u]");
    ft.strikethrough=captured.contains("[s]")&&captured.contains("[/s]");

    QRegularExpression reg("\\[color=(?<color>\\#[0-9a-fA-F]{6})\\](?<txt>.*)");
    QRegularExpressionMatch match= reg.match(txt);
    if(match.hasMatch()){
        ft.color = match.captured("color");
        ft.txt = match.captured("txt");
    }else{
        ft.txt = txt;
    }

    qDebug()<<ft.txt<<":"<<ft.color<<":"<<ft.bold<<ft.italic<<ft.underline<<ft.strikethrough;
    return ft;
}
