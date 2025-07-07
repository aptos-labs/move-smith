
//# publish
module 0xCAFE::ComprehensiveTest {
    use std::signer;
    use std::vector;

    // Define a struct for testing references
    struct S has copy, drop, store {
        a: u64,
        b: u64,
    }

    // Internal constant
    const SECRET_VALUE: u32 = 0xDEADBEEF;

    // Enum with multiple variants
    enum E has copy, drop {
        VariantA,
        VariantB(u32),
        VariantC { flag: bool },
        VariantD,
        VariantE(u32, u32),
    }

    // Entry function to run all tests
    public fun run_all_tests(signer1: signer, signer2: signer) {
        // Test variable scope and shadowing
        test_variable_scoping(signer1);
        // Test references and sum function
        test_references_and_sum(signer1);
        // Test pattern matching on enum
        test_enum_matching(signer2);
        // Test access restrictions
        internal_only_function();
    }

    // Test variable creation, scoping, shadowing, loops, conditionals
    public fun test_variable_scoping(s: signer) {
        let outer_x = 10u64;
        {
            let outer_x = 20u64; // shadow
            let y = 0u64; // make y mutable
            y = outer_x + SECRET_VALUE as u64; // Use shadowed variable
            if (outer_x > 15) {
                let inner_x = outer_x + 5;
                y = inner_x + 10;
            } else {
                let inner_x = outer_x - 5;
                y = inner_x + 15;
            }; // end of if
            while (y < 100) {
                let inner_y = y + 1;
                y = inner_y + 2;
            }; // end of while
        }; // end of inner scope
        // The outer_x from outer scope remains unchanged
        // variable y's last value
    }

    // A function demonstrating local variables, shadowing, loops, conditionals
    public fun complex_variable_and_control_flow(s: signer) {
        let a = 1u64;
        let b = 2u64;
        if (a < b) {
            let a = b + 10; // shadow
            let c = a * 2;
        } else {
            let d = a - 1;
        }; // end of if
        while (a < 10) {
            a = a + 1;
        }; // end of while
    }

    // Internal function to demonstrate access control
    fun internal_only_function() {
        // Not accessible outside this module
        assert!(true, 0);
    }

    // Public function only accessible internally (simulate restricted access)
    public fun public_internal() {
        // Calls internal function
        internal_only_function();
    }

    // Sum function that takes reference to S, including mutable and frozen references
    public fun sum(frozen_struct: &S, mutable_struct: &mut S): u64 {
        let total = frozen_struct.a + frozen_struct.b + mutable_struct.a + mutable_struct.b;
        total
    }

    // Run the sum function with internal struct instances
    public fun run_sum_test(s: signer) {
        let s1 = S {a: 10, b: 20};
        let s2 = S {a: 30, b: 40};
        let total = sum(&s1, &mut s2);
        // total should be 10+20+30+40=100
    }

    // Function to test pattern matching with enum E
    public fun test_enum_patterns(e: E): u64 {
        match (e) {
            E::VariantA => 1,
            E::VariantB(x) => x as u64,
            E::VariantC { flag } => if (flag) { 100 } else { 200 },
            E::VariantD => 300,
            E::VariantE(x, y) => (x + y) as u64,
        }
    }

    // Wrapper to test multiple pattern matches
    public fun test_enum_match_all() {
        let a = E::VariantA;
        let b = E::VariantB(42);
        let c = E::VariantC { flag: true };
        let d = E::VariantD;
        let e = E::VariantE(7, 8);

        let res_a = test_enum_patterns(a);
        let res_b = test_enum_patterns(b);
        let res_c = test_enum_patterns(c);
        let res_d = test_enum_patterns(d);
        let res_e = test_enum_patterns(e);
        // The results should match the expected pattern values
    }
}


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 2c92103899c1fedf695b0fdb00536017: Test that the `sum` function correctly calculates the total by summing values from references to `S`, including frozen and mutable references.
// f54e4fa5c5679cd310463059f6e39fe7: Test that the enum variant match operator `(is)` correctly recognizes single and multiple enum variants in pattern matching.
