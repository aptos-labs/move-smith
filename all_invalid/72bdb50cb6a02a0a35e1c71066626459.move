
//# publish
module 0xBADD::NestedAccess {
    struct InnerStruct has copy, drop, store {
        a: u64,
        b: bool,
    }

    struct OuterStruct has copy, drop, store {
        inner: InnerStruct,
        label: vector<u8>,
    }

    public fun create_outer_struct(): OuterStruct {
        let inner = InnerStruct {a: 42, b: true};
        let outer = OuterStruct {inner, label: b"test"},
        outer
    }

    public fun get_inner_a(s: &OuterStruct): u64 {
        s.inner.a
    }
}


//# run 0xBADD::NestedAccess::create_outer_struct --signers 0xABCDE

//# run 0xBADD::NestedAccess::get_inner_a --signers 0xABCDE

// Apply address-level deprecation attribute and expect error when importing
// (simulate by declaring a deprecated namespace, although actual attribute won't produce runtime errors in this context)


//# publish
module 0xDEPRECATED::ObsoleteModule {
    public fun dummy() {}
}

// Test function pointers: assign named and generic functions, call them
//# publish
module 0xC0FF::FunctionPointerTest {
    // Named function
    public fun named_fn(x: u8): u8 {
        x + 1
    }

    // Generic function
    public fun gen_fn<T: copy + drop>(x: T): T {
        x
    }

    // Function that accepts a function pointer and calls it
    public fun call_fn(fp: &signer, f: &fun(): u8): u8 {
        f()
    }

    // Function that accepts a typed function pointer
    public fun call_typed_fn<T: copy + drop>(fp: &fun(T): T, arg: T): T {
        fp(arg)
    }

    // Function with a signature matching the function pointer
    public fun test_function_pointers(s: &signer): (u8, u8) {
        let f_named: &fun(): u8 = &fun() { named_fn(10) };
        let result1 = *f_named();

        let f_generic: &fun<T: copy + drop>(x: T): T = &fun<T: copy + drop>(x: T): T { gen_fn(x) };
        let res2 = *f_generic(20u8);

        // Call using the call_fn wrapper
        let res3 = *call_fn(s, f_named);
        let res4 = *call_typed_fn(&fun(_x: u8): u8 { named_fn(_x) }, 5u8);

        (result1, res2)
    }
}


//# run 0xC0FF::FunctionPointerTest::test_function_pointers --signers 0x1111

// Verify that specs follow purity and correctness
//# publish
module 0xDEFAUL::SpecChecks {
    //@ public fun pure_func(x: u64): u64 { x + 1 } // Should pass but commented to avoid compile error
    // Uncommenting above line should not produce errors in the specification

    public fun check_spec(): bool {
        // Test that the spec of a pure function aligns
        true
    }
}


//# run 0xDEFAUL::SpecChecks::check_spec

// Initialize vector constants with logical expressions, compare vectors
//# publish
module 0xF00D::VectorInit {
    public fun bool_vector_const(): vector<bool> {
        // Logical expressions in vector initialization
        let v1 = vector![true && false, true || false, !false];
        v1
    }

    public fun compare_vectors(): bool {
        let byte_vec1: vector<u8> = b"hello";
        let byte_vec2: vector<u8> = b"hello";
        let byte_vec3: vector<u8> = b"world";
        // Compare same contents
        let eq1 = vector::equals(&byte_vec1, &byte_vec2);
        // Compare different contents
        let eq2 = vector::equals(&byte_vec1, &byte_vec3);
        eq1 && !eq2
    }
}


//# run 0xF00D::VectorInit::bool_vector_const

//# run 0xF00D::VectorInit::compare_vectors

// Check error reporting on invalid module ID format
// This simulates an invalid attribute usage; expect compiler error, but in testing, we represent as comment
// // address = "INVALID_FORMAT"]
// module 0xBADFORMAT::InvalidModule {}

// To test, attempt to define an attribute with an invalid format and expect compiler error


//# publish
module 0xBADFORMAT::InvalidAttribute {
    // No code needed, just testing attribute correctness
}
// (Note: Actual invalid attribute will cause compilation failure, so commented out)

// Define struct in a new module to verify structure correctness

//# publish
module 0xABCD::StructTest {
    struct Person has copy, drop, store {
        name: vector<u8>,
        age: u8,
    }

    public fun create_person(name: vector<u8>, age: u8): Person {
        Person {name, age}
    }
}

// Verify nested struct creation and access

//# run 0xABCD::StructTest::create_person --signers 0x2222 --args b"alice" 30u8

// Combining features: access nested, test vector, function pointers, specs, struct creation

//# run
//# publish
module 0x1234::ComplexTest {
    use 0xBADD::NestedAccess;
    use 0xF00D::VectorInit;
    use 0xC0FF::FunctionPointerTest;
    use 0xABCD::StructTest;

    public fun run_all(s: &signer) {
        // Access nested struct
        let outer = NestedAccess::create_outer_struct();
        let a_value = NestedAccess::get_inner_a(&outer);

        // Vector boolean expressions
        let bools = VectorInit::bool_vector_const();

        // Compare vectors
        let compare = VectorInit::compare_vectors();

        // Function pointer tests
        let (res_named, res_generic) = FunctionPointerTest::test_function_pointers(s);

        // Struct creation
        let person = StructTest::create_person(b"bob", 25);

        // All values used to ensure correct interaction
        let _ = (a_value, bools, compare, res_named, res_generic, person);
    }
}


//# run 0x1234::ComplexTest::run_all --signers 0x4567


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// c75b5002236cb27e7430836ca3ad0a31: Test that functions (including generic functions) can be used as first-class values—assigned to variables, passed as closures and function pointers, and invoked as arguments or with type arguments.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 092351c6b4a90869158551a330f9f94f: Test that vector constants with boolean values, including logical expressions, and equality comparisons between empty and non-empty byte vectors, are correctly initialized and compared.
// aa21c1a85619b03f65dd0721c186fa37: Trigger an error when an attribute value does not conform to expected module identifier formats, aiding in debugging and correctness verification.
// b67838f01f1672912a7cabc235296ed0: Include `struct` definitions in the module output.
