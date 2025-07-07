
//# publish
module 0xCAFE::AbortAndEntryTest {
    use std::signer;

    /// The function aborts if the input is zero.
    /// We will test abort with particular code 777.
    public fun abort_if_zero(x: u8) {
        if (x == 0) {
            abort 777;
        };
        // Code after abort must not execute
        let _ = x + 1;
    }

    /// Entry function that accepts a signer and a u8
    /// Just a placeholder that calls abort_if_zero to test entry.
    entry fun entry_abort_check(_s: signer, x: u8) {
        abort_if_zero(x);
    }

    /// A struct with a spec block that has an invariant with properties
    struct Data has store {
        value: u64,
    }

    spec module {
        invariant [
            // The value is always less than 100
            forall d: &Data :: d.value < 100

            // Additional condition properties
            condition [d: &Data] {
                d.value != 42
            }
        ];
    }

    /// A function to create Data with a given value
    public fun create_data(value: u64): Data {
        Data { value }
    }
}


//# run 0xCAFE::AbortAndEntryTest::abort_if_zero --args 1u8


//# run 0xCAFE::AbortAndEntryTest::entry_abort_check --signers 0xBEEF --args 1u8


//# run 0xCAFE::AbortAndEntryTest::abort_if_zero --args 0u8


//# run 0xCAFE::AbortAndEntryTest::entry_abort_check --signers 0xBEEF --args 0u8


// Featurres:
// f3460c7b6c15389eddc938567cc829b0: Test that the function correctly aborts execution with the provided value when the condition is true or false, and ensure that code after aborts is not executed.
// 9d566eb4836899102ffef9aba3b62e3f: Mark a function as an entry function, allowing it to be published as a transaction entry point using the 'entry' keyword.
// a871749d39b7d0f3b41f2eb092d92571: Add additional properties to invariants using condition properties syntax in spec blocks.
