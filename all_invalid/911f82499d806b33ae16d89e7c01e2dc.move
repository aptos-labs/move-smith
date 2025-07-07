//# publish
module 0xCAFE::PrivateFnTest {
    // This private function can only be called inside this module.
    // It returns a u64 value for demonstration.
    fun private_fn(): u64 {
        42
    }

    // Public function that uses the private function internally.
    public fun run() : u64 {
        let x = private_fn();

        if (x > 10) {
            // return from if branch
            return x;
        } else {
            // return from else branch
            return 0;
        }
    }

    // Public runner function with no arguments to exercise if-else return paths.
    public fun runner(): u64 {
        if (true) {
            return 1;
        } else {
            return private_fn();
        }
    }
}
//# run 0xCAFE::PrivateFnTest::run --signers 0xCAFE
//# run 0xCAFE::PrivateFnTest::runner --signers 0xCAFE

//# run
script {
    use 0xCAFE::PrivateFnTest;

    fun main(account: signer) {
        let result1 = PrivateFnTest::run();
        // Diagnostic message label usage (not assertions):
        std::debug::print(&("Result from run: ".ascii()));
        std::debug::print(&std::string::utf8(result1));

        let result2 = PrivateFnTest::runner();
        std::debug::print(&("Result from runner: ".ascii()));
        std::debug::print(&std::string::utf8(result2));
    }
}

// Featurres:
// 7558a3708edea4ef863b7d2740db0eac: Declare functions with private visibility that can only be called from within the same module.
// 970b8ff709114601b164f088807367b0: Test that an if-else statement with return statements in both branches compiles and executes correctly without triggering assertions in unreachable code paths.
// a3ed19c19dd63b956349eaca76d07950: Include code snippets or identifiers in diagnostic messages as labels.
