#ifndef INCUBATOR_H
#define INCUBATOR_H

#include <functional>
#include <memory>
#include <unordered_map>
#include <mutex>

namespace Util {

class Incubator
{
public:
    Incubator()
    {
    }

    ~Incubator()
    {
        clear();
    }

    void clear()
    {
        m_services.clear();
        m_lazyServices.clear();
    }

    size_t count() const
    {
        return size();
    }

    size_t size() const
    {
        return m_services.size() + m_lazyServices.size();
    }

    // register a instance
    // NOTE: it is the same instance everytime to call resolve
    template <typename T>
    void inject(T *service = new T())
    {
        std::lock_guard<std::mutex> lock(m_mutex);
        size_t hash = typeid(T).hash_code();
        if(m_services.find(hash) == m_services.end())
            m_services.emplace(hash, service);
    }

    // register a instance
    // NOTE: it is the same instance everytime to call resolve
    template <typename T, typename ...Args>
    void injectWith(Args &&...args)
    {
        std::lock_guard<std::mutex> lock(m_mutex);
        size_t hash = typeid(T).hash_code();
        if(m_services.find(hash) == m_services.end())
            m_services.emplace(hash, new T(std::forward<Args>(args)...));
    }

    // Lazy initialization to creates a shared pointer
    // NOTE: not the same instance everytime to call resolve
    template <typename T>
    void lazyInject(std::function<std::shared_ptr<T>()> creator =
        []() { return std::make_shared<T>(); } )
    {
        std::lock_guard<std::mutex> lock(m_mutex);
        size_t hash = typeid(T).hash_code();
        if(m_lazyServices.find(hash) == m_lazyServices.end())
            m_lazyServices.emplace(hash, creator);
    }

    // Lazy initialization to creates a shared pointer
    // NOTE: not the same instance everytime to call resolve
    template <typename T, typename ...Args>
    void lazyInjectWith(Args &&...args)
    {
        std::lock_guard<std::mutex> lock(m_mutex);
        size_t hash = typeid(T).hash_code();
        if(m_lazyServices.find(hash) == m_lazyServices.end())
            m_lazyServices.emplace(hash, [=]() { return std::make_shared<T>(args...); } );
    }

    template<typename T>
    std::shared_ptr<T> resolve() const
    {
        size_t hash = typeid(T).hash_code();
        auto it1 = m_services.find(hash);
        if (it1 != m_services.end())
            return std::static_pointer_cast<T>(it1->second);

        auto it2 = m_lazyServices.find(hash);
        if (it2 != m_lazyServices.end())
            return std::static_pointer_cast<T>(it2->second());

        return nullptr;
    }

private:
    std::mutex m_mutex;
    std::unordered_map<size_t, std::shared_ptr<void>> m_services;
    std::unordered_map<size_t, std::function<std::shared_ptr<void>()>> m_lazyServices;
};

} // namespace Util

#endif // INCUBATOR_H
