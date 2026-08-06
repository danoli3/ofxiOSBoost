#include <boost/filesystem.hpp>
#include <boost/regex.hpp>
#include <boost/version.hpp>
#if BOOST_VERSION >= 106200
#include <boost/qvm/vec.hpp>
#endif
#if BOOST_VERSION >= 106300
#include <boost/atomic.hpp>
#include <boost/type_index/runtime_cast.hpp>
#endif

#include <iostream>

#if BOOST_VERSION >= 106300
struct RuntimeBase {
    BOOST_TYPE_INDEX_REGISTER_RUNTIME_CLASS()
    virtual ~RuntimeBase() {}
};

struct RuntimeDerived : RuntimeBase {
    BOOST_TYPE_INDEX_REGISTER_RUNTIME_CLASS((RuntimeBase))
};
#endif

int main()
{
    const boost::filesystem::path path("/tmp/ofxiOSBoost/example.txt");
    const boost::regex expected("example\\.txt");

    if (!boost::regex_match(path.filename().string(), expected)) {
        return 1;
    }

#if BOOST_VERSION >= 106200
    // QVM is new in Boost 1.62 and is supplied by the packaged header tree.
    const boost::qvm::vec<float, 3> vector = {{1.0f, 2.0f, 3.0f}};
    if (vector.a[0] + vector.a[1] + vector.a[2] != 6.0f) {
        return 2;
    }
#endif

#if BOOST_VERSION >= 106300
    // TypeIndex runtime_cast and Atomic::is_always_lock_free are new in 1.63.
    RuntimeDerived derived;
    RuntimeBase *base = &derived;
    if (boost::typeindex::runtime_cast<RuntimeDerived *>(base) != &derived) {
        return 3;
    }
    if (boost::atomic<int>::is_always_lock_free != boost::atomic<int>().is_lock_free()) {
        return 4;
    }
#endif

    std::cout << "Boost " << BOOST_LIB_VERSION << " XCFramework linked successfully\n";
    return 0;
}
