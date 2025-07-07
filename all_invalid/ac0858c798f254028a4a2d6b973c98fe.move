// transactional_test.move

// This file contains transactional test cases targeting the Move compiler and VM,
// focusing on diagnostics for duplicate fields and abilities, and macro call parsing.

// The following test suite verifies:
// 1) Duplicate fields error reporting with accurate spans and messages.
// 2) Duplicate abilities error diagnostics.
// 3) Correct parsing of macro calls (name! and argument list in parentheses).

module 0x1::TransactionalTest {

    use std::debug;

    /// Struct with duplicate fields to trigger a diagnostic.
    /// The compiler should detect "foo" is declared twice.
    struct DuplicateFieldsExample has copy, drop {
        foo: u64,
        bar: u64,
        foo: u8,  // <-- duplicate field
    }

    /// Struct with duplicate abilities to trigger a diagnostic.
    /// Move structs have abilities declared in the `has` clause.
    struct DuplicateAbilitiesExample has copy, drop, key, copy {
        value: u64,
    }

    /// A dummy macro for testing parsing of macro calls.
    /// Note: Move currently does not natively support user-defined macros;
    /// this test assumes the Move compiler is extended to recognize macro calls
    /// of the form `name! (...)`.
    /// To simulate compilation: the macro expands to a constant u64 value.

    public fun dummy_macro_impl(_arg: u64): u64 {
        // In a real macro expansion scenario, this might be replaced by the macro expander.
        42
    }

    /// Emulating a macro call parser test.
    /// Here, "dummy_macro!" is followed by parentheses with argument.
    fun test_macro_call() {
        // Macro call with parentheses
        let a = dummy_macro!(10);
        debug::print(&a);
        // Macro call as a call expression style (if supported)
        let b = dummy_macro!(20);
        debug::print(&b);
    }

    /// Entry transaction script to run all tests
    public entry fun run_all_tests() {
        // Attempting to instantiate DuplicateFieldsExample should cause a compile error.
        // let _x = DuplicateFieldsExample { foo: 1, bar: 2, foo: 3 };

        // Attempting to instantiate DuplicateAbilitiesExample should cause a compile error.
        // let _y = DuplicateAbilitiesExample { value: 10 };

        // The macro call test; this should compile and print 42 twice.
        test_macro_call();
    }
}

// Featurres:
// e18360c3589143dfbf63f7f10456469e: Report a diagnostic error when duplicate fields are detected, including their locations and relevant messages.
// 4188bf253a6c091c0c1a987d4bcad65e: Add diagnostics to indicate where duplicate abilities are found to the compiler environment.
// a41ec282b293eaafccf1998093f292df: Create macro calls by following a name with an exclamation mark '!' and call arguments in parentheses or as a call expression.
