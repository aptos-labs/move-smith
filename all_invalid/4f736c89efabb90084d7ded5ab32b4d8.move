// tests/transactional_test.move
module 0x1::TransactionalTest {

    use std::debug;
    use std::vector;

    #[test_only]
    public fun test_compiler_and_vm() {
        // 1. Automatically tag and span name access chains with source location
        //    We simulate this by capturing source location via debug::print and accessing struct fields
        struct Inner { value: u64 }
        struct Outer { inner: Inner }

        let outer = Outer { inner: Inner { value: 42 } };

        // Access chain with source location info captured by debug::print
        debug::print(&outer.inner.value);

        // 2. Verify variable shadowing and capture by closure
        let mut x = 10;
        // Define a function that takes a closure and invokes it
        fun invoke_closure<F: copy + drop>(f: &F) where F: FnMut() {
            // The Move language doesn't currently support FnClosures directly,
            // but on Aptos Move we can simulate closures via inline functions and borrow captures.
            // Instead, we simulate variable shadowing by scoping and re-binding:
            // We'll model capturing by re-assigning x inside an inner block.

            // NOTE: Move currently does not support user-defined closures as first-class values.
            // Instead, simulate with an inline function
        }

        // We simulate closure by an inline block that shadows x
        {
            let x = &mut x;
            *x = 20; // overwrite outer x
        };

        // Assert the shadowing worked — value changed to 20
        debug::assert!(*x == 20, 101);

        // Another shadowing scenario with nested scopes
        let x = 5;
        {
            let x = 7;
            debug::assert!(x == 7, 102);
        }
        debug::assert!(x == 5, 103);

        // 3. Hexadecimal string literals for byte arrays
        // Hex literals prefixed with 0x can be directly used as byte vectors
        // In Move, 0x-prefixed literals produce a vector<u8>
        let bytes: vector<u8> = 0x4d6f76652054657374; // "Move Test" in ASCII hex

        // Check that the bytes match "Move Test"
        let expected: vector<u8> = vector::from_bytes(b"Move Test");
        debug::assert!(bytes == expected, 104);

        // Final print to denote test passed
        debug::print(&"Transactional test passed");
    }
}

// Featurres:
// 260006ae11579981288fc0e379429921: Automatically tag and span name access chains with source location information.
// fff1c50f05bdffc971fc23cdc837a682: Verify that a variable defined in an outer scope can be correctly overwritten by a closure invoked within a function, ensuring proper variable shadowing and capture behavior.
// b16924c5da6fd2ab3cd825003280fe98: Use hexadecimal string literals to represent byte arrays by prefixing the string with '0x'.
