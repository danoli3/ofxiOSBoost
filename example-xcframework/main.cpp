#include <boost/filesystem.hpp>
#include <boost/regex.hpp>
#include <boost/version.hpp>
#if BOOST_VERSION >= 106200
#include <boost/qvm/vec.hpp>
#endif

#include <iostream>

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

    std::cout << "Boost " << BOOST_LIB_VERSION << " XCFramework linked successfully\n";
    return 0;
}
