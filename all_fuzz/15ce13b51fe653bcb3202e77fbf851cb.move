
//# publish
module 0xCAFE::ComputeAdd {
    // Test that the Move function correctly computes the addition of two u8 values before returning a specific value.

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    // Function containing lambda (anonymous function) expressions.
    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |p: u8, q: u8| {
            let add = p + q;
            let mul = p * q;
            (add, mul)
        };
        lambda(x, y)
    }

    // Runner function that uses both above functions for testing.
    public fun runner(): u8 {
        let (sum, product) = use_lambda(3u8, 4u8);
        let total = add_and_return_sum(sum, product);
        total
    }
}


//# run 0xCAFE::ComputeAdd::add_and_return_sum --args 12u8 13u8


//# run 0xCAFE::ComputeAdd::use_lambda --args 5u8 6u8


//# run 0xCAFE::ComputeAdd::runner


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::ComputeAdd;

    // Test that calling an inline function from one module within another module
    // correctly performs nested function calls and returns expected result.

    public inline fun inline_addition(a: u8, b: u8): u8 {
        ComputeAdd::add_and_return_sum(a, b)
    }

    public fun nested_call(x: u8, y: u8): u8 {
        inline_addition(x, y)
    }

    // Runner that calls nested_call inside.
    public fun runner(): u8 {
        nested_call(10u8, 20u8)
    }
}


//# run 0xCAFE::InlineCaller::inline_addition --args 7u8 8u8


//# run 0xCAFE::InlineCaller::nested_call --args 11u8 12u8


//# run 0xCAFE::InlineCaller::runner


//# publish
module 0xCAFE::TypeParamsTest {
    // Automatically generate type parameter syntax with proper formatting and numbering.

    struct Pair<T0, T1> has store {
        first: T0,
        second: T1,
    }

    struct Triple<T0, T1, T2> has store {
        first: T0,
        second: T1,
        third: T2,
    }

    public fun create_pair(): Pair<u8, u16> {
        Pair { first: 1u8, second: 2u16 }
    }

    public fun create_triple(): Triple<u8, u16, u32> {
        Triple { first: 3u8, second: 4u16, third: 5u32 }
    }

    public fun runner(): u32 {
        let p = create_pair();
        let t = create_triple();
        (p.first as u32) + (p.second as u32) + (t.first as u32) + (t.second as u32) + t.third
    }
}


//# run 0xCAFE::TypeParamsTest::create_pair


//# run 0xCAFE::TypeParamsTest::create_triple


//# run 0xCAFE::TypeParamsTest::runner


//# publish
module 0xCAFE::SpecUseTest {
    use std::vector;

    spec module {
        use 0xCAFE::TypeParamsTest::{Pair, Triple};

        struct SpecStruct {
            pair_fields: Pair<u8, u16>,
            triple_fields: Triple<u8, u16, u32>,
        }

        // Functions in spec context can see these imported names (Pair, Triple).

        fun create_spec_struct(): SpecStruct {
            SpecStruct {
                pair_fields: Pair { first: 10u8, second: 20u16 },
                triple_fields: Triple { first: 30u8, second: 40u16, third: 50u32 }
            }
        }
    }

    public fun dummy() {}
}


//# run 0xCAFE::SpecUseTest::dummy


//# run
script {
    // Test for descriptive compile-time errors with invalid hex string literals.
    // This script intentionally contains invalid hex chars in hex string literals.
    // This will cause a compile error with descriptive message on bad hex chars.

    // This test is only to check compile-time errors related to hex literals,
    // move test framework should report error message accordingly.

    fun main() {
        let _valid_hex: vector<u8> = x"abcdef0123456789";
        // Invalid hex string literals with characters beyond 0-9 and a-f.
        // Uncomment each below line one by one to see compile errors.

        // let _invalid_hex1: vector<u8> = x"ghij";      // invalid letters g,h,i,j
        // let _invalid_hex2: vector<u8> = x"12xz34";    // invalid letters x,z
        // let _invalid_hex3: vector<u8> = x"12_34";     // invalid char underscore _
        // let _invalid_hex4: vector<u8> = x"12 34";     // invalid space character
    }
}


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 747b4002faaa7e337217152de6e1ffb0: Automatically generate type parameter syntax with proper formatting and numbering.
// ad31c6dac913bc32d8d6d597858f5b7a: Use 'use' declarations in spec blocks to import names and manage visibility within the specification context.
// fdbba66652f7b34b82cf64fc96933a9d: Receive descriptive compile-time errors when using invalid hexadecimal characters in hex string literals
