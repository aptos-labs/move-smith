
//# publish
module 0xCAFE::UnconditionalJumpTest {
    enum SimpleEnum has copy, drop {
        A,
        B(u8),
        C { val: u8 }
    }

    public fun create_a(): SimpleEnum {
        SimpleEnum::A
    }

    public fun create_b(x: u8): SimpleEnum {
        SimpleEnum::B(x)
    }

    public fun create_c(x: u8): SimpleEnum {
        SimpleEnum::C { val: x }
    }

    public fun match_and_jump(e: SimpleEnum): u8 {
        // Using match with wildcard and variant names only in patterns
        let result = match (e) {
            SimpleEnum::A => {
                // unconditional jump simulation by returning early
                10
            },
            SimpleEnum::B(x) => {
                if (x == 0) {
                    0
                } else {
                    1
                }
            },
            SimpleEnum::C { val } => {
                val
            },
            * => {
                // wildcard catch-all pattern (though in this enum all variants are covered - just for test)
                99
            }
        };
        result
    }

    public fun jump_with_loop(x: u8): u8 {
        let i = x;
        loop {
            if (i == 0) {
                break;
            };
            i = i - 1;
        };
        // Return after loop (unconditional jump happens at bytecode level for break)
        i
    }

    public fun use_wildcard_unpack(): u8 {
        // destructure a tuple with wildcard pattern
        let (a, *) = (5u8, 100u8);
        a
    }

    public fun use_wildcard_variant(a: u8): u8 {
        let e = SimpleEnum::B(a);
        let val = match (e) {
            SimpleEnum::B(x) => x,
            * => 42,
        };
        val
    }
}



//# run 0xCAFE::UnconditionalJumpTest::create_a



//# run 0xCAFE::UnconditionalJumpTest::create_b --args 42u8



//# run 0xCAFE::UnconditionalJumpTest::create_c --args 7u8



//# run 0xCAFE::UnconditionalJumpTest::match_and_jump --args A



//# run 0xCAFE::UnconditionalJumpTest::match_and_jump --args B(0u8)



//# run 0xCAFE::UnconditionalJumpTest::match_and_jump --args B(9u8)



//# run 0xCAFE::UnconditionalJumpTest::match_and_jump --args C { val: 15u8 }



//# run 0xCAFE::UnconditionalJumpTest::jump_with_loop --args 5u8



//# run 0xCAFE::UnconditionalJumpTest::use_wildcard_unpack



//# run 0xCAFE::UnconditionalJumpTest::use_wildcard_variant --args 123u8


// Features:
// 1c2b6379278115578e2da51b66bb5901: Write Move bytecode sequences that end with an unconditional jump instruction
// 9b8f665dbc9945450e25d345bd7379ba: Use variant names only in contexts where they are expected, such as inside match expressions or when constructing enum values
// e722edc0fc481db3207c966e6c9a7628: Use wildcard pattern ('*') where allowed, for example in pattern matching or unpacking.
