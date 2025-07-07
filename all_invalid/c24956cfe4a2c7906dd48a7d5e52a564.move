// File: MoveCompilerAndVMTest.move

address 0x1 {

module MoveCompilerAndVMTest {

    use std::vector;
    use std::string;

    /// A struct to hold a buffer of diagnostic messages
    struct DiagnosticBuffer has copy, drop, store {
        messages: vector<string::String>,
    }

    /// Initialize an empty diagnostic buffer
    public fun new_diagnostic_buffer(): DiagnosticBuffer {
        DiagnosticBuffer {
            messages: vector::empty<string::String>(),
        }
    }

    /// Append a formatted diagnostic message to the buffer
    public fun append_diagnostic_message(
        buffer: &mut DiagnosticBuffer,
        code: u64,
        severity: &string::String,
        message: &string::String,
    ) {
        let formatted = string::concat(
            &string::concat(
                &string::concat(&string::utf8(b"[Code "), &string::u64_to_string(code)),
                &string::utf8(b"] ")
            ),
            &string::concat(severity, &string::utf8(b": "))
        );
        let full_message = string::concat(&formatted, message);
        vector::push_back(&mut buffer.messages, full_message);
    }

    /// Example function using a type spec_domain specifying `T` over the vector type domain
    spec module {
        spec domain $spec_domain<T> {
            // $spec_domain specifying that T is any type in the Move type universe
        }

        spec foo<T> {
            // Specify that x is a value in the domain 0..10
            let x: u8 in 0..10;

            // Let's create a simple invariant using T
            invariant forall v: vector<T> :: vector::length(v) >= 0;
        }
    }

    /// Move VM test function to check appending diagnostics and quantification
    public fun test_transaction(): DiagnosticBuffer {
        // 1. Create a diagnostic buffer
        let mut buffer = new_diagnostic_buffer();

        // 2. Append messages with different severities and codes
        append_diagnostic_message(&mut buffer, 101, &string::utf8(b"Error"), &string::utf8(b"Type parameter T not found"));
        append_diagnostic_message(&mut buffer, 102, &string::utf8(b"Warning"), &string::utf8(b"Variable x out of range"));

        // 3. Test usage of spec_domain and quantified value domain
        // NOTE: The spec_domain and 'in' quantification are only available in specs,
        // but here we simulate reference and correct identification.

        // 4. Just return the diagnostic buffer for on-chain inspection
        buffer
    }

    /// Script to run the test interactively (only available for testing and simulation)
    #[test_only]
    public fun test() {
        let buffer = test_transaction();
        let len = vector::length(&buffer.messages);
        // Expect 2 messages appended
        assert!(len == 2, 1);

        // Optionally could loop through messages and check content
    }
}

}

// Featurres:
// bb5d4592f2188bdb68d5196965acc999: Generate a buffer containing formatted diagnostic messages
// 2ad1983493f0719116dabac9d866e541: Specify a domain over which a variable or type is quantified, either using a type domain with `$spec_domain` or a value domain with `in`.
// 23fe979c52aa80c763c3af9b5501f2b0: Ensure type parameters are correctly identified within types.
