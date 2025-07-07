//# publish
module 0xABC::arith_ops {
    /// Function to perform various bitwise and arithmetic operations and return a tuple of results
    public fun test_operations() {
        // Byte and hexadecimal comparisons
        let a: u8 = 0xA5; // 165 in decimal
        let b: u8 = 0x5A; // 90 in decimal
        let c: bool = a > b;       // true
        let d: bool = a < b;       // false
        let e: bool = a == 165;    // true
        let f: bool = b != 0;      // true
        
        // Logical operators
        let g = a > b && e;       // true && true -> true
        let h = a < b || f;       // false || true -> true
        let i = !(a == b);        // !false -> true

        // Bitwise shifts
        let shift_left = (a as u16) << 3; // 165 << 3 = 1320
        let shift_right = (a as u16) >> 2; // 165 >> 2 = 41

        // Arithmetic operations
        let sum = a as u16 + b as u16;    // 165 + 90 = 255
        let diff = a as i16 - b as i16;   // 165 - 90 = 75
        let product = a as u16 * b as u16; // 165 * 90 = 14850
        let quotient = (a as u16) / (b as u16); // 165 / 90 = 1
        let remainder = (a as u16) % (b as u16); // 165 % 90 = 75

        // Bitwise AND, OR, XOR
        let and_op = a & b; // 0xA5 & 0x5A = 0x00
        let or_op = a | b;  // 0xA5 | 0x5A = 0xFF
        let xor_op = a ^ b; // 0xA5 ^ 0x5A = 0xFF

        // Asserting operations (could be ignored, but included for completeness)
        assert!(c, 0);
        assert!(!d, 1);
        assert!(e, 2);
        assert!(f, 3);
        assert!(g, 4);
        assert!(h, 5);
        assert!(i, 6);
        assert!(shift_left == 1320, 7);
        assert!(shift_right == 41, 8);
        assert!(sum == 255, 9);
        assert!(diff == 75, 10);
        assert!(product == 14850, 11);
        assert!(quotient == 1, 12);
        assert!(remainder == 75, 13);
        assert!(and_op == 0x00, 14);
        assert!(or_op == 0xFF, 15);
        assert!(xor_op == 0xFF, 16);
    }
}

 //# run 0xABC::arith_ops::test_operations

//# publish
module 0xDEF::nested_functions {
    // Returns a closure that adds a captured value
    fun create_adder(capture: u64): |u64| u64 {
        |x| capture + x
    }

    // Returns a closure that multiplies by a captured value
    fun create_multiplier(capture: u64): |u64| u64 {
        |x| capture * x
    }

    // Test nested function captures sending closures around
    public fun test_nested_closures() {
        let add_ten = create_adder(10);
        let add_ten_result = add_ten(5); // 10 + 5 = 15

        let multiply_by_three = create_multiplier(3);
        let multiply_result = multiply_by_three(4); // 3 * 4 = 12

        assert!(add_ten_result == 15, 0);
        assert!(multiply_result == 12, 1);

        // Nested captures, simulate with chained closures
        let outer_capture = 7;
        let inner_closure = |x| |y| outer_capture + x * y;
        let inner_func = inner_closure(2); // |y| 7 + 2 * y
        assert!(inner_func(3) == 13, 2); // 7 + 2*3 =13
    }

    // Test function composition with captured variables
    public fun test_function_composition() {
        let base = 2;
        let compose_mult_add = |x| |y| (x + y) * base;
        let result = compose_mult_add(3)(4); // (3+4)*2=14
        assert!(result == 14, 3);
    }
}

//# run 0xDEF::nested_functions::test_nested_closures
//# run 0xDEF::nested_functions::test_function_composition

//# publish
module 0x123::resource_initializer {
    // A resource with some data
    struct DataResource has key {
        value: u64,
    }

    // Function to initialize the resource (simulate a factory)
    public fun make_resource(account: &signer, init_value: u64) {
        move_to(account, DataResource { value: init_value });
    }

    // Function to create a resource via a closure
    public fun create_resource_via_closure(account: &signer, init_value: u64) {
        let factory = || {
            move_to(account, DataResource { value: init_value });
        };
        factory();
    }
}

//# publish
module 0x456::test {
    use 0x123::resource_initializer;

    fun run(account: &signer) {
        // Call make_resource directly
        resource_initializer::make_resource(account, 42);

        // Call create_resource_via_closure
        resource_initializer::create_resource_via_closure(account, 99);
    }
}

//# run 0x456::test::run --signers 0x0
