//# publish
module 0x1::DeprecationTest {
    #[deprecated]
    struct DeprecatedStruct has store { val: u64 }

    struct ActiveStruct has store { val: u64 }

    fun new_active_struct(): ActiveStruct {
        ActiveStruct { val: 42 }
    }

    fun runner() {
        let _ = Self::new_active_struct();
    }
}
//# run 0x1::DeprecationTest::runner

//# publish
module 0x1::DeprecationTest {  // Duplicate module name to test duplicated modules handling
    struct DuplicateStruct has store { val: u64 }

    fun runner() {
        let _ = DuplicateStruct { val: 100 };
    }
}
//# run 0x1::DeprecationTest::runner

//# publish
module 0x1::AbilitiesTest {
    struct AbilitiesStruct has key, store, copy {}

    fun runner() {
        let _ = AbilitiesStruct {};
    }
}
//# run 0x1::AbilitiesTest::runner

//# publish
module 0x1::TestExpressions {
    use std::signer;

    // A function with side effects inside block expressions that modify a mutable variable `n`
    fun test(): u64 {
        let mut n = 0;
        // expression 1: assign 1 to n, return n + 1 => 2
        let a = {
            n = 1;
            n + 1
        };
        // expression 2: assign 2 to n, return n + 2 => 4
        let b = {
            n = 2;
            n + 2
        };
        // expression 3: n is 2 here, assign n to 3, return n * 2 => 6
        let c = {
            n = 3;
            n * 2
        };
        // sum all results plus the final n, which should be 3
        a + b + c + n
    }

    fun runner(): u64 {
        test()
    }
}
//# run 0x1::TestExpressions::runner