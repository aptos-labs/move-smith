//# publish
module 0xCAFE::ScopedVars {
    /// This function tests local variable assignments and modifications 
    /// within separate scoped blocks and aggregates their results.
    public fun test_scoped_vars(): u64 {
        let mut result = 0;

        {
            let x = 10;
            result = result + x; // result = 10
        }

        {
            let mut y = 20;
            y = y + 5;           // y = 25
            result = result + y; // result = 35
        }

        {
            // nested scopes modifying same variable
            let z = 3;
            let mut w = z + 7;   // w = 10
            {
                w = w * 2;       // w = 20
            }
            result = result + w; // result = 55
        }

        result
    }

    /// A function with a sequence of instructions
    /// This increments x by 1 three times and returns it
    public fun increment_sequence(x: u64): u64 {
        let mut val = x;
        val = val + 1;
        val = val + 1;
        val = val + 1;
        val
    }

    /// Define struct variants with no fields
    /// Using an enum-like pattern by defining multiple structs without fields
    struct NoneVariant has copy, drop, store {}
    struct FirstVariant has copy, drop, store {}
    struct SecondVariant has copy, drop, store {}

    /// Runner function to call internally all other functions without args
    public fun runner(): u64 {
        let a = test_scoped_vars();
        let b = increment_sequence(a);
        // We just combine results to have a non-zero final result
        a + b
    }
}
//# run 0xCAFE::ScopedVars::test_scoped_vars
//# run 0xCAFE::ScopedVars::increment_sequence --args 100u64
//# run 0xCAFE::ScopedVars::runner

//# run
script {
    use 0xCAFE::ScopedVars;

    fun main() {
        let val = ScopedVars::test_scoped_vars();
        let inc = ScopedVars::increment_sequence(val);
        let combined = ScopedVars::runner();

        // Just to force execution - no assertion needed
        let _ = val;
        let _ = inc;
        let _ = combined;
    }
}

// Featurres:
// 214e5cb83bf9c538c57147b21f75e230: Test that local variable assignments and modifications within separate scoped blocks correctly affect the overall computation result.
// e4595db29c530452e76d595154046d23: Write function bodies with a sequence of instructions.
// af7ffc57cb00bcc89856323362a4abd5: Define struct variants with no fields
