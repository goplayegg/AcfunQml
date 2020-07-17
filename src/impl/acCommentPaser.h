#pragma once
#include <QObject>
#include <QList>

struct FormatText
{
    bool bold{false};
    bool underline{false};
    bool italic{false};
    bool strikethrough{false};
    QString txt;
    QString color;
};

class AcCommentPaser : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString acFormatTxt READ acFormatTxt WRITE setAcFormatTxt)
public:
    explicit AcCommentPaser(QObject *parent = nullptr);

    QString acFormatTxt() const;
    void setAcFormatTxt(const QString &txt);
//public Q_SLOTS:
Q_SIGNALS:
    void error(const QString &message);
    void addSegment(const QString& type, const QString& source);
private:
    void cvtToSegment(const QString &str);
    void addToDoc(FormatText& ft);
    void addTextToDoc(FormatText& ft);
    void addEmotToDoc(QString& emot);
    void addImgToDoc(QString& url);
    void emitTxtComment();
    QString txtListToJson();

    FormatText getFormatText(const QString&captured,const QString &txt);

    QString m_acFormatTxt;
    QList<FormatText> m_lsTxt;
};
