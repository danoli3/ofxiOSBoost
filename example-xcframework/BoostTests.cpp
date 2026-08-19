#include "BoostTests.hpp"

#include <boost/version.hpp>
#if BOOST_VERSION >= 107700
#define BOOST_FILESYSTEM_VERSION 4
#endif
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
#if BOOST_VERSION >= 107600
#include <boost/asio/ip/address.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <boost/bind/bind.hpp>
#include <boost/core/bit.hpp>
#include <boost/core/cmath.hpp>
#endif
#if BOOST_VERSION >= 107700
#include <boost/describe.hpp>
#include <boost/lambda2.hpp>
#endif
#if BOOST_VERSION >= 107800
#include <boost/core/span.hpp>
#include <boost/core/type_name.hpp>
#include <boost/system/result.hpp>
#include <boost/variant2.hpp>
#endif
#if BOOST_VERSION >= 107900
#include <boost/io/nullstream.hpp>
#include <boost/throw_exception.hpp>
#include <boost/unordered/unordered_map.hpp>
#endif
#if BOOST_VERSION >= 108000
#include <boost/atomic/atomic_ref.hpp>
#include <boost/math/ccmath/fma.hpp>
#include <boost/math/statistics/chatterjee_correlation.hpp>
#include <boost/optional.hpp>
#include <boost/utility/string_view.hpp>
#endif
#if BOOST_VERSION >= 108100
#include <boost/container/pmr/monotonic_buffer_resource.hpp>
#include <boost/container/pmr/vector.hpp>
#include <boost/log/core.hpp>
#include <boost/log/sources/logger.hpp>
#define BOOST_STACKTRACE_GNU_SOURCE_NOT_REQUIRED
#include <boost/stacktrace/stacktrace.hpp>
#include <boost/timer/timer.hpp>
#include <boost/type_erasure/any.hpp>
#include <boost/type_erasure/any_cast.hpp>
#include <boost/type_erasure/builtin.hpp>
#include <boost/type_erasure/operators.hpp>
#include <boost/unordered/unordered_flat_map.hpp>
#include <boost/url.hpp>
#endif
#if BOOST_VERSION >= 108200
#include <boost/asio/buffer.hpp>
#include <boost/core/data.hpp>
#include <boost/core/identity.hpp>
#include <boost/core/memory_resource.hpp>
#include <boost/core/size.hpp>
#include <boost/mysql/blob.hpp>
#include <boost/mysql/date.hpp>
#include <boost/mysql/field.hpp>
#include <boost/nowide/quoted.hpp>
#include <boost/pfr/core.hpp>
#include <boost/static_string/static_string.hpp>
#include <boost/unordered/unordered_node_map.hpp>
#include <boost/unordered/unordered_node_set.hpp>
#endif

#include <algorithm>
#include <array>
#if __cplusplus >= 202002L
#include <bit>
#include <concepts>
#endif
#include <cstdint>
#include <cstdlib>
#include <exception>
#include <fstream>
#include <functional>
#include <limits>
#include <numeric>
#if __cplusplus >= 201703L
#include <optional>
#endif
#include <sstream>
#if __cplusplus >= 202002L
#include <span>
#endif
#include <stdexcept>
#include <string_view>
#include <system_error>
#include <type_traits>
#include <vector>

namespace {

#if BOOST_VERSION >= 108100
struct Boost181Release {
    int version;
    std::optional<std::string> channel;
};

BOOST_DESCRIBE_STRUCT(Boost181Release, (), (version, channel))
#endif

#if BOOST_VERSION >= 108200
struct Boost182PfrRecord {
    int version;
    short patch;
};

struct Boost182TransparentHash {
    using is_transparent = void;

    std::size_t operator()(std::string_view value) const noexcept
    {
        return std::hash<std::string_view>{}(value);
    }
};

struct Boost182TransparentEqual {
    using is_transparent = void;

    bool operator()(std::string_view lhs, std::string_view rhs) const noexcept
    {
        return lhs == rhs;
    }
};

class Boost182MemoryResource final : public boost::core::memory_resource {
public:
    std::size_t allocations = 0;
    std::size_t deallocations = 0;

private:
    void *do_allocate(std::size_t bytes, std::size_t) override
    {
        ++allocations;
        return ::operator new(bytes);
    }

