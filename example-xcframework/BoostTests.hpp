#pragma once

#include <string>

struct BoostTestResult {
    bool passed;
    std::string report;
};

BoostTestResult runBoostTests();
