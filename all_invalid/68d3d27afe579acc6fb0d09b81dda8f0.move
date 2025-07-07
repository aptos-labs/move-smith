// # publish
module 0xCAFE::CmpAndOpt {
    /// Custom comparison function that should be rewritten by the compiler
    public fun is_less(x: u64, y: u64): bool {
        x < y
    }

    /// Generic Option type and simple constructor
    public struct Option<T> has copy, drop, store {
        inner: bool,
        value: T,
    }

    public fun some<T>(value: T): Option<T> {
        Option { inner: true, value }
    }

    public fun none<T>(): Option<T> {
        // Note: For none, we need to fill a value, but it's unused when inner = false
        // Use zero initialization via `move_from`
        // We'll just fake it with an initialized u8 zero and unsafe cast, for testing purpose use u64 0u64.
        // But to avoid complexity, just create none with inner = false, value = zeroed implicity.
        // Here, we rely on caller not accessing value if inner == false.
        Option { inner: false, value: 0u64 }
    }

    /// Get value from Option, panics if none
    public fun unwrap<T: copy + drop>(opt: &Option<T>): &T {
        assert!(opt.inner, 100);
        &opt.value
    }
}

// # run 0xCAFE::CmpAndOpt::test_cmp
// --signers 0xCAFE
module 0xCAFE::CmpAndOptRunner {
    use 0xCAFE::CmpAndOpt;

    /// Runner to test the custom comparison operator rewriting
    public fun test_cmp(_signer: &signer) {
        let a = 3u64;
        let b = 5u64;
        let result = CmpAndOpt::is_less(a, b);
        // Just call to force execution
        let _ = result;
    }
}

// # run
script {
    use 0xCAFE::CmpAndOpt;
    use 0xCAFE::CmpAndOptRunner;

    fun main() {
        // Test 1: Custom comparison rewritten call
        CmpAndOptRunner::test_cmp(&signer::address_of(&signer));

        // Test 2: Closures with drop and copy, & and &mut references, mutation and invocation

        // Define a local closure type that captures variables and can be copied/dropped
        struct ClosureHolder<T> has copy, drop {
            callback: fn(&mut T, u64) -> u64,
            data: T,
        }

        // Let's define a closure equivalently as a struct with a call method
        // but since Move does not have closures proper, we'll emulate it with functions taking reference.

        // Define a function that acts like a closure with mut access
        fun closure_increment(x: &mut u64, y: u64): u64 {
            *x = *x + y;
            *x
        }

        let mut x = 10u64;

        let mut holder = ClosureHolder {
            callback: closure_increment,
            data: x,
        };

        // Call via &mut reference
        let result = (holder.callback)(&mut holder.data, 5u64);

        // Mutate data through holder.data reference
        holder.data = result + 10;

        // Call again through immutable & reference of a copied holder
        let holder_copy = holder; // copy since has copy
        let res2 = (holder_copy.callback)(&mut (holder_copy.data), 1u64);

        // Store results to force no optimizing out
        let _ = (result, holder.data, res2);

        // Test 3: Generic type application: Option<u64>

        let some_val = CmpAndOpt::some<u64>(42u64);
        let none_val = CmpAndOpt::none<u64>();

        // Use references to Option<T>
        let some_ref = &some_val;
        let none_ref = &none_val;

        let unwrapped_val = CmpAndOpt::unwrap(some_ref);

        // Because none unwrap would panic we won't call that

        let _ = unwrapped_val;
        let _ = none_ref.inner;
    }
}


// Featurres:
// 4d54e60e788ef2ff56d39867c98f8643: Use custom comparison operations that can be automatically rewritten by the compiler for supported functions.
// 1838265b96ee199f371b3d9b6c493bdf: Test that closures with drop and copy abilities can be referenced and mutated via & and &mut, and correctly invoked through references.
// 9fc87a5b4cf2a67fa06f1b06d5bb1857: Use generic type application and parameterization with syntax like 'Option<u64>'.
