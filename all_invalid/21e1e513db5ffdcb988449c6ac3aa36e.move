
//# publish
module 0xCAFE::PragmaTest {
    // Test module to use pragma values as identifiers
    const b_break: u8 = 42;
    const l_loop: u8 = 7;

    public fun get_break(): u8 {
        b_break
    }

    public fun get_loop(): u8 {
        l_loop
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
    use std::debug;
    use std::vector;

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
