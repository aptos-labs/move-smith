//# publish
module 0xCAFE::NestedInline {
    use std::vector;

    // Inline function f2 returning a tuple
    public inline fun f2(a: u16): (u16, u16) {
        (a + 2, a + 3)
    }

    // Public function f1 that takes two parameters and returns u8, applies a loop and if
    public fun f1(x: u8, y: bool): u8 {
        if (y) {
            let _a = 1;
        } else {
            let _b = 2;
        };
        while (x < 20) {
            x = x + 1;
        };
        let z = x + 1;
        z
    }

    // Runner function that applies nested inline functions:
    // Applies f2 to 3, then passes the sum of the tuple as u8 and true to f1
    public fun nested_runner(): u8 {
        let (a, b) = f2(3u16);
        // sum the tuple elements as u8 safely by casting
        let sum = (a + b) as u8;
        f1(sum, true)
    }
}

// Since Move disallows duplicate or restricted aliases, this test will
// attempt to import a module with a duplicate alias which should error at compile time
// The transactional test runner should catch this error.

// The following lines are expected to cause a compile error and effectively test rule #2:

// Duplicate alias usage, should error: use 0xCAFE::NestedInline as NestedInline;
// Duplicate alias usage, should error: use 0xCAFE::NestedInline as NestedInline;

// Correct alias import
use 0xCAFE::NestedInline as NI;

//# run 0xCAFE::NestedInline::nested_runner


//# publish
module 0xCAFE::NativeWithEntry {
    use std::signer;

    // Native function marked as entry to allow transaction calls
    native public entry fun native_entry_add(s: signer, x: u64, y: u64): u64;

    // A runner that calls native_entry_add with arguments 10 and 20
    public fun run_add(s: signer): u64 {
        native_entry_add(s, 10, 20)
    }
}

//# run 0xCAFE::NativeWithEntry::run_add --signers 0xD00D

// Featurres:
// cc8c69755e71ae8b32b329d7d21583ea: Test that the nested inline functions in the module correctly compute the value by applying f2 to 3 and then passing the result to f1, resulting in the correct final output.
// f6a96d478f9d1f255049689e2ff3629c: Receive an error if you attempt to import a module or member using a restricted or duplicate alias name.
// 077541c853dad94d2381db12d33a4ad2: Mark native functions as 'entry' functions that can be invoked by transactions.
