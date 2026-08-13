#include "BoostTests.hpp"

#include <boost/version.hpp>
#include <boost/asio/io_service.hpp>
#include <boost/atomic.hpp>
#include <boost/chrono.hpp>
#if BOOST_VERSION >= 106500
#include <boost/context/detail/fcontext.hpp>
#include <boost/coroutine2/coroutine.hpp>
#endif
#include <boost/date_time/gregorian/gregorian.hpp>
#include <boost/filesystem.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/locale.hpp>
#include <boost/random/random_device.hpp>
#include <boost/regex.hpp>
#if BOOST_VERSION < 106900
#include <boost/signal.hpp>
#else
#include <boost/signals2.hpp>
#endif
#include <boost/system/error_code.hpp>
#include <boost/thread.hpp>

#if BOOST_VERSION >= 106600
#include <boost/beast/http.hpp>
#include <boost/callable_traits.hpp>
#include <boost/mp11.hpp>
#endif
#if BOOST_VERSION >= 106700
#include <boost/contract/assert.hpp>
#include <boost/hof.hpp>
#endif
#if BOOST_VERSION >= 106800
#include <boost/yap/yap.hpp>
#endif
#if BOOST_VERSION >= 107000
#include <boost/histogram.hpp>
#include <boost/outcome.hpp>
#endif
#if BOOST_VERSION >= 107100
#include <boost/variant2/variant.hpp>
#endif
#if BOOST_VERSION >= 107300
#include <boost/nowide/cstdio.hpp>
#include <boost/functional/hash.hpp>
#include <boost/nowide/convert.hpp>
#include <boost/static_string/static_string.hpp>
#endif
#if BOOST_VERSION >= 107400
#include <boost/asio/any_io_executor.hpp>
#include <boost/asio/post.hpp>
#include <boost/nowide/utf/convert.hpp>
#include <boost/stl_interfaces/iterator_interface.hpp>
#endif
#if BOOST_VERSION >= 107500
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>
#include <boost/json.hpp>
#include <boost/leaf.hpp>
#include <boost/make_shared.hpp>
#include <boost/pfr.hpp>
#include <boost/serialization/string.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/serialization/shared_ptr.hpp>
#include <boost/shared_ptr.hpp>
#endif

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <exception>
#include <fstream>
#include <numeric>
#include <sstream>
#include <type_traits>
#include <vector>

namespace {

#if BOOST_VERSION >= 106500
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
#endif

#if BOOST_VERSION >= 107400
struct Boost174Iterator
    : boost::stl_interfaces::iterator_interface<
          Boost174Iterator,
          std::random_access_iterator_tag,
          int>
{
    Boost174Iterator() noexcept : current(nullptr) {}
    explicit Boost174Iterator(int *value) noexcept : current(value) {}

    int &operator*() const noexcept { return *current; }
    Boost174Iterator &operator+=(std::ptrdiff_t offset) noexcept
    {
        current += offset;
        return *this;
    }
    std::ptrdiff_t operator-(Boost174Iterator other) const noexcept
    {
        return current - other.current;
    }

private:
    int *current;
};

struct Boost174Variant : boost::variant2::variant<int, std::string>
{
    using boost::variant2::variant<int, std::string>::variant;
};
#endif

#if BOOST_VERSION >= 107500
struct Boost175SharedPayload {
    std::string value;

    template<class Archive>
    void serialize(Archive &archive, const unsigned int)
    {
        archive & value;
    }
};

struct Boost175Record {
    int id = 0;
    std::string name;
    std::vector<int> values;
    boost::shared_ptr<Boost175SharedPayload> first;
    boost::shared_ptr<Boost175SharedPayload> second;

