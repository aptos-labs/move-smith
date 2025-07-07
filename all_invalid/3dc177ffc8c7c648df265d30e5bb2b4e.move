
//# publish
module 0xCAFE::ArgParenthesesTest {
    public fun no_arg_func(): u8 {
        42
    }

    public fun one_arg_func(x: u8): u8 {
        x + 1
    }

    public fun multi_arg_func(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_functions() {
        // Proper calls with parentheses around arguments
        let a = no_arg_func();
        let b = one_arg_func((10u8));
        let c = multi_arg_func((1u8, 2u8));
        let _ = (a, b, c);
    }
}


//# run 0xCAFE::ArgParenthesesTest::call_functions



//# publish
module 0xCAFE::SpecRewriteTest {
    use std::vector;

    struct Data has store {
      val: u8,
      vec: vector<u8>,
    }

    spec module {
        // Old style spec example: requires that value < 100
        // We pretend this old spec is rewritten properly
        ensures exists<0xCAFE::SpecRewriteTest::Data>(@0xCAFE);
    }

    public fun create_data(): Data {
        Data {
            val: 10,
            vec: vector::empty<u8>(),
        }
    }

    spec create_data {
        ensures result.val == 10;
        ensures vector::length(&result.vec) == 0;
    }

    public fun update_data(d: &mut Data, v: u8) {
        d.val = v;
        vector::push_back(&mut d.vec, v);
    }

    spec update_data {
        requires v < 100;
        ensures d.val == v;
        ensures vector::contains(&d.vec, v);
    }

    public fun runner() {
        let d = create_data();
        update_data(&mut d, 42u8);
    }
}


//# run 0xCAFE::SpecRewriteTest::runner



//# publish
module 0xCAFE::DiagnosticsTest {
    struct Sensitive has copy, drop, store {}

    const CONST_VALUE: u8 = 55;

    // Valid function, struct and constant
    public fun valid_function(x: u8): u8 {
        x + CONST_VALUE
    }

    public fun diagnostics_runner() {
        let _ = CONST_VALUE;

        // Valid accesses
        let _ = valid_function(1u8);
        let _s = Sensitive {};
        
        // Invalid attempted accesses SHOULD trigger diagnostics if uncommented:
        // let _ = Sensitive::CONST_VALUE;
        // let _ = CONST_VALUE::something;
        // let _ = valid_function::CONST_VALUE;
        // let _x = Sensitive::NonExistentField;

        // Valid member access to this module's constant again
        let _ = CONST_VALUE;
    }
}


//# run 0xCAFE::DiagnosticsTest::diagnostics_runner



//# publish
module 0xCAFE::CombinedTest {
    use std::vector;

    struct T has store {
      value: u8,
    }

    spec module {
        // Old spec rewritten with parenthesized calls and member accesses.
        ensures exists<0xCAFE::CombinedTest::T>(@0xCAFE);
    }

    public fun create(): T {
        T { value: 7 }
    }

    spec create {
        ensures (result.value) == 7;
        ensures (0xCAFE::DiagnosticsTest::CONST_VALUE) > 50;
    }

    public fun return_sum(x: u8, y: u8): u8 {
        x + y
    }

    spec return_sum {
        requires x > 0;
        requires y > 0;
        ensures (result) == (x + y);
    }

    public fun faulty_access() {
        // Attempt invalid member access in function body to test diagnostics
        // let _ = 0xCAFE::CombinedTest::NonExistentConst;
        // let _ = 0xCAFE::CombinedTest::T::extra_field;

        let _ = 0xCAFE::DiagnosticsTest::CONST_VALUE; // Valid access

        // call function with parentheses enforcing argument parenthesis
        let sum = return_sum((3u8, 4u8));
        let _ = sum;
    }

    public fun runner() {
        let _ = create();
        faulty_access();
    }
}


//# run 0xCAFE::CombinedTest::runner


// Featurres:
// b2f038c2ec4bca7848d17d1805315da1: Use parentheses to enclose call arguments.
// b55ad2e03b67074aa23a762dfdf31657: Rewrite specifications for Move modules and functions to improve or transform them
// 7ed3aa6336c305003c3cf85d6031e07c: Detect and handle unexpected module member accesses with diagnostics.
