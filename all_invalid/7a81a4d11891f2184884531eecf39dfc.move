
//# publish
module 0xCAFE::LoopAndAttributes {
    use std::vector;

    // Define attribute-like structs for module annotations
    struct Attribute1 has copy, drop, store {}
    struct Attribute2 has copy, drop, store {}

    // Attach attributes to module by including a special comment or metadata
    // (In Move, attributes are not directly supported, but for test, simulate via comment)
    // // Attribute1]
    // // Attribute2]
    // We simulate attributes by defining attributes as structs and documenting.

    // Define a dummy attribute attachment via comments for testing attribute aggregation
    // (In actual Move, this might be via custom loader or annotations)

    // Function to test while loop and break
    public fun test_while_loop(limit: u64): u64 {
        let counter = 0;
        while (counter < limit) {
            counter = counter + 1;
        };
        counter
    }

    // Function to test loop expression (break with value)
    public fun test_loop_with_break(target: u64): u64 {
        let result = loop {
            let x = 0;
            if (target == 0) {
                break 42u64;
            };
            // simulate some work
            break target * 2;
        };
        result
    }

    // Source location span simulation: define a function with span info as comment
    // to check source span info propagation
    // e.g., span: (line 1, col 0) to (line 15, col 20)
    // For the purpose of this test, just define a function with comment.
    // In real test framework, source span info is captured by the parser.

    public fun source_span_test(): u8 {
        // span: (line 21, col 0) to (line 25, col 10)
        let value = 5u8;
        value
    }
}


//# run 0xCAFE::LoopAndAttributes::test_while_loop --args 10u64

//# run 0xCAFE::LoopAndAttributes::test_loop_with_break --args 0u64

//# run 0xCAFE::LoopAndAttributes::source_span_test

// Featurres:
// 9369e9d76834837f0b510cb847679e36: Create loops using 'while' and 'loop' expressions
// a4e33a282cae3cdb894d91b180870d57: Add attributes to modules via spec modules and have those attributes appear on the merged module.
// 38fa6b6e52f19006f26511efa2fb037a: Create a spanned value with location information for source code tracking.