    template<class Archive>
    void serialize(Archive &archive, const unsigned int)
    {
        archive & id & name & values & first & second;
    }
};

struct Boost175Aggregate {
    int id;
    long count;
};

struct Boost175LeafError {
    int value;
};
#endif

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
#if BOOST_VERSION < 106900
    boost::signal<int(int)> signal;
#else
    boost::signals2::signal<int(int)> signal;
#endif
    signal.connect([](int value) { return value + 1; });
    signal.connect([](int value) { return value * 2; });
#if BOOST_VERSION < 106900
    const int result = signal(21);
    detail = "two connected Signals slots emitted";
    return result == 42;
#else
    const boost::optional<int> result = signal(21);
    detail = "two connected Signals2 slots emitted";
    return result && *result == 42;
#endif
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

#if BOOST_VERSION >= 106600
bool testBoost166Headers(std::string &detail)
{
    namespace http = boost::beast::http;
    http::request<http::string_body> request;
    request.method(http::verb::get);
    request.target("/status");
    request.version(11);
    request.set(http::field::host, "localhost");

    using Function = int (*)(double);
    using Return = boost::callable_traits::return_type_t<Function>;
    using Types = boost::mp11::mp_list<int, double, char>;

    detail = "Beast HTTP, CallableTraits, and Mp11";
    return request.method() == http::verb::get &&
           request.target() == "/status" &&
           request[http::field::host] == "localhost" &&
           std::is_same<Return, int>::value &&
           boost::mp11::mp_size<Types>::value == 3;
}
#endif

#if BOOST_VERSION >= 106700
bool testBoost167Features(std::string &detail)
{
    BOOST_CONTRACT_ASSERT(2 + 2 == 4);
    const auto sum = boost::hof::placeholders::_1 +
                     boost::hof::placeholders::_2;
    detail = "Contract assertion and HOF placeholder expression";
    return sum(19, 23) == 42;
}
#endif

#if BOOST_VERSION >= 106800
bool testBoost168Features(std::string &detail)
{
    const auto left = boost::yap::make_terminal(19);
    const auto expression = left + 23;
    detail = "YAP expression template evaluated";
    return boost::yap::evaluate(expression) == 42;
}
#endif

#if BOOST_VERSION >= 107000
bool testBoost170Features(std::string &detail)
{
    auto histogram = boost::histogram::make_histogram(
        boost::histogram::axis::regular<>(2, 0.0, 2.0));
    histogram(0.25);
    histogram(1.25);

    boost::outcome_v2::result<int> outcome = 42;
    detail = "Histogram bins and Outcome result value";
    return histogram.at(0) == 1 && histogram.at(1) == 1 &&
           outcome.has_value() && outcome.value() == 42;
}
#endif

#if BOOST_VERSION >= 107100
bool testBoost171Features(std::string &detail)
{
    boost::variant2::variant<int, std::string> value = 42;
    const int first = boost::variant2::visit(
        [](const auto &item) { return static_cast<int>(item.size()); },
        boost::variant2::variant<std::string>(std::string("variant2")));
    detail = "Variant2 alternative selection and visitation";
    return boost::variant2::holds_alternative<int>(value) &&
           boost::variant2::get<int>(value) == 42 && first == 8;
}
#endif

#if BOOST_VERSION >= 107200
bool testBoost172Updates(std::string &detail)
{
    try {
        boost::filesystem::file_size(
            boost::filesystem::path("/ofxiosboost/nonexistent/1.72"));
    } catch (const boost::filesystem::filesystem_error &error) {
        detail = "compiled Filesystem exception caught";
        return error.code().value() != 0;
    }
    detail = "expected Filesystem exception was not thrown";
    return false;
}
#endif

#if BOOST_VERSION >= 107300
bool testBoost173Features(std::string &detail)
{
    boost::static_string<16> text("Boost");
    text.append(" 1.73");

    const std::string utf8 = u8"caf\u00e9";
    const std::wstring wide = boost::nowide::widen(utf8);
    const std::string roundTrip = boost::nowide::narrow(wide);
    std::FILE *nullFile = boost::nowide::fopen("/dev/null", "r");
    const bool nowideFileOpened = nullFile != nullptr;
    if (nullFile)
        std::fclose(nullFile);

    boost::variant2::variant<int, std::string> value = std::string("hash");
    const std::size_t hash = boost::hash<decltype(value)>{}(value);

    detail = "StaticString, Nowide UTF-8 + compiled fopen, and Variant2 hash";
    return text == "Boost 1.73" && text.size() == 10 && text.capacity() == 16 &&
           text.data()[text.size()] == '\0' && roundTrip == utf8 &&
           nowideFileOpened && hash != 0;
}
#endif

#if BOOST_VERSION >= 107400
bool testBoost174Features(std::string &detail)
{
    std::array<int, 5> values{{5, 1, 4, 2, 3}};
    Boost174Iterator first(values.data());
    Boost174Iterator last(values.data() + values.size());
    std::sort(first, last);
    const bool iteratorPassed =
        std::accumulate(first, last, 0) == 15 && first[2] == 3 &&
        last - first == 5 && first < last;

    const std::string utf8 = u8"caf\u00e9";
    const std::u32string utf32 = boost::nowide::utf::convert_string<char32_t>(
        utf8.data(), utf8.data() + utf8.size());
    const std::string utfRoundTrip = boost::nowide::utf::convert_string<char>(
        utf32.data(), utf32.data() + utf32.size());

    Boost174Variant derived(std::string("derived"));
    const std::size_t visited = boost::variant2::visit<std::size_t>(
        [](const auto &) { return std::size_t(7); },
        derived);

    boost::asio::io_context service;
    boost::asio::any_io_executor executor = service.get_executor();
    int callbacks = 0;
    boost::asio::post(executor, [&callbacks] { ++callbacks; });
    service.run();

    const char *temporaryRoot = std::getenv("TMPDIR");
    if (!temporaryRoot || !*temporaryRoot) {
        detail = "app sandbox TMPDIR is unavailable";
        return false;
    }
    const boost::filesystem::path directory =
        boost::filesystem::path(temporaryRoot) / "ofxiosboost-1.74-smoke";
    const boost::filesystem::path source = directory / "source.txt";
    const boost::filesystem::path destination = directory / "destination.txt";
    boost::system::error_code ignored;
    boost::filesystem::remove_all(directory, ignored);
    boost::filesystem::create_directories(directory);
    {
        std::ofstream output(source.string());
        output << "Boost 1.74";
    }
    const bool copied = boost::filesystem::copy_file(
        source, destination, boost::filesystem::copy_options::skip_existing);
    const bool skipped = !boost::filesystem::copy_file(
        source, destination, boost::filesystem::copy_options::skip_existing);
    const bool filesystemPassed =
        copied && skipped && boost::filesystem::file_size(destination) == 10;
    boost::filesystem::remove_all(directory, ignored);

    detail = "STLInterfaces, Nowide UTF, Variant2 visit<R>, Filesystem copy, and Asio executor";
    return iteratorPassed && utfRoundTrip == utf8 && visited == 7 &&
           callbacks == 1 && filesystemPassed;
}
#endif

#if BOOST_VERSION >= 107500
bool testBoost175Features(std::string &detail)
{
    boost::json::value json = boost::json::parse(
        R"({"name":"Boost","version":175,"ready":true,"values":[1,2,3]})");
    boost::json::object &object = json.as_object();
    object["platform"] = "iOS";
    const std::string serializedJson = boost::json::serialize(json);
    const bool jsonPassed = object.at("name").as_string() == "Boost" &&
        object.at("version").as_int64() == 175 &&
        object.at("values").as_array().size() == 3 &&
        serializedJson.find("iOS") != std::string::npos;

    Boost175Record input;
    input.id = 175;
    input.name = "serialization";
    input.values = {1, 7, 5};
    input.first = boost::make_shared<Boost175SharedPayload>();
    input.first->value = "shared";
    input.second = input.first;
    std::stringstream archiveBuffer;
    {
        boost::archive::binary_oarchive output(archiveBuffer);
        output << input;
    }
    Boost175Record output;
    {
        boost::archive::binary_iarchive inputArchive(archiveBuffer);
        inputArchive >> output;
    }
    const bool serializationPassed = output.id == 175 &&
        output.name == "serialization" && output.values == input.values &&
        output.first && output.second && output.first == output.second &&
        output.first->value == "shared";

    Boost175Aggregate aggregate{17, 5};
    boost::pfr::for_each_field(aggregate, [](auto &field) { ++field; });
    const bool pfrPassed = boost::pfr::get<0>(aggregate) == 18 &&
        boost::pfr::get<1>(aggregate) == 6;

    const int leafValue = boost::leaf::try_handle_all(
        []() -> boost::leaf::result<int> {
            return boost::leaf::new_error(Boost175LeafError{75});
        },
        [](const Boost175LeafError &error) { return error.value; },
        [](const boost::leaf::error_info &) { return -1; });

    detail = "JSON DOM, Serialization identity, LEAF error, and PFR fields";
    return jsonPassed && serializationPassed && pfrPassed && leafValue == 75;
}
#endif

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
#if BOOST_VERSION >= 106600
    run("Boost 1.66 headers", testBoost166Headers);
#endif
#if BOOST_VERSION >= 106700
    run("Boost 1.67 features", testBoost167Features);
#endif
#if BOOST_VERSION >= 106800
    run("Boost 1.68 features", testBoost168Features);
#endif
#if BOOST_VERSION >= 107000
    run("Boost 1.70 features", testBoost170Features);
#endif
#if BOOST_VERSION >= 107100
    run("Boost 1.71 features", testBoost171Features);
#endif
#if BOOST_VERSION >= 107200
    run("Boost 1.72 updates", testBoost172Updates);
#endif
#if BOOST_VERSION >= 107300
    run("Boost 1.73 features", testBoost173Features);
#endif
#if BOOST_VERSION >= 107400
    run("Boost 1.74 features", testBoost174Features);
#endif
#if BOOST_VERSION >= 107500
    run("Boost 1.75 features", testBoost175Features);
#endif
#if BOOST_VERSION >= 106500
    run("Boost.Context", testContext);
    run("Boost.Coroutine2", testCoroutine2);
#endif
    report << "\n" << (passed ? "ALL TESTS PASSED" : "TESTS FAILED");
    return {passed, report.str()};
}
