module 0xCAFE::MatchAndVectorTest {
    use std::vector;

    // Define the enum E with variants V1, V2, V3
    // IMPORTANT: Move requires enums to be defined within the module
    // Enums are declared with the keyword 'enum'
    // Also, pattern matching must refer to the enum directly

    // Define enum E
    enum E {
        V1,
        V2 { x: u64, y: u64 },
        V3 { a: bool },
    }

    // Function to test pattern matching with variants and bindings
    public fun match_enum(e: E): u64 {
        // Match on the enum value
        match (e) {
            E::V1 => 1,
            E::V2(x, y) if (x + y > 10) => 2,
            E::V2(x, y) => 3,
            E::V3 { a } if (a) => 4,
            E::V3 { a } => 5,
        }
    }

    // Function to construct and return a vector of u8
    public fun create_vector(): vector<u8> {
        let vec: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut vec, 10);
        vector::push_back(&mut vec, 20);
        vector::push_back(&mut vec, 30);
        vec
    }

    // Inline recursive function that tries to call itself to create a cycle
    public inline fun recursive_inline_fun(n: u64): u64 {
        if (n == 0) {
            0
        } else {
            // Recursive inline call
            n + recursive_inline_fun(n - 1)
        }
    }

    // Function to call recursive_inline_fun to exercise inline function inlining and detect cycle
    public fun call_recursive(n: u64): u64 {
        recursive_inline_fun(n)
    }
}