    void do_deallocate(void *pointer, std::size_t, std::size_t) override
    {
        ++deallocations;
        ::operator delete(pointer);
    }

    bool do_is_equal(const boost::core::memory_resource &other)
        const noexcept override
    {
        return this == &other;
    }
};
#endif

#if BOOST_VERSION >= 108000
struct Boost180FinalHash final {
    std::size_t operator()(int value) const noexcept
    {
        return std::hash<int>{}(value);
    }
};

struct Boost180FinalEqual final {
    bool operator()(int lhs, int rhs) const noexcept
    {
        return lhs == rhs;
    }
};

template <typename T>
concept Boost180Integral = std::integral<T>;

consteval int boost180ConstevalValue()
{
    return 80;
}

static_assert(Boost180Integral<int>);
static_assert(boost180ConstevalValue() == 80);
static_assert(boost::math::ccmath::fma(2.0, 3.0, 4.0) == 10.0);
#endif

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

#if BOOST_VERSION >= 107600
int addBoost176Values(int left, int right)
{
    return left + right;
}
#endif

#if BOOST_VERSION >= 107700
struct Boost177Record {
    int id;
    std::string name;
};

BOOST_DESCRIBE_STRUCT(Boost177Record, (), (id, name))
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

    const std::string utf8 = "caf\xc3\xa9";
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

