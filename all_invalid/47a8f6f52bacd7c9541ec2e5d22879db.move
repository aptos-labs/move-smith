
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
        invariant forall d: &Data where d.value < 100:
            true;

        condition d: &Data {
            d.value != 42
        }
    }

    /// A function to create Data with a given value
    public fun create_data(value: u64): Data {
        Data { value }
    }
}
