
//# publish
module 0xCAFE::PragmaTest {
    // Test module to use pragma values as identifiers
    const break: u8 = 42;
    const loop: u8 = 7;

    public fun get_break(): u8 {
        break
    }

    public fun get_loop(): u8 {
        loop
    }
}


//# publish
module 0xCAFE::EarlyReturn {
    // Function that returns early if input is zero
    public fun conditional_return(x: u8): u8 {
        if (x == 0) {
            return 100u8;
        };
        x * 2
    }
}


//# publish
module 0xCAFE::BreakLoopTest {
    use aptos_framework::debug;

    // Function that loops but breaks immediately
    public fun test_break_loop() {
        let i = 0u8;
        loop {
            break;
            // The following assertion should never be executed
            debug::print(&vector::empty<u8>());
            i = i + 1;
            assert!(false, 9999);
        };
    }
}


//# run 0xCAFE::PragmaTest::get_break


//# run 0xCAFE::PragmaTest::get_loop


//# run 0xCAFE::EarlyReturn::conditional_return --args 0u8


//# run 0xCAFE::EarlyReturn::conditional_return --args 10u8


//# run 0xCAFE::BreakLoopTest::test_break_loop


// Featurres:
// 40386585b505f1be911d5d00db89f09e: Test that the script terminates immediately when encountering a 'break' statement inside a loop without executing any assertions.
// ae83749d0886920342fdea6bdc4ba15f: Use pragma values that are identifiers in your Move code.
// 2b6aca4d6028953398d725597776c5b9: Test that a function with a conditional early return executes the return statement and produces the expected result.
