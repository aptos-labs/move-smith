//# publish
module 0xCAFE::IfElseVars {
    use std::vector;

    public fun test_if_else_vars(y: bool): u8 {
        let x = 0u8;
        let val = if (y) {
            let a = 10u8;
            a
        } else {
            let b = 20u8;
            b
        };
        let sum = x + val;
        sum
    }
}

//# run 0xCAFE::IfElseVars::test_if_else_vars --args true

//# run 0xCAFE::IfElseVars::test_if_else_vars --args false

//# publish
module 0xCAFE::DiagnosticsTest {
    use std::debug;

    public fun output_diagnostics() {
        debug::print(b"Diagnostic test: Displaying compiler diagnostics with source code context\n");
    }
}

//# run 0xCAFE::DiagnosticsTest::output_diagnostics

//# publish
module 0xCAFE::VectorMutIter {
    use std::vector;

    public fun mutate_vector_with_while(v: &mut vector<u8>, value: u8) {
        let len = vector::length(v);
        let mut idx = 0;
        while (idx < len) {
            *vector::borrow_mut(v, idx) = value;
            idx = idx + 1;
        };
    }

    public fun run_mutate_vector() {
        let mut v = vector::empty<u8>();
        vector::push_back(&mut v, 1);
        vector::push_back(&mut v, 2);
        vector::push_back(&mut v, 3);

        mutate_vector_with_while(&mut v, 42u8);
    }
}

//# run 0xCAFE::VectorMutIter::run_mutate_vector

// Featurres:
// 3cfd637587f89cbe0679fe4f37d64568: Test that variables initialized within both branches of an if-else statement are properly recognized and can be used after the conditional.
// 75ee3fa84956c120f08c2d91e03731db: Call `output_diagnostics` to display compiler diagnostics with source code context.
// 00117828bd5bbf4ac93e513072037541: Test that mutably iterating over a vector using a while loop updates each element to a specified value.
