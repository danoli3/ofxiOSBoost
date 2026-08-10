#include "BoostTests.hpp"

#include <boost/asio/io_service.hpp>
#include <boost/atomic.hpp>
#include <boost/chrono.hpp>
#include <boost/context/detail/fcontext.hpp>
#include <boost/coroutine2/coroutine.hpp>
#include <boost/date_time/gregorian/gregorian.hpp>
#include <boost/filesystem.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/locale.hpp>
#include <boost/random/random_device.hpp>
#include <boost/regex.hpp>
#include <boost/signal.hpp>
#include <boost/system/error_code.hpp>
#include <boost/thread.hpp>
#include <boost/version.hpp>

#include <cstdint>
#include <exception>
#include <sstream>
#include <vector>

namespace {

using boost::context::detail::fcontext_t;
using boost::context::detail::jump_fcontext;
using boost::context::detail::make_fcontext;
using boost::context::detail::ontop_fcontext;
using boost::context::detail::transfer_t;

struct ContextState {
    fcontext_t caller{};
    int visits = 0;
    volatile std::uint64_t canary[64]{};
    bool ontopVisited = false;
};

transfer_t contextOntop(transfer_t transfer)
{
    ContextState *state = static_cast<ContextState *>(transfer.data);
    state->ontopVisited = true;
    return transfer;
}

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
    transfer = ontop_fcontext(child, &state, contextOntop);
    child = transfer.fctx;
    (void)child;

    detail = "two jumps, ontop_fcontext, then resumed child";
    return state.visits == 3 && state.ontopVisited;
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

bool testSystemAndChrono(std::string &detail)
{
    const boost::system::error_code error(
        2, boost::system::generic_category());
    const auto start = boost::chrono::steady_clock::now();
    const auto finish = boost::chrono::steady_clock::now();
    detail = "error_code category and steady_clock";
    return error.value() == 2 && finish >= start;
}

bool testDateTime(std::string &detail)
{
    using namespace boost::gregorian;
    const date releaseDay(2017, Sep, 7);
    detail = "Gregorian date arithmetic";
    return releaseDay + days(1) == date(2017, Sep, 8);
}

bool testRandom(std::string &detail)
{
    boost::random::random_device source;
    const auto value = source();
    detail = "random_device produced native entropy";
    return value >= source.min() && value <= source.max();
}

bool testThreadAndAtomic(std::string &detail)
{
    boost::atomic<int> counter(0);
    const auto increment = [&counter] {
        for (int i = 0; i < 1000; ++i) {
            ++counter;
        }
    };
    boost::thread first(increment);
    boost::thread second(increment);
    first.join();
    second.join();
    detail = "two joined threads and 2,000 atomic increments";
    return counter.load() == 2000;
}

bool testSignals(std::string &detail)
{
    boost::signal<int(int)> signal;
    signal.connect([](int value) { return value + 1; });
    signal.connect([](int value) { return value * 2; });
    const int result = signal(21);
    detail = "two connected slots emitted";
    return result == 42;
}

bool testGraph(std::string &detail)
{
    using Graph = boost::adjacency_list<boost::vecS, boost::vecS,
                                        boost::undirectedS>;
    Graph graph(4);
    add_edge(0, 1, graph);
    add_edge(1, 2, graph);
    add_edge(2, 3, graph);
    detail = "four vertices and three edges";
    return num_vertices(graph) == 4 && num_edges(graph) == 3;
}

bool testLocale(std::string &detail)
{
    boost::locale::generator generator;
    const std::locale locale = generator("C");
    const std::string upper = boost::locale::to_upper("Boost", locale);
    detail = "C locale generated and case-converted";
    return upper == "BOOST";
}

bool testAsio(std::string &detail)
{
    boost::asio::io_service service;
    int callbacks = 0;
    service.post([&callbacks] { ++callbacks; });
    service.post([&callbacks] { ++callbacks; });
    const std::size_t handled = service.run();
    detail = "two offline io_service callbacks";
    return callbacks == 2 && handled == 2;
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
        bool result = false;
        try {
            result = test(detail);
        } catch (const std::exception &error) {
            detail = error.what();
        } catch (...) {
            detail = "unknown exception";
        }
        passed = passed && result;
        report << (result ? "PASS" : "FAIL") << "  " << name
               << "\n      " << detail << "\n";
    };

    run("Packaged libraries", testPackagedLibraries);
    run("System + Chrono", testSystemAndChrono);
    run("DateTime", testDateTime);
    run("Random", testRandom);
    run("Thread + Atomic", testThreadAndAtomic);
    run("Signals", testSignals);
    run("Graph", testGraph);
    run("Locale", testLocale);
    run("Asio", testAsio);
    run("Boost.Context", testContext);
    run("Boost.Coroutine2", testCoroutine2);
    report << "\n" << (passed ? "ALL TESTS PASSED" : "TESTS FAILED");
    return {passed, report.str()};
}
