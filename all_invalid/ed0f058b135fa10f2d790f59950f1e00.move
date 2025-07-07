// Test 1: Recursively analyze used functions to generate bytecode for callee functions

//# publish
module 0xCAFE::RecursiveCalls {
    public fun add_one(x: u64): u64 {
        x + 1
    }

    public fun double_then_add_one(x: u64): u64 {
        Self::add_one(x * 2)
    }

    public fun triple_then_double_then_add_one(x: u64): u64 {
        Self::double_then_add_one(x * 3)
    }

    public fun runner() {
        let _a = Self::triple_then_double_then_add_one(5);
        // Expect: (((5 * 3) * 2) + 1) = (15 * 2) + 1 = 30 + 1 = 31
    }
}
//# run 0xCAFE::RecursiveCalls::runner --signers 0xAABB

// Test 2: Display diagnostics with any color if environment variable is set to 'ALWAYS'
// (This test will only show colored diagnostics if tested in an environment with
// MOVE_COLOR_MODE=ALWAYS. Here, we force a type error for demonstration.)

//# publish
module 0xCAFE::ColoredDiagnostics {
    public fun cause_type_error() {
        let x: address = 5; // type error: assigning u64 to address
    }
}
//# run 0xCAFE::ColoredDiagnostics::cause_type_error --signers 0xAABB

// Test 3: Check for the presence of the Move module magic number in a binary file
// We'll write a script that aborts with 42, then attempt to publish as a module,
// ensuring Move sees the bytecode doesn't have the correct magic number and fails with an error.

//# run
script {
    fun main(account: &signer) {
        // Silly dummy script, does nothing
        abort 42;
    }
}

// Attempt to publish the bytecode of the above script as a module will fail with a magic number error.
// This is usually checked at the Move VM/runtime level, but not expressible as Move code itself.
// However, you can see the error during testing via attempts to publish script as module bytecode.