/*
 * 使用正则解析acfun评论报文
 * 因为Qt自带html富文本显示控件对gif动图支持较差
 * 需要对gif单独用AnimatedImage显示，其他富文本可以用TextArea
 * 他们之间的拼接使用QML的流Flow
 * 方便排版起见先将图片和表情都单独显示，TextArea只有文本
 * 按格式拆分评论为一个个segment 再按顺序和各自格式显示
*/
#pragma once
#include <QObject>
#include <QList>

struct FormatText
{
    bool bold{false};
    bool underline{false};
    bool italic{false};
    bool strikethrough{false};
    int iId{ 0 };//@人的ID
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
    FormatText matchColorOnly(const QString &str);
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
