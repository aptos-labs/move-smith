// # publish
module 0xCAFE::RefSafety {
    use std::signer;
    use std::vector;

    struct MyStruct has store {
        val: u64,
    }

    /// Create a MyStruct with val=42
    public fun create(): MyStruct {
        MyStruct { val: 42 }
    }

    /// Return a mutable reference to the val field
    public fun get_mut(s: &mut MyStruct): &mut u64 {
        &mut s.val
    }

    /// Return an immutable reference to the val field
    public fun get_imm(s: &MyStruct): &u64 {
        &s.val
    }

    /// Borrow MyStruct, modify val via mutable ref and return val
    /// This tests that mutable references are enforced by compiler and runtime
    public fun runner() {
        let mut s = create();
        let r = get_mut(&mut s);
        *r = 100;
        let i = get_imm(&s);
        assert!(*i == 100, 1);
    }
}
// # run 0xCAFE::RefSafety::runner

// # publish
module 0xCAFE::ModuleAccess {
    /// A simple module to test access by module::function syntax
    public fun add(a: u64, b: u64): u64 {
        a + b
    }

    public fun runner() {
        let sum = 0xCAFE::ModuleAccess::add(123, 456);
        assert!(sum == 579, 2);
    }
}
// # run 0xCAFE::ModuleAccess::runner

// # publish
module 0xCAFE::LexerAdvance {
    use std::vector;

    /// A very simple lexer advance function that consumes the first byte if matches given byte.
    /// Returns rest of vector if matched, else returns input vector.
    public fun advance_if_match(tokens: vector<u8>, expected: u8): vector<u8> {
        if (vector::is_empty(&tokens)) {
            return tokens;
        };
        let first = *vector::borrow(&tokens, 0);
        if (first == expected) {
            vector::pop_front(tokens)
        } else {
            tokens
        }
    }

    /// Runner to test advance_if_match removes matching token
    public fun runner() {
        let input1 = b"abc"; // [97,98,99]
        let input2 = b"xyz"; // [120,121,122]

        let output1 = advance_if_match(input1, 97);  // 'a' == 97
        assert!(vector::length(&output1) == 2 && *vector::borrow(&output1, 0) == 98, 3);

        let output2 = advance_if_match(input2, 97);  // 'a' != 'x' (120)
        assert!(vector::length(&output2) == 3 && *vector::borrow(&output2, 0) == 120, 4);
    }
}
// # run 0xCAFE::LexerAdvance::runner

// # run
script {
    use 0xCAFE::RefSafety;
    use 0xCAFE::ModuleAccess;
    use 0xCAFE::LexerAdvance;

    fun main() {
        // Testing direct call of runner functions from each module
        0xCAFE::RefSafety::runner();
        0xCAFE::ModuleAccess::runner();
        0xCAFE::LexerAdvance::runner();

        // Test reference safety: create a struct and get mutable and immutable refs
        let mut s = 0xCAFE::RefSafety::create();
        let r_mut = 0xCAFE::RefSafety::get_mut(&mut s);
        *r_mut = 555;
        let r_imm = 0xCAFE::RefSafety::get_imm(&s);
        // no assertion needed per instruction

        // Use module access add function in script
        let result = 0xCAFE::ModuleAccess::add(1, 2);
        // no assertion needed

        // Test lexer advance directly in script (optional)
        let tokens = b"hello";
        let advanced = 0xCAFE::LexerAdvance::advance_if_match(tokens, b'h'[0]);
        // no assertion needed
    }
}

// Featurres:
// 264e8d0df05ecc5243ec3f8eecb914f0: Enforce reference safety rules for Move references.
// 1d9212bf51cc0e7ef69dc6c4c961fef2: Access and use modules via module access syntax
// 339f6807b3336c0a4b88c2ccdb5128e1: Advance the lexer to consume the token if it matches
