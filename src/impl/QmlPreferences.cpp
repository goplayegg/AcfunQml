#include "QmlPreferences.h"

#include <QCoreApplication>
#include <QPointer>
#include <QHash>
#include <QMetaProperty>
#include <QLoggingCategory>
#include "QmlWindow.h"

Q_LOGGING_CATEGORY(lcQmlPreferences, "app.QmlPreferences")

class QmlPreferencesPrivate
{
    Q_DECLARE_PUBLIC(QmlPreferences)
public:
    QmlPreferencesPrivate(QmlPreferences *q);
    QmlPreferencesPrivate(QmlPreferences *q, QSettings *settings);

    QSettings *instance() const;
    void init();
    void load();
    void save();
    void reset();

    QmlPreferences *q_ptr = nullptr;
    bool initialized = false;
    int timerId = 0;
    QString category;
    QString fileName;
    mutable QPointer<QSettings> settings;
    QHash<const char *, QVariant> properties;
};

QmlPreferencesPrivate::QmlPreferencesPrivate(QmlPreferences *q)
    : q_ptr(q)
{

}

QmlPreferencesPrivate::QmlPreferencesPrivate(QmlPreferences *q, QSettings *settings)
    : q_ptr(q), settings(settings)
{

}

QSettings *QmlPreferencesPrivate::instance() const
{
//    Q_Q(const QmlPreferences);
    if(!settings)
    {
        // convert q from const to non-const for call non-const load() function
        QmlPreferences *q = const_cast<QmlPreferences*>(q_func());

        settings = fileName.isEmpty() ? new QSettings(q) : new QSettings(fileName, QSettings::IniFormat, q);
        if (settings->status() != QSettings::NoError)
        {
            // initialize failed
            qWarning(lcQmlPreferences) << "Failed to initialize QSettings instance. Status code is: " << int(settings->status());

            if (settings->status() == QSettings::AccessError)
            {
                QVector<QString> missingIdentifiers;
                if (QCoreApplication::organizationName().isEmpty())
                    missingIdentifiers.append(QLatin1String("OrganizationName"));
                if (QCoreApplication::organizationDomain().isEmpty())
                    missingIdentifiers.append(QLatin1String("OrganizationDomain"));
                if (QCoreApplication::applicationName().isEmpty())
                    missingIdentifiers.append(QLatin1String("ApplicationName"));

                if (!missingIdentifiers.isEmpty())
                    qWarning(lcQmlPreferences) << "The following application identifiers have not been set: " << missingIdentifiers;
            }

            return settings;
        }

        if (!category.isEmpty())
            settings->beginGroup(category);

        if(initialized)
           q->d_func()->load();
    }

    return settings;
}

void QmlPreferencesPrivate::init()
{
    if (!initialized)
    {
        qCDebug(lcQmlPreferences) << "QQmlSettings: stored at"
                                  << instance()->fileName();
        load();
        initialized = true;
    }
}

void QmlPreferencesPrivate::load()
{
    Q_Q(QmlPreferences);
    const QMetaObject *meta = q->metaObject();
    const int offset = meta->propertyOffset();
    const int count = meta->propertyCount();

    // skip properties in the class's superclasses
    if (offset == 1)
        return;

    for (int i = offset; i < count; ++i)
    {
        QMetaProperty property = meta->property(i);
        const QVariant previousValue = property.read(q);
        const QVariant currentValue = instance()->value(property.name(), previousValue);

        if (!currentValue.isNull() && (!previousValue.isValid()
                || (currentValue.canConvert(previousValue.type()) && previousValue != currentValue)))
        {
            property.write(q, currentValue);
            qCDebug(lcQmlPreferences) << "load" << property.name() << "setting:" << currentValue << "default:" << previousValue;
        }

        if (!instance()->contains(property.name()))
            q->propertyChanged();

        if (!initialized && property.hasNotifySignal())
        {
            static const int propertyChangedIndex = meta->indexOfSlot("propertyChanged()");
            QMetaObject::connect(q, property.notifySignalIndex(), q, propertyChangedIndex);
        }
    }
}

void QmlPreferencesPrivate::save()
{
    QHash<const char *, QVariant>::const_iterator it = properties.constBegin();
    while (it != properties.constEnd())
    {
        instance()->setValue(it.key(), it.value());
        qCDebug(lcQmlPreferences) << "save" << it.key() << ":" << it.value();
        ++it;
    }
    properties.clear();
}

void QmlPreferencesPrivate::reset()
{
    if (initialized && settings && !properties.isEmpty())
        save();

    delete settings;
}

/**
 * @brief QmlPreferences::QmlPreferences
 * @param parent
 */
QmlPreferences::QmlPreferences(QObject *parent)
    : QObject(parent), d(new QmlPreferencesPrivate(this))
{

}

QmlPreferences::QmlPreferences(QSettings *settings, QObject *parent)
    : QObject(parent), d(new QmlPreferencesPrivate(this, settings))
{

}

QmlPreferences::~QmlPreferences()
{
    d->reset();
}

void QmlPreferences::setSettings(QSettings *settings)
{
//    if(!settings)
//    {
//        qWarning(lcQmlPreferences) << "Invalid setting object";
//        return;
//    }

    if(d->settings)
        delete d->settings;
    d->settings = settings;

    if(d->settings)
    {
        d->settings->setParent(this);
        if (!d->category.isEmpty())
            d->settings->beginGroup(d->category);
    }

    if(d->initialized)
       d->load();
}

QSettings *QmlPreferences::settings()
{
    return d->settings;
}

QString QmlPreferences::category() const
{
    return d->category;
}

void QmlPreferences::setCategory(const QString &category)
{
    if (d->category != category)
    {
        d->reset();
        d->category = category;

        if(d->initialized)
            d->load();
    }
}

QString QmlPreferences::fileName() const
{
    return d->fileName;
}

void QmlPreferences::setFileName(const QString &fileName)
{
    if (d->fileName != fileName)
    {
        d->reset();
        d->fileName = fileName;
        if(d->initialized)
            d->load();
    }
}

QVariant QmlPreferences::value(const QString &key, const QVariant &defaultValue) const
{
    return d->instance()->value(key, defaultValue);
}

void QmlPreferences::setValue(const QString &key, const QVariant &value)
{
    d->instance()->setValue(key, value);
    qCDebug(lcQmlPreferences) << "setValue" << key << ":" << value;
    if("translation" == key){
        auto pWnd = qobject_cast<QmlWindow*>(parent());
        if(pWnd){
            pWnd->reTrans(value.toString());
        }
    }
}

void QmlPreferences::propertyChanged()
{
    const QMetaObject *meta = this->metaObject();
    const int offset = meta->propertyOffset();
    const int count = meta->propertyCount();

    for (int i = offset; i < count; ++i)
    {
        const QMetaProperty &property = meta->property(i);
        const QVariant value = property.read(this);
        d->properties.insert(property.name(), value);
        qCDebug(lcQmlPreferences) << "cache" << property.name() << ":" << value;
    }
}

void QmlPreferences::timerEvent(QTimerEvent *event)
{
    if (event->timerId() == d->timerId)
    {
        killTimer(d->timerId);
        d->timerId = 0;

        d->save();
    }

    QObject::timerEvent(event);
}

void QmlPreferences::classBegin()
{

}

void QmlPreferences::componentComplete()
{
    d->init();
}
