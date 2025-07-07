
//# publish
module 0xCAFE::BoolOperatorsTests {
    use std::assert;
    use std::signer;
    use std::vector;

    // Helper function for logical AND tests
    public fun test_and(a: bool, b: bool): bool {
        a && b
    }

    // Helper function for logical OR tests
    public fun test_or(a: bool, b: bool): bool {
        a || b
    }

    // Helper function for negation tests
    public fun test_not(a: bool): bool {
        !a
    }

    // Run comprehensive boolean truth table tests
    public fun run_boolean_tests() {
        // All combinations for &&, ||, and !
        let res_and_00 = test_and(false, false);
        assert!(res_and_00 == false, 0);
        let res_and_01 = test_and(false, true);
        assert!(res_and_01 == false, 1);
        let res_and_10 = test_and(true, false);
        assert!(res_and_10 == false, 2);
        let res_and_11 = test_and(true, true);
        assert!(res_and_11 == true, 3);

        let res_or_00 = test_or(false, false);
        assert!(res_or_00 == false, 4);
        let res_or_01 = test_or(false, true);
        assert!(res_or_01 == true, 5);
        let res_or_10 = test_or(true, false);
        assert!(res_or_10 == true, 6);
        let res_or_11 = test_or(true, true);
        assert!(res_or_11 == true, 7);

        let res_not_00 = test_not(false);
        assert!(res_not_00 == true, 8);
        let res_not_01 = test_not(true);
        assert!(res_not_01 == false, 9);
    }
}


//# run 0xCAFE::BoolOperatorsTests::run_boolean_tests

// Script to invoke functions referencing the boolean tests
//# run
script {
    move {
        0xCAFE::BoolOperatorsTests::run_boolean_tests();
    }
}


//# run 0xCAFE::BoolOperatorsTests::run_boolean_tests


//# publish
module 0xCAFE::ScriptFunctionTests {
    // Example script function
    public fun script_function_call(x: u8) {
        assert!(x < 20, 111);
    }
}


//# run 0xCAFE::ScriptFunctionTests::script_function_call --args 15u8

// Script that uses 'script' keyword to declare a script
//# run
script {
    public script {
        move {
            // Call the existing function
            0xCAFE::ScriptFunctionTests::script_function_call(10u8);
        }
    }
}


//# run 0xCAFE::ScriptFunctionTests::script_function_call --args 10u8

// Define a module with type parameters and abilities constraints

//# publish
module 0xCAFE::TypeParamGeneric {
    use std::assert;

    // Generic struct with ability constraints
    struct Container<T: copy + drop + store> has copy, drop {
        value: T,
    }

    // Function that takes a generic type with constraints
    public fun process_generic<T: copy + drop + store>(c: Container<T>): T {
        c.value
    }

    // Function to create a container with an i32 (which has required abilities)
    public fun create_container_with_i32(val: i32): Container<i32> {
        let c = Container { value: val };
        c
    }

    // Function that uses the generic functions and structs with booleans
    public fun bool_and_generic(con: Container<bool>): bool {
        // Use boolean logic with generic stored value
        let value = con.value;
        value && true
    }
}


//# run 0xCAFE::TypeParamGeneric::create_container_with_i32 --args 42i32


//# run 0xCAFE::TypeParamGeneric::bool_and_generic --args true

// Script that uses type parameters, fields, and functions involving generics
//# run
script {
    move {
        let c = 0xCAFE::TypeParamGeneric::create_container_with_i32(99);
        let _ = 0xCAFE::TypeParamGeneric::process_generic(c);
        let bool_con = 0xCAFE::TypeParamGeneric::Container { value: false };
        let res = 0xCAFE::TypeParamGeneric::bool_and_generic(bool_con);
    }
}


// Featurres:
// 14bbaf44e939819fa9bcceb0d7d09afa: Test that the boolean operators &&, ||, and ! evaluate correctly in all cases.
// 82f755af6a64ca1b7520a8282c6064dc: Define scripts using the 'script' keyword in Move files.
// 184619619054074649b3e2fb51304916: Define type parameters with specific abilities and constraints in Move code.
