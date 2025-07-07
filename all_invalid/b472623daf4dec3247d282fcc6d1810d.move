//# publish
module 0xCAFE::PatternTest {
    /// Struct to hold data for pattern tests
    struct Data has copy, drop, store {
        x: u8,
        y: u8,
        z: u8,
    }

    /// Runner function to execute pattern matching tests.
    public fun run() {
        let d = Data { x: 10, y: 20, z: 30 };
        // Destructure with rest pattern .. to ignore remaining fields after y
        let Data { x: a, y: b, .. } = d;
        // We don't use a and b, no assertions needed, just exercising pattern matching.
        
        // Tuple pattern matching with rest
        let tuple = (1u8, 2u8, 3u8, 4u8);
        let (w, ..) = tuple;
        
        // Nested struct with rest
        let nested = (Data { x:5, y:6, z:7 }, 100u8);
        let (Data { y: y_val, .. }, ..) = nested;
    }
}
//# run 0xCAFE::PatternTest::run


//# publish
module 0xCAFE::WhileLoopAssign {
    /// Runner function to exercise while loop with multiple assignments in condition block
    public fun run(): u64 {
        let mut i = 0u64;
        let mut sum = 0u64;
        let mut x = 10u64;

        while ({
            let old_i = i;
            let old_x = x;

            i = i + 1;
            x = x - 1;

            // multiple assignments done

            // Condition continues while i < 5 and x > 0
            i < 5 && x > 0
        }) {
            sum = sum + i + x;
        };

        // return the sum to check updates propagated outside loop
        sum
    }
}
//# run 0xCAFE::WhileLoopAssign::run --signers 0xCAFE


//# run
script {
    use 0xCAFE::PatternTest;
    use 0xCAFE::WhileLoopAssign;

    fun main() {
        // call PatternTest runner, will exercise pattern matching compiler features
        PatternTest::run();

        // call WhileLoopAssign runner and ignore result
        let _ = WhileLoopAssign::run();
    }
}

// Featurres:
// 171c22c0369c26a126b96ee734d1fedb: Write patterns with `..` (dot-dot) syntax to denote a wildcard or rest pattern in pattern matching
// 9260e563bdcf5d0627c86237bb5e361e: Test that while-loop conditions can contain and execute multiple assignment expressions via a block, and that these assignments correctly affect variables used in the loop and after it.
// 19b3347fb09813cc821a900427f665c5: Define a single main function as the entry point in a script, and ensure the script is omitted if this function is filtered out.
