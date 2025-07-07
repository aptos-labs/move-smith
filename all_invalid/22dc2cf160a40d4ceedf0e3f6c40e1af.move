
//# publish
module 0xCAFE::OptimizationTest {
    use std::signer;

    struct Data has store, key {
        a: u64,
        b: u8,
    }

    // Function with diverse argument types and multiple params
    public fun complex_function(x: u8, y: u64, addr: address, d: Data): (u64, u8) {
        let sum = x as u64 + y + d.a;
        let res_b = d.b + x;

        // For loop with non-ascending range: 10..4 will not execute loop body
        let loop_count = 0u8;
        for i in 10..4 {
            let _unused = i;
            loop_count = loop_count + 1; // Should never execute
        };

        // Using loop_count to prevent removal of variable
        assert!(loop_count == 0, 999);

        // Return sum and result byte for type checking
        (sum, res_b)
    }

    // Runner that calls complex_function with fixed args
    public fun runner(addr: address): (u64, u8) {
        let data = Data {a: 100u64, b: 10u8};
        complex_function(5u8, 15u64, addr, data)
    }

    // Another runner calling complex_function with different args to test multiple arg variants
    public fun runner2(): (u64, u8) {
        let data = Data {a: 0u64, b: 0u8};
        complex_function(0u8, 0u64, @0xCAFE, data)
    }
}


//# run 0xCAFE::OptimizationTest::runner --args @0xBEEF


//# run 0xCAFE::OptimizationTest::runner2


//# run 0xCAFE::OptimizationTest::complex_function --args 5u8 15u64 @0xBEEF 0xCAFE::OptimizationTest::Data { a: 100u64, b: 10u8 }


// Featurres:
// 28277c32ad3fb6b073e3e1ad62644152: Perform stackless bytecode optimization passes in a configurable pipeline.
// 7bb9082a67b154184ac0d6085e615799: Implement functions with multiple argument types and perform type checking on their return types.
// aebedc6b7752fe634f3b20175f8bd8b9: Verify that a for loop with a range where the start is greater than the end (e.g., 10..4) does not execute its body.
