// Transactional test for Aptos Move compiler and VM
// Tests: loop with immediate break, token presence, conditional unpack of fields

// #1: Module for loop with immediate break statement

//# publish
module 0x1::LoopTest {
    public fun runner() {
        let mut i = 0u8;
        while (i < 5u8) {
            i = i + 1;
            break;
        };
        // i should now be 1
    }
}

//# run 0x1::LoopTest::runner --signers 0x1

// #2: Module for checking if a specific token is present in a vector (acting as a token stream)

//# publish
module 0x2::TokenStreamTest {
    use std::option::{Option, some, none};

    public fun has_token(tokens: &vector<u8>, target: u8): bool {
        let len = vector::length(tokens);
        let mut i = 0;
        while (i < len) {
            if (*vector::borrow(tokens, i) == target) {
                return true;
            };
            i = i + 1;
        };
        false
    }

    // runner function for direct call
    public fun runner() {
        let tokens = vector[1u8, 2u8, 3u8, 10u8, 4u8];
        let present = Self::has_token(&tokens, 10u8); // should be true
        let absent = Self::has_token(&tokens, 9u8);   // should be false
        present;
        absent;
    }
}

//# run 0x2::TokenStreamTest::runner --signers 0x2

// #3: Module for conditional unpacking of fields, returning None if any fails

//# publish
module 0x3::ConditionalUnpack {

    use std::option::{Option, some, none};

    struct Foo has copy, drop, store {
        a: u8,
        b: u64,
        c: bool,
    }

    public fun try_unpack(foo_opt: Option<Foo>): Option<(u8, u64, bool)> {
        match foo_opt {
            some(foo) => {
                // destructure all fields - simulate possible failure (e.g., simulate Maybe error here)
                let Foo { a, b, c } = foo;
                // If c is true, succeed, else fail
                if (c) {
                    some((a, b, c))
                } else {
                    none()
                }
            },
            none => none()
        }
    }

    public fun runner() {
        let foo1 = some(Foo { a: 7, b: 99, c: true });
        let foo2 = some(Foo { a: 1, b: 2, c: false });
        let foo3 = none<Foo>();

        let res1 = Self::try_unpack(foo1); // should be Some
        let res2 = Self::try_unpack(foo2); // should be None
        let res3 = Self::try_unpack(foo3); // should be None
        res1;
        res2;
        res3;
    }
}

//# run 0x3::ConditionalUnpack::runner --signers 0x3