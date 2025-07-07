//# publish
@deprecated("Use new_module instead.")
module 0xCAFE::DeprecatedModule {
    public fun deprecated_fun(a: u64, b: u64): u64 {
        a + b
    }

    // Runner function to be called for testing deprecated functions
    public fun runner(): u64 {
        deprecated_fun(5, 10)
    }
}
//# run 0xCAFE::DeprecatedModule::runner

//# publish
module 0xCAFE::BinaryOps {
    public fun bin_ops(a: u64, b: u64): u64 {
        let add = a + b;
        let sub = a - b;
        let mul = a * b;
        let div = a / b;
        let rem = a % b;
        let bit_and = a & b;
        let bit_or = a | b;
        let bit_xor = a ^ b;
        // Combining results to a sum to have some final u64 result
        add + sub + mul + div + rem + bit_and + bit_or + bit_xor
    }

    public fun runner(): u64 {
        bin_ops(10, 3)
    }
}
//# run 0xCAFE::BinaryOps::runner

//# publish
module 0xCAFE::HigherOrder {

    // A type alias for a closure that takes a u64 and returns a u64
    // Move currently does not support real closures, emulate with functions.

    // We emulate a higher order function returning a closure with a struct holding the captured value + a method call
    struct ClosureHolder has copy, drop {
        captured: u64,
    }

    public fun create_closure(x: u64): ClosureHolder {
        ClosureHolder { captured: x }
    }

    public fun call_closure(holder: &ClosureHolder, y: u64): u64 {
        // closure: (x + y)
        holder.captured + y
    }

    // Runner function:
    // Create closure with 100, then immediately call with 23
    public fun runner(): u64 {
        let c = create_closure(100);
        call_closure(&c, 23)
    }
}
//# run 0xCAFE::HigherOrder::runner

//# run
script {
    use 0xCAFE::BinaryOps;
    use 0xCAFE::HigherOrder;

    fun main() {
        // Test deprecated module runner
        let _ = 0xCAFE::DeprecatedModule::runner();

        // Test binary ops runner
        let bin_result = BinaryOps::runner();

        // Test higher order function runner
        let ho_result = HigherOrder::runner();

        // No assertions needed as per instructions
        // Drop unused variables silently
        let _ = bin_result;
        let _ = ho_result;
    }
}

// Featurres:
// caf68958502e03d1c87701fe1f6fd804: Mark modules or address definitions as deprecated by adding attributes, enabling deprecation notices.
// ff2ce72d7fe6ba162ce31d16f06cde76: Create binary or mutate expressions using two sub-expressions.
// 0f1a214dfa4c1ac206e9641b335bbe2f: Test that higher-order functions can return closures which themselves capture function arguments and are immediately callable with further arguments.
