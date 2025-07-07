//# publish
module 0xDEAD::CombinedFeaturesTest {
    use std::vector;

    struct ResourceA has key {
        value: u8,
    }

    struct ResourceB has key {
        flag: bool,
    }

    // Internal function for access testing
    fun internal_function(a: u8): u8 {
        a + 5
    }

    public fun init_resources(signer: &signer) {
        move_to<ResourceA>(signer, ResourceA { value: 10 });
        move_to<ResourceB>(signer, ResourceB { flag: true });
    }

    public fun get_resource_a(address: address): u8 {
        let res_ref: &ResourceA = borrow_global<ResourceA>(address);
        res_ref.value
    }

    public fun get_resource_b(address: address): bool {
        let res_ref: &ResourceB = borrow_global<ResourceB>(address);
        res_ref.flag
    }

    // Wrapper to call internal function without args
    public fun call_internal(_addr: address): u8 {
        internal_function(20)
    }
}



//# run 0xDEAD::CombinedFeaturesTest::init_resources --signers 0xB0B --args



//# run 0xDEAD::CombinedFeaturesTest::get_resource_a --args 0xB0B



//# run 0xDEAD::CombinedFeaturesTest::get_resource_b --args 0xB0B



//# run 0xDEAD::CombinedFeaturesTest::call_internal --args 0xB0B


//# script
//# run
script {
    // Local variables outside loops with varied types
    let local_u8: u8 = 123;
    let local_bool: bool = true;
    let local_vector: vector<u8> = vector::empty<u8>();
    vector::push_back<&mut vector<u8>>(&mut local_vector, 1);
    vector::push_back<&mut vector<u8>>(&mut local_vector, 2);

    // Variable bindings to literals and expressions
    let bound_u8 = local_u8;
    let bound_bool = local_bool;
    let bound_vector = copy local_vector;

    // Using literals directly
    let lit_u8: u8 = 255;
    let lit_bool: bool = false;

    // Shadowing within a loop
    let i: u64 = 0;
    while (i < 3) {
        let i_shadow = i;
        // Assignments inside loop
        let _ = i_shadow + 2;
        // Shadowing local
        let i = i_shadow + 1;
        // Update outer variable
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        // Call an internal function to verify no interference
        let _value = 0xDEAD::CombinedFeaturesTest::call_internal(@0xB0B);
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        // Update outer variable again
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        i = i + 1;
        // Increment outer variable to break loop
        i = i + 1;
        i = i;
        i = i + 1;

        i = i + 1;
        i = i + 1;
        i = i + 1;

        i = i + 1;
        i = i;
        i = i + 1;

        // Increment outer variable
        i = i + 1;
        i = i;

        // Loop continuation
        i = i + 1;
    };
    // After loop, verify outer variable
    let _final_i = i;

    // Binding function result to variable
    let result = 0xDEAD::CombinedFeaturesTest::call_internal(@0xB0B);

    // Use of multiple compiler passes: code that benefits those
    let large_vector: vector<u8> = vector::range(0, 10);
    let sum: u8 = {
        let total: u8 = 0;
        let length = vector::length(&large_vector);
        let idx: u64 = 0;
        while (idx < length) {
            total = total + *vector::borrow(&large_vector, idx);
            idx = idx + 1;
        };
        total
    };
    // Ensure correct behavior after optimization
    assert!(sum == 45, 999);
}
