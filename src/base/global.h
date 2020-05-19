#ifndef GLOBAL_H
#define GLOBAL_H

#include <QScopedPointer>

#define D_PTR(Class)                    \
    Q_DECLARE_PRIVATE_D(d, Class)       \
    QScopedPointer<Class##Private> d;

#define Q_PTR(Class)                    \
    Q_DECLARE_PUBLIC(Class)             \
public:                                 \
    Class *q_ptr = nullptr;

#define CLASS_NAME(Class)               \
public:                                 \
    inline static QString className()   \
    {                                   \
        return #Class;                  \
    }

#endif // GLOBAL_H
