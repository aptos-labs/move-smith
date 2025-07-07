
//# publish
module 0xCAFE::FeatureTest {
    use std::signer;

    public fun add_u8_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let fixed_value = 42u8;
        fixed_value
    }

    public fun lambda_example(x: u8, y: u8): (u8, u8) {
        let anon_fun: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            let m = a * b;
            (s, m)
        };
        anon_fun(x, y)
    }

    public inline fun inline_f1(x: u8, y: u8): u8 {
        let z = x + y;
        z
    }

    public fun call_inline_from_another_module(x: u8, y: u8): u8 {
        let sum = inline_f1(x, y);
        sum
    }

    // Function to test references (borrow global and mutable ref)
    // Add `key` ability so it can be stored under an address and borrowed globally
    struct RefStruct has key, store {
        value: u8,
    }

    public fun create_ref_struct(s: signer, val: u8) {
        move_to<RefStruct>(&s, RefStruct { value: val });
    }

    public fun increment_ref_struct_value(s: signer) {
        let r: &mut RefStruct = borrow_global_mut<RefStruct>(signer::address_of(&s));
        r.value = r.value + 1u8;
    }

    public fun get_ref_struct_value(s: signer): u8 {
        let r: &RefStruct = borrow_global<RefStruct>(signer::address_of(&s));
        r.value
    }

    // Function with a loop that has early return, no code after loop is executed
    public fun early_return_loop(x: u8): u8 {
        let i = 0u8;
        loop {
            if (i >= x) {
                return i;
            };
            i = i + 1;
        };
        // This code is unreachable, but must return a u8;
        // instead of assert!(false, 9999), just return i (or any u8) to satisfy return type
        i
    }
}



//# run 0xCAFE::FeatureTest::add_u8_and_return_fixed --args 5u8 7u8



//# run 0xCAFE::FeatureTest::lambda_example --args 3u8 4u8



//# publish
module 0xCAFE::FeatureTestWrapper {
    use 0xCAFE::FeatureTest;

    public fun call_inline_f1_in_other_module(x: u8, y: u8): u8 {
        FeatureTest::call_inline_from_another_module(x, y)
    }
}



//# run 0xCAFE::FeatureTestWrapper::call_inline_f1_in_other_module --args 10u8 15u8



//# publish
module 0xCAFE::RefTest {
    use std::signer;
    use 0xCAFE::FeatureTest;

    public fun create_struct(s: signer, val: u8) {
        FeatureTest::create_ref_struct(s, val);
    }

    public fun increment_struct_value(s: signer) {
        FeatureTest::increment_ref_struct_value(s);
    }

    public fun read_struct_value(s: signer): u8 {
        FeatureTest::get_ref_struct_value(s)
    }
}



//# run 0xCAFE::RefTest::create_struct --signers 0xD00D --args 100u8



//# run 0xCAFE::RefTest::increment_struct_value --signers 0xD00D



//# run 0xCAFE::RefTest::read_struct_value --signers 0xD00D



//# run 0xCAFE::FeatureTest::early_return_loop --args 10u8
