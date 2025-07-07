
//# publish
module 0xCAFE::SpecAndCompilerOptions {
    use std::signer;

    struct SpecStruct has store {
        value: u64,
    }

    // Function with specification
    public fun set_value(s: &signer, v: u64) {
        let addr = signer::address_of(s);
        move_to_or_update<SpecStruct>(addr, SpecStruct { value: v });
    }

    public fun get_value(): u64 acquires SpecStruct {
        let addr = @0xCAFE;
        let spec_ref = borrow_global<SpecStruct>(addr);
        spec_ref.value
    }

    // Inline function with spec and attributes
    // inline(always)]
    // allow(unused_variables)]
    public inline fun inline_addition(a: u64, b: u64): u64 {
        // Specification requires the result to always be >= a and b (unsigned).
        spec {
            ensures result >= a;
            ensures result >= b;
        };
        a + b
    }

    // Function with spec asserting a property
    public fun check_values(a: u64, b: u64) {
        let _ = inline_addition(a, b);
        spec {
            requires a <= b + 1000;
            ensures true;
        };
        // Body intentionally empty
    }

    // Linted function example with attribute to allow some lints for demonstration
    // allow(unused_variables)]
    public fun linted_function(x: u64) {
        // we can do something simple
        let _y = x + 1;
    }
}

/// Helper: move_to_or_update will move_to if no resource, else update existing resource
fun move_to_or_update<T: store>(addr: address, val: T) {
    if (!exists<T>(addr)) {
        move_to<T>(&signer::borrow_address(&addr), val);
    } else {
        let mut_ref = borrow_global_mut<T>(addr);
        *mut_ref = val;
    };
}



//# run 0xCAFE::SpecAndCompilerOptions::set_value --signers 0xCAFE --args 100u64



//# run 0xCAFE::SpecAndCompilerOptions::get_value



//# run 0xCAFE::SpecAndCompilerOptions::check_values --args 123u64 456u64



//# run 0xCAFE::SpecAndCompilerOptions::linted_function --args 50u64


// Featurres:
// 6690ecacc05deb76718ba05ec0be0845: Write specifications using 'spec' and related keywords to include formal specifications in your Move code.
// be26dc0997ee287f44386dfcef25627e: Control whether inline functions are retained in the output for debugging via compiler options.
// 59c54d46170e9b9dac4684b0ec0a59d0: Allow function bodies to be checked by a variety of lint passes for code quality or correctness.
