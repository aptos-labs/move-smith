
//# publish
module 0xDEAD::NestedStructs {
    use std::assert;

    // Struct with nested fields
    struct Outer has store, drop {
        inner: Inner,
        value: u64,
    }

    struct Inner has store, drop {
        nested_value: u128,
        more_info: Info,
    }

    struct Info has store, drop {
        flag: bool,
        description: vector<u8>,
    }

    // Function to create an Outer with nested value accesses
    public fun create_outer(): Outer {
        let info = Info { flag: true, description: b"desc" };
        let inner = Inner { nested_value: 123456u128, more_info: info };
        Outer { inner, value: 9999u64 }
    }

    // Function to access nested field via dot notation
    public fun get_nested_value(outer: &Outer): u128 {
        // Corrected: Removed invalid line inside the function
        outer.inner.nested_value
    }

    // Function to mutate nested field
    public fun mutate_nested(inner: &mut Inner, new_value: u128) {
        inner.nested_value = new_value;
    }
}



//# run 0xDEAD::NestedStructs::create_outer --signers 0xBADD



//# run 0xDEAD::NestedStructs::get_nested_value --args 0xBADD



//# run 0xDEAD::NestedStructs::mutate_nested --signers 0xBADD --args 987654321u128

// These steps test nested struct creation, deep field access, and mutation



//# publish
module 0xBADA::VariableScope {
    use std::assert;

    // Function demonstrating variable shadowing and inner/outer variables
    public fun variable_shadowing(): u64 {
        let x = 10u64; // outer variable
        let y = 20u64;

        let outer_var = x;
        let a = 0u64; // a should be mutable to modify

        let initial_outer = outer_var;

        // Declare variable outside loop
        let temp: u64 = 0;

        // Outer while loop
        while (outer_var < 15u64) {
            // Shadow inner variable inside loop
            let inner_var = outer_var + 1;
            temp = inner_var * 2;

            // Inner while loop
            let inner_var_mut = inner_var;
            while (inner_var_mut < 20u64) {
                inner_var_mut = inner_var_mut + 1; // shadow is not possible with same name, use new variable
                a = a + inner_var_mut; // a needs to be mutable
            };
            outer_var = outer_var + 1;
        };

        // Assert outer_var has incremented only outside loops
        assert!(outer_var == initial_outer + 5, 0);
        // The variable 'a' should have accumulated
        a
    }

    // Internal function only accessible within the module
    fun internal_compute(x: u64): u64 {
        x * 2
    }

    // Public function to internally call internal_compute
    public fun call_internal(x: u64): u64 {
        internal_compute(x)
    }
}



//# run 0xBADA::VariableScope::variable_shadowing



//# run 0xBADA::VariableScope::call_internal --args 7u64

// Attempt to call internal_compute from outside should be invalid - commented out
// 

//# run 0xBADA::VariableScope::internal_compute --args 5u64 // Should fail to compile
