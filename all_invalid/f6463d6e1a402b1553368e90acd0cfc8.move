
//# publish
module 0xDEAD::ASTSimplifyTest {
    // You never use this module directly in the test commands
    // It is just to contain the structs and functions

    // Enabling testing of AST simplification: Remove code that can be eliminated
    // The code below will include functions, enum variants, and dead code to be simplified or eliminated

    struct DummyStruct has copy, drop, store {
        value: u64,
        flag: bool,
    }

    enum MultiVariantEnum has copy, drop {
        VariantOne,
        VariantTwo(u32, u32),
        VariantThree { data: bool },
    }

    // Function that is designed to test the dead function and code elimination
    public fun test_dead(x: u64): u64 {
        // A dead code branch that should be eliminated
        if (false) {
            // This code should be removed
            let _temp = x + 1;
        };
        // The original purpose is to test the dead function
        dead(x)
    }

    // An intentionally dead code function (not called) to test code elimination
    fun unused_function(): u64 {
        let _ = 123u64;
        999u64
    }

    // Function that returns an enum with multiple variants
    public fun use_enum(flag: bool): MultiVariantEnum {
        if (flag) {
            MultiVariantEnum::VariantOne
        } else {
            MultiVariantEnum::VariantTwo(10, 20)
        }
    }

    public fun use_enum2() {
        let e1 = use_enum(true);
        let e2 = use_enum(false);
        // do nothing, just use the enums
        let _ = e1;
        let _ = e2;
    }

    // Function that calls the dead function, which should be simplified away
    public fun call_dead_with_value(val: u64): u64 {
        dead(val)
    }
}


//# run 0xDEAD::ASTSimplifyTest::test_dead --args 42u64


//# run 0xDEAD::ASTSimplifyTest::use_enum --args true


//# run 0xDEAD::ASTSimplifyTest::use_enum --args false


//# run 0xDEAD::ASTSimplifyTest::use_enum2


//# run 0xDEAD::ASTSimplifyTest::call_dead_with_value --args 100u64


// Featurres:
// 407795779da1e58cabdb55f16af6ad6b: Enable full AST simplification with code elimination when the 'AST_SIMPLIFY_FULL' experiment is active.
// d2cd6e3f5b4592a19300d2d81b91cea1: Test that the Move function `dead` correctly returns the input value without performing any side effects or modifications.
// eec4b5db199960ba48877cef2c2f302e: Declare enums with multiple variants.
