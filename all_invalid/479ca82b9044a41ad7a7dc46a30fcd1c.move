
//# publish
module 0xDEAD::CompilerVMMiscTests {
    use std::signer;

    // Basic function returning a constant u8
    public fun get_const_u8(): u8 {
        42u8
    }

    // Function that takes an input u8 and returns it
    public fun echo_u8(input: u8): u8 {
        input
    }

    // Function with multiple parameters and returns their sum
    public fun sum_u32(a: u32, b: u32): u32 {
        a + b
    }

    // Function that assigns a value to a variable and reassigns it
    public fun variable_reassignment(): u8 {
        let x = 10u8;
        x = x + 1;
        x
    }

    // Function that tests copying variables and maintaining correctness after reassignments
    public fun copy_and_reassign(x_input: u8): u8 {
        let y = x_input;
        let y_copy = y;
        let y_reassigned = y_copy + 1;
        y_reassigned
    }

    // Function that tests assertions on values and reassignments
    public fun test_assertions(input1: u16, input2: u16): u16 {
        let a = input1;
        let b = input2;
        let c = a + b;

        // Reassign a variable after some computation
        let a = c;
        // Assert that a equals the sum of input1 and input2
        assert!(a == input1 + input2, 999);
        // Assert that b remains unchanged
        assert!(b == input2, 888);
        a
    }

    // Function that covers nested variable usage and multiple reassignments
    public fun nested_reassignments(val: u8): u8 {
        let v = val;
        v = v + 1;
        let v2 = v;
        v2
    }

    // Function that tests passing constants and verifying the return values
    public fun constant_flow_test(): u8 {
        let c = get_const_u8();
        let r = echo_u8(c);
        r
    }

    // Function that combines multiple tests: reassignments, copying, assertions
    public fun comprehensive_test(x: u16, y: u16): u16 {
        // Copy parameter
        let x_copy = x;
        // Reassign variable
        let x = x_copy + 1;

        // Use the previous function to verify constants
        let c_flow = constant_flow_test();

        // Verify the flow of constants and parameters
        let sum_result = sum_u32(x as u32, y as u32);
        // Assert correctness
        assert!(sum_result >= 0, 777);
        // Final output combines previous computations
        let result = x + y + c_flow as u16;
        result
    }

    // Main function to run all tests and verify correctness
    public fun run_all_tests() {
        // Testing get_const_u8
        let const_val = get_const_u8();
        assert!(const_val == 42u8, 1000);

        // Testing echo with input
        let echo_val = echo_u8(55u8);
        assert!(echo_val == 55u8, 1001);

        // Testing sum function
        let sum_val = sum_u32(10, 20);
        assert!(sum_val == 30, 1002);

        // Testing variable reassignment
        let v_reassign = variable_reassignment();
        assert!(v_reassign == 11, 1003);

        // Testing copy and reassign
        let copy_result = copy_and_reassign(15u8);
        assert!(copy_result == 16, 1004);

        // Testing assertions and variable handling
        let a_result = test_assertions(3u16, 4u16);
        assert!(a_result == 7, 1005);

        // Test nested reassignments
        let nested = nested_reassignments(5u8);
        assert!(nested == 6, 1006);

        // Test constant flow
        let flow_const = constant_flow_test();
        assert!(flow_const == 42u8, 1007);

        // Complete comprehensive test
        let comp = comprehensive_test(10u16, 20u16);
        assert!(comp >= 31u16, 1008);
    }
}

//# run 0xDEAD::CompilerVMMiscTests::run_all_tests


// Featurres:
// 977fad2fa0781ea83cd7a6c7ba768d27: Test that functions correctly return constant values or input parameters and that assertions in the main function verify expected results.
// 16fb619de252412c464b95bc01d8ea85: Use function signatures to precisely define input and output types for your functions.
// 9d05abcbe52bdb276e6f8b0ddd4c443d: Test that copy propagation and variable assignments work correctly when variables are reassigned and used after being copied in function bodies.
