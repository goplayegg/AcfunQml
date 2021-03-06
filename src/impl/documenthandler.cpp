﻿/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "documenthandler.h"

#include <QFile>
#include <QFileInfo>
#include <QFileSelector>
#include <QQmlFile>
#include <QQmlFileSelector>
#include <QQuickTextDocument>
#include <QTextCharFormat>
#include <QTextCodec>
#include <QTextDocument>
#include <QDebug>
#include <QTextList>
#include <QTextBlock>

DocumentHandler::DocumentHandler(QObject *parent)
    : QObject(parent)
{
}

QQuickTextDocument *DocumentHandler::document() const
{
    return m_document;
}

void DocumentHandler::setDocument(QQuickTextDocument *document)
{
    if (document == m_document)
        return;

    if (m_document)
        m_document->textDocument()->disconnect(this);
    m_document = document;
    if (m_document)
        connect(m_document->textDocument(), &QTextDocument::modificationChanged, this, &DocumentHandler::modifiedChanged);
    emit documentChanged();
}

int DocumentHandler::cursorPosition() const
{
    return m_cursorPosition;
}

void DocumentHandler::setCursorPosition(int position)
{
    if (position == m_cursorPosition)
        return;

    m_cursorPosition = position;
    reset();
    emit cursorPositionChanged();
}

int DocumentHandler::selectionStart() const
{
    return m_selectionStart;
}

void DocumentHandler::setSelectionStart(int position)
{
    if (position == m_selectionStart)
        return;

    m_selectionStart = position;
    emit selectionStartChanged();
}

int DocumentHandler::selectionEnd() const
{
    return m_selectionEnd;
}

void DocumentHandler::setSelectionEnd(int position)
{
    if (position == m_selectionEnd)
        return;

    m_selectionEnd = position;
    emit selectionEndChanged();
}

QString DocumentHandler::fontFamily() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return QString();
    QTextCharFormat format = cursor.charFormat();
    return format.font().family();
}

void DocumentHandler::setFontFamily(const QString &family)
{
    QTextCharFormat format;
    format.setFontFamily(family);
    mergeFormatOnWordOrSelection(format);
    emit fontFamilyChanged();
}

QColor DocumentHandler::textColor() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return QColor(Qt::black);
    QTextCharFormat format = cursor.charFormat();
    return format.foreground().color();
}

void DocumentHandler::setTextColor(const QColor &color)
{
    QTextCharFormat format;
    format.setForeground(QBrush(color));
    mergeFormatOnWordOrSelection(format);
    emit textColorChanged();
}

Qt::Alignment DocumentHandler::alignment() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return Qt::AlignLeft;
    return textCursor().blockFormat().alignment();
}

void DocumentHandler::setAlignment(Qt::Alignment alignment)
{
    QTextBlockFormat format;
    format.setAlignment(alignment);
    QTextCursor cursor = textCursor();
    cursor.mergeBlockFormat(format);
    emit alignmentChanged();
}

bool DocumentHandler::bold() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontWeight() == QFont::Bold;
}

void DocumentHandler::setBold(bool bold)
{
    QTextCharFormat format;
    format.setFontWeight(bold ? QFont::Bold : QFont::Normal);
    mergeFormatOnWordOrSelection(format);
    emit boldChanged();
}

bool DocumentHandler::italic() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontItalic();
}

void DocumentHandler::setItalic(bool italic)
{
    QTextCharFormat format;
    format.setFontItalic(italic);
    mergeFormatOnWordOrSelection(format);
    emit italicChanged();
}

bool DocumentHandler::underline() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontUnderline();
}

void DocumentHandler::setUnderline(bool underline)
{
    QTextCharFormat format;
    format.setFontUnderline(underline);
    mergeFormatOnWordOrSelection(format);
    emit underlineChanged();
}

bool DocumentHandler::strike() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return false;
    return textCursor().charFormat().fontStrikeOut();
}

void DocumentHandler::setStrike(bool strike)
{
    QTextCharFormat format;
    format.setFontStrikeOut(strike);
    mergeFormatOnWordOrSelection(format);
    emit strikeChanged();
}

int DocumentHandler::fontSize() const
{
    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return 0;
    QTextCharFormat format = cursor.charFormat();
    return format.font().pointSize();
}

void DocumentHandler::setFontSize(int size)
{
    if (size <= 0)
        return;

    QTextCursor cursor = textCursor();
    if (cursor.isNull())
        return;

    if (!cursor.hasSelection())
        cursor.select(QTextCursor::WordUnderCursor);

    if (cursor.charFormat().property(QTextFormat::FontPointSize).toInt() == size)
        return;

    QTextCharFormat format;
    format.setFontPointSize(size);
    mergeFormatOnWordOrSelection(format);
    emit fontSizeChanged();
}

