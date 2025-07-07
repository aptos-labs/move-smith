//# publish
module 0xCAFE::RefSafety {
    /// A function to add two u64 numbers, to test compiler correctness on simple arithmetic.
    public fun add_u64(x: u64, y: u64): u64 {
        x + y
    }

    /// An inline function with a body, to test that the compiler removes it appropriately.
    public inline fun inline_double(x: u64): u64 {
        x * 2
    }

    /// A function to check reference safety:
    /// takes a mutable reference and modifies the value pointed to.
    /// This function does not return anything but mutates the reference.
    public fun reference_safety_check(r: &mut u64) {
        *r = *r + 1;
    }

    /// A runner function to exercise the above functions,
    /// No arguments, no signers needed.
    public fun runner() {
        let a = 123u64;
        let b = 321u64;
        let sum = add_u64(a, b); // sum = 444
        let doubled = inline_double(a); // doubled = 246

        let mut val = 10u64;
        reference_safety_check(&mut val); // val = 11 after mutation

        // Use values to avoid "unused variable" warnings (even though no assertions needed)
        let _ = sum + doubled + val;
    }
}
//# run 0xCAFE::RefSafety::runner

//# run
script {
    use 0xCAFE::RefSafety;

    fun main() {
        let x = 100u64;
        let y = 200u64;

        let result = RefSafety::add_u64(x, y);
        let inline_result = RefSafety::inline_double(y);

        let mut val = 50u64;
        RefSafety::reference_safety_check(&mut val);

        let _ = result + inline_result + val;
    }
}

// Featurres:
// 700188a5b9e6617dd97929cdf4048619: Use reference_safety checks to ensure reference safety.
// 90664d4b2d8c8d0427947c5eb3a9aa52: Rely on the compiler to remove inline functions with bodies from the final program, preventing code generation issues with certain constructs.
// 0ea978679d5fdf0f1de63ab95f43eee6: Test that the Move module can define a function that performs simple integer addition.
