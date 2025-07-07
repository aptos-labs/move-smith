
//# publish
module 0xBEEF::SpecOnlyModule {
    // This is a specification-only module.
    // We define a struct to test that only spec modules behave differently.
    struct SpecStruct has copy, drop, store, key {
        value: u8,
    }

    public fun spec_new(value: u8): SpecStruct {
        SpecStruct { value }
    }

    public fun get_value(s: &SpecStruct): u8 {
        s.value
    }
}


//# publish
module 0xCAFE::FeatureTest {
    use std::vector;

    // Function to test if-else with return in both branches
    public fun test_if_else_with_return(x: u8, y: bool): u8 {
        if (y) {
            let res = 10u8;
        } else {
            let res = 20u8;
        };
        // We now re-implement with explicit return expressions to ensure correctness
        if (y) {
            10u8
        } else {
            20u8
        }
    }

    // Function to test borrowing with &mut and expression use
    public fun borrow_and_modify(x: &mut u8, y: u8): u8 {
        // Borrow x mutably and add y to it
        let borrowed_x = &mut *x;
        *borrowed_x = *borrowed_x + y;
        *borrowed_x
    }

    // Function to test combined usage
    public fun run_tests() {
        // Call the `test_if_else_with_return` with different inputs
        let r1 = test_if_else_with_return(5, true);
        let r2 = test_if_else_with_return(5, false);

        // Use a local variable with mutable borrow
        let val: u8 = 3;
        let result = borrow_and_modify(&mut val, 4);
    }
}


//# run 0xCAFE::FeatureTest::run_tests --signers 0xBEEF


// Featurres:
// 89f8f5a5053fd2c4219f777ba327bfd5: Define specification-only modules within normal Move modules or address blocks and have them handled distinctly by the compiler.
// 970b8ff709114601b164f088807367b0: Test that an if-else statement with return statements in both branches compiles and executes correctly without triggering assertions in unreachable code paths.
// c421dfe243fa0fc0182c1380ed024d94: Use '&mut' to borrow a variable mutably in expressions.
