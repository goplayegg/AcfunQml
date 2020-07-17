#pragma once
#include "acCommentPaser.h"
#include <QObject>
#include <QTextCursor>

QT_BEGIN_NAMESPACE
class QTextDocument;
class QQuickTextDocument;
QT_END_NAMESPACE

class TextDocHandler : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QQuickTextDocument *document READ document WRITE setDocument)

    Q_PROPERTY(QString txtJson READ txtJson WRITE setTxtJson)
public:
    explicit TextDocHandler(QObject *parent = nullptr);

    QQuickTextDocument *document() const;
    void setDocument(QQuickTextDocument *document);

    QString txtJson() const;
    void setTxtJson(const QString &txt);
//public Q_SLOTS:
private:
    void addTextToDoc(FormatText& ft, QTextCursor& cursor);
    QTextDocument *textDocument() const;

    QQuickTextDocument *m_document{nullptr};
    QString m_txtJson;
};
