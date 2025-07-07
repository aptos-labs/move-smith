
//# publish
module 0xCAFE::TestModule {
    // Function to test mutable references
    public fun use_mut_ref(x: &mut u64) {
        *x = *x + 1;
    }

    // Inline function that accepts a closure and calls it
    public inline fun with_closure<F: copy + callable>(f: &mut F) {
        // Call the closure with an ignored parameter
        f(true);
    }

    // Runner function to test usage of references and closure
    public fun run_tests() {
        let a: u64 = 10;
        let ref_a = &mut a;
        Self::use_mut_ref(ref_a);
        // After call, a should be 11
        assert(a == 11, 0);

        // Define a closure (function pointer) with an ignored parameter
        fun closure(_: bool) {
            // do nothing
        }
        // Call the inline function with closure
        Self::with_closure(&mut closure);
    }
}



//# run 0xCAFE::TestModule::run_tests

// Features:
// d35b588c67cd02c800b53cd7282965d0: Use '&mut' to define mutable references in types.
// a06727494262e8a948eb4b0617e7fbda: Recognize specific tokens such as commas, braces, and semicolons to parse ability declarations correctly.
// 828d977b5d7b96456af4d7fd8c60f323: Test that inline functions can accept closures as arguments and properly handle closures with ignored parameters using underscores.
