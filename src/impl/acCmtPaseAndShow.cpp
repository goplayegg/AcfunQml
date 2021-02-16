#include "acCmtPaseAndShow.h"
#include <QFile>
#include <QDebug>
#include <QQuickTextDocument>
#include <QTextCursor>
#include <QRegularExpression>


AcCmtPaseAndShow::AcCmtPaseAndShow(QObject *parent)
    : QObject(parent)
{

}

int AcCmtPaseAndShow::replyToId() const
{
    return m_replyToId;
}

void AcCmtPaseAndShow::setrReplyToId(int id)
{
    m_replyToId = id;
}

QString AcCmtPaseAndShow::replyToName() const
{
    return m_replyToName;
}

void AcCmtPaseAndShow::setReplyToName(const QString &name)
{
    m_replyToName = name;
}

QString AcCmtPaseAndShow::acFormatTxt() const
{
    return m_acFormatTxt;
}

void AcCmtPaseAndShow::setAcFormatTxt(const QString &txt)
{
    m_acFormatTxt = txt;
}

QQuickTextDocument *AcCmtPaseAndShow::document() const
{
    return m_document;
}

void AcCmtPaseAndShow::setDocument(QQuickTextDocument *document)
{
    m_document = document;
}

void AcCmtPaseAndShow::parseAndShow()
{
    parseReply();
    cvtToSegment(m_acFormatTxt);
    showTxtComment();
}

void AcCmtPaseAndShow::parseReply()
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

void AcCmtPaseAndShow::cvtToSegment(const QString &str)
{
    qDebug()<<"cvtToSegment:";

    //匹配带格式bius的字符 或者[at uid=]@用户ID[/at] 或者[ac=17908957]ac17908957[/ac]
    //将匹配的和不匹配的分割开，按顺序添加到评论UI里面
    QString strRet = str;
    QRegularExpression reg("(\\[[bius]\\])+(?<txt>.*?)(\\[/([bius]|color)\\])+|\\[at\\suid=(?<uid>[0-9]+)\\](?<name>.*?)\\[/at\\]"
                           "|\\[ac=(?<acid>[0-9]+)\\](?<aclink>.*?)\\[/ac\\]");
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
        auto strAcId = match.captured("acid");
        auto strUid = match.captured("uid");
        if(!strAcId.isEmpty()){//匹配到了稿件链接
            auto strName = match.captured("aclink");
            qDebug()<<"ac link:"<<strAcId<<" name:"<<strName;
            ft.acID = strAcId;
            ft.txt = strName;
        }else if(!strUid.isEmpty()){//匹配到了@用户
            auto strName = match.captured("name");
            qDebug()<<"at:"<<strUid<<" name:"<<strName;
            ft.iId = strUid.toUInt();
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
}

FormatText AcCmtPaseAndShow::matchColorOnly(const QString &str)
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

void AcCmtPaseAndShow::addToDoc(FormatText &ft)
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

void AcCmtPaseAndShow::addTextToDoc(FormatText &ft)
{
    m_lsTxt.push_back(ft);
}

void AcCmtPaseAndShow::addEmotToDoc(QString &emot)
{
    auto url = QString(":/assets/img/emot/%1.").arg(emot);
    qDebug()<<url;
    QString type = "png";
    if(!QFile::exists(url+type)){
        type="gif";
    }
    url+=type;
    url = "qrc"+url;
    dealImage(type, url);
}

void AcCmtPaseAndShow::addImgToDoc(QString &url)
{
    auto idx = url.indexOf("?");
    if(-1!=idx){
        url = url.left(idx);
    }
    QString type = "jpg";
    idx = url.lastIndexOf(".");
    if(-1!=idx){
        type = url.mid(idx+1);
    }
    qDebug()<<"fixed image url:"<<url<<" ,type:"<<type;
    dealImage(type, url);
}

void AcCmtPaseAndShow::dealImage(const QString &type, const QString &url)
{
    FormatText ft;
    ft.imgUrl = url;
    ft.type = type;
    m_lsTxt.push_back(ft);
}

void AcCmtPaseAndShow::showTxtComment()
{
    auto doc = textDocument();
    if(!doc)
        return;

    QTextCursor cursor = QTextCursor(doc);
    cursor.movePosition(QTextCursor::End);
    for(auto& ft: m_lsTxt){
        if(!ft.imgUrl.isEmpty()){
            addImgToDoc(ft, cursor);
            continue;
        }
        addTextToDoc(ft, cursor);
    }
    m_lsTxt.clear();
}

FormatText AcCmtPaseAndShow::getFormatText(const QString &captured,const QString &txt)
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

void AcCmtPaseAndShow::addTextToDoc(FormatText &ft, QTextCursor &cursor)
{
    QTextCharFormat format;
    format.setFontUnderline(ft.underline);
    format.setFontItalic(ft.italic);
    format.setFontStretch(ft.strikethrough);
    format.setFontWeight(ft.bold ? QFont::Bold : QFont::Normal);
    if(0!=ft.iId){
        QColor clr(0x0000ff);
        format.setForeground(QBrush(clr));
        format.setAnchor(true);
        format.setAnchorHref(QString("uid/%1").arg(ft.iId));
    }
    if(!ft.acID.isEmpty()){
        QColor clr(0x0000ff);
        format.setForeground(QBrush(clr));
        format.setAnchor(true);
        format.setAnchorHref(QString("ac/")+ft.acID);
    }
    if(!ft.color.isEmpty()){
        QColor clr(ft.color);
        format.setForeground(QBrush(clr));
    }
    ft.txt.replace("&quot;","\"");
    ft.txt.replace("&#39;","\'");
    ft.txt.replace("&lt;","<");
    ft.txt.replace("&gt;",">");
    ft.txt.replace("&amp;","&");
    ft.txt.replace("\\r\\n","\r\n");
    ft.txt.replace("<br/>","\r\n");
    cursor.insertText(ft.txt,format);
}

void AcCmtPaseAndShow::addImgToDoc(FormatText &ft, QTextCursor &cursor)
{
    if(ft.imgUrl.startsWith("http")){
        emit addImg(ft.imgUrl, ft.type);//网图在Repeater-TextArea 结构里第一次会显示不出，用单独的Image规避
        return;
    }
    QString html;
    if(ft.type == "gif"){
        html = "<a href=\""+ft.imgUrl+"\"><img src=\""+ft.imgUrl+"\" alt=\""+ft.imgUrl+"\"></a>";
    }else{
        html = "<img src=\""+ft.imgUrl+"\" alt=\""+ft.imgUrl+"\">";//height=\"90\" width=\"90\"
    }
    cursor.insertHtml(html);
    //cursor.insertImage(QImage("J:/avicii.jpg"), "avicii"); qml会从qrc里找这个文件 然而找不到
}

QTextDocument *AcCmtPaseAndShow::textDocument() const
{
    if (!m_document)
        return nullptr;

    return m_document->textDocument();
}
