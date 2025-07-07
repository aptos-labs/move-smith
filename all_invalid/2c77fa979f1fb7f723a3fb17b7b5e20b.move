//# publish
module 0xCAFE::FilterTest {
    use std::debug;

    // Function that is private and can't be called outside this module.
    fun private_function(): u64 {
        42
    }

    // Public function to test calling private function inside module.
    public fun call_private(): u64 {
        private_function()
    }

    // Runner function with side effects and unit expression assignment.
    public fun runner() {
        let x = private_function();    // x = 42
        // Assign to unit expression for side effect (here calling debug::print).
        let _ = debug::print(&b"Assign to unit expression for side effect\n");
        // Assign to unit to explicitly discard the result of call to call_private().
        let _ = call_private();
    }
}
//# run 0xCAFE::FilterTest::runner --signers 0xCAFE

//# run
script {
    use std::debug;
    use 0xCAFE::FilterTest;

    fun main() {
        // The following line should generate an error if uncommented, because private_function is private:
        // let x = FilterTest::private_function();

        // Instead, test calling the public function.
        let val = FilterTest::call_private();

        debug::print(&b"Returned from call_private: ");
        debug::print(&debug::to_utf8(val as u8)); // Just print the low byte for demonstration.

        // Test assigning to unit expression with side effect.
        let _ = debug::print(&b"Inside script: assign to unit expression\n");
    }
}

// Featurres:
// aea0924f9167959f01edde6ae806553e: Filter modules, scripts, or addresses based on specific criteria during compilation.
// 61cd1258fcd8808079a578eb5061a745: Generate an error message indicating that the function is private to its module when a violation occurs.
// 64d7361646fc89108c2c632e2bc5ac2f: Assign to unit expressions for side effects without value.
