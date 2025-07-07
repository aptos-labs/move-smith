
//# publish
module 0xCAFE::FeatureTestModule {
    use std::vector;

    const TEST_CONST: u64 = 123456789;

    struct ResourceStruct has key, store {
        id: u64,
        name: vector<u8>,
    }

    // Specification annotations are not a real Move feature but used here for demonstration
    public fun spec_function(x: u8): u8 acquires ResourceStruct {
        // acquire permission for ResourceStruct
        x
    }

    // Function with acquire permission on global resource or specific resource
    public fun with_resource_acquire(resource_ref: &ResourceStruct): bool acquires ResourceStruct {
        // potentially manipulate resource
        resource_ref.id == 42
    }

    // Declaring a deprecated module - the compiler should warn about its usage
    module 0xCAFE::DeprecatedModule {
        // This module is deprecated, but for testing, we include it.
        public fun deprecated_function(): u8 {
            0
        }
    }

    // Function that calls deprecated, should trigger deprecation warning
    public fun use_deprecated() {
        let _ = 0xCAFE::DeprecatedModule::deprecated_function();
    }

    // Function with assertions and explicit specification
    public fun check_value(x: u64): bool {
        assert!(x > 0, 999);
        x < 10000
    }

    // Function with an inline lambda that manipulates vector
    public fun process_vector(input: vector<u8>): vector<u8> {
        let lambda: |vector<u8>| vector<u8> = |v: vector<u8>| {
            let result = v;
            vector::push_back(&mut result, 255u8);
            result
        };
        lambda(input)
    }

    // Function with nested match expression
    public fun nested_match(e: E): u8 {
        match e {
            E::V1 => 1,
            E::V2(a, b) => match a {
                0 => 0,
                _ => b as u8,
            },
            E::V3 { a } => if (a) { 255 } else { 0 },
        }
    }

    // Function demonstrating the use of type parameter with resource
    public fun generic_resource_function<T: copy + drop + store>(t: T): T {
        // Just return the input
        t
    }

    // Main runner function to call various features
    public fun run_all() {
        let res = ResourceStruct {id: TEST_CONST, name: vector::empty<u8>()};
        // Example of acquiring resource
        let _ = with_resource_acquire(&res);
        // Use deprecated function
        use_deprecated();
        // Check value assertions
        let _ = check_value(500);
        // Process vector
        let v = vector::empty<u8>();
        let new_v = process_vector(v);
        // Use nested match
        let e = E::V2(0, 42);
        let _ = nested_match(e);
        // Use generic resource function
        let _ = generic_resource_function::<u64>(99);
    }
}


//# run 0xCAFE::FeatureTestModule::run_all --signers 0xBADADE


//# publish
module 0xCAFE::MainScript {
    use std::signer;
    use 0xCAFE::FeatureTestModule;

    // Script to test attribute usage
    public script {
        fun main(signer: &signer) {
            // Call functions from FeatureTestModule
            FeatureTestModule::run_all();
            let res = ResourceStruct {id: 42, name: vector::empty<u8>()};
            // Acquire resource explicitly
            let _ = FeatureTestModule::with_resource_acquire(&res);
            // call check_value directly
            let _ = FeatureTestModule::check_value(200);
            // Call process_vector with a sample vector
            let v = vector::empty<u8>();
            let _ = FeatureTestModule::process_vector(v);
        }
    }
}


//# run 0xCAFE::MainScript::main --signers 0xBABE --args

// Featurres:
// 2547807e4d5b91edc1a1d1eabd2344db: Write scripts that include attributes, uses, constants, functions, and specifications.
// d9b03363776d57f6f09d4dd1d0f833cf: Annotate functions with acquire permissions to specify which resources are acquired during execution.
// e33086d55e99e70fb78d464961a7ec1d: Understand that the compiler will warn or provide diagnostics when deprecated modules are used, encouraging migration to non-deprecated modules.
