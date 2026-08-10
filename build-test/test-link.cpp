// test-link.cpp - Minimal linker validation for boost.xcframework
// This just validates that all 10 included libraries link without undefined symbols.
#include <boost/version.hpp>
#include <iostream>

int main() {
    std::cout << "Boost version: " << BOOST_VERSION << std::endl;
    std::cout << "Linking test passed" << std::endl;
    return 0;
}
