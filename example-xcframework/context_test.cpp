// Minimal runtime exercise of Boost.Context's fcontext_t assembly trampoline.
// Verifies real stack switches (not just a function call): the child context
// runs on its own stack, resumes twice via jump_fcontext, and correctly
// round-trips data through the transfer_t on each switch.
#include <boost/context/detail/fcontext.hpp>
#include <boost/version.hpp>

#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <vector>

using boost::context::detail::fcontext_t;
using boost::context::detail::jump_fcontext;
using boost::context::detail::make_fcontext;

namespace {

struct ChildState {
    fcontext_t caller{};
    int visits = 0;
    // Large-ish stack-local buffer so a corrupted stack switch (wrong
    // stack pointer, wrong register save/restore) is likely to trash it.
    volatile std::uint64_t canary[64];
};

void child_entry(boost::context::detail::transfer_t transfer)
{
    auto *state = static_cast<ChildState *>(transfer.data);
    state->caller = transfer.fctx;

    for (std::size_t i = 0; i < 64; ++i) {
        state->canary[i] = 0xC0FFEE00ULL + i;
    }

    for (;;) {
        state->visits += 1;
        for (std::size_t i = 0; i < 64; ++i) {
            if (state->canary[i] != 0xC0FFEE00ULL + i) {
                std::abort();  // stack corruption across a context switch
            }
        }
        transfer = jump_fcontext(state->caller, state);
        state->caller = transfer.fctx;
    }
}

}  // namespace

int main()
{
    const std::size_t stack_size = 64 * 1024;
    std::vector<unsigned char> stack(stack_size);

    ChildState state;
    fcontext_t child =
        make_fcontext(stack.data() + stack_size, stack_size, child_entry);

    auto transfer = jump_fcontext(child, &state);
    child = transfer.fctx;
    if (state.visits != 1) {
        std::cerr << "expected 1 visit after first jump, got " << state.visits
                   << "\n";
        return 1;
    }

    transfer = jump_fcontext(child, &state);
    child = transfer.fctx;
    if (state.visits != 2) {
        std::cerr << "expected 2 visits after second jump, got "
                   << state.visits << "\n";
        return 2;
    }

    std::cout << "Boost " << BOOST_LIB_VERSION
               << " Boost.Context fcontext_t round-tripped " << state.visits
               << " stack switches successfully\n";
    return 0;
}