    const std::string utf8 = "caf\xc3\xa9";
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

#if BOOST_VERSION >= 107600
bool testBoost176Features(std::string &detail)
{
    const unsigned int bits = 0x2du;
    const bool corePassed = boost::core::popcount(bits) == 4 &&
        boost::core::countr_zero(bits) == 0 &&
        boost::core::bit_floor(13u) == 8u &&
        boost::core::bit_ceil(13u) == 16u &&
        boost::core::isfinite(1.0) &&
        boost::core::isnan(std::numeric_limits<double>::quiet_NaN());

    const boost::asio::ip::address address =
        boost::asio::ip::address::from_string("127.0.0.1");
    const boost::asio::ip::tcp::endpoint endpoint(address, 1760);
    const std::size_t addressHash =
        std::hash<boost::asio::ip::address>{}(address);
    const std::size_t endpointHash =
        std::hash<boost::asio::ip::tcp::endpoint>{}(endpoint);
    const bool asioPassed = endpoint.port() == 1760 &&
        addressHash == std::hash<boost::asio::ip::address>{}(address) &&
        endpointHash ==
            std::hash<boost::asio::ip::tcp::endpoint>{}(endpoint);

    const auto add = boost::bind(
        &addBoost176Values, std::placeholders::_1, std::placeholders::_2);
    const bool bindPassed = add(17, 59) == 76;

    detail = "Core bit/cmath, Asio IP hashes, and Bind std placeholders";
    return corePassed && asioPassed && bindPassed;
}
#endif

#if BOOST_VERSION >= 107700
bool testBoost177Features(std::string &detail)
{
    Boost177Record record{77, "Describe"};
    std::size_t describedMembers = 0;
    bool describePassed = true;
    using Members = boost::describe::describe_members<
        Boost177Record, boost::describe::mod_public>;
    boost::mp11::mp_for_each<Members>([&](auto descriptor) {
        ++describedMembers;
        describePassed = describePassed && descriptor.name[0] != '\0';
    });
    describePassed = describePassed && describedMembers == 2 &&
        record.id == 77 && record.name == "Describe";

    const auto expression = boost::lambda2::_1 * 2 + boost::lambda2::_2;
    const bool lambdaPassed = expression(35, 7) == 77;

    const std::array<int, 3> source{{7, 7, 0}};
    const boost::json::value json = boost::json::value_from(source);
    const std::array<int, 3> roundTrip =
        boost::json::value_to<std::array<int, 3>>(json);
    const std::size_t jsonHash = std::hash<boost::json::value>{}(json);
    const bool jsonPassed = roundTrip == source &&
        jsonHash == std::hash<boost::json::value>{}(json);

    const boost::filesystem::path hidden(".boost");
    const bool filesystemPassed = hidden.stem() == ".boost" &&
        hidden.extension().empty();

    detail = "Describe, Lambda2, JSON array/hash, and Filesystem v4";
    return describePassed && lambdaPassed && jsonPassed && filesystemPassed;
}
#endif

#if BOOST_VERSION >= 107800
bool testBoost178Features(std::string &detail)
{
    const std::array<int, 3> values{{17, 18, 43}};
    const boost::span<const int> view(values);
    const bool corePassed = view.size() == 3 &&
        std::accumulate(view.begin(), view.end(), 0) == 78 &&
        !boost::core::type_name<int>().empty();

    const boost::system::result<int> success(78);
    const boost::system::result<int> failure(
        boost::system::errc::make_error_code(
            boost::system::errc::invalid_argument));
    const bool systemPassed = success.has_value() && success.value() == 78 &&
        !failure.has_value() &&
        failure.error() == boost::system::errc::invalid_argument;

    const boost::variant2::variant<int, std::string> variant(
        std::string("variant2"));
    const std::size_t visited = boost::variant2::visit_by_index(
        variant,
        [](int value) -> std::size_t { return static_cast<std::size_t>(value); },
        [](const std::string &value) -> std::size_t { return value.size(); });
    const bool variantPassed = visited == 8;

    const boost::filesystem::path directory("boost/");
    const bool filesystemPassed = directory.filename().empty();

    detail = "Core span/type_name, System result, Variant2 visit_by_index, "
        "and Filesystem v4 trailing separator";
    return corePassed && systemPassed && variantPassed && filesystemPassed;
}
#endif

#if BOOST_VERSION >= 107900
bool testBoost179Features(std::string &detail)
{
    const boost::json::value document = boost::json::parse(
        R"({"release":{"version":179,"stable":true}})");
    const bool jsonPassed =
        document.at_pointer("/release/version").as_int64() == 179 &&
        document.at_pointer("/release/stable").as_bool();

    boost::unordered_map<std::string, int> releases{
        {"stable", 179}, {"old", 178}};
    const bool containsPassed = releases.contains("stable");
    const std::size_t erased = boost::unordered::erase_if(
        releases,
        [](const auto &entry) { return entry.second < 179; });
    const bool unorderedPassed = containsPassed && erased == 1 &&
        releases.size() == 1;

    bool throwPassed = false;
    try {
        boost::throw_with_location(std::runtime_error("Boost 1.79"));
    } catch (const std::runtime_error &error) {
        const boost::source_location location = boost::get_throw_location(error);
        throwPassed = std::string(error.what()) == "Boost 1.79" &&
            location.line() != 0;
    }

    boost::io::onullstream nullOutput;
    nullOutput << "Boost " << 179;
    const bool ioPassed = nullOutput.good();

    detail = "JSON Pointer, Unordered contains/erase_if, "
        "throw_with_location, and IO null stream";
    return jsonPassed && unorderedPassed && throwPassed && ioPassed;
}
#endif

#if BOOST_VERSION >= 108000
bool testBoost180Features(std::string &detail)
{
    std::array<unsigned char, 4> bytes{{1, 8, 0, 0}};
    const std::span<unsigned char> span(bytes);
    const boost::asio::mutable_buffer buffer = boost::asio::buffer(span);
    const bool asioPassed = buffer.size() == bytes.size() &&
        buffer.data() == bytes.data();

    boost::json::value document = boost::json::parse(
        R"({"release":{"version":180},"name":"Boost"})");
    document.at("release").at("version") = 180;
    const boost::json::string &name = document.at("name").as_string();
    const bool jsonPassed =
        document.at("release").at("version").as_int64() == 180 &&
        name.subview() == "Boost";

    const boost::optional<int> optional(180);
    const bool optionalPassed = std::hash<boost::optional<int>>{}(optional) ==
        std::hash<boost::optional<int>>{}(optional);

    const boost::string_view text("Boost 1.80");
    const bool utilityPassed = text.contains("1.80") &&
        text.substr() == text;

    detail = "Asio std::span buffer, mutable JSON/subview, Optional hash, "
        "and Utility string_view";
    return asioPassed && jsonPassed && optionalPassed && utilityPassed;
}

bool testBoost180AtomicAndCpp20(std::string &detail)
{
    alignas(64) int sharedValue = 0;
    boost::atomic_ref<int> atomicValue(sharedValue);
    boost::atomic<bool> waiterReady(false);
    int observed = 0;
    boost::thread waiter([&] {
        waiterReady.store(true, boost::memory_order_release);
        observed = atomicValue.wait(0, boost::memory_order_acquire);
    });
    while (!waiterReady.load(boost::memory_order_acquire)) {
        boost::this_thread::yield();
    }
    atomicValue.store(80, boost::memory_order_release);
    atomicValue.notify_all();
    waiter.join();

    const std::uint32_t bits = std::bit_cast<std::uint32_t>(1.0f);
    detail = "Atomic ARM atomic_ref wait/notify and C++20 concept, consteval, bit_cast";
    return observed == 80 && sharedValue == 80 && bits == 0x3f800000u;
}

bool testBoost180System(std::string &detail)
{
    const boost::system::error_code original =
        boost::system::errc::make_error_code(
            boost::system::errc::invalid_argument);
    const std::error_code standard = original;
    const boost::system::error_code restored(standard);
    const std::error_code roundTripped = restored;
    const bool systemPassed = roundTripped == standard &&
        restored.message() == standard.message() &&
        standard.value() == original.value();

    std::ostringstream diagnostics;
    diagnostics << "System semantic std round-trip: boost="
                << original.category().name() << ':' << original.value()
                << ", std=" << standard.category().name() << ':'
                << standard.value() << ", restored="
                << restored.category().name() << ':' << restored.value()
                << ", round-tripped=" << roundTripped.category().name()
                << ':' << roundTripped.value();
    detail = diagnostics.str();
    return systemPassed;
}

bool testBoost180Unordered(std::string &detail)
{
    boost::unordered_map<int, std::string,
        Boost180FinalHash, Boost180FinalEqual> values;
    values.emplace(80, "C++20");
    const bool unorderedPassed = values.contains(80) &&
        values.at(80) == "C++20";

    detail = "Unordered map with final Hasher and KeyEqual types";
    return unorderedPassed;
}

bool testBoost180Leaf(std::string &detail)
{
    bool leafPassed = false;
    try {
        boost::leaf::throw_exception(
            std::runtime_error("Boost 1.80 LEAF"),
            Boost175LeafError{80});
    } catch (const std::runtime_error &error) {
        leafPassed = std::string(error.what()) == "Boost 1.80 LEAF";
    }

    detail = "LEAF throw_exception with std::exception and typed error payload";
    return leafPassed;
}

bool testBoost180Math(std::string &detail)
{
    const std::array<double, 6> independent{{1, 2, 3, 4, 5, 6}};
    const std::array<double, 6> dependent{{1, 3, 2, 6, 5, 4}};
    const double correlation =
        boost::math::statistics::chatterjee_correlation(
            independent, dependent);
    const double fused = boost::math::ccmath::fma(1.5, 4.0, -1.0);

    detail = "Math constexpr/runtime FMA and Chatterjee correlation";
    return fused == 5.0 && std::isfinite(correlation) &&
        correlation >= -1.0 && correlation <= 1.0;
}
#endif

#if BOOST_VERSION >= 108100
bool testBoost181Features(std::string &detail)
{
    const auto parsed = boost::urls::parse_uri(
        "https://www.boost.org/releases/1.81.0/?channel=stable");
    const bool urlPassed = parsed && parsed->scheme() == "https" &&
        parsed->host() == "www.boost.org" &&
        parsed->encoded_path() == "/releases/1.81.0/";

    boost::unordered_flat_map<std::string, int> releases;
    releases.emplace("current", 181);
    releases.emplace("previous", 180);
    const bool unorderedPassed = releases.contains("current") &&
        releases.at("current") == 181 && releases.size() == 2;

    const Boost181Release source{181, std::string("stable")};
    const boost::json::value json = boost::json::value_from(source);
    const Boost181Release restored =
        boost::json::value_to<Boost181Release>(json);
    const bool jsonPassed = restored.version == 181 && restored.channel &&
        *restored.channel == "stable";

    boost::system::result<std::string> result(std::string("old"));
    result.emplace("Boost 1.81");
    const bool systemPassed = result.has_value() &&
        result.value() == "Boost 1.81";

    detail = "URL parse, Unordered flat_map, JSON described/optional "
        "conversion, and System result emplace";
    return urlPassed && unorderedPassed && jsonPassed && systemPassed;
}

bool testBoost181Log(std::string &detail)
{
    boost::log::sources::logger logger;
    boost::log::record record = logger.open_record();
    const bool opened = static_cast<bool>(record);
    if (opened) {
        logger.push_record(std::move(record));
    }

    detail = "Log core opened and submitted a source record";
    return opened;
}

bool testBoost181Container(std::string &detail)
{
    std::array<unsigned char, 1024> storage{};
    boost::container::pmr::monotonic_buffer_resource resource(
        storage.data(), storage.size());
    boost::container::pmr::vector<int> values(&resource);
    values.push_back(20);
    values.push_back(22);

    detail = "Container PMR allocated a vector from a local monotonic resource";
    return values.size() == 2 && values[0] + values[1] == 42;
}

bool testBoost181Timer(std::string &detail)
{
    boost::timer::cpu_timer timer;
    const boost::timer::cpu_times elapsed = timer.elapsed();
    timer.stop();

    detail = "Timer reported non-negative wall, user, and system CPU time";
    return elapsed.wall >= 0 && elapsed.user >= 0 && elapsed.system >= 0;
}

bool testBoost181TypeErasure(std::string &detail)
{
    using Number = boost::type_erasure::any<boost::mpl::vector<
        boost::type_erasure::copy_constructible<>,
        boost::type_erasure::addable<>,
        boost::type_erasure::typeid_<>>>;
    Number left(19);
    Number right(23);
    Number sum = left + right;

    detail = "TypeErasure dynamically dispatched addition and preserved type";
    return boost::type_erasure::any_cast<int>(sum) == 42;
}

bool testBoost181Stacktrace(std::string &detail)
{
    const boost::stacktrace::stacktrace trace;

    detail = "Stacktrace basic backend captured at least one native frame";
    return !trace.empty();
}
#endif

#if BOOST_VERSION >= 108200
bool testBoost182Asio(std::string &detail)
{
    using namespace boost::asio::buffer_literals;
    const boost::asio::const_buffer literal = "Boost 1.82"_buf;
    const auto bytes = static_cast<const char *>(literal.data());

    detail = "Asio buffer literal preserved size and bytes";
    return literal.size() == 10 && std::string(bytes, literal.size()) ==
        "Boost 1.82";
}

bool testBoost182Core(std::string &detail)
{
    Boost182MemoryResource resource;
    void *allocation = resource.allocate(sizeof(int), alignof(int));
    resource.deallocate(allocation, sizeof(int), alignof(int));

    int values[] = {18, 24};
    boost::span<int> view(values);
    const int identity = boost::identity{}(view[0] + view[1]);

    detail = "Core memory_resource, data, size, identity, and span";
    return resource.allocations == 1 && resource.deallocations == 1 &&
        boost::data(values) == values && boost::size(values) == 2 &&
        identity == 42;
}

bool testBoost182Filesystem(std::string &detail)
{
    boost::filesystem::path parent("boost/1.82///");
    parent.remove_filename_and_trailing_separators();
    boost::filesystem::path replaced("boost/1.82/release.txt");
    replaced.replace_filename("device.txt");

    detail = "Filesystem v4 removal and replacement path semantics";
    return parent.generic_string() == "boost/1.82" &&
        replaced.generic_string() == "boost/1.82/device.txt";
}

bool testBoost182Json(std::string &detail)
{
    boost::json::value value = {{"release", 182}};
    value.set_at_pointer("/platform/name", "iOS");
    const std::size_t hash = boost::hash<boost::json::value>{}(value);

    const boost::json::value minimal = {{"version", 182}};
    const Boost181Release restored =
        boost::json::value_to<Boost181Release>(minimal);

    detail = "JSON set_at_pointer, hash, and missing optional conversion";
    return value.at_pointer("/platform/name") == "iOS" && hash != 0 &&
        restored.version == 182 && !restored.channel;
}

bool testBoost182Mysql(std::string &detail)
{
    const boost::mysql::date releaseDate(2023, 4, 14);
    boost::mysql::field number(182);
    boost::mysql::field text(std::string("offline"));
    const boost::mysql::blob bytes{0x01, 0x82};

    detail = "MySQL offline date, field, string, and blob value types";
    return releaseDate.valid() && releaseDate.year() == 2023 &&
        number.as_int64() == 182 && text.as_string() == "offline" &&
        bytes.size() == 2;
}

bool testBoost182Nowide(std::string &detail)
{
    const std::string utf8 = "Boost/\xC3\xA9t\xC3\xA9.txt";
    const std::wstring wide =
        boost::nowide::utf::convert_string<wchar_t>(utf8);
    const std::string restored =
        boost::nowide::utf::convert_string<char>(wide);
    std::ostringstream stream;
    stream << boost::nowide::quoted(boost::filesystem::path(utf8));

    detail = "Nowide convert_string and quoted UTF-8 filesystem path";
    return restored == utf8 && stream.str().find("\xC3\xA9t\xC3\xA9.txt") !=
        std::string::npos;
}

bool testBoost182Pfr(std::string &detail)
{
    Boost182PfrRecord record{182, 0};
    boost::pfr::get<int>(record) = 180;
    boost::pfr::get<short>(record) = 2;

    detail = "PFR reflection availability and get-by-type mutation";
    return BOOST_PFR_ENABLED &&
        boost::pfr::is_implicitly_reflectable_v<Boost182PfrRecord, void> &&
        boost::pfr::get<int>(record) + boost::pfr::get<short>(record) == 182;
}

bool testBoost182StaticString(std::string &detail)
{
    const boost::static_string<16> value("Boost 1.82");
    const std::string_view standardView = value;
    const boost::core::string_view coreView = value;

    detail = "StaticString std and Core string_view interoperability";
    return standardView == "Boost 1.82" && coreView == "Boost 1.82";
}

bool testBoost182Unordered(std::string &detail)
{
    boost::unordered_node_map<std::string, int, Boost182TransparentHash,
        Boost182TransparentEqual> releases;
    releases.emplace("current", 182);
    const auto found = releases.find(std::string_view("current"));

    boost::unordered_node_set<int> versions;
    versions.emplace(181);
    versions.emplace(182);

    detail = "Unordered node map/set and heterogeneous lookup";
    return found != releases.end() && found->second == 182 &&
        versions.contains(181) && versions.contains(182);
}

bool testBoost182Url(std::string &detail)
{
    boost::urls::url formatted =
        boost::urls::format("https://boost.org/{}/{}", "release", "C++ 20");
    formatted.set_params({{"version", "1.82"}, {"target", "iOS"}});
    const boost::core::string_view view = formatted;

    detail = "URL format encoding, set_params, and string_view conversion";
    return formatted.encoded_path() == "/release/C++%2020" &&
        formatted.encoded_query() == "version=1.82&target=iOS" &&
        !view.empty();
}

bool testBoost182StacktraceThread(std::string &detail)
{
    std::size_t frames = 0;
    boost::thread worker([&frames] {
        frames = boost::stacktrace::stacktrace().size();
    });
    worker.join();

    detail = "Stacktrace basic backend captured frames on a joined thread";
    return frames > 0;
}
#endif

} // namespace

