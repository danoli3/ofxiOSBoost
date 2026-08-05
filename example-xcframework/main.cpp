#include <boost/filesystem.hpp>
#include <boost/regex.hpp>
#include <boost/version.hpp>

#include <iostream>

int main()
{
    const boost::filesystem::path path("/tmp/ofxiOSBoost/example.txt");
    const boost::regex expected("example\\.txt");

    if (!boost::regex_match(path.filename().string(), expected)) {
        return 1;
    }

    std::cout << "Boost " << BOOST_LIB_VERSION << " XCFramework linked successfully\n";
    return 0;
}
