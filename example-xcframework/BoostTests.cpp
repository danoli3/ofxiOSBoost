#include "BoostTests.hpp"

#include <boost/context/detail/fcontext.hpp>
#include <boost/coroutine2/coroutine.hpp>
#include <boost/filesystem.hpp>
#include <boost/regex.hpp>
#include <boost/version.hpp>

#include <cstdint>
#include <sstream>
#include <vector>

namespace {

using boost::context::detail::fcontext_t;
using boost::context::detail::jump_fcontext;
using boost::context::detail::make_fcontext;
using boost::context::detail::transfer_t;

struct ContextState {
    fcontext_t caller{};
    int visits = 0;
    volatile std::uint64_t canary[64]{};
};

void contextEntry(transfer_t transfer)
{
    ContextState *state = static_cast<ContextState *>(transfer.data);
    state->caller = transfer.fctx;

    for (std::size_t i = 0; i < 64; ++i) {
        state->canary[i] = 0xC0FFEE00ULL + i;
    }

    for (;;) {
        ++state->visits;
        for (std::size_t i = 0; i < 64; ++i) {
            if (state->canary[i] != 0xC0FFEE00ULL + i) {
                state->visits = -1;
                break;
            }
        }
        transfer = jump_fcontext(state->caller, state);
        state->caller = transfer.fctx;
    }
}

bool testContext(std::string &detail)
{
    const std::size_t stackSize = 64 * 1024;
    std::vector<unsigned char> stack(stackSize);
    ContextState state;

    fcontext_t child =
        make_fcontext(stack.data() + stack.size(), stack.size(), contextEntry);
    transfer_t transfer = jump_fcontext(child, &state);
    child = transfer.fctx;
    transfer = jump_fcontext(child, &state);
    child = transfer.fctx;
    (void)child;

    detail = "two fcontext stack round-trips";
    return state.visits == 2;
}

bool testCoroutine2(std::string &detail)
{
    using Coroutine = boost::coroutines2::coroutine<int>;
    Coroutine::pull_type source([](Coroutine::push_type &sink) {
        sink(21);
        sink(42);
    });

    std::vector<int> values;
    for (int value : source) {
        values.push_back(value);
    }

    detail = "Coroutine2 yielded 21, 42";
    return values.size() == 2 && values[0] == 21 && values[1] == 42;
}

bool testPackagedLibraries(std::string &detail)
{
    const boost::filesystem::path path("/tmp/ofxiOSBoost/example.txt");
    const boost::regex expected("example\\.txt");
    detail = "Filesystem and Regex linked";
    return boost::regex_match(path.filename().string(), expected);
}

} // namespace

BoostTestResult runBoostTests()
{
    std::ostringstream report;
    report << "Boost " << BOOST_LIB_VERSION << "\n\n";
    bool passed = true;

    const auto run = [&](const char *name,
                         bool (*test)(std::string &)) {
        std::string detail;
        const bool result = test(detail);
        passed = passed && result;
        report << (result ? "PASS" : "FAIL") << "  " << name
               << "\n      " << detail << "\n";
    };

    run("Packaged libraries", testPackagedLibraries);
    run("Boost.Context", testContext);
    run("Boost.Coroutine2", testCoroutine2);
    report << "\n" << (passed ? "ALL TESTS PASSED" : "TESTS FAILED");
    return {passed, report.str()};
}