namespace {

struct BoostTestCase {
    const char *name;
    bool (*test)(std::string &);
};

const std::vector<BoostTestCase> &boostTestCases()
{
    static const std::vector<BoostTestCase> tests{
        {"Packaged libraries", testPackagedLibraries},
        {"System + Chrono", testSystemAndChrono},
        {"DateTime", testDateTime},
        {"Random", testRandom},
        {"Thread + Atomic", testThreadAndAtomic},
        {"Signals", testSignals},
        {"Graph", testGraph},
        {"Locale", testLocale},
        {"Asio", testAsio},
#if BOOST_VERSION >= 106600
        {"Boost 1.66 headers", testBoost166Headers},
#endif
#if BOOST_VERSION >= 106700
        {"Boost 1.67 features", testBoost167Features},
#endif
#if BOOST_VERSION >= 106800
        {"Boost 1.68 features", testBoost168Features},
#endif
#if BOOST_VERSION >= 107000
        {"Boost 1.70 features", testBoost170Features},
#endif
#if BOOST_VERSION >= 107100
        {"Boost 1.71 features", testBoost171Features},
#endif
#if BOOST_VERSION >= 107200
        {"Boost 1.72 updates", testBoost172Updates},
#endif
#if BOOST_VERSION >= 107300
        {"Boost 1.73 features", testBoost173Features},
#endif
#if BOOST_VERSION >= 107400
        {"Boost 1.74 features", testBoost174Features},
#endif
#if BOOST_VERSION >= 107500
        {"Boost 1.75 features", testBoost175Features},
#endif
#if BOOST_VERSION >= 107600
        {"Boost 1.76 features", testBoost176Features},
#endif
#if BOOST_VERSION >= 107700
        {"Boost 1.77 features", testBoost177Features},
#endif
#if BOOST_VERSION >= 107800
        {"Boost 1.78 features", testBoost178Features},
#endif
#if BOOST_VERSION >= 107900
        {"Boost 1.79 features", testBoost179Features},
#endif
#if BOOST_VERSION >= 108000
        {"Boost 1.80 features", testBoost180Features},
        {"Boost 1.80 Atomic + C++20", testBoost180AtomicAndCpp20},
        {"Boost 1.80 System", testBoost180System},
        {"Boost 1.80 Unordered", testBoost180Unordered},
        {"Boost 1.80 LEAF", testBoost180Leaf},
        {"Boost 1.80 Math", testBoost180Math},
#endif
#if BOOST_VERSION >= 108100
        {"Boost 1.81 features", testBoost181Features},
        {"Boost 1.81 Log", testBoost181Log},
        {"Boost 1.81 Container", testBoost181Container},
        {"Boost 1.81 Timer", testBoost181Timer},
        {"Boost 1.81 TypeErasure", testBoost181TypeErasure},
        {"Boost 1.81 Stacktrace", testBoost181Stacktrace},
#endif
#if BOOST_VERSION >= 108200
        {"Boost 1.82 Asio", testBoost182Asio},
        {"Boost 1.82 Core", testBoost182Core},
        {"Boost 1.82 Filesystem", testBoost182Filesystem},
        {"Boost 1.82 JSON", testBoost182Json},
        {"Boost 1.82 MySQL offline", testBoost182Mysql},
        {"Boost 1.82 Nowide", testBoost182Nowide},
        {"Boost 1.82 PFR", testBoost182Pfr},
        {"Boost 1.82 StaticString", testBoost182StaticString},
        {"Boost 1.82 Unordered", testBoost182Unordered},
        {"Boost 1.82 URL", testBoost182Url},
        {"Boost 1.82 Stacktrace thread", testBoost182StacktraceThread},
#endif
#if BOOST_VERSION >= 106500
        {"Boost.Context", testContext},
        {"Boost.Coroutine2", testCoroutine2},
#endif
    };
    return tests;
}

} // namespace

