//    This module defines functions with nested loops and pattern matching,
//    and updates counters to verify correct execution after multiple iterations.

//# publish
module 0xC0DE::ComplexInteraction {
    use std::vector;

    // Struct with nested fields
    struct CounterHolder has store {
        count: u64,
        nested: NestedData,
    }

    struct NestedData has store {
        inner_counter: u64,
        flag: bool,
    }

    // Function with nested loops updating counters
    public fun nested_loops(counts: u64): CounterHolder {
        let counter = CounterHolder {
            count: 0,
            nested: NestedData {
                inner_counter: 0,
                flag: false,
            },
        };
        let i = 0;
        while(i < counts) {
            let j = 0;
            while(j < counts) {
                // Increment counters inside nested loops
                counter.count = counter.count + 1;
                counter.nested.inner_counter = counter.nested.inner_counter + 2;
                j = j + 1;
            };
            i = i + 1;
        };
        // Return the final state of counters
        counter
    }
}



//# run 0xC0DE::ComplexInteraction::nested_loops --args 100u64



//# run
script {
    fun run_infinite_loop_with_early_return() {
        let i = 0;
        loop {
            if (i == 5) {
                break;
            };
            // This assertion should never run when i < 5
            assert!(i < 10, 999);
            // Early break inside loop
            if (i == 3) {
                break;
            };
            i = i + 1;
        };
        // Code after loop should run only if early break occurs
        // Verify that i is 3 at this point
        assert!(i == 3, 999);
    }
}


//# run run_infinite_loop_with_early_return


//             For example, access nested struct fields within loops and pattern match to bind multiple variables.

//# publish
module 0xC0DE::NestedAccess {
    struct OuterStruct has store {
        inner: InnerStruct,
        value: u8,
    }

    struct InnerStruct has store {
        data: u16,
        flag: bool,
    }

    // Function to create nested data
    public fun create_nested(): OuterStruct {
        OuterStruct {
            inner: InnerStruct {
                data: 42,
                flag: true,
            },
            value: 255,
        }
    }

    public fun access_nested_fields() {
        let outer = create_nested();

        // Access nested fields via dotted expression and pattern match
        let OuterStruct { inner: InnerStruct { data: d, flag: fl }, value: v } = outer;

        // Use the values in some way (just a dummy usage)
        let sum = d + v as u16;
        if (fl) {
            // do nothing
        };
        sum
    }
}


//# run 0xC0DE::NestedAccess::access_nested_fields



//# run
script {
    fun pattern_match_demo() {
        // Sample data with nested pattern
        let data = (Some(5u64), 10u8, (true, "hello"));
        // Destructuring tuple with nested patterns
        let (option_val, val_u8, (bool_val, msg)) = data;
        // Use these variables to verify pattern matching correctness
        assert!(option_val.is_some(), 999);
        let inner_val = match option_val {
            Some(a) => a,
            None => 0,
        };
        // Further processing
        let total = inner_val + val_u8 as u64;
        if (bool_val) {
            assert!(msg == "hello", 999);
        };
        total
    }
}


//# run 0xC0DE::pattern_match_demo


// Featurres:
// 8ec3435bf1358828adc414949546d591: Use the compiler's run function to process a Move program through multiple compiler passes until reaching a specified pass stage.
// 2eccb8c408c0d24e4020ef8cdbb150e1: Verify that nested loops correctly increment a counter and that the final value matches the expected total after repeated iterations.
// 7960ce7ec9415e18675fd9fadb6188e9: Test that a script with an infinite loop containing an early return does not execute code after the loop, such as an assertion, ensuring the move semantics correctly handle early returns within loops.
// c5a0e463f1983df8bb16c9517e4ffa41: Declare named modules using identifiers
// 50e8a6b48f3650f54f5f59d1c3132663: Access dotted expressions like struct fields or nested expressions with `exp_dotted`.
// 723a0b4cfe42d5e895bbeb4c8f8bd1f9: Bind multiple typed variables simultaneously in pattern matching statements.
