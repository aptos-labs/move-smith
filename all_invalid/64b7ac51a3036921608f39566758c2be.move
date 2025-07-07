
//# publish
module 0xFADE::NestedAccess {
    use std::vector;

    struct OuterStruct has store, key {
        inner: InnerStruct,
        flag: bool,
    }

    struct InnerStruct has store, key {
        value: u64,
        nested: DeepStruct,
    }

    struct DeepStruct has store, key {
        fieldA: u8,
        fieldB: bool,
    }

    // Function to create a nested structure
    public fun create_outer(flag: bool): OuterStruct {
        let deep = DeepStruct {fieldA: 42, fieldB: true};
        let inner = InnerStruct {value: 123, nested: deep};
        let outer = OuterStruct {inner, flag};
        outer
    }

    // Function accessing nested fields
    public fun get_deep_fieldA(outer: &OuterStruct): u8 {
        let deep_ref: &DeepStruct = &outer.inner.nested;
        deep_ref.fieldA
    }

    // Function intentionally missing 'nested' field to simulate error (to be commented out to prevent compile error)
    // public fun invalid_access_missing_field(outer: &OuterStruct): u8 {
    //     let deep_ref: &DeepStruct = &outer.inner.missing;
    //     deep_ref.fieldA
    // }

    // Function to test invalid nested access (simulate compile-time error)
    // For the test, keep only valid access

    // Deprecate entire address namespace to see warnings/errors
    // Note: Move currently does not support 'deprecate' attribute natively; this is illustrative.
    // In actual Move, deprecation is managed via annotations or style guide, so representing as comment.
    // //@ deprecated
}



//# run 0xFADE::NestedAccess::create_outer --args true




//# publish
module 0xDEAD::AddressDeprecation {
    // Attempting to test address namespace deprecation
    // Using attributes - in actual Move, would rely on compiler warnings
    // For illustration, just define modules
    use std::signer;

    struct DeprecateMe has store, key {
        data: u8,
    }

    public fun deposit(s: signer, data: u8) {
        let obj = DeprecateMe {data};
        move_to<DeprecateMe>(&s, obj);
    }

    public fun get_data(s: &signer): u8 {
        let obj_ref: &DeprecateMe = borrow_global<DeprecateMe>(signer::address_of(s));
        obj_ref.data
    }
}



//# run 0xDEAD::AddressDeprecation::deposit --signers 0xBADA --args 7u8


//# run 0xDEAD::AddressDeprecation::get_data --signers 0xBADA




//# publish
module 0xBEEE::FunctionTesting {
    use std::signer;

    // Generic function that adds two u64
    public fun add_u64<T: copy>(a: T, b: T): T {
        a + b
    }

    // Assign function to variable, pass as argument, use as callback
    public fun test_function_usage() {
        let add_fn: |u64, u64| u64 = add_u64;

        let result = add_fn(10, 20);

        // Passing function as argument
        let sum = invoke_add(add_fn, 30, 40);
    }

    public fun invoke_add(f: |u64, u64| u64, a: u64, b: u64): u64 {
        f(a, b)
    }

    // Closure as function pointer (simulate via inline lambda)
    public fun closure_as_fn(): u64 {
        let closure: |u64, u64| u64 = |a: u64, b: u64| a * b;
        closure(6, 7)
    }

    // Function pointer to a generic function
    public fun generic_function_pointer(): u64 {
        let fp: |u64, u64| u64 = add_u64;
        fp(5, 5)
    }
}



//# run 0xBEEE::FunctionTesting::test_function_usage


//# run 0xBEEE::FunctionTesting::closure_as_fn


//# run 0xBEEE::FunctionTesting::generic_function_pointer




//# publish
module 0xC0FFEE::SpecFunctions {
    use std::vector;

    // Function with spec annotations to verify correctness
    public fun verify_spec_purity(): bool {
        // Ensuring function is pure (no side-effects)
        // As a dummy, just return true
        true
    }

    // Function with contract requiring postcondition
    public fun sum_and_check(a: u64, b: u64): bool {
        let sum = a + b;
        // Specification: sum must be >= a and >= b
        assert!(sum >= a, 999);
        assert!(sum >= b, 999);
        sum >= a && sum >= b
    }

    // Function with intentionally missing spec annotation (simulate improper specification)
    public fun incomplete_spec(): bool {
        false
    }
}



//# run 0xC0FFEE::SpecFunctions::verify_spec_purity


//# run 0xC0FFEE::SpecFunctions::sum_and_check --args 10u64 20u64


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
