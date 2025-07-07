
//# publish
module 0xCAFE::UnusedVarsTest {
    struct MyStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun use_var(x: u8): u8 {
        let used_var = x + 1;
        used_var
    }

    // parameter x is not used - to test detect unused parameter (should not cause error but checking coverage)
    public fun param_unused(_x: u8): u8 {
        let y = 5u8;
        y
    }

    public fun all_used_params(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun use_struct_fields(s: MyStruct): u8 {
        let sum = s.a + s.b;
        sum
    }

    public fun call_nested() {
        // use local variable declared and used
        let val = use_var(10u8);
        let _ = all_used_params(val, 5u8);
    }
}



//# run 0xCAFE::UnusedVarsTest::use_var --args 100u8



//# run 0xCAFE::UnusedVarsTest::param_unused --args 50u8



//# run 0xCAFE::UnusedVarsTest::all_used_params --args 7u8 8u8



//# run 0xCAFE::UnusedVarsTest::call_nested



//# run 0xCAFE::UnusedVarsTest::use_struct_fields --args 4u8 3u8



//# publish
module 0xCAFE::SenderAddressTest {
    // Module deliberately published with explicit address 0xCAFE
    public fun no_param_function(): u8 {
        42
    }

    public fun with_param(s: signer, x: u8): u8 {
        let _sender = signer::address_of(&s);
        x + 1
    }
}



//# run 0xCAFE::SenderAddressTest::no_param_function



//# run 0xCAFE::SenderAddressTest::with_param --signers 0xBEEF --args 9u8




//# publish
module 0xCAFE::SimpleNamesTest {
    struct SimpleStruct has copy, drop, store {
        value: u64,
    }

    public fun new_simple_struct(x: u64): SimpleStruct {
        SimpleStruct { value: x }
    }

    public fun get_value(s: SimpleStruct): u64 {
        s.value
    }

    public fun add_values(s1: SimpleStruct, s2: SimpleStruct): u64 {
        s1.value + s2.value
    }
}



//# run 0xCAFE::SimpleNamesTest::new_simple_struct --args 123u64



//# run 0xCAFE::SimpleNamesTest::get_value --args 456u64



//# run 0xCAFE::SimpleNamesTest::add_values --args 1u64 2u64
