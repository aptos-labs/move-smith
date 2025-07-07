
//# publish
module 0xDEAD::NestedAccess {
    // Example nested structure
    struct InnerStruct has copy, drop, store {
        val: u64,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        detail: bool,
    }

    // Function to access nested fields using dot notation
    public fun get_inner_value(o: &OuterStruct): u64 {
        o.inner.val
    }

    public fun get_detail(o: &OuterStruct): bool {
        o.detail
    }
}



//# publish
module 0xBEEF::DeprecationTest {
    // Mark entire namespace as deprecated
    // deprecated]
    public fun deprecated_function() {
        // empty
    }
}



//# publish
module 0xC0FFEE::SpecModule {
    // A function with a spec to check that input is greater than zero
    public fun check_positive(x: u64) {
        // Specification: x must be greater than 0
        spec {
            x > 0
        }
    }

    // A pure function with spec
    public fun pure_add(a: u64, b: u64): u64 {
        a + b
    }
}



//# publish
module 0xCAFE::FunctionUsage {
    // A simple function to add two u64 values
    public fun add_u64(a: u64, b: u64): u64 {
        a + b
    }

    // Generic function returning the maximum of two values
    public fun max<T: copy + drop + 'static>(a: T, b: T, cmp: |T, T| -> bool): T {
        if (cmp(a, b)) {
            a
        } else {
            b
        }
    }
}



//# publish
module 0xDADA::DropTest {
    // A struct with Drop ability
    struct DropStruct has store, drop {
        val: u64,
    }

    // Function to discard a value with Drop
    public fun discard_value<T: drop>(v: T) {
        // v is dropped at the end
        drop v;
    }

    // Function that creates and discards nested types
    public fun create_and_discard() {
        let nested = DropStruct { val: 42 };
        discard_value(nested);
    }
}



//# run 0xDEAD::NestedAccess::get_inner_value --args 0



//# run 0xDEAD::NestedAccess::get_detail --args 0



//# run 0xBEEF::DeprecationTest::deprecated_function --args

// Test deprecation warning: Using deprecated module


//# run 0xBEEF::DeprecationTest::deprecated_function --args

// Assign function to variables and use as first-class


//# run 0xCAFE::FunctionUsage::add_u64 --args 10u64 20u64

// Use generic function as first-class


//# run 0xCAFE::FunctionUsage::max --args 15u64 10u64 --args |a, b| { *a > *b }

// Pass function as argument and invoke
public fun use_as_arg<T: copy + drop>(
    f: |u64, u64| -> u64,
    a: u64,
    b: u64
): u64 {
    f(a, b)
}

// Run passing a concrete function pointer


//# run 0xCAFE::FunctionUsage::add_u64 --args 7u64 3u64
// Assume function pointer is passed properly in the test environment

// Specification enforcement test: call with valid and invalid values


//# run 0xC0FFEE::SpecModule::check_positive --args 5u64

// The following should cause a trap or abort if running in an environment that enforces specs


//# run 0xC0FFEE::SpecModule::check_positive --args 0u64

// Test function purity and specification


//# run 0xC0FFEE::SpecModule::pure_add --args 10u64 15u64

// Drop test: create and discard nested struct


//# run 0xDADA::DropTest::create_and_discard

// Explicit discard of a value with Drop


//# run 0xDADA::DropTest::discard_value --args 100u64
