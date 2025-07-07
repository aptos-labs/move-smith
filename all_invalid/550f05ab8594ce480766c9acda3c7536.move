module 0x1::TransactionTest {

    use std::signer;

    /// A struct with specific abilities to test ability constraints
    struct MyResource has key, store {
        value: u64,
    }

    /// A generic struct with ability constraints on the type parameter
    struct Wrapper<T: copy + drop + store> has key {
        inner: T,
    }

    /// A function that accepts a signer and a byte vector literal, testing byte string literals and type constraints
    public fun write_and_wrap<T: copy + drop + store>(account: &signer, val: T) {
        // Just dummy logic creating a Wrapper
        let _w: Wrapper<T> = Wrapper { inner: val };

        // Let's emit an event or store to onchain storage in a real scenario,
        // here just demonstrating types and byte string literal usage.
        // Check that this function only accepts T with certain abilities.
    }

    /// A function returning a literal byte string to test byte string literal syntax
    public fun get_bytes(): vector<u8> {
        // Using a literal byte string with syntax b"..." (Move supports this)
        let bytes: vector<u8> = b"Hello Aptos Move!";
        bytes
    }

    /// A function demonstrating local variable type annotation with colon ':'
    public fun annotated_local() {
        // Local variable with explicit type annotation
        let x: u8 = 10;
        let y: vector<u8> = b"\x01\x02\x03";

        // Ensure correct type annotation parses correctly
        let wrapped: Wrapper<u8> = Wrapper { inner: x };

        // Small usage to avoid warnings
        let _ = wrapped;
        let _ = y;
    }

    /// Test function that will be executed as a transaction test
    #[test]
    public fun transactional_test() {
        // Create a signer; in Aptos test framework this is provided implicitly
        // For this example, simulate with a dummy signer reference (normally test harness provides it)
        let account: &signer = @0xA;

        // 1. Test byte string literal usage and retrieval
        let bytes: vector<u8> = get_bytes();
        assert!(bytes[0] == 72, 1); // 'H' == 72 ascii

        // 2. Test function that specifies type constraints and ability checks
        let value: u64 = 42;
        write_and_wrap<u64>(account, value);

        // 3. Test struct with ability constraints - MyResource requires key,store abilities
        let resource = MyResource { value: 123 };

        // Wrap it using Wrapper<MyResource>
        let wrapped_res: Wrapper<MyResource> = Wrapper { inner: resource };
        let _ = wrapped_res;

        // 4. Run function demonstrating annotated locals
        annotated_local();

        // If reached here, all tests passed
    }
}

// Featurres:
// 57e2fb9f349faed7c5d21313d52c4dbe: Write literal byte strings using the byte string syntax in code.
// 1fc4d487ad3b1e83b69c5b34cabee61e: Specify type constraints using a colon ':' in Move code for a type.
// f1c17907be8ea222f783a0a1ab20a0a7: Encourage proper handling of abilities via ability checks on types and function signatures.
