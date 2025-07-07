
//# publish
module 0xCAFE::FeatureInteractionTest {
    use std::signer;
    use std::vector;

    // Functions to invoke various features, testing internal, local, block, and spec constructs
    public fun entry_point_logic(s: signer): u64 {
        let val1 = f_with_local_var(10);
        let val2 = f_with_loop_and_shadow(20);
        let val3 = internal_only_function(5); // accessible since within same module
        let val4 = spec_wrapper(val1);
        let val5 = curry_example(val2, (|a: u64| { a + 10 }), (|b: u64| { b * 2 }));
        val5
    }

    // Function involving local variables
    public fun f_with_local_var(x: u64): u64 {
        let y = x + 5;
        let z = y * 2;
        z
    }

    // Function testing local variables in a loop and shadowing
    public fun f_with_loop_and_shadow(start: u64): u64 {
        let counter = start;
        let shadow_var = 0;
        while (counter > 0) {
            let shadow_var = counter; // shadowing outer shadow_var
            counter = counter - 1;
        };
        // After the loop, shadow_var outside is 0
        shadow_var
    }

    // Internal function that acts like an internal variable scope
    fun internal_only_function(input: u64): u64 {
        input + 42
    }

    // Function demonstrating specification block with pure assertion
    public fun spec_wrapper(x: u64): u64 acquires {} {
        spec {
            // Declare property: x is nonzero
            assert!(x != 0, 999);
        }
        x + 1
    }

    // Function testing currying with closures and conditional logic
    public fun curry_example(a: u64, f1: |u64| -> u64, f2: |u64| -> u64): u64 {
        let res1 = f1(a);
        let res2 = f2(a);
        if (res1 > res2) {
            res1
        } else {
            res2
        }
    }

    // Closure with a conditional
    public fun conditional_closure(x: u64): u64 {
        if (x % 2 == 0) {
            x / 2
        } else {
            x * 3 + 1
        }
    }

    // Specification block to check properties of 0x prefixed hex literals
    public fun check_hex_literals() {
        let hex_literal: u64 = 0xDEADBEEF;
        let from_spec = 0xDEADBEEF;
        assert!(hex_literal == from_spec, 777);
    }

    // Specatic function to declare and check member properties
    public fun spec_property_members() {
        spec {
            // Declare a member for property check
            member x: u8 = 255;
            assert!(x <= 255, 555);
        }
        // The spec block is pure; no runtime effect
    }
}



//# run 0xCAFE::FeatureInteractionTest::entry_point_logic --signers 0xBADD --args


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
// 4760b5303eec78392fef07521b1ead67: Declare members within specification blocks to define specific behaviors or properties.
// 2c5f3248efe0e7aabd33dc21c935e3ba: Write hexadecimal numbers using the 0x prefix.
