#ifndef LAZY_H
#define LAZY_H

#include <functional>
#include <memory>
#include <stdexcept>

#define LAZY_CREATE(T, ...) ([=](){ return new T(__VA_ARGS__); })

namespace Util {

// Helper for lazy initialisation of objects.
// Usage:
//    Lazy<Foo> my_lazy_object([]() { return new Foo; });
template <typename T>
class Lazy
{
public:
    explicit Lazy(std::function<T*()> init) : m_init(init) {}

    // Convenience constructor that will lazily default construct the object.
    Lazy() : m_init([]() { return new T; }) {}

    T* get() const
    {
        checkInitialized();
        return m_ptr.get();
    }

    typename std::add_lvalue_reference<T>::type operator*() const
    {
        checkInitialized();
        return *m_ptr;
    }

    T* operator->() const
    {
        return get();
    }

    // Returns true if the object is not yet initialised.
    explicit operator bool() const
    {
        return m_ptr != nullptr;
    }

    // Deletes the underlying object and will re-run the initialisation function
    // if the object is requested again.
    void reset()
    {
        m_ptr.reset(nullptr);
    }

private:
    void checkInitialized() const
    {
        if (!m_ptr)
        {
            m_ptr.reset(m_init());
        }
    }

    static T defaultInitiator()
    {
        throw std::runtime_error("No lazy evaluator given.");
    }
private:
    const std::function<T*()> m_init;
    mutable std::unique_ptr<T> m_ptr;
};

} // namespace Util

#endif // LAZY_H
