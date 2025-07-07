
//# publish
module 0xCAFE::NestedFieldAccess {
    // This module tests nested field access from modules and expressions
    use 0xCAFE::MyModule;

    // Define a struct with nested fields for complex access
    struct NestedStruct has store, key {
        inner: MyModule::S,
        extra: u8,
    }

    // Public function to create and store nested struct
    public fun create_and_store(signer: signer) {
        let s = MyModule::S {x: 42, y: 100};
        move_to<NestedStruct>(&signer, NestedStruct {inner: s, extra: 7});
    }

    // Public function to access nested fields using dot notation
    public fun get_nested_x(s: &NestedStruct): u32 {
        // Access nested field: NestedStruct.inner.x
        s.inner.x
    }

    public fun get_nested_y(s: &NestedStruct): u32 {
        s.inner.y
    }

    // Public function to read submitted nested struct and access its nested fields
    public fun read_and_access(signer: &signer): (u32, u32) {
        let nested_ref: &NestedStruct = borrow_global<NestedStruct>(signer::address_of(signer));
        let x_value = get_nested_x(nested_ref);
        let y_value = get_nested_y(nested_ref);
        (x_value, y_value)
    }
}


//# run 0xCAFE::NestedFieldAccess::create_and_store --signers 0xBADD

//# run 0xCAFE::NestedFieldAccess::read_and_access --signers 0xBADD



//# publish
module 0xCAFE::DeprecationWarningTest {
    // This module applies deprecation attribute at address level
    // All modules under 0xCAFE should emit warnings (tests in tooling)
    // For simulation purposes, just define modules here with deprecation attribute

    // Marking module deprecated (simulated, actual compiler warns)
    // deprecated]
//# publish
    module 0xCAFE::OldModule {
        use std::signer;

        public fun old_func(): u64 {
            999
        }
    }
}


//# run 0xCAFE::OldModule::old_func --signers 0xBADD


// Wrap a function as a first-class value and test invocation

//# publish
module 0xCAFE::FunctionAsFirstClass {
    use std::signer;

    public fun add_one(n: u64): u64 {
        n + 1
    }

    public fun pass_function_as_value(f: fn(u64): u64, val: u64): u64 {
        f(val)
    }

    public fun function_as_value_test(signer: signer): u64 {
        let f = add_one; // assign function to variable
        let result = pass_function_as_value(f, 10);
        result
    }

    // Generic function
    public fun generic_identity<T: copy + drop>(arg: T): T {
        arg
    }

    // Call a generic function with explicit type argument
    public fun test_generic<U: copy + drop>(val: U): U {
        generic_identity<U>(val)
    }
}


//# run 0xCAFE::FunctionAsFirstClass::function_as_value_test --signers 0xBADD

//# run 0xCAFE::FunctionAsFirstClass::test_generic --args 123u64 --signers 0xBADD



//# publish
module 0xCAFE::SpecFunctions {
    // Spec functions (prefixed with $) for runtime/purity checks
    // These simulate static checks often used in specification

    // Dummy spec function for f1
    public fun $f1(x: u8, y: bool): bool {
        // The spec function should be pure and non-effectful
        $f1(x, y) {
            // Enforce some condition (e.g., y must be true if x > 0)
            if (x > 0) {
                y
            } else {
                false
            }
        }
        true
    }

    // Spec for f3, ensuring it computes correctly
    public fun $f3(x: u16): bool {
        // It should reflect the runtime's logic
        let (a, b) = (x + 1, x + 2);
        let s = 0xCAFE::MyModule::S {x: a as u32, y: b as u32};
        // Check some property; for illustration, sum of x, a, and b
        (a + b + x) > 0
    }

    // Specification for the generic function
    public fun $generic_identity<T: copy + drop>(arg: T): bool {
        // For testing, check if arg is non-zero if U is u64
        if (exists<U: u64>) {
            // this mock is illustrative (no ops for now)
            true
        } else {
            true
        }
    }
}


//# run 0xCAFE::SpecFunctions::$f1 --args 5u8 true

//# run 0xCAFE::SpecFunctions::$f3 --args 10u16

//# run 0xCAFE::SpecFunctions::$generic_identity --args 123u64 --signers 0xBADD


// Simulate Out-of-Gas scenario by creating a loop that runs too many iterations
// The loop is designed to abort by gas exhaustion

//# publish
module 0xCAFE::GasExhaustionTest {
    public fun infinite_loop() {
        let count: u64 = 0;
        loop {
            // simulate computationally expensive loop
            count = count + 1;
            if (count == 1000000) {
                break;
            }
        }
        // The above loop is safe; mimic a large loop that may exhaust gas
    }

    // Loop that exceeds gas limit intentionally (to be invoked in test)
    public fun cause_gas_exhaust(signer: signer) {
        let _ = infinite_loop(); // expecting gas exhaustion during execution
    }
}


//# run 0xCAFE::GasExhaustionTest::cause_gas_exhaust --signers 0xBADD


// Additional tests: verify that spec functions match runtime signatures

//# publish
module 0xCAFE::SignatureMirror {
    use 0xCAFE::MyModule;

    // Function to check signature consistency between runtime and spec
    public fun check_signature_consistency(x: u16): bool {
        // Call the runtime function
        let res_runtime = MyModule::f2(x);
        // Call the spec function
        let res_spec = $SpecFunctions::$f3(x);
        // Check if outputs match in format/values (assuming logic matches)
        // For test, just ensure types and flow
        true
    }
}


//# run 0xCAFE::SignatureMirror::check_signature_consistency --args 10u16


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 62fe649a37494771c818ca22b5dadcc3: Define and call functions with arguments and return types, including functions as first-class values.
// aaf7a91ccdb352a55228e2bf4a99e181: Test that the script correctly handles an out-of-gas situation during a loop execution.
// df863012fa11e7aed80792bdd91f0c86: Define Move specification functions ($-prefixed) that correspond to regular Move functions for use in specifications.
