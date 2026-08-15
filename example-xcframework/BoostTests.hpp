#pragma once

#include <cstddef>
#include <string>

struct BoostTestResult {
    bool passed;
    std::string report;
};

BoostTestResult runBoostTests();
std::string boostTestReportHeader();
std::size_t boostTestCount();
BoostTestResult runBoostTestAtIndex(std::size_t index);
