//# publish
module 0xDEADBEEF::Diagnostics {
    /// Utility function to print diagnostic messages with labels.
    public fun report(label: vector<u8>, message: vector<u8>) {
        // Placeholder for reporting diagnostics.
        // In actual test, this will trigger parsing/compilation diagnostic.
        // No implementation needed here for the test.
    }
}

//# publish
module 0xABCD1234::PrimeUtils {
    /// Checks if a number is prime.
    public fun is_prime(n: u64): bool {
        if (n < 2) return false;
        let mut i = 2;
        while (i * i <= n) {
            if (n % i == 0) {
                return false;
            }
            i = i + 1;
        }
        true
    }

    /// Returns the largest prime factor of n.
    public fun largest_prime_factor(n: u64): u64 {
        let mut number = n;
        let mut max_factor = 1;
        let mut divisor = 2;

        while (divisor * divisor <= number) {
            if (number % divisor == 0) {
                max_factor = divisor;
                number = number / divisor;
            } else {
                divisor = divisor + 1;
            }
        }

        if (number > 1) {
            max_factor = number;
        }
        max_factor
    }
}

//# publish
module 0xEDED::LexicalTokenization {
    /// Dummy function to simulate lexical analysis and tokenization process.
    public fun analyze_source(source: vector<u8>): bool {
        // For testing purposes, we simulate detection of tokenization errors.
        // Let's assume that if source contains "error" string, report diagnostic.
        let source_str = String::from_utf8(source).unwrap();
        if (source_str.contains("error")) {
            Diagnostics::report(
                b"LexicalAnalysisError",
                b"Error detected during tokenization."
            );
            return false;
        }
        true
    }
}

//# run 0xCAFE::DiagnosticTest::run_tests --signers 0xCAFE
module 0xCAFE::DiagnosticTest {
    use 0xDEADBEEF::Diagnostics;
    use 0xABCD1234::PrimeUtils;
    use 0xEDED::LexicalTokenization;

    // Main runner function to execute all test snippets.
    public fun run_tests() {
        // Test 1: Module keys with optional address and module name.
        let module_address1 = "0x1234";
        let module_name1 = "TestModule1";
        let module_key1 = if (module_address1 == "") {
            module_name1
        } else {
            /*************************/
            // Simulate module key with address.
            // In actual code, this would relate to module publishing.
            // Placeholder for testing.
            "0x1234::TestModule1"
        };
        Diagnostics::report(
            b"ModuleKeyTest",
            b"Module key: " + module_key1
        );

        // Test 2: Diagnostic message with labels (simulate an identifier).
        Diagnostics::report(
            b"LabelID",
            b"Diagnostic message with label and identifier: function 'largest_prime_factor'"
        );

        // Test 3: Lexical analysis and tokenization.
        // Simulate source code snippet for lexical analysis.
        let source_code = b"
            pub fun main() {
                // Move code snippet
                let x = 42;
            }
        ";
        let _ = LexicalTokenization::analyze_source(vector::from_bytes(source_code));
        // Also test with an error in source.
        let error_source = b"
            pub fun error() {
                error here
            }
        ";
        let _ = LexicalTokenization::analyze_source(vector::from_bytes(error_source));

        // Test 4: largest_prime_factor function.
        // For more robustness, test multiple values.
        let test_numbers = [15u64, 28u64, 97u64, 100u64, 12345u64];
        let mut i = 0;
        while (i < vector::length(&test_numbers)) {
            let number = vector::borrow(&test_numbers, i);
            let result = PrimeUtils::largest_prime_factor(*number);
            Diagnostics::report(
                b"LargestPrimeFactorTest",
                b"largest_prime_factor of " + b"'" + &u64::to_string(*number) + b"'" + b" is " + &u64::to_string(result)
            );
            i = i + 1;
        }
    }
}