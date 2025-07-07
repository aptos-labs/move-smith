//# publish
module 0x1::arith_tests {
    use std::debug;
    use std::signer;

    /// Struct to test mutation across multiple calls
    struct Counter has key {
        count: u64,
    }

    /// Initialize the Counter resource for testing
    public fun init_counter(account: &signer) {
        move_to(account, Counter { count: 0 });
    }

    /// Mutably increments counter and returns the current value + iteration
    public fun mutate_and_get(account: &signer, iteration: u64): u64 acquires Counter {
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(account));
        counter_ref.count = counter_ref.count + 1;
        counter_ref.count + iteration
    }

    /// Function declared within script to test visibility
    public fun script_function() {
        // Do nothing, just a placeholder
    }
}

/// Function to test bitwise and arithmetic operators, and ability debug
public fun test_abilities() {
    // Create a test value
    let x: u16 = 0xFFFF;
    let y: u16 = 0x0001;

    // Addition --> expect 0x10000 (overflow) to trigger error in Move, so safe operation
    // Using checked_add to prevent panic
    let sum = std::checked_add<u16>(&x, &y);
    // Subtraction
    let diff = std::checked_sub<u16>(&x, &y);
    // Multiplication
    let prod = std::checked_mul<u16>(&x, &y);
    // Division
    let div = std::checked_div<u16>(&x, &y);
    // Modulus
    let rem = std::checked_mod<u16>(&x, &y);

    // Attempt division by zero; in move, checked_div returns Option, so simulate failure
    let div_zero = std::checked_div<u16>(&x, &0);
    // Should be None due to division by zero

    // Use operators (simulate via functions)
    assert!(x != y);
    assert!(x == 0xFFFF);
    assert!(!(x < y));
    assert!(x >= y);
    assert!(x > y);
    assert!(x <= y);
    assert!(x << 8 == 0xFF00);
    assert!(x >> 8 == 0x00FF);

    // Compound assignments
    let mut z: u16 = 10;
    z += 5; // z == 15
    z -= 3; // z == 12
    z *= 2; // z == 24
    z /= 3; // z == 8
    z %= 5; // z == 3

    // Range syntax
    let range = 0..10; // 0 to 9
    let first = *range.start();
    let last_minus_one = *range.end() - 1;

    // Nested block with combined operators
    let value = {
        let a = 5;
        let b = 10;
        (a + b) * 2 - 3
    };

    // Invoke debug to render abilities' AST debug info
    // In Move, abilities are traits; debug info usually via debug::debug, but here we'll simulate
    debug::debug("Testing ability dump: struct Counter");
    // For other ability dump, simulate with placeholder
}

/// Run the module's functions to trigger the test
//# run 0x1::arith_tests::test_abilities

//# publish
module 0x1::main_module {
    use 0x1::arith_tests;

    /// Runner function to initialize counter and repeatedly mutate
    public fun run_counter_tests(account: &signer) {
        arith_tests::init_counter(account);
        let mut i = 0;
        // Repeatedly call mutate_and_get, expecting sequential increment + iteration
        while (i < 5) {
            let val = arith_tests::mutate_and_get(account, i);
            debug::print(&val);
            i = i + 1;
        }
    }
}

//# run 0x1::main_module::run_counter_tests --signers 0xAABB

// Function declaration above; testing visibility restriction
public fun public_func() {
    // Do nothing
}

// Attempt to declare a private function within a script, which should be fine
fun private_helper() {
    // Empty helper
}

// Inline function that calls a passed function parameter
public fun inline_call_sum<F: functi(on): u64>(
    fn_param: &F,
    arg1: u64,
    arg2: u64,
): u64 {
    // Call the passed function with arguments
    fn_param(arg1) + fn_param(arg2)
}

// Example functions to pass
public fun double(x: u64): u64 {
    x * 2
}

public fun add_one(x: u64): u64 {
    x + 1
}

// Testing inline_call_sum
// Run with function pointers: using function names directly as arguments
//# run 0x1::main_module::test_inline_call --args 0x1::main_module::double 10 20

//# publish
module 0x1::test_module {
    use 0x1::arith_tests;

    /// Test invoking various operators and symbol usage
    public fun run_operations_test() {
        let a: u8 = 0b1010; // binary literal
        let b: u8 = 0b0101;

        // '~' can't be used directly in Move; simulate bitwise not via xor with max
        let not_a = a ^ 0xFFu8;
        debug::print(&not_a);

        // Use operators
        if a == b {
            debug::print(&"a == b");
        } else {
            debug::print(&"a != b");
        }

        // Symbol usage in comments, or in code as identifiers
        // For example, '==>' is not valid in code, but we can simulate its logic
        if a ==> b {
            // Not actual syntax, just a placeholder comment
        }

        // Demonstrate '<==>' as a placeholder for 'less equal' operator
        if a <= b {
            debug::print(&"a <= b");
        }

        // Use of '<<=' operator represented as shifting left and assigning
        let mut c: u16 = 1;
        c = c << 2;
        debug::print(&c); // Should print 4

        // Use of '%=' operator
        let mut d: u16 = 10;
        d = d % 3;
        debug::print(&d); // Should print 1

        // Use of '.' in move code (access fields), no specific in this test

        // Use of '^=' (xor assignment)
        let mut e: u8 = 0b1100;
        e ^= 0b1010; // Now e == 0b0110
        debug::print(&e);

        // Use of '{', '}', '#' for block and attribute syntax
        let _block = {
            // Block with '#'
            #{
                let temp = 42;
                temp
            }
        };

        // Use of '@' in annotations
        // No direct '@' operator, but can use in documentation or attributes
        // So not executable here

        // Render abilities again
        debug::debug("Ability AST dump: Counter");
    }
}

//# run 0x1::test_module::run_operations_test

// Additional: Testing that 'foo' inline function is called correctly
public fun test_inline_function() {
    let sum_result = inline_call_sum(&double, 3, 4);
    debug::print(&sum_result); // Should print double(3) + double(4) = 6 + 8 =14

    let sum_result2 = inline_call_sum(&add_one, 10, 20);
    debug::print(&sum_result2); // Should print 11 + 21 = 32
}
//# run 0x1::main_module::test_inline_function --args 0x1::main_module::double 3 4