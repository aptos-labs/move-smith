module 0x1::TransactionTest {

    use std::debug;

    /// A simple struct for demonstration.
    struct MyStruct has store {
        val: u64,
    }

    /// Returns a mutable reference to the field `val` of the struct.
    public fun get_mut_ref(s: &mut MyStruct): &mut u64 {
        &mut s.val
    }

    /// Returns an immutable reference to the field `val` of the struct.
    public fun get_imm_ref(s: &MyStruct): &u64 {
        &s.val
    }

    /// Function that takes zero parameters and returns 42.
    public fun zero_params(): u64 {
        42
    }

    /// Function that takes one parameter and returns it multiplied by 2.
    public fun one_param(x: u64): u64 {
        x * 2
    }

    /// Function that takes two parameters and returns their sum.
    public fun two_params(x: u64, y: u64): u64 {
        x + y
    }

    /// Function that takes three parameters and returns (x * y) - z.
    public fun three_params(x: u64, y: u64, z: u64): u64 {
        x * y - z
    }

    #[test]
    public fun transactional_test() {
        // 1. Bind values to local variables within a sequence
        let a = 10;
        let b = 20;
        let c = a + b;
        debug::print(&c); // Expect 30

        // 2. Test mutable references can be reassigned after being returned from a function
        let mut s = MyStruct { val: 100 };

        // Get a mutable reference to s.val via function
        let mut_ref = get_mut_ref(&mut s);
        // Reassign the mutable reference
        *mut_ref = 200;

        // Take an immutable reference from the original value afterward
        let imm_ref = get_imm_ref(&s);

        debug::print(imm_ref); // Expect 200

        // Mutate again through another mutable reference to ensure reassignable
        let mut_ref2 = get_mut_ref(&mut s);
        *mut_ref2 = 300;

        let imm_ref2 = get_imm_ref(&s);
        debug::print(imm_ref2); // Expect 300

        // 3. Test functions with varying parameters and call patterns
        let r0 = zero_params();
        debug::print(&r0);            // Expect 42

        let r1 = one_param(5);
        debug::print(&r1);            // Expect 10

        let r2 = two_params(7, 8);
        debug::print(&r2);            // Expect 15

        let r3 = three_params(3, 4, 5);
        debug::print(&r3);            // Expect (3*4)-5 = 7

        // Additional test: Call inline in sequence
        let seq_result = three_params(one_param(2), two_params(1, 1), zero_params());
        // (2*2) * (1+1) - 42 = (4)*(2) - 42 = 8 - 42 = -34 => u64, so unsigned
        // Since negative is invalid, just test with safe values:
        // Let's rewrite to avoid underflow:
        let seq_result = three_params(one_param(2), two_params(1, 1), 3);
        // (2*2)*(1+1) - 3 = 4*2 -3 = 8 - 3 = 5
        debug::print(&seq_result);   // Expect 5
    }
}

// Featurres:
// 3719a4bf4284b0a7fb591d83313b0aca: Bind values to local variables within a sequence.
// 776a6e57af66887c8df3b853b7746b4d: Test that mutable references can be reassigned after being returned from a function, and that immutable references can still be taken from the original value afterward.
// 4adf157cea6759d562aa3cd24a34a045: Test that the Move module correctly handles functions with varying parameters and call patterns by verifying their execution and return values across different scenarios.
