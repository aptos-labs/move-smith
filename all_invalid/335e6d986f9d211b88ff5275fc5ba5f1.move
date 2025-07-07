
//# publish
module 0xBABE::TestArithmetic {
    use std::vector;

    struct TestStruct has copy, drop, store {
        a: u8,
        b: u8,
    }

    // Function to test arithmetic operations
    public fun perform_arithmetic(x: u8, y: u8): u8 {
        let sum = x + y;
        let diff = x + y; // Since no negative, simulate subtraction with addition
        let prod = x * y;
        let div = if (y != 0) { x / y } else { 0 };
        let res = sum + prod + div;
        res
    }

    // Function to test mutable reference modifications
    public fun modify_and_pass(x: &mut u8, y: u8): u8 {
        *x = *x + y;
        *x
    }

    // Runner function to execute internal test logic
    public fun run_tests() {
        // Local variable for arithmetic operations
        let a = 4u8;
        let b = 5u8;

        let result1 = perform_arithmetic(a, b);

        // Mutable local variable for modification test
        let local_x = 10u8;
        let mod_result = modify_and_pass(&mut local_x, 3u8);

        // Instantiate a struct and check its fields
        let my_struct = TestStruct { a: 7, b: 8 };
        let sum_struct_fields = my_struct.a + my_struct.b;

        (result1, mod_result, sum_struct_fields)
    }
}


//# run 0xBABE::TestArithmetic::run_tests


// Featurres:
// c27bfd0ddff886e382b79619db313d1a: Organize spec block contents using a syntax that allows multiple 'use' declarations and members inside braces.
// 40e9b604023b26824a1ede5bb925b701: Test that functions can perform arithmetic operations and handle mutable references by modifying local variables and passing references to other functions.
// 571535d76ec45523fbe6cc5de0eeba0f: Use leading name access for identifiers and addresses in your code
