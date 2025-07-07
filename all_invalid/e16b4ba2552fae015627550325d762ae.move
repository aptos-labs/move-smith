
//# publish
module 0xCAFE::PragmaTest {
    // Test module to use pragma values as identifiers
    const B_BREAK: u8 = 42;
    const L_LOOP: u8 = 7;

    public fun get_break(): u8 {
        B_BREAK
    }

    public fun get_loop(): u8 {
        L_LOOP
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
    use AptosFramework::debug;
    use AptosFramework::vector;

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
