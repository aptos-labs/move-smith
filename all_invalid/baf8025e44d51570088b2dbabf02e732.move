
//# publish
module 0xCAFE::TestInteraction {

    // Entry point modules to facilitate script testing
    public fun script_create_variables() {
        // Just an empty function to serve as a script placeholder
    }
}



//# run 0xCAFE::TestInteraction::script_create_variables



//# publish
module 0xCAFE::InteractionTests {
    use std::signer;
    use std::vector;

    // Helper function to compare unsigned integers, testing all comparison operators across types
    public fun compare_all_types() {
        // u8 comparisons
        let a8: u8 = 10;
        let b8: u8 = 20;
        assert!(a8 == a8);
        assert!(a8 != b8);
        assert!(a8 < b8);
        assert!(b8 > a8);
        assert!(a8 <= a8);
        assert!(b8 >= a8);

        // u16 comparisons
        let a16: u16 = 100;
        let b16: u16 = 200;
        assert!(a16 == a16);
        assert!(a16 != b16);
        assert!(a16 < b16);
        assert!(b16 > a16);
        assert!(a16 <= a16);
        assert!(b16 >= a16);

        // u32 comparisons
        let a32: u32 = 1000;
        let b32: u32 = 2000;
        assert!(a32 == a32);
        assert!(a32 != b32);
        assert!(a32 < b32);
        assert!(b32 > a32);
        assert!(a32 <= a32);
        assert!(b32 >= a32);

        // u64 comparisons
        let a64: u64 = 10000;
        let b64: u64 = 20000;
        assert!(a64 == a64);
        assert!(a64 != b64);
        assert!(a64 < b64);
        assert!(b64 > a64);
        assert!(a64 <= a64);
        assert!(b64 >= a64);

        // u128 comparisons
        let a128: u128 = 100000;
        let b128: u128 = 200000;
        assert!(a128 == a128);
        assert!(a128 != b128);
        assert!(a128 < b128);
        assert!(b128 > a128);
        assert!(a128 <= a128);
        assert!(b128 >= a128);

        // u256 comparison using inline type
        // In Move, u256 isn't a primitive type; typically, you'd use a vector or a dedicated type.
        // For testing purposes, use u128 as a stand-in.
        let a256: u128 = 1000000; // Simulating u256 with u128
        let b256: u128 = 2000000;
        assert!(a256 == a256);
        assert!(a256 != b256);
        assert!(a256 < b256);
        assert!(b256 > a256);
        assert!(a256 <= a256);
        assert!(b256 >= a256);
    }

    // Function to check variable shadowing and local vs global variables
    public fun variable_shadowing() {
        // Global variables simulation as constants inside the module
        const x: u8 = 5;
        const y: u8 = 10;

        // Local variables with shadowing
        let x: u8 = 20;
        let y: u8 = 30;

        assert!(x == 20);
        assert!(y == 30);
    }

    // Function to test assignment and scope
    public fun assignment_and_scope() {
        let a: u16 = 123;
        let b: u16;
        b = a + 10;
        assert!(b == 133);
    }

    // Function to check while loop with variable assignment inside and outside loop
    public fun while_variable_scope() {
        let count: u64 = 0;
        let sum: u64 = 0;

        while (count < 5) {
            // Local variable in loop
            let temp: u64 = count * 2;
            sum = sum + temp;
            count = count + 1;
        };
        // sum should be 0*2 + 1*2 + 2*2 + 3*2 + 4*2 = 0 + 2 + 4 + 6 + 8 = 20
        assert!(sum == 20);
    }

    // Function to test internal visibility restriction
    fun internal_only_function(): u64 {
        42
    }

    // Function trying to access internal function internally
    public fun test_internal_access() {
        internal_only_function();
    }

    // Function to test "spec" attribute with incorrect formatting (simulate)
    // Since Move doesn't support attribute syntax for functions, this is just a placeholder.
    public fun test_spec_incorrect() {
        // No runtime code; in actual tests, invalid attribute syntax would cause compile errors.
    }

    // Function to test type aliasing (with nested modules or types)
    public fun alias_test() {
        type AliasU8 = u8;
        let val: AliasU8 = 55;
        assert!(val == 55);
    }
}



//# run 0xCAFE::InteractionTests::compare_all_types



//# run 0xCAFE::InteractionTests::variable_shadowing



//# run 0xCAFE::InteractionTests::assignment_and_scope



//# run 0xCAFE::InteractionTests::while_variable_scope



//# run 0xCAFE::InteractionTests::test_internal_access



//# run 0xCAFE::InteractionTests::alias_test
