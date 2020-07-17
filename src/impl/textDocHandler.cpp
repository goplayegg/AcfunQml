#include "textDocHandler.h"
#include <QDebug>
#include <QQuickTextDocument>
#include <QTextCursor>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

TextDocHandler::TextDocHandler(QObject *parent)
    : QObject(parent)
{

}

QQuickTextDocument *TextDocHandler::document() const
{
    return m_document;
}

void TextDocHandler::setDocument(QQuickTextDocument *document)
{
    m_document = document;
}

QString TextDocHandler::txtJson() const
{
    return m_txtJson;
}

void TextDocHandler::setTxtJson(const QString &txt)
{
    qDebug()<<"setTxtJson "<<txt;
    m_txtJson = txt;
    auto doc = textDocument();
    if(!doc)
        return;
    qDebug()<<"QJsonDocument parse begin";
    QJsonArray jsArr;
    QJsonDocument jsonDocument = QJsonDocument::fromJson(txt.toStdString().c_str());
    if(!jsonDocument.isNull() ){
        jsArr = jsonDocument.array();
    }

    QTextCursor cursor = QTextCursor(doc);
    cursor.movePosition(QTextCursor::End);
    FormatText ft;
    for(auto it = jsArr.begin(); it!=jsArr.end(); ++it){
        QJsonValue jsVar = *it;
        ft.bold = jsVar["b"].toBool();
        ft.underline = jsVar["u"].toBool();
        ft.italic = jsVar["i"].toBool();
        ft.strikethrough = jsVar["s"].toBool();
        ft.txt = jsVar["t"].toString();
        ft.color = jsVar["c"].toString();
        addTextToDoc(ft, cursor);
    }
}

void TextDocHandler::addTextToDoc(FormatText &ft, QTextCursor& cursor)
{
    QTextCharFormat format;
    format.setFontUnderline(ft.underline);
    format.setFontItalic(ft.italic);
    format.setFontStretch(ft.strikethrough);
    format.setFontWeight(ft.bold ? QFont::Bold : QFont::Normal);
    if(!ft.color.isEmpty()){
        QColor clr(ft.color);
        format.setForeground(QBrush(clr));
    }
    ft.txt.replace("\\r\\n","\r\n");
    ft.txt.replace("<br/>","\r\n");
    cursor.insertText(ft.txt,format);
}

QTextDocument *TextDocHandler::textDocument() const
{
    if (!m_document)
        return nullptr;

    return m_document->textDocument();
}
