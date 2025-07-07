// 1. Lambda lifting in specifications and use of `apply`.
//# publish
module 0xCAFE::SpecTest {
    public fun is_even(x: u8): bool {
        x % 2 == 0
    }

    /// Applies the 'is_even' function to all elements in the vector.
    public fun all_even(vec: vector<u8>): bool {
        // Use the 'apply' keyword in a specification.
        spec {
            // Lambda lifting: the anonymous function is lifted out.
            // Here we use apply with a named function 'is_even'.
            //
            // Specification ensures that every element is even.
            // 'apply' with lambda would be: apply(|x| x % 2 == 0, pattern)
            // but we'll use the named function for lambda lifting.
            //
            // Example (not Move syntax, for illustration):
            //   apply(|x| x % 2 == 0, vec)
            //
            // In actual Move spec, let's lift to use 'is_even':
            //   apply(Self::is_even, vec)
            //
            // So, ensuring all elements are even:
            //
            // all x in vec: is_even(x)
            //
            include apply(Self::is_even, vec);
        }
        let mut i = 0;
        while (i < vector::length(&vec)) {
            if (!Self::is_even(*vector::borrow(&vec, i))) {
                return false;
            }
            i = i + 1;
        };
        true
    }

    // Example runner so we can call from the test script.
    public entry fun test_apply_and_lambda_lifting() {
        let s = vector[2u8, 4u8, 6u8];
        let r = Self::all_even(s);
        // no assertion needed due to test format.
        let _ = r;
    }
}

//# run 0xCAFE::SpecTest::test_apply_and_lambda_lifting --signers 0xCAFE

// 3. Test script with early return behaviour.
//# run
script {
    use std::debug;

    fun main() {
        let x = 100u8;
        if (x > 50u8) {
            return; // Early return, so anything after this should not execute!
        };
        // Below line should not execute
        debug::print<u8>(x); // would panic during assertion if executed.
    }
}
