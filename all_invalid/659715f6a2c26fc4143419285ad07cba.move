//# publish
module 0xCAFE::DestructTest {
    use std::vector;

    struct MyStruct has copy, drop, store, key {
        a: u8,
        b: u64,
        c: bool,
    }

    // A non-inline public function to test pattern destructuring of struct fields in a reordered and renamed manner
    public fun reorder_destructure(s: MyStruct): u64 {
        // Rename and reorder fields: c -> flag, a -> x, b -> y
        let MyStruct { c: flag, a: x, b: y } = s;
        // Return y if flag is true, else return x as u64
        if (flag) {
            y
        } else {
            (x as u64)
        }
    }

    // Another non-inline public function to test partial destructuring (only extract some fields)
    public fun partial_destructure(s: MyStruct): u8 {
        let MyStruct { a, .. } = s;
        a
    }

    // A runner function with no args which publishes a MyStruct and calls the above functions to make sure they compile
    public fun runner(account: &signer) {
        let s = MyStruct { a: 42, b: 1000, c: true };
        move_to(account, s);
        let s_ref = borrow_global<MyStruct>(signer::address_of(account));
        reorder_destructure(*s_ref);
        partial_destructure(*s_ref);
    }
}
//# run 0xCAFE::DestructTest::runner --signers 0xCAFE


//# publish
module 0xCAFE::BracedBodyTest {
    // Test: full braced body around module with multiple members: const, struct, function

    const MAX_U8: u8 = 255;

    struct Wrapper has copy, drop, store, key {
        value: u8,
    }

    public fun get_max_value(): u8 {
        // Test non-inline
        MAX_U8
    }

    public fun make_wrapper(v: u8): Wrapper {
        Wrapper { value: v }
    }

    public fun runner(account: &signer) {
        let w = make_wrapper(MAX_U8);
        move_to(account, w);
        let w_ref = borrow_global<Wrapper>(signer::address_of(account));
        get_max_value();
        let val = w_ref.value;
        // just read val - no asserts needed
    }
}
//# run 0xCAFE::BracedBodyTest::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::DestructTest;
    use 0xCAFE::BracedBodyTest;

    fun main(account: &signer) {
        // Test struct construction and call reorder_destructure
        let s = DestructTest::MyStruct { a: 10, b: 20, c: false };
        let result = DestructTest::reorder_destructure(s);
        // result should be 10 as u64 since c is false

        // Test partial destructure function
        let a_val = DestructTest::partial_destructure(s);

        // Call BracedBodyTest functions standalone
        let max_val = BracedBodyTest::get_max_value();
        let w = BracedBodyTest::make_wrapper(max_val);

        // Move wrapper to global storage and read back (simulate)
        move_to(account, w);
        let w_ref = borrow_global<BracedBodyTest::Wrapper>(signer::address_of(account));
        let _v = w_ref.value;

        // Call runners in modules which also internally test
        DestructTest::runner(account);
        BracedBodyTest::runner(account);
    }
}

// Featurres:
// af34c34d028cde0ffe036333b37d9cfd: Generate bytecode for each non-inline function targeted for compilation.
// 453f85e1e8934b0eb47d02c4140d0b7c: Test that struct pattern destructuring with local lets (including variable renaming and reordering of fields) correctly assigns values in Move functions.
// f08d9977c9008f27836fc953bc865c9d: Create modules with a body enclosed in braces, containing various module members.
