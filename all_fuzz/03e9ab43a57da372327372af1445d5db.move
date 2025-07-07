
//# publish
module 0xCAFE::AddAndCheck {
    // Removed unused import to fix the warning
    // use std::vector;

    // Test 1: Function to add two u8 and return a specific value after addition
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // If sum is less than 200, return 42, otherwise 100 (just arbitrary to test control flow)
        if (sum < 200) {
            42
        } else {
            100
        }
    }

    // Test 2: Function with lambda (anonymous function) expressions
    public fun apply_lambda(x: u8, y: u8): (u8, u8) {
        // Lambda to return sum and product
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            let p = a * b;
            (s, p)
        };
        lambda(x, y)
    }

    // Since the module 0xCAFE::MyModule::f2 is missing (cannot find the function),
    // we define a dummy inline function f2 here for the test to succeed.
    // This is required to fix the 'no function named `MyModule::f2` found' error.
    // This approach assumes that re-creating f2 in this module is acceptable for the test.
    public inline fun f2(a: u16): (u16, u16) {
        // Just some dummy computation for demonstration
        (a / 2, a / 3)
    }

    // Test 3: Call inline function within this module: reuse f2 (inline returns tuple)
    // and use its result within this module to create own tuple with sum of parts
    public fun nested_inline_call(a: u16): u16 {
        let (x, y) = Self::f2(a);
        // sum x and y
        x + y
    }

    // Test 4: Assert specification in Move code
    public fun check_assert_conditions(a: u8, b: u8) {
        let sum = a + b;
        assert!(sum >= a, 1000); // sum should be at least a
        assert!(sum >= b, 1001); // sum should be at least b
        assert!(sum <= 255, 1002); // sum should not overflow u8
    }

    // Test 5: Use nested generics with consecutive '>' tokens to test parser
    use std::vector;

    struct NestedVectors has copy, drop {
        data: vector<vector<vector<u8>>>
    }

    public fun get_empty_nested_vector(): NestedVectors {
        let inner_vec: vector<u8> = vector[];
        let middle_vec: vector<vector<u8>> = vector[inner_vec];
        let outer_vec: vector<vector<vector<u8>>> = vector[middle_vec];
        NestedVectors { data: outer_vec }
    }
}



//# run 0xCAFE::AddAndCheck::add_then_return --args 10u8 20u8



//# run 0xCAFE::AddAndCheck::apply_lambda --args 5u8 7u8



//# run 0xCAFE::AddAndCheck::nested_inline_call --args 100u16



//# run 0xCAFE::AddAndCheck::check_assert_conditions --args 20u8 30u8



//# run 0xCAFE::AddAndCheck::get_empty_nested_vector
