
//# publish
module 0xCAFE::ControlFlowTest {
    use std::vector;

    // Define a specification function to test full function signatures
    spec fun spec_fun1(x: u8, y: bool): u8;

    // Define a helper function with control flow to analyze successor blocks
    public fun analyze_control_flow(flag: bool): u8 {
        if (flag) {
            let a = 1;
            a
        } else {
            let b = 2;
            b
        }
    }

    // Define a function with nested control flow
    public fun nested_control_flow(x: u8): u8 {
        if (x > 0) {
            if (x < 10) {
                10
            } else {
                20
            }
        } else {
            0
        }
    }

    // Using spec fun with full signature, including traits
    spec fun spec_fun2<T>(val: T): T;

    // Function with match statement and control flow
    public fun match_control(value: u64): u64 {
        // Correct syntax for match blocks: no '=>' and proper indentation
        match (value) {
            0 => 100,
            1 => 200,
            v => v + 300,
        }
    }

    // Friend declaration to ensure it terminates with semicolon
    friend trait Owner;

    // A dummy trait with friend declaration to test syntax
    trait Owner has key {
        // no functions needed
    }
}



//# run 0xCAFE::ControlFlowTest::analyze_control_flow --args true

//# run 0xCAFE::ControlFlowTest::analyze_control_flow --args false

//# run 0xCAFE::ControlFlowTest::nested_control_flow --args 5u8

//# run 0xCAFE::ControlFlowTest::match_control --args 0u64

//# run 0xCAFE::ControlFlowTest::match_control --args 1u64

//# run 0xCAFE::ControlFlowTest::match_control --args 42u64