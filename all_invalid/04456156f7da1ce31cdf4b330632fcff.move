
//# publish
module 0xDEAF::TestInteractions {
    use std::vector;
    use std::signer;
    use std::debug;

    // A singleton struct with named fields
    struct NamedStruct has copy, drop, store {
        a: u8,
        b: u16,
    }

    // A singleton struct with positional fields
    struct PosStruct has copy, drop, store (u32, bool);

    // A generic struct with interaction
    struct Wrapper<T> has copy, drop, store {
        value: T
    }

    // Inline function that calls other inline functions
    public inline fun inline_add(a: u16, b: u16): u16 {
        a + b
    }

    // Inline function with nested calls
    public inline fun inline_process(x: u8): u8 {
        let y = inline_add(x as u16, 10u16) as u8;
        y * 2
    }

    // Function to intentionally abort multiple times, then continue
    public fun abort_then_continue(flag: bool): u32 {
        if (flag) {
            abort 999;
        }
        // Should not reach here if flag is true
        // Next abort
        abort 888;
        // Final part, should never execute if aborts trigger
        42u32
    }

    // Function used to test abort handling and actual flow continuation
    public fun test_abort_flow(flag: bool): u32 {
        let res = abort_then_continue(flag);
        res
    }

    // Function with expected failure attribute (testing compiler diagnostics)
    // test_only]
    public fun invalid_function(): () {
        // Intentionally invalid: no code here but marked as test-only
    }

    // Function that calls inline functions to check inlining correctness
    public fun call_inlined_functions(): u16 {
        let x = inline_add(5u16, 10u16);
        let y = inline_process(3u8);
        x + y
    }

    // Function testing complex integer literals and quantifiers
    public fun integer_literals_and_quantifiers(): bool {
        // Use of large literals
        let a = 100u16;
        let b = 1000u32;
        // Trigger list with multiple expressions
        let triggers = { [|a > 50, b < 2000|] };
        // Check trigger conditions
        triggers[0][0] && triggers[0][1]
    }

    // Function creating singleton structs and accessing fields
    public fun singleton_structs(): (u8, u16, u32, bool) {
        let named = NamedStruct { a: 1u8, b: 256u16 };
        let pos = PosStruct(12345u32, true);
        // Access fields
        let a_field = named.a;
        let b_field = named.b;
        let c_field = pos.0;
        let d_field = pos.1;
        (a_field, b_field, c_field, d_field)
    }

    // Function to test trigger expressions with quantifiers
    public fun trigger_with_quantifiers(): bool {
        let triggers = {
            [| 
                (1u8 > 0u8),
                (2u16 < 100u16),
                (3u32 == 3u32),
                { true, false }[0]
            |]
        };
        triggers[0][0] && triggers[0][1] && triggers[0][2] && triggers[0][3]
    }

    // Function that creates and uses a generic wrapper
    public fun wrap_value<T: copy + drop>(val: T): Wrapper<T> {
        Wrapper { value: val }
    }

    // Function calling the wrapper creation
    public fun test_wrapper(): u64 {
        let wrapped = wrap_value(12345678u64);
        // Access the wrapped value
        wrapped.value
    }
}


//# run 0xDEAF::TestInteractions::test_abort_flow --args false

//# run 0xDEAF::TestInteractions::test_abort_flow --args true

//# run 0xDEAF::TestInteractions::call_inlined_functions

//# run 0xDEAF::TestInteractions::integer_literals_and_quantifiers

//# run 0xDEAF::TestInteractions::singleton_structs

//# run 0xDEAF::TestInteractions::trigger_with_quantifiers

//# run 0xDEAF::TestInteractions::test_wrapper


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 1630878bb07f0e61d64057399656ba48: Test that the Move function correctly handles multiple aborts and continues execution to produce the expected final result.
// 42b25b93e4183728f064e19bece2cde4: Annotate code with expected failure attributes that do not take any parameters or assigned values.
// 1011b8aa32f48fef72a832a6a7a35814: Write Move code that is statically checked for bytecode-level correctness before execution
// 11a4d1fe9892131da3fe1e15c5bf28ca: Write code that calls inline functions and benefit from having those callees' bodies inlined into the caller.
// bff4c6af54c2d2738806ea3bb71098dd: Use integer literals with suffixes for u8, u16, u32, u64, u128, and u256 types in Move code.
// a6e3be8a5a53e05a06faffbeca8e166f: Specify triggers for quantifiers, possibly including a list of trigger expressions enclosed in braces.
// 562d1893fa863035ca81251d4b4ccf8f: Define structs with a single set of fields (singleton structs), optionally positional.