std::string boostTestReportHeader()
{
    return std::string("Boost ") + BOOST_LIB_VERSION + "\n\n";
}

std::size_t boostTestCount()
{
    return boostTestCases().size();
}

BoostTestResult runBoostTestAtIndex(std::size_t index)
{
    if (index >= boostTestCases().size()) {
        return {false, "FAIL  Invalid test index\n      test index is out of range\n"};
    }

    const BoostTestCase &testCase = boostTestCases()[index];
    std::string detail;
    bool passed = false;
    try {
        passed = testCase.test(detail);
    } catch (const std::exception &error) {
        detail = error.what();
    } catch (...) {
        detail = "unknown exception";
    }

    std::ostringstream report;
    report << (passed ? "PASS" : "FAIL") << "  " << testCase.name
           << "\n      " << detail << "\n";
    return {passed, report.str()};
}

BoostTestResult runBoostTests()
{
    std::string report = boostTestReportHeader();
    bool passed = true;
    for (std::size_t index = 0; index < boostTestCount(); ++index) {
        const BoostTestResult result = runBoostTestAtIndex(index);
        passed = passed && result.passed;
        report += result.report;
    }
    report += std::string("\n") +
        (passed ? "ALL TESTS PASSED" : "TESTS FAILED");
    return {passed, report};
}
