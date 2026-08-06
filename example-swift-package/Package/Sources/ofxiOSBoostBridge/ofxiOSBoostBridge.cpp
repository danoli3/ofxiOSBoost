#include "ofxiOSBoostBridge.h"

#include <boost/filesystem.hpp>
#include <boost/regex.hpp>
#include <boost/version.hpp>

#if BOOST_VERSION >= 106200
#include <boost/qvm/vec.hpp>
#endif

const char *ofxiOSBoostVersion(void)
{
    return BOOST_LIB_VERSION;
}

bool ofxiOSBoostRunLinkTest(void)
{
    const boost::filesystem::path path("/tmp/ofxiOSBoost/swift-package.txt");
    const boost::regex expected("swift-package\\.txt");
    if (!boost::regex_match(path.filename().string(), expected)) {
        return false;
    }

#if BOOST_VERSION >= 106200
    const boost::qvm::vec<int, 3> vector = {{1, 2, 3}};
    if (vector.a[0] + vector.a[1] + vector.a[2] != 6) {
        return false;
    }
#endif

    return true;
}
