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

int AcCommentPaser::replyToId() const
{
    return m_replyToId;
}

void AcCommentPaser::setrReplyToId(int id)
{
    m_replyToId = id;
}

QString AcCommentPaser::replyToName() const
{
    return m_replyToName;
}

void AcCommentPaser::setReplyToName(const QString &name)
{
    m_replyToName = name;
}

QString AcCommentPaser::acFormatTxt() const
{
    return m_acFormatTxt;
}

void AcCommentPaser::setAcFormatTxt(const QString &txt)
{
    m_acFormatTxt = txt;
    parseReply();
    cvtToSegment(txt);
}

void AcCommentPaser::parseReply()
{
    if(0 == m_replyToId){
        return;
    }
    FormatText ft;
    ft.txt = tr("Reply to")+" ";
    addTextToDoc(ft);
    ft.iId = m_replyToId;
    ft.txt = "@"+m_replyToName;
    addTextToDoc(ft);
    ft.iId = 0;
    ft.txt = " : ";
    addTextToDoc(ft);
}

void AcCommentPaser::cvtToSegment(const QString &str)
{
    qDebug()<<"cvtToSegment:";

    //匹配带格式bius的字符 或者[at uid=]@用户ID[/at]
    //将匹配的和不匹配的分割开，按顺序添加到评论UI里面
    QString strRet = str;
    QRegularExpression reg("(\\[[bius]\\])+(?<txt>.*?)(\\[/([bius]|color)\\])+|\\[at\\suid=(?<id>[0-9]+)\\](?<name>.*?)\\[/at\\]");
    QRegularExpressionMatch match= reg.match(strRet);
    int iCurStart = match.capturedStart();
    int iCurEnd = match.capturedEnd();
    while (iCurStart>=0) {
        if(iCurStart>0){//不匹配任何特殊格式的字符直接丢进去
            FormatText ft = matchColorOnly(strRet.left(iCurStart));
            addToDoc(ft);
        }
        auto strFormated = strRet.mid(iCurStart, iCurEnd-iCurStart);
        FormatText ft;
        auto strId = match.captured("id");
        if(!strId.isEmpty()){//匹配到了@用户
            auto strName = match.captured("name");
            qDebug()<<"at:"<<strId<<" name:"<<strName;
            ft.iId = strId.toUInt();
            ft.txt = strName;
        }else{//带格式bius的字符
            auto strText = match.captured("txt");
            qDebug()<<"strText:"<<strText;
            ft = getFormatText(strFormated, strText);
        }
        addToDoc(ft);
        //尝试匹配下一个
        strRet = strRet.mid(iCurEnd);
        match= reg.match(strRet);
        iCurStart = match.capturedStart();
        iCurEnd = match.capturedEnd();
    }
    if(!strRet.isEmpty()){
        FormatText ft = matchColorOnly(strRet);
        addToDoc(ft);
    }
    emitTxtComment();
}

FormatText AcCommentPaser::matchColorOnly(const QString &str)
{
    FormatText ft;
    QRegularExpression reg("\\[color=(?<color>\\#[0-9a-fA-F]{6,8})\\](?<txt>.*?)\\[/color\\]");
    QRegularExpressionMatch match= reg.match(str);
    if(match.hasMatch()){
        ft.color = match.captured("color");
        ft.txt = match.captured("txt");
    }else{
        ft.txt = str;
    }
    qDebug()<<"strText:"<<ft.txt<<" color:"<<ft.color;
    return  ft;
}

void AcCommentPaser::addToDoc(FormatText &ft)
{
    //解析所有表情或图片
    QRegularExpression reg("\\[emot=[0-9a-zA-Z]*,(?<emot>[0-9a-zA-Z]+)/\\]|\\[img=?(?<txt>[^\\]]*)\\](?<url>[^\\]]+)\\[/img\\]");
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
    }else{
        auto idx = url.indexOf(".gif?");
        if(-1!=idx){
            url = url.left(idx+4);
            qDebug()<<"fixed gif url:"<<url;
            type="gif";
        }
    }
    emit addSegment(type, url);
}

//遇到图片或表情都先将之前的文本显示掉
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
        objTxt.insert("id", txt.iId);
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

    QRegularExpression reg("\\[color=(?<color>\\#[0-9a-fA-F]{6,8})\\](?<txt>.*)");
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
