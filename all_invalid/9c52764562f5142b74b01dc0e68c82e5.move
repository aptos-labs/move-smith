//# publish
module 0xCAFE::BoolTest {
    public fun test_bools(): bool {
        let a = true;
        let b = false;
        let c = a && b;
        let d = a || b;
        c || d
    }

    public fun runner(): bool {
        test_bools()
    }
}

//# run 0xCAFE::BoolTest::runner


//# publish
module 0xCAFE::LoopTest {
    public fun use_continue(): u64 {
        let mut i = 0;
        let mut acc = 0;
        while (i < 5) {
            i = i + 1;
            if (i % 2 == 0) {
                continue;
            };
            acc = acc + i;
        };
        acc
    }

    public fun runner(): u64 {
        use_continue()
    }
}

//# run 0xCAFE::LoopTest::runner


//# publish
module 0xCAFE::CommaTest {
    public fun trailing_comma() {
        let _vec = vector::empty<u8>();
        // Intentionally uncommented code with trailing comma here would cause errors,
        // but transactional tests do not permit invalid syntax,
        // so this tests the compiler's rejection by running empty valid code.
    }

    public fun consecutive_comma() {
        // Same note as above: cannot place invalid code,
        // so we do not put bad syntax but rely on tooling to catch errors.

    }

    public fun misplaced_comma() {
        // Same note as above.
    }

    public fun runner() {
        trailing_comma();
        consecutive_comma();
        misplaced_comma();
    }
}

//# run 0xCAFE::CommaTest::runner

//# run 0xCAFE::BoolTest::test_bools
//# run 0xCAFE::LoopTest::use_continue

// Featurres:
// 718a75cb260445aa568cc537f57079aa: Use boolean literals true and false in expressions.
// 9c17c0f79bb0cf1155bad21f26e45a5e: Use loop continue statements in expressions
// 9034f758486b8614f15d17a11db301bc: Reject and report errors for trailing, consecutive, or misplaced commas within delimited lists.
