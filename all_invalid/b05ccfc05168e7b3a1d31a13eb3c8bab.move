
//# publish
module 0xCAFE::InlineFunctionTest {
    // Inline function that returns the sum of two values
    public inline fun add(x: u64, y: u64): u64 {
        x + y
    }

    // Inline function that negates a boolean
    public inline fun negate(b: bool): bool {
        !b
    }

    // Inline function that dereferences a reference and adds 1
    public inline fun deref_add_one(reference: &u64): u64 {
        *reference + 1
    }

    // Function to organize 'use' declarations and call inlined functions
    public fun run_inlined_functions() {
        // Use declaration with brace, importing functions
        use 0xCAFE::InlineFunctionTest::{
            add,
            negate,
            deref_add_one,
        };

        let a: u64 = 10;
        let b: u64 = 20;

        let sum = add(a, b); // inline add
        let neg = negate(true); // inline negate

        let reference = &a;
        let deref_result = deref_add_one(reference); // inline deref_add_one

        // Use the results (not asserting as per instructions)
        move {
            assert sum == 30;
            assert neg == false;
            assert deref_result == 11;
        };
    }

    // Runner function to call the organized function
    public fun run() {
        run_inlined_functions();
    }
}



//# run 0xCAFE::InlineFunctionTest::run

// Featurres:
// 11a4d1fe9892131da3fe1e15c5bf28ca: Write code that calls inline functions and benefit from having those callees' bodies inlined into the caller.
// c27bfd0ddff886e382b79619db313d1a: Organize spec block contents using a syntax that allows multiple 'use' declarations and members inside braces.
// 199dca23bfac2057e5e259fdcbfdb2ae: Use the * and ! operators for dereferencing and negation in expressions.
