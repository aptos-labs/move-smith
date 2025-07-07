
//# publish
module 0xBADDAD::AddressValidation {
    // This module is to test address registration and validation.
    use std::signer;

    // Storage for registered module addresses
    struct ModuleRegistry has store, key {
        addr_list: vector<address>,
    }

    public fun initialize_registry(s: signer) {
        let registry = ModuleRegistry { addr_list: vector::empty<address>() };
        move_to<ModuleRegistry>(&s, registry);
    }

    public fun register_module(s: signer, addr: address) {
        let registry_ref: &mut ModuleRegistry = borrow_global_mut<ModuleRegistry>(signer::address_of(&s));
        // Check for duplicates
        let exists = vector::contains(&registry_ref.addr_list, &addr);
        if (exists) {
            // Duplicate registration, abort
            abort 1;
        }
        vector::push_back(&mut registry_ref.addr_list, addr);
    }

    public fun check_duplicate(addr: address): bool {
        // Returns true if duplicate is found
        // For testing purposes, simulate a lookup
        // Note: In real test, we would access stored registry, but here we simply check if address is in a vector
        // As a placeholder, just return false, since the test code will call 'register_module' twice with same address
        false
    }
}


//# run 0xBADDAD::AddressValidation::initialize_registry --signers 0xCAFE


//# run 0xBADDAD::AddressValidation::register_module --signers 0xCAFE --args 0xDEADBEEF // Register a new module address

//# run 0xBADDAD::AddressValidation::register_module --signers 0xCAFE --args 0xDEADBEEF // Attempt duplicate registration, should abort


//# publish
module 0xFACE::LiteralTest {
    // This module tests literals in expressions and functions
    use std::vector;

    // Function that uses different literals
    public fun test_literals() {
        let num: u32 = 123u32;
        let bool_val: bool = true;
        let byte_str: vector<u8> = b"Tester";

        // Use all literals in some expressions
        let sum = num + 10u32;
        let flag = !bool_val;
        let byte_count = vector::length(&byte_str);

        // To verify expressions
        assert!(sum == 133u32, 1);
        assert!(flag == false, 2);
        assert!(byte_count == 6, 3);
    }

    // Function with various literal types in parameters
    public fun process_literals(
        number: u64,
        flag: bool,
        data: vector<u8>
    ): (u64, bool, u8) {
        (number + 1u64, !flag, *vector::borrow(&data, 0))
    }
}


//# run 0xFACE::LiteralTest::test_literals


//# run 0xFACE::LiteralTest::process_literals --args 42u64 true b"data"


//# publish
module 0xTREE::FunctionSignatureTest {
    // This module tests functions with various signatures, including optional and generic parameters
    use std::vector;

    // Basic function with no parameters
    public fun no_param_func(): u8 {
        42
    }

    // Function with multiple type parameters, including optional ones via default values (simulate via overloads)
    public fun generic_func<T: copy+drop>(x: T): T {
        x
    }

    // Function with a vector parameter
    public fun vector_param(v: vector<u8>): u8 {
        vector::length(&v) as u8
    }

    // Function with optional-like behavior via overload (simulate optional)
    public fun optional_param(x: u8, optional_y: Option<u8>): (u8, Option<u8>) {
        (x, optional_y)
    }
}


//# run 0xTREE::FunctionSignatureTest::no_param_func


//# run 0xTREE::FunctionSignatureTest::generic_func --args 0x1 // Passing a type argument is handled during call, but in move testing, type args are part of call syntax, so assume call is valid


//# run 0xTREE::FunctionSignatureTest::vector_param --args  e.g. no args needed, called by the runner


//# run 0xTREE::FunctionSignatureTest::optional_param --args 8u8  --signers 0xCAFE
// Since optional parameters are simulated via options, the test can pass empty options or specific option values

// Note: Because Move does not support optional function parameters directly, the test checks calling overloads or in-place options.


// Featurres:
// fb32f3b3b1dcf46b73265725e707d593: Specify the address for a Move module, which can be checked for redundancy and correctness.
// d52e9087944003edc064087a8ad86564: Use literals in expressions, including numbers, booleans, and byte strings.
// 161e7adce5b7c3f41de21542ac64ac82: Define function signatures with optional type parameters in specifications.
