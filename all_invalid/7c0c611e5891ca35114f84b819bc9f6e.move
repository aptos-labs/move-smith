//# publish
module 0xCAFE::LoopTest {
    /// A resource to store a value
    struct Counter has copy, drop, store {
        value: u64,
    }

    /// Initializes a Counter with 0
    public fun init(): Counter {
        Counter { value: 0 }
    }

    /// Increments counter.value by 1 until it reaches 5, then break out of the loop
    public fun run_loop(counter: &mut Counter) {
        let mut i = 0u64;
        while (true) {
            if (i == 5) {
                break;
            };
            counter.value = i;
            i = i + 1;
        };
        // After break, counter.value should be 4
        // (Since last value assigned is 4 before i reached 5 and broke loop)
    }

    /// A runner function with no args that creates a Counter, runs the loop and returns the counter.value
    public fun runner(): u64 {
        let mut c = init();
        run_loop(&mut c);
        c.value
    }
}
//# run 0xCAFE::LoopTest::runner

//# publish
module 0xCAFE::TokenTest {
    /// Function using various specific Move tokens and constructs
    public fun complex_syntax(v: u64): u64 {
        let r = if (v > 10) {
            (v * 2 + 1) % 7 // arithmetic and modulo
        } else {
            (v / 2) & 0xFF // integer division and bitwise AND
        };
        let b = match v {
            0 => 100,
            1 => 200,
            _ => r,
        };
        // Tuple construction and destructuring
        let tup: (u64, bool) = (b, v > 5);
        let (num, flag) = tup;
        // Move allows returning tuple or single value; here just num + (flag as u64)
        num + (flag as u64)
    }

    /// Runner function to test complex syntax with a fixed input
    public fun runner(): u64 {
        complex_syntax(15)
    }
}
//# run 0xCAFE::TokenTest::runner


//# run
script {
    use 0xCAFE::LoopTest;
    use 0xCAFE::TokenTest;

    fun main() {
        // Test LoopTest runner: expect 4
        let loop_result = LoopTest::runner();
        // Test TokenTest runner (input 15): calculation: since 15 > 10
        // r = (15*2+1)%7 = (31)%7 = 3
        // match _ => r = 3
        // tup = (3, true), so return 3+1 = 4
        let token_result = TokenTest::runner();

        // No assertions required, just execute to test VM and compiler
        let _ = loop_result;
        let _ = token_result;
    }
}

// Featurres:
// 6a45edc659ba2c70bfdd0e0e0016f26f: Test that a while loop with a break statement correctly exits when the condition is met and that variables updated in the loop retain their values after the loop.
// e9b82231f5622596a9761b21cb5fbf98: Verify that a compiled Move module passes bytecode verification successfully.
// cf89a2eacbbcaa727a6145ff30969ae7: Write code that uses specific Move syntax tokens, which can be parsed and recognized by the compiler.
