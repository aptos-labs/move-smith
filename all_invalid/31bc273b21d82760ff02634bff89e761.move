
//# publish
module 0xBEEFBEEF::NestedFieldsTest {
    // Module to test nested field access with dot notation
    struct InnerMost has copy, drop, store {
        value: u64,
    }

    struct Inner has copy, drop, store {
        inner_most: InnerMost,
        flag: bool,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        count: u8,
    }

    public fun create_outer(): Outer {
        Outer {
            inner: Inner {
                inner_most: InnerMost { value: 42 },
                flag: true,
            },
            count: 255,
        }
    }

    public fun access_nested_field(o: &Outer): u64 {
        let inner_ref: &Inner = &o.inner;
        let inner_most_ref: &InnerMost = &inner_ref.inner_most;
        inner_most_ref.value
    }

    public fun get_outer_count(o: &Outer): u8 {
        o.count
    }

    public fun mutate_nested_pointer(o: &mut Outer, new_value: u64) {
        let inner_ref: &mut Inner = &mut o.inner;
        let inner_most_ref: &mut InnerMost = &mut inner_ref.inner_most;
        inner_most_ref.value = new_value;
    }
}


//# run 0xBEEFBEEF::NestedFieldsTest::create_outer --signers 0x0 --args

//# run 0xBEEFBEEF::NestedFieldsTest::access_nested_field --args (borrow_global of outer) --signers 0x0

//# run 0xBEEFBEEF::NestedFieldsTest::get_outer_count --args (borrow_global of outer) --signers 0x0

//# run 0xBEEFBEEF::NestedFieldsTest::mutate_nested_pointer --signers 0x0 --args (replace the outer variable with a mutable borrow) 


//# publish
module 0xDEPRECATED::Namespace {
    // Module under deprecated namespace
    deprecate address 0xDEPRECATED;
    // All modules under this address are considered deprecated
}


//# publish
module 0xCAFE::DeprecationCheck {
    use std::signer;

    // This module is under deprecated namespace, should trigger warnings/errors when used.
    public fun dummy() {}
}


//# run 0xCAFE::DeprecationCheck::dummy --signers 0x0


//# publish
module 0xC0FFEE::FirstClassFunctions {
    // Functions as first-class citizens: assign, pass, invoke
    public fun add_one(x: u64): u64 {
        x + 1
    }

    public fun identity<T>(value: T): T {
        value
    }

    public fun run_example() {
        let f: |u64|u64 = add_one;
        let result = f(10);
        assert!(result == 11, 999);

        // Pass function as argument
        let result2 = call_with_value(add_one, 20);
        assert!(result2 == 21, 999);

        // Use generic function
        let id_func: |u64|u64 = identity;
        let val = id_func(99);
        assert!(val == 99, 999);
    }

    fun call_with_value(func: |u64|u64, v: u64): u64 {
        func(v)
    }
}


//# run 0xC0FFEE::FirstClassFunctions::run_example --signers 0x0


//# publish
module 0xABCD::InlineMarked {
    /// Mark a function inline to verify inlining behavior
    public inline fun compute_sum(a: u64, b: u64): u64 {
        a + b
    }

    public fun check_inlining() {
        let result = compute_sum(10, 20);
        assert!(result == 30, 999);
    }
}


//# run 0xABCD::InlineMarked::check_inlining --signers 0x0


//# publish
module 0xFEED::SpecChecks {
    // Functions with spec: check purity and correctness
    public fun pure_add(x: u64, y: u64): u64 {
        x + y
    }

    // This function should adhere to purity constraints
    public fun validate_spec() {
        // Spec check: pure function should not modify state
        let sum = pure_add(7, 8);
        assert!(sum == 15, 999);
    }
}


//# run 0xFEED::SpecChecks::validate_spec --signers 0x0


//# publish
module 0xDEAD::InlineAndInteraction {
    // Inline function called in multiple places
    public inline fun helper_mul(x: u64, y: u64): u64 {
        x * y
    }

    // Function that calls inline function
    public fun compute_area(length: u64, width: u64): u64 {
        helper_mul(length, width)
    }

    public fun main() {
        let area = compute_area(4, 5);
        assert!(area == 20, 999);
    }
}


//# run 0xDEAD::InlineAndInteraction::main --signers 0x0


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 94d2a0057c5835a2cca11ee17e438e31: Define functions as inline to enable inlining during compilation.
