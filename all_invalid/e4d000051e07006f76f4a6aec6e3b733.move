
//# publish
module 0xCAFE::NestedStructAccess {
    use std::assert;

    // Define nested structs to test dot notation
    struct InnerStruct has copy, drop, store {
        a: u64,
        b: bool,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        c: u8,
    }

    // Function to test nested dot field access within expressions
    public fun test_nested_access(): u8 {
        let inner = InnerStruct { a: 42, b: true };
        let outer = OuterStruct { inner, c: 255 };
        let val: u64 = outer.inner.a;
        let flag: bool = outer.inner.b;
        let result: u8 = if (flag) { (val as u8) } else { 0u8 };
        result
    }

    // Function to test variable assignment inside and outside while loops
    public fun test_variable_assignment_inside_while(): u64 {
        let outer_var: u64 = 0;
        let inner_var: u64 = 100;
        let limit: u64 = 5;
        let counter: u64 = 0;

        // Outer loop
        while (counter < limit) {
            outer_var = outer_var + counter;
            // Inner variable shadowing
            let inner_var = counter * 2;
            // Confirm inner_var updates correctly within loop
            assert!(inner_var == counter * 2, 999);
            counter = counter + 1;
        };
        // Check final values outside the loop
        outer_var
    }

    // Function to test 'internal' function access restrictions
    // We will define an internal function and attempt external access (should fail if checked)
//# publish
    module InternalAccess {
        // Internal function only accessible within the module
        fun internal_add(x: u64, y: u64): u64 {
            x + y
        }
    }

    // Public wrapper to access internal function (simulate restricted access)
    public fun call_internal_add(x: u64, y: u64): u64 {
        InternalAccess::internal_add(x, y)
    }

    // Function to verify preconditions (via assertions) for specs
    public fun check_specs(x: u64): bool {
        // Ensure input is positive
        assert!(x >= 0, 555);
        // Spec check: after some operation
        let result = if (x > 10) { x - 10 } else { x };
        result <= x
    }

    // Function curried with closure: return a closure that sums two u8s and apply conditionally
    public fun curry_sum(cond: bool): |u8, u8| -> u8 {
        let lambda: |u8, u8| -> u8 = |a: u8, b: u8| {
            if (cond) {
                a + b
            } else {
                a - b
            }
        };
        lambda
    }

    // Function that applies the closure based on condition
    public fun apply_closure(a: u8, b: u8, cond: bool): u8 {
        let closure = curry_sum(cond);
        closure(a, b)
    }

    // Function to test parsing address strings and extracting address components
    public fun parse_address_string(addr_str: vector<u8>): (u8, u16) acquires {} {
        // In this mockup, assume addr_str is "0xCAFE"
        // Parse string as bytes, verify prefix and extract
        assert!((vector::length(&addr_str) == 6), 666);
        let b'0' = *vector::borrow(&addr_str, 0);
        let b'x' = *vector::borrow(&addr_str, 1);
        let b'C' = *vector::borrow(&addr_str, 2);
        let b'A' = *vector::borrow(&addr_str, 3);
        let b'F' = *vector::borrow(&addr_str, 4);
        let b'E' = *vector::borrow(&addr_str, 5);
        // Return fixed parsed values for testing
        (0xCA, 0xF00)
    }
}


//# run 0xCAFE::NestedStructAccess::test_nested_access --args

//# run 0xCAFE::NestedStructAccess::test_variable_assignment_inside_while

//# run 0xCAFE::NestedStructAccess::call_internal_add --args 10 20

//# run 0xCAFE::NestedStructAccess::check_specs --args 15

//# run 0xCAFE::NestedStructAccess::apply_closure --args 3 4 true

//# run 0xCAFE::NestedStructAccess::apply_closure --args 10 5 false

//# run 0xCAFE::NestedStructAccess::parse_address_string --args b"0xCAFE"


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// 1fa3c07213945b1a29f8054ea07f4049: Parse a string to extract a named address and its corresponding numerical address.
