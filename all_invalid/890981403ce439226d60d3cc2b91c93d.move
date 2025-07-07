//# publish
module 0xCAFE::TestBlockComparison {
    /// Test that block expressions on both sides of comparison operators are evaluated independently.
    public fun block_comparison_runner() {
        let left = { 1 + 2 };
        let right = { 2 + 1 };
        // Comparison operators: ==, !=, <, <=, >, >=
        // Use the block expressions directly in comparisons on both sides
        let eq = ({ 3 } == { 3 });
        let neq = ({ 4 } != { 5 });
        let lt = ({ 1 } < { 2 });
        let lte = ({ 2 } <= { 2 });
        let gt = ({ 5 } > { 4 });
        let gte = ({ 6 } >= { 6 });

        // Use "ignore" variables to ensure left and right expressions evaluated independently
        let left_val = { 1 + 7 };
        let right_val = { 10 - 2 };
        let _ = (left_val == right_val);

        // no return
    }
}

//# run 0xCAFE::TestBlockComparison::block_comparison_runner --signers 0xCAFE

//# publish
module 0xCAFE::TestMemberKinds {
    // Define fields and functions with different member kinds, no deprecation info.
    struct S has key, store {
        a: u8,
        b: u64,
    }

    // A public constant
    const CONST_VAL: u8 = 42;

    // A public native function (simulate native by empty body, Aptos Move currently doesn't support native in test)
    public fun native_like(): u8 {
        7
    }

    // Private function
    fun private_fun(): u64 {
        123
    }

    // Public function returning field values
    public fun get_a(s: &S): u8 {
        s.a
    }

    // Public inline function
    public inline fun inline_fun(x: u8): u8 {
        x + CONST_VAL
    }

    // A runner function to test calls
    public fun runner() {
        let s = S { a: 1, b: 2 };
        let _ = Self::get_a(&s);
        let _ = Self::inline_fun(5);
        let _ = Self::native_like();
        let _ = Self::private_fun();
    }
}

//# run 0xCAFE::TestMemberKinds::runner --signers 0xCAFE

//# publish
module 0xCAFE::TestLambda {
    // Lambda expressions - anonymous functions - can be assigned to variables and called
    // This tests Move lambda support

    public fun lambda_runner() {
        let add = fun (x: u64, y: u64): u64 { x + y };
        let result = add(10, 20);

        let neg = fun (x: u8): u8 { 0 - x }; // test unary minus (allowed for u8 since no signed, but here will test calculation)

        // Compose lambdas
        let composed = fun (a: u64, b: u64): u64 {
            let sum = add(a, b);
            let doubled = fun (z: u64): u64 { z * 2 };
            doubled(sum)
        };

        let _ = neg(1);
        let _ = result;
        let _ = composed(3, 4);
    }
}

//# run 0xCAFE::TestLambda::lambda_runner --signers 0xCAFE

// Featurres:
// 79d02bcb625237d3284e70591d45763e: Test that a block expression on the left side of a comparison operator is properly evaluated independently from the block on the right side.
// afeb4b6ebb07bba12c83e2588f9fd362: Define module members with specified kinds without deprecation info
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
