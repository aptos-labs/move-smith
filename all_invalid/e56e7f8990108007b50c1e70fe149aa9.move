// 1. Test Spec Invariant Condition Expression

//# publish
module 0xCAFE::SpecInvariantTest {
    struct MyData has copy, drop, store {
        x: u64,
    }

    public fun new_my_data(val: u64): MyData {
        MyData { x: val }
    }

    public fun set_my_data_x(data: &mut MyData, val: u64) {
        data.x = val;
    }

    public fun get_my_data_x(data: &MyData): u64 {
        data.x
    }

    public fun runner() {
        let mut d = Self::new_my_data(20);
        Self::set_my_data_x(&mut d, 45);
        let _x = Self::get_my_data_x(&d);
    }

    spec MyData {
        invariant x > 0;
    }
}

//# run 0xCAFE::SpecInvariantTest::runner

// 2. Test variable initialization enforcement before use in early control flow

//# publish
module 0xCAFE::ConditionalVariableInit {
    public fun early_return(flag: bool): u8 {
        let res: u8;
        if (flag) {
            return 7;
        } else {
            res = 99;
        };
        // The next line is OK because res is surely initialized if we reach here.
        res
    }
    // This version will fail to compile. Uncomment to exercise the compiler's error:
    // public fun bad_early_return(flag: bool): u8 {
    //     let res: u8;
    //     if (flag) {
    //         return 1;
    //     };
    //     res // Error: res possibly uninitialized
    // }
    public fun runner(): u8 {
        let v1 = Self::early_return(true);
        let v2 = Self::early_return(false);
        v1 + v2
    }
}
//# run 0xCAFE::ConditionalVariableInit::runner

// 3. Test automatic token advancing after Move version (must appear at file start):
move 2024;

//# publish
module 0xCAFE::MoveVersionAdvance {
    public fun runner() {
        // If the compiler fails to lex the rest of the file after the Move version,
        // this function can't be compiled.
        let a = 5u64 + 7u64;
        let _b = a / 3u64;
    }
}
//# run 0xCAFE::MoveVersionAdvance::runner

// Featurres:
// 15d85e9a204608b4c1e8625f72ee3c04: Specify an expression for the invariant condition in a spec block.
// d5f607c605733c5b04f5d399e749b0a2: Test that the Move compiler enforces variable initialization before use when variables are only conditionally assigned due to early returns in control flow.
// 620f7ef42c99cf0f794972669396a24e: Automatically advance the token stream after checking the Move version.