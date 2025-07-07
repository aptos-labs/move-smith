//# publish
module 0xCAFE::FilterTest {
    use aptos_framework::debug;

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
    use aptos_framework::debug;
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