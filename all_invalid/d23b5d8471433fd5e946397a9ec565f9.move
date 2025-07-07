// #publish
module 0xCAFE::LoopBreakTest {
    /// Test that `loop` immediately followed by `break` is parsed and handled correctly.
    public fun loop_break_runner() {
        let mut i = 0;
        loop {
            break;
            i = i + 1;
        }
        // No assertions needed, just ensure no infinite loop.
    }
}
// #run 0xCAFE::LoopBreakTest::loop_break_runner --signers 0xCAFE

// #publish
module 0xCAFE::FriendPragmaTest {
    // `friend` is a keyword, but here used as a pragma name (string). Let's define a friend pragma function.
    // Although pragmas  `friend` keyword is special, here we just test parsing it through pragmas.
    // The pragma syntax with 'friend' does not affect compilation negatively.
    #[friend]
    public fun friend_pragma_function() {
        // empty on purpose for compilation testing.
    }

    public fun runner() {
        friend_pragma_function();
    }
}
// #run 0xCAFE::FriendPragmaTest::runner --signers 0xCAFE


// #publish
module 0xCAFE::InlineNestTest {
    // Test nested inline functions and their optimization

    #[inline]
    fun inner1(x: u64): u64 {
        x + 1
    }

    #[inline]
    fun inner2(y: u64): u64 {
        inner1(y) * 2
    }

    #[inline]
    public fun outer(z: u64): u64 {
        // Nested calls: outer calls inner2, which calls inner1
        inner2(z) + inner1(z)
    }

    public fun runner() {
        let res = outer(10);
        // No assertion, just call to test inline nesting and compilation.
        res;
    }
}
// #run 0xCAFE::InlineNestTest::runner --signers 0xCAFE


// #run 0xCAFE::LoopBreakTest::loop_break_runner --signers 0xCAFE
// #run 0xCAFE::FriendPragmaTest::runner --signers 0xCAFE
// #run 0xCAFE::InlineNestTest::runner --signers 0xCAFE

// #run
script {
    use 0xCAFE::LoopBreakTest;
    use 0xCAFE::FriendPragmaTest;
    use 0xCAFE::InlineNestTest;

    fun main() {
        LoopBreakTest::loop_break_runner();
        FriendPragmaTest::runner();
        InlineNestTest::runner();
    }
}

// Featurres:
// 62241665497edacd4b34bf3a1477ce1b: Test that the Move language correctly parses and handles a `loop` statement immediately followed by a `break`.
// 3d4de455fbf6f87677a9c22a23f67039: Use the special 'friend' property in pragmas even though 'friend' is a keyword.
// 38e37684cc05893eff842609257c711e: Test that two inlined function calls can be nested and optimized correctly when invoked from another inline function.
