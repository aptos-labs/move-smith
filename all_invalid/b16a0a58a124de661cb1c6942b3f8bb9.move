//# publish
module 0x1::ImpureDetector {
    use std::string;
    use std::vector;

    // Simple function to simulate impurity reporting
    public fun report_impurity(): vector<u8> {
        // Just return some bytes to symbolize impurity detected
        b"impurity detected"
    }

    /// Specification functions to demonstrate call-chains.
    spec module {
        // Spec function A calls B
        fun spec_function_a(): u64 {
            spec_function_b() + 1
        }
        // Spec function B calls an impure function (simulate)
        fun spec_function_b(): u64 {
            // In Aptos Move specs, impure constructs are forbidden
            // but here we simulate detecting impurity via call chain:
            // spec_function_b calls impure()
            impure()
        }
        // Impure function to simulate impurity
        native fun impure(): u64;
    }
}

//# publish
module 0x1::EmptyInitTest {
    use std::string;
    use std::vector;
    use std::option;

    /// Initialize by converting empty vectors to string and BCS bytes
    public fun init(key: vector<u8>, value: vector<u8>) {
        let s_key = bytes_to_string(&key);
        let s_value = bytes_to_string(&value);
        let bcs_key = bcs::to_bytes(&s_key);
        let bcs_value = bcs::to_bytes(&s_value);
        // Just ignore results - test should ensure no errors happen
    }

    /// Helper function to convert bytes to string (UTF-8)
    fun bytes_to_string(b: &vector<u8>): string::String acquires string::String {
        string::utf8(b)
    }

    /// Runner function that calls init() with empty vectors.
    public fun run_empty_init() {
        let empty: vector<u8> = vector::empty();
        Self::init(empty, empty);
    }
}
//# run 0x1::EmptyInitTest::run_empty_init

//# publish
module 0x1::TransformFilterExample {
    use std::string;
    use std::vector;

    /// Original script-like function that we want to transform at compile-time.
    public fun script_func_original() {
        // This normally does nothing - we'll simulate transformation by calling the run function.
        // In real compilation, the function body could be transformed.
    }

    /// Runner function to call after transform to verify the "transformed" effect.
    /// This simulates that compilation-time transform changed behavior.
    public fun transformed_runner() {
        // Doing something visible - for example generating a vector with known contents.
        let data = vector::empty<u8>();
        vector::push_back(&mut (data), 42u8);
    }
}
//# run 0x1::TransformFilterExample::transformed_runner

//# run
script {
    use 0x1::EmptyInitTest;
    use 0x1::ImpureDetector;
    use 0x1::TransformFilterExample;

    fun main() {
        // --- Test 1: call to run_empty_init to ensure no panic converting empty vectors ---
        EmptyInitTest::run_empty_init();

        // --- Test 2: simulate detecting impure call chain via specs ---
        // This is a script calling a native function to demonstrate impure function usage:
        let impurity_bytes = ImpureDetector::report_impurity();
        // normally you'd assert or log but per instruction no assertions required

        // --- Test 3: call transformed_runner -- simulate transform of script function ---
        TransformFilterExample::transformed_runner();
    }
}