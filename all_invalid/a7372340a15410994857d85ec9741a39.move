
//# publish
module 0xCAFE::DestructuringTest {
    // Use std::assert for verification
    use std::assert;

    // Define a sample struct with multiple fields
    struct ComplexStruct has copy, drop, store {
        a: u8,
        b: bool,
        c: u16,
    }

    // Function to destructure struct into separate variables and verify correctness
    public fun destructure_struct_and_assert(s: ComplexStruct) {
        let ComplexStruct {a: a_field, b: b_field, c: c_field} = s;
        // Verify each field matches the original's after destructuring
        assert!(a_field == s.a, 1001);
        assert!(b_field == s.b, 1002);
        assert!(c_field == s.c, 1003);
        // Compose a tuple from destructured variables and verify
        let tuple = (a_field, b_field, c_field);
        // Assert tuple matches the fields
        assert!(tuple.0 == s.a, 1004);
        assert!(tuple.1 == s.b, 1005);
        assert!(tuple.2 == s.c, 1006);
    }

    // Function to create a dummy struct with hardcoded values
    public fun create_struct(a: u8, b: bool, c: u16): ComplexStruct {
        ComplexStruct {a, b, c}
    }

    // Function to destructure a tuple into variables and verify
    public fun destructure_tuple_and_assert(x: u8, y: bool, z: u16) {
        let (a, b, c) = (x, y, z);
        // Verify variables match the tuple elements
        assert!(a == x, 1010);
        assert!(b == y, 1011);
        assert!(c == z, 1012);
        // Return a value based on destructured vars
        a + c as u8
    }

    // Entry point to run all tests
    public fun run_all_tests() {
        // Prepare a struct instance
        let s = create_struct(42u8, true, 65535u16);
        destructure_struct_and_assert(s);

        // Prepare variables for tuple destructure
        let x: u8 = 7;
        let y: bool = false;
        let z: u16 = 1234;

        // Test destructuring tuple
        let sum_result = destructure_tuple_and_assert(x, y, z);

        // Final assertion to verify sum_result
        assert!(sum_result == 7 + 1234 as u8, 1020);
    }
}


// Featurres:
// 36499f1457fd267362a473b4d1314065: Perform assignments that deconstruct structs or tuples into their individual fields in a single statement
// a9363c0147e2393028a12e3b3ac1a4ca: Fail the compilation process if any errors or diagnostics are encountered.
// 977fad2fa0781ea83cd7a6c7ba768d27: Test that functions correctly return constant values or input parameters and that assertions in the main function verify expected results.
