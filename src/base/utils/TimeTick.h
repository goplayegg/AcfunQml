#ifndef TIMETICK_H
#define TIMETICK_H

#include <QObject>

static const qint64 TICK_INVALID = qint64(0);
static const qint64 CLOCK_FREQ = qint64(1000);

#define SEC_FROM_TICK(tick) ((tick) / CLOCK_FREQ)

/**
 * @brief The TimeTick class
 * NOTE: qRegisterMetaType<TimeTick>() for QML
 */
class TimeTick
{
    // Q_GADGET is a lighter version of the Q_OBJECT macro for classes that do not inherit from QObject
    // it can have Q_ENUM, Q_PROPERTY and Q_INVOKABLE
    // but it cannot have signals or slots
    Q_GADGET
public:
    TimeTick() : m_ticks(TICK_INVALID) {}
    TimeTick(qint64 ticks) : m_ticks(ticks) {}

    TimeTick &operator=(const TimeTick &other)
    {
        m_ticks = other.m_ticks;
        return *this;
    }
    bool operator==(const TimeTick &other) const { return m_ticks == other.m_ticks; }
    bool operator!=(const TimeTick &other) const { return m_ticks != other.m_ticks; }
    operator qint64() { return m_ticks; }

    Q_INVOKABLE bool valid() const { return m_ticks != TICK_INVALID; }

    Q_INVOKABLE QString toString() const
    {
        if(m_ticks == TICK_INVALID)
            return  "--:--";

        qint64 t_sec = SEC_FROM_TICK(m_ticks);
        int sec = t_sec % 60;
        int min = (t_sec / 60) % 60;
        int hour = static_cast<int>(t_sec / 3600);

        if(hour == 0)
            return QString("%1:%2")
                    .arg(min, 2, 10, QChar('0'))
                    .arg(sec, 2, 10, QChar('0'));

        return QString("%1:%2:%3")
                .arg(hour, 2, 10, QChar('0'))
                .arg(min, 2, 10, QChar('0'))
                .arg(sec, 2, 10, QChar('0'));
    }

    Q_INVOKABLE TimeTick scale(float scalar) const
    {
        return TimeTick(qRound64(m_ticks * scalar));
    }

private:
    qint64 m_ticks;
};

#endif // TIMETICK_H
