
//# publish
module 0xCAFE::MyModule {
    // Added this module with inline function f2 as it's missing and causing linker errors.

    public inline fun f2(x: u16): (u16, u16) {
        // For demonstration, just split x into (x, x+1)
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::FeatureTest {
    use std::signer;

    // Simple function that adds two u8 numbers and returns sum + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function demonstrating lambdas with copy and drop
    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let diff = if (a > b) { a - b } else { b - a };
            (sum, diff)
        };
        lambda(x, y)
    }

    // Inline function, multiple inner calls
    public inline fun multiply_by_two(x: u16): u16 {
        x * 2
    }
    public inline fun multiply_and_add(x: u16, y: u16): u16 {
        (multiply_by_two(x)) + y
    }

    // Function that calls inline functions across modules (from MyModule)
    public fun call_external_inline(x: u16): u16 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        multiply_and_add(a, b)
    }

    struct RefStruct has copy, drop, store {
        v: u8,
    }

    // Function showing use of & and &mut references on local struct
    public fun ref_types_example() {
        let mut_struct = RefStruct { v: 42 };
        let ref_imm: &RefStruct = &mut_struct;
        let ref_mut: &mut RefStruct = &mut mut_struct;

        // deref immutable reference to read
        let _val: u8 = ref_imm.v;

        // mutate via mutable reference
        ref_mut.v = ref_mut.v + 1;
    }

    // Function demonstrating reference usage with global resource to be used in specs
    struct GlobalKey has store, key { x: u8 }

    public fun create_global_resource(s: signer, x: u8) {
        move_to<GlobalKey>(&s, GlobalKey { x });
    }

    public fun get_global_ref(s: signer): &GlobalKey {
        borrow_global<GlobalKey>(signer::address_of(&s))
    }

    public fun get_global_mut_ref(s: signer): &mut GlobalKey {
        borrow_global_mut<GlobalKey>(signer::address_of(&s))
    }
}



//# run 0xCAFE::FeatureTest::add_and_offset --args 20u8 30u8



//# run 0xCAFE::FeatureTest::use_lambda --args 7u8 3u8



//# run 0xCAFE::FeatureTest::call_external_inline --args 10u16



//# run 0xCAFE::FeatureTest::ref_types_example



//# run 0xCAFE::FeatureTest::create_global_resource --signers 0xBEEF --args 55u8



//# run 0xCAFE::FeatureTest::get_global_ref --signers 0xBEEF



//# run 0xCAFE::FeatureTest::get_global_mut_ref --signers 0xBEEF
