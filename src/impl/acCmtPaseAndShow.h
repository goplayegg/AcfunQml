/*
 * this is play B
 * 使用正则解析acfun评论报文
 * 按格式拆分评论中的文本/表情/图片 为一个个segment
*/
#pragma once
#include <QObject>
#include <QList>
#include <QTextCursor>
#include "acCommentPaser.h"

class QTextDocument;
class QQuickTextDocument;
class AcCmtPaseAndShow : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int replyToId READ replyToId WRITE setrReplyToId)
    Q_PROPERTY(QString replyToName READ replyToName WRITE setReplyToName)
    Q_PROPERTY(QString acFormatTxt READ acFormatTxt WRITE setAcFormatTxt)
    Q_PROPERTY(QQuickTextDocument *document READ document WRITE setDocument)
public:
    explicit AcCmtPaseAndShow(QObject *parent = nullptr);

    int replyToId() const;
    void setrReplyToId(int id);
    QString replyToName() const;
    void setReplyToName(const QString &name);
    QString acFormatTxt() const;
    void setAcFormatTxt(const QString &txt);
    QQuickTextDocument *document() const;
    void setDocument(QQuickTextDocument *document);
    Q_INVOKABLE void parseAndShow();
Q_SIGNALS:
    void error(const QString &message);
    void addImg(const QString &url);
private:
    void parseReply();
    void cvtToSegment(const QString &str);
    FormatText matchColorOnly(const QString &str);
    void addToDoc(FormatText& ft);
    void addTextToDoc(FormatText& ft);
    void addEmotToDoc(QString& emot);
    void addImgToDoc(QString& url);
    void showTxtComment();
    void dealImage(const QString& type, const QString& source);

    FormatText getFormatText(const QString&captured,const QString &txt);

    int m_replyToId{ 0 };
    QString m_replyToName;
    QString m_acFormatTxt;
    QList<FormatText> m_lsTxt;

    //html doc部分
    void addTextToDoc(FormatText& ft, QTextCursor& cursor);
    void addImgToDoc(FormatText& ft, QTextCursor& cursor);
    QTextDocument *textDocument() const;
    QQuickTextDocument *m_document{nullptr};
};
