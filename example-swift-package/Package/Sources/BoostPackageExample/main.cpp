#include <ofxiOSBoostBridge.h>

#include <iostream>

int main()
{
    if (!ofxiOSBoostRunLinkTest()) {
        return 1;
    }

    std::cout << "Boost " << ofxiOSBoostVersion()
              << " linked through a Swift package binary target\n";
    return 0;
}