QString DocumentHandler::fileName() const
{
    const QString filePath = QQmlFile::urlToLocalFileOrQrc(m_fileUrl);
    const QString fileName = QFileInfo(filePath).fileName();
    if (fileName.isEmpty())
        return QStringLiteral("untitled.txt");
    return fileName;
}

QString DocumentHandler::fileType() const
{
    return QFileInfo(fileName()).suffix();
}

QUrl DocumentHandler::fileUrl() const
{
    return m_fileUrl;
}

bool DocumentHandler::modified() const
{
    return m_document && m_document->textDocument()->isModified();
}

void DocumentHandler::setModified(bool m)
{
    if (m_document)
        m_document->textDocument()->setModified(m);
}

QString DocumentHandler::acFormatTxt() const
{
    return m_acFormatTxt;
}

void DocumentHandler::addEmot(const QString &emotId)
{
    auto url = QString(":/assets/img/emot/%1.").arg(emotId);
    QString type = "png";
    if(!QFile::exists(url+type)){
        type="gif";
    }
    url+=type;
    url = "qrc"+url;
    qDebug()<<"addEmot url:"<<url;

    auto html = "<img src=\""+url+"\" alt=\""+url+"\" height=\"50\"/>";
    auto cursor = textCursor();
    auto fmt = cursor.charFormat();
    cursor.insertHtml(html);
    restoreFormat(fmt);//恢复插入表情前的字体格式
}

QString DocumentHandler::getAcCmt()
{
    QString strCmt;
    QTextDocument *doc = textDocument();
    if (!doc){
        return strCmt;
    }
    QTextBlock block = doc->firstBlock();
    auto allFormats = doc->allFormats();
    int iBlockIdx=0;
    while(block.isValid()) {
        if(0 != iBlockIdx)
            makeAcNewBlock(strCmt);
        qDebug()<<"Block start, index:"<<iBlockIdx++;
        QTextBlockFormat blockFmt = block.blockFormat();
        QTextList* textList = block.textList();
        if(textList)
            QTextListFormat listFmt = allFormats[textList->formatIndex()].toListFormat();

        int iFragIdx=0;
        for(QTextBlock::iterator it = block.begin(); !it.atEnd(); it++)
        {
            QTextFragment fragment = it.fragment();
            if(!fragment.isValid()){
                continue;
            }
            QTextCharFormat charFmt = fragment.charFormat();
            auto imgFmt = charFmt.toImageFormat();
            if (imgFmt.isValid()) {
                makeAcEmot(strCmt, imgFmt.name());
                qDebug()<<"Frag index:"<<iFragIdx++<<"img:"<<imgFmt.name();
            } else {
                FormatText ft;
                ft.bold = charFmt.fontWeight() == QFont::Bold;
                ft.italic = charFmt.fontItalic();
                ft.underline = charFmt.fontUnderline();
                ft.strikethrough = charFmt.fontStrikeOut();
                auto c = charFmt.foreground().color();
                ft.color = c.name();
                ft.txt = fragment.text();
                makeAcTxt(strCmt, ft);
                qDebug()<<"Frag index:"<<iFragIdx++<<" "<<ft.txt<<":"<<ft.color<<":"<<ft.bold<<ft.italic<<ft.underline<<ft.strikethrough;
            }
        }
        block = block.next();
    }
    //qDebug()<<"html: "<<doc->toHtml();
    qDebug()<<"strCmt:"<<strCmt;
    return strCmt;
}

void DocumentHandler::makeAcEmot(QString &acCmt, const QString &emot)
{
    //qrc:/assets/img/emot/5x6jjq8kkiv6ity.png
    //[emot=zt,5x6jjq8kkiv6ity/]
    auto idx = emot.lastIndexOf("/emot/");
    if(-1 != idx){
        auto emId = emot.mid(idx+QString("/emot/").length());
        emId = emId.left(emId.length()-QString(".png").length());
        acCmt+=QString("[emot=zt,%1/]").arg(emId);
    } else {
        qDebug()<<"makeAcEmot error, emot:"<<emot;
    }
}

