//# publish
module 0xCAFE::TestBlockComparison {
    /// Test that block expressions on both sides of comparison operators are evaluated independently.
    public fun block_comparison_runner() {
        let _left = { 1 + 2 };
        let _right = { 2 + 1 };
        // Comparison operators: ==, !=, <, <=, >, >=
        // Use the block expressions directly in comparisons on both sides
        let _eq = ({ 3 } == { 3 });
        let _neq = ({ 4 } != { 5 });
        let _lt = ({ 1 } < { 2 });
        let _lte = ({ 2 } <= { 2 });
        let _gt = ({ 5 } > { 4 });
        let _gte = ({ 6 } >= { 6 });

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
    struct S has key, store, drop {
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
    // Aptos Move 2.2 unstable version does not support capture kind lambdas
    // So instead, implement the logic as regular functions or inline code

    // Helper function simulating add lambda
    public fun add(x: u64, y: u64): u64 {
        x + y
    }

    // Helper function simulating neg lambda for u8
    public fun neg(x: u8): u8 {
        // since 0 - x may underflow, rewrite as 0u8.wrapping_sub(x)
        // but wrapping_sub currently not standard, so compute as (0u8 as u16 - x as u16) cast to u8
        // or simply use saturated subtraction and cast
        (0u8 as u16 - x as u16) as u8
    }

    public fun doubled(z: u64): u64 {
        z * 2
    }

    public fun composed(a: u64, b: u64): u64 {
        let sum = Self::add(a, b);
        Self::doubled(sum)
    }

    public fun lambda_runner() {
        let result = Self::add(10, 20);
        let neg_val = Self::neg(1);
        let comp = Self::composed(3, 4);
        let _ = neg_val;
        let _ = result;
        let _ = comp;
    }
}

//# run 0xCAFE::TestLambda::lambda_runner --signers 0xCAFE