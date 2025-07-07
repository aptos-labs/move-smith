// Corrected Move module with proper placement of internal/internal definitions and function visibility
//# publish
module 0xDEAD::ComplexFeatureTest {
    use std::signer;
    use std::vector;

    // Struct with nested fields for testing dot notation
    struct Container has copy, drop, store {
        inner: Inner,
    }

    struct Inner has copy, drop, store {
        value: u64,
        sub: SubInner,
    }

    struct SubInner has copy, drop, store {
        count: u16,
    }

    // External module with private/internal function
// Place the internal module outside and after the main module
// or in a nested module as Move does not support nested modules
// so to keep things simple, define separate module at the bottom
// But for the purpose of fixing, we should move it outside the main module

// We will move the internal module outside of the main module to fix syntax
}

//# publish
module 0xBADD::InternalModule {
    fun internal_function(): u8 {
        42
    }

    public fun call_internal(): u8 {
        internal_function()
    }
}

// Now return to the main module
//# publish
module 0xDEAD::ComplexFeatureTest {
    use std::signer;
    use std::vector;

    // Structs already defined above

    // Function with spec assertion
    public fun verify_sum(x: u64, y: u64): u64
        ensures result >= x && result >= y {
        let sum = x + y;
        // Intentional check to verify purity
        assert!(sum >= x, 1001);
        assert!(sum >= y, 1002);
        sum
    }

    // Function with currying simulation via closures
    public fun make_multiplier(multiplier: u64): |u64|u64 {
        |x: u64| {
            x * multiplier
        }
    }

    // Function with nested closures
    public fun chained_closure(x: u64, y: u64): u64 {
        let double = |n: u64| n * 2;
        let add = |a: u64, b: u64| a + b;
        let result = add(double(x), double(y));
        result
    }

    // Helper to test variable shadowing in loops
    public fun variable_shadowing_test(flag: bool): u64 {
        let outer_var = if (flag) { 5 } else { 10 };
        let sum = 0;
        let i = 0;
        while (i < 3) {
            let outer_var = i as u64; // shadow outer variable
            sum = sum + outer_var;
            i = i + 1;
        };
        sum
    }

    // Function to access nested fields using dot notation
    public fun access_nested_fields(container: &Container): u64 {
        // Access inner.value
        let _value = container.inner.value;
        // Access sub.count
        let _count = container.inner.sub.count;
        container.inner.value
    }

    // Function to test loop with local variable assignment outside
    public fun loop_with_local_loop_variable(): u64 {
        let total = 0;
        let index = 0;
        while (index < 4) {
            let temp = index * 2; // local variable inside loop
            total = total + temp;
            index = index + 1;
        };
        total
    }

    // Function to test calling internal functions from external
    public fun call_internal_func(): u8 {
        0xBADD::InternalModule::call_internal()
    }

    // Function to test specification assertions inside
    public fun test_assertions(x: u64): u64 {
        assert!(x > 0, 2001);
        let y = x + 10;
        assert!(y > x, 2002);
        y
    }

    // Testing function currying effect
    public fun test_currying_and_closures() {
        let mul_by_3 = make_multiplier(3);
        let mul_by_5 = make_multiplier(5);
        let result1 = mul_by_3(7);
        let result2 = mul_by_5(7);
        assert!(result1 == 21, 3001);
        assert!(result2 == 35, 3002);
    }

    // Test invoking named address with arguments
    public fun invoke_address_with_args(address: address, arg1: u8, arg2: u8): u16 acquires 0 {
        // Just a mock to simulate calling an address with args (no real call)
        // For testing, we just combine args
        (arg1 as u16) + (arg2 as u16)
    }
}

// The tests are run via script or CLI commands as indicated
// with the fixed module code above, the compilation should succeed.