void DocumentHandler::makeAcTxt(QString &acCmt, const FormatText &ft)
{
    //[b][i][u][s][color=#ff0000]颜色+加粗+斜体+下划线+删除线[/u][/s][/color][/i][/b]
    if(ft.bold){
        acCmt+="[b]";
    }
    if(ft.italic){
        acCmt+="[i]";
    }
    if(ft.underline){
        acCmt+="[u]";
    }
    if(ft.strikethrough){
        acCmt+="[s]";
    }
    if(!ft.color.isEmpty() && "#000000"!=ft.color){
        acCmt+="[color="+ft.color+"]";
    }
    acCmt+=ft.txt;
    if(ft.underline){
        acCmt+="[/u]";
    }
    if(ft.strikethrough){
        acCmt+="[/s]";
    }
    if(!ft.color.isEmpty() && "#000000"!=ft.color){
        acCmt+="[/color]";
    }
    if(ft.italic){
        acCmt+="[/i]";
    }
    if(ft.bold){
        acCmt+="[/b]";
    }
}

void DocumentHandler::makeAcNewBlock(QString &acCmt)
{
    acCmt+="\r\n";//"<br/>";
}

void DocumentHandler::load(const QUrl &fileUrl)
{
    if (fileUrl == m_fileUrl)
        return;

    QQmlEngine *engine = qmlEngine(this);
    if (!engine) {
        qWarning() << "load() called before DocumentHandler has QQmlEngine";
        return;
    }

    const QUrl path = QQmlFileSelector::get(engine)->selector()->select(fileUrl);
    const QString fileName = QQmlFile::urlToLocalFileOrQrc(path);
    qDebug()<<"fileurl:"<<fileUrl<<"\r\npath:"<<path<<"\r\nfilename"<<fileName;
    if (QFile::exists(fileName)) {
        QFile file(fileName);
        if (file.open(QFile::ReadOnly)) {
            if (QTextDocument *doc = textDocument())
                doc->setModified(false);

            QByteArray data = file.readAll();
            QTextCodec *codec = QTextCodec::codecForName("UTF-8");
            auto text = codec->toUnicode(data);
            //emit loaded(text);
            reset();
        }
    }

    m_fileUrl = fileUrl;
    emit fileUrlChanged();
}

void DocumentHandler::saveAs(const QUrl &fileUrl)
{
    QTextDocument *doc = textDocument();
    if (!doc)
        return;

    const QString filePath = fileUrl.toLocalFile();
    const bool isHtml = QFileInfo(filePath).suffix().contains(QLatin1String("htm"));
    QFile file(filePath);
    if (!file.open(QFile::WriteOnly | QFile::Truncate | (isHtml ? QFile::NotOpen : QFile::Text))) {
        emit error(tr("Cannot save: ") + file.errorString());
        return;
    }
    file.write((isHtml ? doc->toHtml() : doc->toPlainText()).toUtf8());
    file.close();

    if (fileUrl == m_fileUrl)
        return;

    m_fileUrl = fileUrl;
    emit fileUrlChanged();
}

void DocumentHandler::reset()
{
    emit fontFamilyChanged();
    emit alignmentChanged();
    emit boldChanged();
    emit italicChanged();
    emit underlineChanged();
    emit strikeChanged();
    emit fontSizeChanged();
    emit textColorChanged();
}

QTextCursor DocumentHandler::textCursor() const
{
    QTextDocument *doc = textDocument();
    if (!doc)
        return QTextCursor();

    QTextCursor cursor = QTextCursor(doc);
    if (m_selectionStart != m_selectionEnd) {
        cursor.setPosition(m_selectionStart);
        cursor.setPosition(m_selectionEnd, QTextCursor::KeepAnchor);
    } else {
        cursor.setPosition(m_cursorPosition);
    }
    return cursor;
}

QTextDocument *DocumentHandler::textDocument() const
{
    if (!m_document)
        return nullptr;

    return m_document->textDocument();
}

void DocumentHandler::mergeFormatOnWordOrSelection(const QTextCharFormat &format)
{
    QTextCursor cursor = textCursor();
    if (!cursor.hasSelection())
        cursor.select(QTextCursor::WordUnderCursor);
    cursor.mergeCharFormat(format);
}

void DocumentHandler::restoreFormat(const QTextCharFormat& fmt)
{
    QTextCharFormat format;
    format.setFontWeight(fmt.fontWeight());
    format.setFontItalic(fmt.fontItalic());
    format.setFontUnderline(fmt.fontUnderline());
    format.setFontStrikeOut(fmt.fontStrikeOut());
    format.setForeground(fmt.foreground());
    mergeFormatOnWordOrSelection(format);
    emit boldChanged();
    emit italicChanged();
    emit underlineChanged();
    emit strikeChanged();
    emit textColorChanged();
}
